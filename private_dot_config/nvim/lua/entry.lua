local M = {}

M = {
    -- {
    --     "zbirenbaum/copilot.lua",
    --     cmd = "Copilot",
    --     event = "InsertEnter",
    --     config = function()
    --         require("copilot").setup({ filetypes = { gitcommit = true } })
    --     end
    -- },
    {
        'echasnovski/mini.ai',
        config = function()
            require('mini.ai').setup({
                search_method = "cover_or_nearest",
            })
        end
    },
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({})
        end
    },
    { 'ray-x/go.nvim',            ft = { 'go' } },
    'vim-scripts/LargeFile', { 'Frefreak/gdscript-indent', ft = { 'gdscript' } },
    { 'dracula/vim',              as = 'dracula' }, 'roxma/vim-tmux-clipboard', {
    'vimwiki/vimwiki',
    branch = 'dev',
    init = function()
        vim.g.vimwiki_list = {
            {
                path = '~/vimwiki/',
                index = 'index',
                ext = '.md',
                custom_wiki2html = 'vimwiki_markdown',
                syntax = 'markdown'
            }
        }
        -- vim.g.vimwiki_global_ext = 0
        vim.g.vimwiki_filetypes = { 'markdown' }
    end,
    ft = { 'markdown', 'vimwiki.markdown' },
}, {
    'mattn/emmet-vim',
    ft = { 'html', 'javascript', 'php', 'css', 'vue', 'xml', 'svelte' }
}, {
    'norcalli/nvim-colorizer.lua',
    config = function() require('colorizer').setup() end,
    ft = { 'css', 'html', 'svelte', 'js' }
},
    'ggandor/leap.nvim', {
    'SirVer/ultisnips',
    init = function()
        vim.g.UltiSnipsEditSplit = "vertical"
        vim.g.UltiSnipsExpandTrigger = "<C-e>"
        vim.g.UltiSnipsListSnippets = "<C-l>"
        vim.api.nvim_command(
            'set runtimepath+=~/.local/share/nvim/lazy/vim-snippets')
    end
}, 'honza/vim-snippets', { 'tpope/vim-fugitive', cmd = { "Git" } }, {
    'lervag/vimtex',
    ft = 'tex',
    config = function()
        vim.g.vimtex_compiler_method = 'tectonic'
        vim.opt.conceallevel = 1
        vim.g.tex_conceal = 'abdmgs'
    end
}, {
    'terrortylor/nvim-comment',
    cmd = 'CommentToggle',
    config = function()
        require('nvim_comment').setup({ comment_empty = false })
    end
}, { "SmiteshP/nvim-navic", dependencies = { "neovim/nvim-lspconfig" } }, {
    'hoob3rt/lualine.nvim',
    dependencies = { { 'kyazdani42/nvim-web-devicons', optional = true } },
    config = function()
        require('lualine').setup({ options = { theme = 'dracula' } })
    end
}, {
    'akinsho/bufferline.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    config = function()
        require('bufferline').setup({
            options = {
                diagnostics = 'nvim_lsp',
                separator_style = "slant",
                always_show_bufferline = false,
                hover = { enabled = true, delay = 0, reveal = { 'close' } },
                diagnostics_indicator = function(count, level)
                    local icon = level:match("error") and " " or " "
                    return " " .. icon .. count
                end
            }
        })
    end
}, { 'j-hui/fidget.nvim',            config = function() require('fidget').setup() end },
    {
        'kyazdani42/nvim-tree.lua',
        dependencies = { 'kyazdani42/nvim-web-devicons' },
        config = function()
            require 'nvim-tree'.setup {
                update_focused_file = { enable = true },
                renderer = {
                    icons = {
                        show = {
                            git = false,
                            folder = true,
                            file = false,
                            folder_arrow = true
                        }
                    },
                    highlight_git = false
                }
            }
        end
    }, 'neovim/nvim-lspconfig', {
    'yioneko/nvim-cmp',
    branch = 'perf',
    dependencies = { 'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer' }
}, 'hrsh7th/cmp-path', 'hrsh7th/cmp-nvim-lua',
    'Frefreak/cmp-nvim-ultisnips', 'onsails/lspkind-nvim', {
    "ray-x/lsp_signature.nvim",
    config = function() require('lsp_signature').setup() end
}, { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    'nvim-lua/plenary.nvim', {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
    },
    init = function()
        vim.treesitter.language.register('markdown', { 'vimwiki.markdown' })
    end
}, { 'mrcjkb/rustaceanvim', ft = 'rust' },
    { 'kaarmu/typst.vim',    ft = 'typst', lazy = false }, {
    "neovim/nvim-lspconfig",
    dependencies = {
        {
            "SmiteshP/nvim-navbuddy",
            dependencies = { "SmiteshP/nvim-navic", "MunifTanjim/nui.nvim" },
            opts = { lsp = { auto_attach = true } }
        }
    }
}, { 'mfussenegger/nvim-dap' }, {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" }
}, {
    'ggml-org/llama.vim',
    init = function()
        vim.g.llama_config = {
            n_prefix = 512,
            n_suffix = 512,
            n_predict = 128,
            t_max_prompt_ms = 1500,
            t_max_predict_ms = 1500,
            auto_fim = false,
            keymap_accept_full = "<Tab>",
            keymap_accept_line = "<A-l>",
            keymap_accept_word = "<A-w>",
        }
    end,
}
}

return M
