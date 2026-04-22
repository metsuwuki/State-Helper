--[[
Open with encoding: UTF-8
StateHelper/features/scenes/scene_core.lua
]]

local scene_core = {}

function scene_core.sh_feature_scene_render()
    return scene_work()
end

function scene_core.sh_feature_scene_edit()
    return scene_edit()
end

return scene_core
