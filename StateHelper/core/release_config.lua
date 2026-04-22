--[[
Open with encoding: UTF-8
StateHelper/core/release_config.lua

Single source of truth for release metadata and remote delivery settings.
Use this file to switch staging/production repositories, branches, paths,
or release-facing version metadata in one place.

Important:
- StateHelper.lua remains self-contained on purpose for first bootstrap.
- Bootstrap manifests may fall back to inline values when this module is not
  available yet during the very first install.
]]

local release_config = {}

local function sh_core_release_get_global_string(name, fallback)
    local value = rawget(_G, name)
    if type(value) == 'string' and value ~= '' then
        return value
    end
    return fallback
end

local BASE_PROJECT = {
    name = 'StateHelper',
    entry = sh_core_release_get_global_string('SH_ENTRY_SCRIPT_NAME', 'StateHelper.lua'),
    docs_index = 'docs/readme/README.md',
}

local VERSION = {
    value = 'v5.0.0-alpha',
    vehicle = 'v5.0.0-alpha',
    channel = 'alpha',
    size = 'modular',
}

local BASE_REMOTE = {
    provider = 'github',
    owner = sh_core_release_get_global_string('SH_REPO_OWNER', 'metsuwuki'),
    repo = sh_core_release_get_global_string('SH_REPO_NAME', 'State-Helper'),
    branch = sh_core_release_get_global_string('SH_REPO_BRANCH', 'main'),
    repo_root = '',
    project_root = sh_core_release_get_global_string('SH_PROJECT_ROOT_DIR_NAME', 'StateHelper'),
    entry_path = sh_core_release_get_global_string('SH_ENTRY_SCRIPT_NAME', 'StateHelper.lua'),
    update_info_path = sh_core_release_get_global_string('SH_UPDATE_INFO_PATH', 'StateHelper/update_info.json'),
}

local PROJECTS = {
    Arizona = {
        manifest_path = 'StateHelper/Arizona_bootstrap/manifest.lua',
        runtime_manifest_path = 'StateHelper/Arizona_bootstrap/runtime_manifest.lua',
        remote_data_root = 'Arizona_data/remote',
    },
    Rodina = {
        manifest_path = 'StateHelper/Rodina_bootstrap/manifest.lua',
        runtime_manifest_path = 'StateHelper/Rodina_bootstrap/runtime_manifest.lua',
        remote_data_root = 'Arizona_data/remote',
    },
}

local function sh_core_release_clone(value, copies)
    if type(value) ~= 'table' then
        return value
    end

    copies = copies or {}
    if copies[value] then
        return copies[value]
    end

    local result = {}
    copies[value] = result
    for key, nested_value in pairs(value) do
        result[sh_core_release_clone(key, copies)] = sh_core_release_clone(nested_value, copies)
    end
    return result
end

local function sh_core_release_join_path(...)
    local parts = { ... }
    local normalized = {}
    for _, part in ipairs(parts) do
        if part and part ~= '' then
            normalized[#normalized + 1] = tostring(part):gsub('\\', '/'):gsub('^/+', ''):gsub('/+$', '')
        end
    end
    return table.concat(normalized, '/')
end

local function sh_core_release_encode_path(path)
    return tostring(path or ''):gsub(' ', '%%20')
end

function release_config.sh_core_release_get_version()
    return VERSION.value
end

function release_config.sh_core_release_get_vehicle_version()
    return VERSION.vehicle
end

function release_config.sh_core_release_get_channel()
    return VERSION.channel
end

function release_config.sh_core_release_get_size()
    return VERSION.size
end

function release_config.sh_core_release_get_project_name()
    return BASE_PROJECT.name
end

function release_config.sh_core_release_get_entry()
    return BASE_PROJECT.entry
end

function release_config.sh_core_release_get_entry_path()
    return BASE_REMOTE.entry_path
end

function release_config.sh_core_release_get_docs_index()
    return BASE_PROJECT.docs_index
end

function release_config.sh_core_release_get_project_key(project_name)
    if type(project_name) == 'string' and PROJECTS[project_name] then
        return project_name
    end
    return 'Arizona'
end

function release_config.sh_core_release_get_project_config(project_name)
    local key = release_config.sh_core_release_get_project_key(project_name)
    return sh_core_release_clone(PROJECTS[key])
end

function release_config.sh_core_release_get_project_remote(project_name)
    local key = release_config.sh_core_release_get_project_key(project_name)
    local project = PROJECTS[key]
    local remote = sh_core_release_clone(BASE_REMOTE)
    remote.manifest_path = project.manifest_path
    remote.runtime_manifest_path = project.runtime_manifest_path
    remote.remote_data_root = project.remote_data_root
    return remote
end

function release_config.sh_core_release_get_project_settings(project_name)
    local settings = sh_core_release_clone(BASE_PROJECT)
    settings.version = release_config.sh_core_release_get_version()
    settings.remote = release_config.sh_core_release_get_project_remote(project_name)
    return settings
end

function release_config.sh_core_release_build_github_raw_url(remote, relative_path)
    local active_remote = sh_core_release_clone(remote or BASE_REMOTE)
    if not active_remote.owner or not active_remote.repo or active_remote.owner == '' or active_remote.repo == '' then
        return nil
    end

    local path = sh_core_release_join_path(active_remote.repo_root, relative_path)
    return string.format(
        'https://raw.githubusercontent.com/%s/%s/%s/%s',
        tostring(active_remote.owner),
        tostring(active_remote.repo),
        tostring(active_remote.branch or 'main'),
        sh_core_release_encode_path(path)
    )
end

function release_config.sh_core_release_get_repo_raw_url(relative_path)
    return release_config.sh_core_release_build_github_raw_url(BASE_REMOTE, relative_path)
end

function release_config.sh_core_release_get_project_raw_url(relative_path, project_name)
    local remote = release_config.sh_core_release_get_project_remote(project_name)
    local path = sh_core_release_join_path(remote.project_root, relative_path)
    return release_config.sh_core_release_build_github_raw_url(remote, path)
end

function release_config.sh_core_release_get_remote_data_root(project_name)
    local remote = release_config.sh_core_release_get_project_remote(project_name)
    return remote.remote_data_root
end

function release_config.sh_core_release_get_repository_url(project_name)
    local remote = release_config.sh_core_release_get_project_remote(project_name)
    local configured_url = rawget(_G, 'SH_REPOSITORY_URL')
    if type(configured_url) == 'string' and configured_url ~= '' then
        return configured_url
    end
    return string.format(
        'https://github.com/%s/%s',
        tostring(remote.owner),
        tostring(remote.repo)
    )
end

function release_config.sh_core_release_get_update_info_defaults(project_name)
    return {
        version = release_config.sh_core_release_get_version(),
        channel = release_config.sh_core_release_get_channel(),
        size = release_config.sh_core_release_get_size(),
        vehicle = release_config.sh_core_release_get_vehicle_version(),
        repository = release_config.sh_core_release_get_repository_url(project_name),
    }
end

function release_config.sh_core_release_describe_sources()
    return {
        project = sh_core_release_clone(BASE_PROJECT),
        version = sh_core_release_clone(VERSION),
        base_remote = sh_core_release_clone(BASE_REMOTE),
        projects = sh_core_release_clone(PROJECTS),
    }
end

return release_config
