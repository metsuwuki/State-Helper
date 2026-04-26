--[[
Open with encoding: UTF-8
StateHelper.lua

Точка входа проекта и bootstrap-installer.

Назначение:
- остается единственным Lua-файлом, который игрок кладет в `moonloader`
- если структура `StateHelper/` уже установлена, запускает обычный modular loader
- если структуры нет, автоматически скачивает проект с GitHub и подготавливает локальную папку

Роль в архитектуре:
- entrypoint для MoonLoader
- минимальный self-bootstrap слой для формата "один Lua -> остальное докачается само"

Правила:
- держать файл самостоятельным и минимально зависимым
- не тащить сюда feature-логику и фракционные детали
- использовать этот файл только как старт и аварийный установщик
]]

local function sh_entry_safe_call_global(name, ...)
    local fn = rawget(_G, name)
    if type(fn) == 'function' then
        return fn(...)
    end
    return nil
end

local sh_entry_dlstatus = rawget(_G, 'dlstatus')
if type(sh_entry_dlstatus) ~= 'table' then
    local ok, moonloader = pcall(require, 'moonloader')
    if ok and type(moonloader) == 'table' and type(moonloader.download_status) == 'table' then
        sh_entry_dlstatus = moonloader.download_status
    else
        sh_entry_dlstatus = {}
    end
end

local function sh_entry_is_download_complete(status)
    return status == sh_entry_dlstatus.STATUS_ENDDOWNLOADDATA
end

local function sh_entry_is_download_error(status)
    return status == sh_entry_dlstatus.STATUS_DOWNLOADERROR
        or status == sh_entry_dlstatus.STATUS_DOWNLOAD_ERROR
end

local REMOTE = {
    owner = 'metsuwuki',
    repo = 'State-Helper',
    branch = 'main',
    project_root = 'StateHelper',
    manifest_path = 'StateHelper/Arizona_bootstrap/manifest.lua',
    update_info_path = 'StateHelper/update_info.json',
}

local SH_ENTRY_SCRIPT_NAME = 'StateHelper.lua'
local SH_ENTRY_PROJECT_DISPLAY_NAME = 'State Helper'
local SH_ENTRY_LEGACY_DATA_DIR_NAME = 'StateHelper'

local function sh_entry_publish_global_constants()
    rawset(_G, 'SH_REPO_OWNER', REMOTE.owner)
    rawset(_G, 'SH_REPO_NAME', REMOTE.repo)
    rawset(_G, 'SH_REPO_BRANCH', REMOTE.branch)
    rawset(_G, 'SH_REPO_RAW_BASE_URL', string.format(
        'https://raw.githubusercontent.com/%s/%s/%s',
        tostring(REMOTE.owner),
        tostring(REMOTE.repo),
        tostring(REMOTE.branch)
    ))
    rawset(_G, 'SH_REPOSITORY_URL', string.format(
        'https://github.com/%s/%s',
        tostring(REMOTE.owner),
        tostring(REMOTE.repo)
    ))
    rawset(_G, 'SH_PROJECT_ROOT_DIR_NAME', REMOTE.project_root)
    rawset(_G, 'SH_UPDATE_INFO_PATH', REMOTE.update_info_path)
    rawset(_G, 'SH_ENTRY_SCRIPT_NAME', SH_ENTRY_SCRIPT_NAME)
    rawset(_G, 'SH_PROJECT_DISPLAY_NAME', SH_ENTRY_PROJECT_DISPLAY_NAME)
    rawset(_G, 'SH_LEGACY_DATA_DIR_NAME', SH_ENTRY_LEGACY_DATA_DIR_NAME)
end

sh_entry_publish_global_constants()

local script_dir = (thisScript().path):match('^(.*)[/\\][^/\\]+$') or getWorkingDirectory()
local root_dir = script_dir .. '\\StateHelper'
local install_lock_path = root_dir .. '\\Arizona_data\\cache\\bootstrap_install.lock'
local sh_entry_project_choice_path = root_dir .. '\\project_choice.txt'
local sh_entry_selected_project = nil  -- resolves to 'Arizona' or 'Rodina' before first use

package.path = table.concat({
    script_dir .. '\\?.lua',
    script_dir .. '\\?\\init.lua',
    package.path
}, ';')

local function sh_entry_get_project_version()
    local fallback_version = 'v5.0.0-alpha'
    local ok, version_module = pcall(require, 'StateHelper.core.version')
    if not ok or type(version_module) ~= 'table' then
        return fallback_version
    end

    local version_value = version_module.value
    if type(version_module.sh_core_version_get) == 'function' then
        version_value = version_module.sh_core_version_get()
    end

    if type(version_value) == 'string' and version_value ~= '' then
        return version_value
    end

    return fallback_version
end

local PROJECT_VERSION = sh_entry_get_project_version()

sh_entry_safe_call_global('script_name', SH_ENTRY_PROJECT_DISPLAY_NAME)
sh_entry_safe_call_global('script_author', 'Kane')
sh_entry_safe_call_global('script_struct_developer', 'MetsUwUki')
sh_entry_safe_call_global('script_description', 'Script for employees of state organizations on the Arizona Role Playing Game. bootstrap entrypoint')
sh_entry_safe_call_global('script_version', PROJECT_VERSION)
sh_entry_safe_call_global('script_properties', 'work-in-pause')

local sh_entry_u8 = function(value)
    return tostring(value or '')
end

local sh_entry_bootstrap_overlay = {
    available = false,
    active = false,
    mode = 'idle',
    phase_started_at = 0,
    last_frame_at = 0,
    progress = 0,
    target_progress = 0,
    title = SH_ENTRY_PROJECT_DISPLAY_NAME,
    status_text = '',
    detail_text = '',
    hold_until = 0,
    hold_duration_ms = 2600,
    reset_position = false,
}

local sh_entry_project_selector = {
    active = false,
    chosen = nil,
    texture_paths = {},
    download_state = {},
    retry_at = {},
    texture_meta = {},
    textures = {},
}

local sh_entry_project_selector_release_textures = function()
end

local function sh_entry_clamp(value, min_value, max_value)
    if value < min_value then
        return min_value
    end
    if value > max_value then
        return max_value
    end
    return value
end

local function sh_entry_bootstrap_overlay_set_status(status_text, detail_text, target_progress)
    if not sh_entry_bootstrap_overlay.available then
        return
    end

    if type(status_text) == 'string' and status_text ~= '' then
        sh_entry_bootstrap_overlay.status_text = status_text
    end

    if detail_text ~= nil then
        sh_entry_bootstrap_overlay.detail_text = tostring(detail_text)
    end

    if type(target_progress) == 'number' then
        sh_entry_bootstrap_overlay.target_progress = sh_entry_clamp(target_progress, 0, 1)
    end
end

local function sh_entry_bootstrap_overlay_begin(is_recovery)
    if not sh_entry_bootstrap_overlay.available then
        return false
    end

    local now = os.clock()
    sh_entry_bootstrap_overlay.active = true
    sh_entry_bootstrap_overlay.mode = 'greeting'
    sh_entry_bootstrap_overlay.phase_started_at = now
    sh_entry_bootstrap_overlay.last_frame_at = now
    sh_entry_bootstrap_overlay.progress = 0
    sh_entry_bootstrap_overlay.target_progress = 0
    sh_entry_bootstrap_overlay.title = 'Привет'
    sh_entry_bootstrap_overlay.status_text = 'Сейчас загрузим функционал хелпера.'
    sh_entry_bootstrap_overlay.detail_text = is_recovery
        and 'Восстанавливаем установку после прерывания.'
        or 'Подготавливаем локальную структуру проекта.'
    sh_entry_bootstrap_overlay.hold_until = 0
    sh_entry_bootstrap_overlay.reset_position = true

    sh_entry_bootstrap_overlay.imgui.Process = true
    return true
