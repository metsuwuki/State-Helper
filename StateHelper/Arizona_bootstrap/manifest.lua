--[[
Open with encoding: UTF-8
StateHelper/Arizona_bootstrap/manifest.lua

Bootstrap-манифест

Назначение:
- описывает секции проекта, файлы и настройки удаленного репозитория
- является источником правды для доставки и планирования обновлений

Роль в архитектуре:
- реестр файлов и зон ответственности проекта
- входные данные для loader, updater и resolver

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

-- Manifest must stay self-contained because the entrypoint evaluates it
-- before the rest of StateHelper is installed on first bootstrap.
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
        return release_config.sh_core_release_get_project_settings('Arizona')
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
            manifest_path = 'StateHelper/Arizona_bootstrap/manifest.lua',
            update_info_path = sh_bootstrap_manifest_get_global_string('SH_UPDATE_INFO_PATH', 'StateHelper/update_info.json'),
        }
    }
end

local PROJECT_SETTINGS = sh_bootstrap_manifest_get_project_settings()
local REMOTE_DATA_ROOT = (PROJECT_SETTINGS.remote and PROJECT_SETTINGS.remote.remote_data_root) or 'Arizona_data/remote'

local REMOTE_SERVER_NAMES = {
    'Phoenix',
    'Tucson',
    'Scottdale',
    'Winslow',
    'Brainburg',
    'BumbleBee',
    'CasaGrande',
    'Chandler',
    'Christmas',
    'Faraway',
    'Gilbert',
    'Glendale',
    'Holiday',
    'Kingman',
    'Mesa',
    'Page',
    'Payson',
    'Prescott',
    'QueenCreek',
    'RedRock',
    'SaintRose',
    'Sedona',
    'ShowLow',
    'SunCity',
    'Surprise',
    'Wednesday',
    'Yava',
    'Yuma',
    'Love',
    'Mirage',
    'Drake',
    'VC',
    'Space',
}

local function append_values(target, values)
    for _, value in ipairs(values or {}) do
        target[#target + 1] = value
    end
end

local function build_remote_pack_files(pack_name)
    local files = {}
    for _, server_name in ipairs(REMOTE_SERVER_NAMES) do
        files[#files + 1] = string.format('%s/%s/%s.json', REMOTE_DATA_ROOT, pack_name, server_name)
    end
    return files
end

local function build_data_files()
    local files = {
        REMOTE_DATA_ROOT .. '/nicks.json',
        REMOTE_DATA_ROOT .. '/tencode.json',
        REMOTE_DATA_ROOT .. '/vehicle.json',
        REMOTE_DATA_ROOT .. '/assets/fonts/SFProText-Medium.ttf',
        REMOTE_DATA_ROOT .. '/assets/fonts/SFProText-Bold.ttf',
        REMOTE_DATA_ROOT .. '/assets/images/logo update.png',
        REMOTE_DATA_ROOT .. '/assets/images/No label.png',
        REMOTE_DATA_ROOT .. '/assets/images/Europa Plus.png',
        REMOTE_DATA_ROOT .. '/assets/images/DFM.png',
        REMOTE_DATA_ROOT .. '/assets/images/Chanson.png',
        REMOTE_DATA_ROOT .. '/assets/images/Dacha.png',
        REMOTE_DATA_ROOT .. '/assets/images/Road.png',
        REMOTE_DATA_ROOT .. '/assets/images/Mayak.png',
        REMOTE_DATA_ROOT .. '/assets/images/Nashe.png',
        REMOTE_DATA_ROOT .. '/assets/images/LoFi Hip-Hop.png',
        REMOTE_DATA_ROOT .. '/assets/images/Maximum.png',
        REMOTE_DATA_ROOT .. '/assets/images/90s Eurodance.png',
    }

    append_values(files, build_remote_pack_files('AutoSu'))
    append_values(files, build_remote_pack_files('AutoTicket'))
    append_values(files, build_remote_pack_files('AutoPunish'))
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
            'Arizona_bootstrap/loader.lua',
            'Arizona_bootstrap/updater.lua',
            'Arizona_bootstrap/manifest.lua',
            'Arizona_bootstrap/resolver.lua',
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
        army = { version = PROJECT_VERSION, files = { 'Arizona_factions/army/package.lua', 'Arizona_factions/army/commands.lua' } },
        common = { version = PROJECT_VERSION, files = { 'Arizona_factions/common/package.lua', 'Arizona_factions/common/commands.lua' } },
        driving_school = { version = PROJECT_VERSION, files = { 'Arizona_factions/driving_school/package.lua', 'Arizona_factions/driving_school/commands.lua' } },
        fire_department = { version = PROJECT_VERSION, files = { 'Arizona_factions/fire_department/package.lua', 'Arizona_factions/fire_department/commands.lua', 'Arizona_factions/fire_department/mechanics.lua' } },
        government = { version = PROJECT_VERSION, files = { 'Arizona_factions/government/package.lua', 'Arizona_factions/government/commands.lua' } },
        hospital = { version = PROJECT_VERSION, files = { 'Arizona_factions/hospital/package.lua', 'Arizona_factions/hospital/commands.lua' } },
        jail = { version = PROJECT_VERSION, files = { 'Arizona_factions/jail/package.lua', 'Arizona_factions/jail/commands.lua', 'Arizona_factions/jail/mechanics.lua' } },
        police = { version = PROJECT_VERSION, files = { 'Arizona_factions/police/package.lua', 'Arizona_factions/police/commands.lua', 'Arizona_factions/police/mechanics.lua' } },
        smi = { version = PROJECT_VERSION, files = { 'Arizona_factions/smi/package.lua', 'Arizona_factions/smi/data.lua', 'Arizona_factions/smi/commands.lua' } },
    },
    mechanics = {
        chat_corrector = { version = PROJECT_VERSION, files = { 'Arizona_mechanics/common/chat_corrector.lua' } },
        fire_reports = { version = PROJECT_VERSION, files = { 'Arizona_mechanics/fire/fire_reports.lua' } },
        jail_smart_punish = { version = PROJECT_VERSION, files = { 'Arizona_mechanics/jail/smart_punish.lua' } },
        members_board = { version = PROJECT_VERSION, files = { 'Arizona_mechanics/common/members_board.lua' } },
        mini_player = { version = PROJECT_VERSION, files = { 'Arizona_mechanics/common/mini_player.lua' } },
        police_auto_inves = { version = PROJECT_VERSION, files = { 'Arizona_mechanics/police/auto_inves.lua' } },
        police_siren = { version = PROJECT_VERSION, files = { 'Arizona_mechanics/police/siren.lua' } },
        police_smart_su = { version = PROJECT_VERSION, files = { 'Arizona_mechanics/police/smart_su.lua' } },
        police_smart_ticket = { version = PROJECT_VERSION, files = { 'Arizona_mechanics/police/smart_ticket.lua' } },
        police_ten_codes = { version = PROJECT_VERSION, files = { 'Arizona_mechanics/police/ten_codes.lua' } },
        police_vehicle_data = { version = PROJECT_VERSION, files = { 'Arizona_mechanics/police/vehicle_data.lua' } },
        police_wanted_list = { version = PROJECT_VERSION, files = { 'Arizona_mechanics/police/wanted_list.lua' } },
        time_weather = { version = PROJECT_VERSION, files = { 'Arizona_mechanics/common/time_weather.lua' } },
    },
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
        return release_config.sh_core_release_get_repository_url('Arizona')
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
        for _, mechanic_id in ipairs(sorted_keys(manifest.mechanics)) do
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
