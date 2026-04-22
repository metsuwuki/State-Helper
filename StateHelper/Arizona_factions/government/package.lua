--[[
Open with encoding: UTF-8
StateHelper/Arizona_factions/government/package.lua

Пакет фракции government.

Назначение:
- описывает метаданные government-пакета
- задает точку инициализации для модулей правительства

Роль в архитектуре:
- помогает держать government-логику отдельно и подключать ее адресно
]]

local package_def = { id = 'government', title = 'Government', mechanics = {} }
function package_def:init(ctx) ctx.logger:info('government package initialized') end
return package_def
