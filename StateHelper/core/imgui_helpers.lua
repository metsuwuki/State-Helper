--[[
Open with encoding: UTF-8
StateHelper/core/imgui_helpers.lua
]]

local imgui_helpers = {}

function imgui_helpers.sh_ui_imgui_text_colored(string_value, max_float)
    return imgui.TextColoredRGB(string_value, max_float)
end

function imgui_helpers.sh_ui_imgui_draw_wrapped_text(text, x, y, wrap_width, line_spacing)
    return draw_wrapped_text(text, x, y, wrap_width, line_spacing)
end

return imgui_helpers
