--[[
Open with encoding: UTF-8
StateHelper/mechanics/police/auto_inves.lua
]]

local auto_inves = {}

function auto_inves.sh_mech_police_auto_inves_enabled()
    return setting and setting.police_settings and setting.police_settings.auto_inves or false
end

return auto_inves
