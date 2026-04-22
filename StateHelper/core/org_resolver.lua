--[[
Open with encoding: UTF-8
StateHelper/core/org_resolver.lua

Central place for resolving organization ids into stable project profiles.
]]

local org_resolver = {}

local ORG_PROFILES = {
    {
        key = 'hospital',
        min = 1,
        max = 4,
        command_sets = { 'hospital' },
        gun_func = false,
    },
    {
        key = 'driving_school',
        ids = { 5 },
        command_sets = { 'driving_school' },
        gun_func = false,
    },
    {
        key = 'government',
        ids = { 6 },
        command_sets = { 'government' },
        gun_func = false,
    },
    {
        key = 'army',
        ids = { 7, 8 },
        command_sets = { 'army' },
        gun_func = true,
    },
    {
        key = 'fire_department',
        ids = { 9 },
        command_sets = { 'fire_department' },
        gun_func = false,
    },
    {
        key = 'jail',
        ids = { 10 },
        command_sets = { 'jail' },
        gun_func = true,
    },
    {
        key = 'police',
        min = 11,
        max = 15,
        command_sets = { 'police' },
        gun_func = true,
    },
    {
        key = 'smi',
        min = 16,
        max = 18,
        command_sets = { 'smi' },
        gun_func = false,
    },
}

local function sh_core_org_matches_profile(org_id, profile)
    local numeric_id = tonumber(org_id) or 0

    if numeric_id == 0 or type(profile) ~= 'table' then
        return false
    end

    if profile.ids then
        for _, id in ipairs(profile.ids) do
            if numeric_id == id then
                return true
            end
        end
    end

    if profile.min and profile.max then
        return numeric_id >= profile.min and numeric_id <= profile.max
    end

    return false
end

local function sh_core_org_clone_profile(profile, org_id)
    local result = {}
    for key, value in pairs(profile or {}) do
        if type(value) == 'table' then
            local copy = {}
            for index, nested in ipairs(value) do
                copy[index] = nested
            end
            result[key] = copy
        else
            result[key] = value
        end
    end
    result.org_id = tonumber(org_id) or 0
    return result
end

function org_resolver.sh_core_org_resolve(org_id)
    for _, profile in ipairs(ORG_PROFILES) do
        if sh_core_org_matches_profile(org_id, profile) then
            return sh_core_org_clone_profile(profile, org_id)
        end
    end
    return {
        key = 'unknown',
        org_id = tonumber(org_id) or 0,
        command_sets = {},
        gun_func = false,
    }
end

function org_resolver.sh_core_org_matches(org_id, profile_key)
    local profile = org_resolver.sh_core_org_resolve(org_id)
    return profile.key == profile_key
end

function org_resolver.sh_core_org_is_police(org_id)
    return org_resolver.sh_core_org_matches(org_id, 'police')
end

return org_resolver
