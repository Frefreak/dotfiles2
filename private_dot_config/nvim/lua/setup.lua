function Map(mode, lhs, rhs, opts)
    local options = {noremap = true, silent = true}
    if opts then options = vim.tbl_extend("force", options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- custom stuffs
function TmuxRedo()
    vim.fn.system('tmux lastp')
    vim.fn.system('tmux send-keys up enter')
    vim.fn.system('tmux lastp')
end

Map('n', '<leader>re', ':lua TmuxRedo()<CR>', {})

-- nvim-comment
Map('n', '<A-/>', ':CommentToggle<CR>', {})
Map('v', '<A-/>', ':CommentToggle<CR>', {})

-- bufferline
Map('n', ']b', ':BufferLineCycleNext<CR>', {})
Map('n', '[b', ':BufferLineCyclePrev<CR>', {})
Map('n', '<leader>>', ':BufferLineMoveNext<CR>', {})
Map('n', '<leader><', ':BufferLineMovePrev<CR>', {})

-- nvim-tree
function ChangeToParentDir()
    local folder = vim.fn.expand('%:p:h')
    vim.fn.chdir(folder)
    print("dir changed to " .. folder)
end

Map('n', '<C-n>', ':NvimTreeToggle<CR>', {})
Map('n', '<leader>op', ':NvimTreeFindFileToggle!<CR>', {})
Map('n', '<leader>cp', ':lua ChangeToParentDir()<CR>', {})

-- use ESC to turn off search highlighting
Map("n", "<C-c>", ":noh<CR>", {})

vim.lsp.inlay_hint.enable()

local servers = {
    'ruff', 'ts_ls', 'gopls', 'lua_ls', 'hls', 'tinymist', 'zls', 'glasgow',
    'svelte', 'pyright'
}
for _, svr in ipairs(servers) do vim.lsp.enable(svr) end

local add_lsp_keymap = function ()
        Map('n', 'gd', ":lua vim.lsp.buf.definition()<CR>", {})
        Map('n', 'gD', ":lua vim.lsp.buf.declaration()<CR>", {})
        Map('n', 'gf', ":lua vim.lsp.buf.format({async=false})<CR>", {})
        Map('n', ']d', ":lua vim.diagnostic.goto_next()<CR>", {})
        Map('n', '[d', ":lua vim.diagnostic.goto_prev()<CR>", {})
        Map('n', '<leader>q', ":lua vim.diagnostic.setloclist()<CR>", {})
end

vim.lsp.config('*', {
    on_attach = add_lsp_keymap,
})

-- golang
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
        local params = vim.lsp.util.make_range_params(0, 'utf-16')
        params.context = {only = {"source.organizeImports"}}

        local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
        for cid, res in pairs(result or {}) do
          for _, r in pairs(res.result or {}) do
            if r.edit then
              local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
              vim.lsp.util.apply_workspace_edit(r.edit, enc)
            end
          end
        end
        vim.lsp.buf.format({async = false})
      end
})

-- rust
vim.lsp.config('rust-analyzer', {
    on_attach = function()
        add_lsp_keymap()
        Map('n', '<leader>rd', ":RustLsp externalDocs<CR>", {})
        Map('n', '<leader>em', ":RustLsp expandMacro<CR>", {})
        Map('n', '<leader>oc', ":RustLsp openCargo<CR>", {})
        Map('n', '<leader>ld', ":RustLsp debuggables<CR>", {})
        Map('n', '<leader>lr', ":RustLsp runnables<CR>", {})
    end
})

vim.cmd('hi InLayHints guifg=#5a5c68')
vim.o.completeopt = 'menu,menuone,noselect'

local cmp = require 'cmp'
cmp.setup({
    snippet = {expand = function(args) vim.fn["UltiSnips#Anon"](args.body) end},
    mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false
        }),
        ['<Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end,
        ['<S-Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end
    },
    sources = {
        {name = 'nvim_lsp'}, {name = 'ultisnips'}, {name = 'buffer'},
        {name = 'path'}, {name = 'nvim_lua'}
    },
    formatting = {
        fields = {'abbr', 'kind', 'menu'},
        format = function(_, vim_item) return vim_item end
    }
})

-- lspkind
local lspkind = require('lspkind')
cmp.setup {formatting = {format = lspkind.cmp_format()}}

-- treesitter
local ts_config = require('nvim-treesitter.configs')
ts_config.setup {
    highlight = {
        enable = true,
        use_languagetree = true,
        additional_vim_regex_highlighting = true
    },
    indent = {enable = false}
}

-- telescope
require('telescope').setup {}
require('telescope').load_extension('fzf')

-- Find files using Telescope command-line sugar.
Map('n', '<leader>ff', '<cmd>Telescope find_files<cr>', {})
Map('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', {})
Map('n', '<leader>fb', '<cmd>Telescope buffers<cr>', {})
Map('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', {})

-- leap.nvim
require('leap').set_default_keymaps()

-- navic
local navic = require('nvim-navic')
navic.setup {lsp = {auto_attach = true}}

-- lualine
require("lualine").setup({
    sections = {
        lualine_c = {
            'filename', {
                function() return navic.get_location() end,
                cond = function() return navic.is_available() end
            }
        }
    }
})

-- navbuddy
Map('n', '<leader>b', ':Navbuddy<CR>', {})

-- workaround
for _, method in ipairs({'textDocument/diagnostic', 'workspace/diagnostic'}) do
    local default_diagnostic_handler = vim.lsp.handlers[method]
    vim.lsp.handlers[method] = function(err, result, context, config)
        if err ~= nil and err.code == -32802 then return end
        return default_diagnostic_handler(err, result, context, config)
    end
end

-- dap
local dap = require('dap')

Map('n', '<F5>', ':DapContinue<CR>', {})
Map('n', '<F9>', ':DapToggleBreakpoint<CR>', {})
Map('n', '<F10>', ':DapStepOver<CR>', {})
Map('n', '<F11>', ':DapStepInto<CR>', {})
Map('n', '<F12>', ':DapStepOut<CR>', {})

require("dapui").setup()

Map('n', '<leader>sd', ":lua require('dapui').open()<CR>", {})
Map('n', '<leader>ed', ":lua require('dapui').close()<CR>", {})

local dapui = require("dapui")
dap.listeners.after.event_initialized["dapui_config"] =
    function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] =
    function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

-- llama.vim
vim.api.nvim_set_hl(0, "llama_hl_hint", {fg = "#f8732e", ctermfg = 209})
vim.api.nvim_set_hl(0, "llama_hl_info", {fg = "#50fa7b", ctermfg = 119})

function ToggleLlamaAutoFIM()
    local config = vim.g.llama_config
    config.auto_fim = not config.auto_fim
    vim.g.llama_config = config
    vim.fn["llama#init"]()
end

vim.api.nvim_set_keymap('n', '<leader>af', ':lua ToggleLlamaAutoFIM()<CR>',
                        {noremap = true, silent = true})

-- render-markdown
require('render-markdown').setup({
    file_types = { 'markdown', 'vimwiki.markdown' },
})
