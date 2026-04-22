--[[
Open with encoding: UTF-8
StateHelper/core/command_registry.lua

Адаптер доступа к реестру команд проекта.

Назначение:
- отдает полный список доступных команд
- отдает категории команд
- запускает перезагрузку дефолтных команд через общий runtime-слой

Роль в архитектуре:
- связующий модуль между feature-слоем команд и текущим форматом хранения `cmd`
- уменьшает количество прямых обращений к глобальным таблицам проекта

Важно:
- модуль должен оставаться тонкой связкой над runtime-данными
- сюда можно переносить дальнейшую централизацию командного реестра
]]

local command_registry = {}

function command_registry.sh_core_cmd_registry_get_all()
    if cmd and cmd[1] then
        return cmd[1]
    end
    return {}
end

function command_registry.sh_core_cmd_registry_get_categories()
    if cmd and cmd[2] then
        return cmd[2]
    end
    return {}
end

function command_registry.sh_core_cmd_registry_reload_defaults()
    return add_cmd_defoult()
end

return command_registry
