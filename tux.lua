P = {}
tux = P

P._NAME = "tux"
P._VERSION = "0.0.1"

P._functions = {}

-- TODO: include `luapackageloader` package in this script

base64 = require "base64"

local wrappers = require "wrappers"
local utils = require "utils"


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


function P.usepackage(name)
    tex.print(wrappers.usepackage(name))
end


return P
