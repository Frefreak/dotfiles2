local ls = require('luasnip')
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local extra = require('luasnip.extras')
local c = ls.choice_node
local fn = ls.function_node

ls.add_snippets('all', {
    s('she', {
        t('#!/usr/bin/env '),
        i(1),
        t{'', ''},
        i(2)
    }),
})

ls.add_snippets('python', {
    s('ipy', {
        t('import IPython; IPython.embed()'),
    }),
})

ls.add_snippets('all', {
    s('now', {
        fn(function()
            return vim.fn.strftime('%Y-%m-%d %H:%M:%S')
        end),
    }),
})

ls.add_snippets('all', {
    s('iso9601', {
        fn(function()
            return os.date('!%Y-%m-%dT%H:%M:%SZ')
        end),
    }),
})

