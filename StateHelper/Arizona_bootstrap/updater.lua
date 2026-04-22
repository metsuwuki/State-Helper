--[[
Open with encoding: UTF-8
StateHelper/Arizona_bootstrap/updater.lua

Manifest-driven апдейтер

Назначение:
- проверяет удаленные данные о версии
- строит план загрузки по удаленному manifest
- обновляет файлы проекта из репозитория

Роль в архитектуре:
- оркестратор доставки для GitHub-обновлений
- связующий слой между доставкой, состоянием обновления и интерфейсом проекта

Правила:
- только логика доставки
- не размещать здесь feature-поведение
- оставлять совместимые глобалки только как вспомогательный слой, а не как источник правды
]]

local manifest = require('StateHelper.Arizona_bootstrap.manifest')
local resolver = require('StateHelper.Arizona_bootstrap.resolver')
local downloader = require('StateHelper.Arizona_bootstrap.downloader')
local integrity = require('StateHelper.Arizona_bootstrap.integrity')
local paths = require('StateHelper.core.paths')
local org_resolver_ok, org_resolver = pcall(require, 'StateHelper.core.org_resolver')
if not org_resolver_ok then
    org_resolver = nil
end
local release_config_ok, release_config = pcall(require, 'StateHelper.core.release_config')
if not release_config_ok then
    release_config = nil
end

local updater = {}

local bootstrap_dlstatus = rawget(_G, 'dlstatus')
if type(bootstrap_dlstatus) ~= 'table' then
    local ok, moonloader = pcall(require, 'moonloader')
    if ok and type(moonloader) == 'table' and type(moonloader.download_status) == 'table' then
        bootstrap_dlstatus = moonloader.download_status
    else
        bootstrap_dlstatus = {}
    end
end

local function is_download_complete(status)
    return status == bootstrap_dlstatus.STATUS_ENDDOWNLOADDATA
end

local runtime_ctx = nil
local state = {
    available = false,
    busy = false,
    last_error = nil,
    remote_info = nil,
    remote_manifest = nil,
    remote_urls = nil,
    download_plan = nil,
}

local function sh_bootstrap_update_version_to_number(version)
    local text = tostring(version or '0')
    local major, minor, patch = text:match('[Vv]?(%d+)%.(%d+)%.(%d+)')
    if major and minor and patch then
        local value = (tonumber(major) or 0) * 1000000
            + (tonumber(minor) or 0) * 1000
            + (tonumber(patch) or 0)

        local lowered = text:lower()
        if lowered:find('alpha', 1, true) then
            return value + 0.1
        end
        if lowered:find('beta', 1, true) then
            return value + 0.2
        end
        if lowered:find('rc', 1, true) then
            return value + 0.3
        end
        return value + 0.9
    end

    local processed_version = text:gsub('[^%d%.]', '')
    processed_version = processed_version:gsub('(%d+)%.(%d+)', '%1@%2', 1)
    processed_version = processed_version:gsub('%.', '')
    processed_version = processed_version:gsub('@', '.')
    return tonumber(processed_version) or 0
end

local function sh_bootstrap_update_log(level, message)
    if runtime_ctx and runtime_ctx.logger and runtime_ctx.logger[level] then
        runtime_ctx.logger[level](runtime_ctx.logger, message)
        return
    end

    print(string.format('[StateHelper][UPDATER][%s] %s', string.upper(level), tostring(message)))
end

local function sh_bootstrap_update_build_index_item(section, module_id, relative_path, remote_url)
    return {
        section = section,
        id = module_id,
        path = relative_path,
        url = remote_url,
    }
end

local function sh_bootstrap_update_get_script_path()
    if runtime_ctx and runtime_ctx.entry_script then
        return runtime_ctx.entry_script
    end

    if type(thisScript) == 'function' then
        local ok, script = pcall(thisScript)
        if ok and script and script.path then
            return script.path
        end
    end

    return nil
end

local function sh_bootstrap_update_get_active_manifest()
    if runtime_ctx and runtime_ctx.manifest then
        return runtime_ctx.manifest
    end

    return manifest
