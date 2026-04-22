--[[
Open with encoding: UTF-8
StateHelper/Rodina_bootstrap/manifest.lua

Bootstrap-манифест (Rodina)

Назначение:
- описывает секции проекта Rodina, файлы и настройки удаленного репозитория
- является источником правды для доставки и планирования обновлений

Правила:
- держать пути к файлам явными
- добавлять новые модули сюда, когда они становятся частью доставки
- не размещать здесь runtime-поведение
]]

local release_config = nil
do
    local ok, config = pcall(require, 'StateHelper.core.release_config')
    if ok and type(config) == 'table' then
        release_config = config
    end
end

local PROJECT_VERSION = 'v5.0.0-alpha'
if release_config and type(release_config.sh_core_release_get_version) == 'function' then
    local configured_version = release_config.sh_core_release_get_version()
    if type(configured_version) == 'string' and configured_version ~= '' then
        PROJECT_VERSION = configured_version
    end
end

do
    local ok, version = pcall(require, 'StateHelper.core.version')
    if ok and type(version) == 'table' then
        local resolved_version = version.sh_core_version_get and version.sh_core_version_get() or version.value
        if type(resolved_version) == 'string' and resolved_version ~= '' then
            PROJECT_VERSION = resolved_version
        end
    end
end

local function sh_bootstrap_manifest_get_global_string(name, fallback)
    local value = rawget(_G, name)
    if type(value) == 'string' and value ~= '' then
        return value
    end
    return fallback
end

local function sh_bootstrap_manifest_get_project_settings()
    if release_config and type(release_config.sh_core_release_get_project_settings) == 'function' then
        return release_config.sh_core_release_get_project_settings('Rodina')
    end

    return {
        name = 'StateHelper',
        version = PROJECT_VERSION,
        entry = sh_bootstrap_manifest_get_global_string('SH_ENTRY_SCRIPT_NAME', 'StateHelper.lua'),
        docs_index = 'docs/readme/README.md',
        remote = {
            provider = 'github',
            owner = sh_bootstrap_manifest_get_global_string('SH_REPO_OWNER', 'metsuwuki'),
            repo = sh_bootstrap_manifest_get_global_string('SH_REPO_NAME', 'State-Helper'),
            branch = sh_bootstrap_manifest_get_global_string('SH_REPO_BRANCH', 'main'),
            repo_root = '',
            project_root = sh_bootstrap_manifest_get_global_string('SH_PROJECT_ROOT_DIR_NAME', 'StateHelper'),
            remote_data_root = 'Arizona_data/remote',
            entry_path = sh_bootstrap_manifest_get_global_string('SH_ENTRY_SCRIPT_NAME', 'StateHelper.lua'),
            manifest_path = 'StateHelper/Rodina_bootstrap/manifest.lua',
            update_info_path = sh_bootstrap_manifest_get_global_string('SH_UPDATE_INFO_PATH', 'StateHelper/update_info.json'),
        }
    }
end

local PROJECT_SETTINGS = sh_bootstrap_manifest_get_project_settings()
local REMOTE_DATA_ROOT = (PROJECT_SETTINGS.remote and PROJECT_SETTINGS.remote.remote_data_root) or 'Arizona_data/remote'

