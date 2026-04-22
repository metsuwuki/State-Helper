--[[
Open with encoding: UTF-8
StateHelper/core/runtime_post_init.lua
]]

local sampev = hook
local logger = require('StateHelper.core.logger')
local text_match = require('StateHelper.core.text_match')
local textdraw_registry = require('StateHelper.core.textdraw_registry')
local game_actions = require('StateHelper.core.game_actions')
local dialog_router = require('StateHelper.core.dialog_router')
local chat_filters = require('StateHelper.core.chat_filters')
local command_sync = require('StateHelper.core.command_sync')
local org_resolver = require('StateHelper.core.org_resolver')

local sh_dialog_logger = logger.create({
    prefix = 'DialogCompat',
    filter = function(level, message)
        if rawget(_G, 'SH_DEBUG_MODE') == true
            or rawget(_G, 'SH_VERBOSE_COMMAND_LOG') == true
            or rawget(_G, 'SH_COMMAND_SYNC_DEBUG') == true
            or rawget(_G, 'dev_mode') == true then
            return true
        end

        local text = tostring(message or '')
        if text:find('reason=command_sync', 1, true)
            or text:find('reason=command_sync_refresh', 1, true)
            or text:find('reason=reload_police_utility_commands', 1, true)
            or text:find('reason=default_dep_tab_command', 1, true)
            or text:find('reason=default_sob_tab_command', 1, true) then
            return false
        end

        return true
    end,
})
local sh_protocol_logger = logger.create('ProtocolTrace')

local sh_matcher = text_match.create({
    convert_cp1251 = function(text)
        return u1251:iconv(text)
    end,
})

local sh_actions = game_actions.create({
    logger = sh_dialog_logger,
    preview = function(value, limit)
        return sh_matcher.preview(value, limit)
    end,
})

local sh_textdraws = textdraw_registry.create({
    matcher = sh_matcher,
})

local sh_chat_filters = chat_filters.create({
    matcher = sh_matcher,
    logger = logger.create('ChatFilters'),
    debug_enabled = function()
        return rawget(_G, 'SH_DEBUG_MODE') == true
            or rawget(_G, 'SH_CHAT_FILTER_DEBUG') == true
            or rawget(_G, 'dev_mode') == true
    end,
})

local sh_dialog_routes = dialog_router.create({
    logger = sh_dialog_logger,
    preview = function(value, limit)
        return sh_matcher.preview(value, limit)
    end,
})

local sh_command_sync = command_sync.create({
    logger = logger.create('CommandSync'),
    actions = sh_actions,
    org_resolver = org_resolver,
})

local sh_dialog_legacy_on_show_dialog = hook.onShowDialog
local sh_dialog_legacy_on_server_message = hook.onServerMessage
local sh_dialog_legacy_on_show_textdraw = hook.onShowTextDraw
local sh_dialog_legacy_on_textdraw_set_string = hook.onTextDrawSetString
local sh_dialog_legacy_on_textdraw_hide = hook.onTextDrawHide
local sh_dialog_legacy_on_toggle_select_textdraw = hook.onToggleSelectTextDraw
local sh_dialog_legacy_on_send_click_textdraw = hook.onSendClickTextDraw
local sh_dialog_legacy_on_send_dialog_response = hook.onSendDialogResponse
local sh_dialog_legacy_on_send_command = hook.onSendCommand
local sh_dialog_legacy_on_send_chat = hook.onSendChat

local sh_protocol_debug_handlers_bound = false

local sh_dialog_doc_keywords = {
    'медицинскую',
    'паспорт',
    'лицензии',
    'трудовой',
}

local function sh_dialog_text(value)
    return sh_matcher.text(value)
end

local function sh_dialog_trim(value)
    return sh_matcher.trim(value)
end

local function sh_dialog_strip_colors(value)
    return sh_matcher.strip_colors(value)
end

local function sh_dialog_preview(value, limit)
    return sh_matcher.preview(value, limit)
end

local function sh_dialog_cp1251(value)
    return sh_matcher.to_cp1251(value)
end

local function sh_dialog_contains(value, needles)
    return sh_matcher.contains(value, needles)
end

local function sh_dialog_collect_lines(text)
    return sh_matcher.collect_lines(text)
end

local function sh_dialog_find_row_by_keywords(text, keywords)
    return sh_matcher.find_row_by_keywords(text, keywords)
end

local function sh_dialog_detect_smi_org_from_text(value)
    local text = sh_dialog_strip_colors(value)
    if sh_dialog_contains(text, { 'СМИ Лос', 'CNN LS', 'СМИ LS', 'LS News' }) then
        return 16
    end
    if sh_dialog_contains(text, { 'СМИ Сан', 'CNN SF', 'СМИ SF', 'SF News' }) then
        return 17
    end
    if sh_dialog_contains(text, { 'СМИ Лас', 'CNN LV', 'СМИ LV', 'LV News' }) then
        return 18
    end
    return nil
end

local function sh_debug_enabled(flag_name)
    if rawget(_G, 'SH_DEBUG_MODE') == true then
        return true
    end

    if type(rawget(_G, 'setting')) == 'table' and setting.debug_mode == true then
        return true
    end

    if flag_name and rawget(_G, flag_name) == true then
        return true
    end

    return rawget(_G, 'dev_mode') == true
end

local function sh_dialog_log(level, message)
    sh_actions.log(level, message)
end

local function sh_protocol_debug_enabled()
    return sh_debug_enabled('SH_PROTOCOL_DEBUG')
end

local function sh_chat_debug_enabled()
    return sh_debug_enabled('SH_CHAT_DEBUG') or sh_protocol_debug_enabled()
end

local function sh_dialog_legacy_chat_filter_enabled(index)
    return type(setting) == 'table'
        and type(setting.put_mes) == 'table'
        and setting.put_mes[index] == true
end

local function sh_dialog_color_equals(color_hex, expected)
    return tostring(color_hex or ''):lower() == tostring(expected or ''):lower()
end

