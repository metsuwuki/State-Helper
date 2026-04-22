--[[
Open with encoding: UTF-8
StateHelper/features/sob/sob_templates.lua
]]

local sob_templates = {}

function sob_templates.sh_feature_sob_get_questions()
    if setting and setting.sob and setting.sob.rp_q then
        return setting.sob.rp_q
    end
    return {}
end

function sob_templates.sh_feature_sob_get_fit_templates()
    if setting and setting.sob and setting.sob.rp_fit then
        return setting.sob.rp_fit
    end
    return {}
end

return sob_templates