local function append_values(target, values)
    for _, value in ipairs(values or {}) do
        target[#target + 1] = value
    end
end

local function build_data_files()
    local files = {
        REMOTE_DATA_ROOT .. '/nicks.json',
        REMOTE_DATA_ROOT .. '/tencode.json',
        REMOTE_DATA_ROOT .. '/vehicle.json',
    }
    return files
end

local manifest = {
    project = {
        name = PROJECT_SETTINGS.name,
        version = PROJECT_VERSION,
        entry = PROJECT_SETTINGS.entry,
        docs_index = PROJECT_SETTINGS.docs_index,
        remote = PROJECT_SETTINGS.remote,
    },
    bootstrap = {
        files = {
            'bootstrap/updater.lua',
            'Rodina_bootstrap/loader.lua',
            'Rodina_bootstrap/manifest.lua',
            'Rodina_bootstrap/runtime_manifest.lua',
            -- shared bootstrap infrastructure from Arizona_bootstrap
            'Arizona_bootstrap/resolver.lua',
            'Arizona_bootstrap/updater.lua',
            'Arizona_bootstrap/downloader.lua',
            'Arizona_bootstrap/integrity.lua',
            'Arizona_bootstrap/runtime_manifest.lua',
        }
    },
    core = {
        files = {
            'core/app.lua',
            'core/context.lua',
            'core/version.lua',
            'core/release_config.lua',
            'core/currency.lua',
            'core/paths.lua',
            'core/events.lua',
            'core/registry.lua',
            'core/logger.lua',
            'core/command_builder.lua',
            'core/text_match.lua',
            'core/textdraw_registry.lua',
            'core/game_actions.lua',
            'core/dialog_router.lua',
            'core/chat_filters.lua',
            'core/command_sync.lua',
            'core/org_resolver.lua',
            'core/storage.lua',
            'core/network.lua',
            'core/moonloader_env.lua',
            'core/runtime_compat_prelude.lua',
            'core/ui_root.lua',
            'core/command_engine.lua',
            'core/command_registry.lua',
            'core/hotkeys.lua',
            'core/notifications.lua',
            'core/cef.lua',
            'core/imgui_helpers.lua',
            'core/render.lua',
            'core/utils.lua',
            'core/text.lua',
            'core/encoding.lua',
            'core/runtime_prelude.lua',
            'core/runtime_after_commands.lua',
            'core/runtime_post_init.lua',
            'arizona_logo.png',
            'rodina_logo.png',
        }
    },
    features = {
        actions = { version = PROJECT_VERSION, files = { 'features/actions/actions_core.lua' } },
        commands = {
            version = PROJECT_VERSION,
            files = {
                'features/commands/custom_commands.lua',
                'features/commands/default_command_loader.lua',
                'features/commands/categories.lua',
            }
        },
        dep = {
            version = PROJECT_VERSION,
            files = {
                'features/dep/dep_core.lua',
                'features/dep/dep_templates.lua',
            }
        },
        fastmenu = { version = PROJECT_VERSION, files = { 'features/fastmenu/fastmenu.lua' } },
        music = {
            version = PROJECT_VERSION,
            files = {
                'features/music/music_core.lua',
                'features/music/radio.lua',
            }
        },
        reminder = { version = PROJECT_VERSION, files = { 'features/reminder/reminder_core.lua' } },
        rp_zone = { version = PROJECT_VERSION, files = { 'features/rp_zone/rp_zone_core.lua' } },
        scenes = { version = PROJECT_VERSION, files = { 'features/scenes/scene_core.lua' } },
        settings = { version = PROJECT_VERSION, files = { 'features/settings/settings_core.lua' } },
        shpora = { version = PROJECT_VERSION, files = { 'features/shpora/shpora_core.lua' } },
        sob = {
            version = PROJECT_VERSION,
            files = {
                'features/sob/sob_core.lua',
                'features/sob/sob_parser.lua',
                'features/sob/sob_templates.lua',
            }
        },
        stat = { version = PROJECT_VERSION, files = { 'features/stat/stat_core.lua' } },
        tracking = { version = PROJECT_VERSION, files = { 'features/tracking/tracking.lua' } },
    },
    factions = {
        army          = { version = PROJECT_VERSION, files = { 'Rodina_factions/army/package.lua',           'Rodina_factions/army/commands.lua' } },
        common        = { version = PROJECT_VERSION, files = { 'Rodina_factions/common/package.lua',         'Rodina_factions/common/commands.lua' } },
        government    = { version = PROJECT_VERSION, files = { 'Rodina_factions/government/package.lua',     'Rodina_factions/government/commands.lua' } },
        hospital      = { version = PROJECT_VERSION, files = { 'Rodina_factions/hospital/package.lua',       'Rodina_factions/hospital/commands.lua' } },
        jail          = { version = PROJECT_VERSION, files = { 'Rodina_factions/jail/package.lua',           'Rodina_factions/jail/commands.lua' } },
        license_center = { version = PROJECT_VERSION, files = { 'Rodina_factions/license_center/package.lua', 'Rodina_factions/license_center/commands.lua' } },
        police        = { version = PROJECT_VERSION, files = { 'Rodina_factions/police/package.lua',         'Rodina_factions/police/commands.lua' } },
        smi           = { version = PROJECT_VERSION, files = { 'Rodina_factions/smi/package.lua',            'Rodina_factions/smi/data.lua',            'Rodina_factions/smi/commands.lua' } },
    },
    mechanics = {},
    data = {
        files = build_data_files()
    }
}

local function to_lookup(list)
    if not list then
        return nil
    end
    local lookup = {}
    for _, value in ipairs(list) do
        lookup[value] = true
    end
    return lookup
end

local function sorted_keys(map)
    local keys = {}
    for key in pairs(map or {}) do
        keys[#keys + 1] = key
    end
    table.sort(keys)
    return keys
end

local function append_file_entries(result, section_name, module_id, module_def)
    for _, relative_path in ipairs(module_def.files or {}) do
        result[#result + 1] = {
            section = section_name,
            id = module_id,
            version = module_def.version or manifest.project.version,
            path = relative_path,
        }
    end
end

function manifest.sh_bootstrap_manifest_get_remote()
    return manifest.project.remote
end

function manifest.sh_bootstrap_manifest_is_remote_configured()
    local remote = manifest.project.remote or {}
    return remote.provider == 'github'
        and type(remote.owner) == 'string'
        and type(remote.repo) == 'string'
        and remote.owner ~= ''
        and remote.repo ~= ''
end

function manifest.sh_bootstrap_manifest_get_repository_url()
    local remote = manifest.project.remote or {}
    if not manifest.sh_bootstrap_manifest_is_remote_configured() then
        return nil
    end
    if release_config and type(release_config.sh_core_release_get_repository_url) == 'function' then
        return release_config.sh_core_release_get_repository_url('Rodina')
    end
    return string.format(
        'https://github.com/%s/%s',
        tostring(remote.owner),
        tostring(remote.repo)
    )
end

function manifest.sh_bootstrap_manifest_get_remote_data_root()
    local remote = manifest.project.remote or {}
    local remote_data_root = remote.remote_data_root
    if type(remote_data_root) == 'string' and remote_data_root ~= '' then
        return remote_data_root
    end

    return REMOTE_DATA_ROOT
end

function manifest.sh_bootstrap_manifest_collect_file_index(selection)
    selection = selection or {}

    local enabled_sections = selection.sections or {
        bootstrap = true,
        core = true,
        features = true,
        factions = true,
        mechanics = true,
        data = true,
    }

    local faction_lookup = to_lookup(selection.factions)
    local feature_lookup = to_lookup(selection.features)
    local mechanic_lookup = to_lookup(selection.mechanics)
    local result = {}

    if enabled_sections.bootstrap then
        for _, relative_path in ipairs(manifest.bootstrap.files or {}) do
            result[#result + 1] = {
                section = 'bootstrap',
                id = 'bootstrap',
                version = manifest.project.version,
                path = relative_path,
            }
        end
    end

    if enabled_sections.core then
        for _, relative_path in ipairs(manifest.core.files or {}) do
            result[#result + 1] = {
                section = 'core',
                id = 'core',
                version = manifest.project.version,
                path = relative_path,
            }
        end
    end

    if enabled_sections.features then
        for _, feature_id in ipairs(sorted_keys(manifest.features)) do
            if not feature_lookup or feature_lookup[feature_id] then
                append_file_entries(result, 'features', feature_id, manifest.features[feature_id])
            end
        end
    end

    if enabled_sections.factions then
        for _, faction_id in ipairs(sorted_keys(manifest.factions)) do
            if not faction_lookup or faction_lookup[faction_id] then
                append_file_entries(result, 'factions', faction_id, manifest.factions[faction_id])
            end
        end
    end

    if enabled_sections.mechanics then
        for _, mechanic_id in ipairs(sorted_keys(manifest.mechanics or {})) do
            if not mechanic_lookup or mechanic_lookup[mechanic_id] then
                append_file_entries(result, 'mechanics', mechanic_id, manifest.mechanics[mechanic_id])
            end
        end
    end

    if enabled_sections.data then
        for _, relative_path in ipairs(manifest.data.files or {}) do
            result[#result + 1] = {
                section = 'data',
                id = 'data',
                version = manifest.project.version,
                path = relative_path,
            }
        end
    end

    return result
end

function manifest.sh_bootstrap_manifest_collect_project_files(selection)
    local index = manifest.sh_bootstrap_manifest_collect_file_index(selection)
    local files = {}
    for _, item in ipairs(index) do
        files[#files + 1] = item.path
    end
    table.sort(files)
    return files
end

return manifest
