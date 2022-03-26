local M = {}


local function create_searcher(path)
    local function loadlib(file, name)
        print(file)
        if file:match("^.*%.lua$") then
            return loadfile(file)
        elseif file:match("^.*%.so$") then
            return package.loadlib(file, "luaopen_" .. name)
        end
    end

    local function searcher(name)
        local file, err = package.searchpath(name, path)
        if not err then
            return loadlib(file, name)
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
    local luasearcher = create_searcher(path)
    local cluasearcher = create_searcher(cpath)

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


function M.envpatch()
    M.patch(package.path, package.cpath)
end


return M
