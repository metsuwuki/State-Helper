--[[
Open with encoding: UTF-8
StateHelper/core/storage.lua
]]

local storage = {}

local LEGACY_SETTINGS_FILE = '\xcd\xe0\xf1\xf2\xf0\xee\xe9\xea\xe8.json'
local LEGACY_COMMANDS_DIR = '\xce\xf2\xfb\xe3\xf0\xee\xe2\xea\xe8'
local paths = require('StateHelper.core.paths')

local function normalize(path)
    return path:gsub('/', '\\')
end

local function get_parent_dir(path)
    return normalize(path):match('^(.*)\\[^\\]+$')
end

local function ensure_dir_recursive(path)
    local normalized = normalize(path or '')
    if normalized == '' then
        return
    end

    local drive = normalized:match('^%a:')
    local current = drive or ''
    local remainder = drive and normalized:sub(3) or normalized

    for part in remainder:gmatch('[^\\]+') do
        if current == '' then
            current = part
        elseif current:match('^%a:$') then
            current = current .. '\\' .. part
        else
            current = current .. '\\' .. part
        end

        if not doesDirectoryExist(current) then
            createDirectory(current)
        end
    end
end

local function read_file(path, mode)
    local file = io.open(path, mode or 'rb')
    if not file then
        return nil
    end

    local content = file:read('*a')
    file:close()
    return content
end

local function is_array_table(value)
    if type(value) ~= 'table' then
        return false
    end

    local count = 0
    for key in pairs(value) do
        if type(key) ~= 'number' or key < 1 or key % 1 ~= 0 then
            return false
        end
        count = count + 1
    end

    for index = 1, count do
        if value[index] == nil then
            return false
        end
    end

    return count > 0 or next(value) == nil
end

local function merge_with_defaults(defaults, stored)
    if type(defaults) ~= 'table' then
        if stored == nil then
            return defaults
        end
        return stored
    end

    if type(stored) ~= 'table' then
        return defaults
    end

    local merged = {}
    for key, default_value in pairs(defaults) do
        local stored_value = stored[key]
        if type(default_value) == 'table' and type(stored_value) == 'table' and not is_array_table(default_value) then
            merged[key] = merge_with_defaults(default_value, stored_value)
        elseif stored_value ~= nil then
            merged[key] = stored_value
        else
            merged[key] = default_value
        end
    end

    return merged
end

local function write_file(path, content, mode)
    local parent_dir = get_parent_dir(path)
    if parent_dir then
        ensure_dir_recursive(parent_dir)
    end

    local file = io.open(path, mode or 'wb')
    if not file then
        return false
    end

    file:write(content or '')
    file:flush()
    file:close()
    return true
end

local function safe_remove(path)
    if doesFileExist(path) then
        os.remove(path)
    end
end

local function move_corrupt_file(file_path, raw_data)
    local corrupt_path = file_path .. '.corrupt'
    safe_remove(corrupt_path)

    local moved = os.rename(file_path, corrupt_path)
    if moved and doesFileExist(corrupt_path) then
        return true, corrupt_path
    end

    if raw_data ~= nil and write_file(corrupt_path, raw_data, 'wb') then
        safe_remove(file_path)
        return true, corrupt_path
    end

    return false, corrupt_path
end

local function atomic_write(path, content, keep_backup)
    local tmp_path = path .. '.tmp'
    local backup_path = path .. '.bak'
    local had_original = doesFileExist(path)

    safe_remove(tmp_path)
    if not write_file(tmp_path, content, 'wb') then
        safe_remove(tmp_path)
        return false, 'tmp_write_failed'
    end

    if had_original then
        safe_remove(backup_path)
        local backup_ok = os.rename(path, backup_path)
        if not backup_ok or doesFileExist(path) then
            safe_remove(tmp_path)
            return false, 'backup_rename_failed'
        end
    end

    local rename_ok = os.rename(tmp_path, path)
    if rename_ok and doesFileExist(path) then
        if had_original and not keep_backup then
            safe_remove(backup_path)
        end
        return true, backup_path
    end

    safe_remove(tmp_path)
    if had_original and doesFileExist(backup_path) and not doesFileExist(path) then
        os.rename(backup_path, path)
    end

    return false, 'final_rename_failed'
