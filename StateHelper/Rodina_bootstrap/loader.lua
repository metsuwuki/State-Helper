--[[
Open with encoding: UTF-8
StateHelper/Rodina_bootstrap/loader.lua

Bootstrap-загрузчик (Rodina)

Назначение:
- создает общий runtime-context для проекта Rodina
- инициализирует bootstrap-сервисы
- запускает сборку модульного runtime

Роль в архитектуре:
- загружается из `StateHelper.lua` когда выбран проект Rodina
- использует Rodina-специфичный manifest
- разделяет resolver/updater/context/app с Arizona

Правила:
- не размещать здесь feature-логику
- не размещать здесь UI-логику
- держать стартовый поток явным и читаемым
]]

local manifest = require('StateHelper.Rodina_bootstrap.manifest')
local resolver = require('StateHelper.Arizona_bootstrap.resolver')
local updater = require('StateHelper.Arizona_bootstrap.updater')
local context = require('StateHelper.core.context')
local app = require('StateHelper.core.app')
local release_config_ok, release_config = pcall(require, 'StateHelper.core.release_config')
if not release_config_ok then
    release_config = nil
end

local loader = {}

local function sh_bootstrap_loader_get_remote_data_root()
    if manifest.sh_bootstrap_manifest_get_remote_data_root then
        local remote_data_root = manifest.sh_bootstrap_manifest_get_remote_data_root()
        if type(remote_data_root) == 'string' and remote_data_root ~= '' then
            return remote_data_root
        end
    end

    if release_config and type(release_config.sh_core_release_get_remote_data_root) == 'function' then
        local remote_data_root = release_config.sh_core_release_get_remote_data_root('Rodina')
        if type(remote_data_root) == 'string' and remote_data_root ~= '' then
            return remote_data_root
        end
    end

    return 'Arizona_data/remote'
end

function loader.start(opts)
    local ctx = context.create({
        root_dir = opts.root_dir,
        script_dir = opts.script_dir,
        data_dir = opts.data_dir,
        entry_script = opts.entry_script,
        manifest = manifest,
    })

    _G.SH_REMOTE_DATA_ROOT = sh_bootstrap_loader_get_remote_data_root()

    updater.bootstrap(ctx)
    resolver.apply_package_path(ctx)
    local tracked_update_files = updater.sh_bootstrap_update_collect_project_urls(ctx.manifest)

    ctx.state.delivery = {
        remote_ready = manifest.sh_bootstrap_manifest_is_remote_configured(),
        tracked_files = tracked_update_files,
    }

    if ctx.state.delivery.remote_ready then
        ctx.logger:info('github delivery configured')
    else
        ctx.logger:warn('github delivery is not configured in Rodina_bootstrap/manifest.lua')
    end

    ctx.logger:info('tracked delivery files: ' .. tostring(#ctx.state.delivery.tracked_files))
    ctx.logger:info('entrypoint: ' .. tostring(opts.entry_script))
    return app.start(ctx)
end

return loader
