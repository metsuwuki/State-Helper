--[[
Open with encoding: UTF-8
StateHelper/core/game_actions.lua

Thin executor for common MoonLoader/SAMP actions with consistent logging.
]]

local logger = require('StateHelper.core.logger')

local game_actions = {}

local function sh_core_game_actions_preview(preview_fn, value, limit)
    if type(preview_fn) == 'function' then
        return preview_fn(value, limit)
    end
    if value == nil then
        return ''
    end
    return tostring(value)
end

function game_actions.create(options)
    options = options or {}

    local action_logger = options.logger or logger.create(options.prefix or 'GameActions')
    local preview = options.preview
    local api = {}
    local noisy_reasons = {
        command_sync = true,
        command_sync_refresh = true,
        reload_police_utility_commands = true,
        default_dep_tab_command = true,
        default_sob_tab_command = true,
    }

    local function sh_core_game_actions_debug_enabled()
        return rawget(_G, 'SH_DEBUG_MODE') == true
            or rawget(_G, 'SH_VERBOSE_COMMAND_LOG') == true
            or rawget(_G, 'SH_COMMAND_SYNC_DEBUG') == true
            or rawget(_G, 'dev_mode') == true
    end

    local function sh_core_game_actions_should_log_command_event(reason)
        if sh_core_game_actions_debug_enabled() then
            return true
        end

        return not noisy_reasons[tostring(reason or '')]
    end

    local function sh_core_game_actions_log(level, message)
        if level == 'warn' then
            action_logger:warn(message)
        elseif level == 'error' then
            action_logger:error(message)
        else
            action_logger:info(message)
        end
    end

    function api.log(level, message)
        sh_core_game_actions_log(level, message)
    end

    function api.send_chat(command, reason)
        sh_core_game_actions_log('info', string.format(
            'send chat reason=%s command="%s"',
            tostring(reason),
            sh_core_game_actions_preview(preview, command, 120)
        ))

        if type(sampSendChat) ~= 'function' then
            sh_core_game_actions_log('warn', 'sampSendChat is unavailable')
            return false
        end

        sampSendChat(command)
        return true
    end

    function api.send_dialog_response(id, button_id, list_id, input, reason)
        sh_core_game_actions_log('info', string.format(
            'send dialog response reason=%s id=%s button=%s list=%s input="%s"',
            tostring(reason),
            tostring(id),
            tostring(button_id),
            tostring(list_id),
            sh_core_game_actions_preview(preview, input, 120)
        ))

        if type(sampSendDialogResponse) ~= 'function' then
            sh_core_game_actions_log('warn', 'sampSendDialogResponse is unavailable')
            return false
        end

        sampSendDialogResponse(id, button_id, list_id, input)
        return true
    end

    function api.send_click_textdraw(id, reason)
        sh_core_game_actions_log('info', string.format(
            'send textdraw click reason=%s id=%s',
            tostring(reason),
            tostring(id)
        ))

        if type(sampSendClickTextdraw) ~= 'function' then
            sh_core_game_actions_log('warn', 'sampSendClickTextdraw is unavailable')
            return false
        end

        sampSendClickTextdraw(id)
        return true
    end

    function api.close_dialog(id, button_id, reason)
        sh_core_game_actions_log('info', string.format(
            'close dialog reason=%s id=%s button=%s',
            tostring(reason),
            tostring(id),
            tostring(button_id)
        ))

        if type(closeDialog) ~= 'function' then
            sh_core_game_actions_log('warn', 'closeDialog is unavailable')
            return false
        end

        closeDialog(id, button_id or 0)
        return true
    end

    function api.register_chat_command(name, handler, reason)
        if sh_core_game_actions_should_log_command_event(reason) then
            sh_core_game_actions_log('info', string.format(
                'register command reason=%s name=%s',
                tostring(reason),
                tostring(name)
            ))
        end

        if type(sampRegisterChatCommand) ~= 'function' then
            sh_core_game_actions_log('warn', 'sampRegisterChatCommand is unavailable')
            return false
        end

        sampRegisterChatCommand(name, handler)
        return true
    end

    function api.unregister_chat_command(name, reason)
        if type(sampUnregisterChatCommand) ~= 'function' then
            return false
        end

        if sh_core_game_actions_should_log_command_event(reason) then
            sh_core_game_actions_log('info', string.format(
                'unregister command reason=%s name=%s',
                tostring(reason),
                tostring(name)
            ))
        end

        local ok = pcall(sampUnregisterChatCommand, name)
        if not ok then
            sh_core_game_actions_log('warn', 'failed to unregister command ' .. tostring(name))
        end
        return ok
    end

    return api
end

return game_actions
