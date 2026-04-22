--[[
Open with encoding: UTF-8
StateHelper/core/app.lua

Запуск core app

Назначение:
- собирает исходник runtime из модульных частей
- выполняет собранный runtime chunk

Роль в архитектуре:
- мост между bootstrap-запуском и перенесенным телом runtime

Правила:
- не принимать здесь bootstrap-решения
- не редактировать здесь manifest
- держать порядок сборки управляемым через `runtime_manifest.lua`
]]

local paths = require('StateHelper.core.paths')

local app = {}

function app.start(ctx)
    local project = type(SH_ACTIVE_PROJECT) == 'string' and SH_ACTIVE_PROJECT or 'Arizona'
    local project_runtime_manifest = require('StateHelper.' .. project .. '_bootstrap.runtime_manifest')
    ctx.logger:info('starting StateHelper runtime assembly')
    local source_parts = {
        [[
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

local sh_runtime_release_config_ok, sh_runtime_release_config = pcall(require, 'StateHelper.core.release_config')
if not sh_runtime_release_config_ok then
    sh_runtime_release_config = nil
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

local sh_runtime_paths_ok, sh_runtime_paths = pcall(require, 'StateHelper.core.paths')
if not sh_runtime_paths_ok then
    sh_runtime_paths = nil
end

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
]]
    }

    for _, relative_path in ipairs(project_runtime_manifest.parts) do
        local full_path = paths.sh_core_paths_get_project_path(ctx.script_dir, relative_path)
        local file = assert(io.open(full_path, 'rb'))
        source_parts[#source_parts + 1] = assert(file:read('*a'))
        file:close()
    end

    local runtime_source = table.concat(source_parts, '\r\n')
    local runtime_chunk, load_err = loadstring(runtime_source, '@StateHelper.runtime')
    if not runtime_chunk then
        error(load_err)
    end

    return runtime_chunk()
end

return app
