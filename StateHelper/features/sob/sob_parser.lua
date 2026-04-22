--[[
Open with encoding: UTF-8
StateHelper/features/sob/sob_parser.lua
]]

local sob_parser = {}

function sob_parser.sh_feature_sob_process_string(input_text)
    return process_string(input_text)
end

function sob_parser.sh_feature_sob_split_text_message(input_text, max_length)
    return split_text_message(input_text, max_length)
end

return sob_parser