local function sh_dialog_should_filter_legacy_chat_message(message, color_hex)
    if sh_dialog_legacy_chat_filter_enabled(2) and sh_dialog_contains(message, {
        'Объявление:',
        'Отредактировал сотрудник',
    }) then
        return true, 'legacy_player_media_ads'
    end

    if sh_dialog_legacy_chat_filter_enabled(3) then
        if sh_dialog_contains(message, {
            'News LS',
            'News SF',
            'News LV',
            'LS News',
            'SF News',
            'LV News',
        }) then
            return true, 'legacy_media_news'
        end

        if tostring(color_hex) == '9acd32' and sh_dialog_contains(message, {
            'Гость',
            'Репортёр',
            'Репортер',
        }) then
            return true, 'legacy_media_report'
        end
    end

    if sh_dialog_legacy_chat_filter_enabled(1) and sh_dialog_contains(message, {
        '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~',
        '[Подсказка]',
        'Основные команды сервера',
        'Личный кабинет/Донат',
        'Подробнее об обновлениях сервера',
        'Негде жить?',
        'подробнее о командах',
        'обновления сервера',
        'серверные мероприятия',
        'мероприятия сервера',
        'скидки на донат',
        'Проживая в отеле',
        'Продажа билетов на рейс',
        'акция Х3 PayDay',
        'Центр обмена имуществ',
        'Спонсировать серверные мероприятия',
        'Склад списанных бронежилетов',
    }) then
        return true, 'legacy_tips'
    end

    if sh_dialog_legacy_chat_filter_enabled(4) and sh_dialog_contains(message, {
        'испытал удачу при открытии',
        '[Удача] Игрок',
        'Удача улыбнулась игроку',
        'открытии ларца',
    }) then
        return true, 'legacy_case_luck'
    end

    if sh_dialog_legacy_chat_filter_enabled(5) and sh_dialog_contains(message, {
        '[Сбор средств]',
        'сбор средств',
        'организац',
    }) then
        return true, 'legacy_org_fundraising'
    end

    if sh_dialog_legacy_chat_filter_enabled(7) and sh_dialog_contains(message, {
        'лотерейный билет',
        'лотерейные билеты',
        'счастливый билет',
        'выигрышный билет',
        'лотерея',
        'лотереи',
        'выиграть',
    }) then
        return true, 'legacy_lottery'
    end

    if sh_dialog_legacy_chat_filter_enabled(8) and (
        sh_dialog_contains(message, {
            'Гос.Новости',
            'Гос Новости',
            'государственные новости',
        })
        or sh_dialog_color_equals(color_hex, '045fb4') and sh_dialog_contains(message, { 'новости' })
    ) then
        return true, 'legacy_government_news'
    end

    if sh_dialog_legacy_chat_filter_enabled(6) and sh_dialog_contains(message, {
        '[VIP ADV]',
        '[FOREVER]',
        '[PREMIUM]',
        '[VIP]',
        '[ADMIN]',
        'VIP чат',
        'вип чат',
        'приобрел ',
        'приобрела ',
    }) then
        return true, 'legacy_vip_chat'
    end

    if sh_dialog_legacy_chat_filter_enabled(9) and (
        sh_dialog_contains(message, {
            '[D] ',
            '[D]',
            'департамент',
        })
        or sh_dialog_color_equals(color_hex, '3399ff') and sh_dialog_contains(message, { '[d]', ' деп ' })
    ) then
        return true, 'legacy_department_radio'
    end

    if sh_dialog_legacy_chat_filter_enabled(10) and (
        sh_dialog_contains(message, {
            '[R] ',
            '[R]',
            'рация организации',
        })
        or sh_dialog_color_equals(color_hex, '2db043') and sh_dialog_contains(message, { '[r]', ' рация ' })
    ) then
        return true, 'legacy_org_radio'
    end

    return false, nil
end

local function sh_dialog_should_auto_offer_documents()
    return type(setting) == 'table'
        and (setting.show_dialog_auto or setting.auto_cmd_doc or run_sob == true)
end

local function sh_protocol_log(channel, message)
    if not sh_protocol_debug_enabled() then
        return
    end

    sh_protocol_logger:info(string.format('[%s] %s', tostring(channel), tostring(message)))
end

local function sh_dialog_send_chat_command(command, reason)
    return sh_actions.send_chat(command, reason)
end

local function sh_dialog_send_click_textdraw(id, reason)
    return sh_actions.send_click_textdraw(id, reason)
end

local function sh_dialog_send_response(id, button_id, list_id, input, reason)
    return sh_actions.send_dialog_response(id, button_id, list_id, input, reason)
end

local function sh_dialog_close(id, button_id, reason)
    return sh_actions.close_dialog(id, button_id, reason)
end

local function sh_dialog_find_textdraw_by_keywords(keywords, require_selectable)
    return sh_textdraws.find_by_keywords(keywords, require_selectable)
end

local function sh_dialog_click_textdraw_by_keywords(keywords, reason)
    local textdraw_id, entry = sh_dialog_find_textdraw_by_keywords(keywords, true)
    if textdraw_id ~= nil then
        sh_dialog_log('info', string.format(
            'matched textdraw reason=%s id=%s text="%s"',
            tostring(reason),
            tostring(textdraw_id),
            sh_dialog_preview(entry and entry.text or '', 80)
        ))
        sh_dialog_send_click_textdraw(textdraw_id, reason)
        return true
    end

    sh_dialog_log('warn', string.format('textdraw not found by keywords for reason=%s', tostring(reason)))
    return false
end

local function sh_patch_gui_input_text()
    if type(gui) ~= 'table' or type(gui.InputText) ~= 'function' or gui.__sh_safe_input_text then
        return
    end

    local original_input_text = gui.InputText
    gui.InputText = function(pos_draw, size_input, arg_text, name_input, buf_size_input, text_about, filter_buf, flag_input)
        local ok, value, pressed = pcall(
            original_input_text,
            pos_draw,
            size_input,
            arg_text,
            name_input,
            buf_size_input,
            text_about,
            filter_buf,
            flag_input
        )
        if ok then
            return value, pressed
        end

        print(string.format(
            '[StateHelper][InputText] recovered crash for "%s": arg_type=%s buf=%s error=%s',
            tostring(name_input or 'unnamed'),
            type(arg_text),
            tostring(buf_size_input),
            tostring(value)
        ))

        local fallback_text = arg_text
        if fallback_text == nil then
            fallback_text = ''
        elseif type(fallback_text) ~= 'string' then
            fallback_text = tostring(fallback_text)
        end

        local fallback_buf_size = tonumber(buf_size_input) or 1
        if fallback_buf_size < 1 then
            fallback_buf_size = 1
        end

        local retry_ok, retry_value, retry_pressed = pcall(
            original_input_text,
            pos_draw,
            size_input,
            fallback_text,
            tostring(name_input or 'unnamed'),
            fallback_buf_size,
            text_about,
            filter_buf,
            flag_input
        )
        if retry_ok then
            return retry_value, retry_pressed
        end

        print(string.format(
            '[StateHelper][InputText] fallback failed for "%s": %s',
            tostring(name_input or 'unnamed'),
            tostring(retry_value)
        ))
        return fallback_text, false
    end

    gui.__sh_safe_input_text = true
    print('[StateHelper] Safe InputText wrapper enabled')