end

local function sh_bootstrap_update_get_active_project_key()
    local active_project = rawget(_G, 'SH_ACTIVE_PROJECT')
    if type(active_project) == 'string' and active_project ~= '' then
        return active_project
    end

    return 'Arizona'
end

local function sh_bootstrap_update_get_repository_url(manifest_ref)
    local active_manifest = manifest_ref or sh_bootstrap_update_get_active_manifest()
    if active_manifest and type(active_manifest.sh_bootstrap_manifest_get_repository_url) == 'function' then
        local repository_url = active_manifest.sh_bootstrap_manifest_get_repository_url()
        if type(repository_url) == 'string' and repository_url ~= '' then
            return repository_url
        end
    end

    if release_config and type(release_config.sh_core_release_get_repository_url) == 'function' then
        local repository_url = release_config.sh_core_release_get_repository_url(
            sh_bootstrap_update_get_active_project_key()
        )
        if type(repository_url) == 'string' and repository_url ~= '' then
            return repository_url
        end
    end

    return 'https://github.com/metsuwuki/State-Helper'
end

local function sh_bootstrap_update_get_remote_data_root(manifest_ref)
    local active_manifest = manifest_ref or sh_bootstrap_update_get_active_manifest()
    if active_manifest and type(active_manifest.sh_bootstrap_manifest_get_remote_data_root) == 'function' then
        local remote_data_root = active_manifest.sh_bootstrap_manifest_get_remote_data_root()
        if type(remote_data_root) == 'string' and remote_data_root ~= '' then
            return remote_data_root
        end
    end

    local configured_root = rawget(_G, 'SH_REMOTE_DATA_ROOT')
    if type(configured_root) == 'string' and configured_root ~= '' then
        return configured_root
    end

    if release_config and type(release_config.sh_core_release_get_remote_data_root) == 'function' then
        local remote_data_root = release_config.sh_core_release_get_remote_data_root(
            sh_bootstrap_update_get_active_project_key()
        )
        if type(remote_data_root) == 'string' and remote_data_root ~= '' then
            return remote_data_root
        end
    end

    return 'Arizona_data/remote'
end

local function sh_bootstrap_update_get_script_dir()
    local script_path = sh_bootstrap_update_get_script_path()
    if script_path then
        return paths.sh_core_paths_normalize(script_path):match('^(.*)\\[^\\]+$')
    end

    return paths.sh_core_paths_get_script_dir()
end

local function sh_bootstrap_update_join_path(...)
    return paths.sh_core_paths_join(...)
end

local function sh_bootstrap_update_get_root_dir()
    if runtime_ctx and runtime_ctx.root_dir then
        return runtime_ctx.root_dir
    end

    return paths.sh_core_paths_get_project_root(sh_bootstrap_update_get_script_dir())
end

local function sh_bootstrap_update_ensure_directory(path)
    local normalized = tostring(path or ''):gsub('/', '\\')
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

local function sh_bootstrap_update_read_file(path, mode)
    local file = io.open(path, mode or 'rb')
    if not file then
        return nil
    end

    local content = file:read('*a')
    file:close()
    return content
end

local function sh_bootstrap_update_write_file(path, content, mode)
    local directory = path:match('^(.*)[/\\][^/\\]+$')
    if directory then
        sh_bootstrap_update_ensure_directory(directory)
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

local function sh_bootstrap_update_get_active_data_subdir()
    if type(SH_ACTIVE_PROJECT) == 'string' and SH_ACTIVE_PROJECT ~= '' then
        return SH_ACTIVE_PROJECT .. '_data'
    end
    return 'Arizona_data'
end

local function sh_bootstrap_update_get_managed_index_path()
    return sh_bootstrap_update_join_path(sh_bootstrap_update_get_root_dir(), sh_bootstrap_update_get_active_data_subdir(), 'installed', 'managed_files.lst')
end

