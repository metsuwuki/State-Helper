--[[
Open with encoding: UTF-8
StateHelper/features/tracking/tracking.lua
]]

local tracking = {}

function tracking.sh_feature_tracking_toggle(player_id)
    return toggleTracking(player_id)
end

function tracking.sh_feature_tracking_get_target_coordinates()
    return getTargetServerCoordinates()
end

return tracking
