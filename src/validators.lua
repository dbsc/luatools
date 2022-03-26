local M = {}


function M.validate_luavar_name(name)
    if not name:match('^[a-zA-Z%.]+$') then
        error(string.format("lua variable name '%s' not allowed"), name)
    end
end


function M.validate_texvar_name(name)
    if not name:match('^[a-zA-Z@]+$') then
        error(string.format("lua variable name '%s' not allowed"), name)
    end
end


function M.validate_texcmd_name(name)
    if not name:match('^[a-zA-Z@]+$') then
        error(string.format("command name %s not allowed", name))
    end
end


return M
