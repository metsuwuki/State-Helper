# Дерево проекта StateHelper

Ниже актуальное дерево проекта.

```text
StateHelper.lua
StateHelper/
  Arizona_bootstrap/
    loader.lua
    updater.lua
    manifest.lua
    runtime_manifest.lua
    resolver.lua
    downloader.lua
    integrity.lua

  Rodina_bootstrap/
    loader.lua
    manifest.lua
    runtime_manifest.lua

  core/
    app.lua
    context.lua
    version.lua
    release_config.lua
    currency.lua
    paths.lua
    events.lua
    registry.lua
    logger.lua
    command_builder.lua
    text_match.lua
    textdraw_registry.lua
    game_actions.lua
    dialog_router.lua
    chat_filters.lua
    command_sync.lua
    org_resolver.lua
    storage.lua
    network.lua
    moonloader_env.lua
    runtime_compat_prelude.lua
    ui_root.lua
    command_engine.lua
    command_registry.lua
    hotkeys.lua
    notifications.lua
    cef.lua
    imgui_helpers.lua
    render.lua
    utils.lua
    text.lua
    encoding.lua
    runtime_prelude.lua
    runtime_after_commands.lua
    runtime_post_init.lua

  features/
    actions/
      actions_core.lua
    commands/
      custom_commands.lua
      default_command_loader.lua
      categories.lua
    dep/
      dep_core.lua
      dep_templates.lua
    fastmenu/
      fastmenu.lua
    music/
      music_core.lua
      radio.lua
    reminder/
      reminder_core.lua
    rp_zone/
      rp_zone_core.lua
    scenes/
      scene_core.lua
    settings/
      settings_core.lua
    shpora/
      shpora_core.lua
    sob/
      sob_core.lua
      sob_parser.lua
      sob_templates.lua
    stat/
      stat_core.lua
    tracking/
      tracking.lua

  Arizona_mechanics/
    common/
      chat_corrector.lua
      members_board.lua
      mini_player.lua
      time_weather.lua
    fire/
      fire_reports.lua
    jail/
      smart_punish.lua
    police/
      auto_inves.lua
      siren.lua
      smart_su.lua
      smart_ticket.lua
      ten_codes.lua
      vehicle_data.lua
      wanted_list.lua

  Arizona_factions/
    army/
      package.lua
      commands.lua
    common/
      package.lua
      commands.lua
    driving_school/
      package.lua
      commands.lua
    fire_department/
      package.lua
      commands.lua
      mechanics.lua
    government/
      package.lua
      commands.lua
    hospital/
      package.lua
      commands.lua
    jail/
      package.lua
      commands.lua
      mechanics.lua
    police/
      package.lua
      commands.lua
      mechanics.lua
    smi/
      package.lua
      data.lua
      commands.lua

  Rodina_factions/
    army/
      package.lua
      commands.lua
    common/
      package.lua
      commands.lua
    government/
      package.lua
      commands.lua
    hospital/
      package.lua
      commands.lua
    jail/
      package.lua
      commands.lua
    license_center/
      package.lua
      commands.lua
    police/
      package.lua
      commands.lua
    smi/
      package.lua
      data.lua
      commands.lua

  Arizona_data/
    remote/
      nicks.json
      tencode.json
      vehicle.json
      AutoSu/
      AutoTicket/
      AutoPunish/
      assets/
        fonts/
        images/
    cache/
    installed/
      managed_files.lst
      live_layout.json
      live_layout_snapshots/

  update_info.json

.github/
  labels.json
  labels.yml

tools/
  repair-live-install.ps1
  sync-project-version.ps1
  sync-github-labels.ps1

docs/
  readme/
    README.md
    README_USER_GUIDE_RU.md
    README_DEVELOPMENT_RU.md
    README_UPDATES_RU.md
    README_STRUCTURE_RU.md
    README_PROJECT_TREE_RU.md
    README_LIVE_INSTALL_RU.md
    README_NAMING_RU.md
    README_RELEASE_CONFIG_RU.md

README.md
LICENSE
```

## Как это читать

- `Arizona_bootstrap` / `Rodina_bootstrap` - запуск, доставка и updater
- `core` - инфраструктура и runtime-слой
- `features` - пользовательские разделы
- `Arizona_mechanics` - игровые механики
- `Arizona_factions` / `Rodina_factions` - фракционные пакеты
- `Arizona_data` - локальные данные и удаленные ресурсы

## Что важно помнить

- игроку достаточно [StateHelper.lua](../../StateHelper.lua)
- папка [StateHelper](../../StateHelper) остается основной кодовой базой проекта
- в установленной копии рядом с ней может жить legacy data-папка `State Helper/`
- `managed_files.lst` нужен updater-слою для очистки устаревших файлов
- `live_layout.json` нужен для понятной индексации реальной установленной структуры
- `docs/readme` - это основной комплект документации проекта