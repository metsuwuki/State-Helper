--[[
Open with encoding: UTF-8
StateHelper/Arizona_factions/police/package.lua

Пакет фракции police.

Назначение:
- описывает полицейский пакет
- объявляет набор подключаемых police-механик

Роль в архитектуре:
- один из главных узлов faction-слоя
- именно через него police-часть подключает smart su, ticket, wanted и другие механики
]]

local package_def = {
  id = 'police',
  title = 'Police',
  mechanics = {
    'police_smart_su',
    'police_smart_ticket',
    'police_wanted_list',
    'police_ten_codes',
    'police_siren',
    'police_vehicle_data',
    'police_auto_inves',
  }
}
function package_def:init(ctx) ctx.logger:info('police package initialized') end
return package_def
