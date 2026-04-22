--[[
Open with encoding: UTF-8
StateHelper/core/runtime_compat_prelude.lua

Small compatibility prelude that must run before runtime_prelude.lua.
It restores helper functions that older monolithic startup relied on
being available before the first asset downloads begin.
]]

local function sh_runtime_safe_text(value)
    if value == nil then
        return ''
    end
    if type(value) == 'string' then
        return value
    end
    return tostring(value)
end

local function sh_runtime_get_global_string(name, fallback)
    local value = rawget(_G, name)
    if type(value) == 'string' and value ~= '' then
        return value
    end
    return fallback
end

local sh_runtime_paths_ok, sh_runtime_paths = pcall(require, 'StateHelper.core.paths')
if not sh_runtime_paths_ok then
    sh_runtime_paths = nil
end

local sh_runtime_release_config_ok, sh_runtime_release_config = pcall(require, 'StateHelper.core.release_config')
if not sh_runtime_release_config_ok then
    sh_runtime_release_config = nil
end

local sh_runtime_currency_ok, sh_runtime_currency = pcall(require, 'StateHelper.core.currency')
if not sh_runtime_currency_ok then
    sh_runtime_currency = nil
end

if type(sh_repo_raw_url) ~= 'function' then
    function sh_repo_raw_url(relative_path)
        if sh_runtime_release_config and type(sh_runtime_release_config.sh_core_release_get_repo_raw_url) == 'function' then
            return sh_runtime_release_config.sh_core_release_get_repo_raw_url(relative_path)
        end
        local base_url = sh_runtime_get_global_string('SH_REPO_RAW_BASE_URL', 'https://raw.githubusercontent.com/metsuwuki/State-Helper/main')
        local clean_path = sh_runtime_safe_text(relative_path):gsub('\\', '/'):gsub('^/+', '')
        clean_path = clean_path:gsub(' ', '%%20')
        return base_url .. '/' .. clean_path
    end
end

if type(sh_project_raw_url) ~= 'function' then
    function sh_project_raw_url(relative_path)
        if sh_runtime_release_config and type(sh_runtime_release_config.sh_core_release_get_project_raw_url) == 'function' then
            return sh_runtime_release_config.sh_core_release_get_project_raw_url(
                relative_path,
                rawget(_G, 'SH_ACTIVE_PROJECT') or 'Arizona'
            )
        end
        return sh_repo_raw_url(sh_runtime_get_global_string('SH_PROJECT_ROOT_DIR_NAME', 'StateHelper') .. '/' .. sh_runtime_safe_text(relative_path))
    end
end

local function sh_runtime_get_remote_data_root()
    if sh_runtime_release_config and type(sh_runtime_release_config.sh_core_release_get_remote_data_root) == 'function' then
        return sh_runtime_release_config.sh_core_release_get_remote_data_root(
            rawget(_G, 'SH_ACTIVE_PROJECT') or 'Arizona'
        )
    end

    local configured_root = rawget(_G, 'SH_REMOTE_DATA_ROOT')
    if type(configured_root) == 'string' and configured_root ~= '' then
        return configured_root
    end

    return 'Arizona_data/remote'
end

if type(sh_project_remote_data_url) ~= 'function' then
    function sh_project_remote_data_url(relative_path)
        return sh_project_raw_url(sh_runtime_get_remote_data_root() .. '/' .. sh_runtime_safe_text(relative_path))
    end
end

raw_upd_info_url = raw_upd_info_url or sh_project_raw_url('update_info.json')
raw_upd_url = raw_upd_url or sh_repo_raw_url(
    sh_runtime_release_config
        and sh_runtime_release_config.sh_core_release_get_entry_path
        and sh_runtime_release_config.sh_core_release_get_entry_path()
        or sh_runtime_get_global_string('SH_ENTRY_SCRIPT_NAME', 'StateHelper.lua')
)

if type(sh_data_root_path) ~= 'function' then
    function sh_data_root_path(base_dir)
        if sh_runtime_paths and sh_runtime_paths.sh_core_paths_get_data_root then
            return sh_runtime_paths.sh_core_paths_get_data_root(base_dir)
        end
        local fallback_base = sh_runtime_safe_text(base_dir)
        if fallback_base == '' and type(getWorkingDirectory) == 'function' then
            fallback_base = sh_runtime_safe_text(getWorkingDirectory())
        end
        if fallback_base == '' then
            fallback_base = '.'
        end
        return fallback_base:gsub('/', '\\') .. '\\' .. sh_runtime_get_global_string('SH_LEGACY_DATA_DIR_NAME', 'State Helper')
    end
end

if type(sh_data_path) ~= 'function' then
    function sh_data_path(base_dir, ...)
        if sh_runtime_paths and sh_runtime_paths.sh_core_paths_get_data_path then
            return sh_runtime_paths.sh_core_paths_get_data_path(base_dir, ...)
        end

        local parts = { sh_data_root_path(base_dir), ... }
        local result = table.concat(parts, '\\')
        result = result:gsub('/', '\\'):gsub('\\+', '\\')
        return result
    end
end

if type(sh_money_parse) ~= 'function' then
    function sh_money_parse(value)
        if sh_runtime_currency and type(sh_runtime_currency.sh_core_currency_parse) == 'function' then
            return sh_runtime_currency.sh_core_currency_parse(value)
        end
        return tonumber(value)
    end
end

if type(sh_money_format) ~= 'function' then
    function sh_money_format(value)
        if sh_runtime_currency and type(sh_runtime_currency.sh_core_currency_format_compact) == 'function' then
            return sh_runtime_currency.sh_core_currency_format_compact(value)
        end
        return tostring(value or '0')
    end
end

if type(sh_money_plain) ~= 'function' then
    function sh_money_plain(value)
        if sh_runtime_currency and type(sh_runtime_currency.sh_core_currency_format_plain) == 'function' then
            return sh_runtime_currency.sh_core_currency_format_plain(value)
        end
        return tostring(value or '0')
    end
end

if type(sh_money_dual) ~= 'function' then
    function sh_money_dual(value)
        if sh_runtime_currency and type(sh_runtime_currency.sh_core_currency_format_dual) == 'function' then
            return sh_runtime_currency.sh_core_currency_format_dual(value)
        end
        return tostring(value or '0')
    end
end

if type(sh_money_raw) ~= 'function' then
    function sh_money_raw(value)
        if sh_runtime_currency and type(sh_runtime_currency.sh_core_currency_to_raw_string) == 'function' then
            return sh_runtime_currency.sh_core_currency_to_raw_string(value)
        end
        local numeric = tonumber(value)
        return tostring(numeric or 0)
    end
end

if type(sh_money_render) ~= 'function' then
    function sh_money_render(value, mode)
        if sh_runtime_currency and type(sh_runtime_currency.sh_core_currency_render) == 'function' then
            return sh_runtime_currency.sh_core_currency_render(value, mode)
        end
        if mode == 'raw' then
            return sh_money_raw(value)
        end
        return tostring(value or '0')
    end
end
