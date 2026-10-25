#!/usr/bin/python
import html
import json
import time
from collections import deque
from pathlib import Path


BARS = '▁▂▃▄▅▆▇█'
SAMPLES = 8
INTERVAL = 2


def cpu_counters():
    values = list(map(int, Path('/proc/stat').read_text().splitlines()[0]
                      .split()[1:9]))
    return sum(values), values[3] + values[4]


def memory_usage():
    fields = dict(line.split(':', 1)
                  for line in Path('/proc/meminfo').read_text().splitlines())
    total = int(fields['MemTotal'].split()[0])
    used = total - int(fields['MemAvailable'].split()[0])
    return used / total * 100, used / 1048576, total / 1048576


def network_counters():
    routes = []
    for line in Path('/proc/net/route').read_text().splitlines()[1:]:
        fields = line.split()
        if fields[1] == '00000000' and int(fields[3], 16) & 1:
            routes.append((int(fields[6]), fields[0]))
    if not routes:
        return None
    interface = min(routes)[1]
    for line in Path('/proc/net/dev').read_text().splitlines()[2:]:
        name, counters = line.split(':', 1)
        if name.strip() == interface:
            values = list(map(int, counters.split()))
            return interface, values[0], values[8]
    return None


def graph(values, ceiling=100):
    return ''.join(BARS[round(min(max(value / ceiling, 0), 1) * 7)]
                   for value in values)


def rate(value):
    for unit in ['B/s', 'KiB/s', 'MiB/s', 'GiB/s']:
        if value < 1024 or unit == 'GiB/s':
            return f'{value:.1f} {unit}'
        value /= 1024


def main():
    histories = [deque([0] * SAMPLES, maxlen=SAMPLES) for _ in range(4)]
    cpu_history, ram_history, rx_history, tx_history = histories
    previous_cpu = cpu_counters()
    previous_net = network_counters()
    previous_time = time.monotonic()
    while True:
        time.sleep(INTERVAL)
        now = time.monotonic()
        cpu = cpu_counters()
        net = network_counters()
        elapsed = now - previous_time
        total = cpu[0] - previous_cpu[0]
        idle = cpu[1] - previous_cpu[1]
        usage = max(0, min(100, (total - idle) / max(total, 1) * 100))
        ram, used, capacity = memory_usage()
        cpu_history.append(usage)
        ram_history.append(ram)
        rx = tx = 0
        if net and previous_net and net[0] == previous_net[0]:
            rx = max(0, net[1] - previous_net[1]) / elapsed
            tx = max(0, net[2] - previous_net[2]) / elapsed
        else:
            rx_history.clear()
            tx_history.clear()
            rx_history.extend([0] * SAMPLES)
            tx_history.extend([0] * SAMPLES)
        rx_history.append(rx)
        tx_history.append(tx)
        ceiling = max(1024, *rx_history, *tx_history)
        network = (f'↓{graph(rx_history, ceiling)} '
                   f'↑{graph(tx_history, ceiling)}') if net else 'NET —'
        text = (f'CPU {graph(cpu_history)}  RAM {graph(ram_history)}  '
                f'<span foreground="#c4b0fa">{network}</span>')
        tooltip = (f'CPU: {usage:.0f}%\n'
                   f'RAM: {ram:.0f}% ({used:.1f} / {capacity:.1f} GiB)\n')
        if net:
            tooltip += (f'{html.escape(net[0])}: ↓ {rate(rx)}  ↑ {rate(tx)}\n'
                        f'Network graph scale: {rate(ceiling)}\n')
        else:
            tooltip += 'No IPv4 default route\n'
        tooltip += 'History: 16 seconds; CPU/RAM scale: 0–100%'
        print(json.dumps({'text': text, 'tooltip': tooltip}), flush=True)
        previous_cpu, previous_net, previous_time = cpu, net, now


if __name__ == '__main__':
    try:
        main()
    except (BrokenPipeError, KeyboardInterrupt):
        pass
