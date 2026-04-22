--[[
Open with encoding: CP1251
StateHelper/features/stat/stat_core.lua
]]

function hall.stat()
	local color_ItemActive = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
	local color_ItemHovered = imgui.ImVec4(0.24, 0.24, 0.24, 1.00)
	if setting.cl == 'White' then
		color_ItemActive = imgui.ImVec4(0.78, 0.78, 0.78, 1.00)
		color_ItemHovered = imgui.ImVec4(0.83, 0.83, 0.83, 1.00)
	end
	
	local function format_time(seconds)
		local days = math.floor(seconds / 86400)
		local hours = math.floor((seconds % 86400) / 3600)
		local minutes = math.floor((seconds % 3600) / 60)
		local secs = seconds % 60

		if days > 0 then
			return string.format('%02d д. %02d ч. %02d мин. %02d сек.', days, hours, minutes, secs)
		else
			return string.format('%02d ч. %02d мин. %02d сек.', hours, minutes, secs)
		end
	end
	
	local function is_yesterday(date_string)
		local day, month, year = date_string:match('(%d%d)%.(%d%d)%.(%d%d)')
		
		if not (day and month and year) then
			error('Неправильный формат даты. Ожидается формат "DD.MM.YY".')
		end
		
		day, month, year = tonumber(day), tonumber(month), tonumber(year)
		
		year = year + 2000
		
		local current_time = os.time()
		local current_date = os.date("*t", current_time)
		local input_date_time = os.time({year = year, month = month, day = day, hour = 0})
		local yesterday_time = os.time({
			year = current_date.year,
			month = current_date.month,
			day = current_date.day - 1,
			hour = 0
		})
		
		return input_date_time == yesterday_time
	end
	
	imgui.SetCursorPos(imgui.ImVec2(4, 39))
	imgui.BeginChild(u8'Статистика онлайна', imgui.ImVec2(840, 369), false, imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollWithMouse)
	imgui.Scroller(u8'Статистика онлайна', img_step[1][0], img_duration[1][0], imgui.HoveredFlags.AllowWhenBlockedByActiveItem)
	
	gui.Draw({16, 16}, {808, 118}, cl.tab, 7, 15)
	gui.DrawLine({420, 66}, {420, 134}, cl.line)
	gui.Text(26, 26, tostring(setting.stat.date_week[1] .. ', сегодня'), bold_font[1])
	imgui.PushFont(bold_font[1])
	local calc_date = imgui.CalcTextSize(tostring(setting.stat.date_week[1]) .. u8', сегодня')
	imgui.PopFont()
	gui.Draw({24, 47}, {calc_date.x + 4, 5}, imgui.ImVec4(1.00, 0.58, 0.00, 1.00), 7, 15)
	gui.Text(26, 66, 'Чистый онлайн за день:', font[3])
	gui.Text(26, 86, 'АФК за день:', font[3])
	gui.Text(26, 106, 'Всего за день:', font[3])
	gui.Text(431, 66, 'Чистый онлайн за сессию:', font[3])
	gui.Text(431, 86, 'АФК за сессию:', font[3])
	gui.Text(431, 106, 'Всего за сессию:', font[3])
	
	imgui.PushFont(font[3])
	imgui.SetCursorPos(imgui.ImVec2(186, 66))
	imgui.TextColoredRGB('{279643}' .. format_time(setting.stat.cl[1]))
	imgui.SetCursorPos(imgui.ImVec2(116, 86))
	imgui.TextColoredRGB('{279643}' .. format_time(setting.stat.afk[1]))
	imgui.SetCursorPos(imgui.ImVec2(125, 106))
	imgui.TextColoredRGB('{279643}' .. format_time(setting.stat.day[1]))
	
	imgui.SetCursorPos(imgui.ImVec2(609, 66))
	imgui.TextColoredRGB('{279643}' .. format_time(stat_ses.cl))
	imgui.SetCursorPos(imgui.ImVec2(539, 86))
	imgui.TextColoredRGB('{279643}' .. format_time(stat_ses.afk))
	imgui.SetCursorPos(imgui.ImVec2(546, 106))
	imgui.TextColoredRGB('{279643}' .. format_time(stat_ses.all))
	imgui.PopFont()
	
	local y_pl = 0
	local online_week = setting.stat.cl[1]
	for i = 2, 10 do
		if setting.stat.date_week[i] ~= '' then
			local form_date = setting.stat.date_week[i]
			
			if is_yesterday(setting.stat.date_week[i]) then
				form_date = form_date .. u8', вчера'
			end
			imgui.PushFont(bold_font[1])
			local calc_dat = imgui.CalcTextSize(form_date)
			imgui.PopFont()
			gui.Draw({16, 142 + y_pl}, {808, 118}, cl.tab, 7, 15)
			gui.Draw({24, 173 + y_pl}, {calc_dat.x + 4, 5}, imgui.ImVec4(1.00, 0.58, 0.00, 1.00), 7, 15)
			gui.Text(26, 152 + y_pl, u8:decode(form_date), bold_font[1])
			gui.Text(26, 192 + y_pl, 'Чистый онлайн за день:', font[3])
			gui.Text(26, 212 + y_pl, 'АФК за день:', font[3])
			gui.Text(26, 232 + y_pl, 'Всего за день:', font[3])
			imgui.PushFont(font[3])
			imgui.SetCursorPos(imgui.ImVec2(186, 192 + y_pl))
			imgui.TextColoredRGB('{279643}' .. format_time(setting.stat.cl[i]))
			imgui.SetCursorPos(imgui.ImVec2(116, 212 + y_pl))
			imgui.TextColoredRGB('{279643}' .. format_time(setting.stat.afk[i]))
			imgui.SetCursorPos(imgui.ImVec2(125, 232 + y_pl))
			imgui.TextColoredRGB('{279643}' .. format_time(setting.stat.day[i]))
			imgui.PopFont()
			
			online_week = online_week + setting.stat.cl[i]
			y_pl = y_pl + 128
		end
	end
	gui.Draw({16, 142 + y_pl}, {808, 57}, cl.tab, 7, 15)
	gui.Text(26, 152 + y_pl, 'Чистый онлайн за 10 дней:', font[3])
	gui.Text(26, 172 + y_pl, 'Чистый онлайн за всё время:', font[3])
	imgui.PushFont(font[3])
	imgui.SetCursorPos(imgui.ImVec2(205, 152 + y_pl))
	imgui.TextColoredRGB('{279643}' .. format_time(online_week))
	imgui.SetCursorPos(imgui.ImVec2(223, 172 + y_pl))
	imgui.TextColoredRGB('{279643}' .. format_time(setting.stat.all))
	imgui.PopFont()
	
	imgui.Dummy(imgui.ImVec2(0, 23))

	imgui.EndChild()
end