end

local function sh_entry_bootstrap_overlay_complete(message, is_error)
    if not sh_entry_bootstrap_overlay.available then
        return
    end

    local now = os.clock()
    sh_entry_bootstrap_overlay.active = true
    sh_entry_bootstrap_overlay.mode = is_error and 'error' or 'done'
    sh_entry_bootstrap_overlay.phase_started_at = now
    sh_entry_bootstrap_overlay.last_frame_at = now
    sh_entry_bootstrap_overlay.progress = is_error and sh_entry_bootstrap_overlay.progress or math.max(sh_entry_bootstrap_overlay.progress, 0.98)
    sh_entry_bootstrap_overlay.target_progress = is_error and sh_entry_bootstrap_overlay.target_progress or 1
    sh_entry_bootstrap_overlay.title = is_error and 'Не удалось завершить загрузку' or 'Готово'
    sh_entry_bootstrap_overlay.status_text = tostring(message or '')
    sh_entry_bootstrap_overlay.detail_text = is_error
        and 'Проверьте подключение к интернету или целостность файлов MoonLoader.'
        or 'Сейчас скрипт будет перезагружен, чтобы все элементы зафиксировались.'
    sh_entry_bootstrap_overlay.hold_until = now + (sh_entry_bootstrap_overlay.hold_duration_ms / 1000)
end

local function sh_entry_build_install_error_message(reason)
    local raw_reason = tostring(reason or 'unknown_error')
    local headline = 'Не удалось завершить загрузку хелпера.'
    local detail = 'Проверьте подключение к интернету или целостность файлов MoonLoader.'
    local function shorten_path(path)
        local normalized = tostring(path or ''):gsub('\\', '/')
        if #normalized <= 46 then
            return normalized
        end
        return '...' .. normalized:sub(-43)
    end

    if raw_reason:find('manifest_download_failed', 1, true) then
        detail = 'Не удалось получить стартовый manifest проекта из GitHub.'
    elseif raw_reason:find('manifest_open_failed', 1, true) then
        detail = 'Manifest был скачан, но его не удалось прочитать с диска.'
    elseif raw_reason:find('manifest_load_failed', 1, true) or raw_reason:find('manifest_eval_failed', 1, true) then
        detail = 'Стартовый manifest поврежден или загрузился некорректно.'
    elseif raw_reason:find('file_download_failed:', 1, true) then
        local failed_path = raw_reason:match('file_download_failed:([^:]+):')
        if failed_path and failed_path ~= '' then
            detail = 'Не удалось скачать файл: ' .. shorten_path(failed_path)
        else
            detail = 'Один из файлов проекта не удалось скачать или сохранить.'
        end
    elseif raw_reason:find('download_error', 1, true) then
        detail = 'MoonLoader сообщил об ошибке загрузки из сети.'
    elseif raw_reason:find('backup_failed', 1, true) or raw_reason:find('rename_failed', 1, true) then
        detail = 'Файл был скачан, но его не удалось безопасно записать на диск.'
    end

    return headline, detail, raw_reason
end

