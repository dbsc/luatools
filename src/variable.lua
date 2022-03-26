local M = {}

local validators = require "validators"


function M.texname(name)
    local texname = name:gsub('%.', '@')
    local validator = function ()
        return validators.validate_texvar_name(texname)
    end

    if pcall(validator) then
        return texname
    else
        local fmt = "'%s' is not allowed as a tex variable name"
        error(fmt:format(name))
    end
end


function M.luaname(name)
    local luaname = name:gsub('@', '.')
    local validator = function ()
        return validators.validate_luavar_name(luaname)
    end

    if pcall(validator) then
        return luaname
    else
        local fmt = "'%s' is not allowed as a tex variable name"
        error(fmt:format(name))
    end
end


return M
