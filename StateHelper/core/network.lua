--[[
Open with encoding: UTF-8
StateHelper/core/network.lua
]]

local network = {}

local function sh_core_network_safe_callback(callback, ...)
    if type(callback) ~= 'function' then
        return
    end

    local ok, err = pcall(callback, ...)
    if not ok then
        print(string.format('[StateHelper][NETWORK] callback failed: %s', tostring(err)))
    end
end

local function sh_core_network_perform_request(method, url, args)
    local requests = require 'requests'
    local ok, response = pcall(requests.request, method, url, args)
    if ok and type(response) == 'table' then
        response.json, response.xml = nil, nil
        return true, response
    end

    return false, response
end

function network.sh_core_network_async_http_request(method, url, args, resolve, reject)
    if not resolve then resolve = function() end end
    if not reject then reject = function() end end

    local ok_effil, effil_module = pcall(require, 'effil')
    if ok_effil and type(effil_module) == 'table' and type(effil_module.thread) == 'function' then
        local request_thread = effil_module.thread(function(request_method, request_url, request_args)
            local requests = require 'requests'
            local ok, response = pcall(requests.request, request_method, request_url, request_args)
            if ok and type(response) == 'table' then
                response.json, response.xml = nil, nil
                return true, response
            end
            return false, response
        end)(method, url, args)

        lua_thread.create(function()
            local runner = request_thread
            while true do
                local status, err = runner:status()
                if not err then
                    if status == 'completed' then
                        local ok, response = runner:get()
                        if ok then
                            sh_core_network_safe_callback(resolve, response)
                        else
                            sh_core_network_safe_callback(reject, response)
                        end
                        return
                    elseif status == 'canceled' then
                        sh_core_network_safe_callback(reject, status)
                        return
                    end
                else
                    sh_core_network_safe_callback(reject, err)
                    return
                end
                wait(0)
            end
        end)

        return
    end

    lua_thread.create(function()
        local ok, response = sh_core_network_perform_request(method, url, args)
        if ok then
            sh_core_network_safe_callback(resolve, response)
            return
        end

        sh_core_network_safe_callback(reject, response or 'request_failed')
    end)
end

return network
