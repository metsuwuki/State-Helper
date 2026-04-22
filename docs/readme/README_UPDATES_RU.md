# Обновления и релизы

Здесь собрана короткая и нормальная схема того, как в проекте устроены установка, обновление и выпуск новой версии.

## Базовая схема

- игрок кладет только [StateHelper.lua](../../StateHelper.lua)
- entrypoint проверяет, есть ли локальная папка `StateHelper/`
- если структуры нет, запускается первичная установка
- если структура уже есть, дальше работает обычный updater по manifest-схеме

## Что является источником правды

- [StateHelper.lua](../../StateHelper.lua) - вход и первичная установка
- [release_config.lua](../../StateHelper/core/release_config.lua) - версия, channel и remote-пути
- [version.lua](../../StateHelper/core/version.lua) - совместимый runtime-доступ к версии
- [Arizona manifest](../../StateHelper/Arizona_bootstrap/manifest.lua) - список файлов доставки для Arizona
- [updater.lua](../../StateHelper/Arizona_bootstrap/updater.lua) - логика проверки и применения обновлений
- [update_info.json](../../StateHelper/update_info.json) - версия и текст обновления

## Как проходит обновление

1. Скрипт получает `update_info.json`.
2. Сравнивает локальную и удаленную версии.
3. Если есть новая версия, получает удаленный `manifest.lua`.
4. Собирает список файлов, которые должны быть установлены.
5. Скачивает их в локальную структуру.
6. Обновляет `managed_files.lst`.
7. Удаляет старые управляемые файлы, которых больше нет в manifest.
8. Перезагружает скрипты.

Текущий релизный канал проекта: `alpha`.

## Что сделано по безопасности

- текущий файл не удаляется до успешной замены новым
- updater использует `.tmp` и `.bak`
- конфиги сохраняются через безопасную запись
- битые конфиги не теряются, а уходят в `.corrupt`

## Что проверить перед релизом

- версия и channel обновлены в `StateHelper/core/release_config.lua`
- после этого выполнен [sync-project-version.ps1](../../tools/sync-project-version.ps1)
- новые файлы добавлены в manifest
- удаленные файлы действительно убраны из доставки
- текст в `update_info.json` соответствует релизу
- документация не ссылается на уже удаленные файлы

## Live-установка

Если нужно проверить реальную структуру установленной копии в `moonloader`, используй:

- [repair-live-install.ps1](../../tools/repair-live-install.ps1)

Скрипт пишет индекс live-структуры в `StateHelper/Arizona_data/installed/live_layout.json`.

## GitHub labels

Для issue-трекинга в репозитории подготовлен набор labels:

- конфиг: [labels.json](../../.github/labels.json)
- человекочитаемая версия: [labels.yml](../../.github/labels.yml)
- синхронизация в GitHub: [sync-github-labels.ps1](../../tools/sync-github-labels.ps1)

## GitHub

`https://github.com/metsuwuki/State-Helper`