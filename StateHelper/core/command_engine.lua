--[[
Open with encoding: UTF-8
StateHelper/core/command_engine.lua

Адаптер движка команд проекта.

Назначение:
- дает новой структуре стабильную точку входа в исполнение команд
- оборачивает функции запуска и отладки команд

Роль в архитектуре:
- мост между модульным core и runtime-логикой проекта
- уменьшает количество прямых обращений к глобальным функциям

Важно:
- модуль намеренно тонкий
- при дальнейшем рефакторинге сюда удобно переносить новую диспетчеризацию команд
]]

local command_engine = {}

function command_engine.sh_core_cmd_execute(argument, command_name)
    return cmd_start(argument, command_name)
end

function command_engine.sh_core_cmd_start_other(command_name, arguments)
    return start_other_cmd(command_name, arguments)
end

function command_engine.sh_core_cmd_debug(command_name)
    return debugCommandInfo(command_name)
end

return command_engine
