--[[
Open with encoding: CP1251
StateHelper/features/sob/sob_core.lua
]]

function hall.sob()
	local color_ItemActive = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
	local color_ItemHovered = imgui.ImVec4(0.24, 0.24, 0.24, 1.00)
	if setting.cl == 'White' then
		color_ItemActive = imgui.ImVec4(0.78, 0.78, 0.78, 1.00)
		color_ItemHovered = imgui.ImVec4(0.83, 0.83, 0.83, 1.00)
	end
	
	imgui.SetCursorPos(imgui.ImVec2(4, 39))
	imgui.BeginChild(u8'Собеседование', imgui.ImVec2(840, 369), false, imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollWithMouse)
	imgui.Scroller(u8'Собеседование', img_step[1][0], img_duration[1][0], imgui.HoveredFlags.AllowWhenBlockedByActiveItem)
	
if not edit_rp_q_sob and not edit_rp_fit_sob and not run_sob then
	gui.DrawBox({16, 16}, {808, 37}, cl.tab, cl.line, 7, 15)
	gui.Text(26, 26, 'Введите id игрока, чтобы начать собеседование', font[3])
	id_sobes, ret_bool = gui.InputText({520, 28}, 100, id_sobes, u8'id игрока собеседование', 4, u8'Введите id', 'num')

	if id_sobes ~= '' and (setting.sob.min_exp ~= '' or not setting.sob.auto_exp) and (setting.sob.min_law ~= '' or not setting.sob.auto_law)
	and (setting.sob.min_narko ~= '' or not setting.sob.auto_narko) then
		if gui.Button(u8'Начать собеседование', {643, 21}, {165, 27}) or ret_bool then
			if sampIsPlayerConnected(tonumber(id_sobes)) then
				run_sob = true
				sob_info = {
					exp = -1,
					law = -1,
					narko = -1,
					org = -1,
					med = -1,
					blacklist = -1,
					ticket = -1,
					bilet = -1,
					car = -1,
					moto = -1,
					gun = -1,
					warn = -1,
					bl_info = {},
					org_info = '',
					id = tonumber(id_sobes),
					nick = sampGetPlayerNickname(tonumber(id_sobes)),
					history = {}
				}
			else
				if not setting.cef_notif then
					sampAddChatMessage("[SH] {FFFFFF}Игрок с таким ID не найден, либо это Вы", 0xFF5345)
				else
					cefnotig("{FF5345}[SH] {FFFFFF}Игрок с таким ID не найден, либо это Вы", 3000)
				end
			end
		end
	else
		gui.Button(u8'Начать собеседование', {643, 21}, {165, 27}, false)
	end

		gui.Text(297, 67, 'Настройки меню собеседования', bold_font[1])
		gui.DrawBox({16, 92}, {808, 417}, cl.tab, cl.line, 7, 15)
		for i = 1, 11 do
			gui.DrawLine({16, 91 + (i * 38)}, {824, 91 + (i * 38)}, cl.line)
		end
		gui.Text(26, 102, 'Минимальный уровень игрока для вступления в организацию', font[3])
		local bool_save_input1 = setting.sob.min_exp
		setting.sob.min_exp = gui.InputText({673, 104}, 70, setting.sob.min_exp, u8'Мин exp игрока', 3, u8'Значение', 'num')
		if setting.name_rus ~= bool_save_input1 then save() end
		imgui.SetCursorPos(imgui.ImVec2(783, 98))
		if gui.Switch(u8'##Мин exp игрока функция', setting.sob.auto_exp) then
			setting.sob.auto_exp = not setting.sob.auto_exp
			save()
		end
		if setting.sob.min_exp == '' and setting.sob.auto_exp then
			gui.FaText(632, 100, fa.OCTAGON_EXCLAMATION, fa_font[5], imgui.ImVec4(1.00, 0.07, 0.00, 1.00))
		end
		gui.Text(26, 140, 'Минимальное значение законопослушности игрока для вступления в организацию', font[3])
		local bool_save_input2 = setting.sob.min_law
		setting.sob.min_law = gui.InputText({673, 142}, 70, setting.sob.min_law, u8'Мин law игрока', 3, u8'Значение', 'num')
		if setting.name_rus ~= bool_save_input2 then save() end
		imgui.SetCursorPos(imgui.ImVec2(783, 136))
		if gui.Switch(u8'##law игрока функция', setting.sob.auto_law) then
			setting.sob.auto_law = not setting.sob.auto_law
			save()
		end
		if setting.sob.min_law == '' and setting.sob.auto_law then
			gui.FaText(632, 138, fa.OCTAGON_EXCLAMATION, fa_font[5], imgui.ImVec4(1.00, 0.07, 0.00, 1.00))
		end
		gui.Text(26, 178, string.char(196, 238, 239, 243, 241, 242, 232, 236, 251, 233, 32, 243, 240, 238, 226, 229, 237, 252, 32, 243, 234, 240, 238, 239, 238, 231, 224, 226, 232, 241, 232, 236, 238, 241, 242, 232, 32, 232, 227, 240, 238, 234, 224, 32, 228, 235, 255, 32, 226, 241, 242, 243, 239, 235, 229, 237, 232, 255, 32, 226, 32, 238, 240, 227, 224, 237, 232, 231, 224, 246, 232, 254), font[3])
		local bool_save_input3 = setting.sob.min_narko
		setting.sob.min_narko = gui.InputText({673, 180}, 70, setting.sob.min_narko, u8(string.char(204, 232, 237, 32, 110, 97, 114, 107, 111, 32, 232, 227, 240, 238, 234, 224)), 4, u8(string.char(199, 237, 224, 247, 229, 237, 232, 229)), 'num')
		if setting.name_rus ~= bool_save_input3 then save() end
		imgui.SetCursorPos(imgui.ImVec2(783, 174))
		if gui.Switch(u8'##narko игрока функция', setting.sob.auto_narko) then
			setting.sob.auto_narko = not setting.sob.auto_narko
			save()
		end
		if setting.sob.min_narko == '' and setting.sob.auto_narko then
			gui.FaText(632, 176, fa.OCTAGON_EXCLAMATION, fa_font[5], imgui.ImVec4(1.00, 0.07, 0.00, 1.00))
		end
		gui.Text(26, 216, 'Автоматически проверять состоит ли игрок в организации', font[3])
		imgui.SetCursorPos(imgui.ImVec2(783, 212))
		if gui.Switch(u8'##org игрока функция', setting.sob.auto_org) then
			setting.sob.auto_org = not setting.sob.auto_org
			save()
		end
		gui.Text(26, 254, 'Автоматически проверять состояние здоровья в мед. карте игрока', font[3])
		imgui.SetCursorPos(imgui.ImVec2(783, 250))
		if gui.Switch(u8'##med игрока функция', setting.sob.auto_med) then
			setting.sob.auto_med = not setting.sob.auto_med
			save()
		end
		gui.Text(26, 292, 'Автоматически проверять состоит ли игрок в чёрном списке организации', font[3])
		imgui.SetCursorPos(imgui.ImVec2(783, 288))
		if gui.Switch(u8'##blacklist игрока функция', setting.sob.auto_blacklist) then
			setting.sob.auto_blacklist = not setting.sob.auto_blacklist
			save()
		end
		gui.Text(26, 330, 'Автоматически проверять наличие военного билета и повестки', font[3])
		imgui.SetCursorPos(imgui.ImVec2(783, 326))
		if gui.Switch(u8'##ticket игрока функция', setting.sob.auto_ticket) then
			setting.sob.auto_ticket = not setting.sob.auto_ticket
			save()
		end
		gui.Text(26, 368, 'Автоматически проверять наличие лицензии на авто', font[3])
		imgui.SetCursorPos(imgui.ImVec2(783, 364))
		if gui.Switch(u8'##car игрока функция', setting.sob.auto_car) then
			setting.sob.auto_car = not setting.sob.auto_car
			save()
		end
		gui.Text(26, 406, 'Автоматически проверять наличие лицензии на мото', font[3])
		imgui.SetCursorPos(imgui.ImVec2(783, 402))
		if gui.Switch(u8'##moto игрока функция', setting.sob_moto_lic) then
			setting.sob_moto_lic = not setting.sob_moto_lic
			save()
		end
		gui.Text(26, 444, 'Автоматически проверять наличие лицензии на оружие', font[3])
		imgui.SetCursorPos(imgui.ImVec2(783, 440))
		if gui.Switch(u8'##gun игрока функция', setting.sob.auto_gun) then
			setting.sob.auto_gun = not setting.sob.auto_gun
			save()
		end
		gui.Text(26, 482, 'Автоматически проверять состоит ли игрок в организации', font[3])
		imgui.SetCursorPos(imgui.ImVec2(783, 478))
		if gui.Switch(u8'##warn игрока функция', setting.sob.auto_warn) then
			setting.sob.auto_warn = not setting.sob.auto_warn
			save()
		end
		
		gui.Text(349, 523, 'Другие параметры', bold_font[1])

		gui.DrawBox({16, 548}, {808, 113 + 38}, cl.tab, cl.line, 7, 15)

		gui.DrawLine({16, 585}, {824, 585}, cl.line)
		gui.DrawLine({16, 623}, {824, 623}, cl.line)
		gui.DrawLine({16, 661}, {824, 661}, cl.line)

		gui.Text(26, 558, 'Отображать локальный чат', font[3])
		imgui.SetCursorPos(imgui.ImVec2(783, 554))
		if gui.Switch(u8'##chat игрока функция', setting.sob.chat) then
			setting.sob.chat = not setting.sob.chat
			save()
		end

		gui.Text(26, 596, 'Автоматически закрывать показанные документы игрока', font[3])
		imgui.SetCursorPos(imgui.ImVec2(783, 592))
		if gui.Switch(u8'##close doc игрока функция', setting.sob.close_doc) then
			setting.sob.close_doc = not setting.sob.close_doc
			save()
		end

		local disable_hide_doc = not setting.sob.close_doc
		if disable_hide_doc then
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
		end
		gui.Text(26, 634, 'Скрывать документы с экрана', font[3])
		imgui.SetCursorPos(imgui.ImVec2(783, 630))
		local r_hide_doc, b_hide_doc = gui.Switch(u8'##hide doc функция', setting.sob.hide_doc, disable_hide_doc)
		if r_hide_doc then
			if not disable_hide_doc then
				setting.sob.hide_doc = b_hide_doc
			else
				if setting.sob.hide_doc then
					setting.sob.hide_doc = false
				end
			end
			save()
		end
		if disable_hide_doc then
			imgui.PopStyleColor(1)
		end

		gui.Text(26, 672, 'Красить текст в цвет сообщения', font[3])
		imgui.SetCursorPos(imgui.ImVec2(783, 668))
		if gui.Switch(u8'##sob color', setting.sob.use_original_color) then
			setting.sob.use_original_color = not setting.sob.use_original_color
			save()
		end

		gui.Text(379, 713, 'Отыгровки', bold_font[1])
		gui.DrawBox({16, 738}, {808, 75}, cl.tab, cl.line, 7, 15)
		gui.DrawLine({16, 775}, {824, 775}, cl.line)

		gui.Text(26, 748, 'Отыгровки вопросов', font[3])
		if gui.Button(u8'Настроить...##1', {693, 743}, {115, 27}) then
			edit_rp_q_sob = true
			an[19] = {0, 0}
		end

		gui.Text(26, 786, 'Отыгровки при определении годности', font[3])
		if gui.Button(u8'Настроить...##2', {693, 781}, {115, 27}) then
			edit_rp_fit_sob = true
			an[19] = {0, 0}
		end
		
		imgui.Dummy(imgui.ImVec2(0, 22))
	elseif edit_rp_q_sob then
		gui.Text(346, 14, 'Перечень вопросов', bold_font[1])
		if #setting.sob.rp_q ~= 0 then
			local y_rp_q = 0
			for i = 1, #setting.sob.rp_q do
				gui.DrawBox({16, 39 + y_rp_q}, {808, 75 + (38 * #setting.sob.rp_q[i].rp)}, cl.tab, cl.line, 7, 15)
				gui.Text(26, 49 + y_rp_q, 'Имя вопроса', font[3])
				setting.sob.rp_q[i].name = gui.InputText({598, 51 + y_rp_q}, 200, setting.sob.rp_q[i].name, u8'Имя вопроса собес ' .. i, 100, u8'Текст')
				gui.DrawLine({16, 76 + y_rp_q}, {824, 76 + y_rp_q}, cl.line)
				
				if i <= 9 then
					gui.Text(5, 40 + y_rp_q, tostring(i), font[2])
				else
					gui.Text(2, 40 + y_rp_q, tostring(i), font[2])
				end
				
				if #setting.sob.rp_q[i].rp ~= 0 then
					for m = 1, #setting.sob.rp_q[i].rp do
						setting.sob.rp_q[i].rp[m] = gui.InputText({33, 89 + y_rp_q}, 734, setting.sob.rp_q[i].rp[m], u8'Отыгровка ' .. i .. m, 300, u8'Текст отыгровки')
						imgui.SetCursorPos(imgui.ImVec2(790, 84 + y_rp_q))
						if imgui.InvisibleButton(u8'##Удалить текст отыгровки ' .. i .. m, imgui.ImVec2(22, 23)) then
							table.remove(setting.sob.rp_q[i].rp, m)
							break
						end
						if imgui.IsItemActive() then
							gui.FaText(793, 87 + y_rp_q, fa.TRASH, fa_font[4], imgui.ImVec4(1.00, 0.07, 0.00, 1.00))
						else
							gui.FaText(793, 87 + y_rp_q, fa.TRASH, fa_font[4], cl.def)
						end
						gui.DrawLine({16, 114 + y_rp_q}, {824, 114 + y_rp_q}, cl.line)
						
						y_rp_q = y_rp_q + 38
					end
				end
				if gui.Button(u8'Добавить отыгровку##новую отыгровку' .. i, {255, 82 + y_rp_q}, {150, 27}) then
					table.insert(setting.sob.rp_q[i].rp, '')
				end
				if gui.Button(u8'Удалить вопрос##новую отыгровку' .. i, {435, 82 + y_rp_q}, {150, 27}) then
					table.remove(setting.sob.rp_q, i)
					break
				end
				
				y_rp_q = y_rp_q + 91
			end
		else
			if gui.Button(u8'Добавить вопрос##ff2s', {345, 185}, {150, 27}) then
				table.insert(setting.sob.rp_q, {name = '', rp = {''}})
			end
		end
		
		imgui.Dummy(imgui.ImVec2(0, 22))
		
		if bool_sob_rp_scroll then
			imgui.SetScrollY(imgui.GetScrollMaxY() + 200)
			bool_sob_rp_scroll = false
		end
	elseif edit_rp_fit_sob then
		gui.Text(239, 14, 'Перечень отыгровок при определении годности', bold_font[1])
		if #setting.sob.rp_fit ~= 0 then
			local y_rp_q = 0
			for i = 1, #setting.sob.rp_fit do
				gui.DrawBox({16, 39 + y_rp_q}, {808, 75 + (38 * #setting.sob.rp_fit[i].rp)}, cl.tab, cl.line, 7, 15)
				gui.Text(26, 49 + y_rp_q, 'Имя ответа', font[3])
				setting.sob.rp_fit[i].name = gui.InputText({598, 51 + y_rp_q}, 200, setting.sob.rp_fit[i].name, u8'Имя вопроса собес ' .. i, 100, u8'Текст')
				gui.DrawLine({16, 76 + y_rp_q}, {824, 76 + y_rp_q}, cl.line)
				
				if i <= 9 then
					gui.Text(5, 40 + y_rp_q, tostring(i), font[2])
				else
					gui.Text(2, 40 + y_rp_q, tostring(i), font[2])
				end
				
				if #setting.sob.rp_fit[i].rp ~= 0 then
					for m = 1, #setting.sob.rp_fit[i].rp do
						setting.sob.rp_fit[i].rp[m] = gui.InputText({33, 89 + y_rp_q}, 734, setting.sob.rp_fit[i].rp[m], u8'Отыгровка ' .. i .. m, 300, u8'Текст отыгровки')
						imgui.SetCursorPos(imgui.ImVec2(790, 84 + y_rp_q))
						if imgui.InvisibleButton(u8'##Удалить текст отыгровки ' .. i .. m, imgui.ImVec2(22, 23)) then
							table.remove(setting.sob.rp_fit[i].rp, m)
							break
						end
						if imgui.IsItemActive() then
							gui.FaText(793, 87 + y_rp_q, fa.TRASH, fa_font[4], imgui.ImVec4(1.00, 0.07, 0.00, 1.00))
						else
							gui.FaText(793, 87 + y_rp_q, fa.TRASH, fa_font[4], cl.def)
						end
						gui.DrawLine({16, 114 + y_rp_q}, {824, 114 + y_rp_q}, cl.line)
						
						y_rp_q = y_rp_q + 38
					end
				end
				if gui.Button(u8'Добавить отыгровку##новую отыгровку' .. i, {255, 82 + y_rp_q}, {150, 27}) then
					table.insert(setting.sob.rp_fit[i].rp, '')
				end
				if gui.Button(u8'Удалить ответ##новую отыгровку' .. i, {435, 82 + y_rp_q}, {150, 27}) then
					table.remove(setting.sob.rp_fit, i)
					break
				end
				
				y_rp_q = y_rp_q + 91
			end
		else
			if gui.Button(u8'Добавить ответ##ff2s', {345, 185}, {150, 27}) then
				table.insert(setting.sob.rp_fit, {name = '', rp = {''}})
			end
		end
		
		imgui.Dummy(imgui.ImVec2(0, 22))
		
		if bool_sob_rp_scroll then
			imgui.SetScrollY(imgui.GetScrollMaxY() + 200)
			bool_sob_rp_scroll = false
		end
	elseif run_sob then
		local ps_text = {{26, 56}, {296, 56}, {565, 56}, {26, 84}, {296, 84}, {565, 84}, {26, 112}, {296, 112}, {565, 112}, {26, 140}, {296, 140}, {565, 140}}
		local all_bool_cdf = {setting.sob.auto_exp, setting.sob.auto_law, setting.sob.auto_narko, setting.sob.auto_org, setting.sob.auto_med, setting.sob.auto_blacklist, setting.sob.auto_car, setting.sob_moto_lic, setting.sob.auto_gun, setting.sob.auto_warn, setting.sob.auto_ticket, setting.sob.auto_ticket}
		local all_bool_cdk = {'Уровень: ', 'Законопослушность: ', 'Наркозависимость: ', 'Мед карта: ', 'Здоровье: ', 'Чёрный список: ', 'Лиц. на авто: ', 'Лиц. на мото: ', 'Лиц. на оружие: ', 'Организация: ', 'Повестка: ', 'Военный билет: '}
		local all_param = {}
		local num_all_bool_cdf = 0
		local y_pos_all_cdf = 0
		for g = 1, 12 do
			if all_bool_cdf[g] then num_all_bool_cdf = num_all_bool_cdf + 1 end
		end
		
		if num_all_bool_cdf == 0 then
			gui.DrawBox({16, 16}, {808, 34}, cl.tab, cl.line, 7, 15)
		elseif num_all_bool_cdf <= 3 then
			gui.DrawBox({16, 16}, {808, 62}, cl.tab, cl.line, 7, 15)
			gui.DrawLine({16, 50}, {824, 50}, cl.line)
			gui.DrawLine({285, 50}, {285, 78}, cl.line)
			gui.DrawLine({554, 50}, {554, 78}, cl.line)
			y_pos_all_cdf = 28
		elseif num_all_bool_cdf <= 6 then
			gui.DrawBox({16, 16}, {808, 90}, cl.tab, cl.line, 7, 15)
			gui.DrawLine({16, 50}, {824, 50}, cl.line)
			gui.DrawLine({16, 78}, {824, 78}, cl.line)
			gui.DrawLine({285, 50}, {285, 106}, cl.line)
			gui.DrawLine({554, 50}, {554, 106}, cl.line)
			y_pos_all_cdf = 56
		elseif num_all_bool_cdf <= 9 then
			gui.DrawBox({16, 16}, {808, 118}, cl.tab, cl.line, 7, 15)
			gui.DrawLine({16, 50}, {824, 50}, cl.line)
			gui.DrawLine({16, 78}, {824, 78}, cl.line)
			gui.DrawLine({16, 106}, {824, 106}, cl.line)
			gui.DrawLine({285, 50}, {285, 134}, cl.line)
			gui.DrawLine({554, 50}, {554, 134}, cl.line)
			y_pos_all_cdf = 84
		elseif num_all_bool_cdf > 9 then
			gui.DrawBox({16, 16}, {808, 146}, cl.tab,cl.line, 7, 15)
			gui.DrawLine({16, 50}, {824, 50}, cl.line)
			gui.DrawLine({16, 78}, {824, 78}, cl.line)
			gui.DrawLine({16, 106}, {824, 106}, cl.line)
			gui.DrawLine({16, 134}, {824, 134}, cl.line)
			gui.DrawLine({285, 50}, {285, 162}, cl.line)
			gui.DrawLine({554, 50}, {554, 162}, cl.line)
			y_pos_all_cdf = 112
		end
		
		
		imgui.PushFont(bold_font[1])
		local sob_nick = imgui.CalcTextSize(sob_info.nick .. ' [' .. sob_info.id .. ']')
		imgui.PopFont()
		gui.Text(420 - sob_nick.x / 2, 23, sob_info.nick .. ' [' .. sob_info.id .. ']', bold_font[1])
		
		num_all_bool_cdf = 0
		for i = 1, 10 do
			if all_bool_cdf[i] then
				num_all_bool_cdf = num_all_bool_cdf + 1
				gui.Text(ps_text[num_all_bool_cdf][1], ps_text[num_all_bool_cdf][2], all_bool_cdk[i], font[3])
				imgui.PushFont(font[3])
				local calc_t = imgui.CalcTextSize(u8(all_bool_cdk[i]))
				local text_end_t = '{FF9500}Неизвестно'
				if all_bool_cdk[i] == 'Уровень: ' then
					if sob_info.exp == -2 then
						text_end_t = "{CF0000}Нету паспорта"
					else
						if tonumber(sob_info.exp) > -1 then
							if tonumber(sob_info.exp) >= tonumber(setting.sob.min_exp) then
								text_end_t = '{00A115}' .. tostring(sob_info.exp) .. '/' .. setting.sob.min_exp
							else
								text_end_t = '{CF0000}' .. tostring(sob_info.exp) .. '/' .. setting.sob.min_exp
							end
						end
					end
				elseif all_bool_cdk[i] == 'Законопослушность: ' then
					if sob_info.law == -2 then
						text_end_t = "{CF0000}Нету паспорта"
					else
						if tonumber(sob_info.law) > -1 then
							if tonumber(sob_info.law) >= tonumber(setting.sob.min_law) then
								text_end_t = '{00A115}' .. tostring(sob_info.law) .. '/' .. setting.sob.min_law
							else
								text_end_t = '{CF0000}' .. tostring(sob_info.law) .. '/' .. setting.sob.min_law
							end
						end
					end
				elseif all_bool_cdk[i] == 'Наркозависимость: ' then
					if tonumber(sob_info.narko) > -1 then
						if tonumber(sob_info.narko) >= tonumber(setting.sob.min_narko) then
							text_end_t = '{CF0000}' .. tostring(sob_info.narko) .. '/' .. setting.sob.min_narko
						else
							text_end_t = '{00A115}' .. tostring(sob_info.narko) .. '/' .. setting.sob.min_narko
						end
					end
				elseif all_bool_cdk[i] == 'Мед карта: ' then
					if sob_info.org > -1 then
						if sob_info.org == 1 then
							text_end_t = '{00A115}В порядке'
						elseif sob_info.org  == 2 then
							text_end_t = '{CF0000}Требуется обновить'
						elseif sob_info.org  == 3 then
							text_end_t = '{CF0000}Нету мед.карты'
						end
					end
				elseif all_bool_cdk[i] == 'Здоровье: ' then
					if sob_info.med > -1 then
						if sob_info.med == 1 then
							text_end_t = '{00A115}Полностью здоров'
						elseif sob_info.med == 2 then
							text_end_t = '{CF0000}Псих. отклонения'
						elseif sob_info.med == 3 then
							text_end_t = '{CF0000}Псих. нездоров'
						elseif sob_info.med == 4 then
							text_end_t = '{CF0000}Не определён'
						elseif sob_info.med == 5 then
							text_end_t = '{CF0000}Нету мед.карты'
						end
					end
				elseif all_bool_cdk[i] == 'Чёрный список: ' then
					if sob_info.blacklist > -1 then
						if sob_info.blacklist == 1 then
							text_end_t = '{00A115}Нигде не состоит'
						else
							text_end_t = '{CF0000}Состоит в ЧС'
						end
					end
				elseif all_bool_cdk[i] == 'Лиц. на авто: ' then
					if sob_info.car > -1 then
						if sob_info.car == 1 then
							text_end_t = '{00A115}Имеется'
						else
							text_end_t = '{CF0000}Отсутствует'
						end
					end
				elseif all_bool_cdk[i] == 'Лиц. на мото: ' then
					if sob_info.moto > -1 then
						if sob_info.moto == 1 then
							text_end_t = '{00A115}Имеется'
						else
							text_end_t = '{CF0000}Отсутствует'
						end
					end
				elseif all_bool_cdk[i] == 'Лиц. на оружие: ' then
					if sob_info.gun > -1 then
						if sob_info.gun == 1 then
							text_end_t = '{00A115}Имеется'
						else
							text_end_t = '{CF0000}Отсутствует'
						end
					end
				elseif all_bool_cdk[i] == 'Организация: ' then
					if sob_info.warn > -1 then
						if sob_info.warn == 1 then
							text_end_t = '{00A115}Отсутствует'
						else
							text_end_t = '{CF0000}Имеется'
						end
					end
				end
				imgui.SetCursorPos(imgui.ImVec2(ps_text[num_all_bool_cdf][1] + calc_t.x + 2, ps_text[num_all_bool_cdf][2]))
				imgui.TextColoredRGB(text_end_t)
				if text_end_t:find('Состоит в ЧС') then
					local calc_bl = imgui.CalcTextSize(u8'Состоит в ЧС')
					local blacklist_all = table.concat(sob_info.bl_info, '\n')
					imgui.SetCursorPos(imgui.ImVec2(ps_text[num_all_bool_cdf][1] + calc_t.x + 2 + calc_bl.x + 8, ps_text[num_all_bool_cdf][2]))
					imgui.PushFont(fa_font[2])
					imgui.PushStyleColor(imgui.Col.Text, cl.def)
					imgui.Text(fa.CIRCLE_QUESTION)
					imgui.PopStyleColor(1)
					imgui.PopFont()
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8'Список ЧС, в котором состоит:\n\n' .. u8(blacklist_all))
					end
				end
				imgui.PopFont()
			end
		end
		
		if all_bool_cdf[11] then
			num_all_bool_cdf = num_all_bool_cdf + 1
			gui.Text(ps_text[num_all_bool_cdf][1], ps_text[num_all_bool_cdf][2], all_bool_cdk[11], font[3])
			imgui.PushFont(font[3])
			local calc_t = imgui.CalcTextSize(u8(all_bool_cdk[11]))
			local text_end_t = '{FF9500}Неизвестно'
			if sob_info.ticket > -1 then
				if sob_info.ticket == 1 then
					text_end_t = '{CF0000}Имеется'
				else
					text_end_t = '{00A115}Отсутствует'
				end
			end
			imgui.SetCursorPos(imgui.ImVec2(ps_text[num_all_bool_cdf][1] + calc_t.x + 2, ps_text[num_all_bool_cdf][2]))
			imgui.TextColoredRGB(text_end_t)
			
			num_all_bool_cdf = num_all_bool_cdf + 1
			gui.Text(ps_text[num_all_bool_cdf][1], ps_text[num_all_bool_cdf][2], all_bool_cdk[12], font[3])
			
			calc_t = imgui.CalcTextSize(u8(all_bool_cdk[12]))
			text_end_t = '{FF9500}Неизвестно'
			if sob_info.bilet > -1 then
				if sob_info.bilet == 1 then
					text_end_t = '{CF0000}Отсутствует'
				else
					text_end_t = '{00A115}Имеется'
				end
			end
			imgui.SetCursorPos(imgui.ImVec2(ps_text[num_all_bool_cdf][1] + calc_t.x + 2, ps_text[num_all_bool_cdf][2]))
			imgui.TextColoredRGB(text_end_t)
			
			imgui.PopFont()
		end
		
		if setting.sob.chat then
			gui.DrawBox({16, 60 + y_pos_all_cdf}, {808, 266 - y_pos_all_cdf}, cl.tab, cl.line, 7, 15)
			text_sob_chat, ret_bool = gui.InputText({27, 300}, 677, text_sob_chat, u8'Текст для чата собеседования', 350, u8'Введите текст')
			if text_sob_chat ~= '' then
				if gui.Button(u8'Отправить', {724, 293}, {90, 27}) or ret_bool then
					sampSendChat(u8:decode(text_sob_chat))
					text_sob_chat = ''
				end
			else
				gui.Button(u8'Отправить', {724, 293}, {90, 27}, false)
			end
			
			imgui.SetCursorPos(imgui.ImVec2(16, 60 + y_pos_all_cdf))
			imgui.BeginChild(u8'Чат собеседования', imgui.ImVec2(808, 232 - y_pos_all_cdf), false, imgui.WindowFlags.NoScrollWithMouse)
			imgui.SetScrollY(imgui.GetScrollMaxY())
			
			if #sob_info.history > 30 then
				for i = 1, #sob_info.history - 20 do
					table.remove(sob_info.history, 1)
				end
			end
			if #sob_info.history ~= 0 then
				start_index = math.max(#sob_info.history - 19, 1)
				for i = start_index, #sob_info.history do
					imgui.PushFont(font[3])
					imgui.SetCursorPos(imgui.ImVec2(10, 10 + ((i - 1) * 20)))
					imgui.TextColoredRGB(sob_info.history[i])
					imgui.PopFont()
				end
			end
			imgui.Dummy(imgui.ImVec2(0, 8))
			imgui.EndChild()
		end
		
		if #setting.sob.rp_q ~= 0 then
			if gui.Button(u8'Задать вопрос', {16, 334}, {200, 27}) then
				imgui.OpenPopup(u8'Задать вопрос в хелпере')
			end
		else
			gui.Button(u8'Задать вопрос', {16, 334}, {200, 27}, false)
		end
		if #setting.sob.rp_fit ~= 0 then
			if gui.Button(u8'Определить годность', {320, 334}, {200, 27}) then
				sendJav("if(typeof window.cleanupCefHider === 'function') { window.cleanupCefHider(); }")
				isCefScript = false
				imgui.OpenPopup(u8'Определить годность в хелпере')
			end
		else
			gui.Button(u8'Определить годность', {320, 334}, {200, 27}, false)
		end
		if gui.Button(u8'Прекратить собеседование', {624, 334}, {200, 27}) then
			sendJav("if(typeof window.cleanupCefHider === 'function') { window.cleanupCefHider(); }")
			isCefScript = false
			run_sob = false
		end
		
		if imgui.BeginPopupModal(u8'Задать вопрос в хелпере', null, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar) then
			imgui.SetCursorPos(imgui.ImVec2(10, 10))
			if imgui.InvisibleButton(u8'##Закрыть окно с вопросами', imgui.ImVec2(16, 16)) then
				imgui.CloseCurrentPopup()
			end
			imgui.SetCursorPos(imgui.ImVec2(16, 16))
			local p = imgui.GetCursorScreenPos()
			if imgui.IsItemHovered() then
				imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x - 0.4, p.y - 0.2), 7, imgui.GetColorU32Vec4(imgui.ImVec4(0.98, 0.32, 0.38 ,1.00)), 60)
			else
				imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x - 0.4, p.y - 0.2), 7, imgui.GetColorU32Vec4(imgui.ImVec4(0.98, 0.42, 0.38 ,1.00)), 60)
			end
			gui.DrawLine({10, 31}, {296, 31}, cl.line)
			local y_size_child = 52
			if #setting.sob.rp_q < 9 and #setting.sob.rp_q > 1 then
				for i = 2, #setting.sob.rp_q do
					y_size_child = y_size_child + 35
				end
			elseif #setting.sob.rp_q == 1 then
				y_size_child = 52
			else
				y_size_child = 367
			end
			imgui.SetCursorPos(imgui.ImVec2(6, 40))
			imgui.BeginChild(u8'Задать вопрос в хелпере ', imgui.ImVec2(300, y_size_child), false)
			
			local pos_y_b = 0
			for i = 1, #setting.sob.rp_q do
				local text_name_sob = setting.sob.rp_q[i].name
				if setting.sob.rp_q[i].name == '' then
					text_name_sob = 'Без названия'
				end
				if gui.Button(text_name_sob .. '##rff4' .. i, {10, 8 + pos_y_b}, {274, 27}) then
					start_sob_cmd(setting.sob.rp_q[i].rp)
					imgui.CloseCurrentPopup()
				end
				pos_y_b = pos_y_b + 35
			end
			
			imgui.Dummy(imgui.ImVec2(0, 11))
			imgui.EndChild()
			imgui.EndPopup()
		end
		
		if imgui.BeginPopupModal(u8'Определить годность в хелпере', null, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar) then
			imgui.SetCursorPos(imgui.ImVec2(10, 10))
			if imgui.InvisibleButton(u8'##Закрыть окно с Определить годность', imgui.ImVec2(16, 16)) then
				imgui.CloseCurrentPopup()
			end
			imgui.SetCursorPos(imgui.ImVec2(16, 16))
			local p = imgui.GetCursorScreenPos()
			if imgui.IsItemHovered() then
				imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x - 0.4, p.y - 0.2), 7, imgui.GetColorU32Vec4(imgui.ImVec4(0.98, 0.32, 0.38 ,1.00)), 60)
			else
				imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x - 0.4, p.y - 0.2), 7, imgui.GetColorU32Vec4(imgui.ImVec4(0.98, 0.42, 0.38 ,1.00)), 60)
			end
			gui.DrawLine({10, 31}, {296, 31}, cl.line)
			local y_size_child = 52
			if #setting.sob.rp_fit < 9 and #setting.sob.rp_fit > 1 then
				for i = 2, #setting.sob.rp_fit do
					y_size_child = y_size_child + 35
				end
			elseif #setting.sob.rp_fit == 1 then
				y_size_child = 52
			else
				y_size_child = 367
			end
			imgui.SetCursorPos(imgui.ImVec2(6, 40))
			imgui.BeginChild(u8'Определить годность в хелпере ', imgui.ImVec2(300, y_size_child), false)
			
			local pos_y_b = 0
			for i = 1, #setting.sob.rp_fit do
				local text_name_sob = setting.sob.rp_fit[i].name
				if setting.sob.rp_fit[i].name == '' then
					text_name_sob = 'Без названия'
				end
				if gui.Button(text_name_sob .. '##rff4' .. i, {10, 8 + pos_y_b}, {274, 27}) then
					start_sob_cmd(setting.sob.rp_fit[i].rp)
					open_main()
					run_sob = false
					
					imgui.CloseCurrentPopup()
				end
				pos_y_b = pos_y_b + 35
			end
			
			imgui.Dummy(imgui.ImVec2(0, 11))
			imgui.EndChild()
			imgui.EndPopup()
		end
		
	end
	imgui.EndChild()
end

