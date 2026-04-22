--[[
Open with encoding: UTF-8
StateHelper/Arizona_factions/common/package.lua

Базовый faction-resolver проекта.

Назначение:
- определяет активную фракцию по organization id игрока
- задает общий вход для faction-пакетов

Роль в архитектуре:
- связующий модуль между текущим игровым состоянием и faction-слоем
- используется для выбора нужного пакета без жесткой привязки к конкретной реализации runtime

Важно:
- именно здесь задается карта org -> faction_id
- при добавлении новых организаций сначала обновляется этот модуль
]]

local package_def = {
    id = 'common',
    title = 'Common',
}

local org_map = {
    hospital = { 1, 2, 3, 4 },
    driving_school = { 5 },
    government = { 6 },
    army = { 7, 8 },
    fire_department = { 9 },
    jail = { 10 },
    police = { 11, 12, 13, 14, 15 },
}

function package_def.resolve_faction_id(current_org)
    local org = current_org
    if org == nil and rawget(_G, 'setting') and type(setting) == 'table' then
        org = setting.org
    end
    org = tonumber(org) or 5

    for faction_id, list in pairs(org_map) do
        for _, value in ipairs(list) do
            if value == org then
                return faction_id
            end
        end
    end

    return 'driving_school'
end

function package_def:init(_) end

return package_def
