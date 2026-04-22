--[[
Open with encoding: UTF-8
StateHelper/core/text.lua
]]

local text = {}

function text.sh_core_text_format_time(seconds)
    return format_time(seconds)
end

function text.sh_core_text_wrap(input_text, max_length, max_total_length)
    return wrapText(input_text, max_length, max_total_length)
end

return text
