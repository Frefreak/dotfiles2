local spec = {
    {
        'dracula/vim',
        name = 'dracula',
        config = function()
            vim.cmd("color dracula")
        end
    },
    -- {
    --     "zbirenbaum/copilot.lua",
    --     cmd = "Copilot",
    --     event = "InsertEnter",
    --     config = function()
    --         require("copilot").setup({
    --             suggestion = {
    --                 auto_trigger = true,
    --                 keymap = {
    --                     accept = "<M-k>",
    --                     accept_line = "<M-l>",
    --                 },
    --             }
    --         })
    --         vim.api.nvim_create_autocmd("User", {
    --             pattern = "BlinkCmpMenuOpen",
    --             callback = function()
    --                 vim.b.copilot_suggestion_hidden = true
    --             end,
    --         })

    --         vim.api.nvim_create_autocmd("User", {
    --             pattern = "BlinkCmpMenuClose",
    --             callback = function()
    --                 vim.b.copilot_suggestion_hidden = false
    --             end,
    --         })
    --     end,
    --     cond = not vim.g.vscode,
    -- },
    {
        'nvim-flutter/flutter-tools.nvim',
        ft = { 'dart' },
    },
    {
        'echasnovski/mini.ai',
        config = function()
            require('mini.ai').setup({ search_method = "cover_or_nearest" })
        end
    },
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function() require("nvim-surround").setup({}) end
    },
    { 'Frefreak/gdscript-indent', ft = { 'gdscript' } },
    'roxma/vim-tmux-clipboard', {
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
    ft = { 'markdown', 'vimwiki.markdown' }
},
    {
        'mattn/emmet-vim',
        ft = { 'html', 'javascript', 'php', 'css', 'vue', 'xml', 'svelte' }
    }, {
    'norcalli/nvim-colorizer.lua',
    config = function() require('colorizer').setup() end,
    ft = { 'css', 'html', 'svelte', 'js' }
}, {
    -- 'ggandor/leap.nvim',
    url = 'https://codeberg.org/andyg/leap.nvim.git',
    dependencies = { 'tpope/vim-repeat' },
    config = function()
        vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')
        vim.keymap.set({ 'n', 'x', 'o' }, 'S', '<Plug>(leap-from-window)')
        local leap = require('leap')
        leap.opts.vim_opts['go.ignorecase'] = true
        leap.opts.vim_opts['go.smartcase'] = true
    end
}, {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    version = "v2.*",
    build = "make install_jsregexp",
    config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
    end,
    opts = {
        snippets = { preset = 'luasnip' },
        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
        },
    }
}, { 'tpope/vim-fugitive',    cmd = { "Git" } }, {
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
    end,
    keys = {
        { '<A-/>', ':CommentToggle<CR>' },
        { '<A-/>', ':CommentToggle<CR>', mode = 'v' },
    }
},
    {
        "SmiteshP/nvim-navic",
        dependencies = { "neovim/nvim-lspconfig" },
        config = function()
            local navic = require('nvim-navic')
            navic.setup { lsp = { auto_attach = true } }
        end
    },
    {
        'hoob3rt/lualine.nvim',
        dependencies = { { 'kyazdani42/nvim-web-devicons', optional = true } },
        config = function()
            require('lualine').setup({
                options = { theme = 'dracula' },
                sections = {
                    lualine_c = {
                        'filename', {
                        function() return require('nvim-navic').get_location() end,
                        cond = function() return require('nvim-navic').is_available() end
                    }
                    }
                }
            })
        end
    },
    {
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
    },
    { 'j-hui/fidget.nvim',   config = function() require('fidget').setup() end },
    -- {
    --     'kyazdani42/nvim-tree.lua',
    --     dependencies = { 'kyazdani42/nvim-web-devicons' },
    --     config = function()
    --         require 'nvim-tree'.setup {
    --             update_focused_file = { enable = true },
    --             renderer = {
    --                 icons = {
    --                     show = {
    --                         git = false,
    --                         folder = true,
    --                         file = false,
    --                         folder_arrow = true
    --                     }
    --                 },
    --                 highlight_git = false
    --             }
    --         }
    --     end
    -- },
    {
        'stevearc/oil.nvim',
        opts = {},
        dependencies = { "nvim-tree/nvim-web-devicons" },
        lazy = false,
        config = function()
            require("oil").setup()
        end
    },

    {
        'neovim/nvim-lspconfig',
        cond = not vim.g.vscode,
    },

    {
        'saghen/blink.cmp',
        version = '1.*',
        opts = {
            keymap = {
                preset = 'enter',
                -- ['<Tab>'] = {
                --     function(cmp)
                --         if cmp.is_active() then
                --             return cmp.select_next()
                --         end
                --     end,
                --     'fallback',
                -- },
                ['<C-e>'] = {
                    function(cmp)
                        if cmp.is_active() then
                            return cmp.cancel()
                        end
                    end,
                    'fallback',
                },
                ['<C-J>'] = { 'snippet_forward', 'fallback' },
                ['<C-K>'] = { 'snippet_backward', 'fallback' },
                ['<A-D>'] = { 'show_documentation', 'hide_documentation', 'fallback' },
                ['<A-S>'] = { 'show_signature', 'hide_signature', 'fallback' },
            },

            appearance = {
                nerd_font_variant = 'mono'
            },
            signature = { enabled = true },

            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },

            snippets = {
                preset = 'luasnip'
            },

            fuzzy = { implementation = "prefer_rust_with_warning" }
        },
        opts_extend = { "sources.default" },
        cond = not vim.g.vscode,
    },

    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            vim.treesitter.language.register('markdown', { 'vimwiki.markdown' })
        end
    },
    'nvim-lua/plenary.nvim', {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
    },
    config = function()
        require('telescope').setup {}
        require('telescope').load_extension('fzf')
    end,
    keys = {
        { '<leader>ff', '<cmd>Telescope find_files<cr>' },
        { '<leader>fg', '<cmd>Telescope live_grep<cr>' },
        { '<leader>fb', '<cmd>Telescope buffers<cr>' },
        { '<leader>fh', '<cmd>Telescope help_tags<cr>' },
    }
}, { 'mrcjkb/rustaceanvim', ft = 'rust' },
    { 'kaarmu/typst.vim',    ft = 'typst',                                     lazy = false }, {
    "neovim/nvim-lspconfig",
    dependencies = {
        {
            "SmiteshP/nvim-navbuddy",
            dependencies = { "SmiteshP/nvim-navic", "MunifTanjim/nui.nvim" },
            opts = { lsp = { auto_attach = true } },
        }
    }
}, { 'mfussenegger/nvim-dap' }, {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" }
},
    {
        'ggml-org/llama.vim',
        init = function()
            vim.g.llama_config = {
                n_prefix = 512,
                n_suffix = 512,
                n_predict = 128,
                t_max_prompt_ms = 1500,
                t_max_predict_ms = 1500,
                auto_fim = true,
                keymap_fim_accept_full = "<Tab>",
                keymap_fim_accept_line = "<A-l>",
                keymap_fim_accept_word = "<A-w>"
            }
        end,
        cond = function()
            return not vim.g.vscode
        end
    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('render-markdown').setup({
                file_types = { 'markdown', 'vimwiki.markdown' },
            })
        end,
        ft = { 'markdown' },
        cond = function()
            return not vim.g.vscode
        end
    },
    {
        "NeogitOrg/neogit",
        lazy = true,
        dependencies = {
            "nvim-lua/plenary.nvim", -- required
            "sindrets/diffview.nvim",
            "nvim-telescope/telescope.nvim",
        },
        cmd = "Neogit",
        keys = {
            { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" }
        }
    },
    {
        dir = "~/neollm/",
        opts = {
            pre = function()
                require('bufferline').setup({
                    options = { auto_toggle_bufferline = false }
                })
                vim.opt.showtabline = 0
            end
        }
    }
}

return spec
