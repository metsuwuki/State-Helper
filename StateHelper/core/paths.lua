--[[
Open with encoding: UTF-8
StateHelper/core/paths.lua
]]

local paths = {}

local PROJECT_ROOT_DIR = rawget(_G, 'SH_PROJECT_ROOT_DIR_NAME') or 'StateHelper'
local LEGACY_DATA_DIR = rawget(_G, 'SH_LEGACY_DATA_DIR_NAME') or PROJECT_ROOT_DIR
local OLD_LEGACY_DATA_DIR = 'State Helper'
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

local function exists_dir(path)
    return type(doesDirectoryExist) == 'function' and doesDirectoryExist(path)
end

local function exists_file(path)
    return type(doesFileExist) == 'function' and doesFileExist(path)
end

local function ensure_dir(path)
    if not exists_dir(path) and type(createDirectory) == 'function' then
        createDirectory(path)
    end
end

local function remove_empty_dir(path)
    if not exists_dir(path) then
        return
    end

    local ok_lfs, lfs = pcall(require, 'lfs')
    if ok_lfs and lfs and lfs.rmdir then
        pcall(lfs.rmdir, path)
        return
    end

    if type(removeDirectory) == 'function' then
        pcall(removeDirectory, path)
    end
end

local function migrate_dir_contents(source_dir, target_dir, lfs)
    ensure_dir(target_dir)

    for item_name in lfs.dir(source_dir) do
        if item_name ~= '.' and item_name ~= '..' then
            local source_path = paths.sh_core_paths_join(source_dir, item_name)
            local target_path = paths.sh_core_paths_join(target_dir, item_name)

            if exists_dir(source_path) then
                migrate_dir_contents(source_path, target_path, lfs)
                remove_empty_dir(source_path)
            elseif exists_file(source_path) and not exists_file(target_path) and not exists_dir(target_path) then
                os.rename(source_path, target_path)
            end
        end
    end
end

function paths.sh_core_paths_migrate_legacy_data_root(base_dir)
    if LEGACY_DATA_DIR == OLD_LEGACY_DATA_DIR then
        return false
    end

    local root = base_dir or paths.sh_core_paths_get_script_dir()
    local old_root = paths.sh_core_paths_join(root, OLD_LEGACY_DATA_DIR)
    local new_root = paths.sh_core_paths_get_data_root(root)

    if not exists_dir(old_root) then
        return false
    end

    local ok_lfs, lfs = pcall(require, 'lfs')
    if not ok_lfs or not lfs or type(lfs.dir) ~= 'function' then
        return false
    end

    migrate_dir_contents(old_root, new_root, lfs)
    remove_empty_dir(old_root)
    return true
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
