--[[
Open with encoding: UTF-8
StateHelper/core/encoding.lua

Слой безопасной работы со строками и локализацией.

Назначение:
- дает единые helper-функции для utf8/cp1251-строк
- снижает риск падений на `nil`, числах и битых строках

Роль в архитектуре:
- инфраструктурный helper для модулей, где нельзя полагаться на "идеальный" вход

Правила:
- не хранить здесь UI-логику
- не смешивать здесь сетевую или файловую работу
]]

local encoding_core = {}

local function normalize_text(text)
    if text == nil then
        return ''
    end
    if type(text) == 'string' then
        return text
    end
    return tostring(text)
end

function encoding_core.sh_core_encoding_normalize_text(text)
    return normalize_text(text)
end

function encoding_core.sh_core_encoding_utf8(text)
    local normalized = normalize_text(text)
    local ok, value = pcall(u8, normalized)
    return ok and value or normalized
end

function encoding_core.sh_core_encoding_utf8_decode(text)
    local normalized = normalize_text(text)
    local ok, value = pcall(function()
        return u8:decode(normalized)
    end)
    return ok and value or normalized
end

function encoding_core.sh_core_encoding_sex_decode(text)
    return sex_decode(normalize_text(text))
end

return encoding_core
