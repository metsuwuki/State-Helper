--[[
Open with encoding: UTF-8
StateHelper/features/commands/categories.lua
]]

local categories = {}

function categories.sh_feature_cmd_categories_get_all()
    if cmd and cmd[2] then
        return cmd[2]
    end
    return {}
end

function categories.sh_feature_cmd_categories_add_to_all()
    return add_cmd_in_all_cmd()
end

return categories
