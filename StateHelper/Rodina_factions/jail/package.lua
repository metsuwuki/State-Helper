--[[
Open with encoding: UTF-8
StateHelper/Rodina_factions/jail/package.lua
]]

local package_def = { id = 'jail', title = 'Jail', mechanics = {} }
function package_def:init(ctx) ctx.logger:info('jail package initialized') end
return package_def