end

local function get_legacy_root(base_dir)
    return paths.sh_core_paths_get_data_root(base_dir):gsub('\\', '/')
end

local function get_legacy_settings_path(base_dir)
    return get_legacy_root(base_dir) .. '/' .. LEGACY_SETTINGS_FILE
end

local function get_legacy_commands_dir(base_dir)
    return get_legacy_root(base_dir) .. '/' .. LEGACY_COMMANDS_DIR .. '/'
end

function storage.create(ctx)
    local obj = {}

    function obj:path(relative_path)
        return paths.sh_core_paths_get_project_path(ctx.script_dir, relative_path)
    end

    function obj:data_path(relative_path)
        return paths.sh_core_paths_get_data_path(ctx.script_dir, relative_path)
    end

    function obj:ensure_dir(relative_path)
        local full_path = self:path(relative_path)
        if not doesDirectoryExist(full_path) then
            createDirectory(full_path)
        end
        return full_path
    end

    return obj
end

function storage.sh_core_storage_save_settings(base_dir, settings_table, encode_json)
    if not settings_table or settings_table.first_start then
        return
    end

    atomic_write(get_legacy_settings_path(base_dir), encode_json(settings_table), true)
end

function storage.sh_core_storage_save_commands(base_dir, settings_table, command_state, lfs_module, encode_json)
    if not settings_table or settings_table.first_start or not command_state then
        return
    end

    local base_commands_dir = get_legacy_commands_dir(base_dir)
    if not doesDirectoryExist(base_commands_dir) then
        createDirectory(base_commands_dir)
    end

    atomic_write(base_commands_dir .. 'categories.json', encode_json(command_state[2]), true)

    local existing_files = {}
    for folder_name in lfs_module.dir(base_commands_dir) do
        if folder_name ~= '.' and folder_name ~= '..' and folder_name ~= 'categories.json' then
            local folder_path = base_commands_dir .. folder_name
            if doesDirectoryExist(folder_path) then
                for file_name in lfs_module.dir(folder_path) do
                    if file_name:match('%.json$') then
                        existing_files[folder_path .. '/' .. file_name] = true
                    end
                end
            end
        end
    end

    local current_files = {}
    for _, command_obj in ipairs(command_state[1]) do
        local file_name = command_obj.cmd
        if not file_name or file_name == '' then
            file_name = tostring(command_obj.UID)
        end

        if file_name then
            local folder_index = command_obj.folder
            if folder_index and command_state[2][folder_index] then
                local folder_name = command_state[2][folder_index][1]
                local folder_path = base_commands_dir .. folder_name .. '/'
                if not doesDirectoryExist(folder_path) then
                    createDirectory(folder_path)
                end

                local file_path = folder_path .. file_name .. '.json'
                current_files[file_path] = true
                atomic_write(file_path, encode_json(command_obj), false)
            end
        end
    end

    for file_path in pairs(existing_files) do
        if not current_files[file_path] then
            os.remove(file_path)
        end
    end
end

function storage.sh_core_storage_apply_settings(base_dir, name_file, description_file, target_table, decode_json, encode_json, settings_table)
    local file_path = get_legacy_root(base_dir) .. '/' .. name_file
    if doesFileExist(file_path) then
        print('{82E28C}Reading ' .. description_file .. '...')
        local raw_data = read_file(file_path, 'rb')
        local ok, stored_table = pcall(decode_json, raw_data)
        if ok and type(stored_table) == 'table' then
            target_table = merge_with_defaults(target_table, stored_table)

            if not settings_table.first_start then
                atomic_write(file_path, encode_json(target_table), true)
            end
        else
            move_corrupt_file(file_path, raw_data)
            print('{F54A4A}Settings file is corrupt. A new one will be created.')
        end
    else
        print('{F54A4A}Settings file was not found.')
    end

    return target_table
end

return storage
