local P = {}
tux = P

P._NAME = "tux"
P._VERSION = "0.0.1"

P.variables = {}

base64 = require "base64"

local wrappers = require "wrappers"
local utils = require "utils"
local variable = require "variable"


local function function_string(_function)
    local encoded = base64.encode(string.dump(_function))
    return string.format([[load(base64.decode("%s"))]], encoded)
end


local function function_directlua(_function)
    local function mapper(i)
        local escaped = wrappers.luaescapestring('#' .. i)
        return string.format([["%s"]], escaped)
    end
    local range = utils.range(1, utils.function_nargs(_function))
    local args = table.concat(utils.map(mapper, range), ",")
    local fstring = function_string(_function)

    local fmt = "tex.print(%s(%s))"
    return wrappers.directlua(fmt:format(fstring, args))
end


function P.newcommand(name, action)
    local nargs = utils.function_nargs(action)
    local body = function_directlua(action)

    local texcode = wrappers.newcommand(name, body, nargs)
    tex.print(texcode)
end


function P.createvar(name)
    local luaname = variable.luaname(name)
    local texname = variable.texname(name)

    local readname = texname
    local writename = '@' .. texname

    local function read_action()
        return P.variables[luaname]
    end
    local function write_action(value)
        P.variables[luaname] = value
    end

    P.newcommand(readname, read_action)
    P.newcommand(writename, write_action)
end


pcall(function () require(tex.jobname) end)

return P
