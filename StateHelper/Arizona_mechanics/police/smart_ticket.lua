--[[
Open with encoding: UTF-8
StateHelper/mechanics/police/smart_ticket.lua
]]

local smart_ticket = {}

function smart_ticket.sh_mech_police_ticket_open(player_id)
    return smart_ticket_func(player_id)
end

function smart_ticket.sh_mech_police_ticket_send(commands)
    return send_smart_ticket_commands(commands)
end

function smart_ticket.sh_mech_police_ticket_download_reasons()
    return download_ticket_reasons()
end

return smart_ticket
