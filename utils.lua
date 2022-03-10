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
    local output = file:read('a')
    local _, _, return_code = file:close()

    return {
        output,
        return_code
    }
end


return M
