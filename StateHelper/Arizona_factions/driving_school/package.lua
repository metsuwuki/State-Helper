--[[
Open with encoding: UTF-8
StateHelper/Arizona_factions/driving_school/package.lua

Пакет фракции driving_school.

Назначение:
- описывает метаданные пакета автошколы
- задает точку входа для дальнейшего подключения модулей фракции

Роль в архитектуре:
- позволяет держать команды и расширения автошколы отдельно от других фракций
]]

local package_def = { id = 'driving_school', title = 'Driving School', mechanics = {} }
function package_def:init(ctx) ctx.logger:info('driving_school package initialized') end
return package_def