end

pcall(sh_patch_gui_input_text)

local function sh_dialog_is_wanted_dialog(title, text)
    return sh_dialog_contains(title, { 'Разыскиваем', 'Розыск', 'Wanted' })
        or (sh_dialog_contains(text, { 'уровень' }) and sh_dialog_text(text):find('{21FF11}', 1, true) ~= nil)
end

local function sh_dialog_is_prison_dialog(title, text)
    return sh_dialog_contains(title, { 'Тюремные наказания' })
        or sh_dialog_contains(text, { 'Тюремные наказания' })
end

local function sh_dialog_is_active_offer(title, text)
    return sh_dialog_contains(title, { 'Активные предложения' })
        or sh_dialog_contains(text, { 'Активные предложения' })
end

local function sh_dialog_is_members_dialog(title, text)
    return sh_dialog_contains(title, { 'В сети:' })
        or (sh_dialog_contains(text, { 'Следующая страница' }) and sh_dialog_contains(text, { 'Ник' }))
end

local function sh_dialog_is_government_pass_dialog(title, text)
    return sh_dialog_contains(title, { 'паспорт', 'документ' })
        or sh_dialog_contains(text, {
            'обычный паспорт',
            'загранпаспорт',
            'служебный паспорт',
            'биометрический паспорт',
        })
end

local function sh_dialog_is_fire_list_dialog(title, text)
    return sh_dialog_contains(title, { 'Список происшествий' })
        or sh_dialog_contains(text, { 'Список происшествий' })
end

local function sh_dialog_is_license_sale_dialog(title, text)
    return sh_dialog_contains(title, { 'Продажа лицензии', 'Лицензии' })
        or sh_dialog_contains(text, {
            'Водительские права',
            'Лицензия на оружие',
            'Лицензия на охоту',
            'Лицензия на рыбалку',
        })
end

local function sh_dialog_is_license_term_dialog(title, text)
    return sh_dialog_contains(title, { 'Выбор срока лицензий', 'Срок лицензии' })
        or sh_dialog_contains(text, { '30 дней', '90 дней', '365 дней' })
end

local function sh_dialog_create_context(id, style, title, button_1, button_2, text)
    local dialog = {
        id = id,
        style = style,
        title = title,
        button_1 = button_1,
        button_2 = button_2,
        text = text,
    }

    function dialog:has_title(needles)
        return sh_dialog_contains(self.title, needles)
    end

    function dialog:has_text(needles)
        return sh_dialog_contains(self.text, needles)
    end

    function dialog:find_row_by_keywords(keywords)
        return sh_dialog_find_row_by_keywords(self.text, keywords)
    end

    function dialog:respond(button_id, list_id, input, reason)
        return sh_dialog_send_response(self.id, button_id, list_id, input, reason)
    end

    function dialog:close(button_id, reason)
        return sh_dialog_close(self.id, button_id, reason)
    end

    return dialog
end

function reload_police_utility_commands()
    if type(setting) ~= 'table' then
        return
    end

    sh_actions.unregister_chat_command('su', 'reload_police_utility_commands')
    sh_actions.unregister_chat_command('ticket', 'reload_police_utility_commands')

    if not org_resolver.sh_core_org_is_police(setting.org) then
        return
    end

    if type(setting.police_settings) ~= 'table' then
        return
    end

    if setting.police_settings.smart_su and type(smart_su_func) == 'function' then
        sh_actions.register_chat_command('su', smart_su_func, 'police_smart_su')
        if type(download_wanted_reasons) == 'function' then
            download_wanted_reasons()
        end
    end

    if setting.police_settings.smart_ticket and type(smart_ticket_func) == 'function' then
        sh_actions.register_chat_command('ticket', smart_ticket_func, 'police_smart_ticket')
        if type(download_ticket_reasons) == 'function' then
            download_ticket_reasons()
        end
    end
end

