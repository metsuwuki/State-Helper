# Документация StateHelper

Здесь лежит вся основная русская документация по проекту.

Если коротко:

- хочешь просто поставить и пользоваться - открой [README_USER_GUIDE_RU.md](README_USER_GUIDE_RU.md)
- хочешь править код и развивать проект - открой [README_DEVELOPMENT_RU.md](README_DEVELOPMENT_RU.md)
- готовишь релиз или проверяешь обновление - открой [README_UPDATES_RU.md](README_UPDATES_RU.md)

## Что тут есть

- [README_USER_GUIDE_RU.md](README_USER_GUIDE_RU.md) - как поставить, запустить и обновить проект
- [README_DEVELOPMENT_RU.md](README_DEVELOPMENT_RU.md) - как здесь все устроено и как лучше вносить правки
- [README_UPDATES_RU.md](README_UPDATES_RU.md) - как работает доставка файлов и что проверить перед пушем
- [README_STRUCTURE_RU.md](README_STRUCTURE_RU.md) - что за что отвечает в проекте
- [README_PROJECT_TREE_RU.md](README_PROJECT_TREE_RU.md) - актуальное дерево папок и файлов
- [README_LIVE_INSTALL_RU.md](README_LIVE_INSTALL_RU.md) - как устроена установленная копия в `moonloader`
- [README_NAMING_RU.md](README_NAMING_RU.md) - как называть файлы, функции и состояния
- [README_RELEASE_CONFIG_RU.md](README_RELEASE_CONFIG_RU.md) - где централизованно менять staging/prod, owner/repo/branch и пути доставки

Что важно после последних изменений:

- релизные версия, channel и remote-пути теперь централизованы в `StateHelper/core/release_config.lua`
- `StateHelper/core/version.lua` остается совместимым runtime-фасадом для версии
- денежный формат вынесен в `StateHelper/core/currency.lua`
- для синхронизации release-метаданных есть `tools/sync-project-version.ps1`
- для индексации установленной live-структуры есть `tools/repair-live-install.ps1`
- для набора GitHub issue labels есть `.github/labels.json` и `tools/sync-github-labels.ps1`