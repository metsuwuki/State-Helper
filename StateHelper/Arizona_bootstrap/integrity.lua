--[[
Open with encoding: UTF-8
StateHelper/Arizona_bootstrap/integrity.lua

Проверки целостности

Назначение:
- проверяет, что скачанные файлы существуют и не пустые
- дает простые защитные проверки для bootstrap-доставки

Роль в архитектуре:
- слой безопасности после загрузки и перед применением обновления

Правила:
- держать проверки небольшими и детерминированными
- не выполнять здесь загрузку
- не оркестрировать здесь процесс обновления
]]

local integrity = {}

function integrity.sh_bootstrap_integrity_verify_file(path, min_bytes)
    if not path or not doesFileExist(path) then
        return false, 'missing'
    end

    local file = io.open(path, 'rb')
    if not file then
        return false, 'open_failed'
    end

    local content = file:read('*a') or ''
    file:close()

    if #content == 0 then
        return false, 'empty'
    end

    if min_bytes and #content < min_bytes then
        return false, 'too_small'
    end

    return true, 'ok'
end

return integrity
