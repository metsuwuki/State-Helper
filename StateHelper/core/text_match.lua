--[[
Open with encoding: UTF-8
StateHelper/core/text_match.lua

Shared string helpers for dialog, textdraw, and automation matching.
]]

local text_match = {}

local function sh_core_text_match_safe_text(value)
    if value == nil then
        return ''
    end
    return tostring(value)
end

local function sh_core_text_match_normalize_search(value)
    local text = sh_core_text_match_safe_text(value)
    text = text:gsub('{[%x]+}', '')
    text = text:gsub('[\r\n\t]+', ' ')
    text = text:gsub('%s+', ' ')
    text = text:gsub('Ё', 'Е'):gsub('ё', 'е')
    text = text:lower()
    return text
end

function text_match.create(options)
    options = options or {}

    local cp1251_cache = {}
    local convert_cp1251 = options.convert_cp1251
    local api = {}

    function api.text(value)
        return sh_core_text_match_safe_text(value)
    end

    function api.trim(value)
        return api.text(value):gsub('^%s+', ''):gsub('%s+$', '')
    end

    function api.strip_colors(value)
        return api.text(value):gsub('{[%x]+}', '')
    end

    function api.preview(value, limit)
        local text = api.strip_colors(value):gsub('[\r\n\t]+', ' '):gsub('%s+', ' ')
        limit = tonumber(limit) or 160
        if #text > limit then
            return text:sub(1, limit) .. '...'
        end
        return text
    end

    function api.to_cp1251(value)
        local text = api.text(value)
        if cp1251_cache[text] ~= nil then
            return cp1251_cache[text]
        end

        local converted = text
        if type(convert_cp1251) == 'function' then
            local ok, result = pcall(convert_cp1251, text)
            if ok and result ~= nil then
                converted = tostring(result)
            end
        end

        cp1251_cache[text] = converted
        return converted
    end

    function api.contains(value, needles)
        local source = api.text(value)
        local stripped = api.strip_colors(source)
        local source_normalized = sh_core_text_match_normalize_search(source)
        local stripped_normalized = sh_core_text_match_normalize_search(stripped)

        for _, needle in ipairs(needles or {}) do
            local current = api.to_cp1251(needle)
            local normalized_current = sh_core_text_match_normalize_search(current)
            if source:find(current, 1, true)
                or stripped:find(current, 1, true)
                or source_normalized:find(normalized_current, 1, true)
                or stripped_normalized:find(normalized_current, 1, true) then
                return true
            end
        end

        return false
    end

    function api.collect_lines(text)
        local lines = {}
        for raw_line in api.text(text):gmatch('[^\r\n]+') do
            local clean = api.trim(api.strip_colors(raw_line))
            if clean ~= '' then
                lines[#lines + 1] = {
                    raw = raw_line,
                    clean = clean,
                }
            end
        end
        return lines
    end

    function api.find_row_by_keywords(text, keywords)
        local lines = api.collect_lines(text)
        for index, line in ipairs(lines) do
            if api.contains(line.clean, keywords) then
                return index - 1, line.clean
            end
        end
        return nil, nil
    end

    return api
end

return text_match
