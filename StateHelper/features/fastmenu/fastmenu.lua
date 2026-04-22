--[[
Open with encoding: UTF-8
StateHelper/features/fastmenu/fastmenu.lua
]]

local fastmenu = {}

function fastmenu.sh_feature_fastmenu_open_for_id(player_id)
    return open_fast_menu_for_id(player_id)
end

function fastmenu.sh_feature_fastmenu_open_smart(target_id)
    return openSmartFastMenu(target_id)
end

return fastmenu