do
    local ok, imgui = pcall(require, 'mimgui')
    if ok and type(imgui) == 'table' then
        sh_entry_bootstrap_overlay.available = true
        sh_entry_bootstrap_overlay.imgui = imgui

        local function sh_entry_bootstrap_overlay_gradient_color(speed, shift, alpha)
            local r = math.floor(math.sin((os.clock() + shift) * speed) * 127 + 128) / 255
            local g = math.floor(math.sin((os.clock() + shift) * speed + 2) * 127 + 128) / 255
            local b = math.floor(math.sin((os.clock() + shift) * speed + 4) * 127 + 128) / 255
            return imgui.ImVec4(r, g, b, alpha or 1.0)
        end

        local function sh_entry_bootstrap_overlay_draw_gradient_border(draw_list, window_pos, window_size)
            local border_color = sh_entry_bootstrap_overlay_gradient_color(0.9, 0.15, 0.95)
            local glow_color = sh_entry_bootstrap_overlay_gradient_color(0.9, 0.15, 0.22)
            local border_draw_list = draw_list
            if type(imgui.GetForegroundDrawList) == 'function' then
                border_draw_list = imgui.GetForegroundDrawList()
            end

            border_draw_list:AddRect(
                imgui.ImVec2(window_pos.x - 6, window_pos.y - 6),
                imgui.ImVec2(window_pos.x + window_size.x + 6, window_pos.y + window_size.y + 6),
                imgui.GetColorU32Vec4(glow_color),
                22,
                15,
                3.0
            )
            border_draw_list:AddRect(
                imgui.ImVec2(window_pos.x - 2, window_pos.y - 2),
                imgui.ImVec2(window_pos.x + window_size.x + 2, window_pos.y + window_size.y + 2),
                imgui.GetColorU32Vec4(border_color),
                18,
                15,
                2.0
            )
        end

        local function sh_entry_bootstrap_overlay_draw_text_block(text, wrap_width)
            if text == '' then
                return
            end

            imgui.PushTextWrapPos(wrap_width)
            imgui.TextUnformatted(sh_entry_u8(text))
            imgui.PopTextWrapPos()
        end

        local function sh_entry_bootstrap_overlay_utf8_chars(text)
            local chars = {}
            for char in tostring(text or ''):gmatch('[%z\1-\127\194-\244][\128-\191]*') do
                chars[#chars + 1] = char
            end
            return chars
        end

        local function sh_entry_bootstrap_overlay_draw_scaled_text(text, x, y, scale, color)
            imgui.SetCursorPos(imgui.ImVec2(x, y))
            imgui.SetWindowFontScale(scale)
            if color then
                imgui.PushStyleColor(imgui.Col.Text, color)
            end
            imgui.TextUnformatted(sh_entry_u8(text))
            if color then
                imgui.PopStyleColor(1)
            end
            imgui.SetWindowFontScale(1.0)
        end

        local function sh_entry_bootstrap_overlay_draw_gradient_text(text, x, y, scale, alpha)
            local chars = sh_entry_bootstrap_overlay_utf8_chars(text)
            imgui.SetCursorPos(imgui.ImVec2(x, y))
            imgui.SetWindowFontScale(scale)

            for index, char in ipairs(chars) do
                local color = sh_entry_bootstrap_overlay_gradient_color(0.55, index * 0.14, alpha or 1.0)
                imgui.PushStyleColor(imgui.Col.Text, color)
                imgui.TextUnformatted(char)
                imgui.PopStyleColor(1)

                if index < #chars then
                    imgui.SameLine(nil, 0)
                end
            end

            imgui.SetWindowFontScale(1.0)
        end

        local function sh_entry_bootstrap_overlay_draw_progress_bar(draw_list, x, y, width, height, progress)
            local time = os.clock()
            local function get_clr(shift)
                local r = math.floor(math.sin(time * 0.9 + shift) * 127 + 128) / 255
                local g = math.floor(math.sin(time * 0.9 + shift + 2) * 127 + 128) / 255
                local b = math.floor(math.sin(time * 0.9 + shift + 4) * 127 + 128) / 255
                return imgui.GetColorU32Vec4(imgui.ImVec4(r, g, b, 0.9))
            end

            draw_list:AddRectFilled(imgui.ImVec2(x, y), imgui.ImVec2(x + width, y + height), imgui.GetColorU32Vec4(imgui.ImVec4(0.12, 0.12, 0.12, 1.00)), 12)

            if progress > 0 then
                local fill_width = (width - 4) * progress
                draw_list:AddRectFilled(
                    imgui.ImVec2(x + 2, y + 2),
                    imgui.ImVec2(x + 2 + fill_width, y + height - 2),
                    get_clr(progress * 1.2),
                    10
                )
                draw_list:AddRectFilled(
                    imgui.ImVec2(x + 2, y + 2),
                    imgui.ImVec2(x + 2 + fill_width, y + (height / 2) - 1),
                    imgui.GetColorU32Vec4(imgui.ImVec4(1.00, 1.00, 1.00, 0.08)),
                    10
                )
            end
        end

        local function sh_entry_project_selector_get_logo_candidates(project_name)
            local file_name = string.lower(project_name) .. '_logo.png'
            return {
                root_dir .. '\\' .. file_name,
                script_dir .. '\\StateHelper\\' .. file_name,
                script_dir .. '\\' .. file_name,
            }
        end

        local function sh_entry_project_selector_get_logo_uv(project_name)
            if project_name == 'Arizona' then
                return imgui.ImVec2(7 / 512, 16 / 512), imgui.ImVec2(504 / 512, 496 / 512)
            end
            if project_name == 'Rodina' then
                return imgui.ImVec2(0 / 128, 18 / 128), imgui.ImVec2(127 / 128, 120 / 128)
            end
            return imgui.ImVec2(0, 0), imgui.ImVec2(1, 1)
        end

        local function sh_entry_project_selector_read_png_size(path)
            local file = io.open(path, 'rb')
            if not file then
                return nil, nil
            end

            local header = file:read(24)
            file:close()
            if type(header) ~= 'string' or #header < 24 then
                return nil, nil
            end

            local b = { header:byte(1, 24) }
            local is_png = b[1] == 137 and b[2] == 80 and b[3] == 78 and b[4] == 71
                and b[5] == 13 and b[6] == 10 and b[7] == 26 and b[8] == 10
            if not is_png then
                return nil, nil
            end

            local width = (((b[17] * 256) + b[18]) * 256 + b[19]) * 256 + b[20]
            local height = (((b[21] * 256) + b[22]) * 256 + b[23]) * 256 + b[24]
            return width, height
        end

        local function sh_entry_project_selector_build_texture_meta(project_name, texture_path)
            local width, height = sh_entry_project_selector_read_png_size(texture_path)
            local uv_min, uv_max = sh_entry_project_selector_get_logo_uv(project_name)
            return {
                width = tonumber(width) or 1,
                height = tonumber(height) or 1,
                uv_min = uv_min,
                uv_max = uv_max,
            }
        end

        local function sh_entry_project_selector_start_logo_download(project_name, destination_path)
            if type(downloadUrlToFile) ~= 'function' then
                return
            end

            sh_entry_project_selector.download_state[project_name] = 'downloading'
            sh_entry_project_selector.retry_at[project_name] = nil
            local remote_path = 'StateHelper/' .. string.lower(project_name) .. '_logo.png'
            local base_url = rawget(_G, 'SH_REPO_RAW_BASE_URL')
            if type(base_url) ~= 'string' or base_url == '' then
                base_url = string.format(
                    'https://raw.githubusercontent.com/%s/%s/%s',
                    tostring(REMOTE.owner),
                    tostring(REMOTE.repo),
                    tostring(REMOTE.branch)
                )
            end
            local remote_url = base_url .. '/' .. tostring(remote_path):gsub(' ', '%%20')
            downloadUrlToFile(remote_url, destination_path, function(_, status)
                if sh_entry_is_download_complete(status) then
                    sh_entry_project_selector.download_state[project_name] = 'ready'
                elseif sh_entry_is_download_error(status) then
                    sh_entry_project_selector.download_state[project_name] = 'failed'
                    sh_entry_project_selector.retry_at[project_name] = os.clock() + 3
                end
            end)
        end

        local function sh_entry_project_selector_ensure_textures()
            sh_entry_project_selector.textures = sh_entry_project_selector.textures or {}
            sh_entry_project_selector.texture_paths = sh_entry_project_selector.texture_paths or {}
            sh_entry_project_selector.download_state = sh_entry_project_selector.download_state or {}
            sh_entry_project_selector.texture_meta = sh_entry_project_selector.texture_meta or {}

            if type(imgui.CreateTextureFromFile) ~= 'function' then
                return
            end

            if not doesDirectoryExist(root_dir) then
                local normalized_root = tostring(root_dir or ''):gsub('/', '\\')
                local drive = normalized_root:match('^%a:')
                local current = drive or ''
                local remainder = drive and normalized_root:sub(3) or normalized_root

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

            for _, project_name in ipairs({ 'Arizona', 'Rodina' }) do
                if sh_entry_project_selector.textures[project_name] == nil then
                    local found_path = nil
                    for _, candidate_path in ipairs(sh_entry_project_selector_get_logo_candidates(project_name)) do
                        if doesFileExist(candidate_path) then
                            found_path = candidate_path
                            break
                        end
                    end

                    if found_path then
                        local ok_texture, texture = pcall(imgui.CreateTextureFromFile, found_path)
                        if ok_texture and texture ~= nil then
                            sh_entry_project_selector.textures[project_name] = texture
                            sh_entry_project_selector.texture_paths[project_name] = found_path
                            sh_entry_project_selector.texture_meta[project_name] = sh_entry_project_selector_build_texture_meta(project_name, found_path)
                            sh_entry_project_selector.download_state[project_name] = 'loaded'
                        end
                    else
                        local root_logo_path = root_dir .. '\\' .. string.lower(project_name) .. '_logo.png'
                        local state = sh_entry_project_selector.download_state[project_name]
                        local retry_at = sh_entry_project_selector.retry_at[project_name]
                        local can_retry = state ~= 'failed' or (type(retry_at) == 'number' and os.clock() >= retry_at)
                        if state ~= 'downloading' and can_retry then
                            sh_entry_project_selector_start_logo_download(project_name, root_logo_path)
                        end
                    end
                end
            end
        end

        sh_entry_project_selector_release_textures = function()
            if type(imgui.ReleaseTexture) ~= 'function' then
                return
            end

            for key, texture in pairs(sh_entry_project_selector.textures or {}) do
                if texture ~= nil then
                    pcall(imgui.ReleaseTexture, texture)
                    sh_entry_project_selector.textures[key] = nil
                end
            end

            sh_entry_project_selector.texture_paths = {}
            sh_entry_project_selector.download_state = {}
            sh_entry_project_selector.retry_at = {}
            sh_entry_project_selector.texture_meta = {}
        end

        imgui.OnFrame(
            function()
                return sh_entry_bootstrap_overlay.active
            end,
            function(main)
                local now = os.clock()
                local dt = sh_entry_clamp(now - (sh_entry_bootstrap_overlay.last_frame_at or now), 0, 0.05)
                sh_entry_bootstrap_overlay.last_frame_at = now

                local progress_delta = sh_entry_bootstrap_overlay.target_progress - sh_entry_bootstrap_overlay.progress
                sh_entry_bootstrap_overlay.progress = sh_entry_clamp(sh_entry_bootstrap_overlay.progress + progress_delta * dt * 7.5, 0, 1)

                main.HideCursor = true

                local io = imgui.GetIO()
                local display = io.DisplaySize
                local overlay_width = 560
                local overlay_height = 145

                imgui.SetNextWindowPos(imgui.ImVec2(display.x * 0.5, display.y - 70), imgui.Cond.Always, imgui.ImVec2(0.5, 1.0))
                imgui.SetNextWindowSize(imgui.ImVec2(overlay_width, overlay_height), imgui.Cond.Always)

                imgui.PushStyleVarFloat(imgui.StyleVar.WindowRounding, 16)
                imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(0, 0))
                
                imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(0, 0, 0, 0))
                imgui.PushStyleColor(imgui.Col.Border, imgui.ImVec4(0, 0, 0, 0))

                imgui.Begin('State Helper Bootstrap##overlay', nil, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse)

                local draw_list = imgui.GetWindowDrawList()
                local wpos = imgui.GetWindowPos()
                local wsize = imgui.GetWindowSize()

                local function get_rgb(shift)
                    local r = math.floor(math.sin(now * 0.9 + shift) * 127 + 128) / 255
                    local g = math.floor(math.sin(now * 0.9 + shift + 2) * 127 + 128) / 255
                    local b = math.floor(math.sin(now * 0.9 + shift + 4) * 127 + 128) / 255
                    return imgui.ImVec4(r, g, b, 0.85)
                end

                draw_list:AddRectFilled(imgui.ImVec2(wpos.x + 3, wpos.y + 3), imgui.ImVec2(wpos.x + wsize.x - 3, wpos.y + wsize.y - 3), imgui.GetColorU32Vec4(imgui.ImVec4(0.07, 0.07, 0.07, 1.00)), 16)
                draw_list:AddRect(imgui.ImVec2(wpos.x + 2, wpos.y + 2), imgui.ImVec2(wpos.x + wsize.x - 2, wpos.y + wsize.y - 2), imgui.GetColorU32Vec4(get_rgb(0)), 16, 15, 2.5)

                imgui.SetCursorPos(imgui.ImVec2(35, 22))
                imgui.SetWindowFontScale(1.6)
                imgui.PushStyleColor(imgui.Col.Text, get_rgb(1))
                imgui.TextUnformatted(sh_entry_u8('State Helper'))
                imgui.PopStyleColor(1)
                imgui.SetWindowFontScale(1.0) 

                imgui.SetCursorPos(imgui.ImVec2(35, 58))
                imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1, 1, 1, 0.9))
                imgui.TextUnformatted(sh_entry_u8(sh_entry_bootstrap_overlay.status_text))
                imgui.PopStyleColor(1)

                imgui.SetCursorPos(imgui.ImVec2(35, 80))
                imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.5, 0.5, 0.5, 1.0))
                imgui.SetWindowFontScale(0.9)
                imgui.TextUnformatted(sh_entry_u8(sh_entry_bootstrap_overlay.detail_text))
                imgui.SetWindowFontScale(1.0)
                imgui.PopStyleColor(1)

                if sh_entry_bootstrap_overlay.mode ~= 'done' then
                    local prc_v = math.floor(sh_entry_bootstrap_overlay.progress * 100 + 0.5)
                    local prc_s = tostring(prc_v) .. '%%'
                    local psz = imgui.CalcTextSize((prc_s:gsub('%%%%', '%%')))
                    
                    imgui.SetCursorPos(imgui.ImVec2(overlay_width - 35 - psz.x, 58))
                    imgui.SetWindowFontScale(1.1)
                    imgui.PushStyleColor(imgui.Col.Text, get_rgb(2))
                    imgui.Text(prc_s) 
                    imgui.PopStyleColor(1)
                    imgui.SetWindowFontScale(1.0)
                end

                sh_entry_bootstrap_overlay_draw_progress_bar(draw_list, wpos.x + 35, wpos.y + 108, overlay_width - 70, 12, sh_entry_bootstrap_overlay.progress)

                imgui.End()
                imgui.PopStyleColor(2)
                imgui.PopStyleVar(2)
            end
        )

        imgui.OnFrame(
            function()
                return sh_entry_project_selector.active
            end,
            function(main)
                main.HideCursor = false
                sh_entry_project_selector_ensure_textures()

                local io = imgui.GetIO()
                local display = io.DisplaySize
                local w, h = 478, 244
                local accent_blue = imgui.ImVec4(0.12, 0.63, 1.00, 1.00)
                local accent_red = imgui.ImVec4(1.00, 0.27, 0.30, 1.00)
                local accent_green = imgui.ImVec4(0.12, 0.83, 0.40, 1.00)
                local selector_center_y = math.min(display.y - (h * 0.5) - 18, display.y * 0.74)
                local now = os.clock()

                imgui.SetNextWindowPos(imgui.ImVec2(display.x * 0.5, selector_center_y), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
                imgui.SetNextWindowSize(imgui.ImVec2(w, h), imgui.Cond.Always)
                imgui.PushStyleVarFloat(imgui.StyleVar.WindowRounding, 16)
                imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(0, 0))
                imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
                imgui.PushStyleColor(imgui.Col.Border, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
                imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.95, 0.95, 0.95, 1.00))

                if type(imgui.GetForegroundDrawList) == 'function' then
                    local fg = imgui.GetForegroundDrawList()
                    fg:AddRectFilled(
                        imgui.ImVec2(0, 0),
                        imgui.ImVec2(display.x, display.y),
                        imgui.GetColorU32Vec4(imgui.ImVec4(0.00, 0.00, 0.00, 0.22))
                    )
                end

                imgui.Begin('ProjectSelect##sh', nil, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse)

                local draw_list = imgui.GetWindowDrawList()
                local wpos = imgui.GetWindowPos()
                local wsize = imgui.GetWindowSize()

                local function get_rgb(shift)
                    local r = math.floor(math.sin(now * 0.9 + shift) * 127 + 128) / 255
                    local g = math.floor(math.sin(now * 0.9 + shift + 2) * 127 + 128) / 255
                    local b = math.floor(math.sin(now * 0.9 + shift + 4) * 127 + 128) / 255
                    return imgui.ImVec4(r, g, b, 0.85)
                end

                draw_list:AddRectFilled(
                    imgui.ImVec2(wpos.x + 3, wpos.y + 3),
                    imgui.ImVec2(wpos.x + wsize.x - 3, wpos.y + wsize.y - 3),
                    imgui.GetColorU32Vec4(imgui.ImVec4(0.07, 0.07, 0.07, 1.00)),
                    16
                )
                draw_list:AddRect(
                    imgui.ImVec2(wpos.x + 2, wpos.y + 2),
                    imgui.ImVec2(wpos.x + wsize.x - 2, wpos.y + wsize.y - 2),
                    imgui.GetColorU32Vec4(get_rgb(0)),
                    16,
                    15,
                    2.5
                )

                local title = 'ВЫБОР ПРОЕКТА'
                imgui.SetWindowFontScale(1.12)
                local title_size = imgui.CalcTextSize(sh_entry_u8(title))
                imgui.SetWindowFontScale(1.0)
                imgui.SetCursorPos(imgui.ImVec2((wsize.x - title_size.x * 1.12) * 0.5, 22))
                imgui.SetWindowFontScale(1.12)
                imgui.PushStyleColor(imgui.Col.Text, get_rgb(1))
                imgui.TextUnformatted(sh_entry_u8(title))
                imgui.PopStyleColor(1)
                imgui.SetWindowFontScale(1.0)

                draw_list:AddLine(
                    imgui.ImVec2(wpos.x + 46, wpos.y + 54),
                    imgui.ImVec2(wpos.x + wsize.x - 46, wpos.y + 54),
                    imgui.GetColorU32Vec4(imgui.ImVec4(0.22, 0.22, 0.22, 1.00)),
                    1.0
                )

                local subtitle = 'Выберите площадку для установки и запуска хелпера'
                imgui.SetCursorPos(imgui.ImVec2(0, 56))
                imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.62, 0.62, 0.64, 1.00))
                imgui.SetWindowFontScale(0.92)
                local subtitle_size = imgui.CalcTextSize(sh_entry_u8(subtitle))
                imgui.SetCursorPos(imgui.ImVec2((wsize.x - subtitle_size.x * 0.92) * 0.5, 56))
                imgui.TextUnformatted(sh_entry_u8(subtitle))
                imgui.SetWindowFontScale(1.0)
                imgui.PopStyleColor(1)

                local card_width = 194
                local card_height = 126
                local card_y = 86
                local gap = 18
                local total_width = card_width * 2 + gap
                local start_x = (wsize.x - total_width) * 0.5

                local function get_card_status(project_name)
                    local state = sh_entry_project_selector.download_state[project_name]
                    if sh_entry_project_selector.textures[project_name] ~= nil then
                        return nil
                    end
                    if state == 'downloading' then
                        return 'Загрузка логотипа...'
                    end
                    if state == 'failed' then
                        return 'Повторная загрузка...'
                    end
                    return 'Подготовка...'
                end

                local function draw_project_card(project_name, display_name, accent_color, texture, offset_x)
                    local local_pos = imgui.ImVec2(start_x + offset_x, card_y)
                    local card_offset_y = 0
                    imgui.SetCursorPos(imgui.ImVec2(local_pos.x, local_pos.y + card_offset_y))
                    if imgui.InvisibleButton('##project_card_' .. project_name, imgui.ImVec2(card_width, card_height)) then
                        sh_entry_project_selector.chosen = project_name
                        sh_entry_project_selector.active = false
                    end

                    local hovered = imgui.IsItemHovered()
                    local active = imgui.IsItemActive()
                    card_offset_y = hovered and -2 or 0
                    if active then
                        card_offset_y = 0
                    end
                    if card_offset_y ~= 0 then
                        imgui.SetCursorPos(imgui.ImVec2(local_pos.x, local_pos.y + card_offset_y))
                        imgui.InvisibleButton('##project_card_visual_' .. project_name, imgui.ImVec2(card_width, card_height))
                    end

                    local card_min = imgui.GetItemRectMin()
                    local card_max = imgui.GetItemRectMax()
                    local card_bg = hovered and imgui.ImVec4(0.17, 0.17, 0.17, 1.00) or imgui.ImVec4(0.13, 0.13, 0.13, 1.00)
                    local card_inner_bg = hovered and imgui.ImVec4(0.20, 0.21, 0.22, 1.00) or imgui.ImVec4(0.16, 0.17, 0.18, 1.00)
                    local card_status = get_card_status(project_name)
                    local dl = draw_list
                    local outer_rounding = 12
                    local inner_rounding = 9
                    local outer_border_color = hovered
                        and imgui.ImVec4(accent_color.x, accent_color.y, accent_color.z, 0.58)
                        or imgui.ImVec4(0.31, 0.31, 0.31, 1.00)
                    local inner_border_color = hovered
                        and imgui.ImVec4(accent_color.x, accent_color.y, accent_color.z, 0.24)
                        or imgui.ImVec4(0.25, 0.25, 0.25, 1.00)

                    if active then
                        card_bg = imgui.ImVec4(card_bg.x + 0.04, card_bg.y + 0.04, card_bg.z + 0.04, 1.00)
                        card_inner_bg = imgui.ImVec4(card_inner_bg.x + 0.04, card_inner_bg.y + 0.04, card_inner_bg.z + 0.04, 1.00)
                    end

                    if hovered then
                        dl:AddRectFilled(
                            imgui.ImVec2(card_min.x - 5, card_min.y - 5),
                            imgui.ImVec2(card_max.x + 5, card_max.y + 5),
                            imgui.GetColorU32Vec4(imgui.ImVec4(accent_color.x, accent_color.y, accent_color.z, 0.06)),
                            outer_rounding + 3
                        )
                        dl:AddRect(
                            imgui.ImVec2(card_min.x - 4, card_min.y - 4),
                            imgui.ImVec2(card_max.x + 4, card_max.y + 4),
                            imgui.GetColorU32Vec4(imgui.ImVec4(accent_color.x, accent_color.y, accent_color.z, 0.42)),
                            outer_rounding + 2,
                            15,
                            1.8
                        )
                    end

                    dl:AddRectFilled(
                        card_min,
                        card_max,
                        imgui.GetColorU32Vec4(card_bg),
                        outer_rounding
                    )
                    dl:AddRect(
                        card_min,
                        card_max,
                        imgui.GetColorU32Vec4(outer_border_color),
                        outer_rounding,
                        15,
                        1.6
                    )

                    dl:AddRectFilled(
                        imgui.ImVec2(card_min.x + 6, card_min.y + 6),
                        imgui.ImVec2(card_max.x - 6, card_max.y - 6),
                        imgui.GetColorU32Vec4(card_inner_bg),
                        inner_rounding
                    )
                    dl:AddRect(
                        imgui.ImVec2(card_min.x + 6, card_min.y + 6),
                        imgui.ImVec2(card_max.x - 6, card_max.y - 6),
                        imgui.GetColorU32Vec4(inner_border_color),
                        inner_rounding,
                        15,
                        1.0
                    )

                    dl:AddRectFilled(
                        imgui.ImVec2(card_min.x + 12, card_min.y + 12),
                        imgui.ImVec2(card_max.x - 12, card_min.y + 74),
                        imgui.GetColorU32Vec4(imgui.ImVec4(accent_color.x, accent_color.y, accent_color.z, hovered and 0.08 or 0.03)),
                        9
                    )
                    dl:AddRectFilled(
                        imgui.ImVec2(card_min.x + 12, card_max.y - 8),
                        imgui.ImVec2(card_max.x - 12, card_max.y - 3),
                        imgui.GetColorU32Vec4(accent_color),
                        4
                    )

                    if texture ~= nil then
                        local meta = sh_entry_project_selector.texture_meta[project_name] or {}
                        local uv_min = meta.uv_min or imgui.ImVec2(0, 0)
                        local uv_max = meta.uv_max or imgui.ImVec2(1, 1)
                        local source_width = tonumber(meta.width) or 1
                        local source_height = tonumber(meta.height) or 1
                        local visible_width = math.max(1, source_width * math.abs(uv_max.x - uv_min.x))
                        local visible_height = math.max(1, source_height * math.abs(uv_max.y - uv_min.y))
                        local max_w, max_h = 148, 58
                        local scale = math.min(max_w / visible_width, max_h / visible_height)
                        local image_width = visible_width * scale
                        local image_height = visible_height * scale
                        local image_x = card_min.x + (card_width - image_width) * 0.5
                        local image_y = card_min.y + 16
                        dl:AddImage(
                            texture,
                            imgui.ImVec2(image_x, image_y),
                            imgui.ImVec2(image_x + image_width, image_y + image_height),
                            uv_min,
                            uv_max
                        )
                    else
                        local fallback_text = project_name == 'Arizona' and 'AZ' or 'RD'
                        imgui.SetCursorPos(imgui.ImVec2(local_pos.x + 62, local_pos.y + 22 + card_offset_y))
                        imgui.SetWindowFontScale(1.75)
                        imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(accent_color.x, accent_color.y, accent_color.z, hovered and 1.00 or 0.88))
                        imgui.TextUnformatted(fallback_text)
                        imgui.PopStyleColor(1)
                        imgui.SetWindowFontScale(1.0)
                    end

                    local label_y = texture ~= nil and 82 or 82
                    imgui.SetCursorPos(imgui.ImVec2(local_pos.x, local_pos.y + label_y + card_offset_y))
                    local label_size = imgui.CalcTextSize(sh_entry_u8(display_name))
                    imgui.SetCursorPos(imgui.ImVec2(local_pos.x + (card_width - label_size.x) * 0.5, local_pos.y + label_y + card_offset_y))
                    imgui.PushStyleColor(imgui.Col.Text, hovered and imgui.ImVec4(1.00, 1.00, 1.00, 1.00) or imgui.ImVec4(0.92, 0.92, 0.92, 1.00))
                    imgui.TextUnformatted(sh_entry_u8(display_name))
                    imgui.PopStyleColor(1)

                    if card_status ~= nil then
                        imgui.SetWindowFontScale(0.80)
                        local status_size = imgui.CalcTextSize(sh_entry_u8(card_status))
                        imgui.SetCursorPos(imgui.ImVec2(local_pos.x + (card_width - status_size.x * 0.80) * 0.5, local_pos.y + 101 + card_offset_y))
                        imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.62, 0.62, 0.66, 1.00))
                        imgui.TextUnformatted(sh_entry_u8(card_status))
                        imgui.PopStyleColor(1)
                        imgui.SetWindowFontScale(1.0)
                    elseif hovered then
                        local hover_text = 'Нажмите для выбора'
                        imgui.SetWindowFontScale(0.80)
                        local hover_size = imgui.CalcTextSize(sh_entry_u8(hover_text))
                        imgui.SetCursorPos(imgui.ImVec2(local_pos.x + (card_width - hover_size.x * 0.80) * 0.5, local_pos.y + 101 + card_offset_y))
                        imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(accent_color.x, accent_color.y, accent_color.z, 0.92))
                        imgui.TextUnformatted(sh_entry_u8(hover_text))
                        imgui.PopStyleColor(1)
                        imgui.SetWindowFontScale(1.0)
                    end
                end

                draw_project_card(
                    'Arizona',
                    'ARIZONA RP',
                    accent_blue,
                    sh_entry_project_selector.textures.Arizona,
                    0
                )
                draw_project_card(
                    'Rodina',
                    'RODINA RP',
                    accent_red,
                    sh_entry_project_selector.textures.Rodina,
                    card_width + gap
                )

                imgui.End()
                imgui.PopStyleColor(3)
                imgui.PopStyleVar(2)
            end
        )
    end
