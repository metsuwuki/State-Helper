--[[
Open with encoding: UTF-8
StateHelper/core/paths.lua
]]

local paths = {}

local PROJECT_ROOT_DIR = rawget(_G, 'SH_PROJECT_ROOT_DIR_NAME') or 'StateHelper'
local LEGACY_DATA_DIR = rawget(_G, 'SH_LEGACY_DATA_DIR_NAME') or 'State Helper'
local ENTRY_SCRIPT_NAME = rawget(_G, 'SH_ENTRY_SCRIPT_NAME') or 'StateHelper.lua'

local function normalize(path)
    local value = tostring(path or ''):gsub('/', '\\')
    value = value:gsub('\\+', '\\')
    return value
end

function paths.sh_core_paths_join(...)
    local parts = { ... }
    local result = table.concat(parts, '\\')
    return normalize(result)
end

function paths.sh_core_paths_normalize(path)
    return normalize(path)
end

function paths.sh_core_paths_get_script_path()
    if type(thisScript) == 'function' then
        local ok, script = pcall(thisScript)
        if ok and script and script.path then
            return normalize(script.path)
        end
    end

    return nil
end

function paths.sh_core_paths_get_script_dir()
    local script_path = paths.sh_core_paths_get_script_path()
    if script_path then
        return script_path:match('^(.*)\\[^\\]+$')
    end

    if type(getWorkingDirectory) == 'function' then
        return normalize(getWorkingDirectory())
    end

    return '.'
end

function paths.sh_core_paths_get_project_root(base_dir)
    return paths.sh_core_paths_join(base_dir or paths.sh_core_paths_get_script_dir(), PROJECT_ROOT_DIR)
end

function paths.sh_core_paths_get_data_root(base_dir)
    return paths.sh_core_paths_join(base_dir or paths.sh_core_paths_get_script_dir(), LEGACY_DATA_DIR)
end

function paths.sh_core_paths_get_project_path(base_dir, ...)
    local parts = { ... }
    table.insert(parts, 1, paths.sh_core_paths_get_project_root(base_dir))
    return paths.sh_core_paths_join(unpack(parts))
end

function paths.sh_core_paths_get_data_path(base_dir, ...)
    local parts = { ... }
    table.insert(parts, 1, paths.sh_core_paths_get_data_root(base_dir))
    return paths.sh_core_paths_join(unpack(parts))
end

function paths.sh_core_paths_get_entry_path(base_dir)
    return paths.sh_core_paths_join(base_dir or paths.sh_core_paths_get_script_dir(), ENTRY_SCRIPT_NAME)
end

function paths.sh_core_paths_get_project_dir_name()
    return PROJECT_ROOT_DIR
end

function paths.sh_core_paths_get_data_dir_name()
    return LEGACY_DATA_DIR
end

return paths
