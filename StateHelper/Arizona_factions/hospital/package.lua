--[[
Open with encoding: UTF-8
StateHelper/Arizona_factions/hospital/package.lua

Пакет фракции hospital.

Назначение:
- описывает faction-id и заголовок пакета
- резервирует точку инициализации для hospital-модулей

Роль в архитектуре:
- подключается registry/app как самостоятельный faction package
- отделяет hospital-логику от других госструктур
]]

local package_def = { id = 'hospital', title = 'Hospital', mechanics = {} }
function package_def:init(ctx) ctx.logger:info('hospital package initialized') end
return package_def