end

local function sh_entry_shorten_relative_path(relative_path)
    local normalized = tostring(relative_path or ''):gsub('\\', '/')
    if #normalized <= 46 then
        return normalized
    end

    return '...' .. normalized:sub(-43)
end

local function sh_entry_install_progress(index, total)
    if total <= 0 then
        return 0.08
    end

    return 0.08 + (index / total) * 0.84
end

local function sh_entry_join_url_path(...)
    local parts = { ... }
    local normalized = {}
    for _, part in ipairs(parts) do
        if part and part ~= '' then
            normalized[#normalized + 1] = tostring(part):gsub('\\', '/'):gsub('^/+', ''):gsub('/+$', '')
        end
    end
    return table.concat(normalized, '/')
end

local function sh_entry_url_encode_path(path)
    return tostring(path):gsub(' ', '%%20')
end

local function sh_entry_get_raw_url(relative_path)
    local base_url = rawget(_G, 'SH_REPO_RAW_BASE_URL')
    if type(base_url) ~= 'string' or base_url == '' then
        base_url = string.format(
            'https://raw.githubusercontent.com/%s/%s/%s',
            REMOTE.owner,
            REMOTE.repo,
            REMOTE.branch
        )
    end

    return base_url .. '/' .. sh_entry_url_encode_path(relative_path)
end

local function sh_entry_get_project_file_url(relative_path)
    return sh_entry_get_raw_url(sh_entry_join_url_path(REMOTE.project_root, relative_path))
end

local function sh_entry_notify(message)
    local chat_fn = rawget(_G, 'sampAddChatMessage')
    if type(chat_fn) == 'function' then
        local ok = pcall(chat_fn, '[SH] {FFFFFF}' .. tostring(message), 0x23E64A)
        if ok then
            return
        end
    end
    print('[StateHelper] ' .. tostring(message))
end

local function sh_entry_notify_error(message)
    local chat_fn = rawget(_G, 'sampAddChatMessage')
    if type(chat_fn) == 'function' then
        local ok = pcall(chat_fn, '[SH] {FFFFFF}' .. tostring(message), 0xFF5345)
        if ok then
            return
        end
    end
    print('[StateHelper][ERROR] ' .. tostring(message))
end

local function sh_entry_schedule_reload()
    local script = thisScript()
    if script and type(script.reload) == 'function' then
        script:reload()
        return true
    end
    return false
end

local function sh_entry_normalize_fs_path(path)
    return tostring(path or ''):gsub('/', '\\')
end

local function sh_entry_ensure_dir_recursive(path)
    local normalized = sh_entry_normalize_fs_path(path)
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

local function sh_entry_safe_remove(path)
    if doesFileExist(path) then
        os.remove(path)
    end
end

local function sh_entry_read_file(path, mode)
    local file = io.open(path, mode or 'rb')
    if not file then
        return nil
    end

    local content = file:read('*a')
    file:close()
    return content
end

local function sh_entry_write_file(path, content, mode)
    local parent_dir = path:match('^(.*)[/\\][^/\\]+$')
    if parent_dir then
        sh_entry_ensure_dir_recursive(parent_dir)
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

local function sh_entry_load_project_choice()
    local content = sh_entry_read_file(sh_entry_project_choice_path, 'r')
    if content then
        local trimmed = content:match('^%s*(.-)%s*$')
        if trimmed == 'Arizona' or trimmed == 'Rodina' then
            return trimmed
        end
    end
    return nil
end

local function sh_entry_save_project_choice(choice)
    sh_entry_write_file(sh_entry_project_choice_path, tostring(choice), 'w')
end

local function sh_entry_has_install_lock()
    return doesFileExist(install_lock_path)
end

local function sh_entry_set_install_lock(state_text)
    return sh_entry_write_file(install_lock_path, tostring(state_text or 'installing'), 'wb')
end

local function sh_entry_clear_install_lock()
    sh_entry_safe_remove(install_lock_path)
end

local function sh_entry_try_rename(source_path, destination_path, attempts)
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

local function sh_entry_try_read_file(path, mode, attempts)
    local total_attempts = attempts or 20
    for attempt = 1, total_attempts do
        local content = sh_entry_read_file(path, mode)
        if content ~= nil then
            return content
        end

        if attempt < total_attempts then
            wait(0)
        end
    end

    return nil
end

local function sh_entry_replace_file(source_path, destination_path)
    local rename_ok = sh_entry_try_rename(source_path, destination_path)
    if rename_ok then
        return true
    end

    local content = sh_entry_try_read_file(source_path, 'rb')
    if content == nil then
        return false
    end

    local write_ok = sh_entry_write_file(destination_path, content, 'wb')
    if not write_ok or not doesFileExist(destination_path) then
        return false
    end

    sh_entry_safe_remove(source_path)
    return true
end

local function sh_entry_download_to_file_sync(url, destination_path)
    local destination_dir = destination_path:match('^(.*)[/\\][^/\\]+$')
    if destination_dir then
        sh_entry_ensure_dir_recursive(destination_dir)
    end

    local tmp_path = destination_path .. '.tmp'
    local backup_path = destination_path .. '.bak'
    local done = false
    local success = false
    local reason = 'download_error'
    local download_completed = false
    local download_failed = false

    sh_entry_safe_remove(tmp_path)

    downloadUrlToFile(url, tmp_path, function(_, status)
        if sh_entry_is_download_complete(status) then
            download_completed = true
        elseif sh_entry_is_download_error(status) then
            download_failed = true
        end
    end)

    while not done do
        if download_completed then
            local had_original = doesFileExist(destination_path)

            if had_original then
                sh_entry_safe_remove(backup_path)
                local backup_ok = sh_entry_try_rename(destination_path, backup_path)
                if not backup_ok or doesFileExist(destination_path) then
                    sh_entry_safe_remove(tmp_path)
                    success = false
                    reason = 'backup_failed'
                    done = true
                else
                    local replace_ok = sh_entry_replace_file(tmp_path, destination_path)
                    if replace_ok then
                        sh_entry_safe_remove(backup_path)
                        success = true
                        reason = nil
                    else
                        sh_entry_safe_remove(tmp_path)
                        sh_entry_safe_remove(destination_path)
                        if doesFileExist(backup_path) and not doesFileExist(destination_path) then
                            sh_entry_try_rename(backup_path, destination_path)
                        end
                        success = false
                        reason = 'rename_failed'
                    end

                    done = true
                end
            else
                local replace_ok = sh_entry_replace_file(tmp_path, destination_path)
                if replace_ok then
                    success = true
                    reason = nil
                else
                    sh_entry_safe_remove(tmp_path)
                    sh_entry_safe_remove(destination_path)
                    success = false
                    reason = 'rename_failed'
                end

                done = true
            end
        elseif download_failed then
            sh_entry_safe_remove(tmp_path)
            success = false
            reason = 'download_error'
            done = true
        end

        wait(0)
    end

    return success, reason
end

local function sh_entry_install_required()
    if not sh_entry_selected_project then
        return true
    end
    local bp = sh_entry_selected_project .. '_bootstrap'
    local required_paths = {
        root_dir .. '\\bootstrap\\updater.lua',
        root_dir .. '\\' .. bp .. '\\loader.lua',
        root_dir .. '\\' .. bp .. '\\manifest.lua',
        root_dir .. '\\Arizona_bootstrap\\updater.lua',
        root_dir .. '\\core\\app.lua',
        root_dir .. '\\core\\context.lua',
        root_dir .. '\\core\\version.lua',
        root_dir .. '\\core\\paths.lua',
        root_dir .. '\\core\\runtime_compat_prelude.lua',
        root_dir .. '\\' .. bp .. '\\runtime_manifest.lua',
        root_dir .. '\\core\\runtime_prelude.lua',
        root_dir .. '\\core\\ui_root.lua',
        root_dir .. '\\core\\runtime_after_commands.lua',
        root_dir .. '\\core\\runtime_post_init.lua',
        root_dir .. '\\features\\settings\\settings_core.lua',
        root_dir .. '\\features\\commands\\custom_commands.lua',
        root_dir .. '\\features\\commands\\default_command_loader.lua',
    }

    for _, path in ipairs(required_paths) do
        if not doesFileExist(path) then
            return true
        end
    end

    return false
end

local function sh_entry_fetch_remote_manifest()
    local bp = sh_entry_selected_project .. '_bootstrap'
    local remote_manifest_path = 'StateHelper/' .. bp .. '/manifest.lua'
    local local_manifest_path = root_dir .. '\\' .. bp .. '\\manifest.lua'
    local ok, reason = sh_entry_download_to_file_sync(sh_entry_get_raw_url(remote_manifest_path), local_manifest_path)
    if not ok then
        return false, 'manifest_download_failed:' .. tostring(reason)
    end

    local manifest_source = sh_entry_read_file(local_manifest_path, 'rb')
    if not manifest_source then
        return false, 'manifest_open_failed'
    end

    local chunk, load_err = loadstring(manifest_source, '@StateHelper.remote_manifest')
    if not chunk then
        return false, 'manifest_load_failed:' .. tostring(load_err)
    end

    local eval_ok, remote_manifest = pcall(chunk)
    if not eval_ok or type(remote_manifest) ~= 'table' then
        return false, 'manifest_eval_failed'
    end

    return true, remote_manifest
end

local function sh_entry_collect_install_files(remote_manifest)
    local files = {}
    local index = remote_manifest.sh_bootstrap_manifest_collect_file_index({
        sections = {
            bootstrap = true,
            core = true,
            features = true,
            factions = true,
            mechanics = true,
            data = true,
        }
    }) or {}

    for _, item in ipairs(index) do
        files[#files + 1] = item.path
    end

    files[#files + 1] = 'update_info.json'
    return files
end

local function sh_entry_store_managed_index(files)
    local managed_paths = {}
    local seen = {}

    managed_paths[#managed_paths + 1] = sh_entry_normalize_fs_path(thisScript().path)
    for _, relative_path in ipairs(files or {}) do
        local absolute_path = sh_entry_normalize_fs_path(root_dir .. '\\' .. tostring(relative_path):gsub('/', '\\'))
        if not seen[absolute_path] then
            seen[absolute_path] = true
            managed_paths[#managed_paths + 1] = absolute_path
        end
    end

    table.sort(managed_paths)
    local index_path = root_dir .. '\\' .. (sh_entry_selected_project or 'Arizona') .. '_data\\installed\\managed_files.lst'
    local payload = table.concat(managed_paths, '\n')
    if payload ~= '' then
        payload = payload .. '\n'
    end

    return sh_entry_write_file(index_path, payload, 'wb')
end

local function sh_entry_install_project()
    local bp = sh_entry_selected_project .. '_bootstrap'
    local dp = sh_entry_selected_project .. '_data'
    sh_entry_ensure_dir_recursive(root_dir)
    sh_entry_ensure_dir_recursive(root_dir .. '\\' .. bp)
    sh_entry_ensure_dir_recursive(root_dir .. '\\' .. dp .. '\\cache')
    sh_entry_set_install_lock('installing')

    sh_entry_bootstrap_overlay_set_status(
        'Сейчас загрузим функционал хелпера.',
        'Получаем список файлов проекта.',
        0.05
    )

    local manifest_ok, remote_manifest = sh_entry_fetch_remote_manifest()
    if not manifest_ok then
        return false, remote_manifest
    end

    local files = sh_entry_collect_install_files(remote_manifest)
    sh_entry_bootstrap_overlay_set_status(
        'Загружаем функционал хелпера.',
        string.format('Подготовлено файлов: %d', #files),
        0.08
    )

    for index, relative_path in ipairs(files) do
        local destination_path = root_dir .. '\\' .. relative_path:gsub('/', '\\')
        local url = sh_entry_get_project_file_url(relative_path)
        local ok, reason = sh_entry_download_to_file_sync(url, destination_path)
        if not ok then
            return false, string.format('file_download_failed:%s:%s', relative_path, tostring(reason))
        end

        sh_entry_bootstrap_overlay_set_status(
            'Загружаем функционал хелпера.',
            string.format('%d/%d  %s', index, #files, sh_entry_shorten_relative_path(relative_path)),
            sh_entry_install_progress(index, #files)
        )
    end

    sh_entry_store_managed_index(files)
    sh_entry_clear_install_lock()

    return true
end

local function sh_entry_start_loader()
    local bp_module = 'StateHelper.' .. sh_entry_selected_project .. '_bootstrap.loader'
    SH_ACTIVE_PROJECT = sh_entry_selected_project
    local ok, loader = pcall(require, bp_module)
    if not ok then
        error('Failed to load ' .. bp_module .. ': ' .. tostring(loader))
    end

    return loader.start({
        script_dir = script_dir,
        root_dir = root_dir,
        entry_script = thisScript().path,
    })
end

sh_entry_selected_project = sh_entry_load_project_choice()
if sh_entry_selected_project then
    install_lock_path = root_dir .. '\\' .. sh_entry_selected_project .. '_data\\cache\\bootstrap_install.lock'
end

local bootstrap_recovery_needed = sh_entry_has_install_lock()
if not bootstrap_recovery_needed and not sh_entry_install_required() then
    return sh_entry_start_loader()
end

if not sh_entry_bootstrap_overlay.available then
    if bootstrap_recovery_needed then
        sh_entry_notify('Detected interrupted bootstrap install. Resuming installation and repair...')
    else
        sh_entry_notify('StateHelper local structure was not found. Starting bootstrap install...')
        sh_entry_notify('Please wait until installation finishes. Do not press Ctrl+R while files are downloading.')
    end
end

local sh_entry_install_finished = false
local sh_entry_samp_connected = false

-- Поток 1: показываем оверлей после спавна (если установка ещё не завершена)
lua_thread.create(function()
    local samp_gamestate_fn = rawget(_G, 'sampGetGamestate')
    local samp_spawned_fn = rawget(_G, 'sampIsLocalPlayerSpawned')

    if type(samp_spawned_fn) == 'function' then
        while not sh_entry_install_finished do
            local gamestate_ok = type(samp_gamestate_fn) ~= 'function' or (pcall(samp_gamestate_fn) and samp_gamestate_fn() == 3)
            local spawned_ok, spawned = pcall(samp_spawned_fn)
            if gamestate_ok and spawned_ok and spawned and sh_entry_samp_connected then
                break
            end
            wait(500)
        end
    end

    if not sh_entry_install_finished and sh_entry_bootstrap_overlay.available and not sh_entry_project_selector.active then
        local now = os.clock()
        sh_entry_bootstrap_overlay.active = true
        sh_entry_bootstrap_overlay.mode = 'loading'
        sh_entry_bootstrap_overlay.phase_started_at = now
        sh_entry_bootstrap_overlay.last_frame_at = now
        sh_entry_bootstrap_overlay.title = 'State Helper'
        sh_entry_bootstrap_overlay.reset_position = true
        sh_entry_bootstrap_overlay.imgui.Process = true
    end
end)

-- Поток 2: ждёт подключения SAMP (gamestate == 3), затем запускает установку
lua_thread.create(function()
    local samp_gamestate_fn = rawget(_G, 'sampGetGamestate')

    if type(samp_gamestate_fn) == 'function' then
        while true do
            local ok, state = pcall(samp_gamestate_fn)
            if ok and state == 3 then
                break
            end
            wait(500)
        end
    end

    sh_entry_samp_connected = true

    if not sh_entry_selected_project then
        if sh_entry_bootstrap_overlay.available then
            sh_entry_bootstrap_overlay.imgui.Process = true
            sh_entry_project_selector.active = true
            while not sh_entry_project_selector.chosen do
                wait(50)
            end
        else
            -- imgui недоступен — по умолчанию Arizona
            sh_entry_project_selector.chosen = 'Arizona'
        end
        sh_entry_selected_project = sh_entry_project_selector.chosen
        pcall(sh_entry_project_selector_release_textures)
        sh_entry_save_project_choice(sh_entry_selected_project)
        install_lock_path = root_dir .. '\\' .. sh_entry_selected_project .. '_data\\cache\\bootstrap_install.lock'
    end

    -- Активируем оверлей перед установкой (если ещё не активен)
    if sh_entry_bootstrap_overlay.available and not sh_entry_bootstrap_overlay.active then
        local now = os.clock()
        sh_entry_bootstrap_overlay.active = true
        sh_entry_bootstrap_overlay.mode = 'greeting'
        sh_entry_bootstrap_overlay.phase_started_at = now
        sh_entry_bootstrap_overlay.last_frame_at = now
        sh_entry_bootstrap_overlay.title = 'State Helper'
        sh_entry_bootstrap_overlay.status_text = 'Сейчас загрузим функционал хелпера.'
        sh_entry_bootstrap_overlay.detail_text = bootstrap_recovery_needed
            and 'Восстанавливаем установку после прерывания.'
            or 'Подготавливаем локальную структуру проекта.'
        sh_entry_bootstrap_overlay.hold_until = 0
        sh_entry_bootstrap_overlay.reset_position = true
    end

    local ok, result, install_err = pcall(sh_entry_install_project)
    sh_entry_install_finished = true

    local function sh_entry_ensure_overlay_active()
        if not sh_entry_bootstrap_overlay.available then
            return
        end
        if not sh_entry_bootstrap_overlay.active then
            local now = os.clock()
            sh_entry_bootstrap_overlay.active = true
            sh_entry_bootstrap_overlay.mode = 'loading'
            sh_entry_bootstrap_overlay.phase_started_at = now
            sh_entry_bootstrap_overlay.last_frame_at = now
            sh_entry_bootstrap_overlay.title = 'State Helper'
            sh_entry_bootstrap_overlay.reset_position = true
            sh_entry_bootstrap_overlay.imgui.Process = true
        end
    end

    if not ok then
        local headline, detail, technical_reason = sh_entry_build_install_error_message(result)
        sh_entry_ensure_overlay_active()
        sh_entry_bootstrap_overlay_complete(headline, true)
        sh_entry_notify_error('Bootstrap install crashed: ' .. tostring(result))
        return
    end

    if not result then
        local headline, detail, technical_reason = sh_entry_build_install_error_message(install_err)
        sh_entry_ensure_overlay_active()
        sh_entry_bootstrap_overlay_complete(headline, true)
        sh_entry_notify_error('Bootstrap install failed: ' .. tostring(install_err))
        return
    end

    if sh_entry_bootstrap_overlay.active then
        sh_entry_bootstrap_overlay_complete('Готово, сейчас скрипт будет перезагружен, чтобы все элементы зафиксировались.', false)
        wait(sh_entry_bootstrap_overlay.hold_duration_ms)
    else
        sh_entry_notify('Bootstrap install completed. Reloading State Helper...')
    end

    if not sh_entry_schedule_reload() then
        sh_entry_notify('Please reload MoonLoader manually if State Helper does not start automatically.')
    end
end)


