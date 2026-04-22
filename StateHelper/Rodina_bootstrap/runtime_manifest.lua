--[[
Open with encoding: UTF-8
StateHelper/Rodina_bootstrap/runtime_manifest.lua

Манифест сборки runtime (Rodina)

Назначение:
- задает упорядоченный список частей исходников для сборки runtime
- разделяется с Arizona (одинаковый набор features/core)

Правила:
- бережно сохранять порядок частей
- добавлять и переставлять части только с пониманием миграции
- держать файл декларативным
]]

return {
    parts = {
        'core/runtime_compat_prelude.lua',
        'core/runtime_prelude.lua',
        'features/settings/settings_core.lua',
        'features/commands/custom_commands.lua',
        'features/shpora/shpora_core.lua',
        'features/dep/dep_core.lua',
        'features/sob/sob_core.lua',
        'features/reminder/reminder_core.lua',
        'features/stat/stat_core.lua',
        'features/music/music_core.lua',
        'features/rp_zone/rp_zone_core.lua',
        'features/actions/actions_core.lua',
        'core/ui_root.lua',
        'features/commands/default_command_loader.lua',
        'core/runtime_after_commands.lua',
        'core/runtime_post_init.lua',
    }
}
