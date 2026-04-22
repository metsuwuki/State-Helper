--[[
Open with encoding: UTF-8
StateHelper/core/moonloader_env.lua
]]

local moonloader_env = {}
local paths = require('StateHelper.core.paths')

function moonloader_env.sh_core_fs_ensure_statehelper_dir(base_dir, folder_name, folder_description)
    local status_folder = true
    local full_path = paths.sh_core_paths_get_data_path(base_dir, folder_name) .. '/'
    if not doesDirectoryExist(full_path) then
        print(string.format(
            '[StateHelper][FS] creating missing folder "%s" at %s',
            tostring(folder_description or folder_name or 'unknown'),
            tostring(full_path)
        ))
        createDirectory(full_path)
        status_folder = false
    end

    return status_folder
end

function moonloader_env.sh_core_table_deep_copy(orig, copies)
    copies = copies or {}
    if type(orig) == 'table' then
        if copies[orig] then
            return copies[orig]
        end

        local copy = {}
        copies[orig] = copy
        for key, value in next, orig, nil do
            copy[moonloader_env.sh_core_table_deep_copy(key, copies)] = moonloader_env.sh_core_table_deep_copy(value, copies)
        end
        setmetatable(copy, moonloader_env.sh_core_table_deep_copy(getmetatable(orig), copies))
        return copy
    end

    return orig
end

function moonloader_env.sh_core_table_convert_utf8(value, utf8_encoder)
    if type(value) == 'string' then
        return utf8_encoder(value)
    end

    if type(value) == 'table' then
        for key, nested_value in pairs(value) do
            value[key] = moonloader_env.sh_core_table_convert_utf8(nested_value, utf8_encoder)
        end
    end

    return value
end

return moonloader_env
