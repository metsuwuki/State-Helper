--[[
Open with encoding: UTF-8
StateHelper/mechanics/jail/smart_punish.lua
]]

local smart_punish = {}

function smart_punish.sh_mech_jail_punish_open(player_id)
    return smart_punish_func(player_id)
end

function smart_punish.sh_mech_jail_punish_send(commands)
    return send_smart_punish_commands(commands)
end

function smart_punish.sh_mech_jail_punish_download_reasons()
    return download_punish_reasons()
end

return smart_punish