local function sh_dialog_parse_members(dialog)
    local ok, err = pcall(function()
        local ip, port = sampGetCurrentServerAddress()
        local server = ip .. ':' .. port
        if server == '80.66.82.147:7777' then
            sh_dialog_log('warn', 'members dialog skipped on VC because layout is unsupported')
            return
        end

        local count = 0
        members_wait.next_page.bool = false

        local title_clean = sh_dialog_strip_colors(dialog.title)
        org.name = sh_dialog_trim(title_clean:match('^(.-)%s*%(') or title_clean)
        org.online = tonumber(title_clean:match('(%d+)%s*%)') or 0)
        if org.name == '' then
            org.name = sh_dialog_cp1251('Организация')
        end

        for line in sh_dialog_text(dialog.text):gmatch('[^\r\n]+') do
            count = count + 1
            if not sh_dialog_contains(line, { 'Ник', 'страница' }) then
                local color, nick, player_id, prefix, rank_name, rank_id, color_nil, warns, afk, muted, quests
                if line:find('%(Вы%)') then
                    color, nick, player_id, prefix, rank_name, rank_id, color_nil, warns, idk, afk, muted, quests =
                        string.match(line, '{(%x+)}(.-)%((%d+)%)%{(%x+)}%(Вы%)\t(.-)%((%d+)%)\t{(%x+)}(%d+) %[(%d+)] / (%d+)%s*(.-)\t(%d+)')
                elseif line:find('%(%d+ ' .. sh_dialog_cp1251('дней') .. '%)') then
                    color, nick, player_id, rank_name, rank_id, color, days, color_nil, warns, idk, afk, muted, quests =
                        string.match(line, '{(%x+)}(.-)%((%d+)%)\t(.-)%((%d+)%) {(%x+)}%((.-)%)\t{(%x+)}(%d+) %[(%d+)] / (%d+)%s*(.-)\t(%d+)')
                else
                    color, nick, player_id, rank_name, rank_id, color_nil, warns, idk, afk, muted, quests =
                        string.match(line, '{(%x+)}(.-)%((%d+)%)\t(.-)%((%d+)%)\t{(%x+)}(%d+) %[(%d+)] / (%d+)%s*(.-)\t(%d+)')
                end

                if nick and player_id and rank_id then
                    local uniform = (color == '90EE90')
                    if not setting.mb_tags then
                        nick = nick:match('([A-Za-z]+_[A-Za-z]+)$')
                    end
                    if muted and muted ~= '' and nick then
                        muted = muted:match('^/%s*(.*)') or muted
                        nick = nick .. ' (' .. muted .. ') '
                    end

                    members[#members + 1] = {
                        nick = tostring(nick),
                        id = player_id,
                        rank = {
                            count = tonumber(rank_id),
                        },
                        afk = tonumber(afk),
                        warns = tonumber(warns),
                        rank_name = rank_name,
                        uniform = uniform,
                    }
                end
            end

            if sh_dialog_contains(line, { 'Следующая страница' }) then
                members_wait.next_page.bool = true
                members_wait.next_page.i = count - 2
            end
        end

        if members_wait.next_page.bool then
            dialog:respond(1, members_wait.next_page.i, nil, 'members_next_page')
            members_wait.next_page.bool = false
            members_wait.next_page.i = 0
        else
            while #members > tonumber(org.online) do
                table.remove(members, 1)
            end

            dialog:respond(0, nil, nil, 'members_close')
            org.afk = getAfkCount()
            members_wait.members = false

            if type(setting.police_settings) == 'table'
                and type(setting.police_settings.wanted_list) == 'table'
                and setting.police_settings.wanted_list.func
                and org_resolver.sh_core_org_is_police(setting.org)
                and not wanted_wait.checking then
                lua_thread.create(function()
                    wait(1100)
                    wanted_wait.checking = true
                    wanted_wait.page = 1
                    emp_wanted_players = {}
                    sh_dialog_send_chat_command('/wanted 1', 'members_followup_wanted')
                    wanted_wait.timeout = os.clock() + 5
                    sh_dialog_log('info', 'members dialog completed, requested wanted page 1')
                end)
            end
        end
    end)

    if not ok then
        sh_dialog_log('error', string.format('members parser failed: %s', tostring(err)))
        if not setting.cef_notif then
            sampAddChatMessage('[SH]{FFFFFF} В Мемберс на экране случилась ошибка. Функция отключена.', 0xFF5345)
        else
            cefnotig('{FF5345}[SH]{FFFFFF} В Мемберс на экране случилась ошибка. Функция отключена.', 3000)
        end
        setting.mb.func = false
    end

    return false
end

