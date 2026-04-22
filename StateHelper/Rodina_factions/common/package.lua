--[[
Open with encoding: UTF-8
StateHelper/Rodina_factions/common/package.lua
]]

local package_def = { id = 'common', title = 'Common', mechanics = {} }
function package_def:init(ctx) ctx.logger:info('common package initialized') end
return package_def
