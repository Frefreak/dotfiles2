#!/usr/bin/python
import fcntl
import json
import os
import socket
import sys
from collections import defaultdict
from pathlib import Path


class WidthPolicy:
    def __init__(self):
        self.membership = None
        self.expanded = set()

    def update(self, windows):
        groups = defaultdict(list)
        for window in windows:
            workspace = window['workspace_id']
            if workspace is not None and not window['is_floating']:
                groups[workspace].append(window['id'])
        membership = frozenset((workspace, tuple(sorted(ids)))
                               for workspace, ids in groups.items())
        if membership == self.membership:
            return []
        self.membership = membership
        actions = []
        singletons = set()
        for ids in groups.values():
            if len(ids) == 1:
                window_id = ids[0]
                singletons.add(window_id)
                if window_id not in self.expanded:
                    actions.append((window_id, 100))
            else:
                actions.extend((window_id, 50) for window_id in ids
                               if window_id in self.expanded)
        floating = {w['id'] for w in windows if w['is_floating']}
        self.expanded = singletons | (self.expanded & floating)
        return actions

    def failed(self, window_id, width):
        self.membership = None
        if width == 100:
            self.expanded.discard(window_id)
        else:
            self.expanded.add(window_id)


def request(path, message):
    with socket.socket(socket.AF_UNIX) as connection:
        connection.settimeout(2)
        connection.connect(path)
        connection.sendall(json.dumps(message).encode() + b'\n')
        with connection.makefile('rb') as stream:
            reply = json.loads(stream.readline())
    if 'Err' in reply:
        raise RuntimeError(reply['Err'])
    return reply['Ok']


def main():
    path = os.environ['NIRI_SOCKET']
    lock_path = Path(os.environ['XDG_RUNTIME_DIR']) / 'niri-auto-width.lock'
    with lock_path.open('w') as lock:
        try:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            return
        policy = WidthPolicy()
        with socket.socket(socket.AF_UNIX) as connection:
            connection.connect(path)
            connection.sendall(b'"EventStream"\n')
            with connection.makefile('rb') as stream:
                for line in stream:
                    event = json.loads(line)
                    if not event.keys() & {
                        'WindowsChanged', 'WindowOpenedOrChanged',
                        'WindowClosed', 'WindowLayoutsChanged'
                    }:
                        continue
                    windows = request(path, 'Windows')['Windows']
                    for window_id, width in policy.update(windows):
                        action = {'Action': {'SetWindowWidth': {
                            'id': window_id,
                            'change': {'SetProportion': width}
                        }}}
                        try:
                            request(path, action)
                        except RuntimeError as error:
                            policy.failed(window_id, width)
                            print(f'Window {window_id}: {error}',
                                  file=sys.stderr, flush=True)


if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        pass
