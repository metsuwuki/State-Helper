--[[
Open with encoding: UTF-8
StateHelper/core/events.lua

Простой внутренний event bus проекта.

Назначение:
- подписывает обработчики на внутренние события
- рассылает payload между независимыми модулями

Роль в архитектуре:
- уменьшает жесткую связанность между частями core, features и mechanics
- служит базовой шиной событий для модульной версии проекта

Важно:
- здесь не должно быть бизнес-логики конкретной фракции
- модуль должен оставаться минимальным и предсказуемым
]]

local events = {}

function events.create()
    local bus = {
        handlers = {}
    }

    function bus:on(event_name, handler)
        self.handlers[event_name] = self.handlers[event_name] or {}
        table.insert(self.handlers[event_name], handler)
    end

    function bus:emit(event_name, payload)
        local list = self.handlers[event_name] or {}
        for _, handler in ipairs(list) do
            handler(payload)
        end
    end

    return bus
end

return events
