--[[
Open with encoding: UTF-8
StateHelper/core/dialog_router.lua

Declarative router for dialog automation rules.
]]

local logger = require('StateHelper.core.logger')

local dialog_router = {}

function dialog_router.create(options)
    options = options or {}

    local router_logger = options.logger or logger.create(options.prefix or 'DialogRouter')
    local preview = options.preview
    local routes = {}
    local api = {}

    local function sh_core_dialog_router_preview(value, limit)
        if type(preview) == 'function' then
            return preview(value, limit)
        end
        if value == nil then
            return ''
        end
        return tostring(value)
    end

    function api.add_route(route)
        if type(route) ~= 'table' then
            error('dialog route must be a table')
        end
        if type(route.key) ~= 'string' or route.key == '' then
            error('dialog route.key must be a non-empty string')
        end
        if type(route.match) ~= 'function' then
            error('dialog route.match must be a function')
        end
        if type(route.run) ~= 'function' then
            error('dialog route.run must be a function')
        end

        routes[#routes + 1] = route
        return route
    end

    function api.add_routes(route_list)
        for _, route in ipairs(route_list or {}) do
            api.add_route(route)
        end
    end

    function api.run(dialog)
        for _, route in ipairs(routes) do
            local ok_match, matched = pcall(route.match, dialog)
            if not ok_match then
                router_logger:error(string.format('route match failed key=%s error=%s', route.key, tostring(matched)))
            elseif matched then
                router_logger:info(string.format(
                    'route matched key=%s title="%s"',
                    route.key,
                    sh_core_dialog_router_preview(dialog and dialog.title or '', 80)
                ))

                local ok_run, result = pcall(route.run, dialog)
                if not ok_run then
                    router_logger:error(string.format('route run failed key=%s error=%s', route.key, tostring(result)))
                elseif result ~= nil then
                    return result
                end
            end
        end

        return nil
    end

    function api.get_routes()
        local result = {}
        for index, route in ipairs(routes) do
            result[index] = route
        end
        return result
    end

    return api
end

return dialog_router
