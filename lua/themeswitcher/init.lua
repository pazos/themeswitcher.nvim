local bundled_themes = {
    "blue", "darkblue", "default", "delek", "desert",
    "elflord", "evening", "habamax", "industry", "koehler",
    "lunaperche", "morning", "murphy", "pablo", "peachpuff",
    "quiet", "ron", "shine", "slate", "torte", "zellner"
}

local function idx(name, t)
    for i, v in ipairs(t) do
        if name == v then
            return i
        end
    end
    return 0
end

local function filter(t1, t2)
    local t = {}
    for _, v in ipairs(t1) do
        local match = false
        for _, name in ipairs(t2) do
            if v == name then
                match = true
                break
            end
        end
        if not match then
            table.insert(t, v)
        end
    end
    return t
end

local function append(t1, t2)
    local t = t1
    for _, v in ipairs(t2) do
        local match = false
        for _, name in ipairs(t1) do
            if v == name then
                match = true
            end
        end
        if not match then
            table.insert(t, v)
        end
    end
    return t
end

local function next(name, t)
    local index = idx(name, t)
    if index == #t then
        return t[1]
    else
        return t[index + 1]
    end
end

local function prev(name, t)
    local index = idx(name, t)
    if index <= 1 then
        return t[#t]
    else
        return t[index - 1]
    end
end

local function notify(message, error)
    local lvl = error and vim.log.levels.ERROR or vim.log.levels.INFO
    local msg = tostring(message)
    msg = string.format("\r%s%s", msg, string.rep(" ", vim.v.echospace - #msg))
    vim.notify(msg, lvl, {})
end

local manager = {}

function manager:setup(o)
    o = o or {}
    o.system = o.system or {}
    o.system.included = o.system.included or {}
    o.installed = o.installed or {}
    o.installed.excluded = o.installed.excluded or {}
    o.installed.included = o.installed.included or {}
    o.silent = o.silent or false

    local all = vim.fn.getcompletion("", "color")
    local themes
    if #o.installed.included > 1 then
        themes = append(o.installed.included, o.system.included)
    else
        themes = filter(all, bundled_themes)
        themes = filter(themes, o.installed.excluded)
        themes = append(themes, o.system.included)
    end

    self.themes = themes
    local colorscheme
    if type(o.colorscheme) == "string" then
        for _, v in ipairs(themes) do
            if v == o.colorscheme then
                colorscheme = o.colorscheme
                break
            end
        end
    end
    if colorscheme then
        self:set(colorscheme)
    end

    self.colorscheme = colorscheme or vim.api.nvim_exec("colorscheme", true)
end

function manager:next()
    self:set(next(self.colorscheme, self.themes))
    if not self.silent then
        vim.defer_fn(function() self:print() end, 20)
    end
end

function manager:prev()
    self:set(prev(self.colorscheme, self.themes))
    if not self.silent then
        vim.defer_fn(function() self:print() end, 20)
    end
end

function manager:print()
    local msg = string.format("\rtheme: %s", self.colorscheme)
    notify(msg)
end

function manager:set(name)
    self.colorscheme = name
    pcall(vim.cmd, "colorscheme " .. self.colorscheme)
end

local M = {}
function M.setup(o)
    manager.setup(manager, o)
    for _, v in ipairs({
        { "ThemeNext", function() pcall(manager.next, manager) end },
        { "ThemePrev", function() pcall(manager.prev, manager) end },
    }) do
        vim.api.nvim_create_user_command(v[1], v[2], { nargs = 0})
    end
end

return M
