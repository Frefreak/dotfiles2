local ls = require('luasnip')
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local extra = require('luasnip.extras')
local c = ls.choice_node

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
