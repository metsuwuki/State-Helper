--[[
Open with encoding: UTF-8
StateHelper/mechanics/police/wanted_list.lua
]]

local wanted_list = {}

function wanted_list.sh_mech_police_wanted_render()
    return render_wanted()
end

function wanted_list.sh_mech_police_wanted_refresh()
    return wanted_check()
end

function wanted_list.sh_mech_police_wanted_change_position()
    return changeWantedPosition()
end

return wanted_list
