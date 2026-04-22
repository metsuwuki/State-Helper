# StateHelper

`StateHelper` - Lua-проект для `MoonLoader`, `SAMP` и `Arizona RP`.

Текущий релизный статус: `v5.0.0-alpha`.

Игроку по-прежнему нужен только [StateHelper.lua](StateHelper.lua). Дальше entrypoint сам ставит или обновляет структуру проекта из GitHub.

## Что важно сейчас

- `StateHelper/` - кодовой корень проекта
- `State Helper/` - legacy data-root установленной копии
- источник релизных данных и remote-путей: `StateHelper/core/release_config.lua`
- совместимый runtime-доступ к версии: `StateHelper/core/version.lua`
- денежный формат проекта переведен на компактный вид: `1K`, `1KK`, `1M`

## Что лежит в репозитории

- `StateHelper.lua` - входной файл для игрока
- `StateHelper/` - bootstrap, core, features, mechanics, factions и remote-данные
- `tools/` - служебные PowerShell-скрипты для сопровождения проекта
- `.github/` - конфигурация labels для issue-трекинга
- `docs/readme/` - актуальная русская документация по проекту

## Документация

- [Индекс документации](docs/readme/README.md)
- [Руководство пользователя](docs/readme/README_USER_GUIDE_RU.md)
- [Руководство разработчика](docs/readme/README_DEVELOPMENT_RU.md)
- [Обновления и релизы](docs/readme/README_UPDATES_RU.md)
- [Структура проекта](docs/readme/README_STRUCTURE_RU.md)
- [Дерево проекта](docs/readme/README_PROJECT_TREE_RU.md)
- [Live-установка](docs/readme/README_LIVE_INSTALL_RU.md)
- [Конфиг релиза](docs/readme/README_RELEASE_CONFIG_RU.md)
- [Конвенция именования](docs/readme/README_NAMING_RU.md)

## GitHub

`https://github.com/metsuwuki/State-Helper`

## Лицензия

[MIT](LICENSE)
