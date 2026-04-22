--[[
Open with encoding: UTF-8
StateHelper/Rodina_factions/government/package.lua
]]

local package_def = { id = 'government', title = 'Government', mechanics = {} }
function package_def:init(ctx) ctx.logger:info('government package initialized') end
return package_def
