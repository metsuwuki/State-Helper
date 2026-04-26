--[[
Open with encoding: UTF-8
StateHelper/core/context.lua

Runtime-context

Назначение:
- создает общий context-объект для модульного проекта
- регистрирует core-сервисы, доступные bootstrap и runtime-модулям

Роль в архитектуре:
- общий контейнер зависимостей для модулей стартового слоя

Правила:
- хранить здесь инфраструктурные сервисы
- избегать здесь feature-специфичного состояния
- держать создание context предсказуемым
]]

local logger = require('StateHelper.core.logger')
local storage = require('StateHelper.core.storage')
local events = require('StateHelper.core.events')
local registry = require('StateHelper.core.registry')
local notifications = require('StateHelper.core.notifications')
local paths = require('StateHelper.core.paths')

local context = {}

function context.create(opts)
    local script_dir = opts.script_dir or paths.sh_core_paths_get_script_dir()
    paths.sh_core_paths_migrate_legacy_data_root(script_dir)

    local ctx = {
        root_dir = opts.root_dir,
        script_dir = script_dir,
        data_dir = opts.data_dir or paths.sh_core_paths_get_data_root(script_dir),
        entry_script = opts.entry_script,
        manifest = opts.manifest,
        state = {},
    }

    ctx.logger = logger.create('StateHelper')
    ctx.paths = paths
    ctx.storage = storage.create(ctx)
    ctx.events = events.create()
    ctx.registry = registry.create(ctx)
    ctx.notifications = notifications.create(ctx)
    ctx.packages = {
        factions = {},
        mechanics = {},
        features = {},
    }

    return ctx
end

return context
