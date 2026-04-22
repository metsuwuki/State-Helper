--[[
Open with encoding: UTF-8
StateHelper/core/registry.lua

Реестр активных частей приложения.

Назначение:
- хранит текущую активную фракцию
- хранит набор подключенных механик
- дает точку расширения для регистрации runtime-сущностей

Роль в архитектуре:
- связующий модуль между bootstrap, factions и mechanics
- помогает приложению понимать, какие пакеты активны в текущем контексте игрока

Важно:
- registry не исполняет игровую логику сам по себе
- его задача хранить и отдавать runtime-состояние подключений
]]

local registry = {}

function registry.create(ctx)
    local obj = {
        ctx = ctx,
        registered_commands = {},
        active_faction = nil,
        active_mechanics = {},
    }

    function obj:set_active_faction(faction_id)
        self.active_faction = faction_id
    end

    function obj:register_mechanic(mechanic_id, mechanic_module)
        self.active_mechanics[mechanic_id] = mechanic_module
    end

    return obj
end

return registry
