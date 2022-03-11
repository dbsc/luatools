local M = {}


function M.validate_command_name(name)
    if not name:match('^[a-zA-Z@]+$') then
        error(string.format("command name %s not allowed", name))
    end
end


return M
