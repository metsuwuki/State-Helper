## Конфиг релиза и remote-источников

Главный файл для смены staging/prod:
`StateHelper/core/release_config.lua`

Что хранится в одном месте:
- версия проекта;
- версия vehicle data;
- channel/size для release-метаданных;
- `owner/repo/branch`;
- `project_root`, `entry_path`, `update_info_path`;
- `manifest_path` и `runtime_manifest_path` для Arizona и Rodina;
- `remote_data_root`;
- генерация `repository url` и `raw github url`.

Какие файлы уже используют этот конфиг:
- `StateHelper/core/version.lua`
- `StateHelper/core/runtime_compat_prelude.lua`
- `StateHelper/core/app.lua`
- `StateHelper/Arizona_bootstrap/manifest.lua`
- `StateHelper/Rodina_bootstrap/manifest.lua`
- `StateHelper/Arizona_bootstrap/resolver.lua`
- `StateHelper/Arizona_bootstrap/updater.lua`

Как переключать окружение:
1. Измените значения в `StateHelper/core/release_config.lua`.
2. Для production/staging смените `owner/repo/branch` и при необходимости `manifest_path`, `remote_data_root`, `update_info_path`.
3. Если меняете релизную версию, синхронизируйте:
   `StateHelper/core/release_config.lua`
   `StateHelper/update_info.json`
   `StateHelper.lua` - намеренно не трогается автоматически, потому что это self-bootstrap entrypoint.

Что важно понимать:
- `release_config.lua` теперь источник правды для релизной версии и remote-источников;
- `version.lua` нужен как совместимый фасад для runtime и bootstrap-слоя;
- текущий релизный канал проекта: `alpha`.

Намеренно оставленные исключения:
- `StateHelper.lua`
  Причина: файл должен оставаться самодостаточным для первой установки без уже скачанного проекта.
- `StateHelper/core/runtime_prelude.lua`
  Причина: legacy runtime-файл в CP1251. Он пока не переведен на новый конфиг, чтобы не рисковать поломкой монолитного старта.

Практический смысл:
- разработчики меняют staging/prod в одном Lua-файле;
- bootstrap и modular runtime используют одни и те же remote-данные;
- исключения явно перечислены и не теряются по коду.