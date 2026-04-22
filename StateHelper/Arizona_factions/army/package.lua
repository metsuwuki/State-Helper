--[[
Open with encoding: UTF-8
StateHelper/Arizona_factions/army/package.lua

Пакет фракции army.

Назначение:
- хранит id и заголовок армейского пакета
- задает точку входа для дальнейшей инициализации army-модулей

Роль в архитектуре:
- отделяет армейский набор команд и будущие механики от общего runtime
]]

local package_def = { id = 'army', title = 'Army', mechanics = {} }
function package_def:init(ctx) ctx.logger:info('army package initialized') end
return package_def
