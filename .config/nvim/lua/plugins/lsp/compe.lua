-- Access Nvim API and functions
local api = vim.api
local fn  = vim.fn

-- Set up `nvim-compe`
require("compe").setup {
    enabled          = true,
    autocomplete     = true,
    debug            = false,
    min_length       = 1,
    preselect        = "enable",
    throttle_time    = 80,
    source_timeout   = 200,
    incomplete_delay = 400,
    max_abbr_width   = 100,
    max_kind_width   = 100,
    max_menu_width   = 100,
    documentation    = true,

    source = {
        calc       = true,
        nvim_lsp   = true,
        nvim_lua   = true,
        path       = true,
        tags       = false,
        treesitter = true,
        vsnip      = false,
        ultisnips  = true,
        buffer     = { menu = " Buffer" },
        spell      = { menu = " Spell" }
    }
}

-- Replace term codes
local t = function(str)
  return api.nvim_replace_termcodes(str, true, true, true)
end

-- Check a back space
local check_back_space = function()
    local col = fn.col(".") - 1
    if col == 0 or fn.getline("."):sub(col, col):match("%s") then
        return true
    end
    return false
end

-- Use <C-n>/<Tab> to:
--     * Move to next item in completion menuone
--     * Jump to next snippet's placeholder
_G.tab_complete = function()
    if fn.pumvisible() == 1 then
        return t("<C-n>")
    end
    if fn.call("vsnip#available", {1}) == 1 then
        return t("<Plug>(vsnip-expand-or-jump)")
    end
    if check_back_space() then
        return t("<Tab>")
    end
    return fn['compe#complete']()
end

-- Use <C-p>/<S-Tab> to:
--     * Move to previous item in completion menuone
--     * Jump to previous snippet's placeholder
_G.s_tab_complete = function()
    if fn.pumvisible() == 1 then
        return t("<C-p>")
    end
    if fn.call("vsnip#jumpable", {-1}) == 1 then
        return t("<Plug>(vsnip-jump-prev)")
    end
    return t("<S-Tab>")
end

-- Mapping options
local opts = { expr = true }

-- Set up the mappings
api.nvim_set_keymap("i", "<Tab>",   "v:lua.tab_complete()",   opts)
api.nvim_set_keymap("s", "<Tab>",   "v:lua.tab_complete()",   opts)
api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", opts)
api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", opts)