sh_dialog_routes.add_routes({
    {
        key = 'wanted_dynamic',
        match = function(dialog)
            return wanted_wait and wanted_wait.checking and sh_dialog_is_wanted_dialog(dialog.title, dialog.text)
        end,
        run = function(dialog)
            wanted_wait.timeout = 0
            wanted_wait.dialog_opened = true

            local wanted_pattern = '{FFFFFF}(.-)%({21FF11}(%d+){FFFFFF}%)%s+(%d+)%s+'
                .. sh_dialog_cp1251('уровень')
                .. '%s+%[%s*(.-)%s*%]'

            for line in sh_dialog_text(dialog.text):gmatch('[^\r\n]+') do
                local nick, player_id, wanted_level, distance = string.match(line, wanted_pattern)
                if nick then
                    emp_wanted_players[#emp_wanted_players + 1] = {
                        nick = nick,
                        id = player_id,
                        level = wanted_level,
                        dist = distance,
                    }
                end
            end

            sh_dialog_log('info', string.format(
                'wanted dialog matched dynamically id=%s players=%s',
                tostring(dialog.id),
                tostring(#emp_wanted_players)
            ))

            dialog:close(0, 'wanted_dynamic_close')
            wanted_check()
            return false
        end,
    },
    {
        key = 'unprison_dynamic',
        match = function(dialog)
            return unprison and sh_dialog_is_prison_dialog(dialog.title, dialog.text)
        end,
        run = function(dialog)
            sh_dialog_log('info', string.format(
                'prison dialog matched dynamically id=%s player=%s',
                tostring(dialog.id),
                tostring(unprison_id)
            ))

            if s_na == 'Chandler'
                or s_na == 'RedRock'
                or s_na == 'Gilbert'
                or s_na == 'ShowLow'
                or s_na == 'CasaGrande'
                or s_na == 'SunCity'
                or s_na == 'Holiday'
                or s_na == 'Christmas'
                or s_na == 'Scottdale' then
                local values = {}
                for value in sh_dialog_text(dialog.text):gmatch('{5CDC59}(%d+)') do
                    values[#values + 1] = value
                end

                if #values > 0 and setting.price[3] and unprison_id then
                    local total_sum = 0
                    total_sum = total_sum + ((tonumber(values[1]) or 0) * (sh_money_parse(setting.price[3].box) or 0))
                    total_sum = total_sum + ((tonumber(values[2]) or 0) * (sh_money_parse(setting.price[3].eat) or 0))
                    total_sum = total_sum + ((tonumber(values[3]) or 0) * (sh_money_parse(setting.price[3].cloth) or 0))
                    total_sum = total_sum + ((tonumber(values[4]) or 0) * (sh_money_parse(setting.price[3].trash) or 0))
                    total_sum = total_sum + ((tonumber(values[5]) or 0) * (sh_money_parse(setting.price[3].min) or 0))

                    local price = sh_money_raw(math.floor(total_sum))
                    sampAddChatMessage('/unpunish ' .. unprison_id .. ' ' .. price, -1)
                    sh_dialog_send_chat_command('/unpunish ' .. unprison_id .. ' ' .. price, 'unprison_dynamic')
                    unprison_id = nil
                end
            elseif s_na == 'Tucson' then
                sh_dialog_send_chat_command('/unpunish ' .. unprison_id .. ' 2500000', 'unprison_tucson')
                unprison = false
            elseif s_na == 'Mesa' then
                sh_dialog_send_chat_command('/unpunish ' .. unprison_id .. ' 2000000', 'unprison_mesa')
                unprison = false
            elseif s_na == 'Page' then
                sh_dialog_send_chat_command('/unpunish ' .. unprison_id .. ' 10000000', 'unprison_page')
                unprison = false
            elseif s_na == 'Sedona' then
                sh_dialog_send_chat_command('/unpunish ' .. unprison_id .. ' 15000000', 'unprison_sedona')
                unprison = false
            end
        end,
    },
    {
        key = 'rank_sync_dynamic',
        match = function(dialog)
            return dialog:has_text({ 'Должность:' })
        end,
        run = function(dialog)
            local job_pattern = sh_dialog_cp1251('Должность: ') .. '{B83434}(.-)%((%d+)%)'
            local text_org, rank_org = sh_dialog_text(dialog.text):match(job_pattern)
            local org_pattern = sh_dialog_cp1251('Организация: ') .. '{B83434}%[(.-)%]'
            local organization_name = sh_dialog_text(dialog.text):match(org_pattern)
            local clean_dialog_text = sh_dialog_strip_colors(sh_dialog_text(dialog.text))

            if not text_org or not rank_org then
                local inline_title, inline_rank = clean_dialog_text:match(':%s*([^:\r\n]-)%s*%((%d+)%)')
                if inline_title and inline_rank then
                    text_org = sh_dialog_trim(inline_title)
                    rank_org = inline_rank
                end
            end

            if not organization_name then
                organization_name = clean_dialog_text:match(':%s*%[([^%]\r\n]+)%]')
            end

            if (not text_org or not rank_org) or not organization_name then
                for line in clean_dialog_text:gmatch('[^\r\n]+') do
                    if not text_org or not rank_org then
                        local line_title, line_rank = line:match(':%s*(.-)%s*%((%d+)%)')
                        if line_title and line_rank then
                            text_org = sh_dialog_trim(line_title)
                            rank_org = line_rank
                        end
                    end

                    if not organization_name then
                        local line_org = line:match(':%s*%[([^%]]+)%]')
                        if line_org then
                            organization_name = sh_dialog_trim(line_org)
                        end
                    end
                end
            end

            if text_org and rank_org then
                setting.job_title = u8(text_org)
                setting.rank = tonumber(rank_org)

                local detected_smi_org = sh_dialog_detect_smi_org_from_text(organization_name)
                if detected_smi_org and setting.org ~= detected_smi_org then
                    setting.org = detected_smi_org
                    sh_dialog_log('info', string.format(
                        'organization auto-detected as SMI via stats dialog org=%s source="%s"',
                        tostring(detected_smi_org),
                        tostring(organization_name)
                    ))

                    local sync_ok, sync_result = pcall(sh_command_sync.sync_current_org, setting)
                    if not sync_ok then
                        print(string.format('[StateHelper] immediate org sync failed after stats dialog: %s', tostring(sync_result)))
                    else
                        pcall(reload_police_utility_commands)
                    end
                end

                save()
                sh_dialog_log('info', string.format(
                    'rank synced from dialog id=%s title="%s" rank=%s',
                    tostring(dialog.id),
                    tostring(text_org),
                    tostring(rank_org)
                ))
            elseif dialog:has_text({ 'Должность: Судья' }) then
                setting.job_title = u8(sh_dialog_cp1251('Судья'))
                setting.rank = 10
                save()
                sh_dialog_log('info', 'rank synced from judge dialog fallback')
            else
                sh_dialog_log('warn', string.format(
                    'rank sync parse failed id=%s clean_text="%s"',
                    tostring(dialog.id),
                    tostring(sh_dialog_preview(clean_dialog_text, 220))
                ))
            end

            if close_stats then
                dialog:close(0, 'close_stats_dynamic')
                close_stats = false
                return false
            end
        end,
    },
    {
        key = 'auto_inves_fill_dynamic',
        match = function(dialog)
            return type(setting.police_settings) == 'table'
                and setting.police_settings.auto_inves
                and dialog.style == 1
                and sh_dialog_text(dialog.text):find('{90EE90}', 1, true) ~= nil
        end,
        run = function(dialog)
            local extracted_text = sh_dialog_text(dialog.text):match('{90EE90}([^%{]*)')
            if extracted_text then
                dialog:respond(1, 0, sh_dialog_trim(extracted_text), 'auto_inves_fill_dynamic')
                return false
            end

            sh_dialog_log('warn', string.format(
                'auto_inves dialog matched but green value not found id=%s',
                tostring(dialog.id)
            ))
        end,
    },
    {
        key = 'doc_offer_accept_dynamic',
        match = function(dialog)
            return sh_dialog_is_active_offer(dialog.title, dialog.text)
                and sh_dialog_should_auto_offer_documents()
                and doc_numb
                and dialog:find_row_by_keywords(sh_dialog_doc_keywords) ~= nil
        end,
        run = function(dialog)
            local row, matched_line = dialog:find_row_by_keywords(sh_dialog_doc_keywords)
            if row ~= nil then
                doc_numb = false
                dialog:respond(1, row, -1, 'doc_offer_accept_dynamic')
                sh_dialog_log('info', string.format(
                    'document offer accepted id=%s row=%s line="%s"',
                    tostring(dialog.id),
                    tostring(row),
                    tostring(matched_line)
                ))
                return false
            end
        end,
    },
    {
        key = 'doc_offer_confirm_dynamic',
        match = function(dialog)
            return sh_dialog_should_auto_offer_documents()
                and dialog:find_row_by_keywords(sh_dialog_doc_keywords) ~= nil
                and dialog:has_title({ 'Подтверждение', 'Предложение', 'Оформление' })
        end,
        run = function(dialog)
            confirm_action_dialog = true
            dialog:respond(1, 2, -1, 'doc_offer_confirm_dynamic')
            return false
        end,
    },
    {
        key = 'doc_offer_followup_dynamic',
        match = function(dialog)
            return confirm_action_dialog and dialog:has_title({ 'Подтверждение', 'Оформление' })
        end,
        run = function(dialog)
            confirm_action_dialog = false
            dialog:respond(1, 5, nil, 'doc_offer_followup_dynamic')
            return false
        end,
    },
    {
        key = 'doc_offer_open_dynamic',
        match = function(dialog)
            return sh_dialog_is_active_offer(dialog.title, dialog.text)
                and sh_dialog_should_auto_offer_documents()
                and not doc_numb
                and dialog:find_row_by_keywords(sh_dialog_doc_keywords) ~= nil
        end,
        run = function(dialog)
            doc_numb = true
            dialog:respond(1, 2, nil, 'doc_offer_open_dynamic')
            return false
        end,
    },
    {
        key = 'members_parse_dynamic',
        match = function(dialog)
            return members_wait
                and members_wait.members
                and type(setting.mb) == 'table'
                and setting.mb.func
                and sh_dialog_is_members_dialog(dialog.title, dialog.text)
        end,
        run = function(dialog)
            sh_dialog_log('info', string.format('members dialog matched dynamically id=%s', tostring(dialog.id)))
            return sh_dialog_parse_members(dialog)
        end,
    },
    {
        key = 'sob_blacklist_dynamic',
        match = function(dialog)
            return run_sob and dialog:has_text({ 'Состоит в ЧС' })
        end,
        run = function(dialog)
            sob_info.blacklist = 0
            for line in sh_dialog_text(dialog.text):gmatch('[^\n]+') do
                if line:find('{FFFFFF}' .. sh_dialog_cp1251('Состоит в ЧС') .. '{FF6200}', 1, true) then
                    local value = line:match('{FFFFFF}' .. sh_dialog_cp1251('Состоит в ЧС') .. '{FF6200}(.+)')
                    if value then
                        table.insert(sob_info.bl_info, value)
                    end
                end
            end

            sh_dialog_log('info', string.format(
                'sob blacklist dialog matched dynamically id=%s status=%s',
                tostring(dialog.id),
                tostring(sob_info.blacklist)
            ))

            if type(setting.sob) == 'table' and setting.sob.close_doc then
                return false
            end
        end,
    },
    {
        key = 'government_pass_dynamic',
        match = function(dialog)
            return num_give_gov > -1 and sh_dialog_is_government_pass_dialog(dialog.title, dialog.text)
        end,
        run = function(dialog)
            dialog:respond(1, num_give_gov, nil, 'government_pass_dynamic')
            num_give_gov = -1
            return false
        end,
    },
    {
        key = 'license_sale_dynamic',
        match = function(dialog)
            return num_give_lic > -1 and sh_dialog_is_license_sale_dialog(dialog.title, dialog.text)
        end,
        run = function(dialog)
            dialog:respond(1, num_give_lic, nil, 'license_sale_dynamic')
            sh_dialog_log('info', string.format(
                'license sale dialog matched dynamically id=%s option=%s',
                tostring(dialog.id),
                tostring(num_give_lic)
            ))
            return false
        end,
    },
    {
        key = 'license_term_dynamic',
        match = function(dialog)
            return num_give_lic > -1 and sh_dialog_is_license_term_dialog(dialog.title, dialog.text)
        end,
        run = function(dialog)
            dialog:respond(1, num_give_lic_term, nil, 'license_term_dynamic')
            sh_dialog_log('info', string.format(
                'license term dialog matched dynamically id=%s option=%s',
                tostring(dialog.id),
                tostring(num_give_lic_term)
            ))
            num_give_lic = -1
            return false
        end,
    },
    {
        key = 'fire_dialog_dynamic',
        match = function(dialog)
            return setting.godeath and setting.godeath.func and sh_dialog_is_fire_list_dialog(dialog.title, dialog.text)
        end,
        run = function(dialog)
            dialog_fire = {
                id = dialog.id,
                text = {},
            }

            for line in sh_dialog_text(dialog.text):gmatch('[^\r\n]+') do
                if not sh_dialog_contains(line, { 'Ранг' }) then
                    table.insert(dialog_fire.text, line)
                end
            end

            sh_dialog_log('info', string.format(
                'fire incidents dialog matched dynamically id=%s rows=%s',
                tostring(dialog.id),
                tostring(#dialog_fire.text)
            ))

            if setting.fire and setting.fire.auto_select_fires then
                reply_from_choice_fires_dialog(0)
                dialog:respond(1, 0, nil, 'fire_auto_select_dynamic')
                return false
            end
        end,
    },
})

local function sh_dialog_handle_members_abort(dialog)
    if members_wait and members_wait.members and not sh_dialog_is_members_dialog(dialog.title, dialog.text) then
        dont_show_me_members = true
        members_wait.members = false
        members_wait.next_page.bool = false
        members_wait.next_page.i = 0

        while #members > tonumber(org.online) do
            table.remove(members, 1)
        end

        sh_dialog_log('warn', string.format(
            'members wait aborted by foreign dialog id=%s title="%s"',
            tostring(dialog.id),
            sh_dialog_preview(dialog.title, 80)
        ))
    elseif dont_show_me_members and sh_dialog_is_members_dialog(dialog.title, dialog.text) then
        dont_show_me_members = false
        lua_thread.create(function()
            wait(0)
            dialog:respond(0, nil, nil, 'members_hide_after_abort_dynamic')
        end)
        return false
    end

    return nil
end

local function sh_dialog_handle_dynamic_show(id, style, title, button_1, button_2, text)
    local dialog = sh_dialog_create_context(id, style, title, button_1, button_2, text)

    sh_dialog_log('info', string.format(
        'show id=%s style=%s title="%s" button1="%s" button2="%s" text="%s"',
        tostring(dialog.id),
        tostring(dialog.style),
        sh_dialog_preview(dialog.title, 80),
        sh_dialog_preview(dialog.button_1, 40),
        sh_dialog_preview(dialog.button_2, 40),
        sh_dialog_preview(dialog.text, 180)
    ))

    local routed_result = sh_dialog_routes.run(dialog)
    if routed_result ~= nil then
        return routed_result
    end

    local members_result = sh_dialog_handle_members_abort(dialog)
    if members_result ~= nil then
        return members_result
    end

    if lspawncar then
        sh_dialog_log('warn', string.format(
            'spawncar flow still waits for legacy dialog id, current id=%s title="%s"',
            tostring(dialog.id),
            sh_dialog_preview(dialog.title, 80)
        ))
    end

    if nickname_dialog or nickname_dialog2 or nickname_dialog3 or nickname_dialog4 then
        sh_dialog_log('warn', string.format(
            'nickname flow is still partly legacy-bound, current id=%s title="%s"',
            tostring(dialog.id),
            sh_dialog_preview(dialog.title, 80)
        ))
    end

    return nil
end

function sampev.onShowDialog(id, style, title, button_1, button_2, text)
    local ok, result = pcall(sh_dialog_handle_dynamic_show, id, style, title, button_1, button_2, text)
    if not ok then
        sh_dialog_log('error', string.format(
            'compat onShowDialog failed id=%s title="%s" error=%s',
            tostring(id),
            sh_dialog_preview(title, 80),
            tostring(result)
        ))
    elseif result ~= nil then
        return result
    end

    if type(sh_dialog_legacy_on_show_dialog) == 'function' then
        return sh_dialog_legacy_on_show_dialog(id, style, title, button_1, button_2, text)
    end
end

hook.onShowDialog = sampev.onShowDialog

function sampev.onServerMessage(color_mes, mes)
    local mes_col = bit.tohex(bit.rshift(color_mes, 8), 6)

    sh_chat_filters.normalize_settings(setting)

    if sh_chat_debug_enabled() then
        sh_protocol_log('chat-recv', string.format(
            'color=%s message="%s"',
            tostring(mes_col),
            sh_dialog_preview(mes, 180)
        ))
    end

    local filtered, filter_reason = sh_chat_filters.should_filter(setting, mes, mes_col)
    if filtered then
        sh_dialog_log('info', string.format('chat message filtered by compat rule=%s', tostring(filter_reason)))
        return false
    end

    local legacy_filtered, legacy_filter_reason = sh_dialog_should_filter_legacy_chat_message(mes, mes_col)
    if legacy_filtered then
        sh_dialog_log('info', string.format('chat message filtered by legacy game-chat rule=%s', tostring(legacy_filter_reason)))
        return false
    end

    if sh_dialog_should_auto_offer_documents() then
        if sh_dialog_contains(mes, {
            'Вам поступило предложение',
            'команду: /offer',
            'клавишу X',
        }) then
            sh_dialog_send_chat_command('/offer', 'auto_offer_message_dynamic')
            return false
        end
    end

    if setting and setting.police_settings and setting.police_settings.auto_inves then
        if sh_dialog_contains(mes, {
            'Вы заполнили все пункты',
            'Заполнить',
        }) then
            sh_dialog_log('info', 'auto_inves completion message received, trying textdraw lookup for submit button')
            if not sh_dialog_click_textdraw_by_keywords({
                'Заполнить',
                'Подтвердить',
                'Подписать',
            }, 'auto_inves_submit_dynamic') then
                sh_dialog_log('warn', 'submit textdraw not found by text, using legacy fallback id=2131')
                sh_dialog_send_click_textdraw(2131, 'auto_inves_submit_legacy')
            end
            return false
        end
    end

    if type(sh_dialog_legacy_on_server_message) == 'function' then
        return sh_dialog_legacy_on_server_message(color_mes, mes)
    end
end

hook.onServerMessage = sampev.onServerMessage

function sampev.onShowTextDraw(textdraw_id, textdraw)
    sh_textdraws.show(textdraw_id, textdraw)
    sh_protocol_log('textdraw', string.format(
        'show id=%s selectable=%s style=%s text="%s"',
        tostring(textdraw_id),
        tostring(type(textdraw) == 'table' and textdraw.selectable or nil),
        tostring(type(textdraw) == 'table' and textdraw.style or nil),
        sh_dialog_preview(sh_textdraws.extract_text(textdraw), 120)
    ))

    if type(sh_dialog_legacy_on_show_textdraw) == 'function' then
        return sh_dialog_legacy_on_show_textdraw(textdraw_id, textdraw)
    end
end

hook.onShowTextDraw = sampev.onShowTextDraw

function sampev.onTextDrawSetString(id, text)
    sh_textdraws.set_string(id, text)
    sh_protocol_log('textdraw', string.format(
        'set-string id=%s text="%s"',
        tostring(id),
        sh_dialog_preview(text, 120)
    ))

    if type(sh_dialog_legacy_on_textdraw_set_string) == 'function' then
        return sh_dialog_legacy_on_textdraw_set_string(id, text)
    end
end

hook.onTextDrawSetString = sampev.onTextDrawSetString

function sampev.onTextDrawHide(textdraw_id)
    sh_textdraws.hide(textdraw_id)
    sh_protocol_log('textdraw', string.format('hide id=%s', tostring(textdraw_id)))

    if type(sh_dialog_legacy_on_textdraw_hide) == 'function' then
        return sh_dialog_legacy_on_textdraw_hide(textdraw_id)
    end
end

hook.onTextDrawHide = sampev.onTextDrawHide

function sampev.onToggleSelectTextDraw(state, hovercolor)
    sh_textdraws.set_selectable(state, hovercolor)
    sh_protocol_log('textdraw', string.format(
        'toggle-select state=%s hovercolor=%s',
        tostring(state),
        tostring(hovercolor)
    ))

    if type(sh_dialog_legacy_on_toggle_select_textdraw) == 'function' then
        return sh_dialog_legacy_on_toggle_select_textdraw(state, hovercolor)
    end
end

hook.onToggleSelectTextDraw = sampev.onToggleSelectTextDraw

function sampev.onSendClickTextDraw(textdraw_id)
    sh_protocol_log('textdraw', string.format('send-click id=%s', tostring(textdraw_id)))

    if type(sh_dialog_legacy_on_send_click_textdraw) == 'function' then
        return sh_dialog_legacy_on_send_click_textdraw(textdraw_id)
    end
end

hook.onSendClickTextDraw = sampev.onSendClickTextDraw

function sampev.onSendDialogResponse(dialog_id, button, listbox_id, input)
    sh_protocol_log('dialog', string.format(
        'send-response id=%s button=%s list=%s input="%s"',
        tostring(dialog_id),
        tostring(button),
        tostring(listbox_id),
        sh_dialog_preview(input or '', 80)
    ))

    if type(sh_dialog_legacy_on_send_dialog_response) == 'function' then
        return sh_dialog_legacy_on_send_dialog_response(dialog_id, button, listbox_id, input)
    end
end

hook.onSendDialogResponse = sampev.onSendDialogResponse

function sampev.onSendCommand(command)
    sh_protocol_log('command', string.format('send "%s"', sh_dialog_preview(command, 120)))

    if type(sh_dialog_legacy_on_send_command) == 'function' then
        return sh_dialog_legacy_on_send_command(command)
    end
end

hook.onSendCommand = sampev.onSendCommand

function sampev.onSendChat(message)
    sh_protocol_log('chat', string.format('send "%s"', sh_dialog_preview(message, 120)))

    if type(sh_dialog_legacy_on_send_chat) == 'function' then
        return sh_dialog_legacy_on_send_chat(message)
    end
end

hook.onSendChat = sampev.onSendChat

local function sh_bind_protocol_debug_handlers()
    if sh_protocol_debug_handlers_bound or type(addEventHandler) ~= 'function' then
        return
    end

    sh_protocol_debug_handlers_bound = true

    addEventHandler('onReceiveRpc', function(id, bitStream)
        sh_protocol_log('rpc', string.format('receive id=%s', tostring(id)))
    end)

    addEventHandler('onSendRpc', function(id, bitStream, priority, reliability, orderingChannel, shiftTs)
        sh_protocol_log('rpc', string.format(
            'send id=%s priority=%s reliability=%s channel=%s shiftTs=%s',
            tostring(id),
            tostring(priority),
            tostring(reliability),
            tostring(orderingChannel),
            tostring(shiftTs)
        ))
    end)
end

local function sh_register_default_tab_command(index, command_name, reason)
    if type(setting) ~= 'table' or type(setting.command_tabs) ~= 'table' then
        return
    end

    if type(setting.command_tabs[index]) == 'string' and setting.command_tabs[index] ~= '' then
        return
    end

    setting.command_tabs[index] = command_name
    sh_actions.register_chat_command(command_name, function(arg)
        start_other_cmd(command_name, arg or '')
    end, reason)
    print(string.format('[StateHelper] default tab command assigned: /%s', tostring(command_name)))
end

local function sh_hotkey_ensure_pair(value)
    if type(value) ~= 'table' then
        return { '', {} }
    end

    if type(value[2]) ~= 'table' then
        value[2] = {}
    end

    if value[1] == nil then
        value[1] = ''
    end

    return value
end

local function sh_hotkey_sanitize_runtime_tables()
    if type(setting) ~= 'table' then
        return
    end

    if type(setting.fast) ~= 'table' then
        setting.fast = {}
    end
    setting.fast.key = sh_hotkey_ensure_pair(setting.fast.key)

    if type(setting.win_key) ~= 'table' then
        setting.win_key = { {}, {} }
    end
    if type(setting.win_key[2]) ~= 'table' then
        setting.win_key[2] = {}
    end

    if type(setting.act_key) ~= 'table' then
        setting.act_key = { {} }
    end
    if type(setting.act_key[1]) ~= 'table' then
        setting.act_key[1] = {}
    end

    if type(setting.shp) == 'table' then
        for i = 1, #setting.shp do
            if type(setting.shp[i]) == 'table' then
                setting.shp[i].key = sh_hotkey_ensure_pair(setting.shp[i].key)
            end
        end
    end

    if type(setting.key_tabs) == 'table' then
        for i = 1, #setting.key_tabs do
            if type(setting.key_tabs[i]) ~= 'table' then
                setting.key_tabs[i] = { '', {} }
            elseif type(setting.key_tabs[i][2]) ~= 'table' then
                setting.key_tabs[i][2] = {}
            end
        end
    end

    if type(setting.police_settings) == 'table' then
        setting.police_settings.siren_key = sh_hotkey_ensure_pair(setting.police_settings.siren_key)
    end

    if type(cmd) == 'table' and type(cmd[1]) == 'table' then
        for i = 1, #cmd[1] do
            if type(cmd[1][i]) == 'table' then
                cmd[1][i].key = sh_hotkey_ensure_pair(cmd[1][i].key)
            end
        end
    end
end

local function sh_patch_on_hot_key_guard()
    if rawget(_G, 'sh_on_hot_key_guard_enabled') then
        return
    end

    if type(rawget(_G, 'on_hot_key')) ~= 'function' then
        return
    end

    local legacy_on_hot_key = on_hot_key
    _G.sh_on_hot_key_guard_enabled = true

    _G.on_hot_key = function(id_pr_key)
        pcall(sh_hotkey_sanitize_runtime_tables)
        local ok, result = pcall(legacy_on_hot_key, id_pr_key)
        if not ok then
            print(string.format('[StateHelper] on_hot_key failed: %s', tostring(result)))
            return nil
        end
        return result
    end
end

sh_bind_protocol_debug_handlers()
sh_patch_on_hot_key_guard()

lua_thread.create(function()
    local last_synced_org = nil

    repeat
        wait(250)
    until type(isSampAvailable) == 'function'
        and isSampAvailable()
        and rawget(_G, 'setting') ~= nil

    wait(750)
    sh_patch_on_hot_key_guard()
    local input_ok, input_err = pcall(sh_patch_gui_input_text)
    if not input_ok then
        print(string.format('[StateHelper] failed to enable safe InputText wrapper: %s', tostring(input_err)))
    end

    local commands_ok, commands_err = pcall(function()
        sh_register_default_tab_command(3, 'dep', 'default_dep_tab_command')
        sh_register_default_tab_command(4, 'sob', 'default_sob_tab_command')
        save()
    end)
    if not commands_ok then
        print(string.format('[StateHelper] default tab command setup failed: %s', tostring(commands_err)))
    end

    local ok, err = pcall(reload_police_utility_commands)
    if not ok then
        print(string.format('[StateHelper] police utility command sync failed: %s', tostring(err)))
    end

    while true do
        wait(600)

        local current_org = type(setting) == 'table' and tonumber(setting.org) or nil
        if current_org and current_org ~= last_synced_org then
            local sync_ok, sync_result = pcall(sh_command_sync.sync_current_org, setting)
            if not sync_ok then
                print(string.format('[StateHelper] org command sync failed: %s', tostring(sync_result)))
            elseif sync_result ~= nil then
                last_synced_org = current_org
                pcall(reload_police_utility_commands)
                if type(save) == 'function' then
                    pcall(save)
                end
            end
        end
    end
end)
