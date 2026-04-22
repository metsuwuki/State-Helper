--[[
Open with encoding: UTF-8
StateHelper/mechanics/police/smart_su.lua
]]

local smart_su = {}

function smart_su.sh_mech_police_su_open(player_id)
    return smart_su_func(player_id)
end

function smart_su.sh_mech_police_su_send(commands)
    return send_smart_su_commands(commands)
end

function smart_su.sh_mech_police_su_download_reasons()
    return download_wanted_reasons()
end

return smart_su
