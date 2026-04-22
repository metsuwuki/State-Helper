--[[
Open with encoding: UTF-8
StateHelper/mechanics/police/vehicle_data.lua
]]

local vehicle_data = {}

function vehicle_data.sh_mech_police_vehicle_check()
    return checkVehicleData()
end

function vehicle_data.sh_mech_police_vehicle_get_nearest_model()
    return getNearestVehicleModel()
end

function vehicle_data.sh_mech_police_vehicle_get_nearest_speed()
    return getNearestVehicleSpeed()
end

function vehicle_data.sh_mech_police_vehicle_get_map_square()
    return getCurrentMapSquare()
end

return vehicle_data
