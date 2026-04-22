--[[
Open with encoding: CP1251
StateHelper/features/settings/settings_core.lua
]]

function hall.settings()
	gui.Draw({4, 39}, {220, 369}, cl.tab, 0, 15)
	imgui.SetCursorPos(imgui.ImVec2(4, 39))
	imgui.BeginChild(u8'Вкладка настроек', imgui.ImVec2(222, 369), false, imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollWithMouse)
	local function new_tab_setting(color_tab_set, icon_tab_set, name_tab_set, num_return_tab_set, num_pos_plus_tab_set, sdvig_icon, sdvig_draw)
		if sdvig_icon == nil then sdvig_icon = {0, 0} end
		if sdvig_draw == nil then sdvig_draw = 0 end
		num_pos_plus_tab_set = num_pos_plus_tab_set + num_return_tab_set
		imgui.SetCursorPos(imgui.ImVec2(0, 66 + ((num_pos_plus_tab_set - 1) * 32)))
		if imgui.InvisibleButton(u8'##Кнопка перехода во вкладку ' .. num_return_tab_set, imgui.ImVec2(220, 29)) then
			tab_settings = num_return_tab_set
			if tab_settings == 13 then
				up_child_sub = 0
				developer_mode = developer_mode + 1
			elseif tab_settings == 6 then
				if setting.fire.auto_send then
					an[27] = 42
					ANIMATE[1] = animate(42, 42, 42, 42, an[27], an[27], 1, 4)
				else
					an[27] = 0
					ANIMATE[2] = animate(0, 0, 0, 0, an[27], an[27], 1, 4)
				end
			elseif tab_settings == 12 then
				if search_for_new_version == 0 and new_version == '0' then
					search_for_new_version = 615
					update_check()
				end
			end
		end
		if num_return_tab_set == tab_settings then
			gui.Draw({10, 66 + ((num_pos_plus_tab_set - 1) * 32)}, {200, 29}, cl.def, 4, 15)
		end
		gui.Draw({14, 70 + ((num_pos_plus_tab_set - 1) * 32)}, {21 + sdvig_draw, 20}, color_tab_set, 4, 15)
		
		imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.95, 0.95, 0.95, 1.00))
		imgui.PushFont(fa_font[2])
		imgui.SetCursorPos(imgui.ImVec2(18 + sdvig_icon[1], 73 + sdvig_icon[2] + ((num_pos_plus_tab_set - 1) * 32)))
		imgui.Text(icon_tab_set)
		imgui.PopFont()
		imgui.PopStyleColor(1)
		if setting.cl == 'White' and num_return_tab_set == tab_settings then
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.95, 0.95, 0.95, 1.00))
			gui.Text(43, 73 + ((num_pos_plus_tab_set - 1) * 32), name_tab_set, font[3])
			imgui.PopStyleColor(1)
		else
			gui.Text(43, 73 + ((num_pos_plus_tab_set - 1) * 32), name_tab_set, font[3])
		end
	end
	imgui.Scroller(u8'Вкладка настроек', img_step[1][0], img_duration[1][0], imgui.HoveredFlags.AllowWhenBlockedByActiveItem)
	
	if setting.cl == 'White' then
		gui.DrawCircle({29, 32}, 20, cl.circ_im)
	else
		gui.DrawCircle({29, 32}, 20, cl.circ_im)
	end
	local all_org = {
		'Больница Лос-Сантос', 'Больница Сан-Фиерро', 'Больница Лас-Вентурас', 'Больница Джефферсон', 
		'Центр Лицензирования', 'Правительство', 
		'Армия Лос-Сантос', 'Армия Сан-Фиерро', 
		'Пожарный департамент', 'Тюрьма строгого режима',
		'Полиция Лос-Сантос', 'Полиция Лас-Вентурас', 'Полиция Сан-Фиерро', 'Полиция Рэд-Каунти', 'ФБР',
		'СМИ ЛС', 'СМИ СФ', 'СМИ ЛВ'
	}
	local num_char = #u8:decode(setting.name_rus)
	if num_char <= 19 then
		gui.Text(57, 17, u8:decode(setting.name_rus), font[3])
	elseif num_char <= 22 then
		gui.Text(57, 17, u8:decode(setting.name_rus), font[2])
	else
		local wrapped_text, newline_count = wrapText(u8:decode(setting.name_rus), 22, 22)
		gui.Text(57, 17, wrapped_text, font[2])
	end
	
	imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
	gui.Text(57, 33, all_org[setting.org], font[2])
	imgui.PopStyleColor(1)
	imgui.PushFont(fa_font[4])
	imgui.SetCursorPos(imgui.ImVec2(22, 23))
	imgui.Text(fa.USER)
	imgui.PopFont()
	local pos_tab_pl = 0
	new_tab_setting(imgui.ImVec4(0.56, 0.56, 0.58, 1.00), fa.LOCK, 'Личная информация', 1, 0 + pos_tab_pl, {1, 0})
	new_tab_setting(imgui.ImVec4(0.00, 0.40, 1.00, 1.00), fa.COMMENT, 'Игровой чат', 2, 0 + pos_tab_pl)
	if setting.org <= 5 --[[or setting.org == 10]] then
		new_tab_setting(imgui.ImVec4(0.30, 0.80, 0.39, 1.00), fa.COINS, 'Ценовая политика', 3, 0 + pos_tab_pl)
	else
		pos_tab_pl = pos_tab_pl - 1
	end
	new_tab_setting(imgui.ImVec4(1.00, 0.18, 0.33, 1.00), fa.RSS, 'Быстрый доступ', 4, 0 + pos_tab_pl, {1, 0})
	new_tab_setting(imgui.ImVec4(0.00, 0.40, 1.00, 1.00), fa.USER, 'Мемберс', 5, 0 + pos_tab_pl, {1, 0})
	if setting.org <= 4 then
		new_tab_setting(imgui.ImVec4(1.00, 0.18, 0.33, 1.00), fa.TRUCK_MEDICAL, 'Вызовы', 6, 0 + pos_tab_pl, {-1.5, 0})
	elseif setting.org == 9 then
		new_tab_setting(imgui.ImVec4(1.00, 0.18, 0.15, 1.00), fa.FIRE, 'Вызовы', 6, 0 + pos_tab_pl, {1, 0})
	elseif setting.org >= 10 and setting.org <= 15 then
		new_tab_setting(imgui.ImVec4(0.50, 0.50, 0.50, 1.00), fa.WRENCH, 'Доп. настройки', 6, 0 + pos_tab_pl, {0, 0})
	--elseif setting.org == 10 then
		--new_tab_setting(imgui.ImVec4(0.50, 0.50, 0.50, 1.00), fa.GAVEL, 'Доп. настройки', 6, 0 + pos_tab_pl, {0, 0})
	else
		pos_tab_pl = pos_tab_pl -1
	end
	
	new_tab_setting(imgui.ImVec4(0.00, 0.40, 1.00, 1.00), fa.PAPER_PLANE, 'Уведомления', 7, 0.5 + pos_tab_pl)
	new_tab_setting(imgui.ImVec4(1.00, 0.18, 0.33, 1.00), fa.COMMENT_DOTS, 'Акцент', 8, 0.5 + pos_tab_pl)
	new_tab_setting(imgui.ImVec4(0.56, 0.56, 0.58, 1.00), fa.TOGGLE_ON, 'Другие функции', 9, 0.5 + pos_tab_pl, {-1, 0})
	
	new_tab_setting(imgui.ImVec4(0.56, 0.56, 0.58, 1.00), fa.COMPACT_DISC, 'Оформление', 10, 1 + pos_tab_pl)
	new_tab_setting(imgui.ImVec4(0.56, 0.56, 0.58, 1.00), fa.SLIDERS, 'Параметры скрипта', 11, 1 + pos_tab_pl)
	new_tab_setting(imgui.ImVec4(0.70, 0.30, 1.00, 1.00), fa.DOWNLOAD, 'Обновление', 12, 1 + pos_tab_pl)
	new_tab_setting(imgui.ImVec4(0.56, 0.56, 0.58, 1.00), fa.CODE, 'О скрипте', 13, 1 + pos_tab_pl, {-1, 0}, 1)
	
	new_tab_setting(imgui.ImVec4(0.56, 0.56, 0.58, 1.00), fa.HAMMER, 'Команды', 14, 1.5 + pos_tab_pl)
	new_tab_setting(imgui.ImVec4(0.56, 0.56, 0.58, 1.00), fa.BOOK, 'Шпаргалки', 15, 1.5 + pos_tab_pl, {1, 0})
	new_tab_setting(imgui.ImVec4(0.56, 0.56, 0.58, 1.00), fa.SIGNAL, 'Департамент', 16, 1.5 + pos_tab_pl)
	new_tab_setting(imgui.ImVec4(0.56, 0.56, 0.58, 1.00), fa.USER_PLUS, 'Собеседование', 17, 1.5 + pos_tab_pl)
	new_tab_setting(imgui.ImVec4(0.56, 0.56, 0.58, 1.00), fa.BELL, 'Напоминания', 18, 1.5 + pos_tab_pl, {1, 0})
	new_tab_setting(imgui.ImVec4(0.56, 0.56, 0.58, 1.00), fa.CHART_SIMPLE, 'Статистика', 19, 1.5 + pos_tab_pl, {1, 0})
	new_tab_setting(imgui.ImVec4(0.56, 0.56, 0.58, 1.00), fa.MUSIC, 'Музыка', 20, 1.5 + pos_tab_pl)
	new_tab_setting(imgui.ImVec4(0.56, 0.56, 0.58, 1.00), fa.OBJECT_UNGROUP, 'РП зона', 21, 1.5 + pos_tab_pl, {-1, 0})
	new_tab_setting(imgui.ImVec4(0.56, 0.56, 0.58, 1.00), fa.CUBE, 'Действия', 22, 1.5 + pos_tab_pl) --(0.11, 0.80, 0.62, 1.00)
	
	imgui.Dummy(imgui.ImVec2(0, 8))
	if bool_go_stat_set then
		bool_go_stat_set = false
		imgui.SetScrollY(imgui.GetScrollMaxY())
	end
	imgui.EndChild()
	hovered_bool_not_child = imgui.IsItemHovered()
	
	imgui.SetCursorPos(imgui.ImVec2(226, 39))
	--if tab_settings == 4 then size_y_child = 335 end
	imgui.BeginChild(u8'Суть вкладки главное', imgui.ImVec2(618, tab_settings == 4 and 335 or 369), false, imgui.WindowFlags.NoScrollWithMouse + (tab_settings == 13 and imgui.WindowFlags.NoScrollbar or 0))
	imgui.Scroller(u8'Суть вкладки главное', img_step[1][0], img_duration[1][0])
	
	local function cmd_amd_key_tab(i_tabs)
		local cmd_text_edit = u8'Назначить...'
		local key_text_edit = u8'Назначить...'
		local func_true_or_false_return = false
		if setting.key_tabs[i_tabs][1] ~= '' then
			key_text_edit = u8'Изменить...'
		end
		if setting.command_tabs[i_tabs] ~= '' then
			cmd_text_edit = u8'Изменить...'
		end
		new_draw(16, 71)
		gui.DrawLine({16, 51}, {602, 51}, cl.line)
		gui.Text(26, 25, 'Команда для открытия вкладки:', font[3])
		imgui.PushFont(font[3])
		imgui.SetCursorPos(imgui.ImVec2(241, 24))
		if setting.command_tabs[i_tabs] == '' then
			imgui.TextColored(imgui.ImVec4(0.50, 0.50, 0.50, 0.50), u8'Отсутствует')
		else
			imgui.TextColored(imgui.ImVec4(0.50, 0.50, 0.50, 0.50), u8'/' .. setting.command_tabs[i_tabs])
			func_true_or_false_return = true
		end
		imgui.PopFont()
		if gui.Button(cmd_text_edit .. u8'##команду для вкладки', {492, 21}, {100, 25}) then
			lockPlayerControl(true)
			edit_cmd = true
			cur_cmd = setting.command_tabs[i_tabs]
			new_cmd = setting.command_tabs[i_tabs]
			imgui.OpenPopup(u8'Изменить команду для открытия вкладки' .. i_tabs)
		end
		
		gui.Text(26, 61, 'Клавиша активации для открытия вкладки:', font[3])
		imgui.PushFont(font[3])
		imgui.SetCursorPos(imgui.ImVec2(312, 62))
		if setting.key_tabs[i_tabs][1] == '' then
			imgui.TextColored(imgui.ImVec4(0.50, 0.50, 0.50, 0.50), u8'Отсутствует')
		else
			imgui.TextColored(imgui.ImVec4(0.50, 0.50, 0.50, 0.50), setting.key_tabs[i_tabs][1])
		end
		imgui.PopFont()
		if gui.Button(key_text_edit .. u8'##клавишу активации для вкладки', {492, 57}, {100, 25}) then
			current_key = {'', {}}
			imgui.OpenPopup(u8'Изменить клавишу активации открытия вкладки' .. i_tabs)
			lockPlayerControl(true)
			edit_key = true
			win_key = setting.key_tabs[1][2]
		end
		
		local bool_result = key_edit(u8'Изменить клавишу активации открытия вкладки' .. i_tabs, setting.key_tabs[i_tabs])
		if bool_result[1] then
			setting.key_tabs[i_tabs] = bool_result[2]
			save()
		end
		
		if edit_cmd then
			local cmd_end = cmd_edit(u8'Изменить команду для открытия вкладки' .. i_tabs, cur_cmd)
			if cmd_end then
				if cmd_end ~= '' then
					setting.command_tabs[i_tabs] = cmd_end
					sampRegisterChatCommand(cmd_end, function(arg)
						start_other_cmd(cmd_end, arg)
					end)
				else
					setting.command_tabs[i_tabs] = ''
				end
				save()
				add_cmd_in_all_cmd()
			end
		end
		
		return func_true_or_false_return
	end
	
	if tab_settings == 1 then
		gui.Text(25, 12, 'Основное', bold_font[1])
		new_draw(37, 87)
		
		gui.Text(26, 50, 'Никнейм на русском', font[3])
		local bool_save_input = setting.name_rus
		setting.name_rus = gui.InputText({350, 52}, 231, setting.name_rus, u8'Имя на русском языке', 60, u8'Введите Ваш никнейм на русском', 'rus')
		if setting.name_rus ~= bool_save_input then
			save()
		end
		gui.DrawLine({16, 80}, {602, 80}, cl.line)
		gui.Text(26, 94, 'Пол персонажа', font[3])
		
		local bool_save_list = setting.sex
		setting.sex = gui.ListTableHorizontal({348, 91}, {u8'Мужской', u8'Женский'}, setting.sex, u8'Выбрать пол персонажа')
		if setting.sex ~= bool_save_list then
			save()
		end
		
		gui.Text(25, 143, 'Организация', bold_font[1])
		new_draw(168, 87)
		
		gui.Text(26, 181, 'Организация', font[3])
		local bool_set_org = setting.org
		setting.org = gui.ListTableMove({572, 181}, {u8'Больница Лос-Сантос', u8'Больница Сан-Фиерро', u8'Больница Лас-Вентурас', u8'Больница Джефферсон', u8'Центр Лицензирования', u8'Правительство', u8'Армия Лос-Сантос', u8'Армия Сан-Фиерро', u8'Пожарный департамент', u8'Тюрьма строгого режима', u8'Полиция Лос-Сантос', u8'Полиция Лас-Вентурас', u8'Полиция Сан-Фиерро', u8'Полиция Рэд-Каунти', u8'ФБР', u8'СМИ ЛС', u8'СМИ СФ', u8'СМИ ЛВ'}, setting.org, 'Select Organization')
		--setting.org = gui.ListTableMove({572, 181}, {u8'Больница Лос-Сантос', u8'Больница Сан-Фиерро', u8'Больница Лас-Вентурас', u8'Больница Джефферсон', u8'Центр Лицензирования', u8'Правительство', u8'Армия Лос-Сантос', u8'Армия Сан-Фиерро', u8'Пожарный департамент', u8'Тюрьма строгого режима', u8'СМИ ЛС', u8'СМИ СФ', u8'СМИ ЛВ'}, setting.org, 'Select Organization')
		if setting.org ~= bool_set_org then
			setting.gun_func = false
			if setting.org <= 4 then --> Для Больниц
				for i = 1, #cmd_defoult.hospital do
					local command_return = false
					if #cmd[1] ~= 0 then
						for c = 1, #cmd[1] do
							if cmd[1][c].cmd == cmd_defoult.hospital[i].cmd then
								command_return = true
							end
						end
					end
					if not command_return then
						table.insert(cmd[1], cmd_defoult.hospital[i])
						sampRegisterChatCommand(cmd_defoult.hospital[i].cmd, function(arg) 
						cmd_start(arg, tostring(cmd_defoult.hospital[i].UID) .. cmd_defoult.hospital[i].cmd) end)
						
						if s_na == 'Phoenix' then 
							for i = 1, #cmd[1] do
								if cmd[1][i].cmd == 'mc' then
									cmd[1][i] = mc_phoenix
								end
							end
						end
					end
				end
			elseif setting.org == 5 then --> Для ЦЛ
				for i = 1, #cmd_defoult.driving_school do
					local command_return = false
					if #cmd[1] ~= 0 then
						for c = 1, #cmd[1] do
							if cmd[1][c].cmd == cmd_defoult.driving_school[i].cmd then
								command_return = true
							end
						end
					end
					if not command_return then
						table.insert(cmd[1], cmd_defoult.driving_school[i])
						sampRegisterChatCommand(cmd_defoult.driving_school[i].cmd, function(arg) 
						cmd_start(arg, tostring(cmd_defoult.driving_school[i].UID) .. cmd_defoult.driving_school[i].cmd) end)
					end
				end
			elseif setting.org == 6 then --> Для Права
				for i = 1, #cmd_defoult.government do
					local command_return = false
					if #cmd[1] ~= 0 then
						for c = 1, #cmd[1] do
							if cmd[1][c].cmd == cmd_defoult.government[i].cmd then
								command_return = true
							end
						end
					end
					if not command_return then
						table.insert(cmd[1], cmd_defoult.government[i])
						sampRegisterChatCommand(cmd_defoult.government[i].cmd, function(arg) 
						cmd_start(arg, tostring(cmd_defoult.government[i].UID) .. cmd_defoult.government[i].cmd) end)
					end
				end
			elseif setting.org == 7 or setting.org == 8 then --> Для Армии
				for i = 1, #cmd_defoult.army do
					local command_return = false
					if #cmd[1] ~= 0 then
						for c = 1, #cmd[1] do
							if cmd[1][c].cmd == cmd_defoult.army[i].cmd then
								command_return = true
							end
						end
					end
					if not command_return then
						table.insert(cmd[1], cmd_defoult.army[i])
						sampRegisterChatCommand(cmd_defoult.army[i].cmd, function(arg) 
						cmd_start(arg, tostring(cmd_defoult.army[i].UID) .. cmd_defoult.army[i].cmd) end)
					end
					setting.gun_func = true
				end
			elseif setting.org == 9 then --> Для Пожарки
				for i = 1, #cmd_defoult.fire_department do
					local command_return = false
					if #cmd[1] ~= 0 then
						for c = 1, #cmd[1] do
							if cmd[1][c].cmd == cmd_defoult.fire_department[i].cmd then
								command_return = true
							end
						end
					end
					if not command_return then
						table.insert(cmd[1], cmd_defoult.fire_department[i])
						sampRegisterChatCommand(cmd_defoult.fire_department[i].cmd, function(arg) 
						cmd_start(arg, tostring(cmd_defoult.fire_department[i].UID) .. cmd_defoult.fire_department[i].cmd) end)
					end
				end
			elseif setting.org == 10 then --> Для ТСР
				new_draw(16, 103)
	
				gui.Text(26, 25, 'Умное изменение срока', font[3])
				imgui.SetCursorPos(imgui.ImVec2(561, 21))
				local toggled_smart_punish, new_smart_punish = gui.Switch('##smart_punish', setting.tsr_settings.smart_punish)
				if toggled_smart_punish then
					setting.tsr_settings.smart_punish = new_smart_punish
					save()
					reload_punish_cmd() 
				end
				gui.TextInfo({26, 44}, {'Позволяет удобно изменять срок заключенным, активация /punish'})
				
				gui.DrawLine({16, 72}, {602, 72}, cl.line)
				for i = 1, #cmd_defoult.jail do
					local command_return = false
					if #cmd[1] ~= 0 then
						for c = 1, #cmd[1] do
							if cmd[1][c].cmd == cmd_defoult.jail[i].cmd then
								command_return = true
							end
						end
					end
					if not command_return then
						table.insert(cmd[1], cmd_defoult.jail[i])
						sampRegisterChatCommand(cmd_defoult.jail[i].cmd, function(arg) 
						cmd_start(arg, tostring(cmd_defoult.jail[i].UID) .. cmd_defoult.jail[i].cmd) end)
					end
					setting.gun_func = true
				end
			elseif setting.org >= 16 and setting.org <= 18 then --> Для СМИ
				for i = 1, #cmd_defoult.smi do
					local command_return = false
					if #cmd[1] ~= 0 then
						for c = 1, #cmd[1] do
							if cmd[1][c].cmd == cmd_defoult.smi[i].cmd then
								command_return = true
							end
						end
					end
					if not command_return then
						table.insert(cmd[1], cmd_defoult.smi[i])
						sampRegisterChatCommand(cmd_defoult.smi[i].cmd, function(arg) 
						cmd_start(arg, tostring(cmd_defoult.smi[i].UID) .. cmd_defoult.smi[i].cmd) end)
					end
				end
			elseif setting.org >= 11 and setting.org <= 15 then --> Для Полиции
				for i = 1, #cmd_defoult.police do
					local command_return = false
					if #cmd[1] ~= 0 then
						for c = 1, #cmd[1] do
							if cmd[1][c].cmd == cmd_defoult.police[i].cmd then
								command_return = true
							end
						end
					end
					if not command_return then
						table.insert(cmd[1], cmd_defoult.police[i])
						sampRegisterChatCommand(cmd_defoult.police[i].cmd, function(arg) 
						cmd_start(arg, tostring(cmd_defoult.police[i].UID) .. cmd_defoult.police[i].cmd) end)
					end
					setting.gun_func = true
				end
			end
			
			add_cmd_in_all_cmd()
			save_cmd()
			save()
		end
		gui.DrawLine({16, 211}, {602, 211}, cl.line)
		
		gui.Text(26, 225, 'Должность', font[3])
		
		if setting.job_title == u8'Не определено' then
			local calc_jt = imgui.CalcTextSize(setting.job_title)
			gui.Text(587 - calc_jt.x, 225, u8:decode(setting.job_title), font[3])
		else
			local calc_jt = imgui.CalcTextSize(setting.job_title .. ' [' .. setting.rank ..']')
			gui.Text(587 - calc_jt.x, 225, u8:decode(setting.job_title .. ' [' .. setting.rank ..']'), font[3])
		end
	elseif tab_settings == 2 then
		gui.Text(25, 12, 'Получаемые сообщения', bold_font[1])
		new_draw(37, 431)
		
		for i = 0, 10 do
			gui.DrawLine({16, 72 + (i * 36)}, {602, 72 + (i * 36)}, cl.line)
		end
		
		gui.Text(26, 46, 'Скрыть частые подсказки сервера', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 42))
		if gui.Switch(u8'##Скрыть частые подсказки', setting.put_mes[1]) then
			setting.put_mes[1] = not setting.put_mes[1]
			save()
		end
		gui.Text(26, 82, 'Скрыть объявления в СМИ от игроков', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 77))
		if gui.Switch(u8'##Скрыть объявления в СМИ от игроков', setting.put_mes[2]) then
			setting.put_mes[2] = not setting.put_mes[2]
			save()
		end
		gui.Text(26, 118, 'Скрыть репортажи и новости от СМИ', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 113))
		if gui.Switch(u8'##Скрыть репортажи и новости от СМИ', setting.put_mes[3]) then
			setting.put_mes[3] = not setting.put_mes[3]
			save()
		end
		gui.Text(26, 154, 'Скрыть удачи игроков при открытии ларцов', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 149))
		if gui.Switch(u8'##Скрыть удачи игроков при открытии ларцов', setting.put_mes[4]) then
			setting.put_mes[4] = not setting.put_mes[4]
			save()
		end
		gui.Text(26, 190, 'Скрыть информацию о сборе средств в организации', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 185))
		if gui.Switch(u8'##Скрыть информацию о сборе средств в организации', setting.put_mes[5]) then
			setting.put_mes[5] = not setting.put_mes[5]
			save()
		end
		gui.Text(26, 226, 'Скрыть сообщения в вип чате', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 221))
		if gui.Switch(u8'##Скрыть сообщения в вип чате', setting.put_mes[6]) then
			setting.put_mes[6] = not setting.put_mes[6]
			save()
		end
		gui.Text(26, 262, 'Скрыть сообщения о лотерее', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 257))
		if gui.Switch(u8'##Скрыть сообщения о лотерее', setting.put_mes[7]) then
			setting.put_mes[7] = not setting.put_mes[7]
			save()
		end
		gui.Text(26, 298, 'Скрыть государственные новости', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 293))
		if gui.Switch(u8'##Скрыть государственные новости', setting.put_mes[8]) then
			setting.put_mes[8] = not setting.put_mes[8]
			save()
		end
		gui.Text(26, 334, 'Скрыть сообщения рации департамента', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 329))
		if gui.Switch(u8'##Скрыть сообщения рации департамента', setting.put_mes[9]) then
			setting.put_mes[9] = not setting.put_mes[9]
			save()
		end
		gui.Text(26, 370, 'Скрыть сообщения рации организации', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 365))
		if gui.Switch(u8'##Скрыть сообщения рации организации', setting.put_mes[10]) then
			setting.put_mes[10] = not setting.put_mes[10]
			save()
		end
		gui.Text(26, 406, 'Заменить сообщения о флуде всплывающей надписью', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 401))
		if gui.Switch(u8'##Заменить сообщение о флуде', setting.replace_not_flood) then
			setting.replace_not_flood = not setting.replace_not_flood
			save()
		end
		gui.Text(26, 442, 'Изменить цвет ника по цвету организации', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 437))
		if gui.Switch(u8'##Цветные ники', setting.color_nick) then
			setting.color_nick = not setting.color_nick
			save()
		end
		if setting.color_nick then
			if gui.Button(u8'Настроить', {370, 442}, {130, 20}) then
				imgui.OpenPopup(u8'Настроить цвет ника')
			end
		else
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
			imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
			imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
			gui.Button(u8'Настроить', {370, 442}, {130, 20}, false)
			imgui.PopStyleColor(3)
		end
		if imgui.BeginPopupModal(u8'Настроить цвет ника', null, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar) then
			imgui.SetCursorPos(imgui.ImVec2(0, 0))
			imgui.BeginChild(u8'Настройки цветов', imgui.ImVec2(730, 164), false, imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoScrollbar)
			imgui.SetCursorPos(imgui.ImVec2(710, 2))
			if imgui.InvisibleButton(u8'##Закрыть окно настроек', imgui.ImVec2(20, 20)) then
				save()
				imgui.CloseCurrentPopup()
			end
			if imgui.IsItemHovered() then
				gui.DrawCircle({721, 12}, 7, imgui.ImVec4(0.98, 0.30, 0.38, 1.00))
			else
				gui.DrawCircle({721, 12}, 7, imgui.ImVec4(0.98, 0.40, 0.38, 1.00))
			end			
			gui.Draw({16, 16}, {698, 148}, cl.tab, 7, 15)
			gui.Text(26, 26, 'Заменять цвет текста в IC сообщениях', font[3])
			imgui.SameLine(0, 10)
			if gui.Switch(u8'##Заменить IC', setting.replace_ic) then
				setting.replace_ic = not setting.replace_ic
				save()
			end
			gui.Text(26, 62, 'Заменять цвет текста в /s', font[3])
			imgui.SameLine(0, 10)
			if gui.Switch(u8'##Заменить /s', setting.replace_s) then
				setting.replace_s = not setting.replace_s
				save()
			end
			gui.Text(26, 98, 'Заменять цвет текста в /c', font[3])
			imgui.SameLine(0, 10)
			if gui.Switch(u8'##Заменить /c', setting.replace_c) then
				setting.replace_c = not setting.replace_c
				save()
			end
			gui.Text(26, 134, 'Заменять цвет текста в /b', font[3])
			imgui.SameLine(0, 10)
			if gui.Switch(u8'##Заменить /b', setting.replace_b) then
				setting.replace_b = not setting.replace_b
				save()
			end
			imgui.Dummy(imgui.ImVec2(0, 20))
			imgui.EndChild()
			imgui.Dummy(imgui.ImVec2(0, 13))
			imgui.EndPopup()
		end

		gui.Text(25, 487, 'Отыгровки', bold_font[1])
		new_draw(512, 694)
		
		gui.Text(26, 521, 'Корректор чата', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 516))
		if gui.Switch(u8'##Корректор чата', setting.chat_corrector) then
			setting.chat_corrector = not setting.chat_corrector
			save()
		end
		gui.TextInfo({26, 540}, {'Автоматически делает первую букву заглавной, ставит точку в конце,', 'пробел после запятой и исправляет регистр после знаков . ? !'})
		gui.DrawLine({16, 575}, {602, 575}, cl.line)

		gui.Text(26, 585, 'Автокоррекция отыгровок /me, /do, /todo', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 580))
		if gui.Switch(u8'##Автокоррекция отыгровок', setting.auto_edit) then
			setting.auto_edit = not setting.auto_edit
			save()
		end
		gui.DrawLine({16, 611}, {602, 611}, cl.line)

		gui.Text(26, 621, 'Автоотыгровка при принятии документов', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 616))
		if gui.Switch(u8'##Автоотыгровка при принятии документов', setting.auto_cmd_doc) then
			setting.auto_cmd_doc = not setting.auto_cmd_doc
			save()
		end
		gui.TextInfo({26, 640}, {'При просмотре паспорта, лицензий, медицинской карты или трудовой книжки, будет', 'автоматически воспроизведена отыгровка взятия просматриваемого документа.'})
		gui.DrawLine({16, 679}, {602, 679}, cl.line)

		gui.Text(26, 689, 'Автоотыгровка при закрытии документов', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 685))
		if gui.Switch(u8'##Автоотыгровка при закрытии документов', setting.auto_close_doc) then
			setting.auto_close_doc = not setting.auto_close_doc
			save()
		end
		gui.TextInfo({26, 708}, {'При закрытии окна с документами в чате автоматически будет воспроизведена отыгровка.'})
		gui.DrawLine({16, 737}, {602, 737}, cl.line)

		gui.Text(26, 747, 'Автоотыгровка дубинки', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 743))
		if gui.Switch(u8'##Автоотыгровка дубинки', setting.auto_cmd_tazer) then
			setting.auto_cmd_tazer = not setting.auto_cmd_tazer
			save()
		end
		gui.DrawLine({16, 774}, {602, 774}, cl.line)

		gui.Text(26, 784, 'Автоотыгровка /time', font[3])
		local bool_set_time = setting.auto_cmd_time
		setting.auto_cmd_time = gui.InputText({190, 786}, 391, setting.auto_cmd_time, u8'Автоотыгровка time', 230, u8'Введите текст отыгровки')
		if setting.auto_cmd_time ~= bool_set_time then
			save()
		end
		gui.TextInfo({26, 815}, {'После ввода команды /time, будет автоматически воспроизведена введённая Вами отыгровка.', 'Оставьте поле пустым, если не нужно.'})
		gui.DrawLine({16, 851}, {602, 851}, cl.line)

		gui.Text(26, 861, 'Автоотыгровка /r', font[3])
		local bool_set_r = setting.auto_cmd_r
		setting.auto_cmd_r = gui.InputText({190, 863}, 391, setting.auto_cmd_r, u8'Автоотыгровка r', 230, u8'Введите текст отыгровки')
		if setting.auto_cmd_r ~= bool_set_r then
			save()
		end
		gui.TextInfo({26, 892}, {'После ввода команды /r, будет автоматически воспроизведена введённая Вами отыгровка.', 'Оставьте поле пустым, если не нужно.'})
		gui.DrawLine({16, 928}, {602, 928}, cl.line)

		gui.Text(26, 938, 'Тег в рацию /r', font[3])
		local bool_set_teg = setting.teg_r
		setting.teg_r = gui.InputText({190, 940}, 391, setting.teg_r, u8'Тег в рацию организации', 250, u8'Введите тег для рации')
		if setting.teg_r ~= bool_set_teg then
			save()
		end
		gui.TextInfo({26, 969}, {'О необходимости использования тега уточните у лидера Вашей организации.'})
		gui.DrawLine({16, 1005}, {602, 1005}, cl.line)

		gui.Text(26, 1015, 'Использовать автоотыгровки при взаимодействии с оружием', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 1011))
		if gui.Switch(u8'##Автоотыгровка взаимодействия с оружием', setting.gun_func) then
			setting.gun_func = not setting.gun_func
			save()
		end
		if setting.gun_func then
			gui.Text(26, 1041, 'Отыгровки оружия', font[3])
			if gui.Button(u8'Редактировать...', {460, 1038}, {130, 25}) then
				imgui.OpenPopup(u8'Редактировать отыгровки оружия')
				gun_bool = deep_copy(setting.gun)
			end
		else
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
			gui.Text(26, 1041, 'Отыгровки оружия', font[3])
			imgui.PopStyleColor(1)
			gui.Button(u8'Редактировать...', {460, 1038}, {130, 25}, false)
		end
		gui.DrawLine({16, 1069}, {602, 1069}, cl.line)

		gui.Text(26, 1079, 'Автоматический перенос длинного текста в игровом чате', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 1075))
		if gui.Switch(u8'##Автоматический перенос длинного текста в игровом чате', setting.wrap_text_chat.func) then
			setting.wrap_text_chat.func = not setting.wrap_text_chat.func
			save()
		end
		
		if setting.wrap_text_chat.func then
			gui.Text(26, 1106, 'Переносить текст после достижения', font[3])
			local bool_set_wrap = setting.wrap_text_chat.num_char
			setting.wrap_text_chat.num_char = gui.InputText({274, 1106}, 30, setting.wrap_text_chat.num_char, u8'Количество символов переносимого текста', 4, u8'Число', 'num')
			if setting.wrap_text_chat.num_char ~= bool_set_wrap then
				if setting.wrap_text_chat.num_char == '' then
					setting.wrap_text_chat.num_char = '128'
				end
				save()
			end
			gui.Text(320, 1106, 'символов', font[3])
		else
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
			gui.Text(26, 1106, 'Переносить текст после достижения', font[3])
			gui.Text(320, 1106, 'символов', font[3])
			gui.InputFalse(setting.wrap_text_chat.num_char, 274, 1106, 30)
			imgui.PopStyleColor(1)
		end

		if imgui.BeginPopupModal(u8'Редактировать отыгровки оружия', null, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar) then
			imgui.SetCursorPos(imgui.ImVec2(0, 0))
			imgui.BeginChild(u8'Редактор отыгровок оружия', imgui.ImVec2(730, 370), false, imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollWithMouse)
			imgui.Scroller(u8'Редактор отыгровок оружия', img_step[1][0], img_duration[1][0], imgui.HoveredFlags.AllowWhenBlockedByActiveItem)
			local pos_y = 0
			for i = 1, #gun_bool do
				gui.Text(25, 14 + pos_y, gun_bool[i].name_gun, bold_font[1])
				gui.Draw({16, 39 + pos_y}, {698, 71}, cl.tab, 7, 15)
				gui.DrawLine({16, 74 + pos_y}, {714, 74 + pos_y}, cl.line)
				gui.DrawCircleEmp({33.5, 56.5 + pos_y}, 10, cl.bg2, 2)
				imgui.SetCursorPos(imgui.ImVec2(20, 43 + pos_y))
				if imgui.InvisibleButton(u8'##Использовать отыгровку взятия оружия' .. i, imgui.ImVec2(27, 27)) then
					gun_bool[i].take = not gun_bool[i].take
				end
				if imgui.IsItemActive() then
					gui.DrawCircle({33.5, 56.5 + pos_y}, 10, cl.bg2, 2)
				end
				if gun_bool[i].take then
					gui.FaText(28, 50 + pos_y, fa.CHECK, fa_font[2])
				end
				gun_bool[i].take_rp = gui.InputText({57, 50 + pos_y}, 637, gun_bool[i].take_rp, u8'Взятие оружия' .. i, 260, u8'Введите текст взятия оружия')
				
				gui.DrawCircleEmp({33.5, 92.5 + pos_y}, 10, cl.bg2, 2)
				imgui.SetCursorPos(imgui.ImVec2(20, 79 + pos_y))
				if imgui.InvisibleButton(u8'##Использовать отыгровку убирания оружия' .. i, imgui.ImVec2(27, 27)) then
					gun_bool[i].put = not gun_bool[i].put
				end
				if imgui.IsItemActive() then
					gui.DrawCircle({33.5, 92.5 + pos_y}, 10, cl.bg2, 2)
				end
				if gun_bool[i].put then
					gui.FaText(28, 86 + pos_y, fa.CHECK, fa_font[2])
				end
				gun_bool[i].put_rp = gui.InputText({57, 86 + pos_y}, 637, gun_bool[i].put_rp, u8'Убирание оружия' .. i, 260, u8'Введите текст убирания оружия из виду')
			
				pos_y = pos_y + 115
			end
			
			imgui.Dummy(imgui.ImVec2(0, 20))
			imgui.EndChild()
			
			gui.DrawLine({10, 370}, {720, 370}, cl.line)
			if gui.Button(u8'Сохранить и выйти', {10, 381}, {230, 31}) then
				setting.gun = deep_copy(gun_bool)
				save()
				imgui.CloseCurrentPopup()
			end
			if gui.Button(u8'Отменить текущие изменения', {250, 381}, {230, 31}) then
				imgui.CloseCurrentPopup()
			end
			if gui.Button(u8'Сбросить отыгровки до дефолта', {490, 381}, {230, 31}) then
				gun_bool = deep_copy(gun_orig)
			end
			if gui.Button(u8'Отключить все', {250, 417}, {230, 31}) then
				for i = 1, #gun_bool do
					gun_bool[i].take = false
					gun_bool[i].put = false
				end
			end

			imgui.Dummy(imgui.ImVec2(0, 13))
			imgui.EndPopup()
		end
		
		setting.chat_filters = setting.chat_filters or {}
		if setting.chat_filters.treasure == nil then setting.chat_filters.treasure = false end
		if setting.chat_filters.hotels == nil then setting.chat_filters.hotels = false end
		if setting.chat_filters.armor_warehouse == nil then setting.chat_filters.armor_warehouse = false end
		if setting.chat_filters.arms_race == nil then setting.chat_filters.arms_race = false end
		if setting.chat_filters.car_quality == nil then setting.chat_filters.car_quality = false end

		gui.Text(25, 1141, 'Дополнительные фильтры', bold_font[1])
		new_draw(1166, 215)
		gui.DrawLine({16, 1201}, {602, 1201}, cl.line)
		gui.DrawLine({16, 1237}, {602, 1237}, cl.line)
		gui.DrawLine({16, 1273}, {602, 1273}, cl.line)
		gui.DrawLine({16, 1309}, {602, 1309}, cl.line)
		gui.DrawLine({16, 1345}, {602, 1345}, cl.line)

		gui.Text(26, 1175, 'Скрыть сообщения о кладах', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 1171))
		if gui.Switch(u8'##Скрыть сообщения о кладах', setting.chat_filters.treasure) then
			setting.chat_filters.treasure = not setting.chat_filters.treasure
			save()
		end

		gui.Text(26, 1211, 'Скрыть сообщения об отелях', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 1207))
		if gui.Switch(u8'##Скрыть сообщения об отелях', setting.chat_filters.hotels) then
			setting.chat_filters.hotels = not setting.chat_filters.hotels
			save()
		end

		gui.Text(26, 1247, 'Скрыть сообщения о списанных бронежилетах', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 1243))
		if gui.Switch(u8'##Скрыть сообщения о списанных бронежилетах', setting.chat_filters.armor_warehouse) then
			setting.chat_filters.armor_warehouse = not setting.chat_filters.armor_warehouse
			save()
		end

		gui.Text(26, 1283, 'Скрыть сообщения о гонке вооружений', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 1279))
		if gui.Switch(u8'##Скрыть сообщения о гонке вооружений', setting.chat_filters.arms_race) then
			setting.chat_filters.arms_race = not setting.chat_filters.arms_race
			save()
		end

		gui.Text(26, 1319, 'Скрыть сообщения о качестве транспорта', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 1315))
		if gui.Switch(u8'##Скрыть сообщения о качестве транспорта', setting.chat_filters.car_quality) then
			setting.chat_filters.car_quality = not setting.chat_filters.car_quality
			save()
		end
		imgui.Dummy(imgui.ImVec2(0, 24))
	elseif tab_settings == 3 then
		if setting.org <= 4 then
			gui.Text(25, 12, 'Разное', bold_font[1])
			new_draw(37, 131)
		
			gui.Text(26, 50, 'Лечение', font[3])
			local bool_set_lec = setting.price[1].lec
			setting.price[1].lec = gui.InputText({130, 52}, 100, setting.price[1].lec, u8'Цена лечения', 20, u8'Цена', 'money')
			if setting.price[1].lec ~= bool_set_lec then save() end
			gui.DrawLine({16, 80}, {602, 80}, cl.line)
			gui.Text(26, 94, 'Наркоз-ость', font[3])
			local bool_set_narko = setting.price[1].lec
			setting.price[1].narko = gui.InputText({130, 96}, 100, setting.price[1].narko, u8'Цена нарко', 20, u8'Цена', 'money')
			if setting.price[1].narko ~= bool_set_narko then save() end
			gui.DrawLine({16, 124}, {602, 124}, cl.line)
			gui.Text(26, 138, 'Мед. осмотр', font[3])
			local bool_set_osm = setting.price[1].osm
			setting.price[1].osm = gui.InputText({130, 140}, 100, setting.price[1].osm, u8'Цена осмотра', 20, u8'Цена', 'money')
			if setting.price[1].osm ~= bool_set_osm then save() end
			gui.Text(381, 50, 'Рецепт', font[3])
			local bool_set_rec = setting.price[1].rec
			setting.price[1].rec = gui.InputText({481, 52}, 100, setting.price[1].rec, u8'Цена рецепта', 20, u8'Цена', 'money')
			if setting.price[1].rec ~= bool_set_rec then save() end
			gui.Text(381, 94, 'Антибиотик', font[3])
			local bool_set_ant = setting.price[1].ant
			setting.price[1].ant = gui.InputText({481, 96}, 100, setting.price[1].ant, u8'Цена антибиотика', 20, u8'Цена', 'money')
			if setting.price[1].ant ~= bool_set_ant then save() end
			gui.Text(381, 138, 'Охранник', font[3])
			local bool_set_gua = setting.price[1].tatu
			setting.price[1].tatu = gui.InputText({481, 140}, 100, setting.price[1].tatu, u8'Цена охраны', 20, u8'Цена', 'money')
			if setting.price[1].tatu ~= bool_set_gua then save() end

			gui.Text(25, 187, 'Медицинская карта', bold_font[1])
			new_draw(212, 175)
			
			gui.Text(26, 225, 'Новая на 7 дней', font[3])
			local bool_set_mc1 = setting.price[1].mc[1]
			setting.price[1].mc[1] = gui.InputText({154, 227}, 100, setting.price[1].mc[1], u8'Цена мед карты 7 дней новая', 20, u8'Цена', 'money')
			if setting.price[1].mc[1] ~= bool_set_mc1 then save() end
			gui.DrawLine({16, 255}, {602, 255}, cl.line)
			gui.Text(26, 269, 'Новая на 14 дней', font[3])
			local bool_set_mc2 = setting.price[1].mc[2]
			setting.price[1].mc[2] = gui.InputText({154, 271}, 100, setting.price[1].mc[2], u8'Цена мед карты 14 дней новая', 20, u8'Цена', 'money')
			if setting.price[1].mc[2] ~= bool_set_mc2 then save() end
			gui.DrawLine({16, 299}, {602, 299}, cl.line)
			gui.Text(26, 313, 'Новая на 30 дней', font[3])
			local bool_set_mc3 = setting.price[1].mc[3]
			setting.price[1].mc[3] = gui.InputText({154, 315}, 100, setting.price[1].mc[3], u8'Цена мед карты 30 дней новая', 20, u8'Цена', 'money')
			if setting.price[1].mc[3] ~= bool_set_mc3 then save() end
			gui.DrawLine({16, 343}, {602, 343}, cl.line)
			gui.Text(26, 357, 'Новая на 60 дней', font[3])
			local bool_set_mc4 = setting.price[1].mc[4]
			setting.price[1].mc[4] = gui.InputText({154, 359}, 100, setting.price[1].mc[4], u8'Цена мед карты 60 дней новая', 20, u8'Цена', 'money')
			if setting.price[1].mc[4] ~= bool_set_mc4 then save() end
			
			gui.Text(330, 225, 'Обновить на 7 дней', font[3])
			local bool_set_mcupd1 = setting.price[1].mcupd[1]
			setting.price[1].mcupd[1] = gui.InputText({481, 227}, 100, setting.price[1].mcupd[1], u8'Цена мед карты 7 дней обновить', 20, u8'Цена', 'money')
			if setting.price[1].mcupd[1] ~= bool_set_mcupd1 then save() end
			gui.Text(330, 269, 'Обновить на 14 дней', font[3])
			local bool_set_mcupd2 = setting.price[1].mcupd[2]
			setting.price[1].mcupd[2] = gui.InputText({481, 271}, 100, setting.price[1].mcupd[2], u8'Цена мед карты 14 дней обновить', 20, u8'Цена', 'money')
			if setting.price[1].mcupd[2] ~= bool_set_mcupd2 then save() end
			gui.Text(330, 313, 'Обновить на 30 дней', font[3])
			local bool_set_mcupd3 = setting.price[1].mcupd[3]
			setting.price[1].mcupd[3] = gui.InputText({481, 315}, 100, setting.price[1].mcupd[3], u8'Цена мед карты 30 дней обновить', 20, u8'Цена', 'money')
			if setting.price[1].mcupd[3] ~= bool_set_mcupd3 then save() end
			gui.Text(330, 357, 'Обновить на 60 дней', font[3])
			local bool_set_mcupd4 = setting.price[1].mcupd[4]
			setting.price[1].mcupd[4] = gui.InputText({481, 359}, 100, setting.price[1].mcupd[4], u8'Цена мед карты 60 дней обновить', 20, u8'Цена', 'money')
			if setting.price[1].mcupd[4] ~= bool_set_mcupd4 then save() end
			
			imgui.Dummy(imgui.ImVec2(0, 26))
			--[[ НУ И КОСТЫЛЫ. Сделаю по другому потом
		elseif setting.org == 10 then
			gui.Text(25, 12, 'Выход по УДО', bold_font[1])

			local price_presets = {
				Chandler	 = { box = '45000', eat = '60000', cloth = '60000', trash = '75000', min = '10000' },
				RedRock	  = { box = '30000', eat = '35000', cloth = '35000', trash = '40000', min = '25000' },
				Gilbert	  = { box = '50000', eat = '70000', cloth = '70000', trash = '50000', min = '50000' },
				ShowLow	  = { box = '200000', eat = '250000', cloth = '250000', trash = '200000', min = '30000' },
				CasaGrande   = { box = '75000', eat = '80000', cloth = '80000', trash = '80000', min = '35000' },
				SunCity	  = { box = '40000', eat = '60000', cloth = '50000', trash = '40000', min = '30000' },
				Holiday	  = { box = '16000', eat = '23000', cloth = '25000', trash = '28000', min = '43000' },
				Christmas	= { box = '50000', eat = '70000', cloth = '70000', trash = '50000', min = '50000' },
				Scottdale	= { box = '50000', eat = '70000', cloth = '70000', trash = '50000', min = '50000' },
				Winslow	  = { task1 = '20000000', task2 = '15000000', task3 = '12000000', task4 = '11000000', task5 = '6500000', task6 = '3000000'},
				QueenCreek   = { task1 = '30000000', task2 = '15000000', task3 = '10000000', task4 = '6000000', task5 = '3000000'},
				Wednesday	= { task1 = '30000000', task2 = '25000000', task3 = '20000000', task4 = '15000000', task5 = '10000000', task6 = '5000000'}
			}

			if not setting.price[3] and price_presets[s_na] then
				setting.price[3] = price_presets[s_na]
			end

			if (s_na == 'Chandler' or s_na == 'RedRock' or s_na == 'Gilbert' or s_na == 'ShowLow' or s_na == 'CasaGrande' or s_na == 'SunCity' or s_na == 'Holiday' or s_na == 'Christmas' or s_na == 'Scottdale') then
				new_draw(37, 131)
				gui.Text(26, 50, 'За 1 ящик', font[3])
				local bool_set_box = setting.price[3].box
				setting.price[3].box = gui.InputText({130, 52}, 100, setting.price[3].box, u8'Цена ящика', 20, u8'Цена', 'money')
				if setting.price[3].box ~= bool_set_box then save() end
				gui.DrawLine({16, 80}, {602, 80}, cl.line)
				gui.Text(26, 94, 'За 1 еду', font[3])
				local bool_set_eat = setting.price[3].eat
				setting.price[3].eat = gui.InputText({130, 96}, 100, setting.price[3].eat, u8'Цена еды', 20, u8'Цена', 'money')
				if setting.price[3].eat ~= bool_set_eat then save() end
				gui.DrawLine({16, 124}, {602, 124}, cl.line)
				gui.Text(26, 138, 'За 1 одежду', font[3])
				local bool_set_cloth = setting.price[3].cloth
				setting.price[3].cloth = gui.InputText({130, 140}, 100, setting.price[3].cloth, u8'Цена одежды', 20, u8'Цена', 'money')
				if setting.price[3].cloth ~= bool_set_cloth then save() end
				gui.Text(381, 50, 'За 1 мусор', font[3])
				local bool_set_trash = setting.price[3].trash
				setting.price[3].trash = gui.InputText({481, 52}, 100, setting.price[3].trash, u8'Цена мусора', 20, u8'Цена', 'money')
				if setting.price[3].trash ~= bool_set_trash then save() end
				gui.Text(381, 94, 'За 1 минуту', font[3])
				local bool_set_min = setting.price[3].min
				setting.price[3].min = gui.InputText({481, 96}, 100, setting.price[3].min, u8'Цена за минуту', 20, u8'Цена', 'money')
				if setting.price[3].min ~= bool_set_min then save() end
			elseif (s_na == 'Winslow' or s_na == 'Wednesday') then
				new_draw(37, 262)
				gui.Text(26, 50, 'Без выполненных работ', font[3])
				local bool_set_task1 = setting.price[3].task1
				setting.price[3].task1 = gui.InputText({300, 52}, 100, setting.price[3].task1, u8'Цена ящика', 20, u8'Цена', 'money')
				if setting.price[3].task1 ~= bool_set_task1 then save() end
				gui.DrawLine({16, 80}, {602, 80}, cl.line)
				gui.Text(26, 94, 'С сделанным 1 заданием', font[3])
				local bool_set_task2 = setting.price[3].task2
				setting.price[3].task2 = gui.InputText({300, 96}, 100, setting.price[3].task2, u8'Цена еды', 20, u8'Цена', 'money')
				if setting.price[3].task2 ~= bool_set_task2 then save() end
				gui.DrawLine({16, 124}, {602, 124}, cl.line)
				gui.Text(26, 138, 'С сделанными 2 заданиями', font[3])
				local bool_set_task3 = setting.price[3].task3
				setting.price[3].task3 = gui.InputText({300, 140}, 100, setting.price[3].task3, u8'Цена одежды', 20, u8'Цена', 'money')
				if setting.price[3].task3 ~= bool_set_task3 then save() end
				gui.DrawLine({16, 168}, {602, 168}, cl.line)
				gui.Text(26, 182, 'С сделанными 3 заданиями', font[3])
				local bool_set_task4 = setting.price[3].task4
				setting.price[3].task4 = gui.InputText({300, 184}, 100, setting.price[3].task4, u8'Цена мусора', 20, u8'Цена', 'money')
				if setting.price[3].task4 ~= bool_set_task4 then save() end
				gui.DrawLine({16, 212}, {602, 212}, cl.line)
				gui.Text(26, 226, 'С сделанными 4 заданиями', font[3])
				local bool_set_task5 = setting.price[3].task5
				setting.price[3].task5 = gui.InputText({300, 228}, 100, setting.price[3].task5, u8'Цена за минуту', 20, u8'Цена', 'money')
				if setting.price[3].task5 ~= bool_set_task5 then save() end
				gui.DrawLine({16, 256}, {602, 256}, cl.line)
				gui.Text(26, 270, 'Осталось только время', font[3])
				local bool_set_task6 = setting.price[3].task6
				setting.price[3].task6 = gui.InputText({300, 272}, 100, setting.price[3].task6, u8'Цена за минуту', 20, u8'Цена', 'money')
				if setting.price[3].task6 ~= bool_set_task6 then save() end
				end
				new_draw(318, 53)
				gui.Text(26, 327, 'Оставлять окно с заданиями открытым', font[3])
				imgui.SetCursorPos(imgui.ImVec2(561, 322))
				if gui.Switch(u8'##Оставлять окно видемым', setting.prinfo) then
					setting.prinfo = not setting.prinfo
					save()
				end
			gui.TextInfo({26, 352}, {'Скрипт будет оставлять окно /getjail открытым на экране, для возможности его скриншота.'})
			]]
		elseif setting.org == 5 then
			new_draw(16, 428)
			
			gui.DrawLine({109, 16}, {109, 444}, cl.line)
			gui.DrawLine({273, 16}, {273, 444}, cl.line)
			gui.DrawLine({437, 16}, {437, 444}, cl.line)
			gui.DrawLine({16, 44}, {602, 44}, cl.line)
			gui.DrawLine({16, 84}, {602, 84}, cl.line)
			gui.DrawLine({16, 124}, {602, 124}, cl.line)
			gui.DrawLine({16, 164}, {602, 164}, cl.line)
			gui.DrawLine({16, 204}, {602, 204}, cl.line)
			gui.DrawLine({16, 244}, {602, 244}, cl.line)
			gui.DrawLine({16, 284}, {602, 284}, cl.line)
			gui.DrawLine({16, 324}, {602, 324}, cl.line)
			gui.DrawLine({16, 364}, {602, 364}, cl.line)
			gui.DrawLine({16, 404}, {602, 404}, cl.line)
			
			gui.Text(166, 21, '1 месяц', font[3])
			gui.Text(326, 21, '2 месяца', font[3])
			gui.Text(490, 21, '3 месяца', font[3])
			
			gui.Text(26, 56, 'Авто', font[3])
			gui.Text(26, 96, 'Мото', font[3])
			gui.Text(26, 136, 'Полёты', font[3])
			gui.Text(26, 176, 'Рыбалка', font[3])
			gui.Text(26, 216, 'Водное т/c', font[3])
			gui.Text(26, 256, 'Оружие', font[3])
			gui.Text(26, 296, 'Охота', font[3])
			gui.Text(26, 336, 'Раскопки', font[3])
			gui.Text(26, 376, 'Такси', font[3])
			gui.Text(26, 416, 'Механик', font[3])
			
			local bool_set_auto1 = setting.price[2].auto[1]
			setting.price[2].auto[1] = gui.InputText({140, 58}, 99, setting.price[2].auto[1], u8'Цена авто 1', 20, u8'Цена', 'money')
			if setting.price[2].auto[1] ~= bool_set_auto1 then save() end
			local bool_set_auto1 = setting.price[2].auto[2]
			setting.price[2].auto[2] = gui.InputText({304, 58}, 99, setting.price[2].auto[2], u8'Цена авто 2', 20, u8'Цена', 'money')
			if setting.price[2].auto[2] ~= bool_set_auto1 then save() end
			local bool_set_auto1 = setting.price[2].auto[3]
			setting.price[2].auto[3] = gui.InputText({468, 58}, 99, setting.price[2].auto[3], u8'Цена авто 3', 20, u8'Цена', 'money')
			if setting.price[2].auto[3] ~= bool_set_auto1 then save() end
			
			local bool_set_moto1 = setting.price[2].moto[1]
			setting.price[2].moto[1] = gui.InputText({140, 98}, 99, setting.price[2].moto[1], u8'Цена мото 1', 20, u8'Цена', 'money')
			if setting.price[2].moto[1] ~= bool_set_moto1 then save() end
			local bool_set_moto2 = setting.price[2].moto[2]
			setting.price[2].moto[2] = gui.InputText({304, 98}, 99, setting.price[2].moto[2], u8'Цена мото 2', 20, u8'Цена', 'money')
			if setting.price[2].moto[2] ~= bool_set_moto2 then save() end
			local bool_set_moto3 = setting.price[2].moto[3]
			setting.price[2].moto[3] = gui.InputText({468, 98}, 99, setting.price[2].moto[3], u8'Цена мото 3', 20, u8'Цена', 'money')
			if setting.price[2].moto[3] ~= bool_set_moto3 then save() end
			
			local bool_set_fly1 = setting.price[2].fly[1]
			setting.price[2].fly[1] = gui.InputText({140, 138}, 99, setting.price[2].fly[1], u8'Цена полёты', 20, u8'Цена', 'money')
			if setting.price[2].fly[1] ~= bool_set_moto11 then save() end
			gui.Text(316, 136, 'Недоступно', font[3])
			gui.Text(480, 136, 'Недоступно', font[3])
			
			local bool_set_fish1 = setting.price[2].fish[1]
			setting.price[2].fish[1] = gui.InputText({140, 178}, 99, setting.price[2].fish[1], u8'Цена рыба 1', 20, u8'Цена', 'money')
			if setting.price[2].fish[1] ~= bool_set_fish1 then save() end
			local bool_set_fish2 = setting.price[2].fish[2]
			setting.price[2].fish[2] = gui.InputText({304, 178}, 99, setting.price[2].fish[2], u8'Цена рыба 2', 20, u8'Цена', 'money')
			if setting.price[2].fish[2] ~= bool_set_fish2 then save() end
			local bool_set_fish3 = setting.price[2].fish[3]
			setting.price[2].fish[3] = gui.InputText({468, 178}, 99, setting.price[2].fish[3], u8'Цена рыба 3', 20, u8'Цена', 'money')
			if setting.price[2].fish[3] ~= bool_set_fish3 then save() end
			
			local bool_set_swim1 = setting.price[2].swim[1]
			setting.price[2].swim[1] = gui.InputText({140, 218}, 99, setting.price[2].swim[1], u8'Цена плавание 1', 20, u8'Цена', 'money')
			if setting.price[2].swim[1] ~= bool_set_swim1 then save() end
			local bool_set_swim2 = setting.price[2].swim[2]
			setting.price[2].swim[2] = gui.InputText({304, 218}, 99, setting.price[2].swim[2], u8'Цена плавание 2', 20, u8'Цена', 'money')
			if setting.price[2].swim[2] ~= bool_set_swim2 then save() end
			local bool_set_swim3 = setting.price[2].swim[3]
			setting.price[2].swim[3] = gui.InputText({468, 218}, 99, setting.price[2].swim[3], u8'Цена плавание 3', 20, u8'Цена', 'money')
			if setting.price[2].swim[3] ~= bool_set_swim3 then save() end
			
			local bool_set_gun1 = setting.price[2].gun[1]
			setting.price[2].gun[1] = gui.InputText({140, 258}, 99, setting.price[2].gun[1], u8'Цена оружие 1', 20, u8'Цена', 'money')
			if setting.price[2].gun[1] ~= bool_set_gun1 then save() end
			local bool_set_gun2 = setting.price[2].gun[2]
			setting.price[2].gun[2] = gui.InputText({304, 258}, 99, setting.price[2].gun[2], u8'Цена оружие 2', 20, u8'Цена', 'money')
			if setting.price[2].gun[2] ~= bool_set_gun2 then save() end
			local bool_set_gun3 = setting.price[2].gun[3]
			setting.price[2].gun[3] = gui.InputText({468, 258}, 99, setting.price[2].gun[3], u8'Цена оружие 3', 20, u8'Цена', 'money')
			if setting.price[2].gun[3] ~= bool_set_gun3 then save() end
			
			local bool_set_hunt1 = setting.price[2].hunt[1]
			setting.price[2].hunt[1] = gui.InputText({140, 298}, 99, setting.price[2].hunt[1], u8'Цена охота 1', 20, u8'Цена', 'money')
			if setting.price[2].hunt[1] ~= bool_set_hunt1 then save() end
			local bool_set_hunt2 = setting.price[2].hunt[2]
			setting.price[2].hunt[2] = gui.InputText({304, 298}, 99, setting.price[2].hunt[2], u8'Цена охота 2', 20, u8'Цена', 'money')
			if setting.price[2].hunt[2] ~= bool_set_hunt2 then save() end
			local bool_set_hunt3 = setting.price[2].hunt[3]
			setting.price[2].hunt[3] = gui.InputText({468, 298}, 99, setting.price[2].hunt[3], u8'Цена охота 3', 20, u8'Цена', 'money')
			if setting.price[2].hunt[3] ~= bool_set_hunt3 then save() end
			
			local bool_set_exc1 = setting.price[2].exc[1]
			setting.price[2].exc[1] = gui.InputText({140, 338}, 99, setting.price[2].exc[1], u8'Цена раскопки 1', 20, u8'Цена', 'money')
			if setting.price[2].exc[1] ~= bool_set_exc1 then save() end
			local bool_set_exc2 = setting.price[2].exc[2]
			setting.price[2].exc[2] = gui.InputText({304, 338}, 99, setting.price[2].exc[2], u8'Цена раскопки 2', 20, u8'Цена', 'money')
			if setting.price[2].exc[2] ~= bool_set_exc2 then save() end
			local bool_set_exc3 = setting.price[2].exc[3]
			setting.price[2].exc[3] = gui.InputText({468, 338}, 99, setting.price[2].exc[3], u8'Цена раскопки 3', 20, u8'Цена', 'money')
			if setting.price[2].exc[3] ~= bool_set_exc3 then save() end
			
			local bool_set_taxi1 = setting.price[2].taxi[1]
			setting.price[2].taxi[1] = gui.InputText({140, 378}, 99, setting.price[2].taxi[1], u8'Цена такси 1', 20, u8'Цена', 'money')
			if setting.price[2].taxi[1] ~= bool_set_taxi1 then save() end
			local bool_set_taxi2 = setting.price[2].taxi[2]
			setting.price[2].taxi[2] = gui.InputText({304, 378}, 99, setting.price[2].taxi[2], u8'Цена такси 2', 20, u8'Цена', 'money')
			if setting.price[2].taxi[2] ~= bool_set_taxi2 then save() end
			local bool_set_taxi3 = setting.price[2].taxi[3]
			setting.price[2].taxi[3] = gui.InputText({468, 378}, 99, setting.price[2].taxi[3], u8'Цена такси 3', 20, u8'Цена', 'money')
			if setting.price[2].taxi[3] ~= bool_set_taxi3 then save() end
			
			local bool_set_meh1 = setting.price[2].meh[1]
			setting.price[2].meh[1] = gui.InputText({140, 418}, 99, setting.price[2].meh[1], u8'Цена механик 1', 20, u8'Цена', 'money')
			if setting.price[2].meh[1] ~= bool_set_meh1 then save() end
			local bool_set_meh2 = setting.price[2].meh[2]
			setting.price[2].meh[2] = gui.InputText({304, 418}, 99, setting.price[2].meh[2], u8'Цена механик 2', 20, u8'Цена', 'money')
			if setting.price[2].meh[2] ~= bool_set_meh2 then save() end
			local bool_set_meh3 = setting.price[2].meh[3]
			setting.price[2].meh[3] = gui.InputText({468, 418}, 99, setting.price[2].meh[3], u8'Цена механик 3', 20, u8'Цена', 'money')
			if setting.price[2].meh[3] ~= bool_set_meh3 then save() end
			
			imgui.Dummy(imgui.ImVec2(0, 24))
		else
			gui.Text(152, 159, 'Недоступно для Вас', bold_font[3])
		end
	elseif tab_settings == 4 then
		if not setting.fast then setting.fast = {} end
		if not setting.fast.one_win then setting.fast.one_win = {} end
		if not setting.fast.two_win then setting.fast.two_win = {} end
		syncFastActions()
		autoFixFastActionsIdFlags()
		local size_y_fast = 37
		if setting.fast.func then size_y_fast = 79 end
		new_draw(16, size_y_fast)
		
		
		gui.Text(26, 26, 'Быстрое взаимодействие с игроками', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 21))
		if gui.Switch(u8'##Быстрый доступ', setting.fast.func) then
			setting.fast.func = not setting.fast.func
			if setting.first_start_fast and #setting.fast.one_win == 0 and #setting.fast.two_win == 0 then
				if #cmd[1] ~= 0 then
					for i = 1, #cmd[1] do
						local new_action = {name = cmd[1][i].desc, cmd = cmd[1][i].cmd, send = true, id = true}
						if new_action.id then
							table.insert(setting.fast.one_win, new_action)
						else
							table.insert(setting.fast.two_win, new_action)
						end
					end
				end
				setting.first_start_fast = false
			end
			save()
		end
		
		if setting.fast.func then
			gui.DrawLine({16, 53}, {602, 53}, cl.line)
			gui.Text(26, 66, 'Текущая активация -', font[3])
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.30, 0.85, 0.38, 1.00))
			gui.Text(165, 66, u8:decode(setting.fast.key_name), font[3])
			imgui.PopStyleColor(1)
			if gui.Button(u8'Изменить клавишу активации', {373, 62}, {218, 25}) then
				current_key[2] = {2}
				current_key[1] = u8'ПКМ'
				imgui.OpenPopup(u8'Изменить клавишу активации быстрого доступа')
				lockPlayerControl(true)
				edit_key = true
				fast_key = setting.fast.key
			end
			
			if imgui.BeginPopupModal(u8'Изменить клавишу активации быстрого доступа', null, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar) then
				imgui.SetCursorPos(imgui.ImVec2(10, 10))
				if imgui.InvisibleButton(u8'##Закрыть окно КАБД', imgui.ImVec2(16, 16)) then
					lockPlayerControl(false)
					edit_key = false
					imgui.CloseCurrentPopup()
				end
				imgui.SetCursorPos(imgui.ImVec2(16, 16))
				local p = imgui.GetCursorScreenPos()
				if imgui.IsItemHovered() then
					imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x - 0.4, p.y - 0.2), 7, imgui.GetColorU32Vec4(imgui.ImVec4(0.98, 0.32, 0.38 ,1.00)), 60)
				else
					imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x - 0.4, p.y - 0.2), 7, imgui.GetColorU32Vec4(imgui.ImVec4(0.98, 0.42, 0.38 ,1.00)), 60)
				end
				imgui.SetCursorPos(imgui.ImVec2(10, 40))
				imgui.BeginChild(u8'Назначение клавиши активации КАБД', imgui.ImVec2(390, 181), false, imgui.WindowFlags.NoScrollbar)
				
				imgui.PushFont(font[3])
				imgui.SetCursorPos(imgui.ImVec2(10, 0))
				imgui.Text(u8'Нажмите на необходимую клавишу или комбинацию')
				imgui.SetCursorPos(imgui.ImVec2(10, 25))
				imgui.Text(u8'Текущее сочетание:')
				imgui.SetCursorPos(imgui.ImVec2(145, 25))
				if #fast_key == 0 then
					imgui.TextColored(imgui.ImVec4(0.90, 0.22, 0.22 ,1.00), u8'Отсутствует')
				else
					local all_key = {}
					for i = 1, #fast_key do
						table.insert(all_key, vkeys.id_to_name(fast_key[i]))
					end
					imgui.TextColored(imgui.ImVec4(0.90, 0.63, 0.22 ,1.00), table.concat(all_key, ' + '))
				end
				imgui.PopFont()
				gui.DrawLine({0, 50}, {381, 50}, cl.line)
				
				if imgui.IsMouseClicked(0) then
					lua_thread.create(function()
						wait(500)
						setVirtualKeyDown(3, true)
						wait(0)
						setVirtualKeyDown(3, false)
					end)
				end
				local currently_pressed_keys = rkeys.getKeys(true)
				local pr_key_num = {2}
				local pr_key_name = {u8'ПКМ'}
				if #currently_pressed_keys ~= 0 then
					local stop_hot = false
					for i = 1, #currently_pressed_keys do
						local parts = {}
						for part in currently_pressed_keys[i]:gmatch('[^:]+') do
							table.insert(parts, part)
						end
						if currently_pressed_keys[i] ~= u8'1:ЛКМ' and currently_pressed_keys[i] ~= '145:Scrol Lock' 
						and currently_pressed_keys[i] ~= u8'2:ПКМ' then
							table.insert(pr_key_num, tonumber(parts[1]))
							table.insert(pr_key_name, parts[2])
						else
							stop_hot = true
						end
					end
					if not stop_key_move and not stop_hot then
						if current_key == {u8'ПКМ', {2}} then end
						current_key[1] = table.concat(pr_key_name, ' + ')
						
						current_key[2] = pr_key_num
						stop_key_move = true
						lua_thread.create(function()
							wait(250)
							stop_key_move = false
						end)
					end
				end
				if current_key[1] == nil then
					current_key[1] = u8''
				end
				if current_key[1] ~= u8'Такая комбинация уже существует' then
					imgui.PushFont(bold_font[3])
					local calc = imgui.CalcTextSize(current_key[1])
					imgui.SetCursorPos(imgui.ImVec2(195 - calc.x / 2, 80))
					if calc.x >= 385 then
						imgui.PopFont()
						imgui.PushFont(font[3])
						calc = imgui.CalcTextSize(current_key[1])
						imgui.SetCursorPos(imgui.ImVec2(195 - calc.x / 2, 90))
					end
					imgui.TextColored(imgui.ImVec4(0.08, 0.64, 0.11, 1.00), current_key[1])
					imgui.PopFont()
				else
					imgui.PushFont(font[3])
					local calc = imgui.CalcTextSize(current_key[1])
					imgui.SetCursorPos(imgui.ImVec2(195 - calc.x / 2, 90))
					imgui.TextColored(imgui.ImVec4(0.90, 0.22, 0.22, 1.00), current_key[1])
					imgui.PopFont()
				end
					
					
				if gui.Button(u8'Применить', {0, 144}, {185, 29}) then
					if not compare_array_disable_order(setting.fast.key, current_key[2]) then
						local is_hot_key_done = false
						local num_hot_key_remove = 0
						
						if #all_keys ~= 0 and #current_key[2] ~= 0 then
							for i = 1, #all_keys do
								is_hot_key_done = compare_array_disable_order(all_keys[i], current_key[2])
								if is_hot_key_done then break end
							end
							for i = 1, #all_keys do
								if compare_array_disable_order(all_keys[i], setting.fast.key) then
									num_hot_key_remove = i
									break
								end
							end
						end
						if is_hot_key_done then current_key = {u8'Такая комбинация уже существует', {}} end
						if not is_hot_key_done then
							if num_hot_key_remove ~= 0 then
								table.remove(all_keys, num_hot_key_remove)
								rkeys.unRegisterHotKey(setting.fast.key)
							end
							setting.fast.key = current_key[2]
							setting.fast.key_name = current_key[1]
							table.insert(all_keys, current_key[2])
							rkeys.registerHotKey(current_key[2], 3, true, function() on_hot_key(setting.fast.key) end)
							lockPlayerControl(false)
							edit_key = false
							imgui.CloseCurrentPopup()
							save()
						end
					else
						lockPlayerControl(false)
						edit_key = false
						imgui.CloseCurrentPopup()
					end
				end
				if gui.Button(u8'Очистить', {194, 144}, {186, 29}) then
					current_key = {u8'ПКМ', {2}}
				end
					
				imgui.EndChild()
				imgui.EndPopup()
			end
			
			gui.DrawLine({16, 93}, {602, 93}, cl.line)
			new_draw(98, 55)
			gui.Text(26, 103, 'Использовать улучшенное меню', font[3])
			imgui.SetCursorPos(imgui.ImVec2(561, 98))
			local old_smart_state = setting.smart_fast_menu
			if gui.Switch(u8'##SmartFastMenu', setting.smart_fast_menu) then
				setting.smart_fast_menu = not setting.smart_fast_menu
				if old_smart_state ~= setting.smart_fast_menu then
					if setting.smart_fast_menu then
						syncFastActions()
					else
						syncFromSmartToOld()
					end
				end
				save()
			end
			gui.TextInfo({26, 122}, {'Новое меню позволяет выбирать игрока из списка и динамически'})
			gui.TextInfo({26, 136}, {'разделяет действия на колонки. Старое меню работает по-прежнему.'})
			
			local y_offset = 50
			
			if not bool_edit_fast then
				if an[5][1] == 0 then
					if setting.smart_fast_menu then
						num_win_fast = gui.ListTableHorizontal({189, 115 + y_offset}, {u8'С ID игрока', u8'Без ID'}, num_win_fast, u8'Выбор типа действий')
					else
						num_win_fast = gui.ListTableHorizontal({189, 115 + y_offset}, {u8'Первое окно', u8'Второе окно'}, num_win_fast, u8'Выбор номера окна в взаимодействии')
					end
				else
					if setting.smart_fast_menu then
						gui.ListTableHorizontal({189, 115 + y_offset}, {u8'С ID игрока', u8'Без ID'}, num_win_fast, u8'Выбор типа действий')
					else
						gui.ListTableHorizontal({189, 115 + y_offset}, {u8'Первое окно', u8'Второе окно'}, num_win_fast, u8'Выбор номера окна в взаимодействии')
					end
				end
			else
				gui.Text(219, 116 + y_offset, 'Режим редактирования', bold_font[1])
			end
			
			local function fast_table_func(set_fast)
				local set_pil = 'one_win'
				if set_fast == 3 then
					set_pil = 'two_win'
				end
				
				if not setting.smart_fast_menu then
					if an[5][1] < 0 and an[5][1] >= -40 then
						gui.DrawBox({235, 337 + an[5][1] + (#setting.fast[set_pil] * 111) + y_offset}, {148, 29}, cl.tab, cl.line, 7, 15)
					elseif an[5][1] < -40 then
						if an[5][1] > -165.4 then
							local s_x = 48 + (-an[5][1] * 3.25)
							local s_y = 9 - (an[5][1] / 1.9)
							local p_x = 309 - (s_x / 2)
							local p_y = 337 + (an[5][1] * 1.08) + (#setting.fast[set_pil] * 111) + y_offset
							gui.DrawBox({p_x, p_y}, {s_x, s_y}, cl.tab, cl.line, 7, 15)
						end
					end
					
					if #setting.fast[set_pil] ~= 0 then
						local bool_num_el = 0
						for i = 1, #setting.fast[set_pil] do
							if i == #setting.fast[set_pil] then
								if setting.cl == 'White' then
									imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.10, 0.10, 0.10, an[5][3]))
								else
									imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.95, 0.95, 0.95, an[5][3]))
								end
							end
							
							local scroll_cursor_pos = gui.GetCursorScroll()
							local pos_y_f = ((i - 1) * 111) + y_offset
							
							if bool_edit_fast then
								local tab_element_bool = false
								imgui.SetCursorPos(imgui.ImVec2(31, 158 + pos_y_f))
								if imgui.InvisibleButton(u8'##Переместить элемент ' .. set_fast .. i, imgui.ImVec2(571, 97)) then
									
								end
								if imgui.IsItemClicked() then
									sc_cursor_pos = scroll_cursor_pos
									sc_cr_p_element[1] = 0
									sc_cr_p_element[2] = i
									sc_cr_p_element[3] = i
									sc_cr_p_element[4] = i
									sc_cr_p_element[5] = pos_y_f
									
								end
								if imgui.IsItemActive() then
									tab_element_bool = true
									bool_item_active = true
									sc_cr_pos = {x = sc_cursor_pos.x - scroll_cursor_pos.x, y = sc_cursor_pos.y - scroll_cursor_pos.y}
									pos_y_f = pos_y_f - sc_cr_pos.y
									
									local pos_scroll = imgui.GetScrollY()
									if scroll_cursor_pos.y < (50 + pos_scroll) then
										imgui.SetScrollY(pos_scroll - ((100 * anim) + (-(scroll_cursor_pos.y - pos_scroll) / 30)))
									elseif scroll_cursor_pos.y > (285 + pos_scroll) then
										imgui.SetScrollY(pos_scroll + ((100 * anim) + ((scroll_cursor_pos.y - pos_scroll - 285) / 30)))
									end
									
									sc_cr_p_element[1] = pos_y_f
								elseif bool_item_active and sc_cr_p_element[2] == i then
									bool_item_active = false
									swapping(setting.fast[set_pil], i, sdv_bool_fast)
									save()
								elseif not imgui.IsItemActive() and sc_cr_p_element[2] == i then
									sc_cr_p_element[1] = 0
									sc_cr_p_element[2] = 0
									sc_cr_p_element[3] = 0
									sc_cr_p_element[4] = 0
									sc_cr_p_element[5] = 0
								else
									sc_cr_pos = {x = 0, y = 0}
								end
								
								if sc_cr_p_element[1] ~= 0 then
									local razn = sc_cr_p_element[1] - sc_cr_p_element[5]
									if sc_cr_p_element[1] ~= 0 and not tab_element_bool then
										if sc_cr_p_element[2] < i then
											if sc_cr_p_element[1] > (pos_y_f - 20) then
												bool_num_el = bool_num_el + 1
												sc_cr_p_element[3] = i
												if i == sc_cr_p_element[3] + 1 and sc_cr_p_element[1] < (pos_y_f + 222 - 20) then
													sc_cr_p_element[3] = i
													an[5][5] = 0
												end
												if i == sc_cr_p_element[3] then
													pos_y_f = pos_y_f - an[5][5]
												else
													pos_y_f = pos_y_f - 111
												end
												if an[5][5] < 111 then
													an[5][5] = an[5][5] + (500 * anim)
												else
													an[5][5] = 111
												end
											end
										elseif sc_cr_p_element[2] > i then
											if sc_cr_p_element[1] < (pos_y_f + 20) then
												bool_num_el = bool_num_el - 1
												if i == sc_cr_p_element[3] - 1 then
													sc_cr_p_element[3] = i
													an[5][5] = 0
												end
												if i == sc_cr_p_element[3] then
													pos_y_f = pos_y_f + an[5][5]
												else
													pos_y_f = pos_y_f + 111
												end
												if an[5][5] < 111 then
													an[5][5] = an[5][5] + (500 * anim)
												else
													an[5][5] = 111
												end
											end
										end
									end
								end
							end
							
							local vis_anim_input = 180
							if i <= 9 then
								gui.Text(5, 160 + pos_y_f, tostring(i), font[2])
							else
								gui.Text(2, 160 + pos_y_f, tostring(i), font[2])
							end
							if i == #setting.fast[set_pil] then vis_anim_input = an[5][4] end
							
							gui.DrawBox({16, 158 + pos_y_f}, {586, 97}, cl.tab, cl.line, 7, 15)
							gui.Text(26, 171 + pos_y_f, 'Имя', font[3])
							
							if bool_edit_fast then
								imgui.SetCursorPos(imgui.ImVec2(8, 150 + pos_y_f))
								if imgui.InvisibleButton(u8'##Удалить действие ' .. set_fast .. i, imgui.ImVec2(22, 22)) then
									table.remove(setting.fast[set_pil], i)
									save()
									break
								end
								imgui.PushFont(fa_font[4])
								imgui.SetCursorPos(imgui.ImVec2(10, 152 + pos_y_f))
								if imgui.IsItemActive() then
									imgui.TextColored(cl.def, fa.CIRCLE_XMARK)
								else
									imgui.Text(fa.CIRCLE_XMARK)
								end
								imgui.PopFont()
							end
							
							local bool_setfast = setting.fast[set_pil][i].name
							setting.fast[set_pil][i].name = gui.InputText({68, 173 + pos_y_f}, vis_anim_input, setting.fast[set_pil][i].name, u8'Имя действия' .. i, 300, u8'Введите имя действия')
							if bool_setfast ~= setting.fast[set_pil][i].name then save() end
							gui.Text(328, 171 + pos_y_f, 'Команда', font[3])
							local bool_setfast2 = setting.fast[set_pil][i].cmd
							setting.fast[set_pil][i].cmd = gui.InputText({401, 173 + pos_y_f}, vis_anim_input, setting.fast[set_pil][i].cmd, u8'Команда действия' .. i, 25, u8'Введите команду действия', 'en')
							if bool_setfast2 ~= setting.fast[set_pil][i].cmd then save() end
							gui.DrawLine({16, 201 + pos_y_f}, {602, 201 + pos_y_f}, cl.line)
							gui.Text(26, 206 + pos_y_f, 'Передавать в первый аргумент id игрока', font[3])
							imgui.SetCursorPos(imgui.ImVec2(561, 201 + pos_y_f))
							if gui.Switch(u8'##Передавать аргумент id игрока' .. set_fast.. i, setting.fast[set_pil][i].id) then
								setting.fast[set_pil][i].id = not setting.fast[set_pil][i].id
								save()
							end
							gui.DrawLine({16, 227 + pos_y_f}, {602, 227 + pos_y_f}, cl.line)
							gui.Text(26, 233 + pos_y_f, 'Отправлять команду без подтверждения', font[3])
							imgui.SetCursorPos(imgui.ImVec2(561, 228 + pos_y_f))
							if gui.Switch(u8'##Отправлять команду без подтверждения' .. set_fast ..i, setting.fast[set_pil][i].send) then
								setting.fast[set_pil][i].send = not setting.fast[set_pil][i].send
								save()
							end
							
							if i == #setting.fast[set_pil] then
								imgui.PopStyleColor(1)
							end
						end
						sdv_bool_fast = bool_num_el
					else
						if an[5][1] == 0 then
							gui.Text(124, 218 + y_offset, 'Нет ни одного действия', bold_font[3])
						end
					end
					
					imgui.Dummy(imgui.ImVec2(0, 19))
					if (an[5][1] < 0 and an[5][1] > -165.2) or (an[5][1] <= -165.2 and an[5][1] > -165.3) then
						imgui.Dummy(imgui.ImVec2(0, 106))
						imgui.SetScrollY(imgui.GetScrollMaxY())
					end
				else
					if an[5][1] < 0 and an[5][1] >= -40 then
						gui.DrawBox({235, 337 + an[5][1] + (#setting.fast[set_pil] * 111) + y_offset}, {148, 29}, cl.tab, cl.line, 7, 15)
					elseif an[5][1] < -40 then
						if an[5][1] > -165.4 then
							local s_x = 48 + (-an[5][1] * 3.25)
							local s_y = 9 - (an[5][1] / 1.9)
							local p_x = 309 - (s_x / 2)
							local p_y = 337 + (an[5][1] * 1.08) + (#setting.fast[set_pil] * 111) + y_offset
							gui.DrawBox({p_x, p_y}, {s_x, s_y}, cl.tab, cl.line, 7, 15)
						end
					end
					
					if #setting.fast[set_pil] ~= 0 then
						local bool_num_el = 0
						local items_per_column = math.ceil(#setting.fast[set_pil] / 2)
						local separator_added = false
						
						for i = 1, #setting.fast[set_pil] do
							if i == #setting.fast[set_pil] then
								if setting.cl == 'White' then
									imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.10, 0.10, 0.10, an[5][3]))
								else
									imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.95, 0.95, 0.95, an[5][3]))
								end
							end
							
							local scroll_cursor_pos = gui.GetCursorScroll()
							local pos_y_f = ((i - 1) * 111) + y_offset
							
							if i == items_per_column + 1 and #setting.fast[set_pil] > items_per_column then
								separator_added = true
								pos_y_f = pos_y_f + 30
								gui.DrawLine({16, 158 + pos_y_f - 33}, {602, 158 + pos_y_f - 33}, cl.line, 2)
								gui.DrawLine({16, 158 + pos_y_f - 12}, {602, 158 + pos_y_f - 12}, cl.line, 2)
								imgui.PushFont(bold_font[1])
								if num_win_fast == 1 then
									gui.Text(240, 158 + pos_y_f - 31, ' ВТОРАЯ КОЛОНКА ', bold_font[1])
								else
									gui.Text(240, 158 + pos_y_f - 31, ' ВТОРАЯ КОЛОНКА ', bold_font[1])
								end
								imgui.PopFont()
							end
							
							if separator_added and i > items_per_column + 1 then
								pos_y_f = pos_y_f + 30
							end
							
							if bool_edit_fast then
								local tab_element_bool = false
								imgui.SetCursorPos(imgui.ImVec2(31, 158 + pos_y_f))
								if imgui.InvisibleButton(u8'##Переместить элемент ' .. set_fast .. i, imgui.ImVec2(571, 97)) then
									
								end
								if imgui.IsItemClicked() then
									sc_cursor_pos = scroll_cursor_pos
									sc_cr_p_element[1] = 0
									sc_cr_p_element[2] = i
									sc_cr_p_element[3] = i
									sc_cr_p_element[4] = i
									sc_cr_p_element[5] = pos_y_f
									
								end
								if imgui.IsItemActive() then
									tab_element_bool = true
									bool_item_active = true
									sc_cr_pos = {x = sc_cursor_pos.x - scroll_cursor_pos.x, y = sc_cursor_pos.y - scroll_cursor_pos.y}
									pos_y_f = pos_y_f - sc_cr_pos.y
									
									local pos_scroll = imgui.GetScrollY()
									if scroll_cursor_pos.y < (50 + pos_scroll) then
										imgui.SetScrollY(pos_scroll - ((100 * anim) + (-(scroll_cursor_pos.y - pos_scroll) / 30)))
									elseif scroll_cursor_pos.y > (285 + pos_scroll) then
										imgui.SetScrollY(pos_scroll + ((100 * anim) + ((scroll_cursor_pos.y - pos_scroll - 285) / 30)))
									end
									
									sc_cr_p_element[1] = pos_y_f
								elseif bool_item_active and sc_cr_p_element[2] == i then
									bool_item_active = false
									swapping(setting.fast[set_pil], i, sdv_bool_fast)
									save()
									syncFastActions()
								elseif not imgui.IsItemActive() and sc_cr_p_element[2] == i then
									sc_cr_p_element[1] = 0
									sc_cr_p_element[2] = 0
									sc_cr_p_element[3] = 0
									sc_cr_p_element[4] = 0
									sc_cr_p_element[5] = 0
								else
									sc_cr_pos = {x = 0, y = 0}
								end
								
								if sc_cr_p_element[1] ~= 0 then
									local razn = sc_cr_p_element[1] - sc_cr_p_element[5]
									if sc_cr_p_element[1] ~= 0 and not tab_element_bool then
										if sc_cr_p_element[2] < i then
											if sc_cr_p_element[1] > (pos_y_f - 20) then
												bool_num_el = bool_num_el + 1
												sc_cr_p_element[3] = i
												if i == sc_cr_p_element[3] + 1 and sc_cr_p_element[1] < (pos_y_f + 222 - 20) then
													sc_cr_p_element[3] = i
													an[5][5] = 0
												end
												if i == sc_cr_p_element[3] then
													pos_y_f = pos_y_f - an[5][5]
												else
													pos_y_f = pos_y_f - 111
												end
												if an[5][5] < 111 then
													an[5][5] = an[5][5] + (500 * anim)
												else
													an[5][5] = 111
												end
											end
										elseif sc_cr_p_element[2] > i then
											if sc_cr_p_element[1] < (pos_y_f + 20) then
												bool_num_el = bool_num_el - 1
												if i == sc_cr_p_element[3] - 1 then
													sc_cr_p_element[3] = i
													an[5][5] = 0
												end
												if i == sc_cr_p_element[3] then
													pos_y_f = pos_y_f + an[5][5]
												else
													pos_y_f = pos_y_f + 111
												end
												if an[5][5] < 111 then
													an[5][5] = an[5][5] + (500 * anim)
												else
													an[5][5] = 111
												end
											end
										end
									end
								end
							end
							
							local vis_anim_input = 180
							if i <= 9 then
								gui.Text(5, 160 + pos_y_f, tostring(i), font[2])
							else
								gui.Text(2, 160 + pos_y_f, tostring(i), font[2])
							end
							if i == #setting.fast[set_pil] then vis_anim_input = an[5][4] end
							
							gui.DrawBox({16, 158 + pos_y_f}, {586, 97}, cl.tab, cl.line, 7, 15)
							gui.Text(26, 171 + pos_y_f, 'Имя', font[3])
							
							if bool_edit_fast then
								imgui.SetCursorPos(imgui.ImVec2(8, 150 + pos_y_f))
								if imgui.InvisibleButton(u8'##Удалить действие ' .. set_fast .. i, imgui.ImVec2(22, 22)) then
									table.remove(setting.fast[set_pil], i)
									save()
									syncFastActions()
									break
								end
								imgui.PushFont(fa_font[4])
								imgui.SetCursorPos(imgui.ImVec2(10, 152 + pos_y_f))
								if imgui.IsItemActive() then
									imgui.TextColored(cl.def, fa.CIRCLE_XMARK)
								else
									imgui.Text(fa.CIRCLE_XMARK)
								end
								imgui.PopFont()
							end
							
							local bool_setfast = setting.fast[set_pil][i].name
							setting.fast[set_pil][i].name = gui.InputText({68, 173 + pos_y_f}, vis_anim_input, setting.fast[set_pil][i].name, u8'Имя действия' .. i, 300, u8'Введите имя действия')
							if bool_setfast ~= setting.fast[set_pil][i].name then 
								save()
								syncFastActions()
							end
							gui.Text(328, 171 + pos_y_f, 'Команда', font[3])
							local bool_setfast2 = setting.fast[set_pil][i].cmd
							setting.fast[set_pil][i].cmd = gui.InputText({401, 173 + pos_y_f}, vis_anim_input, setting.fast[set_pil][i].cmd, u8'Команда действия' .. i, 25, u8'Введите команду действия', 'en')
							if bool_setfast2 ~= setting.fast[set_pil][i].cmd then 
								save()
								syncFastActions()
							end
							gui.DrawLine({16, 201 + pos_y_f}, {602, 201 + pos_y_f}, cl.line)
							gui.Text(26, 206 + pos_y_f, 'Передавать в первый аргумент id игрока', font[3])
							imgui.SetCursorPos(imgui.ImVec2(561, 201 + pos_y_f))
							
							local switched, new_state = gui.Switch(u8'##Передавать аргумент id игрока' .. set_fast .. i, setting.fast[set_pil][i].id)
							if switched then
								local action = setting.fast[set_pil][i]
								action.id = new_state
								
								table.remove(setting.fast[set_pil], i)
								
								local target_array
								if new_state then
									target_array = setting.fast.one_win
								else
									target_array = setting.fast.two_win
								end
								
								table.insert(target_array, action)
								
								syncFastActions()
								save()
							
								return
							end
							
							gui.DrawLine({16, 227 + pos_y_f}, {602, 227 + pos_y_f}, cl.line)
							gui.Text(26, 233 + pos_y_f, 'Отправлять команду без подтверждения', font[3])
							imgui.SetCursorPos(imgui.ImVec2(561, 228 + pos_y_f))
							local switched_send, new_state_send = gui.Switch(u8'##Отправлять команду без подтверждения' .. set_fast ..i, setting.fast[set_pil][i].send)
							if switched_send then
								setting.fast[set_pil][i].send = new_state_send
								save()
								syncFastActions()
							end
							
							if i == #setting.fast[set_pil] then
								imgui.PopStyleColor(1)
							end
						end
						sdv_bool_fast = bool_num_el
					else
						if an[5][1] == 0 then
							if num_win_fast == 1 then
								gui.Text(124, 218 + y_offset, 'Нет действий для категории "С ID игрока"', bold_font[1])
							else
								gui.Text(124, 218 + y_offset, 'Нет действий для категории "Без ID"', bold_font[1])
							end
						end
					end
					
					imgui.Dummy(imgui.ImVec2(0, 19))
					if (an[5][1] < 0 and an[5][1] > -165.2) or (an[5][1] <= -165.2 and an[5][1] > -165.3) then
						imgui.Dummy(imgui.ImVec2(0, 106))
						imgui.SetScrollY(imgui.GetScrollMaxY())
					end
				end
			end
			
			if num_win_fast == 1 then
				fast_table_func(2)
			else
				fast_table_func(3)
			end
			
			
			if (setting.smart_fast_menu and (#setting.fast.one_win > 0 or #setting.fast.two_win > 0)) or (not setting.smart_fast_menu and (#setting.fast.one_win > 0 or #setting.fast.two_win > 0)) then
				imgui.SetCursorPos(imgui.ImVec2(814, 381 + y_offset))
				if imgui.InvisibleButton(u8'##Настройки быстрого доступа', imgui.ImVec2(22, 22)) then
					bool_edit_fast = not bool_edit_fast
				end
				imgui.PushFont(fa_font[4])
				imgui.SetCursorPos(imgui.ImVec2(816, 383 + y_offset))
				if imgui.IsItemActive() then
					imgui.TextColored(cl.def, fa.GEAR)
				else
					imgui.Text(fa.GEAR)
				end
				imgui.PopFont()
			else
				bool_edit_fast = false
			end
			
			if an[5][1] < 0 and an[5][1] > -165.2 then
				local bool_minus = 40 * anim
				an[5][1] = (an[5][1] - bool_minus) - (bool_minus * match_interpolation(0, 155, -an[5][1], 30))
			elseif an[5][1] <= -165.2 and an[5][1] > -165.3 then
				if setting.smart_fast_menu then
					if num_win_fast == 1 then
						table.insert(setting.fast.one_win, {name = u8'Действие ' .. (#setting.fast.one_win + 1), cmd = '', send = true, id = true})
					else
						table.insert(setting.fast.two_win, {name = u8'Действие ' .. (#setting.fast.two_win + 1), cmd = '', send = true, id = false})
					end
				else
					if num_win_fast == 1 then
						table.insert(setting.fast.one_win, {name = u8'Действие ' .. (#setting.fast.one_win + 1), cmd = '', send = true, id = true})
					else
						table.insert(setting.fast.two_win, {name = u8'Действие ' .. (#setting.fast.two_win + 1), cmd = '', send = true, id = true})
					end
				end
				syncFastActions()
				an[5][1] = -165.4
				an[5][3] = 0
				an[5][4] = 0
			else
				an[5][1] = 0
				an[5][2] = 420
				if an[5][3] < 1.00 then
					an[5][3] = an[5][3] + (2.9 * anim)
				else
					an[5][3] = 1.00
				end
				if an[5][4] < 180 then
					an[5][4] = an[5][4] + (1000 * anim)
					if an[5][4] > 180 then an[5][4] = 180 end
				else
					an[5][4] = 180
				end
			end
		end
	elseif tab_settings == 5 then
		new_draw(16, 37)
		
		gui.Text(26, 26, 'Мемберс организации на Вашем экране', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 21))
		if gui.Switch(u8'##Мембрес', setting.mb.func) then
			setting.mb.func = not setting.mb.func
			save()
		end
		
		if setting.mb.func then
			gui.Text(25, 72, 'Содержимое', bold_font[1])
			new_draw(97, 215)
			
			gui.Text(26, 106, 'Отображать id игроков', font[3])
			imgui.SetCursorPos(imgui.ImVec2(561, 101))
			if gui.Switch(u8'##Отображать id игроков', setting.mb.id) then
				setting.mb.id = not setting.mb.id
				save()
			end
			gui.DrawLine({16, 132}, {602, 132}, cl.line)
			gui.Text(26, 142, 'Отображать ранг игроков', font[3])
			imgui.SetCursorPos(imgui.ImVec2(561, 137))
			if gui.Switch(u8'##Отображать ранг игроков', setting.mb.rank) then
				setting.mb.rank = not setting.mb.rank
				save()
			end
			gui.DrawLine({16, 168}, {602, 168}, cl.line)
			gui.Text(26, 178, 'Отображать время АФК', font[3])
			imgui.SetCursorPos(imgui.ImVec2(561, 173))
			if gui.Switch(u8'##Отображать время АФК', setting.mb.afk) then
				setting.mb.afk = not setting.mb.afk
				save()
			end
			gui.DrawLine({16, 204}, {602, 204}, cl.line)
			gui.Text(26, 214, 'Отображать количество выговоров', font[3])
			imgui.SetCursorPos(imgui.ImVec2(561, 209))
			if gui.Switch(u8'##Отображать количество выговоров', setting.mb.warn) then
				setting.mb.warn = not setting.mb.warn
				save()
			end
			gui.DrawLine({16, 240}, {602, 240}, cl.line)
			gui.Text(26, 250, 'Отображать теги организации в никнеймах', font[3])
			imgui.SetCursorPos(imgui.ImVec2(561, 245))
			if gui.Switch(u8'##Отображать теги в никнеймах', setting.mb_tags) then
				setting.mb_tags = not setting.mb_tags
				save()
			end
			gui.DrawLine({16, 276}, {602, 276}, cl.line)
			gui.Text(26, 286, 'Выделять цветом тех, кто в форме', font[3])
			imgui.SetCursorPos(imgui.ImVec2(561, 281))
			if gui.Switch(u8'##Выделять цветом тех, кто в форме', setting.mb.form) then
				setting.mb.form = not setting.mb.form
				save()
			end
			
			gui.Text(25, 331, 'Визуальное отображение', bold_font[1])
			new_draw(356, 330)
			
			gui.Text(26, 365, 'Скрывать при открытом диалоге', font[3])
			imgui.SetCursorPos(imgui.ImVec2(561, 360))
			if gui.Switch(u8'##Скрывать при открытом диалоге', setting.mb.dialog) then
				setting.mb.dialog = not setting.mb.dialog
				save()
			end
			gui.DrawLine({16, 391}, {602, 391}, cl.line)
			gui.Text(26, 401, 'Инверсировать текст', font[3])
			imgui.SetCursorPos(imgui.ImVec2(561, 396))
			if gui.Switch(u8'##Инверсировать текст', setting.mb.invers) then
				setting.mb.invers = not setting.mb.invers
				save()
			end
			gui.DrawLine({16, 427}, {602, 427}, cl.line)
			gui.Text(26, 437, 'Флаг шрифта', font[3])
			local bool_set_flag = setting.mb.flag
			setting.mb.flag = gui.ListTableMove({572, 437}, {u8'Без обводки', u8'Без обводки наклонённый', u8'Без обводки жирный наклонённый', u8'С обводкой', u8'С обводкой жирный', u8'С обводкой наклонённый', u8'С обводкой жирный наклонённый', u8'Без обводки с тенью', u8'Без обводки жирный с тенью', u8'Без обводки с тенью наклонённый', u8'Без обводки с тенью жирный наклонённый', u8'С обводкой и тенью', u8'С обводкой и тенью жирный'}, setting.mb.flag, 'Select Size')
			if setting.mb.flag ~= bool_set_flag then
				fontes = renderCreateFont('Trebuchet MS', setting.mb.size, setting.mb.flag)
				save() 
			end
			gui.DrawLine({16, 463}, {602, 463}, cl.line)
			
			local mb_set = {
				vis = imgui.new.float(setting.mb.vis),
				size = imgui.new.float(setting.mb.size),
				dist = imgui.new.float(setting.mb.dist)
			}
			
			gui.SliderCircle('SliderVisibleMb',{54, 486}, 70, 257, imgui.GetColorU32Vec4(imgui.ImVec4(0.90, 0.90, 0.90, 1.00)), 12, 50, 100, mb_set.vis[0])
			gui.SliderCircle('SliderVisibleMb2',{239, 486}, 70, 257, imgui.GetColorU32Vec4(imgui.ImVec4(0.90, 0.90, 0.90, 1.00)), 12, 50, 50, mb_set.size[0])
			gui.SliderCircle('SliderVisibleMb3',{424, 486}, 70, 257, imgui.GetColorU32Vec4(imgui.ImVec4(0.90, 0.90, 0.90, 1.00)), 12, 50, 50, mb_set.dist[0])
			
			
			gui.Text(78, 621, 'Прозрачность', font[3])
			local bool_set_vis = mb_set.vis[0]
			mb_set.vis[0] = gui.SliderBar('##Прозрачность текста', mb_set.vis, 0, 100, 152, {51, 646})
			if mb_set.vis[0] ~= bool_set_vis then
				setting.mb.vis = floor(mb_set.vis[0])
				save()
			end
			gui.Text(286, 621, 'Размер', font[3])
			local bool_set_size = mb_set.size[0]
			mb_set.size[0] = gui.SliderBar('##Размер текста',mb_set.size, 1, 50, 152, {236, 646})
			if mb_set.size[0] ~= bool_set_size then
				setting.mb.size = floor(mb_set.size[0])
				fontes = renderCreateFont('Trebuchet MS', mb_set.size[0], setting.mb.flag)
				save()
			end
			gui.Text(400, 621, 'Расстояние между строками', font[3])
			local bool_set_dist = mb_set.dist[0]
			mb_set.dist[0] = gui.SliderBar('##Расстояние между строками текста', mb_set.dist, 0, 50, 152, {421, 646})
			if mb_set.dist[0] ~= bool_set_dist then
				setting.mb.dist = floor(mb_set.dist[0])
				save()
			end
			setting.mb.vis = mb_set.vis[0]
			setting.mb.size = mb_set.size[0]
			setting.mb.dist = mb_set.dist[0]
			
			gui.Text(25, 705, 'Цветовой стиль текста', bold_font[1])
			new_draw(730, 107)
			gui.Text(26, 739, 'Заголовок', font[3])
			gui.DrawLine({16, 765}, {602, 765}, cl.line)
			gui.Text(26, 775, 'Сотрудники в форме', font[3])
			gui.DrawLine({16, 801}, {602, 801}, cl.line)
			gui.Text(26, 811, 'Сотрудники без формы', font[3])
			imgui.PushStyleVarVec2(imgui.StyleVar.FramePadding, imgui.ImVec2(6.5, 6.5))
			imgui.SetCursorPos(imgui.ImVec2(564, 734))
			if imgui.ColorEdit4('##TitleColor', col_mb.title, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoAlpha) then
				local c = imgui.ImVec4(col_mb.title[0], col_mb.title[1], col_mb.title[2], col_mb.title[3])
				local argb = imgui.ColorConvertFloat4ToARGB(c)
				setting.mb.color.title = imgui.ColorConvertFloat4ToARGB(c)
				save()
			end
			imgui.SetCursorPos(imgui.ImVec2(564, 770))
			if imgui.ColorEdit4('##WorkColor', col_mb.work, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoAlpha) then
				local c = imgui.ImVec4(col_mb.work[0], col_mb.work[1], col_mb.work[2], col_mb.work[3])
				local argb = imgui.ColorConvertFloat4ToARGB(c)
				setting.mb.color.work = imgui.ColorConvertFloat4ToARGB(c)
				save()
			end
			imgui.SetCursorPos(imgui.ImVec2(564, 806))
			if imgui.ColorEdit4('##DefColor', col_mb.default, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoAlpha) then
				local c = imgui.ImVec4(col_mb.default[0], col_mb.default[1], col_mb.default[2], col_mb.default[3])
				local argb = imgui.ColorConvertFloat4ToARGB(c)
				setting.mb.color.default = imgui.ColorConvertFloat4ToARGB(c)
				save()
			end
			imgui.PopStyleVar()
			
			new_draw(856, 70)
			--gui.DrawLine({16, 891}, {602, 891}, cl.line)
			gui.Text(26, 865, 'Отображать только сотрудников со следующими рангами:', font[3])
			for num_rank = 1, 10 do
				imgui.PushFont(bold_font[1])
				local calc_text = imgui.CalcTextSize(tostring(num_rank))
				imgui.PopFont()
				if setting.rank_members[num_rank] then
					gui.Draw({49 + ((num_rank - 1) * 55), 895}, {25, 25}, cl.def, 5, 15)
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.95, 0.95, 0.95, 1.00))
				else
					gui.Draw({49 + ((num_rank - 1) * 55), 895}, {25, 25}, cl.bg, 5, 15)
				end
				
				gui.Text((62 + ((num_rank - 1) * 55)) - (calc_text.x / 2), 899, num_rank, bold_font[1])
				
				if setting.rank_members[num_rank] then
					imgui.PopStyleColor(1)
				end
				imgui.SetCursorPos(imgui.ImVec2(49 + ((num_rank - 1) * 55), 895))
				if imgui.InvisibleButton(u8'##Переключить отображение ранга ' .. num_rank, imgui.ImVec2(25, 25)) then
					setting.rank_members[num_rank] = not setting.rank_members[num_rank]
				end
			end
			
			new_draw(945, 35)
			gui.Text(26, 954, 'Положение текста на экране', font[3])
			if gui.Button(u8'Изменить...', {491, 950}, {99, 25}) then
				changePosition()
			end
			
			imgui.Dummy(imgui.ImVec2(0, 21))
		end
	elseif tab_settings == 6 then
		if setting.org <= 4 then
			new_draw(16, 53)
			
			gui.Text(26, 26, 'Упростить систему вызовов /godeath', font[3])
			imgui.SetCursorPos(imgui.ImVec2(561, 21))
			if gui.Switch(u8'##Упростить godeath', setting.godeath.func) then
				setting.godeath.func = not setting.godeath.func
				if setting.godeath.func and setting.godeath.cmd_go then
						sampRegisterChatCommand('go', function()
							go_medic_or_fire()
						end)
				elseif not setting.godeath.func and setting.godeath.cmd_go then
					sampUnregisterChatCommand('go')
				end
				save()
			end
			gui.TextInfo({26, 45}, {'Вам станет удобнее работать с вызовами игроков через /godeath'})
			
			if setting.godeath.func then
				local function accent_col(num_acc, color_acc, color_acc_act)
					imgui.SetCursorPos(imgui.ImVec2(407 + (num_acc * 43), 371))
					local p = imgui.GetCursorScreenPos()
					
					imgui.SetCursorPos(imgui.ImVec2(396 + (num_acc * 43), 360))
					if imgui.InvisibleButton(u8'##Выбор цвета' .. num_acc, imgui.ImVec2(22, 22)) then
						setting.color_godeath = color_acc
						setting.godeath.color = num_acc
						save()
					end
					if imgui.IsItemActive() then
						imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x, p.y + 0.5), 12, imgui.GetColorU32Vec4(imgui.ImVec4(color_acc_act[1], color_acc_act[2], color_acc_act[3] ,1.00)), 60)
					else
						imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x, p.y + 0.5),  12, imgui.GetColorU32Vec4(imgui.ImVec4(color_acc[1], color_acc[2], color_acc[3] ,1.00)), 60)
					end
					if num_acc == setting.godeath.color then
						imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x, p.y + 0.5), 4, imgui.GetColorU32Vec4(imgui.ImVec4(1.00, 1.00, 1.00 ,1.00)), 60)
					end
				end
				
				gui.Text(25, 88, 'Взаимодействие', bold_font[1])
				new_draw(113, 107)
				
				gui.Text(26, 122, 'Принимать последний вызов командой /go', font[3])
				imgui.SetCursorPos(imgui.ImVec2(561, 118))
				if gui.Switch(u8'##Принимать последний вызов командой /go', setting.godeath.cmd_go) then
					setting.godeath.cmd_go = not setting.godeath.cmd_go
					if setting.godeath.cmd_go then
						sampRegisterChatCommand('go', function()
							go_medic_or_fire()
						end)
					else
						sampUnregisterChatCommand('go')
					end
					save()
				end
				gui.DrawLine({16, 148}, {602, 148}, cl.line)
				gui.Text(26, 158, 'Автоматически докладывать в рацию /r о принятии вызова', font[3])
				imgui.SetCursorPos(imgui.ImVec2(561, 154))
				if gui.Switch(u8'##Автоматически докладывать', setting.godeath.auto_send) then
					setting.godeath.auto_send = not setting.godeath.auto_send
					save()
				end
				gui.DrawLine({16, 184}, {602, 184}, cl.line)
				gui.Text(26, 194, 'Воспроизводить звуковой сигнал при поступлении вызова', font[3])
				imgui.SetCursorPos(imgui.ImVec2(561, 189))
				if gui.Switch(u8'##Воспроизводить звуковой сигнал при поступлении вызова', setting.godeath.sound) then
					setting.godeath.sound = not setting.godeath.sound
					save()
				end
				
				gui.Text(25, 239, 'Отображение', bold_font[1])
				new_draw(264, 71)
				
				gui.Text(26, 273, 'Отображать расстояние от Вас до пациента', font[3])
				imgui.SetCursorPos(imgui.ImVec2(561, 268))
				if gui.Switch(u8'##Отображать расстояние', setting.godeath.meter) then
					setting.godeath.meter = not setting.godeath.meter
					save()
				end
				gui.DrawLine({16, 299}, {602, 299}, cl.line)
				gui.Text(26, 309, 'Заменять два сообщения о вызове одним', font[3])
				imgui.SetCursorPos(imgui.ImVec2(561, 304))
				if gui.Switch(u8'##Заменять два сообщения', setting.godeath.two_text) then
					setting.godeath.two_text = not setting.godeath.two_text
					save()
				end

				if setting.godeath.two_text then
					new_draw(354, 35)
					gui.Text(26, 363, 'Цвет текста вызова', font[3])
					accent_col(0, {1.00, 0.33, 0.31}, {1.00, 0.23, 0.31})
					accent_col(1, {0.75, 0.35, 0.87}, {0.75, 0.25, 0.87})
					accent_col(2, {0.26, 0.45, 0.94}, {0.26, 0.35, 0.94})
					accent_col(3, {0.20, 0.74, 0.29}, {0.20, 0.64, 0.29})
					accent_col(4, {0.50, 0.50, 0.52}, {0.40, 0.40, 0.42})
				end
				
				imgui.Dummy(imgui.ImVec2(0, 18))
			end
		elseif setting.org == 9 then
			new_draw(16, 53)

			gui.Text(26, 26, 'Упростить систему выездов на пожары', font[3])
			imgui.SetCursorPos(imgui.ImVec2(561, 21))
			if gui.Switch(u8'##Упростить вызовы на пожары', setting.godeath.func) then
				setting.godeath.func = not setting.godeath.func
				if setting.godeath.func and setting.godeath.cmd_go then
						sampRegisterChatCommand('go', function()
							go_medic_or_fire()
						end)
				elseif not setting.godeath.func and setting.godeath.cmd_go then
					sampUnregisterChatCommand('go')
				end
				save()
			end
			gui.TextInfo({26, 45}, {'Вам станет удобнее принимать вызовы /fire'})
			
			if setting.godeath.func then
				gui.Text(25, 88, 'Взаимодействие с вызовами', bold_font[1])
				new_draw(113, 179 + an[27])
				
				gui.Text(26, 122, 'Принимать последний вызов командой /go', font[3])
				imgui.SetCursorPos(imgui.ImVec2(561, 118))
				if gui.Switch(u8'##Принимать последний вызов командой /go', setting.godeath.cmd_go) then
					setting.godeath.cmd_go = not setting.godeath.cmd_go
					if setting.godeath.cmd_go then
						sampRegisterChatCommand('go', function()
							go_medic_or_fire()
						end)
					else
						sampUnregisterChatCommand('go')
					end
					save()
				end
				gui.DrawLine({16, 148}, {602, 148}, cl.line)
				gui.Text(26, 158, 'Автоматически докладывать в рацию /r о принятии вызова', font[3])
				imgui.SetCursorPos(imgui.ImVec2(561, 154))
				if gui.Switch(u8'##Автоматически докладывать', setting.fire.auto_send) then
					setting.fire.auto_send = not setting.fire.auto_send
					if setting.fire.auto_send then
						ANIMATE[1] = animate(an[27], an[27], 42, 42, an[27], an[27], 1, 4)
					else
						ANIMATE[2] = animate(an[27], an[27], 0, 0, an[27], an[27], 1, 4)
					end
					save()
				end
				
				if setting.fire.auto_send then
					an[27] = ANIMATE[1]()
				else
					an[27] = ANIMATE[2]()
				end
				
				if an[27] > 0 then
					local bool_set_time = setting.text_fires
					setting.text_fires = gui.InputText({33, 194}, 548, setting.text_fires, u8'Доклад r', 230, u8'Введите текст отыгровки')
					if setting.text_fires ~= bool_set_time then
						save()
					end
					gui.Draw({16, 185 + an[27]}, {586, 30}, cl.tab)
				end
				
				gui.DrawLine({16, 184 + an[27]}, {602, 184 + an[27]}, cl.line)
				gui.Text(26, 194 + an[27], 'Воспроизводить звуковой сигнал при поступлении вызова', font[3])
				imgui.SetCursorPos(imgui.ImVec2(561, 189 + an[27]))
				if gui.Switch(u8'##Воспроизводить звуковой сигнал при поступлении вызова', setting.fire.sound) then
					setting.fire.sound = not setting.fire.sound
					save()
				end
				gui.DrawLine({16, 220 + an[27]}, {602, 220 + an[27]}, cl.line)
				gui.Text(26, 230 + an[27], 'Автоматически открывать /fires после поступления вызова', font[3])
				imgui.SetCursorPos(imgui.ImVec2(561, 225 + an[27]))
				if gui.Switch(u8'##Автоматически открывать /fires после поступления вызова', setting.fire.auto_cmd_fires) then
					setting.fire.auto_cmd_fires = not setting.fire.auto_cmd_fires
					save()
				end
				gui.DrawLine({16, 256 + an[27]}, {602, 256 + an[27]}, cl.line)
				gui.Text(26, 266 + an[27], 'Автоматически выбирать новейший пожар после открытия окна /fires', font[3])
				imgui.SetCursorPos(imgui.ImVec2(561, 261 + an[27]))
				if gui.Switch(u8'##Автоматически выбирать новейший пожар после открытия окна /fires', setting.fire.auto_select_fires) then
					setting.fire.auto_select_fires = not setting.fire.auto_select_fires
					save()
				end
				
				gui.Text(25, 311 + an[27], 'Доклады в рабочую рацию', bold_font[1])
				
				local pos_report_plus = 0
				new_draw(336 + an[27], 107)
				gui.DrawLine({16, 371 + an[27]}, {602, 371 + an[27]}, cl.line)
				gui.DrawLine({16, 407 + an[27]}, {602, 407 + an[27]}, cl.line)
				gui.Text(26, 345 + an[27], 'Прибытие на место пожара', font[3])
				imgui.SetCursorPos(imgui.ImVec2(561, 340 + an[27]))
				if gui.Switch(u8'##Прибытие на место пожара', setting.report_fire.arrival.func) then
					setting.report_fire.arrival.func = not setting.report_fire.arrival.func
					save()
				end
				if setting.report_fire.arrival.func then
					gui.Text(26, 381 + an[27], 'Спрашивать подтверждение перед отправкой', font[3])
					imgui.SetCursorPos(imgui.ImVec2(561, 376 + an[27]))
					if gui.Switch(u8'##Спрашивать подтверждение перед отправкой', setting.report_fire.arrival.ask) then
						setting.report_fire.arrival.ask = not setting.report_fire.arrival.ask
						save()
					end
					gui.Text(26, 417 + an[27], 'Текст доклада', font[3])
					local bool_set_time = setting.report_fire.arrival.text
					setting.report_fire.arrival.text = gui.InputText({135, 419 + an[27]}, 446, setting.report_fire.arrival.text, u8'Доклад прибытия на пожар', 230, u8'Введите текст отыгровки')
					if setting.report_fire.arrival.text ~= bool_set_time then
						save()
					end
				else
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.40, 0.40, 0.40, 0.50))
					gui.Text(26, 381 + an[27], 'Спрашивать подтверждение перед отправкой', font[3])
					imgui.SetCursorPos(imgui.ImVec2(561, 376 + an[27]))
					gui.SwitchFalse(setting.report_fire.arrival.ask)
					gui.Text(26, 417 + an[27], 'Текст доклада', font[3])
					gui.InputFalse(setting.report_fire.arrival.text, 135, 419 + an[27], 446)
					imgui.PopStyleColor(1)
				end
				
				pos_report_plus = pos_report_plus + 121
				new_draw(336 + an[27] + pos_report_plus, 107)
				gui.DrawLine({16, 371 + an[27] + pos_report_plus}, {602, 371 + an[27] + pos_report_plus}, cl.line)
				gui.DrawLine({16, 407 + an[27] + pos_report_plus}, {602, 407 + an[27] + pos_report_plus}, cl.line)
				gui.Text(26, 345 + an[27] + pos_report_plus, 'Ликвидация очагов возгарания', font[3])
				imgui.SetCursorPos(imgui.ImVec2(561, 340 + an[27] + pos_report_plus))
				if gui.Switch(u8'##Ликвидация очагов возгарания', setting.report_fire.foci.func) then
					setting.report_fire.foci.func = not setting.report_fire.foci.func
					save()
				end
				if setting.report_fire.foci.func then
					gui.Text(26, 381 + an[27] + pos_report_plus, 'Спрашивать подтверждение перед отправкой', font[3])
					imgui.SetCursorPos(imgui.ImVec2(561, 376 + an[27] + pos_report_plus))
					if gui.Switch(u8'##Спрашивать подтверждение перед отправкой 2', setting.report_fire.foci.ask) then
						setting.report_fire.foci.ask = not setting.report_fire.foci.ask
						save()
					end
					gui.Text(26, 417 + an[27] + pos_report_plus, 'Текст доклада', font[3])
					local bool_set_time = setting.report_fire.foci.text
					setting.report_fire.foci.text = gui.InputText({135, 419 + an[27] + pos_report_plus}, 446, setting.report_fire.foci.text, u8'Ликвидация пожара', 230, u8'Введите текст отыгровки')
					if setting.report_fire.foci.text ~= bool_set_time then
						save()
					end
				else
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.40, 0.40, 0.40, 0.50))
					gui.Text(26, 381 + an[27] + pos_report_plus, 'Спрашивать подтверждение перед отправкой', font[3])
					imgui.SetCursorPos(imgui.ImVec2(561, 376 + an[27] + pos_report_plus))
					gui.SwitchFalse(setting.report_fire.foci.ask)
					gui.Text(26, 417 + an[27] + pos_report_plus, 'Текст доклада', font[3])
					gui.InputFalse(setting.report_fire.foci.text, 135, 419 + an[27] + pos_report_plus, 446)
					imgui.PopStyleColor(1)
				end
				
				pos_report_plus = pos_report_plus + 121
				new_draw(336 + an[27] + pos_report_plus, 107)
				gui.DrawLine({16, 371 + an[27] + pos_report_plus}, {602, 371 + an[27] + pos_report_plus}, cl.line)
				gui.DrawLine({16, 407 + an[27] + pos_report_plus}, {602, 407 + an[27] + pos_report_plus}, cl.line)
				gui.Text(26, 345 + an[27] + pos_report_plus, 'Погрузка пострадавшего на носилки', font[3])
				imgui.SetCursorPos(imgui.ImVec2(561, 340 + an[27] + pos_report_plus))
				if gui.Switch(u8'##Погрузка пострадавшего на носилки', setting.report_fire.stretcher.func) then
					setting.report_fire.stretcher.func = not setting.report_fire.stretcher.func
					save()
				end
				if setting.report_fire.stretcher.func then
					gui.Text(26, 381 + an[27] + pos_report_plus, 'Спрашивать подтверждение перед отправкой', font[3])
					imgui.SetCursorPos(imgui.ImVec2(561, 376 + an[27] + pos_report_plus))
					if gui.Switch(u8'##Спрашивать подтверждение перед отправкой 3', setting.report_fire.stretcher.ask) then
						setting.report_fire.stretcher.ask = not setting.report_fire.stretcher.ask
						save()
					end
					gui.Text(26, 417 + an[27] + pos_report_plus, 'Текст доклада', font[3])
					local bool_set_time = setting.report_fire.stretcher.text
					setting.report_fire.stretcher.text = gui.InputText({135, 419 + an[27] + pos_report_plus}, 446, setting.report_fire.stretcher.text, u8'Пстрадавший на носилки', 230, u8'Введите текст отыгровки')
					if setting.report_fire.stretcher.text ~= bool_set_time then
						save()
					end
				else
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.40, 0.40, 0.40, 0.50))
					gui.Text(26, 381 + an[27] + pos_report_plus, 'Спрашивать подтверждение перед отправкой', font[3])
					imgui.SetCursorPos(imgui.ImVec2(561, 376 + an[27] + pos_report_plus))
					gui.SwitchFalse(setting.report_fire.stretcher.ask)
					gui.Text(26, 417 + an[27] + pos_report_plus, 'Текст доклада', font[3])
					gui.InputFalse(setting.report_fire.stretcher.text, 135, 419 + an[27] + pos_report_plus, 446)
					imgui.PopStyleColor(1)
				end
				
				pos_report_plus = pos_report_plus + 121
				new_draw(336 + an[27] + pos_report_plus, 107)
				gui.DrawLine({16, 371 + an[27] + pos_report_plus}, {602, 371 + an[27] + pos_report_plus}, cl.line)
				gui.DrawLine({16, 407 + an[27] + pos_report_plus}, {602, 407 + an[27] + pos_report_plus}, cl.line)
				gui.Text(26, 345 + an[27] + pos_report_plus, 'Спасение пострадавшего', font[3])
				imgui.SetCursorPos(imgui.ImVec2(561, 340 + an[27] + pos_report_plus))
				if gui.Switch(u8'##Спасение пострадавшего', setting.report_fire.salvation.func) then
					setting.report_fire.salvation.func = not setting.report_fire.salvation.func
					save()
				end
				if setting.report_fire.salvation.func then
					gui.Text(26, 381 + an[27] + pos_report_plus, 'Спрашивать подтверждение перед отправкой', font[3])
					imgui.SetCursorPos(imgui.ImVec2(561, 376 + an[27] + pos_report_plus))
					if gui.Switch(u8'##Спрашивать подтверждение перед отправкой 4', setting.report_fire.salvation.ask) then
						setting.report_fire.salvation.ask = not setting.report_fire.salvation.ask
						save()
					end
					gui.Text(26, 417 + an[27] + pos_report_plus, 'Текст доклада', font[3])
					local bool_set_time = setting.report_fire.salvation.text
					setting.report_fire.salvation.text = gui.InputText({135, 419 + an[27] + pos_report_plus}, 446, setting.report_fire.salvation.text, u8'Спасение пострадавшего', 230, u8'Введите текст отыгровки')
					if setting.report_fire.salvation.text ~= bool_set_time then
						save()
					end
				else
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.40, 0.40, 0.40, 0.50))
					gui.Text(26, 381 + an[27] + pos_report_plus, 'Спрашивать подтверждение перед отправкой', font[3])
					imgui.SetCursorPos(imgui.ImVec2(561, 376 + an[27] + pos_report_plus))
					gui.SwitchFalse(setting.report_fire.salvation.ask)
					gui.Text(26, 417 + an[27] + pos_report_plus, 'Текст доклада', font[3])
					gui.InputFalse(setting.report_fire.salvation.text, 135, 419 + an[27] + pos_report_plus, 446)
					imgui.PopStyleColor(1)
				end
				
				pos_report_plus = pos_report_plus + 121
				new_draw(336 + an[27] + pos_report_plus, 107)
				gui.DrawLine({16, 371 + an[27] + pos_report_plus}, {602, 371 + an[27] + pos_report_plus}, cl.line)
				gui.DrawLine({16, 407 + an[27] + pos_report_plus}, {602, 407 + an[27] + pos_report_plus}, cl.line)
				gui.Text(26, 345 + an[27] + pos_report_plus, 'Полное устранение пожара', font[3])
				imgui.SetCursorPos(imgui.ImVec2(561, 340 + an[27] + pos_report_plus))
				if gui.Switch(u8'##Полное устранение пожара', setting.report_fire.extinguishing.func) then
					setting.report_fire.extinguishing.func = not setting.report_fire.extinguishing.func
					save()
				end
				if setting.report_fire.extinguishing.func then
					gui.Text(26, 381 + an[27] + pos_report_plus, 'Спрашивать подтверждение перед отправкой', font[3])
					imgui.SetCursorPos(imgui.ImVec2(561, 376 + an[27] + pos_report_plus))
					if gui.Switch(u8'##Спрашивать подтверждение перед отправкой 5', setting.report_fire.extinguishing.ask) then
						setting.report_fire.extinguishing.ask = not setting.report_fire.extinguishing.ask
						save()
					end
					gui.Text(26, 417 + an[27] + pos_report_plus, 'Текст доклада', font[3])
					local bool_set_time = setting.report_fire.extinguishing.text
					setting.report_fire.extinguishing.text = gui.InputText({135, 419 + an[27] + pos_report_plus}, 446, setting.report_fire.extinguishing.text, u8'Устранение пожара', 230, u8'Введите текст отыгровки')
					if setting.report_fire.extinguishing.text ~= bool_set_time then
						save()
					end
				else
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.40, 0.40, 0.40, 0.50))
					gui.Text(26, 381 + an[27] + pos_report_plus, 'Спрашивать подтверждение перед отправкой', font[3])
					imgui.SetCursorPos(imgui.ImVec2(561, 376 + an[27] + pos_report_plus))
					gui.SwitchFalse(setting.report_fire.extinguishing.ask)
					gui.Text(26, 417 + an[27] + pos_report_plus, 'Текст доклада', font[3])
					gui.InputFalse(setting.report_fire.extinguishing.text, 135, 419 + an[27] + pos_report_plus, 446)
					imgui.PopStyleColor(1)
				end
				
				imgui.Dummy(imgui.ImVec2(0, 22))
				tags_in_call()
			end
		elseif setting.org == 10 then
			new_draw(16, 53)
			
			gui.Text(26, 25, 'Умное изменение срока', font[3])
			imgui.SetCursorPos(imgui.ImVec2(561, 21))
			local toggled_smart_punish, new_smart_punish = gui.Switch('##smart_punish', setting.tsr_settings.smart_punish)
			if toggled_smart_punish then
				setting.tsr_settings.smart_punish = new_smart_punish
				if new_smart_punish then
					sampRegisterChatCommand('punish', smart_punish_func)
					sampRegisterChatCommand('testpunish', test_punish_func)
					download_punish_reasons()
				else
					sampUnregisterChatCommand('punish')
					sampUnregisterChatCommand('testpunish')
				end
				save()
			end
			gui.TextInfo({26, 44}, {'Позволяет удобно изменять срок заключенным, активация /punish'})
			
			for i = 1, #cmd_defoult.jail do
				local command_return = false
				if #cmd[1] ~= 0 then
					for c = 1, #cmd[1] do
						if cmd[1][c].cmd == cmd_defoult.jail[i].cmd then
							command_return = true
						end
					end
				end
				if not command_return then
					table.insert(cmd[1], cmd_defoult.jail[i])
					sampRegisterChatCommand(cmd_defoult.jail[i].cmd, function(arg) 
					cmd_start(arg, tostring(cmd_defoult.jail[i].UID) .. cmd_defoult.jail[i].cmd) end)
				end
				setting.gun_func = true
			end
		elseif setting.org >= 11 and setting.org <= 15 then
			new_draw(16, 103)
			
			gui.Text(26, 25, 'Умный розыск', font[3])
			imgui.SetCursorPos(imgui.ImVec2(561, 21))
			local toggled_smart_su, new_smart_su = gui.Switch('##smart_su', setting.police_settings.smart_su)
			if toggled_smart_su then
				setting.police_settings.smart_su = new_smart_su
				if new_smart_su then
					sampRegisterChatCommand('su', smart_su_func)
					download_wanted_reasons()
				else
					sampUnregisterChatCommand('su')
				end
				save()
			end
			gui.TextInfo({26, 44}, {'Позволяет удобно выдавать розыск, активация /su'})
			
			gui.DrawLine({16, 72}, {602, 72}, cl.line)
			
			gui.Text(26, 82, 'Умные штрафы', font[3])
			imgui.SetCursorPos(imgui.ImVec2(561, 78))
			local toggled_smart_ticket, new_smart_ticket = gui.Switch('##smart_ticket', setting.police_settings.smart_ticket)
			if toggled_smart_ticket then
				setting.police_settings.smart_ticket = new_smart_ticket
				if new_smart_ticket then
					sampRegisterChatCommand('ticket', smart_ticket_func)
					download_ticket_reasons()
				else
					sampUnregisterChatCommand('ticket')
				end
				save()
			end
			gui.TextInfo({26, 101}, {'Позволяет удобно выписывать штрафы, активация /ticket'})
			
			new_draw(16 + 119, 53)
			gui.Text(26, 26 + 119, 'Быстрое включение сирены', font[3])
			imgui.SetCursorPos(imgui.ImVec2(561, 21 + 119))
			if gui.Switch(u8'##siren_toggle', setting.police_settings.siren) then
				setting.police_settings.siren = not setting.police_settings.siren
				save()
			end
			gui.TextInfo({26, 45 + 119}, {'Взаимодействие с сиреной по одному нажатию кнопки.'})
			
			if setting.police_settings.siren then
				if gui.Button(u8'Настроить', {370, 26 + 119}, {130, 20}) then
					imgui.OpenPopup(u8'Настроить сирену')
				end
			else
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
				gui.Button(u8'Настроить', {370, 26 + 119}, {130, 20}, false)
				imgui.PopStyleColor(3)
			end
			
			if imgui.BeginPopupModal(u8'Настроить сирену', null, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar) then
				imgui.BeginChild(u8'Настройки сирены', imgui.ImVec2(730, 210), false, imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoScrollbar)
				gui.Draw({16, 16}, {698, 180}, cl.tab, 7, 15)
				gui.Text(260, 22, "Настройки быстрой сирены", bold_font[1])
				imgui.SetCursorPos(imgui.ImVec2(710, 0))
				if imgui.InvisibleButton(u8'##Закрыть окно настроек сирены', imgui.ImVec2(20, 20)) then
					save()
					imgui.CloseCurrentPopup()
				end
				if imgui.IsItemHovered() then
					gui.DrawCircle({720, 10}, 7, imgui.ImVec4(0.98, 0.30, 0.38, 1.00))
				else
					gui.DrawCircle({720, 10}, 7, imgui.ImVec4(0.98, 0.40, 0.38, 1.00))
				end
				gui.DrawLine({16, 50}, {714, 50}, cl.line)
				local current_key_text = (setting.police_settings.siren_key[1] ~= '' and setting.police_settings.siren_key[1] or 'Не назначена')
				gui.Text(26, 58, 'Клавиша активации: ' .. current_key_text, font[3])
				local key_text_edit = (setting.police_settings.siren_key[1] ~= '' and u8'Изменить...' or u8'Назначить...')
				if gui.Button(key_text_edit .. u8'##клавишу активации для сирены', {594, 55}, {110, 25}) then
					current_key = {'', {}}
					imgui.OpenPopup(u8'Изменить клавишу активации сирены')
					lockPlayerControl(true)
					edit_key = true
					key_bool_cur = setting.police_settings.siren_key[2]
				end
				gui.DrawLine({16, 88}, {714, 88}, cl.line)
				gui.Text(26, 96, 'РП отыгровка включения', font[3])
				local bool_set_on_rp = setting.police_settings.siren_on_rp
				setting.police_settings.siren_on_rp = gui.InputText({230, 100}, 474, setting.police_settings.siren_on_rp or '', u8'siren_on_rp', 230, u8'Введите текст отыгровки')
				if setting.police_settings.siren_on_rp ~= bool_set_on_rp then
					save()
				end
				gui.DrawLine({16, 124}, {714, 124}, cl.line)
				gui.Text(26, 132, 'РП отыгровка выключения', font[3])
				local bool_set_off_rp = setting.police_settings.siren_off_rp
				setting.police_settings.siren_off_rp = gui.InputText({230, 136}, 474, setting.police_settings.siren_off_rp or '', u8'siren_off_rp', 230, u8'Введите текст отыгровки')
				if setting.police_settings.siren_off_rp ~= bool_set_off_rp then
					save()
				end
				gui.DrawLine({16, 160}, {714, 160}, cl.line)
				if gui.Button(u8'Сохранить', {265, 166}, {200, 25}) then
					save()
					imgui.CloseCurrentPopup()
				end
				local bool_result = key_edit(u8'Изменить клавишу активации сирены', setting.police_settings.siren_key)
				if bool_result[1] then
					local old_key_to_remove = setting.police_settings.siren_key[2]
					if #old_key_to_remove > 0 then
						rkeys.unRegisterHotKey(old_key_to_remove)
						for i, key in ipairs(all_keys) do
							if compare_array_disable_order(key, old_key_to_remove) then
								table.remove(all_keys, i)
								break
							end
						end
					end
					setting.police_settings.siren_key = bool_result[2]
					if #setting.police_settings.siren_key[2] > 0 then
						rkeys.registerHotKey(setting.police_settings.siren_key[2], 3, true, function() on_hot_key(setting.police_settings.siren_key[2]) end)
						table.insert(all_keys, setting.police_settings.siren_key[2])
					end
					save()
				end
				imgui.EndChild()
				imgui.EndPopup()
			end
			
			new_draw(16 + 172, 53)
			gui.Text(26, 26 + 172, 'Расшифровка тен-кодов в чате.', font[3])
			imgui.SetCursorPos(imgui.ImVec2(561, 21 + 172))
			if gui.Switch(u8'##ten_code', setting.police_settings.ten_code) then
				setting.police_settings.ten_code = not setting.police_settings.ten_code
				save()
			end
			gui.TextInfo({26, 45 + 172}, {'Расшифровывает полицейские тен-коды (10-XX) в чате.'})
			
			new_draw(16 + 225, 53)
			gui.Text(26, 26 + 225, 'Заполнять бланк расследования', font[3])
			imgui.SetCursorPos(imgui.ImVec2(561, 21 + 225))
			if gui.Switch(u8'##auto_inves_toggle', setting.police_settings.auto_inves) then
				setting.police_settings.auto_inves = not setting.police_settings.auto_inves
				save()
			end
			gui.TextInfo({26, 45 + 225}, {'Заполняет данные в бланке расследования за вас (дата, время, оружие...)'})
			
			local pos_wanted = 225 + 53 + 19
			new_draw(16 + pos_wanted, 37)
			gui.Text(26, 26 + pos_wanted, 'Список разыскиваемых на Вашем экране', font[3])
			imgui.SetCursorPos(imgui.ImVec2(561, 21 + pos_wanted))
			if gui.Switch(u8'##wanted_list_func', setting.police_settings.wanted_list.func) then
				setting.police_settings.wanted_list.func = not setting.police_settings.wanted_list.func
				save()
			end
			
			pos_wanted = pos_wanted + 37 + 19
			if setting.police_settings.wanted_list.func then
				gui.Text(25, pos_wanted, 'Содержимое', bold_font[1])
				pos_wanted = pos_wanted + 25
				local content_box_height = 71
				new_draw(pos_wanted, content_box_height)
				gui.Text(26, pos_wanted + 9, 'Скрывать дистанцию до разыскиваемого', font[3])
				imgui.SetCursorPos(imgui.ImVec2(561, pos_wanted + 5))
				if gui.Switch(u8'##hide_distance', setting.police_settings.wanted_list.hide_distance) then
					setting.police_settings.wanted_list.hide_distance = not setting.police_settings.wanted_list.hide_distance
					save()
				end
				gui.DrawLine({16, pos_wanted + 35}, {602, pos_wanted + 35}, cl.line)
				gui.Text(26, pos_wanted + 45, 'Скрывать игроков в интерьере', font[3])
				imgui.SetCursorPos(imgui.ImVec2(561, pos_wanted + 40))
				if gui.Switch(u8'##interior', setting.police_settings.wanted_list.interior) then
					setting.police_settings.wanted_list.interior = not setting.police_settings.wanted_list.interior
					save()
				end
				pos_wanted = pos_wanted + content_box_height + 19
				gui.Text(25, pos_wanted, 'Визуальное отображение', bold_font[1])
				pos_wanted = pos_wanted + 25
				local visual_box_height = 330
				new_draw(pos_wanted, visual_box_height)
				gui.Text(26, pos_wanted + 9, 'Скрывать при открытом диалоге', font[3])
				imgui.SetCursorPos(imgui.ImVec2(561, pos_wanted + 5))
				if gui.Switch(u8'##wanted_dialog', setting.police_settings.wanted_list.dialog) then
					setting.police_settings.wanted_list.dialog = not setting.police_settings.wanted_list.dialog
					save()
				end
				gui.DrawLine({16, pos_wanted + 35}, {602, pos_wanted + 35}, cl.line)
				gui.Text(26, pos_wanted + 45, 'Инверсировать текст', font[3])
				imgui.SetCursorPos(imgui.ImVec2(561, pos_wanted + 40))
				if gui.Switch(u8'##wanted_invers', setting.police_settings.wanted_list.invers) then
					setting.police_settings.wanted_list.invers = not setting.police_settings.wanted_list.invers
					save()
				end
				gui.DrawLine({16, pos_wanted + 71}, {602, pos_wanted + 71}, cl.line)
				gui.Text(26, pos_wanted + 81, 'Флаг шрифта', font[3])
				local bool_set_flag = setting.police_settings.wanted_list.flag
				setting.police_settings.wanted_list.flag = gui.ListTableMove({572, pos_wanted + 81}, {u8'Без обводки', u8'Без обводки наклонённый', u8'Без обводки жирный наклонённый', u8'С обводкой', u8'С обводкой жирный', u8'С обводкой наклонённый', u8'С обводкой жирный наклонённый', u8'Без обводки с тенью', u8'Без обводки жирный с тенью', u8'Без обводки с тенью наклонённый', u8'Без обводки с тенью жирный наклонённый', u8'С обводкой и тенью', u8'С обводкой и тенью жирный'}, setting.police_settings.wanted_list.flag, 'Select Wanted Size')
				if setting.police_settings.wanted_list.flag ~= bool_set_flag then
					fontes_wanted = renderCreateFont('Trebuchet MS', setting.police_settings.wanted_list.size, setting.police_settings.wanted_list.flag)
					save()
				end
				gui.DrawLine({16, pos_wanted + 107}, {602, pos_wanted + 107}, cl.line)
				local wanted_set = {
					vis = imgui.new.float(setting.police_settings.wanted_list.vis),
					size = imgui.new.float(setting.police_settings.wanted_list.size),
					dist = imgui.new.float(setting.police_settings.wanted_list.dist)
				}
				gui.SliderCircle('SliderVisibleWanted',{54, pos_wanted + 130}, 70, 257, imgui.GetColorU32Vec4(imgui.ImVec4(0.90, 0.90, 0.90, 1.00)), 12, 50, 100, wanted_set.vis[0])
				gui.SliderCircle('SliderVisibleWanted2',{239, pos_wanted + 130}, 70, 257, imgui.GetColorU32Vec4(imgui.ImVec4(0.90, 0.90, 0.90, 1.00)), 12, 50, 50, wanted_set.size[0])
				gui.SliderCircle('SliderVisibleWanted3',{424, pos_wanted + 130}, 70, 257, imgui.GetColorU32Vec4(imgui.ImVec4(0.90, 0.90, 0.90, 1.00)), 12, 50, 50, wanted_set.dist[0])
				gui.Text(78, pos_wanted + 265, 'Прозрачность', font[3])
				local bool_set_vis = wanted_set.vis[0]
				wanted_set.vis[0] = gui.SliderBar('##wanted_vis', wanted_set.vis, 0, 100, 152, {51, pos_wanted + 290})
				if wanted_set.vis[0] ~= bool_set_vis then
					setting.police_settings.wanted_list.vis = floor(wanted_set.vis[0])
					save()
				end
				gui.Text(286, pos_wanted + 265, 'Размер', font[3])
				local bool_set_size = wanted_set.size[0]
				wanted_set.size[0] = gui.SliderBar('##wanted_size',wanted_set.size, 1, 50, 152, {236, pos_wanted + 290})
				if wanted_set.size[0] ~= bool_set_size then
					setting.police_settings.wanted_list.size = floor(wanted_set.size[0])
					fontes_wanted = renderCreateFont('Trebuchet MS', wanted_set.size[0], setting.police_settings.wanted_list.flag)
					save()
				end
				gui.Text(400, pos_wanted + 265, 'Расстояние между строками', font[3])
				local bool_set_dist = wanted_set.dist[0]
				wanted_set.dist[0] = gui.SliderBar('##wanted_dist', wanted_set.dist, 0, 50, 152, {421, pos_wanted + 290})
				if wanted_set.dist[0] ~= bool_set_dist then
					setting.police_settings.wanted_list.dist = floor(wanted_set.dist[0])
					save()
				end
				setting.police_settings.wanted_list.vis = wanted_set.vis[0]
				setting.police_settings.wanted_list.size = wanted_set.size[0]
				setting.police_settings.wanted_list.dist = wanted_set.dist[0]
				pos_wanted = pos_wanted + visual_box_height + 19
				gui.Text(25, pos_wanted, 'Цветовой стиль текста', bold_font[1])
				pos_wanted = pos_wanted + 25
				local color_box_height = 71
				new_draw(pos_wanted, color_box_height)
				gui.Text(26, pos_wanted + 9, 'Заголовок', font[3])
				gui.DrawLine({16, pos_wanted + 35}, {602, pos_wanted + 35}, cl.line)
				gui.Text(26, pos_wanted + 45, 'Игроки в розыске', font[3])
				imgui.PushStyleVarVec2(imgui.StyleVar.FramePadding, imgui.ImVec2(6.5, 6.5))
				imgui.SetCursorPos(imgui.ImVec2(564, pos_wanted + 4))
				if imgui.ColorEdit4('##wantedTitleColor', col_wanted.title, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoAlpha) then
					local c = imgui.ImVec4(col_wanted.title[0], col_wanted.title[1], col_wanted.title[2], col_wanted.title[3])
					setting.police_settings.wanted_list.color.title = imgui.ColorConvertFloat4ToARGB(c)
					save()
				end
				imgui.SetCursorPos(imgui.ImVec2(564, pos_wanted + 40))
				if imgui.ColorEdit4('##wantedDefColor', col_wanted.default, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoAlpha) then
					local c = imgui.ImVec4(col_wanted.default[0], col_wanted.default[1], col_wanted.default[2], col_wanted.default[3])
					setting.police_settings.wanted_list.color.default = imgui.ColorConvertFloat4ToARGB(c)
					save()
				end
				imgui.PopStyleVar()
				pos_wanted = pos_wanted + color_box_height + 19
				local position_box_height = 35
				new_draw(pos_wanted, position_box_height)
				gui.Text(26, pos_wanted + 9, 'Положение текста на экране', font[3])
				if gui.Button(u8'Изменить...', {491, pos_wanted + 5}, {99, 25}) then
					changeWantedPosition()
				end
				pos_wanted = pos_wanted + position_box_height
				imgui.Dummy(imgui.ImVec2(0, 21))
			end
		end
	elseif tab_settings == 7 then
		new_draw(16, 53)
		
		gui.Text(26, 26, 'Уведомлять звуковым сигналом о спавне авто', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 21))
		if gui.Switch(u8'##Уведомлять звуковым сигналом о спавне авто', setting.notice.car) then
			setting.notice.car = not setting.notice.car
			save()
		end
		gui.TextInfo({26, 45}, {'Когда администрация предупредит о спавне авто, Вы будете уведомлены звуковым сигналом.'})
		
		local size_y_dep = 53
		if setting.notice.dep then
			size_y_dep = 91
			if setting.dep.my_tag ~= '' then
				size_y_dep = 128
				if setting.dep.my_tag_en ~= '' then
					size_y_dep = 164
					if setting.dep.my_tag_en2 ~= '' then
						size_y_dep = 200
					end
				end
			end
		end
		new_draw(88, size_y_dep)
		gui.Text(26, 98, 'Уведомлять о вызове организации в рации департамента', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 93))
		if gui.Switch(u8'##Уведомлять о вызове организации', setting.notice.dep) then
			setting.notice.dep = not setting.notice.dep
			save()
		end
		gui.TextInfo({26, 117}, {'Когда в рации департамента обратятся к Вашей организации, Вы будете уведомлены звуком.'})

		local function clean_tag(tag)
			return tag:gsub("%%%-%%", "-")
		end

		local function encode_tag(tag)
			return tag:gsub("%-", "%%-%%")
		end

		if setting.notice.dep then
			gui.DrawLine({16, 143}, {602, 143}, cl.line)
			gui.Text(26, 153, 'Тег организации на который реагировать', font[3])

			local old_tag1 = setting.dep.my_tag
			local input_tag1 = gui.InputText({431, 155}, 150, clean_tag(setting.dep.my_tag), u8'Тег организации 1', 40, u8'Введите тег', 'ernh')
			if input_tag1 ~= clean_tag(old_tag1) then
				setting.dep.my_tag = encode_tag(input_tag1)
				save()
			end

			if setting.dep.my_tag ~= '' then 
				gui.DrawLine({16, 179}, {602, 179}, cl.line)
				gui.Text(26, 189, 'Дополнительный тег (не обязательно)', font[3])

				local old_tag2 = setting.dep.my_tag_en
				local input_tag2 = gui.InputText({431, 191}, 150, clean_tag(setting.dep.my_tag_en), u8'Тег организации 2', 40, u8'Введите тег', 'ernh')
				if input_tag2 ~= clean_tag(old_tag2) then
					setting.dep.my_tag_en = encode_tag(input_tag2)
					save()
				end

				if setting.dep.my_tag_en ~= '' then
					gui.DrawLine({16, 215}, {602, 215}, cl.line)
					gui.Text(26, 225, 'Второй дополнительный тег (не обязательно)', font[3])

					local old_tag3 = setting.dep.my_tag_en2
					local input_tag3 = gui.InputText({431, 227}, 150, clean_tag(setting.dep.my_tag_en2), u8'Тег организации 3', 40, u8'Введите тег', 'ernh')
					if input_tag3 ~= clean_tag(old_tag3) then
						setting.dep.my_tag_en2 = encode_tag(input_tag3)
						save()
					end

					if setting.dep.my_tag_en2 ~= '' then
						gui.DrawLine({16, 251}, {602, 251}, cl.line)
						gui.Text(26, 261, 'Третий дополнительный тег (не обязательно)', font[3])

						local old_tag4 = setting.dep.my_tag_en3
						local input_tag4 = gui.InputText({431, 263}, 150, clean_tag(setting.dep.my_tag_en3), u8'Тег организации 4', 40, u8'Введите тег', 'ernh')
						if input_tag4 ~= clean_tag(old_tag4) then
							setting.dep.my_tag_en3 = encode_tag(input_tag4)
							save()
						end
					end
				end
			end
		end
	elseif tab_settings == 8 then
		new_draw(16, 37)
		
		gui.Text(26, 26, 'Использовать акцент в разговоре', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 21))
		if gui.Switch(u8'##Акцент', setting.accent.func) then
			setting.accent.func = not setting.accent.func
			save()
		end
		
		if setting.accent.func then
			new_draw(72, 64)
			
			gui.Text(26, 82, 'Акцент персонажа', font[3])
			local bool_save_input = setting.accent.text
			setting.accent.text = gui.InputText({350, 84}, 231, setting.accent.text, u8'Акцент', 60, u8'Введите Ваш акцент', 'rus')
			if setting.accent.text ~= bool_save_input then
				save()
			end
			gui.TextInfo({26, 112}, {'Начните с заглавной буквы. Слово "акцент" писать не нужно. Например, "Британский"'})
			
			gui.Text(25, 155, 'Параметры', bold_font[1])
			new_draw(180, 143)
			gui.Text(26, 189, 'Акцент в рацию организации /r', font[3])
			imgui.SetCursorPos(imgui.ImVec2(561, 184))
			if gui.Switch(u8'##Акцент в рацию организации /r', setting.accent.r) then
				setting.accent.r = not setting.accent.r
				save()
			end
			gui.DrawLine({16, 215}, {602, 215}, cl.line)
			gui.Text(26, 225, 'Акцент во время крика /s', font[3])
			imgui.SetCursorPos(imgui.ImVec2(561, 220))
			if gui.Switch(u8'##Акцент во время крика /s', setting.accent.s) then
				setting.accent.s = not setting.accent.s
				save()
			end
			gui.DrawLine({16, 251}, {602, 251}, cl.line)
			gui.Text(26, 261, 'Акцент в рацию департамента /d', font[3])
			imgui.SetCursorPos(imgui.ImVec2(561, 256))
			if gui.Switch(u8'##Акцент в рацию департамента /d', setting.accent.d) then
				setting.accent.d = not setting.accent.d
				save()
				if setting.accent.d and not setting.dep_off then
					sampRegisterChatCommand('d', function(text_accents_d) 
						if text_accents_d ~= '' and setting.accent.func and setting.accent.d and setting.accent.text ~= '' then
							sampSendChat('/d [' .. u8:decode(setting.accent.text) .. ' акцент]: ' .. text_accents_d)
						else
							sampSendChat('/d ' .. text_accents_d)
						end 
					end)
				elseif not setting.accent.d and not setting.dep_off then
					sampUnregisterChatCommand('d')
				end
			end
			gui.DrawLine({16, 287}, {602, 287}, cl.line)
			gui.Text(26, 297, 'Акцент в чат банды/мафии /f', font[3])
			imgui.SetCursorPos(imgui.ImVec2(561, 292))
			if gui.Switch(u8'##Акцент в чат банды/мафии /f', setting.accent.f) then
				setting.accent.f = not setting.accent.f
				save()
			end
		end
	elseif tab_settings == 9 then
		new_draw(16, 361)
		
		gui.Text(26, 35, 'Автоматическое принятие документов', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 30))
		if gui.Switch(u8'##Автопринятие документов', setting.show_dialog_auto) then
			setting.show_dialog_auto = not setting.show_dialog_auto
			save()
		end
		gui.TextInfo({26, 54}, {'Вам больше не нужно будет вводить /offer, чтобы посмотреть паспорт, мед. карту, лицензии', 'или трудовую книжку, которую хочет предложит посмотреть Вам игрок.'})
		gui.DrawLine({16, 93}, {602, 93}, cl.line)
		gui.Text(26, 103, 'Отключить команду рации департамента', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 98))
		if gui.Switch(u8'##Отключить рацию депа', setting.dep_off) then
			setting.dep_off = not setting.dep_off
			save()
			if setting.dep_off then
				sampRegisterChatCommand('d', function()
					if not setting.cef_notif then
						sampAddChatMessage('[SH]{FFFFFF} Вы отключили команду /d в настройках.', 0xFF5345)
					else
						cefnotig('{FF5345}[SH]{FFFFFF} Вы отключили команду /d в настройках.', 3000)
					end
				end)
			else
				sampUnregisterChatCommand('d')
			end
		end
		gui.TextInfo({26, 122}, {'Если Вы очень часто по случайности отправляете информацию в рацию департамента,', 'то можете отключить команду /d. Тогда эта команда просто перестанет работать.'})
		gui.DrawLine({16, 161}, {602, 161}, cl.line)
		gui.Text(26, 171, 'Отображать под миникартой расстояние до серверной метки', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 166))
		if gui.Switch(u8'##Серверная метка', setting.display_map_distance.server) then
			setting.display_map_distance.server = not setting.display_map_distance.server
			save()
		end
		gui.DrawLine({16, 197}, {602, 197}, cl.line)
		gui.Text(26, 207, 'Отображать под миникартой расстояние до пользовательской метки', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 202))
		if gui.Switch(u8'##Пользовательская метка', setting.display_map_distance.user) then
			setting.display_map_distance.user = not setting.display_map_distance.user
			save()
		end
		gui.DrawLine({16, 233}, {602, 233}, cl.line)
		gui.Text(26, 243, 'Скриншот экрана + /time командой /ts', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 238))
		if gui.Switch(u8'##Команда ts', setting.ts) then
			setting.ts = not setting.ts
			if setting.ts then
				sampRegisterChatCommand('ts', print_scr_time)
			else
				sampUnregisterChatCommand('ts')
			end
			save()
		end
		gui.DrawLine({16, 269}, {602, 269}, cl.line)
		gui.Text(26, 279, 'Отображать дату и время под миникартой', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 274))
		if gui.Switch(u8'##Дата и время', setting.time_hud) then
			setting.time_hud = not setting.time_hud
			save()
		end
		gui.DrawLine({16, 305}, {602, 305}, cl.line)
		gui.Text(26, 315, 'Клавиша для остановки отыгровки - ' .. setting.act_key[2], font[3])
		if gui.Button(u8'Изменить...', {491, 311}, {99, 25}) then
			imgui.OpenPopup(u8'Изменить клавишу деактивации команды')
			lockPlayerControl(true)
			edit_key = true
			act_key = setting.act_key[1]
			current_key = {u8'Page Down', {34}}
		end
		gui.DrawLine({16, 341}, {602, 341}, cl.line)
		gui.Text(26, 351, 'Клавиша для продолжения отыгровки - ' .. setting.enter_key[2], font[3])
		if gui.Button(u8'Изменить...##клавишу продолжения', {491, 347}, {99, 25}) then
			imgui.OpenPopup(u8'Изменить клавишу продолжения команды')
			lockPlayerControl(true)
			edit_key = true
			enter_key = setting.enter_key[1]
			current_key = {u8'Enter', {13}}
		end
		
		new_draw(396, 53)
		gui.Text(26, 405, 'Изменить значение текущего времени', font[3])
		gui.TextInfo({26, 424}, {'Скрипт начнёт воспринимать текущее время с учётом Вашего изменения.'})
		
		local color_imVec4_button1, color_imVec4_button_text1 = cl.bg, cl.text
		if setting.time_offset >= 12 then
			color_imVec4_button1 = imgui.ImVec4(0.40, 0.40, 0.40, 0.50)
			color_imVec4_button_text1 = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
		else
			imgui.SetCursorPos(imgui.ImVec2(566, 410))
			if imgui.InvisibleButton(u8'##Прибавить значение к времени', imgui.ImVec2(26, 26)) then
				setting.time_offset = setting.time_offset + 1
				save()
			end
			
			if imgui.IsItemActive() then
				color_imVec4_button1 = cl.def
				color_imVec4_button_text1 = imgui.ImVec4(0.95, 0.95, 0.95, 1.00)
			end
		end
		gui.DrawCircle({578.5, 422.5}, 12.5, color_imVec4_button1)
		gui.FaText(572, 414, fa.PLUS, fa_font[3], color_imVec4_button_text1)
		
		local color_imVec4_button2, color_imVec4_button_text2 = cl.bg, cl.text
		if setting.time_offset <= -12 then
			color_imVec4_button2 = imgui.ImVec4(0.40, 0.40, 0.40, 0.50)
			color_imVec4_button_text2 = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
		else
			imgui.SetCursorPos(imgui.ImVec2(450, 410))
			if imgui.InvisibleButton(u8'##Убавить значение к времени', imgui.ImVec2(26, 26)) then
				setting.time_offset = setting.time_offset - 1
				save()
			end
			
			if imgui.IsItemActive() then
				color_imVec4_button2 = cl.def
				color_imVec4_button_text2 = imgui.ImVec4(0.95, 0.95, 0.95, 1.00)
			end
		end
		gui.DrawCircle({462.5, 422.5}, 12.5, color_imVec4_button2)
		gui.FaText(456, 414, fa.MINUS, fa_font[3], color_imVec4_button_text2)
		
		local format_time_text = ' час'
		if setting.time_offset >= -4 and setting.time_offset <= 4 and setting.time_offset ~= -1 and setting.time_offset ~= 1 then
			format_time_text = ' часа'
		elseif setting.time_offset ~= -1 and setting.time_offset ~= 1 then
			format_time_text = ' часов'
		end
		
		if setting.time_offset == 0 then
			gui.Text(492, 412, '0 часов', bold_font[1])
		elseif setting.time_offset > 0 then
			imgui.PushFont(bold_font[1])
			local text_format = '+' .. tostring(setting.time_offset) .. format_time_text
			local calc_size_text = imgui.CalcTextSize(u8(text_format))
			imgui.PopFont()
			gui.Text(521 - (calc_size_text.x / 2), 412, text_format, bold_font[1])
		else
			imgui.PushFont(bold_font[1])
			local text_format = tostring(setting.time_offset) .. format_time_text
			local calc_size_text = imgui.CalcTextSize(u8(text_format))
			imgui.PopFont()
			gui.Text(521 - (calc_size_text.x / 2), 412, text_format, bold_font[1])
		end
		
		if imgui.BeginPopupModal(u8'Изменить клавишу деактивации команды', null, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar) then
			imgui.SetCursorPos(imgui.ImVec2(10, 10))
			if imgui.InvisibleButton(u8'##Закрыть окно КДК', imgui.ImVec2(16, 16)) then
				lockPlayerControl(false)
				edit_key = false
				imgui.CloseCurrentPopup()
			end
			imgui.SetCursorPos(imgui.ImVec2(16, 16))
			local p = imgui.GetCursorScreenPos()
			if imgui.IsItemHovered() then
				imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x - 0.4, p.y - 0.2), 7, imgui.GetColorU32Vec4(imgui.ImVec4(0.98, 0.32, 0.38 ,1.00)), 60)
			else
				imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x - 0.4, p.y - 0.2), 7, imgui.GetColorU32Vec4(imgui.ImVec4(0.98, 0.42, 0.38 ,1.00)), 60)
			end
			imgui.SetCursorPos(imgui.ImVec2(10, 40))
			imgui.BeginChild(u8'Назначение клавиши активации КДК', imgui.ImVec2(390, 181), false, imgui.WindowFlags.NoScrollbar)
			
			imgui.PushFont(font[3])
			imgui.SetCursorPos(imgui.ImVec2(10, 0))
			imgui.Text(u8'Нажмите на необходимую клавишу для назначения')
			imgui.SetCursorPos(imgui.ImVec2(10, 25))
			imgui.Text(u8'Текущая клавиша:')
			imgui.SetCursorPos(imgui.ImVec2(135, 25))
			if #act_key == 0 then
				imgui.TextColored(imgui.ImVec4(0.90, 0.22, 0.22 ,1.00), u8'Отсутствует')
			else
				local all_key = {}
				for i = 1, #act_key do
					table.insert(all_key, vkeys.id_to_name(act_key[i]))
				end
				imgui.TextColored(imgui.ImVec4(0.90, 0.63, 0.22 ,1.00), table.concat(all_key, ' + '))
			end
			imgui.PopFont()
			gui.DrawLine({0, 50}, {381, 50}, cl.line)
			
			if imgui.IsMouseClicked(0) then
				lua_thread.create(function()
					wait(500)
					setVirtualKeyDown(3, true)
					wait(0)
					setVirtualKeyDown(3, false)
				end)
			end
			local currently_pressed_keys = rkeys.getKeys(true)
			local pr_key_num = {34}
			local pr_key_name = {u8'Page Down'}
			if #currently_pressed_keys ~= 0 then
				local stop_hot = false
				for i = 1, #currently_pressed_keys do
					local parts = {}
					for part in currently_pressed_keys[i]:gmatch('[^:]+') do
						table.insert(parts, part)
					end
					if currently_pressed_keys[i] ~= u8'1:ЛКМ' and currently_pressed_keys[i] ~= '145:Scrol Lock' 
					and currently_pressed_keys[i] ~= u8'2:ПКМ' then
						pr_key_num[1] = tonumber(parts[1])
						pr_key_name[1] = parts[2]
					else
						stop_hot = true
					end
				end
				if not stop_key_move and not stop_hot then
					if current_key == {u8'Page Down', {34}} then end
					current_key[1] = table.concat(pr_key_name, ' + ')
					
					current_key[2] = pr_key_num
					stop_key_move = true
					lua_thread.create(function()
						wait(250)
						stop_key_move = false
					end)
				end
			end
			if current_key[1] == nil then
				current_key[1] = u8''
			end
			if current_key[1] ~= u8'Такая комбинация уже существует' then
				imgui.PushFont(bold_font[3])
				local calc = imgui.CalcTextSize(current_key[1])
				imgui.SetCursorPos(imgui.ImVec2(195 - calc.x / 2, 80))
				if calc.x >= 385 then
					imgui.PopFont()
					imgui.PushFont(font[3])
					calc = imgui.CalcTextSize(current_key[1])
					imgui.SetCursorPos(imgui.ImVec2(195 - calc.x / 2, 90))
				end
				imgui.TextColored(imgui.ImVec4(0.08, 0.64, 0.11, 1.00), current_key[1])
				imgui.PopFont()
			else
				imgui.PushFont(font[3])
				local calc = imgui.CalcTextSize(current_key[1])
				imgui.SetCursorPos(imgui.ImVec2(195 - calc.x / 2, 90))
				imgui.TextColored(imgui.ImVec4(0.90, 0.22, 0.22, 1.00), current_key[1])
				imgui.PopFont()
			end
				
				
			if gui.Button(u8'Применить', {0, 144}, {185, 29}) then
				if not compare_array_disable_order(setting.act_key[1], current_key[2]) then
					local is_hot_key_done = false
					local num_hot_key_remove = 0
					
					if #all_keys ~= 0 and #current_key[2] ~= 0 then
						for i = 1, #all_keys do
							is_hot_key_done = compare_array_disable_order(all_keys[i], current_key[2])
							if is_hot_key_done then break end
						end
						for i = 1, #all_keys do
							if compare_array_disable_order(all_keys[i], setting.act_key[1]) then
								num_hot_key_remove = i
								break
							end
						end
					end
					if is_hot_key_done then current_key = {u8'Такая комбинация уже существует', {}} end
					if not is_hot_key_done then
						if num_hot_key_remove ~= 0 then
							table.remove(all_keys, num_hot_key_remove)
							rkeys.unRegisterHotKey(setting.act_key[1])
						end
						setting.act_key[1] = current_key[2]
						setting.act_key[2] = current_key[1]
						table.insert(all_keys, current_key[2])
						rkeys.registerHotKey(current_key[2], 3, true, function() on_hot_key(setting.act_key[1]) end)
						lockPlayerControl(false)
						edit_key = false
						imgui.CloseCurrentPopup()
						save()
					end
				else
					lockPlayerControl(false)
					edit_key = false
					imgui.CloseCurrentPopup()
				end
			end
			if gui.Button(u8'Очистить', {194, 144}, {186, 29}) then
				current_key = {u8'Page Down', {34}}
			end
				
			imgui.EndChild()
			imgui.EndPopup()
		end
			
		if imgui.BeginPopupModal(u8'Изменить клавишу продолжения команды', null, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar) then
			imgui.SetCursorPos(imgui.ImVec2(10, 10))
			if imgui.InvisibleButton(u8'##Закрыть окно КПК', imgui.ImVec2(16, 16)) then
				lockPlayerControl(false)
				edit_key = false
				imgui.CloseCurrentPopup()
			end
			imgui.SetCursorPos(imgui.ImVec2(16, 16))
			local p = imgui.GetCursorScreenPos()
			if imgui.IsItemHovered() then
				imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x - 0.4, p.y - 0.2), 7, imgui.GetColorU32Vec4(imgui.ImVec4(0.98, 0.32, 0.38 ,1.00)), 60)
			else
				imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x - 0.4, p.y - 0.2), 7, imgui.GetColorU32Vec4(imgui.ImVec4(0.98, 0.42, 0.38 ,1.00)), 60)
			end
			imgui.SetCursorPos(imgui.ImVec2(10, 40))
			imgui.BeginChild(u8'Назначение клавиши активации КПК', imgui.ImVec2(390, 181), false, imgui.WindowFlags.NoScrollbar)
			
			imgui.PushFont(font[3])
			imgui.SetCursorPos(imgui.ImVec2(10, 0))
			imgui.Text(u8'Нажмите на необходимую клавишу для назначения')
			imgui.SetCursorPos(imgui.ImVec2(10, 25))
			imgui.Text(u8'Текущая клавиша:')
			imgui.SetCursorPos(imgui.ImVec2(135, 25))
			if #enter_key == 0 then
				imgui.TextColored(imgui.ImVec4(0.90, 0.22, 0.22 ,1.00), u8'Отсутствует')
			else
				local all_key = {}
				for i = 1, #enter_key do
					table.insert(all_key, vkeys.id_to_name(enter_key[i]))
				end
				imgui.TextColored(imgui.ImVec4(0.90, 0.63, 0.22 ,1.00), table.concat(all_key, ' + '))
			end
			imgui.PopFont()
			gui.DrawLine({0, 50}, {381, 50}, cl.line)
			
			if imgui.IsMouseClicked(0) then
				lua_thread.create(function()
					wait(500)
					setVirtualKeyDown(3, true)
					wait(0)
					setVirtualKeyDown(3, false)
				end)
			end
			local currently_pressed_keys = rkeys.getKeys(true)
			local pr_key_num = {13}
			local pr_key_name = {u8'Enter'}
			if #currently_pressed_keys ~= 0 then
				local stop_hot = false
				for i = 1, #currently_pressed_keys do
					local parts = {}
					for part in currently_pressed_keys[i]:gmatch('[^:]+') do
						table.insert(parts, part)
					end
					if currently_pressed_keys[i] ~= u8'1:ЛКМ' and currently_pressed_keys[i] ~= '145:Scrol Lock' 
					and currently_pressed_keys[i] ~= u8'2:ПКМ' then
						pr_key_num[1] = tonumber(parts[1])
						pr_key_name[1] = parts[2]
					else
						stop_hot = true
					end
				end
				if not stop_key_move and not stop_hot then
					if current_key == {u8'Enter', {13}} then end
					current_key[1] = table.concat(pr_key_name, ' + ')
					
					current_key[2] = pr_key_num
					stop_key_move = true
					lua_thread.create(function()
						wait(250)
						stop_key_move = false
					end)
				end
			end
			if current_key[1] == nil then
				current_key[1] = u8''
			end
			if current_key[1] ~= u8'Такая комбинация уже существует' then
				imgui.PushFont(bold_font[3])
				local calc = imgui.CalcTextSize(current_key[1])
				imgui.SetCursorPos(imgui.ImVec2(195 - calc.x / 2, 80))
				if calc.x >= 385 then
					imgui.PopFont()
					imgui.PushFont(font[3])
					calc = imgui.CalcTextSize(current_key[1])
					imgui.SetCursorPos(imgui.ImVec2(195 - calc.x / 2, 90))
				end
				imgui.TextColored(imgui.ImVec4(0.08, 0.64, 0.11, 1.00), current_key[1])
				imgui.PopFont()
			else
				imgui.PushFont(font[3])
				local calc = imgui.CalcTextSize(current_key[1])
				imgui.SetCursorPos(imgui.ImVec2(195 - calc.x / 2, 90))
				imgui.TextColored(imgui.ImVec4(0.90, 0.22, 0.22, 1.00), current_key[1])
				imgui.PopFont()
			end
				
				
			if gui.Button(u8'Применить', {0, 144}, {185, 29}) then
				if not compare_array_disable_order(setting.enter_key[1], current_key[2]) then
					local is_hot_key_done = false
					local num_hot_key_remove = 0
					
					if #all_keys ~= 0 and #current_key[2] ~= 0 then
						for i = 1, #all_keys do
							is_hot_key_done = compare_array_disable_order(all_keys[i], current_key[2])
							if is_hot_key_done then break end
						end
						for i = 1, #all_keys do
							if compare_array_disable_order(all_keys[i], setting.enter_key[1]) then
								num_hot_key_remove = i
								break
							end
						end
					end
					if is_hot_key_done then current_key = {u8'Такая комбинация уже существует', {}} end
					if not is_hot_key_done then
						if num_hot_key_remove ~= 0 then
							table.remove(all_keys, num_hot_key_remove)
							rkeys.unRegisterHotKey(setting.enter_key[1])
						end
						setting.enter_key[1] = current_key[2]
						setting.enter_key[2] = current_key[1]
						table.insert(all_keys, current_key[2])
						rkeys.registerHotKey(current_key[2], 3, true, function() on_hot_key(setting.enter_key[1]) end)
						lockPlayerControl(false)
						edit_key = false
						imgui.CloseCurrentPopup()
						save()
					end
				else
					lockPlayerControl(false)
					edit_key = false
					imgui.CloseCurrentPopup()
				end
			end
			if gui.Button(u8'Очистить', {194, 144}, {186, 29}) then
				current_key = {u8'Enter', {13}}
			end
				
			imgui.EndChild()
			imgui.EndPopup()
		end
		
		local pos_y_dopf = 0
		if setting.kick_afk.func then
			pos_y_dopf = 72
			new_draw(468, 107)
		else
			new_draw(468, 35)
		end	
		gui.Text(26, 477, 'Автоматически кикать при привышение нормы АФК', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 472))
		if gui.Switch(u8'##Автокик АФК', setting.kick_afk.func) then
			setting.kick_afk.func = not setting.kick_afk.func
			save()
		end
		if setting.kick_afk.func then
			gui.DrawLine({16, 503}, {602, 503}, cl.line)
			gui.Text(26, 513, 'Введите значение в минутах', font[3])
			local bool_save_input_afk = setting.accent.text
			setting.kick_afk.time_kick = gui.InputText({417, 515}, 164, setting.kick_afk.time_kick, u8'АФК кик', 4, u8'Введите значение', 'num')
			if setting.kick_afk.time_kick ~= bool_save_input_afk then
				save()
			end
			gui.DrawLine({16, 539}, {602, 539}, cl.line)
			gui.Text(26, 549, 'Действие после привышения значения', font[3])
			local bool_set_act = setting.kick_afk.mode
			setting.kick_afk.mode = gui.ListTableMove({572, 549}, {u8'Полностью закрыть игру', u8'Закрыть соединение с сервером'}, setting.kick_afk.mode, 'Select action AFK')
			if setting.kick_afk.mode ~= bool_set_act then
				save() 
			end
			imgui.Dummy(imgui.ImVec2(0, 22))
		else
			imgui.Dummy(imgui.ImVec2(0, 25))
		end
	elseif tab_settings == 10 then
		local function accent_col(num_acc, color_acc, color_acc_act)
			imgui.SetCursorPos(imgui.ImVec2(278 + (num_acc * 43), 224))
			local p = imgui.GetCursorScreenPos()
			
			imgui.SetCursorPos(imgui.ImVec2(267 + (num_acc * 43), 214))
			if imgui.InvisibleButton(u8'##Выбор цвета' .. num_acc, imgui.ImVec2(22, 22)) then
				setting.color_def = color_acc
				setting.color_def_num = num_acc
				save()
				change_design(setting.cl, true)
			end
			if imgui.IsItemActive() then
				imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x, p.y + 0.5), 12, imgui.GetColorU32Vec4(imgui.ImVec4(color_acc_act[1], color_acc_act[2], color_acc_act[3] ,1.00)), 60)
			else
				imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x, p.y + 0.5),  12, imgui.GetColorU32Vec4(imgui.ImVec4(color_acc[1], color_acc[2], color_acc[3] ,1.00)), 60)
			end
			if num_acc == setting.color_def_num then
				imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x, p.y + 0.5), 4, imgui.GetColorU32Vec4(imgui.ImVec4(1.00, 1.00, 1.00 ,1.00)), 60)
			end
		end
		new_draw(16, 226)
		local min_x = 115
		local min_y = 129
		gui.Draw({148 - min_x, 162 - min_y}, {252, 132}, imgui.ImVec4(0.98, 0.98, 0.98, 1.00), 7, 15)
		gui.Draw({448 - min_x, 162 - min_y}, {252, 132}, imgui.ImVec4(0.10, 0.10, 0.10, 1.00), 7, 15)
		
		--> Дизайн окон выбора темы
		gui.Draw({148 - min_x, 162 - min_y}, {252, 20}, imgui.ImVec4(0.91, 0.89, 0.76, 1.00), 7, 3)
		gui.Draw({448 - min_x, 162 - min_y}, {252, 20}, imgui.ImVec4(0.13, 0.13, 0.13, 1.00), 7, 3)
		gui.Draw({148 - min_x, 274 - min_y}, {252, 20}, imgui.ImVec4(0.91, 0.89, 0.76, 1.00), 7, 12)
		gui.Draw({448 - min_x, 274 - min_y}, {252, 20}, imgui.ImVec4(0.13, 0.13, 0.13, 1.00), 7, 12)
		gui.Draw({181 - min_x, 279 - min_y}, {10, 10}, imgui.ImVec4(0.81, 0.79, 0.66, 1.00), 3, 15)
		gui.Draw({224 - min_x, 279 - min_y}, {10, 10}, imgui.ImVec4(0.81, 0.79, 0.66, 1.00), 3, 15)
		gui.Draw({267 - min_x, 279 - min_y}, {10, 10}, imgui.ImVec4(0.81, 0.79, 0.66, 1.00), 3, 15)
		gui.Draw({310 - min_x, 279 - min_y}, {10, 10}, imgui.ImVec4(0.81, 0.79, 0.66, 1.00), 3, 15)
		gui.Draw({353 - min_x, 279 - min_y}, {10, 10}, imgui.ImVec4(0.81, 0.79, 0.66, 1.00), 3, 15)
		gui.Draw({481 - min_x, 279 - min_y}, {10, 10}, imgui.ImVec4(0.20, 0.20, 0.20, 1.00), 3, 15)
		gui.Draw({524 - min_x, 279 - min_y}, {10, 10}, imgui.ImVec4(0.20, 0.20, 0.20, 1.00), 3, 15)
		gui.Draw({567 - min_x, 279 - min_y}, {10, 10}, imgui.ImVec4(0.20, 0.20, 0.20, 1.00), 3, 15)
		gui.Draw({610 - min_x, 279 - min_y}, {10, 10}, imgui.ImVec4(0.20, 0.20, 0.20, 1.00), 3, 15)
		gui.Draw({653 - min_x, 279 - min_y}, {10, 10}, imgui.ImVec4(0.20, 0.20, 0.20, 1.00), 3, 15)
		gui.Draw({244 - min_x, 167 - min_y}, {60, 10}, imgui.ImVec4(0.60, 0.60, 0.60, 0.30), 15, 15)
		gui.Draw({158 - min_x, 197 - min_y}, {200, 10}, imgui.ImVec4(0.60, 0.60, 0.60, 0.30), 15, 15)
		gui.Draw({158 - min_x, 222 - min_y}, {100, 10}, imgui.ImVec4(0.60, 0.60, 0.60, 0.30), 15, 15)
		gui.Draw({158 - min_x, 247 - min_y}, {150, 10}, imgui.ImVec4(0.60, 0.60, 0.60, 0.30), 15, 15)
		gui.Draw({544 - min_x, 167 - min_y}, {60, 10}, imgui.ImVec4(0.60, 0.60, 0.60, 0.30), 15, 15)
		gui.Draw({458 - min_x, 197 - min_y}, {200, 10}, imgui.ImVec4(0.40, 0.40, 0.40, 0.30), 15, 15)
		gui.Draw({458 - min_x, 222 - min_y}, {100, 10}, imgui.ImVec4(0.40, 0.40, 0.40, 0.30), 15, 15)
		gui.Draw({458 - min_x, 247 - min_y}, {150, 10}, imgui.ImVec4(0.40, 0.40, 0.40, 0.30), 15, 15)
		gui.DrawCircle({158 - min_x, 172 - min_y}, 4, imgui.ImVec4(0.98, 0.40, 0.38, 1.00))
		gui.DrawCircle({458 - min_x, 172 - min_y}, 4, imgui.ImVec4(0.98, 0.40, 0.38, 1.00))
		
		if setting.cl == 'White' then
			gui.DrawEmp({148 - min_x, 162 - min_y}, {252, 132}, cl.def, 7, 15, 3)
		else
			gui.DrawEmp({448 - min_x, 162 - min_y}, {252, 132}, cl.def, 7, 15, 3)
		end
		
		imgui.SetCursorPos(imgui.ImVec2(148 - min_x, 162 - min_y))
		if imgui.InvisibleButton(u8'##Выбрать светлую тему', imgui.ImVec2(252, 132)) then
			if setting.cl ~= 'White' then
				change_design('White')
				save()
			end
		end
		imgui.SetCursorPos(imgui.ImVec2(448 - min_x, 162 - min_y))
		if imgui.InvisibleButton(u8'##Выбрать тёмную тему', imgui.ImVec2(252, 132)) then
			if setting.cl ~= 'Black' then
				change_design('Black')
				save()
			end
		end
		
		gui.Text(204 - min_x, 306 - min_y, 'Светлое оформление', font[3])
		gui.Text(507 - min_x, 306 - min_y, 'Тёмное оформление', font[3])
		
		gui.DrawLine({16, 206}, {602, 206}, cl.line)
		gui.Text(26, 216, 'Цветовой акцент', font[3])
		accent_col(1, {0.26, 0.45, 0.94}, {0.26, 0.35, 0.94})
		accent_col(2, {0.75, 0.35, 0.87}, {0.75, 0.25, 0.87})
		accent_col(3, {1.00, 0.22, 0.37}, {1.00, 0.12, 0.37})
		accent_col(4, {1.00, 0.27, 0.23}, {1.00, 0.17, 0.23})
		accent_col(5, {1.00, 0.57, 0.04}, {1.00, 0.47, 0.04})
		accent_col(6, {0.20, 0.74, 0.29}, {0.20, 0.64, 0.29})
		accent_col(7, {0.50, 0.50, 0.52}, {0.40, 0.40, 0.42})

		new_draw(261, 35)
		gui.Text(26, 270, 'Прозрачность окна', font[3])
		local alpha_slider = imgui.new.float(setting.window_alpha)
		local new_alpha = gui.SliderBar('##Прозрачность окна', alpha_slider, 0.2, 1.0, 200, {380, 267})
		if new_alpha ~= setting.window_alpha then
			setting.window_alpha = round(new_alpha, 2)
			save()
		end

		new_draw(315, 35)
		gui.Text(26, 324, 'Заменять уведомления скрипта на оконные', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 319))
		if gui.Switch(u8'##Заменять уведомления на оконные', setting.cef_notif) then
			setting.cef_notif = not setting.cef_notif
			save()
		end
	elseif tab_settings == 11 then
		new_draw(16, 71)
		
		if setting.win_key[1] == '' then
			gui.Text(26, 25, 'Комбинация клавиш для открытия скрипта - Отсутствует', font[3])
			if gui.Button(u8'Назначить...##клавишу', {492, 21}, {99, 25}) then
				current_key = {'', {}}
				imgui.OpenPopup(u8'Изменить клавишу активации открытия скрипта')
				lockPlayerControl(true)
				edit_key = true
				win_key = setting.win_key[2]
			end
		else
			gui.Text(26, 25, 'Комбинация клавиш для открытия скрипта - ' .. setting.win_key[1], font[3])
			if gui.Button(u8'Изменить...##клавишу', {492, 21}, {99, 25}) then
				current_key = {'', {}}
				imgui.OpenPopup(u8'Изменить клавишу активации открытия скрипта')
				lockPlayerControl(true)
				edit_key = true
				win_key = setting.win_key[2]
			end
		end
		
		if imgui.BeginPopupModal(u8'Изменить клавишу активации открытия скрипта', null, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar) then
			imgui.SetCursorPos(imgui.ImVec2(10, 10))
			if imgui.InvisibleButton(u8'##Закрыть окно КАC', imgui.ImVec2(16, 16)) then
				lockPlayerControl(false)
				edit_key = false
				imgui.CloseCurrentPopup()
			end
			imgui.SetCursorPos(imgui.ImVec2(16, 16))
			local p = imgui.GetCursorScreenPos()
			if imgui.IsItemHovered() then
				imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x - 0.4, p.y - 0.2), 7, imgui.GetColorU32Vec4(imgui.ImVec4(0.98, 0.32, 0.38 ,1.00)), 60)
			else
				imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x - 0.4, p.y - 0.2), 7, imgui.GetColorU32Vec4(imgui.ImVec4(0.98, 0.42, 0.38 ,1.00)), 60)
			end
			imgui.SetCursorPos(imgui.ImVec2(10, 40))
			imgui.BeginChild(u8'Назначение клавиши активации КАC', imgui.ImVec2(390, 181), false, imgui.WindowFlags.NoScrollbar)
			
			imgui.PushFont(font[3])
			imgui.SetCursorPos(imgui.ImVec2(10, 0))
			imgui.Text(u8'Нажмите на необходимую клавишу или комбинацию')
			imgui.SetCursorPos(imgui.ImVec2(10, 25))
			imgui.Text(u8'Текущее сочетание:')
			imgui.SetCursorPos(imgui.ImVec2(145, 25))
			if #win_key == 0 then
				imgui.TextColored(imgui.ImVec4(0.90, 0.22, 0.22 ,1.00), u8'Отсутствует')
			else
				local all_key = {}
				for i = 1, #win_key do
					table.insert(all_key, vkeys.id_to_name(win_key[i]))
				end
				imgui.TextColored(imgui.ImVec4(0.90, 0.63, 0.22 ,1.00), table.concat(all_key, ' + '))
			end
			imgui.PopFont()
			gui.DrawLine({0, 50}, {381, 50}, cl.line)
			
			if imgui.IsMouseClicked(0) then
				lua_thread.create(function()
					wait(500)
					setVirtualKeyDown(3, true)
					wait(0)
					setVirtualKeyDown(3, false)
				end)
			end
			local currently_pressed_keys = rkeys.getKeys(true)
			local pr_key_num = {}
			local pr_key_name = {}
			if #currently_pressed_keys ~= 0 then
				local stop_hot = false
				for i = 1, #currently_pressed_keys do
					local parts = {}
					for part in currently_pressed_keys[i]:gmatch('[^:]+') do
						table.insert(parts, part)
					end
					if currently_pressed_keys[i] ~= u8'1:ЛКМ' and currently_pressed_keys[i] ~= '145:Scrol Lock' 
					and currently_pressed_keys[i] ~= u8'2:ПКМ' then
						table.insert(pr_key_num, tonumber(parts[1]))
						table.insert(pr_key_name, parts[2])
					else
						stop_hot = true
					end
				end
				if not stop_key_move and not stop_hot then
					current_key[1] = table.concat(pr_key_name, ' + ')
					
					current_key[2] = pr_key_num
					stop_key_move = true
					lua_thread.create(function()
						wait(250)
						stop_key_move = false
					end)
				end
			end
			if current_key[1] == nil then
				current_key[1] = u8''
			end
			if current_key[1] ~= u8'Такая комбинация уже существует' then
				imgui.PushFont(bold_font[3])
				local calc = imgui.CalcTextSize(current_key[1])
				imgui.SetCursorPos(imgui.ImVec2(195 - calc.x / 2, 80))
				if calc.x >= 385 then
					imgui.PopFont()
					imgui.PushFont(font[3])
					calc = imgui.CalcTextSize(current_key[1])
					imgui.SetCursorPos(imgui.ImVec2(195 - calc.x / 2, 90))
				end
				imgui.TextColored(imgui.ImVec4(0.08, 0.64, 0.11, 1.00), current_key[1])
				imgui.PopFont()
			else
				imgui.PushFont(font[3])
				local calc = imgui.CalcTextSize(current_key[1])
				imgui.SetCursorPos(imgui.ImVec2(195 - calc.x / 2, 90))
				imgui.TextColored(imgui.ImVec4(0.90, 0.22, 0.22, 1.00), current_key[1])
				imgui.PopFont()
			end
				
				
			if gui.Button(u8'Применить', {0, 144}, {185, 29}) then
				if not compare_array_disable_order(setting.win_key[2], current_key[2]) then
					local is_hot_key_done = false
					local num_hot_key_remove = 0
					local remove_sd = false
					
					if #current_key[2] == 0 and #setting.win_key[2] ~= 0 then
						remove_sd = true
						for i = 1, #all_keys do
							if compare_array_disable_order(all_keys[i], setting.win_key[2]) then
								num_hot_key_remove = i
								break
							end
						end
					else
						if #all_keys ~= 0 and #current_key[2] ~= 0 then
							for i = 1, #all_keys do
								is_hot_key_done = compare_array_disable_order(all_keys[i], current_key[2])
								if is_hot_key_done then break end
							end
							for i = 1, #all_keys do
								if compare_array_disable_order(all_keys[i], setting.win_key[2]) then
									num_hot_key_remove = i
									break
								end
							end
						end
					end
					if not remove_sd then
						if is_hot_key_done then current_key = {u8'Такая комбинация уже существует', {}} end
						if not is_hot_key_done then
							if num_hot_key_remove ~= 0 then
								table.remove(all_keys, num_hot_key_remove)
								rkeys.unRegisterHotKey(setting.win_key[2])
							end
							setting.win_key[2] = current_key[2]
							setting.win_key[1] = current_key[1]
							table.insert(all_keys, current_key[2])
							rkeys.registerHotKey(current_key[2], 3, true, function() on_hot_key(setting.win_key[2]) end)
							lockPlayerControl(false)
							edit_key = false
							imgui.CloseCurrentPopup()
							save()
						end
					else
						table.remove(all_keys, num_hot_key_remove)
						rkeys.unRegisterHotKey(setting.win_key[2])
						setting.win_key = {'', {}}
						lockPlayerControl(false)
						edit_key = false
						imgui.CloseCurrentPopup()
						save()
					end
				else
					lockPlayerControl(false)
					edit_key = false
					imgui.CloseCurrentPopup()
				end
			end
			if gui.Button(u8'Очистить', {194, 144}, {186, 29}) then
				current_key = {'', {}}
			end
				
			imgui.EndChild()
			imgui.EndPopup()
		end
			
		gui.DrawLine({16, 51}, {602, 51}, cl.line)
		if setting.cmd_open_win == '' then
			gui.Text(26, 61, 'Дополнительная команда для открытия скрипта - Отсутствует', font[3])
			if gui.Button(u8'Назначить...##команду', {492, 57}, {99, 25}) then
				lockPlayerControl(true)
				edit_cmd = true
				cur_cmd = setting.cmd_open_win
				new_cmd = setting.cmd_open_win
				imgui.OpenPopup(u8'Изменить команду для открытия скрипта')
			end
		else
			gui.Text(26, 61, 'Дополнительная команда для открытия скрипта - /' .. setting.cmd_open_win, font[3])
			if gui.Button(u8'Изменить...##команду', {492, 57}, {99, 25}) then
				lockPlayerControl(true)
				edit_cmd = true
				cur_cmd = setting.cmd_open_win
				new_cmd = setting.cmd_open_win
				imgui.OpenPopup(u8'Изменить команду для открытия скрипта')
			end
		end
		
		if edit_cmd then
			local cmd_end = cmd_edit(u8'Изменить команду для открытия скрипта', cur_cmd)
			if cmd_end ~= nil then
				if cmd_end ~= '' then
					setting.cmd_open_win = cmd_end
					sampRegisterChatCommand(cmd_end, function(arg)
						start_other_cmd(cmd_end, arg)
					end)
				else
					setting.cmd_open_win = ''
				end
				save()
			end
		end
		
		new_draw(106, 71)
		
		gui.Text(26, 115, 'Анимация движения окон', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 110))
		if gui.Switch(u8'##Анимация движения', setting.anim_win) then
			setting.anim_win = not setting.anim_win
			save()
		end
		gui.DrawLine({16, 141}, {602, 141}, cl.line)
		gui.Text(26, 151, 'Приветственное сообщение при запуске скрипта', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 146))
		if gui.Switch(u8'##Приветственное сообщение', setting.hi_mes) then
			setting.hi_mes = not setting.hi_mes
			save()
		end
		
		new_draw(196, 35)
		gui.Text(26, 205, 'Порядок расположения вкладок', font[3])
		if gui.Button(u8'Изменить...', {492, 201}, {99, 25}) then
			edit_order_tabs = true
		end
		
		new_draw(250, 35)
		gui.Text(26, 259, 'Отображать кнопку закрытия скрипта', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 254))
		if gui.Switch(u8'##Кнопка закрытия скрипта', setting.close_button) then
			setting.close_button = not setting.close_button
			save()
		end
		
		new_draw(304, 35)
		gui.Text(26, 313, 'Отображать лог ошибок в чате игры в случае сбоя скрипта', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 308))
		if gui.Switch(u8'##Отображать лог ошибок в чате после краша', setting.show_logs) then
			setting.show_logs = not setting.show_logs
			save()
		end

		if setting.debug_mode == nil then
			setting.debug_mode = false
		end
		new_draw(358, 53)
		gui.Text(26, 367, 'Расширенный debug-режим для Dialog / TextDraw / RPC', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 362))
		if gui.Switch(u8'##Расширенный debug-режим', setting.debug_mode) then
			setting.debug_mode = not setting.debug_mode
			save()
		end
		gui.TextInfo({26, 386}, {'Пишет подробные события в moonloader.log для поиска поломок после обновлений сервера.'})
		
	elseif tab_settings == 12 then
		new_draw(16, 37)
		
		gui.Text(26, 26, 'Автообновление', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 21))
		if gui.Switch(u8'##Автообновление', setting.auto_update) then
			setting.auto_update = not setting.auto_update
			save()
		end
		
		if new_version == '0' then
			if search_for_new_version > 600 then
				local function update_tail_rotation()
					tail_rotation_angle = (tail_rotation_angle + rotation_speed * anim) % 360
				end
				local function draw_tail(pos_upd_x, pos_upd_y)
					imgui.SetCursorPos(imgui.ImVec2(pos_upd_x, pos_upd_y))
					local p = imgui.GetCursorScreenPos()
					local circle_center_x, circle_center_y = p.x + 100, p.y + 100
					local circle_radius = 6
					local start_angle = math.rad(tail_rotation_angle)
					local end_angle = start_angle + math.rad(90)
					local draw_list = imgui.GetWindowDrawList()
					local segments = 32
					
					draw_list:AddCircle(imgui.ImVec2(circle_center_x, circle_center_y), circle_radius + 0.2, imgui.GetColorU32Vec4(imgui.ImVec4(0.40, 0.40, 0.40, 1.00)), 64, 3)
					
					for i = 0, segments do
						local t = i / segments
						local angle = start_angle + t * (end_angle - start_angle)
						local x = circle_center_x + math.cos(angle) * circle_radius
						local y = circle_center_y + math.sin(angle) * circle_radius
						if i > 0 then
							draw_list:AddLine(imgui.ImVec2(prev_x, prev_y), imgui.ImVec2(x, y), imgui.GetColorU32Vec4(cl.def), 2)
						end
						prev_x, prev_y = x, y
					end
				end

				update_tail_rotation()
				draw_tail(70, 110)
				gui.Text(185, 201, 'Проверка наличия обновления...', bold_font[1])
			
			else
				imgui.PushFont(bold_font[1])
				local calc_text_size = imgui.CalcTextSize('State Helper ' .. scr.version)
				imgui.PopFont()
				gui.Text(309 - (calc_text_size.x / 2), 192, 'State Helper ' .. scr.version, bold_font[1])
				imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.40, 0.40, 0.40, 1.00))
				gui.Text(252, 212, 'Версия актуальна', font[3])
				imgui.PopStyleColor(1)
			end
		else
			new_draw(72, 254)
			imgui.SetCursorPos(imgui.ImVec2(25, 81))
			imgui.Image(image_logo_update, imgui.ImVec2(47, 47))
			imgui.SetWindowFontScale(0.7)
			imgui.PushFont(bold_font[3])
			local calc_text_logo = imgui.CalcTextSize(update_info.version)
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1.00, 1.00, 1.00, 1.00))
			gui.Text(48.5 - (calc_text_logo.x / 2), 92, update_info.version, bold_font[3])
			imgui.PopStyleColor(1)
			imgui.PopFont()
			imgui.SetWindowFontScale(1.0)
			gui.Text(80, 87, 'State Helper ' .. update_info.version, font[3])
			gui.Text(80, 105, tostring(update_info.size) .. ' кб.', font[3])
			
			gui.DrawLine({16, 137}, {602, 137}, cl.line)
			imgui.SetCursorPos(imgui.ImVec2(16, 138))
			imgui.BeginChild(u8'Информация об обновлении', imgui.ImVec2(586, 188), false, imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollWithMouse)
			imgui.Scroller(u8'Информация об обновлении', img_step[1][0], img_duration[1][0], imgui.HoveredFlags.AllowWhenBlockedByActiveItem)
			local text_update = u8'Обновление содержит исправление ошибок, улучшение кода, а тажке несколько\nновых функций. \n\nНововведения в этой версии:\n1. Во вкладку Команды добавлен поиск команд.\n2. Во вкладке Команды теперь можно сравнивать аргументы или переменные по \nвеличине данных.\n3. Во вкладке Команды добавлен тег для получения игрового уровня игрока.\n4. Во вкладке Команды ветки условий теперь сортируются по блокам для удобства \nчтения.\n5. Добавлена функция автопереноса текста в игровом чате, если текст превышает \nдопустимую длину символов.\n6. Для сотрудников Больниц сервера Phoenix добавлена кастомная мед. карта.\n7. В функции Мемберс на экране теперь можно отключить отображение определён-\nных рангов.\n8. Исправлен баг, из-за которого при включённой функции Мемберс на экране авто-\nпринятие документов могло не сработать.\n9. Исправлен баг, из-за которого добавление некоторых действий в определённое \nместо в Командах добавляло их в конец, а не на нужное место.\n10. Исправлен баг, из-за которого функция сброса настроек скрипта не работала.\n11. Исправлен баг, из-за которого функция Автооткрытие вызовов у Пожарного Де-\nпартамента отправляла /fires во время активного вызова.\n12. Исправлен баг, из-за которого у сотрудников Автошколы выдача лицензии могла \nне происходить автоматически из-за включённого Мемберс на экране.'
			local pos_y_line = 10
			--update_info.text = text_update
			for line, newlines in update_info.text:gmatch('([^\n]*)(\n*)') do
				if line:find(u8'Нововведения в этой версии') then
					imgui.PushFont(font[3])
					local calc_text_new = imgui.CalcTextSize(line)
					gui.Text(10, pos_y_line, u8:decode(line), bold_font[1])
					imgui.PopFont()
					pos_y_line = pos_y_line + 24
				elseif line ~= '' then
					gui.Text(10, pos_y_line, u8:decode(line), font[3])
					pos_y_line = pos_y_line + 18
				end
				if #newlines > 0 then
					pos_y_line = pos_y_line + (#newlines - 1) * 24
				end
			end
			imgui.Dummy(imgui.ImVec2(0, 10))
			imgui.EndChild()
			if update_request >= 9 then
				gui.Button(u8'Обновление запрошено...', {16, 334}, {586, 27}, false)
			elseif update_request > 0 then
				gui.Button(u8'Произошла ошибка при попытке обновления, пытаемся восстановить...', {16, 334}, {586, 27}, false)
			else
				if gui.Button(u8'Установить', {16, 334}, {586, 27}) then
					update_request = 20
					update_download()
				end
			end
		end
	elseif tab_settings == 13 then
		imgui.PushFont(bold_font[3])
		local calc_text = imgui.CalcTextSize('State Helper ' .. scr.version)
		imgui.SetCursorPos(imgui.ImVec2(309 - (calc_text.x / 2), 365))
		gui.TextGradient('State Helper ' .. scr.version, 0.5, 1.00)
		local titles = {
			'',
			'',
			'',
			'Авторское право © 2023 - 2026 Марсель Афанасьев',
			'Все права сохранены.',
			'',
			'',
			'',
			'{FF6188}Создано:',
			'Alberto_Kane, Phoenix {A9DC76}(Автор идеи)',
			'',
			'',
			'',
			'{FF6188}Программисты:',
			'Alberto_Kane, Phoenix {A9DC76}(Fullstack-разработчик скрипта)',
			'Luke_Blather, Phoenix {A9DC76}(Backend-разработчик API-сервера)',
			'',
			'',
			'',
			'{FF6188}Программист | Архитектура и развитие проекта:',
			'Metsuki_Kagami, Winslow {A9DC76}(Seniour-App-Dev Рефакторинг по модулям)',
			'',
			'',
			'',
			'{FF6188}Остальная команда:',
			'Ilya_Kustov, Phoenix {A9DC76}(QA-инженер, поддержка скрипта и обработка предложений)',
			'Emma_Simmons, Phoenix {A9DC76}(QA-инженер, помощь в разработке функциональности)',
			'Oliver_Blain, Love {A9DC76}(QA-инженер стадии Бета)',
			'Richard_Forbes, Surprise {A9DC76}(Разработчик сайта, помощь в разработке функций)',
			'Robert_Poloskyn, Winslow {A9DC76}(QA-инженер стадии Бета, помощь в разработке функций)',
			'Maestro_Hennessy, Phoenix {A9DC76}(QA-инженер стадии Бета)',
			'Daniel_Heiliger, Love {A9DC76}(QA-инженер стадии Бета)',
			'Samuel_Hayakawa, Phoenix {A9DC76}(QA-инженер стадии Бета)',
			'Alfredo_Mason, Phoenix {A9DC76}(QA-инженер стадии Бета)',
			'Danny_Bronks, Mirage {A9DC76}(QA-инженер стадии Бета)',
			'Tetsuya_Midzuno, Faraway {A9DC76}(QA-инженер стадии Бета)',
			'Yan_Heiliger, Love {A9DC76}(QA-инженер стадии Бета)',
			'Brian_Petty, Tucson {A9DC76}(QA-инженер стадии Бета)',
			'Franklin_Perry, Bumble Bee {A9DC76}(QA-инженер стадии Бета)',
			'Victor_Bellucci, Tucson {A9DC76}(QA-инженер стадии Бета)',
			'Sover_Covanio, Phoenix {A9DC76}(QA-инженер стадии Бета)',
			'Saul_Goodmaan, Love {A9DC76}(QA-инженер стадии Бета)',
			'Aaron_Grella, Mesa {A9DC76}(QA-инженер стадии Бета)',
			'Virka_Vandalov, Wednesday {A9DC76}(QA-инженер стадии Бета)',
			'Akio_Hayasi, Tucson {A9DC76}(QA-тестировщик)',
			'Richard_Anderson, Phoenix {A9DC76}(QA-тестировщик, помощь в ранней стадии разработки)',
			'Samuel_Kloppo, Red-Rock {A9DC76}(Помощь в разработке функциональности)',
			'Kevin_Hatiko, Saint Rose {A9DC76}(Вдохновение на создание скрипта)',
			'',
			'',
			'',
			'Скрипт разработан для облегчения работы сотрудников государственных структур',
			'проекта Arizona RP с дополнительной функциональностью для обычных игроков.',
			'',
			'',
			'',
			'Копировать скрипт, его реализованные функции из кода, кастомные элементы',
			'дизайна, а также присваивать себе авторство скрипта категорически запрещено',
			'и может быть протестовано.',
			'',
			'',
			'',
			'{FF6188}State Helper',
			'Самый быстрый путь от Вашей задумки до её реализации.'			
		}
		
		pos_titles = 410
		for i = 1, #titles do
			imgui.PushFont(font[3])
			imgui.SetCursorPos(imgui.ImVec2(16, pos_titles))
			imgui.TextColoredRGB(titles[i])
			imgui.PopFont()
			
			pos_titles = pos_titles + 20
		end
		
		
		imgui.Dummy(imgui.ImVec2(0, 380))
		local max_scroll = imgui.GetScrollMaxY()
		imgui.SetScrollY(up_child_sub)
		if up_child_sub < max_scroll then
			up_child_sub = up_child_sub + (anim * 25)
		else
			up_child_sub = 0
		end
		imgui.PopFont()
	elseif tab_settings == 14 then --> Команды
		cmd_amd_key_tab(1)
	elseif tab_settings == 15 then --> Шпаргалки
		cmd_amd_key_tab(2)
	elseif tab_settings == 16 then --> Департамент
		cmd_amd_key_tab(3)
	elseif tab_settings == 17 then --> Собеседование
		local ret = cmd_amd_key_tab(4)
		
		if ret then
			new_draw(106, 53)
			gui.Text(26, 115, 'Передавать в аргумент команды id игрока', font[3])
			imgui.SetCursorPos(imgui.ImVec2(561, 110))
			if gui.Switch(u8'##Передавать в аргумент команды id игрока', setting.sob_id_arg) then
				setting.sob_id_arg = not setting.sob_id_arg
				save()
			end
			gui.TextInfo({26, 134}, {'Передав в аргумент id игрока, Вы сразу начнёте собеседование с этим игроком.'})
		end
	elseif tab_settings == 18 then --> Напоминания
		cmd_amd_key_tab(5)
	elseif tab_settings == 19 then --> Статистика
		cmd_amd_key_tab(6)
		new_draw(106, 35)
		gui.Text(26, 115, 'Отображать статистику онлайна на экране', font[3])
		imgui.SetCursorPos(imgui.ImVec2(561, 110))
		if gui.Switch(u8'##Стата онлайна на экране', setting.stat_on_screen.func) then
			setting.stat_on_screen.func = not setting.stat_on_screen.func
			save()
		end
		if setting.stat_on_screen.func then

			new_draw(160, 395)	--new_draw(160, 431)

			for ps = 0, 11 do
				gui.DrawLine({16, 195 + (ps * 36)}, {602, 195 + (ps * 36)}, cl.line)
			end
			
			gui.Text(26, 169, 'Отображать текущее время', font[3])
			imgui.SetCursorPos(imgui.ImVec2(561, 164))
			if gui.Switch(u8'##Текущее время в стате онлайна на экране', setting.stat_on_screen.current_time) then
				setting.stat_on_screen.current_time = not setting.stat_on_screen.current_time
				save()
			end
			gui.Text(26, 205, 'Отображать текущую дату', font[3])
			imgui.SetCursorPos(imgui.ImVec2(561, 200))
			if gui.Switch(u8'##Текущую дату в стате онлайна на экране', setting.stat_on_screen.current_date) then
				setting.stat_on_screen.current_date = not setting.stat_on_screen.current_date
				save()
			end
			gui.Text(26, 241, 'Показывать отыгранные часы за день без учёта АФК', font[3])
			imgui.SetCursorPos(imgui.ImVec2(561, 236))
			if gui.Switch(u8'##Показывать отыгранные часы за день в стате онлайна на экране', setting.stat_on_screen.day) then
				setting.stat_on_screen.day = not setting.stat_on_screen.day
				save()
			end
			gui.Text(26, 277, 'Показывать нахождение в АФК за день', font[3])
			imgui.SetCursorPos(imgui.ImVec2(561, 272))
			if gui.Switch(u8'##Показывать нахождение в афк за день в стате онлайна на экране', setting.stat_on_screen.afk) then
				setting.stat_on_screen.afk = not setting.stat_on_screen.afk
				save()
			end
			gui.Text(26, 313, 'Показывать общее время в игре за день', font[3])
			imgui.SetCursorPos(imgui.ImVec2(561, 308))
			if gui.Switch(u8'##Показывать общее время в игре за день в стате онлайна на экране', setting.stat_on_screen.all) then
				setting.stat_on_screen.all = not setting.stat_on_screen.all
				save()
			end
			gui.Text(26, 349, 'Показывать отыгранные часы за сессию без учёта АФК', font[3])
			imgui.SetCursorPos(imgui.ImVec2(561, 344))
			if gui.Switch(u8'##Показывать отыгранные часы за сессию в стате онлайна на экране', setting.stat_on_screen.ses_day) then
				setting.stat_on_screen.ses_day = not setting.stat_on_screen.ses_day
				save()
			end
			gui.Text(26, 385, 'Показывать нахождение в АФК за сессию', font[3])
			imgui.SetCursorPos(imgui.ImVec2(561, 380))
			if gui.Switch(u8'##Показывать нахождение в афк за сессию в стате онлайна на экране', setting.stat_on_screen.ses_afk) then
				setting.stat_on_screen.ses_afk = not setting.stat_on_screen.ses_afk
				save()
			end
			gui.Text(26, 421, 'Показывать общее время в игре за сессию', font[3])
			imgui.SetCursorPos(imgui.ImVec2(561, 416))
			if gui.Switch(u8'##Показывать общее время в игре за сессию в стате онлайна на экране', setting.stat_on_screen.ses_all) then
				setting.stat_on_screen.ses_all = not setting.stat_on_screen.ses_all
				save()
			end
			gui.Text(26, 457, 'Скрывать окно при открытых диалогах', font[3])
			imgui.SetCursorPos(imgui.ImVec2(561, 452))
			if gui.Switch(u8'##Скрывать окно при открытых диалогах в стате онлайна на экране', setting.stat_on_screen.dialog) then
				setting.stat_on_screen.dialog = not setting.stat_on_screen.dialog
				save()
			end
			gui.Text(26, 493, 'Прозрачность окна', font[3])
			local bool_visible = imgui.new.float(setting.stat_on_screen.visible)
			setting.stat_on_screen.visible = gui.SliderBar('##Прозрачность текста', bool_visible, 0, 100, 180, {415, 490})
			setting.stat_on_screen.visible = round(setting.stat_on_screen.visible, 0.1)
			gui.Text(26, 529, 'Позиция окна на экране', font[3])
			if gui.Button(u8'Изменить...', {492, 524}, {100, 27}) then
				ch_pos_on_stat()
			end
			--gui.Text(26, 565, 'Приостанавливать онлайн в заданное время', font[3])
			--imgui.SetCursorPos(imgui.ImVec2(561, 560))
			--if gui.Switch(u8'##Приостанавливать онлайн', setting.stat_on_screen.stop_timer) then
			--	setting.stat_on_screen.stop_timer = not setting.stat_on_screen.stop_timer
			--	save()
			--end
			imgui.Dummy(imgui.ImVec2(0, 21))
		end
	elseif tab_settings == 20 then --> Музыка
		cmd_amd_key_tab(7)
	elseif tab_settings == 21 then --> Рп зона
		cmd_amd_key_tab(8)
	elseif tab_settings == 22 then --> Действия
		cmd_amd_key_tab(9)
	end
	imgui.EndChild()
	
	if tab_settings == 4 and setting.fast.func then
        gui.DrawLine({226, 374}, {844, 374}, cl.line)
        gui.Draw({226, 375}, {618, 33}, cl.tab)
        if (not bool_edit_fast or (setting.smart_fast_menu and #setting.fast.one_win == 0 and #setting.fast.two_win == 0) or (not setting.smart_fast_menu and #setting.fast.one_win == 0 and #setting.fast.two_win == 0)) then
            if gui.Button(u8'Добавить действие', {461, 377}, {148, 29}) then
                if an[5][4] >= 180 then
                    an[5][1] = an[5][1] - 1
                end
            end
        elseif bool_edit_fast then
            if gui.Button(u8'Применить', {487, 377}, {96, 29}) then
                bool_edit_fast = false
            end
        end
        
        if (#setting.fast.one_win > 0 and num_win_fast == 1) or (#setting.fast.two_win > 0 and num_win_fast == 2) then
            imgui.SetCursorPos(imgui.ImVec2(814, 381))
            if imgui.InvisibleButton(u8'##Настройки быстрого доступа', imgui.ImVec2(22, 22)) then
                bool_edit_fast = not bool_edit_fast
            end
            imgui.PushFont(fa_font[4])
            imgui.SetCursorPos(imgui.ImVec2(816, 383))
            if imgui.IsItemActive() then
                imgui.TextColored(cl.def, fa.GEAR)
            else
                imgui.Text(fa.GEAR)
            end
            imgui.PopFont()
        else
            bool_edit_fast = false
        end
		if an[5][1] < 0 and an[5][1] > -165.2 then
			local bool_minus = 40 * anim
			an[5][1] = (an[5][1] - bool_minus) - (bool_minus * match_interpolation(0, 155, -an[5][1], 30))
		elseif an[5][1] <= -165.2 and an[5][1] > -165.3 then
			if num_win_fast == 1 then
				table.insert(setting.fast.one_win, {name = u8'Действие ' .. (#setting.fast.one_win + 1), cmd = '', send = true, id = true})
			else
				table.insert(setting.fast.two_win, {name = u8'Действие ' .. (#setting.fast.two_win + 1), cmd = '', send = true, id = true})
			end
			an[5][1] = -165.4
			an[5][3] = 0
			an[5][4] = 0
		else
			an[5][1] = 0
			an[5][2] = 420
			if an[5][3] < 1.00 then
				an[5][3] = an[5][3] + (2.9 * anim)
			else
				an[5][3] = 1.00
			end
			if an[5][4] < 180 then
				an[5][4] = an[5][4] + (1000 * anim)
				if an[5][4] > 180 then an[5][4] = 180 end
			else
				an[5][4] = 180
			end
		end
	end
	
	if edit_order_tabs then
		imgui.SetCursorPos(imgui.ImVec2(0, 34))
		imgui.BeginChild(u8'Блок для изменения расположения вкладок', imgui.ImVec2(848, 375), false, imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoScrollbar)
		
		gui.Draw({4, 4}, {840, 370}, imgui.ImVec4(0.50, 0.50, 0.50, 0.90), 0, 15)
		if gui.Button(u8'Применить##настройку вкладок', {377, 315}, {94, 27}) then
			edit_order_tabs = false
			save()
		end
		gui.Text(137, 350, 'Меняйте вкладки местами, так как Вам будет удобней, после чего нажмите применить.', font[3])
		
		imgui.EndChild()
	end
	
	gui.DrawLine({224, 38}, {224, 409}, cl.tab, 2)
	gui.DrawLine({225, 38}, {225, 409}, cl.line)
end


