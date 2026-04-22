# Структура проекта StateHelper

Этот файл нужен, чтобы быстро понять, как устроен проект и куда вообще лучше лезть с правками.

## Общая идея

Снаружи для игрока все выглядит просто. Есть один [StateHelper.lua](../../StateHelper.lua), который ставит проект и дальше запускает его как надо.

Внутри проект разделен на понятные слои:

- запуск и доставка
- ядро
- пользовательские фичи
- игровые механики
- фракционные пакеты
- данные и remote-ресурсы

Логически это все те же `bootstrap/core/features/mechanics/factions/data`, но физически в репозитории сейчас используются project-specific директории:

- `Arizona_bootstrap/`
- `Rodina_bootstrap/`
- `Arizona_factions/`
- `Rodina_factions/`
- `Arizona_mechanics/`
- `Arizona_data/`

## Как запускается проект

1. Игрок кладет [StateHelper.lua](../../StateHelper.lua) в `moonloader`.
2. Если структура `StateHelper/` уже есть, подключается bootstrap-слой нужного проекта.
3. Если структуры нет, entrypoint скачивает проект.
4. Bootstrap поднимает context, пути и updater.
5. [app.lua](../../StateHelper/core/app.lua) собирает runtime по project-specific `runtime_manifest.lua`.
6. После этого проект стартует в обычном режиме.
7. Post-init слой дожимает позднюю инициализацию команд и recovery-логики.

Важно:

- `StateHelper/` это кодовая структура проекта
- `State Helper/` в установленной копии это legacy data-структура рантайма
- до полной миграции обе папки могут сосуществовать и выполнять разные роли

## Основные слои

### `Arizona_bootstrap/` и `Rodina_bootstrap/`

Отвечают за запуск, доставку и обновление для конкретного проекта.

Тут лежат:

- loader
- manifest
- resolver
- downloader
- integrity
- updater
- runtime manifest

### `core/`

Это инфраструктурное ядро проекта.

Здесь лежат:

- context
- version
- release_config
- currency
- paths
- logger
- storage
- events
- registry
- notifications
- network
- command_builder
- text_match
- textdraw_registry
- game_actions
- dialog_router
- chat_filters
- command_sync
- org_resolver
- runtime compatibility и post-init helper-слой
- CEF и UI-helper слой
- крупные runtime-файлы проекта

### `features/`

Здесь лежат пользовательские разделы, которые не завязаны жестко на одну фракцию.

Примеры:

- команды
- настройки
- напоминания
- музыка
- статистика
- собеседования
- RP-зона
- действия

### `Arizona_mechanics/`

Игровые механики, которые удобнее держать отдельно от feature-слоя.

### `Arizona_factions/` и `Rodina_factions/`

Пакеты фракций с командами и, если нужно, своей механикой или локальными data-модулями.

Пример:

- `smi/package.lua`
- `smi/data.lua`
- `smi/commands.lua`

### `Arizona_data/`

Рабочие данные, remote-ресурсы и локальные служебные файлы.

Важно:

- `remote/` хранит данные и ассеты, которые проект скачивает из своего же репозитория
- `installed/` хранит служебные индексы вроде `managed_files.lst`
- `installed/live_layout.json` хранит снимок live-структуры установленной копии
- `cache/` хранит кэш update-метаданных и других runtime-данных

## Runtime-файлы

Часть логики сейчас все еще собрана в крупных runtime-файлах:

- [runtime_prelude.lua](../../StateHelper/core/runtime_prelude.lua)
- [ui_root.lua](../../StateHelper/core/ui_root.lua)
- [runtime_after_commands.lua](../../StateHelper/core/runtime_after_commands.lua)
- [runtime_post_init.lua](../../StateHelper/core/runtime_post_init.lua)

## Денежный формат

Общая логика денежного формата теперь вынесена в [currency.lua](../../StateHelper/core/currency.lua).

Формат:

- `1K` = `1.000`
- `1KK` = `1.000.000`
- `1M` = `1.000.000.000`
- составные суммы могут рендериться как `1M, 2KK, 555.630K`

## Переименование корня

Идея переименовать `StateHelper/` в `StateEngine` нормальная как архитектурное направление, но пока это нельзя считать локальной правкой.

Причина:

- `StateHelper` сейчас одновременно namespace для `require(...)`, имя кодовой папки и часть bootstrap-путей
- в установленной игре уже сосуществуют `StateHelper/` и legacy data-папка `State Helper/`
- без полной migration-логики появится еще третья корневая структура

Поэтому сначала нужно завершить структурную разгрузку runtime и централизовать namespace migration, и только потом менять физическое имя корня.