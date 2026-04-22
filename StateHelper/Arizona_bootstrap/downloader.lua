--[[
Open with encoding: UTF-8
StateHelper/Arizona_bootstrap/downloader.lua

Bootstrap-загрузчик файлов

Назначение:
- скачивает удаленный файл в локальный путь
- использует временный файл перед заменой финального файла

Роль в архитектуре:
- низкоуровневый примитив доставки файлов для updater

Правила:
- только загрузка
- не принимать здесь версионные решения
- не размещать здесь логику manifest
]]

local downloader = {}

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

local function is_download_error(status)
    return status == bootstrap_dlstatus.STATUS_DOWNLOADERROR
        or status == bootstrap_dlstatus.STATUS_DOWNLOAD_ERROR
end

local function ensure_dir_recursive(path)
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

local function safe_remove(path)
    if doesFileExist(path) then
        os.remove(path)
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

local function write_file(path, content, mode)
    local parent_dir = path:match('^(.*)[/\\][^/\\]+$')
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

local function try_rename(source_path, destination_path, attempts)
    local total_attempts = attempts or 20
    for attempt = 1, total_attempts do
        local rename_ok = os.rename(source_path, destination_path)
        if rename_ok and doesFileExist(destination_path) then
            return true
        end

        if attempt < total_attempts then
            wait(0)
        end
    end

    return false
end

local function try_read_file(path, mode, attempts)
    local total_attempts = attempts or 20
    for attempt = 1, total_attempts do
        local content = read_file(path, mode)
        if content ~= nil then
            return content
        end

        if attempt < total_attempts then
            wait(0)
        end
    end

    return nil
end

local function replace_file(source_path, destination_path)
    local rename_ok = try_rename(source_path, destination_path)
    if rename_ok then
        return true
    end

    local content = try_read_file(source_path, 'rb')
    if content == nil then
        return false
    end

    local write_ok = write_file(destination_path, content, 'wb')
    if not write_ok or not doesFileExist(destination_path) then
        return false
    end

    safe_remove(source_path)
    return true
end

function downloader.sh_bootstrap_downloader_download_to_file(url, destination_path, on_done)
    if not url or url == '' then
        if on_done then
            on_done(false, 'empty_url')
        end
        return false, 'empty_url'
    end

    local destination_dir = destination_path:match('^(.*)[/\\][^/\\]+$')
    if destination_dir then
        ensure_dir_recursive(destination_dir)
    end

    local tmp_path = destination_path .. '.tmp'
    local backup_path = destination_path .. '.bak'
    safe_remove(tmp_path)

    downloadUrlToFile(url, tmp_path, function(_, status)
        if is_download_complete(status) then
            lua_thread.create(function()
                local had_original = doesFileExist(destination_path)

                if had_original then
                    safe_remove(backup_path)
                    local backup_ok = try_rename(destination_path, backup_path)
                    if not backup_ok or doesFileExist(destination_path) then
                        safe_remove(tmp_path)
                        if on_done then
                            on_done(false, 'backup_failed')
                        end
                        return
                    end
                end

                local replace_ok = replace_file(tmp_path, destination_path)
                if replace_ok then
                    safe_remove(backup_path)
                    if on_done then
                        on_done(true, destination_path)
                    end
                else
                    safe_remove(tmp_path)
                    safe_remove(destination_path)
                    if had_original and doesFileExist(backup_path) and not doesFileExist(destination_path) then
                        try_rename(backup_path, destination_path)
                    end
                    if on_done then
                        on_done(false, 'rename_failed')
                    end
                end
            end)
        elseif is_download_error(status) then
            lua_thread.create(function()
                safe_remove(tmp_path)
                if on_done then
                    on_done(false, 'download_error')
                end
            end)
        end
    end)

    return true
end

return downloader
