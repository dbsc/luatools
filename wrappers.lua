local M = {}

local validators = require "validators"


function M.newcommand(name, body, nargs, default)
    validators.validate_command_name(name)
    nargs = nargs or 0

    local fmt, str
    if default == nil then
        fmt = [[\newcommand{\%s}[%d]{%s}]]
        str = fmt:format(name, nargs, body)
    else
        fmt = [[\newcommand{\%s}[%d][%s]{%s}]]
        str = fmt:format(name, nargs, default, body)
    end

    return str
end


function M.directlua(str)
    local fmt = [[\directlua{%s}]]
    return fmt:format(str)
end


function M.luaescapestring(str)
    local fmt = [[\luaescapestring{%s}]]
    return fmt:format(str)
end


return M
