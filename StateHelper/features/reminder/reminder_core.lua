--[[
Open with encoding: CP1251
StateHelper/features/reminder/reminder_core.lua
]]

function hall.reminder()
	local color_ItemActive = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
	local color_ItemHovered = imgui.ImVec4(0.24, 0.24, 0.24, 1.00)
	if setting.cl == 'White' then
		color_ItemActive = imgui.ImVec4(0.78, 0.78, 0.78, 1.00)
		color_ItemHovered = imgui.ImVec4(0.83, 0.83, 0.83, 1.00)
	end
	
	imgui.SetCursorPos(imgui.ImVec2(4, 39))
	imgui.BeginChild(u8'Напоминания', imgui.ImVec2(840, 369), false, imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollWithMouse)
	imgui.Scroller(u8'Напоминания', img_step[1][0], img_duration[1][0], imgui.HoveredFlags.AllowWhenBlockedByActiveItem)
	
	if new_reminder then
		gui.DrawBox({16, 16}, {808, 37}, cl.tab, cl.line, 7, 15)
		gui.Text(26, 26, 'Текст напоминания', font[3])
		new_rem.text = gui.InputText({169, 28}, 635, new_rem.text, u8'Текст напоминания', 400, u8'Введите текст')
		
		gui.DrawBox({16, 63}, {265, 296}, cl.tab, cl.line, 7, 15)
		gui.Text(32, 71, getMonthName(new_rem.mon) .. ' ' .. tostring(new_rem.year) .. ' г.', bold_font[1])
		gui.DrawLine({16, 99}, {281, 99}, cl.line)
		
		--local bool_date_td = get_today_date()
		local bool_week_td = getMonthInfo(new_rem.mon, new_rem.year)
		
		
		imgui.SetCursorPos(imgui.ImVec2(195, 66))
		if imgui.InvisibleButton(u8'##На месяц назад',  imgui.ImVec2(30, 30)) then
			new_rem.mon = new_rem.mon - 1
			new_rem.day = 1
			if new_rem.mon == 0 then
				new_rem.mon = 12
				new_rem.year = new_rem.year - 1
			end
		end
		if imgui.IsItemActive() then
			gui.FaText(204, 70, fa.ANGLE_LEFT, fa_font[5], imgui.ImVec4(0.83, 0.34, 0.34 ,1.00))
		else
			gui.FaText(204, 70, fa.ANGLE_LEFT, fa_font[5], imgui.ImVec4(0.83, 0.14, 0.14 ,1.00))
		end
		
		imgui.SetCursorPos(imgui.ImVec2(242, 66))
		if imgui.InvisibleButton(u8'##На месяц вперёд',  imgui.ImVec2(30, 30)) then
			new_rem.mon = new_rem.mon + 1
			new_rem.day = 1
			if new_rem.mon == 13 then
				new_rem.mon = 1
				new_rem.year = new_rem.year + 1
			end
		end
		if imgui.IsItemActive() then
			gui.FaText(252, 70, fa.ANGLE_RIGHT, fa_font[5], imgui.ImVec4(0.83, 0.34, 0.34 ,1.00))
		else
			gui.FaText(252, 70, fa.ANGLE_RIGHT, fa_font[5], imgui.ImVec4(0.83, 0.14, 0.14 ,1.00))
		end
		
		local bool_all_week = {u8'ПН', u8'ВТ', u8'СР', u8'ЧТ', u8'ПТ', u8'СБ', u8'ВС'}
		imgui.PushFont(font[3])
		for i = 1, 7 do
			imgui.PushFont(font[3])
			local week_calc = imgui.CalcTextSize(bool_all_week[i])
			imgui.PopFont()
			imgui.SetCursorPos(imgui.ImVec2(5 - (week_calc.x / 2) + (i * 36), 110))
			imgui.TextColored(imgui.ImVec4(0.30, 0.30, 0.30, 1.00), bool_all_week[i])
		end
		imgui.PopFont()
		
		
		local y_pos_pl = 4
		local week_bool = bool_week_td[1]
		for i = 1, bool_week_td[2] do
			imgui.PushFont(font[3])
			local num_calc = imgui.CalcTextSize(tostring(i))
			imgui.PopFont()
			local pos_x_num = math.floor(5 - (num_calc.x / 2) + (week_bool * 36))
			imgui.SetCursorPos(imgui.ImVec2(pos_x_num - 13 + (num_calc.x / 2), 147 - 13 + y_pos_pl))
			if imgui.InvisibleButton(u8'##Выбор числа месяца' .. i,  imgui.ImVec2(26, 26)) then
				new_rem.day = i
			end
			if imgui.IsItemHovered() then
				gui.DrawCircle({pos_x_num + (num_calc.x / 2), 147.5 + y_pos_pl}, 13.5, imgui.ImVec4(0.30, 0.30, 0.30 ,1.00))
			end
			if i == new_rem.day then
				gui.DrawCircle({pos_x_num + (num_calc.x / 2), 147.5 + y_pos_pl}, 13.5, imgui.ImVec4(0.83, 0.14, 0.14 ,1.00))
			end
			gui.Text(pos_x_num, 140 + y_pos_pl, tostring(i), font[3])
			
			if week_bool == 7 then
				y_pos_pl = y_pos_pl + 36
				week_bool = 1
			else
				week_bool = week_bool + 1
			end
		end
		
		gui.DrawBox({289, 63}, {99, 253}, cl.tab, cl.line, 7, 15)
		for i = 1, 7 do
			gui.Text(299, 42 + (i * 35), u8:decode(bool_all_week[i]), font[3])
			imgui.SetCursorPos(imgui.ImVec2(348, 37 + (i * 35)))
			if gui.Switch(u8'##Повтор week' .. i, new_rem.repeats[i]) then
				new_rem.repeats[i] = not new_rem.repeats[i]
			end
		end
		gui.DrawBox({289, 324}, {99, 35}, cl.tab, cl.line, 7, 15)
		gui.Text(299, 333, 'Звук', font[3])
		imgui.SetCursorPos(imgui.ImVec2(348, 328))
		if gui.Switch(u8'##Звуковой сигнал напоминания', new_rem.sound) then
			new_rem.sound = not new_rem.sound
		end
		
		if #tostring(new_rem.min) == 1 then
			new_rem.min = '0'..new_rem.min
		end
		if #tostring(new_rem.hour) == 1 then
			new_rem.hour = '0'..new_rem.hour
		end
		
		gui.Draw({500, 181}, {228, 60}, cl.tab, 7, 15)
		gui.Text(606, 173, ':', bold_font[2])
		gui.Text(480, 202, 'Ч', bold_font[1])
		gui.Text(737, 202, 'МИН', bold_font[1])
		
		--> ЧАСЫ
		imgui.SetCursorPos(imgui.ImVec2(520, 53))
		imgui.BeginChild(u8'Часы', imgui.ImVec2(90, 316), false, imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoScrollbar)
		local mouse_pos = imgui.GetMousePos() * 2
		if start_child[1] then
			start_child[1] = false
			imgui.SetScrollY(last_child_y[1])
		end
		if imgui.IsMouseDown(0) and child_clicked[1] then
			imgui.SetScrollY(last_child_y[1] + (last_mouse_pos[1] - mouse_pos.y))
		else
			last_mouse_pos[1] = mouse_pos.y
			last_child_y[1] = imgui.GetScrollY()
			if last_child_y[1] % 60 == 0 then
				new_rem.hour = last_child_y[1] / 60
			elseif last_child_y[1] % 60 >= 30 then
				last_child_y[1] = last_child_y[1] + 1
				imgui.SetScrollY(last_child_y[1])
			else
				last_child_y[1] = last_child_y[1] - 1
				imgui.SetScrollY(last_child_y[1])
			end
		end
		
		for i = 0, 23 do
			if i <= 9 then
				i = '0' .. tostring(i)
			end
			imgui.PushFont(bold_font[2])
			calc_num = imgui.CalcTextSize(tostring(i))
			imgui.PopFont()
			gui.Text(36 - (calc_num.x / 2), 125 + (i * 60), tostring(i), bold_font[2])
		end
		
		imgui.Dummy(imgui.ImVec2(0, 125))
		if setting.cl == 'Black' then
			gui.Draw({0, imgui.GetScrollY() - 72}, {90, 200}, imgui.ImVec4(0.10, 0.10, 0.10, 0.96))
			gui.Draw({0, imgui.GetScrollY() + 188}, {90, 200}, imgui.ImVec4(0.10, 0.10, 0.10, 0.96))
		else
			gui.Draw({0, imgui.GetScrollY() - 72}, {90, 200}, imgui.ImVec4(0.93, 0.93, 0.93, 0.90))
			gui.Draw({0, imgui.GetScrollY() + 188}, {90, 200}, imgui.ImVec4(0.93, 0.93, 0.93, 0.90))
		end
		imgui.EndChild()
		if imgui.IsItemClicked() then
			child_clicked[1] = true
		end
		
		--> МИНУТЫ
		imgui.SetCursorPos(imgui.ImVec2(640, 53))
		imgui.BeginChild(u8'Минуты', imgui.ImVec2(90, 316), false, imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoScrollbar)
		local mouse_pos = imgui.GetMousePos() * 2
		if start_child[2] then
			start_child[2] = false
			imgui.SetScrollY(last_child_y[2])
		end
		if imgui.IsMouseDown(0) and child_clicked[2] then
			imgui.SetScrollY(last_child_y[2] + (last_mouse_pos[2] - mouse_pos.y))
		else
			last_mouse_pos[2] = mouse_pos.y
			last_child_y[2] = imgui.GetScrollY()
			if last_child_y[2] % 60 == 0 then
				new_rem.min = last_child_y[2] / 60
			elseif last_child_y[2] % 60 >= 30 then
				last_child_y[2] = last_child_y[2] + 1
				imgui.SetScrollY(last_child_y[2])
			else
				last_child_y[2] = last_child_y[2] - 1
				imgui.SetScrollY(last_child_y[2])
			end
		end
		
		for i = 0, 59 do
			if i <= 9 then
				i = '0' .. tostring(i)
			end
			imgui.PushFont(bold_font[2])
			calc_num = imgui.CalcTextSize(tostring(i))
			imgui.PopFont()
			gui.Text(36 - (calc_num.x / 2), 125 + (i * 60), tostring(i), bold_font[2])
		end
		
		imgui.Dummy(imgui.ImVec2(0, 125))
		if setting.cl == 'Black' then
			gui.Draw({0, imgui.GetScrollY() - 72}, {90, 200}, imgui.ImVec4(0.10, 0.10, 0.10, 0.96))
			gui.Draw({0, imgui.GetScrollY() + 188}, {90, 200}, imgui.ImVec4(0.10, 0.10, 0.10, 0.96))
		else
			gui.Draw({0, imgui.GetScrollY() - 72}, {90, 200}, imgui.ImVec4(0.93, 0.93, 0.93, 0.90))
			gui.Draw({0, imgui.GetScrollY() + 188}, {90, 200}, imgui.ImVec4(0.93, 0.93, 0.93, 0.90))
		end
		imgui.EndChild()
		if imgui.IsItemClicked() then
			child_clicked[2] = true
		end
		
		if imgui.IsMouseReleased(0) then
			child_clicked = {false, false}
		end
	else
		if #setting.reminder == 0 then
			if setting.cl == 'White' then
				imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.40, 0.40, 0.40, 1.00))
			else
				imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50, 0.50, 0.50, 1.00))
			end
			gui.Text(375, 165, 'Пусто', bold_font[3])
			imgui.PopStyleColor(1)
		else
			local function format_date_time(day, month, year, hour, minute)
				day = tonumber(day)
				month = tonumber(month)
				year = tonumber(year)
				hour = tonumber(hour)
				minute = tonumber(minute)
				local months = {
					'Января', 'Февраля', 'Марта', 'Апреля', 'Мая', 'Июня',
					'Июля', 'Августа', 'Сентября', 'Октября', 'Ноября', 'Декабря'
				}
				
				return string.format('%d %s %d г. в %02d:%02d', day, months[month], year, hour, minute)
			end
			
			local function get_repeats(repeats)
				local daysOfWeek = {'ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'ВС'}
				local result = {}
				
				for i, isRepeat in ipairs(repeats) do
					if isRepeat then
						table.insert(result, daysOfWeek[i])
					end
				end
				
				if #result == 0 then
					return 'Без повторений'
				elseif #result == 7 then
					return 'Повтор каждый день'
				elseif #result == 5 and table.concat(result, ', ') == 'ПН, ВТ, СР, ЧТ, ПТ' then
					return 'Повтор в будние дни'
				else
					return 'Повтор в ' .. table.concat(result, ', ')
				end
			end
			
			for i = 1, #setting.reminder do
				local pos_y_pl = (i - 1) * 85
				local rep_rem = get_repeats(setting.reminder[i].repeats)
				local wrapped_text, newline_count = wrapText(u8:decode(setting.reminder[i].text), 95, 95)
				imgui.SetCursorPos(imgui.ImVec2(16, 16 + pos_y_pl))
				if imgui.InvisibleButton(u8'##Удалить напоминание' .. i, imgui.ImVec2(808, 75)) then
					imgui.OpenPopup(u8'Подтверждение удаления напоминания')
					del_rem = i
				end
				if setting.cl == 'Black' then
					if imgui.IsItemActive() then
						gui.Draw({16, 16 + pos_y_pl}, {808, 75}, imgui.ImVec4(0.12, 0.12, 0.12, 1.00), 7, 15)
					elseif imgui.IsItemHovered() then
						gui.Draw({16, 16 + pos_y_pl}, {808, 75}, imgui.ImVec4(0.15, 0.15, 0.15, 1.00), 7, 15)
					else
						gui.Draw({16, 16 + pos_y_pl}, {808, 75}, cl.tab, 7, 15)
					end
				else
					if imgui.IsItemActive() then
						gui.Draw({16, 16 + pos_y_pl}, {808, 75}, imgui.ImVec4(0.88, 0.86, 0.84, 1.00), 7, 15)
					elseif imgui.IsItemHovered() then
						gui.Draw({16, 16 + pos_y_pl}, {808, 75}, imgui.ImVec4(0.92, 0.90, 0.88, 1.00), 7, 15)
					else
						gui.Draw({16, 16 + pos_y_pl}, {808, 75}, cl.tab, 7, 15)
					end
				end
				gui.DrawLine({16, 53 + pos_y_pl}, {824, 53 + pos_y_pl}, cl.line)
				if setting.reminder[i].text ~= '' then
					gui.Text(26, 26 + pos_y_pl,wrapped_text, font[3])
				else
					gui.Text(26, 26 + pos_y_pl, 'Без названия', font[3])
				end
				gui.Draw({26, 63 + pos_y_pl}, {6, 19}, imgui.ImVec4(1.00, 0.58, 0.00, 1.00))
				gui.Text(40, 64 + pos_y_pl, format_date_time(setting.reminder[i].day, setting.reminder[i].mon, setting.reminder[i].year, setting.reminder[i].hour, setting.reminder[i].min), font[3])
				imgui.PushFont(font[3])
				local calc_rep = imgui.CalcTextSize(u8(rep_rem))
				imgui.PopFont()
				gui.Text(814 - calc_rep.x, 64 + pos_y_pl, rep_rem, font[3])
			end
			
			if imgui.BeginPopupModal(u8'Подтверждение удаления напоминания', null, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar) then
				imgui.SetCursorPos(imgui.ImVec2(10, 10))
				if imgui.InvisibleButton(u8'##Закрыть окно удаления напоминания', imgui.ImVec2(16, 16)) then
					imgui.CloseCurrentPopup()
				end
				imgui.SetCursorPos(imgui.ImVec2(16, 16))
				local p = imgui.GetCursorScreenPos()
				if imgui.IsItemHovered() then
					imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x - 0.4, p.y - 0.2), 7, imgui.GetColorU32Vec4(imgui.ImVec4(0.98, 0.32, 0.38 ,1.00)), 60)
				else
					imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x - 0.4, p.y - 0.2), 7, imgui.GetColorU32Vec4(imgui.ImVec4(0.98, 0.42, 0.38 ,1.00)), 60)
				end
				gui.DrawLine({10, 31}, {346, 31}, cl.line)
				imgui.SetCursorPos(imgui.ImVec2(6, 40))
				imgui.BeginChild(u8'Подтверждение удаления напоминания ', imgui.ImVec2(261, 90), false, imgui.WindowFlags.NoScrollbar)
				
				gui.Text(25, 5, 'Вы уверены, что хотите удалить \n				 напоминание?', font[3])
				if gui.Button(u8'Удалить', {24, 50}, {90, 27}) then
					table.remove(setting.reminder, del_rem)
					imgui.CloseCurrentPopup()
					save()
				end
				if gui.Button(u8'Отмена', {141, 50}, {90, 27}) then
					imgui.CloseCurrentPopup()
				end
				imgui.EndChild()
				imgui.EndPopup()
			end
			
			imgui.Dummy(imgui.ImVec2(0, 23))
		end
	end
	
	imgui.EndChild()
end


