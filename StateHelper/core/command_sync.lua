--[[
Open with encoding: UTF-8
StateHelper/core/command_sync.lua

Keeps default faction command sets in sync with the currently selected org.
]]

local logger = require('StateHelper.core.logger')

local command_sync = {}

local MANAGED_SET_KEYS = {
    'all',
    'hospital',
    'driving_school',
    'government',
    'army',
    'fire_department',
    'jail',
    'police',
    'smi',
}

local function sh_core_command_sync_copy_command(command)
    if type(command) ~= 'table' then
        return nil
    end

    if type(deep_copy) == 'function' then
        local ok, result = pcall(deep_copy, command)
        if ok and type(result) == 'table' then
            return result
        end
    end

    local result = {}
    for key, value in pairs(command) do
        if type(value) == 'table' then
            local nested = {}
            for nested_key, nested_value in pairs(value) do
                nested[nested_key] = nested_value
            end
            result[key] = nested
        else
            result[key] = value
        end
    end
    return result
end

function command_sync.create(options)
    options = options or {}

    local actions = options.actions
    local resolver = options.org_resolver
    local sync_logger = options.logger or logger.create('CommandSync')
    local api = {}

    local function sh_core_command_sync_log(level, message)
        if level == 'warn' then
            sync_logger:warn(message)
        elseif level == 'error' then
            sync_logger:error(message)
        else
            sync_logger:info(message)
        end
    end

    local function sh_core_command_sync_register_command(command_name)
        if not actions or type(actions.register_chat_command) ~= 'function' then
            return
        end

        actions.register_chat_command(command_name, function(argument)
            if type(cmd_start) == 'function' and rawget(_G, 'cmd') and type(cmd[1]) == 'table' then
                for _, command in ipairs(cmd[1]) do
                    if command and command.cmd == command_name then
                        return cmd_start(argument, tostring(command.UID or 0) .. command.cmd)
                    end
                end
            end
        end, 'command_sync')
    end

    function api.sync_current_org(current_setting)
        local numeric_org = type(current_setting) == 'table' and tonumber(current_setting.org) or nil

        if type(current_setting) ~= 'table'
            or numeric_org == nil
            or type(rawget(_G, 'cmd')) ~= 'table'
            or type(cmd[1]) ~= 'table'
            or type(rawget(_G, 'cmd_defoult')) ~= 'table'
            or type(resolver) ~= 'table'
            or type(resolver.sh_core_org_resolve) ~= 'function' then
            return nil
        end

        current_setting.org = numeric_org

        local profile = resolver.sh_core_org_resolve(numeric_org)
        local active_set_keys = { all = true }
        local active_commands_by_name = {}
        local managed_names = {}

        for _, set_key in ipairs(profile.command_sets or {}) do
            active_set_keys[set_key] = true
        end

        for _, set_key in ipairs(MANAGED_SET_KEYS) do
            local source = cmd_defoult[set_key]
            if type(source) == 'table' then
                for _, command in ipairs(source) do
                    if type(command) == 'table' and type(command.cmd) == 'string' and command.cmd ~= '' then
                        managed_names[command.cmd] = true
                        if active_set_keys[set_key] then
                            active_commands_by_name[command.cmd] = sh_core_command_sync_copy_command(command)
                        end
                    end
                end
            end
        end

        if current_setting.new_mc and rawget(_G, 's_na') == 'Phoenix' and type(rawget(_G, 'mc_phoenix')) == 'table' and mc_phoenix.cmd == 'mc' then
            active_commands_by_name.mc = sh_core_command_sync_copy_command(mc_phoenix)
            managed_names.mc = true
        end

        for command_name in pairs(managed_names) do
            if actions and type(actions.unregister_chat_command) == 'function' then
                actions.unregister_chat_command(command_name, 'command_sync_refresh')
            end
        end

        local rebuilt_commands = {}
        local existing_active = {}
        local removed_names = {}
        local added_names = {}

        for _, existing in ipairs(cmd[1]) do
            if type(existing) == 'table' and type(existing.cmd) == 'string' and existing.cmd ~= '' then
                if managed_names[existing.cmd] then
                    local replacement = active_commands_by_name[existing.cmd]
                    if replacement then
                        replacement.UID = existing.UID or replacement.UID
                        replacement.key = existing.key or replacement.key
                        rebuilt_commands[#rebuilt_commands + 1] = replacement
                        existing_active[existing.cmd] = true
                    else
                        removed_names[#removed_names + 1] = existing.cmd
                    end
                else
                    rebuilt_commands[#rebuilt_commands + 1] = existing
                end
            else
                rebuilt_commands[#rebuilt_commands + 1] = existing
            end
        end

        for command_name, replacement in pairs(active_commands_by_name) do
            if not existing_active[command_name] then
                rebuilt_commands[#rebuilt_commands + 1] = replacement
                added_names[#added_names + 1] = command_name
            end
        end

        cmd[1] = rebuilt_commands

        for command_name in pairs(active_commands_by_name) do
            sh_core_command_sync_register_command(command_name)
        end

        if type(add_cmd_in_all_cmd) == 'function' then
            pcall(add_cmd_in_all_cmd)
        end
        if type(save_cmd) == 'function' then
            pcall(save_cmd)
        end

        current_setting.gun_func = profile.gun_func == true

        local should_log_summary = #added_names > 0
            or #removed_names > 0
            or rawget(_G, 'SH_DEBUG_MODE') == true
            or rawget(_G, 'SH_COMMAND_SYNC_DEBUG') == true
            or rawget(_G, 'dev_mode') == true

        if should_log_summary then
            sh_core_command_sync_log('info', string.format(
                'org=%s profile=%s active_sets=%s active_commands=%s added=%s removed=%s',
                tostring(numeric_org),
                tostring(profile.key),
                tostring(#profile.command_sets + 1),
                tostring(#rebuilt_commands),
                tostring(#added_names),
                tostring(#removed_names)
            ))
        end

        return {
            profile = profile,
            added = added_names,
            removed = removed_names,
        }
    end

    return api
end

return command_sync
