--[[
Open with encoding: UTF-8
StateHelper/core/render.lua
]]

local render = {}

function render.sh_ui_render_gradient_border(time_value, speed_border)
    return draw_gradient_border(time_value, speed_border)
end

function render.sh_ui_render_gradient_image(speed_border, x, y, size_x, size_y, radius)
    return draw_gradient_image_music(speed_border, x, y, size_x, size_y, radius)
end

return render
