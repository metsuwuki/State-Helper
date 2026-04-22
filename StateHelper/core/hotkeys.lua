--[[
Open with encoding: UTF-8
StateHelper/core/hotkeys.lua
]]

local hotkeys = {}

function hotkeys.sh_core_hotkeys_handle(key_data)
    return on_hot_key(key_data)
end

function hotkeys.sh_core_hotkeys_key_edit(title, key_data)
    return key_edit(title, key_data)
end

return hotkeys
