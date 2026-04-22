# Live-установка StateHelper

Этот файл описывает, как сейчас выглядит установленная копия проекта в `moonloader`.

## Что важно

- код проекта живет в `StateHelper/`
- legacy-данные рантайма живут в `State Helper/`
- это нормальная текущая схема, а не ошибка установки

## Типичная структура

- `moonloader/StateHelper.lua` - входной скрипт
- `moonloader/StateHelper/` - код, bootstrap, manifest, updater, remote cache
- `moonloader/State Helper/` - настройки, шрифты, изображения, отыгровки, локальные json

## Где что лежит

- `StateHelper/Arizona_data/cache/remote_update_info.json` - кэш последней release-метаинформации
- `StateHelper/Arizona_data/installed/managed_files.lst` - индекс файлов, которыми управляет updater
- `StateHelper/Arizona_data/installed/live_layout.json` - индекс текущей live-структуры
- `State Helper/Настройки.json` - пользовательские настройки
- `State Helper/Police/vehicle.json` и `State Helper/Police/tencode.json` - legacy police data
- `moonloader.log` - главный лог MoonLoader

## Как получить индекс live-структуры

Используй:

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\repair-live-install.ps1 -MoonloaderRoot "D:\Arizona RP\moonloader"
```

Что делает скрипт:

- проверяет наличие ожидаемых корней
- гарантирует наличие `Arizona_data/cache` и `Arizona_data/installed`
- записывает `live_layout.json`
- создает timestamp-snapshot в `live_layout_snapshots/`

## Почему данные не переносятся автоматически

Потому что сейчас в проекте еще есть legacy runtime-слой, который читает часть файлов строго из `State Helper/`.

Поэтому безопасная стратегия такая:

- сначала индексировать и документировать live-структуру
- затем переводить чтение на централизованные пути
- и только после этого делать полную миграцию data-root
