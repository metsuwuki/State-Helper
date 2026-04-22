--[[
Open with encoding: UTF-8
StateHelper/core/currency.lua
]]

local currency = {}

local BILLION = 1000000000
local MILLION = 1000000
local THOUSAND = 1000

local function trim(value)
    return tostring(value or ''):gsub('^%s+', ''):gsub('%s+$', '')
end

local function parse_decimal_segment(value)
    local normalized = trim(value):upper():gsub('%s+', '')
    if normalized == '' then
        return nil
    end

    if normalized:match('^%d+$') then
        return tonumber(normalized)
    end

    if normalized:match('^%d+%.%d+$') then
        return tonumber(normalized)
    end

    return nil
end

local function round(value)
    if value >= 0 then
        return math.floor(value + 0.5)
    end
    return math.ceil(value - 0.5)
end

local function format_k_segment(value)
    local whole = math.floor(value / THOUSAND)
    local remainder = value % THOUSAND
    if remainder == 0 then
        return tostring(whole) .. 'K'
    end
    return string.format('%d.%03dK', whole, remainder)
end

local function format_plain_segment(value)
    local text = tostring(math.abs(round(value or 0)))
    local formatted = text:reverse():gsub('(%d%d%d)', '%1.'):reverse():gsub('^%.', '')
    if round(value or 0) < 0 then
        return '-' .. formatted
    end
    return formatted
end

function currency.sh_core_currency_parse(value)
    if type(value) == 'number' then
        return round(value)
    end

    local text = trim(value)
    if text == '' then
        return nil
    end

    local compact = text:upper()
    if compact:find('[KM]') then
        local total = 0
        local matched = false

        for token in compact:gmatch('[^,]+') do
            local part = trim(token)
            if part ~= '' then
                local number_part, suffix = part:match('^(.-)(M)$')
                if not number_part then
                    number_part, suffix = part:match('^(.-)(KK)$')
                end
                if not number_part then
                    number_part, suffix = part:match('^(.-)(K)$')
                end

                if not number_part or not suffix then
                    return nil
                end

                local numeric = parse_decimal_segment(number_part)
                if not numeric then
                    return nil
                end

                if suffix == 'M' then
                    total = total + round(numeric * BILLION)
                elseif suffix == 'KK' then
                    total = total + round(numeric * MILLION)
                elseif suffix == 'K' then
                    total = total + round(numeric * THOUSAND)
                end

                matched = true
            end
        end

        if matched then
            return total
        end
        return nil
    end

    local plain = text:gsub('[%s%.]', '')
    if plain:match('^%d+$') then
        return tonumber(plain)
    end

    return nil
end

function currency.sh_core_currency_format_compact(value)
    local numeric = currency.sh_core_currency_parse(value)
    if not numeric then
        return '0'
    end

    if numeric == 0 then
        return '0'
    end

    local parts = {}
    local remainder = numeric

    local billions = math.floor(remainder / BILLION)
    if billions > 0 then
        parts[#parts + 1] = tostring(billions) .. 'M'
        remainder = remainder - (billions * BILLION)
    end

    local millions = math.floor(remainder / MILLION)
    if millions > 0 then
        parts[#parts + 1] = tostring(millions) .. 'KK'
        remainder = remainder - (millions * MILLION)
    end

    if remainder > 0 then
        parts[#parts + 1] = format_k_segment(remainder)
    end

    if #parts == 0 then
        return '0'
    end

    return table.concat(parts, ', ')
end

function currency.sh_core_currency_to_raw_string(value)
    local numeric = currency.sh_core_currency_parse(value)
    if not numeric then
        return '0'
    end
    return tostring(numeric)
end

function currency.sh_core_currency_format_plain(value)
    local numeric = currency.sh_core_currency_parse(value)
    if not numeric then
        return '0'
    end
    return format_plain_segment(numeric)
end

function currency.sh_core_currency_format_dual(value)
    local compact = currency.sh_core_currency_format_compact(value)
    local plain = currency.sh_core_currency_format_plain(value)

    if compact == plain then
        return compact
    end

    return string.format('%s (%s)', compact, plain)
end

function currency.sh_core_currency_render(value, mode)
    if mode == 'raw' then
        return currency.sh_core_currency_to_raw_string(value)
    end
    if mode == 'plain' then
        return currency.sh_core_currency_format_plain(value)
    end
    if mode == 'compact' then
        return currency.sh_core_currency_format_compact(value)
    end
    if mode == 'dual' or mode == 'display' or mode == nil then
        return currency.sh_core_currency_format_dual(value)
    end
    return currency.sh_core_currency_format_dual(value)
end

return currency
