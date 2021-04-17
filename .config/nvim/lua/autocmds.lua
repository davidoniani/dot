-- Access Nvim API
local api = vim.api

-- Allow for defining autocommands
function _G.augroups(definitions)
    for group_name, definition in pairs(definitions) do
        api.nvim_command("augroup " .. group_name)
        api.nvim_command("autocmd!")
        for _, def in ipairs(definition) do
            local command = table.concat(vim.tbl_flatten {"autocmd", def}, " ")
            api.nvim_command(command)
        end
        api.nvim_command("augroup END")
    end
end

-- Define all autocommands
local autocmds = {
    Design = {
        { "ColorScheme", "*", "hi! Comment cterm=italic, gui=italic" },
        { "ColorScheme", "*", "hi! Comment ctermfg=61, guifg=#5a699d" },
        { "ColorScheme", "*", "hi! LineNr ctermfg=237 guifg=#3c3c3c" },
        { "ColorScheme", "*", "hi! Normal ctermfg=233 guibg=#12131a" },
    },
    LuaHighlight = {
        { "TextYankPost", "*", "silent! lua vim.highlight.on_yank { }" }
    },
    TexClean = {
        { "VimLeave", "*.tex", ":!texclean" }
    }
}

-- Activate all autocommands
augroups(autocmds)
