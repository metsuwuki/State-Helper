# Руководство разработчика

Этот файл для тех, кто дорабатывает `StateHelper`, чистит код и готовит проект к следующему релизу.

## Главная мысль

Если логика относится к отдельной ответственности, выноси ее в модуль, а не раздувай `runtime_prelude.lua`, `ui_root.lua` и другие крупные legacy-файлы.

## Основные слои

- `Arizona_bootstrap/`, `Rodina_bootstrap/` - запуск, manifest, resolver, downloader, updater
- `core/` - инфраструктура, совместимость, currency, release-конфиг, dialog/textdraw/chat helper-слой
- `features/` - пользовательские разделы
- `Arizona_mechanics/` - игровые механики Arizona
- `Arizona_factions/`, `Rodina_factions/` - фракционные пакеты и локальные data-модули
- `Arizona_data/` - remote-ресурсы и installed/cache-данные
- `tools/` - скрипты сопровождения репозитория и live-установки

Подробнее смотри в [README_STRUCTURE_RU.md](README_STRUCTURE_RU.md) и [README_PROJECT_TREE_RU.md](README_PROJECT_TREE_RU.md).

## Как лучше вносить правки

1. Сначала определи слой, к которому относится изменение.
2. Новую вспомогательную логику старайся выносить в `core/` или в доменный модуль нужной фичи.
3. Фракционные данные и шаблоны держи внутри папки конкретной фракции.
4. Если приходится трогать крупный runtime-файл, сначала подумай, можно ли вынести кусок в новый модуль.
5. Не плодите новые hardcoded `dialog id`, `textdraw id` и raw-url по проекту.

## Версия и релизные данные

Теперь источник правды для релизных данных:

- [release_config.lua](../../StateHelper/core/release_config.lua) - версия, channel, owner/repo/branch, remote-paths
- [version.lua](../../StateHelper/core/version.lua) - совместимый runtime-фасад для версии

Если готовишь новый релиз:

1. Меняешь значения в `StateHelper/core/release_config.lua`
2. Запускаешь [sync-project-version.ps1](../../tools/sync-project-version.ps1)
3. Проверяешь diff в `StateHelper/update_info.json`, `StateHelper/Arizona_data/remote/vehicle.json` и entrypoint

Текущий релизный статус проекта: `v5.0.0-alpha`.

## Денежный формат

В проекте используется компактный денежный формат:

- `1.000 = 1K`
- `1.000.000 = 1KK`
- `1.000.000.000 = 1M`
- сложные суммы могут выглядеть как `1M, 2KK, 555.630K`

Источником общей логики является [currency.lua](../../StateHelper/core/currency.lua).

## Кодировка

В проекте одновременно живут `UTF-8` и `CP1251`.

- новые модульные файлы и документация должны быть в `UTF-8`
- крупные legacy runtime/UI файлы все еще могут быть в `CP1251`
- не делай массовую перекодировку без проверки запуска в игре
- если в шапке файла написано `Open with encoding: CP1251`, редактируй его именно так

Что особенно важно:

- не передавай `nil` в `u8(...)` и `u8:decode(...)`
- не считай, что строка уже в правильной кодировке
- для новых helper-мест используй [encoding.lua](../../StateHelper/core/encoding.lua)

## Имя проекта и корень

Каноническое имя namespace и кодовой папки сейчас: `StateHelper`.

Почему пока не `StateEngine`:

- `require('StateHelper....')` уже прошит по bootstrap-цепочке и runtime
- код лежит в `StateHelper/`
- установленная игра отдельно хранит legacy data-root в `State Helper/`

Значит переименование потребует полноценной миграции путей, namespace и данных. Пока она не сделана, `StateHelper` остается каноническим именем проекта.

## Работа со ссылками

Не добавляй новые вручную вбитые `raw.githubusercontent`-ссылки.

- bootstrap-слой должен опираться на manifest и release_config
- runtime-слой должен использовать централизованные helper-функции сборки URL
- если добавляешь новый remote-ресурс, сначала положи его в репозиторий, потом внеси в manifest

## Live-установка

Установленная копия сейчас состоит из двух корней:

- `StateHelper/` - код
- `State Helper/` - legacy runtime data

Для индексации live-структуры используй [repair-live-install.ps1](../../tools/repair-live-install.ps1).

Скрипт пишет карту установки в:

- `StateHelper/Arizona_data/installed/live_layout.json`
- `StateHelper/Arizona_data/installed/live_layout_snapshots/`

## Безопасность данных

- настройки сохраняются через временный файл и backup
- битые конфиги уходят в `.corrupt`
- updater ведет индекс управляемых файлов в `StateHelper/Arizona_data/installed/managed_files.lst`
- прерванный bootstrap-install должен корректно восстанавливаться на следующем запуске

## Перед пушем

- проверь, что новый файл добавлен в manifest
- проверь, что релизные данные синхронизированы через `release_config.lua`
- проверь, что документация соответствует реальной структуре проекта
- проверь, что правка не ломает кодировку, локализацию и не плодит дубли логики
