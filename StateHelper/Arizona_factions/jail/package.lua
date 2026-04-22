--[[
Open with encoding: UTF-8
StateHelper/Arizona_factions/jail/package.lua

Пакет фракции jail.

Назначение:
- описывает jail-пакет
- подключает связанные jail-механики

Роль в архитектуре:
- отделяет тюремный набор команд и механик в самостоятельный faction package
]]

local package_def = { id = 'jail', title = 'Jail', mechanics = { 'jail_smart_punish' } }
function package_def:init(ctx) ctx.logger:info('jail package initialized') end
return package_def
