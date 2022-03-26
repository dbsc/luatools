local M = {}


function M.range(n, m)
    local range = {}
    for i = n, m do
        table.insert(range, i)
    end
    return range
end


function M.map(_function, iterable)
    local mapped = {}
    for _, element in ipairs(iterable) do
        table.insert(mapped, _function(element))
    end
    return mapped
end


function M.execute(cmd)
    local file = io.popen(cmd)
    local output = file:read("a")
    local _, _, return_code = file:close()

    return output, return_code
end


function M.iscallable(obj)
    local cond1 = type()
    local cond2 = (getmetatable(obj) or {}).__call
    return cond1 or cond2
end


function M.isfunction(obj)
    return type(obj) == "function"
end


function M.function_nargs(_function)
    if not M.isfunction(_function) then
        local fmt = "%s is not a function"
        error(fmt:format(tostring(_function)))
    end
    return debug.getinfo(_function).nparams
end


function M.function_address(_function)
    if not M.isfunction(_function) then
        local fmt = "%s is not a function"
        error(fmt:format(tostring(_function)))
    end
    return string.match(tostring(_function), "0x.*")
end


return M
