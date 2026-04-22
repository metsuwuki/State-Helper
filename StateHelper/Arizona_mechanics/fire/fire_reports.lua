--[[
Open with encoding: UTF-8
StateHelper/mechanics/fire/fire_reports.lua
]]

local fire_reports = {}

function fire_reports.sh_mech_fire_report_send(text_send, ask_before_send)
    return auto_report_fire(text_send, ask_before_send)
end

return fire_reports