local function sh_bootstrap_update_get_remote_data_path(manifest_ref, relative_path)
    local active_manifest = manifest_ref or sh_bootstrap_update_get_active_manifest()
    local data_root = sh_bootstrap_update_get_remote_data_root(active_manifest)
    return resolver.sh_bootstrap_resolver_get_project_file_url(
        active_manifest,
        sh_bootstrap_update_join_path(data_root, relative_path):gsub('\\', '/')
    )
end

local function sh_bootstrap_update_is_managed_path_safe(path)
    local normalized = tostring(path or ''):gsub('/', '\\'):lower()
    local root_dir = tostring(sh_bootstrap_update_get_root_dir() or ''):gsub('/', '\\'):lower()
    local script_dir = tostring(sh_bootstrap_update_get_script_dir() or ''):gsub('/', '\\'):lower()

    if root_dir ~= '' and normalized:sub(1, #root_dir) == root_dir then
        return true
    end

    local entry_path = sh_bootstrap_update_get_script_path()
    if entry_path and normalized == tostring(entry_path):gsub('/', '\\'):lower() then
        return true
    end

    return script_dir ~= '' and normalized == paths.sh_core_paths_get_entry_path(script_dir):lower()
end

local function sh_bootstrap_update_read_managed_index()
    local path = sh_bootstrap_update_get_managed_index_path()
    local content = sh_bootstrap_update_read_file(path, 'rb')
    local entries = {}
    local seen = {}

    if not content then
        return entries, seen
    end

    content = tostring(content):gsub('\r\n', '\n')
    for line in content:gmatch('[^\n]+') do
        local normalized = tostring(line):gsub('/', '\\')
        if normalized ~= '' and sh_bootstrap_update_is_managed_path_safe(normalized) and not seen[normalized] then
            seen[normalized] = true
            entries[#entries + 1] = normalized
        end
    end

    return entries, seen
end

local function sh_bootstrap_update_collect_managed_paths(plan)
    local entries = {}
    local seen = {}

    for _, item in ipairs(plan or {}) do
        local normalized = tostring(item.destination or ''):gsub('/', '\\')
        if normalized ~= '' and sh_bootstrap_update_is_managed_path_safe(normalized) and not seen[normalized] then
            seen[normalized] = true
            entries[#entries + 1] = normalized
        end
    end

    table.sort(entries)
    return entries, seen
end

local function sh_bootstrap_update_store_managed_index(plan)
    local entries = sh_bootstrap_update_collect_managed_paths(plan)
    local payload = table.concat(entries, '\n')
    if payload ~= '' then
        payload = payload .. '\n'
    end

    return sh_bootstrap_update_write_file(sh_bootstrap_update_get_managed_index_path(), payload, 'wb')
end

local function sh_bootstrap_update_cleanup_stale_files(plan)
    local previous_entries, previous_lookup = sh_bootstrap_update_read_managed_index()
    local _, current_lookup = sh_bootstrap_update_collect_managed_paths(plan)
    local removed = 0

    for _, stale_path in ipairs(previous_entries) do
        if previous_lookup[stale_path] and not current_lookup[stale_path] and doesFileExist(stale_path) then
            os.remove(stale_path)
            if not doesFileExist(stale_path) then
                removed = removed + 1
            end
        end
    end

    return removed
end

local function sh_bootstrap_update_sync_ctx_state()
    if not runtime_ctx then
        return
    end

    runtime_ctx.state.update = runtime_ctx.state.update or {}
    runtime_ctx.state.update.available = state.available
    runtime_ctx.state.update.busy = state.busy
    runtime_ctx.state.update.last_error = state.last_error
    runtime_ctx.state.update.remote_info = state.remote_info
    runtime_ctx.state.update.remote_urls = state.remote_urls
    runtime_ctx.state.update.project_files = state.download_plan
    runtime_ctx.state.update.repository_url = sh_bootstrap_update_get_repository_url()
end

local function sh_bootstrap_update_sync_compat_globals()
    local active_manifest = sh_bootstrap_update_get_active_manifest()
    local fallback_version = active_manifest.project.version
    if rawget(_G, 'scr') and type(scr) == 'table' and scr.version then
        fallback_version = scr.version
    end

    local info = state.remote_info or {
        version = fallback_version,
        size = 'n/a',
        text = '',
        channel = 'stable',
        repository = sh_bootstrap_update_get_repository_url(active_manifest),
    }

    rawset(_G, 'update_info', info)
    rawset(_G, 'new_version', state.available and tostring(info.version or '0') or '0')
    rawset(_G, 'error_update', state.last_error ~= nil)

    if state.remote_urls then
        rawset(_G, 'raw_upd_url', state.remote_urls.entry_url)
        rawset(_G, 'raw_upd_info_url', state.remote_urls.update_info_url)
        rawset(_G, 'raw_manifest_url', state.remote_urls.manifest_url)
    end

    sh_bootstrap_update_sync_ctx_state()
end

local function sh_bootstrap_update_set_error(code, message)
    state.last_error = {
        code = code,
        message = message,
    }
    state.available = false
    state.busy = false
    state.download_plan = nil

    rawset(_G, 'update_request', 1)
    rawset(_G, 'search_for_new_version', 0)
    sh_bootstrap_update_sync_compat_globals()
    sh_bootstrap_update_log('error', string.format('%s: %s', tostring(code), tostring(message)))
end

local function sh_bootstrap_update_clear_error()
    state.last_error = nil
    sh_bootstrap_update_sync_compat_globals()
end

local function sh_bootstrap_update_notify(message)
    if rawget(_G, 'setting') and type(setting) == 'table' and setting.cef_notif and rawget(_G, 'cefnotig') then
        cefnotig('{FF5345}[SH] {FFFFFF}' .. tostring(message), 3000)
        return
    end

    local chat_fn = rawget(_G, 'sampAddChatMessage')
    if type(chat_fn) == 'function' then
        local ok = pcall(chat_fn, '[SH] {FFFFFF}' .. tostring(message), 0xFF5345)
        if ok then
            return
        end
    end

    sh_bootstrap_update_log('info', message)
end

local function sh_bootstrap_update_schedule_reload()
    if rawget(_G, 'lua_thread') and type(lua_thread.create) == 'function' then
        lua_thread.create(function()
            wait(250)
            if rawget(_G, 'showCursor') then
                pcall(showCursor, false)
            end
            if rawget(_G, 'reloadScripts') then
                reloadScripts()
                return
            end
            if rawget(_G, 'thisScript') and type(thisScript) == 'function' then
                local script = thisScript()
                if script and type(script.reload) == 'function' then
                    script:reload()
                end
            end
        end)
        return true
    end

    if rawget(_G, 'reloadScripts') then
        reloadScripts()
        return true
    end

    if rawget(_G, 'thisScript') and type(thisScript) == 'function' then
        local script = thisScript()
        if script and type(script.reload) == 'function' then
            script:reload()
            return true
        end
    end

    return false
end

local function sh_bootstrap_update_clone_table(value)
    if type(value) ~= 'table' then
        return value
    end

    local result = {}
    for key, nested_value in pairs(value) do
        result[key] = sh_bootstrap_update_clone_table(nested_value)
    end
    return result
end

local function sh_bootstrap_update_append_unique_commands(target, source)
    if type(target) ~= 'table' or type(source) ~= 'table' then
        return
    end

    local existing = {}
    for _, command_def in ipairs(target) do
        if type(command_def) == 'table' and command_def.cmd and command_def.cmd ~= '' then
            existing[tostring(command_def.cmd)] = true
        end
    end

    for _, command_def in ipairs(source) do
        if type(command_def) == 'table' then
            local command_name = tostring(command_def.cmd or '')
            if command_name == '' or not existing[command_name] then
                target[#target + 1] = sh_bootstrap_update_clone_table(command_def)
                if command_name ~= '' then
                    existing[command_name] = true
                end
            end
        end
    end
end

local function sh_bootstrap_update_normalize_info(raw_info)
    local info = type(raw_info) == 'table' and raw_info or {}
    local active_manifest = sh_bootstrap_update_get_active_manifest()
    local notes_text = ''

    if type(info.notes) == 'table' then
        notes_text = table.concat(info.notes, '\n')
    end

    return {
        version = tostring(info.version or active_manifest.project.version or '0'),
        size = tostring(info.size or 'n/a'),
        text = tostring(info.text or notes_text or ''),
        channel = tostring(info.channel or 'stable'),
        repository = tostring(info.repository or sh_bootstrap_update_get_repository_url(active_manifest)),
        vehicle = info.vehicle and tostring(info.vehicle) or nil,
    }
end

local function sh_bootstrap_update_sanitize_json_content(content)
    if type(content) ~= 'string' then
        return false, 'invalid_content_type'
    end

    local sanitized = content:gsub('^\239\187\191', '')
    sanitized = sanitized:gsub('^%s+', ''):gsub('%s+$', '')

    if sanitized == '' then
        return false, 'json_empty'
    end

    local first_char = sanitized:sub(1, 1)
    if first_char ~= '{' and first_char ~= '[' then
        return false, 'json_unexpected_prefix:' .. tostring(string.byte(first_char) or 'nil')
    end

    return true, sanitized
end

local function sh_bootstrap_update_decode_json_file(path)
    local content = sh_bootstrap_update_read_file(path, 'rb')
    if not content then
        return false, 'open_failed'
    end

    if type(decodeJson) ~= 'function' then
        return false, 'decode_json_missing'
    end

    local sanitized_ok, sanitized_content = sh_bootstrap_update_sanitize_json_content(content)
    if not sanitized_ok then
        return false, sanitized_content
    end

    local ok, data = pcall(decodeJson, sanitized_content)
    if not ok or type(data) ~= 'table' then
        return false, 'json_parse_failed:' .. tostring(data)
    end

    return true, data
end

local function sh_bootstrap_update_fetch_remote_file(url, destination_path, min_bytes, on_done)
    if not url then
        on_done(false, 'empty_url')
        return
    end

    local directory = destination_path:match('^(.*)[/\\][^/\\]+$')
    if directory then
        sh_bootstrap_update_ensure_directory(directory)
    end

    downloader.sh_bootstrap_downloader_download_to_file(url, destination_path, function(success, result)
        if not success then
            on_done(false, result)
            return
        end

        local verified, verify_reason = integrity.sh_bootstrap_integrity_verify_file(destination_path, min_bytes)
        if not verified then
            on_done(false, verify_reason)
            return
        end

        on_done(true, destination_path)
    end)
end

local function sh_bootstrap_update_fetch_remote_manifest(on_done)
    local active_manifest = (runtime_ctx and runtime_ctx.manifest) or manifest
    local remote_urls = updater.sh_bootstrap_update_get_remote_urls(active_manifest)
    state.remote_urls = remote_urls
    sh_bootstrap_update_sync_compat_globals()

    if not remote_urls.manifest_url then
        on_done(true, active_manifest)
        return
    end

    local cache_dir = sh_bootstrap_update_join_path(sh_bootstrap_update_get_root_dir(), sh_bootstrap_update_get_active_data_subdir(), 'cache')
    local cache_path = sh_bootstrap_update_join_path(cache_dir, 'remote_manifest.lua')

    sh_bootstrap_update_fetch_remote_file(remote_urls.manifest_url, cache_path, 32, function(success, result)
        if not success then
            on_done(false, 'remote_manifest_download_failed:' .. tostring(result))
            return
        end

        local manifest_source = sh_bootstrap_update_read_file(cache_path, 'rb')
        if not manifest_source then
            on_done(false, 'remote_manifest_open_failed')
            return
        end

        local chunk, load_err = loadstring(manifest_source, '@StateHelper.remote_manifest')
        if not chunk then
            on_done(false, 'remote_manifest_load_failed:' .. tostring(load_err))
            return
        end

        local ok, remote_manifest = pcall(chunk)
        if not ok or type(remote_manifest) ~= 'table' then
            on_done(false, 'remote_manifest_eval_failed')
            return
        end

        state.remote_manifest = remote_manifest
        on_done(true, remote_manifest)
    end)
end

local function sh_bootstrap_update_fetch_remote_info(on_done)
    local active_manifest = (runtime_ctx and runtime_ctx.manifest) or manifest
    local remote_urls = updater.sh_bootstrap_update_get_remote_urls(active_manifest)
    state.remote_urls = remote_urls
    sh_bootstrap_update_sync_compat_globals()

    if not remote_urls.update_info_url then
        on_done(false, 'update_info_url_missing')
        return
    end

    local cache_dir = sh_bootstrap_update_join_path(sh_bootstrap_update_get_root_dir(), sh_bootstrap_update_get_active_data_subdir(), 'cache')
    local cache_path = sh_bootstrap_update_join_path(cache_dir, 'remote_update_info.json')

    sh_bootstrap_update_fetch_remote_file(remote_urls.update_info_url, cache_path, 2, function(success, result)
        if not success then
            on_done(false, 'remote_update_info_download_failed:' .. tostring(result))
            return
        end

        local ok, raw_info = sh_bootstrap_update_decode_json_file(cache_path)
        if not ok then
            on_done(false, raw_info)
            return
        end

        state.remote_info = sh_bootstrap_update_normalize_info(raw_info)
        sh_bootstrap_update_sync_compat_globals()
        on_done(true, state.remote_info)
    end)
end

local function sh_bootstrap_update_resolve_download_path(item)
    local script_dir = sh_bootstrap_update_get_script_dir()
    local root_dir = sh_bootstrap_update_get_root_dir()

    if item.section == 'project' then
        return sh_bootstrap_update_join_path(script_dir, item.path)
    end

    return sh_bootstrap_update_join_path(root_dir, item.path)
end

local function sh_bootstrap_update_build_download_plan(remote_manifest)
    local collected = updater.sh_bootstrap_update_collect_project_urls(remote_manifest)
    local plan = {}
    local entry_item = nil
    local seen = {}

    for _, item in ipairs(collected) do
        if item.url and not seen[item.path] then
            seen[item.path] = true
            item.destination = sh_bootstrap_update_resolve_download_path(item)

            if item.section == 'project' and item.id == 'entry' then
                entry_item = item
            else
                plan[#plan + 1] = item
            end
        end
    end

    if entry_item then
        plan[#plan + 1] = entry_item
    end

    state.download_plan = plan
    sh_bootstrap_update_sync_ctx_state()
    return plan
end

local function sh_bootstrap_update_download_plan(plan, index, on_done)
    if index > #plan then
        on_done(true)
        return
    end

    local item = plan[index]
    local item_dir = item.destination:match('^(.*)[/\\][^/\\]+$')
    if item_dir then
        sh_bootstrap_update_ensure_directory(item_dir)
    end

    downloader.sh_bootstrap_downloader_download_to_file(item.url, item.destination, function(success, result)
        if not success then
            on_done(false, {
                item = item,
                reason = result,
            })
            return
        end

        local verified, verify_reason = integrity.sh_bootstrap_integrity_verify_file(item.destination, 1)
        if not verified then
            on_done(false, {
                item = item,
                reason = verify_reason,
            })
            return
        end

        sh_bootstrap_update_download_plan(plan, index + 1, on_done)
    end)
end

local function sh_bootstrap_update_apply_first_start_defaults()
    if not rawget(_G, 'setting') or type(setting) ~= 'table' or not setting.first_start then
        return
    end

    if not rawget(_G, 'cmd') or not rawget(_G, 'cmd_defoult') then
        return
    end

    setting.first_start = false

    sh_bootstrap_update_append_unique_commands(cmd[1], cmd_defoult.all)

    local org_profile = org_resolver and org_resolver.sh_core_org_resolve and org_resolver.sh_core_org_resolve(setting.org) or nil
    if org_profile and type(org_profile.command_sets) == 'table' then
        for _, command_set in ipairs(org_profile.command_sets) do
            if type(cmd_defoult[command_set]) == 'table' then
                sh_bootstrap_update_append_unique_commands(cmd[1], cmd_defoult[command_set])
            end
        end

        if org_profile.gun_func then
            setting.gun_func = true
        end
    end

    if org_profile and org_profile.key == 'hospital' and rawget(_G, 's_na') == 'Phoenix' then
        for i = 1, #cmd[1] do
            if cmd[1][i].cmd == 'mc' and rawget(_G, 'mc_phoenix') then
                cmd[1][i] = sh_bootstrap_update_clone_table(mc_phoenix)
            end
        end
    end

    if rawget(_G, 'add_cmd_in_all_cmd') then
        add_cmd_in_all_cmd()
    end
    if rawget(_G, 'save_cmd') then
        save_cmd()
    end
    if rawget(_G, 'save') then
        save()
    end
end

local function sh_bootstrap_update_refresh_vehicle_data()
    if not state.remote_info or not state.remote_info.vehicle or not rawget(_G, 'localVehicleVersion') then
        return
    end

    local remote_version = sh_bootstrap_update_version_to_number(state.remote_info.vehicle)
    local local_version = sh_bootstrap_update_version_to_number(localVehicleVersion)
    if remote_version <= local_version then
        return
    end

    local data_url = sh_bootstrap_update_get_remote_data_path(sh_bootstrap_update_get_active_manifest(), 'vehicle.json')
    local base_dir = rawget(_G, 'dir')
    if not data_url or not base_dir then
        return
    end

    local local_path = paths.sh_core_paths_get_data_path(base_dir, 'Police', 'vehicle.json')
    local vehicle_dir = local_path:match('^(.*)[/\\][^/\\]+$')
    if vehicle_dir then
        sh_bootstrap_update_ensure_directory(vehicle_dir)
    end

    downloadUrlToFile(data_url, local_path, function(_, status)
        if is_download_complete(status) and rawget(_G, 'checkVehicleData') then
            checkVehicleData()
        end
    end)
end

function updater.bootstrap(ctx)
    runtime_ctx = ctx
    state.remote_urls = updater.sh_bootstrap_update_get_remote_urls(ctx.manifest)

    sh_bootstrap_update_log('info', 'bootstrap updater initialized for ' .. ctx.manifest.project.name)
    sh_bootstrap_update_sync_compat_globals()
end

function updater.sh_bootstrap_update_get_remote_urls(manifest_ref)
    local ref = manifest_ref or manifest
    local remote = ref.sh_bootstrap_manifest_get_remote and ref.sh_bootstrap_manifest_get_remote() or ref.project.remote
    return {
        manifest_url = resolver.sh_bootstrap_resolver_get_github_raw_url(remote, remote.manifest_path),
        entry_url = resolver.sh_bootstrap_resolver_get_github_raw_url(remote, remote.entry_path),
        update_info_url = resolver.sh_bootstrap_resolver_get_github_raw_url(remote, remote.update_info_path),
    }
end

function updater.sh_bootstrap_update_collect_project_urls(manifest_ref, selection)
    local ref = manifest_ref or manifest
    local result = {}
    local remote = ref.sh_bootstrap_manifest_get_remote and ref.sh_bootstrap_manifest_get_remote() or ref.project.remote
    local file_index = ref.sh_bootstrap_manifest_collect_file_index and ref.sh_bootstrap_manifest_collect_file_index(selection) or {}

    result[#result + 1] = sh_bootstrap_update_build_index_item(
        'project',
        'entry',
        remote.entry_path,
        resolver.sh_bootstrap_resolver_get_github_raw_url(remote, remote.entry_path)
    )

    result[#result + 1] = sh_bootstrap_update_build_index_item(
        'project',
        'update_info',
        remote.update_info_path,
        resolver.sh_bootstrap_resolver_get_github_raw_url(remote, remote.update_info_path)
    )

    for _, item in ipairs(file_index) do
        result[#result + 1] = sh_bootstrap_update_build_index_item(
            item.section,
            item.id,
            item.path,
            resolver.sh_bootstrap_resolver_get_project_file_url(ref, item.path)
        )
    end

    return result
end

function updater.sh_bootstrap_update_get_state()
    return state
end

function updater.sh_core_update_check()
    if state.busy then
        return false
    end

    state.last_error = nil
    state.available = false
    sh_bootstrap_update_sync_compat_globals()

    sh_bootstrap_update_fetch_remote_info(function(success, remote_info)
        rawset(_G, 'search_for_new_version', 0)

        if not success then
            sh_bootstrap_update_set_error('update_check_failed', remote_info)
            return
        end

        local current_version = sh_bootstrap_update_get_active_manifest().project.version
        if rawget(_G, 'scr') and type(scr) == 'table' and scr.version then
            current_version = scr.version
        end

        local has_update = sh_bootstrap_update_version_to_number(remote_info.version) > sh_bootstrap_update_version_to_number(current_version)
        state.available = has_update
        state.last_error = nil
        sh_bootstrap_update_sync_compat_globals()
        sh_bootstrap_update_refresh_vehicle_data()

        if has_update then
            sh_bootstrap_update_notify('Update available: ' .. tostring(remote_info.version))
            if rawget(_G, 'setting') and type(setting) == 'table' and setting.auto_update then
                sh_bootstrap_update_notify('Automatic update started...')
                updater.sh_core_update_download()
            end
        end
    end)

    return true
end

function updater.sh_core_update_download()
    if state.busy then
        return false
    end

    state.busy = true
    state.last_error = nil
    rawset(_G, 'update_request', 100000)
    rawset(_G, 'updates', nil)
    sh_bootstrap_update_sync_compat_globals()

    sh_bootstrap_update_fetch_remote_manifest(function(success, remote_manifest)
        if not success then
            sh_bootstrap_update_set_error('update_manifest_failed', remote_manifest)
            return
        end

        local plan = sh_bootstrap_update_build_download_plan(remote_manifest)
        if #plan == 0 then
            sh_bootstrap_update_set_error('update_plan_empty', 'no files collected from manifest')
            return
        end

        sh_bootstrap_update_download_plan(plan, 1, function(download_ok, payload)
            if not download_ok then
                local failed_item = payload and payload.item
                local failed_reason = payload and payload.reason or 'download_failed'
                local failed_path = failed_item and failed_item.path or 'unknown'
                sh_bootstrap_update_set_error('update_download_failed', failed_path .. ':' .. tostring(failed_reason))
                return
            end

            state.busy = false
            state.available = false
            state.last_error = nil
            rawset(_G, 'update_request', 0)
            rawset(_G, 'updates', true)
            rawset(_G, 'new_version', '0')
            local removed_count = sh_bootstrap_update_cleanup_stale_files(plan)
            sh_bootstrap_update_store_managed_index(plan)
            sh_bootstrap_update_sync_compat_globals()
            sh_bootstrap_update_apply_first_start_defaults()

            if rawget(_G, 'windows') and type(windows) == 'table' and windows.main then
                windows.main[0] = false
            end

            if removed_count > 0 then
                sh_bootstrap_update_notify('Update installed. Removed obsolete files: ' .. tostring(removed_count))
            end
            sh_bootstrap_update_notify('Update installed. Reloading scripts...')
            if not sh_bootstrap_update_schedule_reload() then
                sh_bootstrap_update_notify('Please reload MoonLoader manually if the update does not start automatically.')
            end
        end)
    end)

    return true
end

function updater.sh_core_update_error()
    local repository_url = sh_bootstrap_update_get_repository_url()
    local error_text = table.concat({
        '{FFFFFF}Automatic update failed.',
        'Please update the files manually from the repository:',
        '{A1DF6B}' .. repository_url .. '{FFFFFF}',
        '',
        'The repository link has been copied to the clipboard.',
    }, '\n')

    if rawget(_G, 'sampShowDialog') then
        sampShowDialog(2001, '{FF0000}Update Error', error_text, 'Close', '', 0)
    end
    if rawget(_G, 'setClipboardText') then
        setClipboardText(repository_url)
    end
end

return updater

