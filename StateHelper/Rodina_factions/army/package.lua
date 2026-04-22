--[[
Open with encoding: UTF-8
StateHelper/Rodina_factions/army/package.lua
]]

local package_def = { id = 'army', title = 'Army', mechanics = {} }
function package_def:init(ctx) ctx.logger:info('army package initialized') end
return package_def
