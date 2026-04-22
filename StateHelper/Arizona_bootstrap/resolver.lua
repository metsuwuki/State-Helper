--[[
Open with encoding: UTF-8
StateHelper/Arizona_bootstrap/resolver.lua

Резолвер путей и URL

Назначение:
- настраивает локальные package-path
- собирает нормализованные пути внутри проекта
- строит GitHub raw URL для файлов проекта

Роль в архитектуре:
- общий низкоуровневый сервис путей для bootstrap-модулей

Правила:
- не выполнять здесь загрузку
- не изменять здесь manifest
- держать сборку путей детерминированной
]]

local resolver = {}
local release_config = nil

do
    local ok, config = pcall(require, 'StateHelper.core.release_config')
    if ok and type(config) == 'table' then
        release_config = config
    end
end

local function sh_bootstrap_resolver_url_encode_path(path)
    return tostring(path):gsub(' ', '%%20')
end

local function sh_bootstrap_resolver_get_global_string(name, fallback)
    local value = rawget(_G, name)
    if type(value) == 'string' and value ~= '' then
        return value
    end
    return fallback
end

function resolver.apply_package_path(ctx)
    local root = ctx.root_dir
    package.path = table.concat({
        root .. '\\?.lua',
        root .. '\\?\\init.lua',
        package.path
    }, ';')
end

function resolver.sh_bootstrap_resolver_join_path(...)
    local parts = { ... }
    local normalized = {}
    for _, part in ipairs(parts) do
        if part and part ~= '' then
            normalized[#normalized + 1] = tostring(part):gsub('\\', '/'):gsub('^/+', ''):gsub('/+$', '')
        end
    end
    return table.concat(normalized, '/')
end

function resolver.sh_bootstrap_resolver_get_github_raw_url(remote, relative_path)
    if not remote or not remote.owner or not remote.repo or remote.owner == '' or remote.repo == '' then
        return nil
    end

    local path = resolver.sh_bootstrap_resolver_join_path(remote.repo_root, relative_path)
    if release_config and type(release_config.sh_core_release_build_github_raw_url) == 'function' then
        return release_config.sh_core_release_build_github_raw_url(remote, path)
    end

    local owner = tostring(remote.owner)
    local repo = tostring(remote.repo)
    local branch = tostring(remote.branch or 'main')
    local global_owner = sh_bootstrap_resolver_get_global_string('SH_REPO_OWNER', '')
    local global_repo = sh_bootstrap_resolver_get_global_string('SH_REPO_NAME', '')
    local global_branch = sh_bootstrap_resolver_get_global_string('SH_REPO_BRANCH', 'main')
    local global_base_url = sh_bootstrap_resolver_get_global_string('SH_REPO_RAW_BASE_URL', '')

    if global_base_url ~= ''
        and owner == global_owner
        and repo == global_repo
        and branch == global_branch then
        return global_base_url .. '/' .. sh_bootstrap_resolver_url_encode_path(path)
    end

    return string.format(
        'https://raw.githubusercontent.com/%s/%s/%s/%s',
        owner,
        repo,
        branch,
        sh_bootstrap_resolver_url_encode_path(path)
    )
end

function resolver.sh_bootstrap_resolver_get_project_file_url(manifest, relative_path)
    local remote = manifest.sh_bootstrap_manifest_get_remote and manifest.sh_bootstrap_manifest_get_remote() or manifest.project.remote
    local path = resolver.sh_bootstrap_resolver_join_path(remote.project_root, relative_path)
    return resolver.sh_bootstrap_resolver_get_github_raw_url(remote, path)
end

return resolver
