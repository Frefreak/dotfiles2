-- custom stuffs
function TmuxRedo()
    vim.fn.system('tmux lastp')
    vim.fn.system('tmux send-keys up enter')
    vim.fn.system('tmux lastp')
end

local map = vim.keymap.set
map('n', '<leader>re', TmuxRedo)

-- bufferline
map('n', ']b', ':BufferLineCycleNext<CR>')
map('n', '[b', ':BufferLineCyclePrev<CR>')
map('n', '<leader>>', ':BufferLineMoveNext<CR>')
map('n', '<leader><', ':BufferLineMovePrev<CR>')
map('n', '<leader>p', ':BufferLinePick<CR>')

-- nvim-tree
-- function ChangeToParentDir()
--     local folder = vim.fn.expand('%:p:h')
--     vim.fn.chdir(folder)
--     local hostname = vim.fn.hostname()
--     local cwd = vim.uv.cwd()
--     vim.fn.printf('\x1b]7;file://%s%s\x07', hostname, cwd)
--     print("dir changed to " .. folder)
-- end

-- map('n', '<C-n>', ':NvimTreeToggle<CR>')
-- map('n', '<leader>op', ':NvimTreeFindFileToggle!<CR>')
-- map('n', '<leader>cp', ChangeToParentDir)

-- use ESC to turn off search highlighting
map("n", "<C-c>", ":noh<CR>")

if not vim.g.vscode then
    vim.lsp.inlay_hint.enable()
end

local servers = {
    'ruff', 'ts_ls', 'gopls', 'lua_ls', 'hls', 'tinymist', 'zls', 'glasgow',
    'svelte', 'pyright', 'yamlls', 'clangd', 'tailwindcss'
}
for _, svr in ipairs(servers) do vim.lsp.enable(svr) end

local add_lsp_keymap = function()
    if vim.g.vscode then
        map('n', 'gd', function()
            require('vscode').action('editor.action.revealDefinition')
        end)
        map('n', ']d', function()
            require('vscode').action('editor.action.marker.next')
        end)
        map('n', '[d', function()
            require('vscode').action('editor.action.marker.prev')
        end)
        map('n', '<leader>gf', function()
            require('vscode').action('editor.action.formatDocument')
        end)
    else
        map('n', 'gd', vim.lsp.buf.definition)
        map('n', 'gD', vim.lsp.buf.declaration)
        map('n', '<leader>gf', function() vim.lsp.buf.format({ async = false }) end)
        map('n', ']d', vim.diagnostic.goto_next)
        map('n', '[d', vim.diagnostic.goto_prev)
        map('n', '<leader>q', vim.diagnostic.setloclist)
    end
end

add_lsp_keymap()

-- dart
if not vim.g.vscode then
    require('flutter-tools').setup {}
end

-- golang
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
        local params = vim.lsp.util.make_range_params(0, 'utf-16')
        params.context = { only = { "source.organizeImports" } }

        local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
        for cid, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
                if r.edit then
                    local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                    vim.lsp.util.apply_workspace_edit(r.edit, enc)
                end
            end
        end
        vim.lsp.buf.format({ async = false })
    end
})

-- rust
vim.lsp.config('rust-analyzer', {
    on_attach = function()
        map('n', '<leader>rd', ":RustLsp externalDocs<CR>")
        map('n', '<leader>em', ":RustLsp expandMacro<CR>")
        map('n', '<leader>oc', ":RustLsp openCargo<CR>")
        map('n', '<leader>ld', ":RustLsp debuggables<CR>")
        map('n', '<leader>lr', ":RustLsp runnables<CR>")
    end
})

-- treesitter
local ts_config = require('nvim-treesitter.configs')
ts_config.setup {
    highlight = {
        enable = true,
        use_languagetree = true,
        additional_vim_regex_highlighting = true
    },
    -- indent = {enable = true}
}

-- navbuddy
map('n', '<leader>b', ':Navbuddy<CR>')

-- workaround
for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
    local default_diagnostic_handler = vim.lsp.handlers[method]
    vim.lsp.handlers[method] = function(err, result, context, config)
        if err ~= nil and err.code == -32802 then return end
        return default_diagnostic_handler(err, result, context, config)
    end
end

-- dap
local dap = require('dap')

map('n', '<F5>', ':DapContinue<CR>')
map('n', '<F9>', ':DapToggleBreakpoint<CR>')
map('n', '<F10>', ':DapStepOver<CR>')
map('n', '<F11>', ':DapStepInto<CR>')
map('n', '<F12>', ':DapStepOut<CR>')

require("dapui").setup()

map('n', '<leader>sd', require('dapui').open)
map('n', '<leader>ed', require('dapui').close)

local dapui = require("dapui")
dap.listeners.after.event_initialized["dapui_config"] =
    function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] =
    function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

-- llama.vim
vim.api.nvim_set_hl(0, "llama_hl_hint", { fg = "#f8732e", ctermfg = 209 })
vim.api.nvim_set_hl(0, "llama_hl_info", { fg = "#50fa7b", ctermfg = 119 })

function ToggleLlamaAutoFIM()
    local config = vim.g.llama_config
    config.auto_fim = not config.auto_fim
    vim.g.llama_config = config
    vim.fn["llama#init"]()
end

map('n', '<leader>af', ToggleLlamaAutoFIM)

-- luasnip
local ls = require('luasnip')
vim.keymap.set({ "i" }, "<C-E>", function() ls.expand() end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-J>", function() ls.jump(1) end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-K>", function() ls.jump(-1) end, { silent = true })
vim.keymap.set({ "i", "s" }, "<A-n>", function()
    if ls.choice_active() then
        ls.change_choice(1)
    end
end, { silent = true })
require('snippets')

-- oil
local oil = require('oil')
function OpenCurrent()
    local curr = oil.get_current_dir(0)
    oil.open(curr)
end
function OpenCurrentFloat()
    local curr = oil.get_current_dir(0)
    oil.open_float(curr)
end

map('n', '<C-n><C-n>', OpenCurrent)
map('n', '<C-n><C-f>', OpenCurrentFloat)


-- term

map('t', 'kj', '<C-\\><C-n>')

vim.api.nvim_create_autocmd("WinEnter", {
    pattern = "term://*",
    callback = function()
        local buf = vim.api.nvim_get_current_buf()
        local line_count = vim.api.nvim_buf_line_count(buf)
        local row = vim.api.nvim_win_get_cursor(0)[1]

        -- If you are already on the last line of the buffer, just enter Insert mode.
        if row >= line_count then
            vim.cmd("startinsert")
            return
        end

        -- Get all lines after the current cursor position.
        -- nvim_buf_get_lines is 0-indexed, so 'row' points to the line after 'row'.
        local trailing_lines = vim.api.nvim_buf_get_lines(buf, row, -1, false)
        local is_at_end = true

        for _, line in ipairs(trailing_lines) do
            -- Check if the line contains any non-whitespace character (%S).
            if line:find("%S") then
                is_at_end = false
                break
            end
        end

        if is_at_end then
            vim.cmd("startinsert")
        end
    end,
})

-- neogit
map('n', '<leader>dq', ':DiffviewClose<CR>')
