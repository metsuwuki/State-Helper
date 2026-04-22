--[[
Open with encoding: UTF-8
StateHelper/mechanics/common/time_weather.lua
]]

local time_weather = {}

function time_weather.sh_mech_common_time_process(param, mode)
    return processCommand(param, mode)
end

function time_weather.sh_mech_common_time_update()
    return updateTime()
end

function time_weather.sh_mech_common_go_medic_or_fire()
    return go_medic_or_fire()
end

return time_weather
