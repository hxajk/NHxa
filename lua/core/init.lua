-- Main core (extra stuffs)

local M = {}

M.notify = function(msg, type, opts)
    vim.schedule(function()
        vim.notify(msg, type, vim.tbl_deep_extend("force", { title = "3x3y3z" }, opts or {}))
    end)
end

M.is_available = function(plugin)
    local status, lazy = pcall(require, "lazy.core.config")
    return status and lazy.spec.plugins[plugin] ~= nil
end

M.create_file = function()
    local extension = vim.fn.input("Enter your file type e.g (.txt, .lua, ...): ")

    if extension == "" then
        print("No extension provided, operation cancelled.")
        return
    end

    local filename = "newfile" .. extension
    vim.cmd("e " .. filename)

    local filetype = vim.fn.fnamemodify(filename, ":e")
    vim.cmd("setlocal filetype=" .. filetype)

    print("Created file: " .. filename .. " with filetype: " .. filetype)
end

-- lualine

M.lsp_progress = function()
    local cur = vim.fn.line(".")
    local total = vim.fn.line("$")
    local spinners = { "", "", "" }

    if cur == 1 then
        return spinners[1]
    elseif cur == total then
        return spinners[3]
    else
        local ms = vim.loop.hrtime() / 1000000
        local frame = math.floor(ms / 120) % #spinners

        return string.format(" %%<%s %s%%%% ", spinners[frame + 1], math.floor(cur / total * 100))
    end
end

M.theme = function()
    -- -- Define the gruvbox color pallete
    -- local colors = {
    -- 	black = "#282828",
    -- 	white = "#ebdbb2",
    -- 	red = "#fb4934",
    -- 	green = "#b8bb26",
    -- 	blue = "#83a598",
    -- 	yellow = "#fe8019",
    -- 	gray = "#a89984",
    -- 	darkgray = "#3c3836",
    -- 	lightgray = "#504945",
    -- 	inactivegray = "#7c6f64",
    -- 	outerbg = "None",
    -- 	innerbg = "None",
    -- }

    -- Define the Catppuccin Frappé color palette
    local colors = {
        bg       = '#202328',
        fg       = '#bbc2cf',
        yellow   = '#ECBE7B',
        cyan     = '#008080',
        darkblue = '#081633',
        green    = '#98be65',
        orange   = '#FF8800',
        violet   = '#a9a1e1',
        magenta  = '#c678dd',
        blue     = '#51afef',
        red      = '#ec5f67',
    }
    return {
        normal = { c = { fg = colors.fg, bg = colors.bg } },
        inactive = { c = { fg = colors.fg, bg = colors.bg } },
    }
end
-- Icons

M.Icons = {
    -- AUTO COMPLETION --
    kinds = {
        Array = "",
        Boolean = "",
        Class = "",
        Color = "",
        Constant = "",
        Constructor = "",
        Enum = "",
        EnumMember = "",
        Event = "",
        Field = "",
        File = "",
        Folder = "󰉋",
        Function = "",
        Interface = "",
        Key = "",
        Keyword = "",
        Method = "",
        Module = "",
        Namespace = "",
        Null = "󰟢",
        Number = "",
        Object = "",
        Operator = "",
        Package = "",
        Property = "",
        Reference = "",
        Snippet = "",
        String = "",
        Struct = "",
        Text = "",
        TypeParameter = "",
        Unit = "",
        Value = "",
        Variable = "",
    },
    -- -- -- -- -- -- -- -- -- --

    -- Base Icon --

    base = {
        Buffer = "󰓩",
        Clock = "",
        DiagnosticError = "",
        DiagnosticHint = "󰌵",
        DiagnosticInfo = "󰋼",
        DiagnosticWarn = "",
        Flash = "⚡",
        Git = "󰊢",
        GitAdd = "▎",
        GitChange = "▎",
        GitChangeDelete = "▎",
        GitDelete = "",
        GitTopDelete = "",
        GitUnTracked = "▎",
        LSP = "",
        Message = "",
        Package = "",
        Selected = "❯",
        Session = "",
        Tab = "󰓩",
        Telescope = "",
        TelescopePrompt = "",
        Terminal = "",
        VBar = "│",
    },

    -- -- -- -- -- -- --
}

M.get_icon = function(kind, padding, enable) -- Later on...
    if not vim.g.icons_enabled and enable then
        return ""
    end

    local Base = M.Icons
    local icon = Base["base"] and Base["base"][kind]
    return icon and icon .. string.rep(" ", padding or 0) or ""
end

M.capabilities = function()
    require("cmp_nvim_lsp").default_capabilities()
end

M.on_attach = function(client, bufnr)
    local function map(mode, key, core, desc)
        vim.keymap.set(mode, key, core, { desc = desc, buffer = bufnr })
    end

    -- Using the custom map function

    map("n", "<leader>l", "<leader>l", "+" .. M.get_icon("LSP", 1, true) .. "LSP")

    map("n", "<leader>lh", vim.lsp.buf.signature_help, "Show signature help")

    map("n", "<leader>li", "<cmd>LspInfo<cr>", "Lsp Info")

    map("n", "<leader>lk", vim.lsp.buf.hover, "Hover")

    map("n", "[d", vim.diagnostic.goto_prev, "Previous Diagnostic")

    map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")

    map("n", "<leader>ln", vim.lsp.buf.rename, "Rename Varable")

    if client.supports_method("textDocument/formatting") then
        map({ "n", "v" }, "<leader>lf", vim.lsp.buf.format, "Format buffer")
    end
end
return M
