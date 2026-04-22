--[[
Open with encoding: UTF-8
StateHelper/core/logger.lua
]]

local logger = {}

local LEVEL_WEIGHT = {
    DEBUG = 10,
    INFO = 20,
    WARN = 30,
    ERROR = 40,
}

local function sh_core_logger_normalize_options(prefix_or_options)
    if type(prefix_or_options) == 'table' then
        return {
            prefix = tostring(prefix_or_options.prefix or 'Logger'),
            min_level = tostring(prefix_or_options.min_level or 'INFO'):upper(),
            filter = prefix_or_options.filter,
        }
    end

    return {
        prefix = tostring(prefix_or_options or 'Logger'),
        min_level = 'INFO',
        filter = nil,
    }
end

function logger.create(prefix_or_options)
    local obj = {}
    local options = sh_core_logger_normalize_options(prefix_or_options)

    local function sh_core_logger_should_emit(level, message)
        local current_weight = LEVEL_WEIGHT[tostring(level):upper()] or LEVEL_WEIGHT.INFO
        local minimum_weight = LEVEL_WEIGHT[options.min_level] or LEVEL_WEIGHT.INFO
        if current_weight < minimum_weight then
            return false
        end

        if type(options.filter) == 'function' then
            local ok, allowed = pcall(options.filter, tostring(level):upper(), tostring(message or ''))
            if ok and allowed == false then
                return false
            end
        end

        return true
    end

    local function sh_core_logger_emit(level, message)
        if not sh_core_logger_should_emit(level, message) then
            return
        end

        local text = string.format('[%s][%s] %s', options.prefix, tostring(level):upper(), tostring(message))
        print(text)
    end

    function obj:debug(message)
        sh_core_logger_emit('DEBUG', message)
    end

    function obj:info(message)
        sh_core_logger_emit('INFO', message)
    end

    function obj:warn(message)
        sh_core_logger_emit('WARN', message)
    end

    function obj:error(message)
        sh_core_logger_emit('ERROR', message)
    end

    return obj
end

return logger
