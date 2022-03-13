local M = {}


local function concat_paths(...)
    return table.concat({...}, ';')
end


local function create_searcher(...)
    local path = concat_paths(...)

    local function searcher(name)
        local file, err = package.searchpath(name, path)
        if not err then
            return loadfile(file)
        end
    end

    return searcher
end


local function concat_searchers(...)
    local searchers = table.pack(...)

    local function master_searcher(name)
        local errmsgs = {}
        local loader
        for _, searcher in ipairs(searchers) do
            loader = searcher(name)
            if type(loader) ~= "string" then
                return loader
            else
                table.insert(errmsgs, loader)
            end
        end
        return table.concat(errmsgs, '\n')
    end

    return master_searcher
end


function M.patch(path, cpath)
    local luasearcher = create_searcher(package.path, path)
    local cluasearcher = create_searcher(package.cpath, cpath)

    package.searchers[2] = concat_searchers(package.searchers[2], luasearcher)
    package.searchers[3] = concat_searchers(package.searchers[3], cluasearcher)
end


function M.dirpatch(dir)
    if dir:sub(-1) ~= '/' then
        dir = dir .. '/'
    end

    local path = dir .. '?.lua;' .. dir .. '?/init.lua'
    local cpath = dir .. '?.so'

    M.patch(path, cpath)
end


return M
