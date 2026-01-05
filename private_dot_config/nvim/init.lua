-- vim: foldmethod=marker foldmarker={{{,}}}

-- lazy.nvim & mapleader {{{
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ','

require('lazy').setup("spec")

-- }}}

-- general settings {{{
vim.o.fileencodings = 'utf8,cp936,gb18030,big5'
vim.o.tabstop = 8
vim.o.softtabstop = 8
vim.o.shiftwidth = 8
vim.o.cursorline = true
vim.o.termguicolors = true
vim.o.inccommand = 'split'
vim.o.completeopt = 'menu,menuone,noselect'

vim.api.nvim_create_augroup('nvim.swapfile', { clear = true })

vim.api.nvim_create_autocmd('BufReadPost', {
    callback = function(ev)
        vim.fn.setpos('.', vim.fn.getpos("'\""))
    end
})

vim.fn.matchadd('ExtraWhitespace', "\\s\\+$")
vim.api.nvim_create_autocmd('InsertEnter', {
    callback = function()
        vim.api.nvim_set_hl(0, 'ExtraWhitespace', { ctermbg = 'NONE', bg = 'NONE' })
    end
})
vim.api.nvim_create_autocmd('InsertLeave', {
    callback = function()
        vim.api.nvim_set_hl(0, 'ExtraWhitespace', { ctermbg = 196, bg = '#FF5455' })
    end
})

vim.fn.matchadd('ColorColumn', "\\%81v", 100)

local web_file_types = {
    'html', 'xhtml', 'javascript', 'css', 'typescript', 'hamlet',
    'vue', 'wast', 'svelte'
}

vim.api.nvim_create_autocmd('Filetype', {
    pattern = web_file_types,
    callback = function()
        vim.fn.clearmatches()
        vim.bo.sw = 2
        vim.bo.ts = 2
        vim.bo.sts = 2
        vim.bo.expandtab = true
        vim.o.shiftround = true
    end
})

local tab2_expand_file_types = {
    'cabal', 'zsh', 'tex', 'plaintex', 'cpp', 'dart'
}
local tab4_expand_file_types = {
    'vim', 'vimwiki', 'python', 'haskell', 'lhaskell', 'cmake',
    'markdown', 'lua', 'groovy', 'php', 'nginx',
}
local tab4_noexpand_file_types = {
    'go',
}
local config_file_types = {
    'toml', 'yaml', 'json',
}

vim.api.nvim_create_autocmd('FileType', {
    pattern = tab2_expand_file_types,
    callback = function()
        vim.bo.sw = 2
        vim.bo.ts = 2
        vim.bo.sts = 2
        vim.bo.expandtab = true
    end
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = tab4_expand_file_types,
    callback = function()
        vim.bo.sw = 4
        vim.bo.ts = 4
        vim.bo.sts = 4
        vim.bo.expandtab = true
        vim.o.shiftround = true
    end
})
vim.api.nvim_create_autocmd('FileType', {
    pattern = tab4_noexpand_file_types,
    callback = function()
        vim.bo.sw = 4
        vim.bo.ts = 4
        vim.bo.sts = 4
    end
})
vim.api.nvim_create_autocmd('FileType', {
    pattern = config_file_types,
    callback = function()
        vim.bo.ts = 8
        vim.bo.sw = 2
        vim.bo.sts = 2
        vim.o.shiftround = true
    end
})
-- }}}

-- keymaps & command {{{
local map = vim.keymap.set

map('n', ':', ';')
map('n', ';', ':')

map('n', 'v', '<C-v>')
map('n', '<C-v>', 'v')
map('v', 'v', '<C-v>')
map('v', '<C-v>', 'v')

map('n', '<Down>', '5j')
map('n', '<Up>', '5k')
map('n', '<Left>', '5h')
map('n', '<Right>', '5l')

map('n', '<A-h>', '<C-w>h')
map('n', '<A-j>', '<C-w>j')
map('n', '<A-k>', '<C-w>k')
map('n', '<A-l>', '<C-w>l')

map('n', 'H', '^')
map('n', 'L', '$')
map('i', 'kj', '<Esc>')
map('c', 'kj', '<C-c>')

map('v', 'ty', '"+y')
map('n', 'tp', '"+p')

map('n', 'a9', 'v<esc>ea(<esc>A)<esc>gv<esc>')
map('c', 'w!!', 'w !sudo tee % > /dev/null')

map('n', '<leader>cc', ':ccl<CR>')
map('n', '<leader>lc', ':lcl<CR>')

vim.api.nvim_create_user_command(
  "ClearSpaces",
  "%s/ \\+$//",
  {}                      -- Options (empty = no args, no completion, etc.)
)
-- }}}

-- misc {{{
local os_name = vim.uv.os_uname().sysname
if os_name == 'Linux' then
    vim.g.python3_host_prog = '/usr/bin/python3'
elseif os_name == 'Darwin' then
    vim.g.python3_host_prog = '/opt/homebrew/bin/python3'
end

vim.api.nvim_set_hl(0, 'LspInlayHint', { fg = '#777777' })

vim.api.nvim_create_autocmd('BufReadCmd', {
    pattern = {'*.ehpk'},
    callback = function()
        vim.fn["zip#Browse"](vim.fn.expand('<amatch>'))
    end
})
-- }}}

-- further lua config {{{
require('setup')
-- }}}
