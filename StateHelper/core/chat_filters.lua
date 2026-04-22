--[[
Open with encoding: UTF-8
StateHelper/core/chat_filters.lua

Configurable chat filtering rules kept outside legacy UI/runtime files.
]]

local logger = require('StateHelper.core.logger')

local chat_filters = {}

local FILTER_DEFAULTS = {
    treasure = false,
    hotels = false,
    armor_warehouse = false,
    arms_race = false,
    car_quality = false,
}

local FILTER_RULES = {
    {
        key = 'treasure',
        patterns = {
            'клад',
            'клада',
            'кладом',
            'кладоиск',
            'сокровищ',
            'тайник',
            'сундук',
        },
    },
    {
        key = 'hotels',
        patterns = {
            'отел',
            'гостиниц',
            'проживая в отеле',
            'засел',
            'высел',
            'номер в отеле',
        },
    },
    {
        key = 'armor_warehouse',
        patterns = {
            'списанный бронежилет',
            'списанные бронежилеты',
            'склад списанных бронежилетов',
            'бронежилет',
        },
    },
    {
        key = 'arms_race',
        patterns = {
            'гонка вооружений',
            'гонки вооружений',
            'вооружений',
        },
    },
    {
        key = 'car_quality',
        patterns = {
            'качество на авто',
            'качество авто',
            'качество автомобиля',
            'качество транспорта',
            'состояние транспорта',
            'получил на транспорт',
            'получила на транспорт',
            'качество ',
            'легендарное качество',
            'эпическое качество',
            'редкое качество',
        },
    },
}

local function sh_core_chat_filters_bool(value)
    return value == true
end

function chat_filters.create(options)
    options = options or {}

    local matcher = options.matcher
    local filter_logger = options.logger or logger.create('ChatFilters')
    local debug_enabled = options.debug_enabled
    local api = {}

    local function sh_core_chat_filters_log(message)
        if type(debug_enabled) == 'function' and debug_enabled() then
            filter_logger:info(message)
        end
    end

    function api.normalize_settings(target_setting)
        if type(target_setting) ~= 'table' then
            return
        end

        if type(target_setting.chat_filters) ~= 'table' then
            target_setting.chat_filters = {}
        end

        for key, default_value in pairs(FILTER_DEFAULTS) do
            if target_setting.chat_filters[key] == nil then
                target_setting.chat_filters[key] = default_value
            else
                target_setting.chat_filters[key] = sh_core_chat_filters_bool(target_setting.chat_filters[key])
            end
        end
    end

    function api.is_enabled(target_setting, key)
        api.normalize_settings(target_setting)
        return type(target_setting) == 'table'
            and type(target_setting.chat_filters) == 'table'
            and target_setting.chat_filters[key] == true
    end

    function api.should_filter(target_setting, message, color_hex)
        api.normalize_settings(target_setting)

        if setting.hide_chat ~= true then return false, nil end

        for _, rule in ipairs(FILTER_RULES) do
            if api.is_enabled(target_setting, rule.key) and matcher and matcher.contains and matcher.contains(message, rule.patterns) then
                sh_core_chat_filters_log(string.format(
                    'filtered key=%s color=%s message="%s"',
                    tostring(rule.key),
                    tostring(color_hex),
                    matcher.preview and matcher.preview(message, 140) or tostring(message)
                ))
                return true, rule.key
            end
        end

        return false, nil
    end

    function api.get_defaults()
        local result = {}
        for key, value in pairs(FILTER_DEFAULTS) do
            result[key] = value
        end
        return result
    end

    function api.get_rules()
        local result = {}
        for index, rule in ipairs(FILTER_RULES) do
            result[index] = rule
        end
        return result
    end

    return api
end

return chat_filters
