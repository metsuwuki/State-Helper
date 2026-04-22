--[[
Open with encoding: UTF-8
StateHelper/Arizona_factions/fire_department/package.lua

Пакет фракции fire_department.

Назначение:
- описывает пакет пожарного департамента
- объявляет список механик, которые должны активироваться вместе с фракцией

Роль в архитектуре:
- связывает faction-слой fire_department с отдельными mechanics-модулями
]]

local package_def = { id = 'fire_department', title = 'Fire Department', mechanics = { 'fire_reports' } }
function package_def:init(ctx) ctx.logger:info('fire_department package initialized') end
return package_def
