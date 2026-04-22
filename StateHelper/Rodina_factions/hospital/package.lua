--[[
Open with encoding: UTF-8
StateHelper/Rodina_factions/hospital/package.lua
]]

local package_def = { id = 'hospital', title = 'Hospital', mechanics = {} }
function package_def:init(ctx) ctx.logger:info('hospital package initialized') end
return package_def
