--[[
Open with encoding: UTF-8
StateHelper/mechanics/police/siren.lua
]]

local siren = {}

function siren.sh_mech_police_siren_key()
    if setting and setting.police_settings then
        return setting.police_settings.siren_key
    end
    return nil
end

return siren
