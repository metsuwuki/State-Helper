--[[
Open with encoding: UTF-8
StateHelper/core/textdraw_registry.lua

Small state container for visible textdraws.
]]

local textdraw_registry = {}

local function sh_core_textdraw_registry_get_text(matcher, value)
    if matcher and matcher.text then
        return matcher.text(value)
    end
    if value == nil then
        return ''
    end
    return tostring(value)
end

function textdraw_registry.create(options)
    options = options or {}

    local matcher = options.matcher
    local state = {
        visible = {},
        selectable = false,
        hovercolor = nil,
    }

    local api = {}

    function api.extract_text(textdraw)
        if type(textdraw) == 'table' then
            return sh_core_textdraw_registry_get_text(matcher, textdraw.text)
        end
        return sh_core_textdraw_registry_get_text(matcher, textdraw)
    end

    function api.show(id, textdraw)
        local text_value = api.extract_text(textdraw)
        local clean_value = matcher and matcher.strip_colors and matcher.strip_colors(text_value) or text_value

        state.visible[id] = {
            id = id,
            text = text_value,
            clean = clean_value,
            selectable = type(textdraw) == 'table' and (textdraw.selectable == 1 or textdraw.selectable == true) or false,
            style = type(textdraw) == 'table' and textdraw.style or nil,
            raw = textdraw,
            updated_at = os.clock(),
        }

        return state.visible[id]
    end

    function api.set_string(id, text)
        local cached = state.visible[id] or { id = id }
        cached.text = sh_core_textdraw_registry_get_text(matcher, text)
        cached.clean = matcher and matcher.strip_colors and matcher.strip_colors(cached.text) or cached.text
        cached.updated_at = os.clock()
        state.visible[id] = cached
        return cached
    end

    function api.hide(id)
        state.visible[id] = nil
    end

    function api.set_selectable(enabled, hovercolor)
        state.selectable = enabled
        state.hovercolor = hovercolor
    end

    function api.find_by_keywords(keywords, require_selectable)
        local best_id = nil
        local best_entry = nil

        for id, entry in pairs(state.visible) do
            if matcher and matcher.contains and matcher.contains(entry.text, keywords) then
                if (not require_selectable) or entry.selectable then
                    if not best_entry or (entry.updated_at or 0) > (best_entry.updated_at or 0) then
                        best_id = id
                        best_entry = entry
                    end
                end
            end
        end

        return best_id, best_entry
    end

    function api.get_state()
        return state
    end

    return api
end

return textdraw_registry
