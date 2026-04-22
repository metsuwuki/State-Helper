--[[
Open with encoding: UTF-8
StateHelper/core/version.lua
]]

local fallback_version = {
    value = 'v5.0.0-alpha',
    vehicle_data = 'v5.0.0-alpha',
}

local version = {
    value = fallback_version.value,
    vehicle_data = fallback_version.vehicle_data,
}

local ok, release_config = pcall(require, 'StateHelper.core.release_config')
if ok and type(release_config) == 'table' then
    local resolved_version = release_config.sh_core_release_get_version and release_config.sh_core_release_get_version()
    local resolved_vehicle = release_config.sh_core_release_get_vehicle_version and release_config.sh_core_release_get_vehicle_version()

    if type(resolved_version) == 'string' and resolved_version ~= '' then
        version.value = resolved_version
    end
    if type(resolved_vehicle) == 'string' and resolved_vehicle ~= '' then
        version.vehicle_data = resolved_vehicle
    end
end

function version.sh_core_version_get()
    return version.value
end

function version.sh_core_version_get_vehicle()
    return version.vehicle_data
end

return version
