--[[
Open with encoding: UTF-8
StateHelper/Rodina_factions/police/package.lua
]]

local package_def = { id = 'police', title = 'Police', mechanics = {} }
function package_def:init(ctx) ctx.logger:info('police package initialized') end
return package_def
