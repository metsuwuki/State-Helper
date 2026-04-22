--[[
Open with encoding: UTF-8
StateHelper/Rodina_factions/smi/package.lua

Пакет фракции smi.

Назначение:
- описывает faction package для СМИ
- задает точку расширения для будущих mechanics/инициализации
- держит SMI-логику в faction-слое, а не в core

Роль в архитектуре:
- изолирует smi-команды и логику от остальных фракций
]]

local package_def = { id = 'smi', title = 'SMI', mechanics = {} }
function package_def:init(ctx) ctx.logger:info('smi package initialized') end
return package_def
