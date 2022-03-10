local M = {}

local validators = require "validators"


function M.newcommand(cmd, def, args, opt)
    validators.validate_command_name(cmd)
    args = args or 0

    local fmt, str
    if opt == nil then
        fmt = [[\newcommand{\%s}[%d]{%s}]]
        str = fmt:format(cmd, args, def)
    else
        fmt = [[\newcommand{\%s}[%d][%s]{%s}]]
        str = fmt:format(cmd, args, opt, def)
    end

    tex.print(str)
end


function M.directlua(str)
    local fmt = [[\directlua{%s}]]
    tex.print(fmt:format(str))
end


function M.luaescapestring(str)
    return [[\luaescapestring{str}]]
end


return M
