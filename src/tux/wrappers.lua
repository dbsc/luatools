local M = {}

local validators = require "tux.validators"


local function texcmd(cmd, args, nopts, pos)
    args = args or {}
    nopts = nopts or 0
    pos = pos or 1

    local str = string.format([[\%s]], cmd)
    for i, arg in ipairs(args) do
        if nopts > 0 and i >= pos then
            str = str .. string.format("[%s]", arg)
            nopts = nopts - 1
        else
            str = str .. string.format("{%s}", arg)
        end
    end

    return str
end


function M.newcommand(name, body, nargs, default)
    validators.validate_command_name(name)
    nargs = nargs or 0

    local args, nopts, pos
    if default == nil then
        args = {texcmd(name), nargs, body}
        nopts = 1
    else
        args = {texcmd(name), nargs, default, body}
        nopts = 2
    end
    pos = 2

    return texcmd("newcommand", args, nopts, pos)
end


function M.directlua(str)
    return texcmd("directlua", {str})
end


function M.luaescapestring(str)
    return texcmd("luaescapestring", {str})
end


function M.usepackage(str)
    return texcmd("usepackage", {str})
end


return M
