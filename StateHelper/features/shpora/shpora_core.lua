--[[
Open with encoding: CP1251
StateHelper/features/shpora/shpora_core.lua
]]

function hall.shpora()
	local color_ItemActive = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
	local color_ItemHovered = imgui.ImVec4(0.24, 0.24, 0.24, 1.00)
	if setting.cl == 'White' then
		color_ItemActive = imgui.ImVec4(0.78, 0.78, 0.78, 1.00)
		color_ItemHovered = imgui.ImVec4(0.83, 0.83, 0.83, 1.00)
	end
	
	imgui.SetCursorPos(imgui.ImVec2(4, 39))
	imgui.BeginChild(u8'Шпаргалки', imgui.ImVec2(840, 369), false, imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollWithMouse)
	imgui.Scroller(u8'Шпаргалки', img_step[1][0], img_duration[1][0], imgui.HoveredFlags.AllowWhenBlockedByActiveItem)
	
	local function accent_col(num_acc, color_acc, color_acc_act)
		imgui.SetCursorPos(imgui.ImVec2(356 + (num_acc * 44), 115))
		local p = imgui.GetCursorScreenPos()
		
		imgui.SetCursorPos(imgui.ImVec2(345 + (num_acc * 44), 105))
		if imgui.InvisibleButton(u8'##Выбор цвета' .. num_acc, imgui.ImVec2(22, 22)) then
			shpora_bool.color = num_acc
		end
		if imgui.IsItemActive() then
			imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x, p.y + 0.5), 12, imgui.GetColorU32Vec4(imgui.ImVec4(color_acc_act[1], color_acc_act[2], color_acc_act[3] ,1.00)), 60)
		else
			imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x, p.y + 0.5),  12, imgui.GetColorU32Vec4(imgui.ImVec4(color_acc[1], color_acc[2], color_acc[3] ,1.00)), 60)
		end
		if num_acc == shpora_bool.color then
			imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x, p.y + 0.5), 4, imgui.GetColorU32Vec4(imgui.ImVec4(1.00, 1.00, 1.00 ,1.00)), 60)
		end
	end
		
	if edit_tab_shpora then
		gui.DrawBox({16, 16}, {396, 71}, cl.tab, cl.line, 7, 15)
		gui.DrawBox({428, 16}, {396, 71}, cl.tab, cl.line, 7, 15)
		gui.DrawLine({16, 51}, {412, 51}, cl.line)
		gui.DrawLine({428, 51}, {824, 51}, cl.line)
		
		gui.Text(26, 25, 'Имя шпаргалки', font[3])
		gui.Text(26, 61, 'Команда активации', font[3])
		shpora_bool.name = gui.InputText({191, 26}, 200, shpora_bool.name, u8'Название шпаргалки', 250, u8'Введите имя шпаргалки')
		shpora_bool.cmd = gui.InputText({191, 63}, 200, shpora_bool.cmd, u8'Установка команды шпоре', 30, u8'Введите команду', 'en')
		
		gui.Text(438, 61, 'Значок карточки', font[3])
		gui.FaText(565, 60, all_icon_shpora[shpora_bool.icon], fa_font[4])
		if gui.Button(u8'Выбрать...', {713, 57}, {100, 25}) then
			imgui.OpenPopup(u8'Установить значок карточки в шпорах')
		end
		
		if imgui.BeginPopupModal(u8'Установить значок карточки в шпорах', null, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar) then
			imgui.SetCursorPos(imgui.ImVec2(10, 10))
			if imgui.InvisibleButton(u8'##Закрыть окно установки значка', imgui.ImVec2(16, 16)) then
				imgui.CloseCurrentPopup()
			end
			imgui.SetCursorPos(imgui.ImVec2(16, 16))
			local p = imgui.GetCursorScreenPos()
			if imgui.IsItemHovered() then
				imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x - 0.4, p.y - 0.2), 7, imgui.GetColorU32Vec4(imgui.ImVec4(0.98, 0.32, 0.38 ,1.00)), 60)
			else
				imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x - 0.4, p.y - 0.2), 7, imgui.GetColorU32Vec4(imgui.ImVec4(0.98, 0.42, 0.38 ,1.00)), 60)
			end
			gui.DrawLine({10, 31}, {239, 31}, cl.line)
			imgui.SetCursorPos(imgui.ImVec2(6, 40))
			imgui.BeginChild(u8'Установка значка в шпорах', imgui.ImVec2(243, 340), false)
			local function auto_ordering_icon(pos_ic_y, table_ic, num_ic_n)
				local bool_proc_y = 0
				local bool_proc_x = 0
				local return_icon = 0
				for i = 1, #table_ic do
					imgui.SetCursorPos(imgui.ImVec2(5 + (bool_proc_x * 48), pos_ic_y - 4 + (45 * bool_proc_y)))
					if imgui.InvisibleButton(u8'##Выбрать значок ' .. pos_ic_y .. i, imgui.ImVec2(30, 30)) then
						return_icon = i + num_ic_n
					end
					if imgui.IsItemHovered() then
						gui.FaText(10 + (bool_proc_x * 48), pos_ic_y + (45 * bool_proc_y), table_ic[i], fa_font[4], cl.def)
					else
						gui.FaText(10 + (bool_proc_x * 48), pos_ic_y + (45 * bool_proc_y), table_ic[i], fa_font[4], imgui.ImVec4(0.60, 0.60, 0.60, 1.00))
					end
					if i % 5 == 0 then
						bool_proc_y = bool_proc_y + 1
						bool_proc_x = 0
					else
						bool_proc_x = bool_proc_x + 1
					end
				end
				
				if return_icon ~= 0 then
					shpora_bool.icon = return_icon
					imgui.CloseCurrentPopup()
				end
			end
			gui.Text(10, 5, 'Предметы', bold_font[1])
			auto_ordering_icon(40, {fa.HOUSE, fa.STAR, fa.USER, fa.MUSIC, fa.GIFT, fa.BOOK, fa.KEY, fa.GLOBE, fa.CODE, fa.COMPASS, fa.LAYER_GROUP, fa.USERS, fa.HEART, fa.CAR, fa.CALENDAR, fa.PLAY, fa.FLAG, fa.BRAIN, fa.ROBOT, fa.WRENCH, fa.INFO, fa.CLOCK, fa.FLOPPY_DISK, fa.CHART_SIMPLE, fa.SHOP, fa.LINK, fa.DATABASE, fa.TAGS, fa.POWER_OFF, fa.HAMMER, fa.SCROLL, fa.CLONE, fa.DICE}, 0)
			gui.Text(10, 355, 'Медицина', bold_font[1])
			auto_ordering_icon(390, {fa.USER_NURSE, fa.HOSPITAL, fa.WHEELCHAIR, fa.TRUCK_MEDICAL, fa.TEMPERATURE_LOW, fa.SYRINGE, fa.HEART_PULSE, fa.BOOK_MEDICAL, fa.BAN, fa.PLUS, fa.NOTES_MEDICAL}, 33)
			gui.Text(10, 525, 'Операционная система', bold_font[1])
			auto_ordering_icon(560, {fa.IMAGE, fa.FILE, fa.TRASH, fa.INBOX, fa.FOLDER, fa.FOLDER_OPEN, fa.COMMENTS, fa.SLIDERS, fa.WIFI, fa.VOLUME_HIGH, fa.UP_DOWN_LEFT_RIGHT, fa.TERMINAL, fa.SUPERSCRIPT}, 44)
			
			imgui.Dummy(imgui.ImVec2(0, 20))
			imgui.EndChild()
			imgui.EndPopup()
		end
		
		gui.DrawBox({16, 98}, {808, 35}, cl.tab, cl.line, 7, 15)
		gui.Text(26, 107, 'Цвет карточки', font[3])
		accent_col(0, {1.00, 0.62, 0.04}, {1.00, 0.52, 0.04})
		accent_col(1, {1.00, 0.26, 0.23}, {1.00, 0.16, 0.23})
		accent_col(2, {1.00, 0.82, 0.04}, {1.00, 0.72, 0.04})
		accent_col(3, {0.19, 0.80, 0.35}, {0.19, 0.70, 0.35})
		accent_col(4, {0.00, 0.80, 0.76}, {0.00, 0.70, 0.76})
		accent_col(5, {0.04, 0.49, 1.00}, {0.04, 0.39, 1.00})
		accent_col(6, {0.37, 0.35, 0.93}, {0.37, 0.25, 0.93})
		accent_col(7, {0.75, 0.33, 0.95}, {0.75, 0.23, 0.95})
		accent_col(8, {1.00, 0.20, 0.37}, {1.00, 0.10, 0.37})
		accent_col(9, {1.00, 0.55, 0.55}, {1.00, 0.45, 0.55})
		accent_col(10, {0.67, 0.55, 0.41}, {0.67, 0.45, 0.41})
		
		if shpora_bool.key[1] == '' then
			gui.Text(438, 24, 'Клавиша активации - Отсутствует', font[3])
		else
			gui.Text(438, 24, 'Клавиша активации - ' .. shpora_bool.key[1], font[3])
		end
		
		if gui.Button(u8'Назначить...', {713, 21}, {100, 25}) then
			imgui.OpenPopup(u8'Назначить клавишу активации в шпаргалках')
			current_key = {'', {}}
			lockPlayerControl(true)
			edit_key = true
			key_bool_cur = shpora_bool.key[2]
		end
		local bool_result = key_edit(u8'Назначить клавишу активации в шпаргалках', shpora_bool.key)
		if bool_result[1] then
			shpora_bool.key = bool_result[2]
		end
		
		gui.DrawBox({16, 144}, {808, 209}, cl.tab, cl.line, 7, 15)
		
		imgui.SetCursorPos(imgui.ImVec2(21, 149))
		local text_multiline = imgui.new.char[512000](shpora_bool.text or '')
		imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImVec4(0.50, 0.50, 0.50, 0.00))
		imgui.PushStyleVarVec2(imgui.StyleVar.FramePadding, imgui.ImVec2(5, 5))
		imgui.PushFont(font[3])
		imgui.InputTextMultiline('##Окно ввода текста шпаргалки', text_multiline, ffi.sizeof(text_multiline), imgui.ImVec2(803, 205))
		imgui.PopStyleColor()
		imgui.PopStyleVar(1)
		imgui.PopFont()
		shpora_bool.text = ffi.string(text_multiline)
		
		if ffi.string(text_multiline) == '' then
			imgui.PushFont(font[3])
			imgui.SetCursorPos(imgui.ImVec2(26, 154))
			if setting.cl == 'Black' then
				imgui.TextColored(imgui.ImVec4(1.00, 1.00, 1.00, 0.50), u8'Вводите текст')
			else
				imgui.TextColored(imgui.ImVec4(0.00, 0.00, 0.00, 0.50), u8'Вводите текст')
			end
			imgui.PopFont()
		end
	else
		if #setting.shp ~= 0 then
			local bool_shp_x = 0
			local bool_shp_y = 0
			local color_shp = {{1.00, 0.62, 0.04}, {1.00, 0.26, 0.23}, {1.00, 0.82, 0.04}, {0.19, 0.80, 0.35}, {0.00, 0.80, 0.76}, {0.04, 0.49, 1.00}, {0.37, 0.35, 0.93}, {0.75, 0.33, 0.95}, {1.00, 0.20, 0.37}, {1.00, 0.55, 0.55}, {0.67, 0.55, 0.41}}
			for i = 1, #setting.shp do
				if not shp_edit_all[1] then
					local x_sp = (204 * bool_shp_x)
					local y_sp = (108 * bool_shp_y)
					gui.Draw({16 + x_sp, 16 + y_sp}, {196, 100}, imgui.ImVec4(color_shp[setting.shp[i].color + 1][1], color_shp[setting.shp[i].color + 1][2], color_shp[setting.shp[i].color + 1][3], 1.00), 10, 15)
					imgui.SetCursorPos(imgui.ImVec2(16 + x_sp, 16 + y_sp))
					if imgui.InvisibleButton(u8'##Открыть для просмотра шпоры ' .. i, imgui.ImVec2(156, 100)) then
						show_shpora = i
						text_shpora = setting.shp[i].text
						windows.shpora[0] = true
					end
					if imgui.IsItemActive() then
						gui.Draw({16 + x_sp, 16 + y_sp}, {196, 100}, imgui.ImVec4(color_shp[setting.shp[i].color + 1][1], color_shp[setting.shp[i].color + 1][2] - 0.10, color_shp[setting.shp[i].color + 1][3], 1.00), 10, 15)
					end
					imgui.SetCursorPos(imgui.ImVec2(172 + x_sp, 56 + y_sp))
					if imgui.InvisibleButton(u8'##Открыть для просмотра шпоры 2' .. i, imgui.ImVec2(40, 60)) then
						show_shpora = i
						windows.shpora[0] = true
					end
					if imgui.IsItemActive() then
						gui.Draw({16 + x_sp, 16 + y_sp}, {196, 100}, imgui.ImVec4(color_shp[setting.shp[i].color + 1][1], color_shp[setting.shp[i].color + 1][2] - 0.10, color_shp[setting.shp[i].color + 1][3], 1.00), 10, 15)
					end
					gui.FaText(26 + x_sp, 26 + y_sp, all_icon_shpora[setting.shp[i].icon], fa_font[5], imgui.ImVec4(1.00, 1.00, 1.00, 1.00))
					imgui.SetCursorPos(imgui.ImVec2(16 + x_sp, 16 + y_sp))
					
					imgui.SetCursorPos(imgui.ImVec2(189 + x_sp, 39 + y_sp))
					local p = imgui.GetCursorScreenPos()
					imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x, p.y), 15, imgui.GetColorU32Vec4(imgui.ImVec4(color_shp[setting.shp[i].color + 1][1], color_shp[setting.shp[i].color + 1][2] + 0.10, color_shp[setting.shp[i].color + 1][3], 1.00)), 60)
					imgui.SetCursorPos(imgui.ImVec2(174 + x_sp, 24 + y_sp))
					if imgui.InvisibleButton(u8'##Открыть для редактирования шпоры ' .. i, imgui.ImVec2(30, 30)) then
						edit_tab_shpora = true
						shpora_bool = setting.shp[i]
						num_shpora = i
						cmd_memory_shpora = setting.shp[i].cmd
					end
					if imgui.IsItemActive() then
						imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x, p.y), 15, imgui.GetColorU32Vec4(imgui.ImVec4(color_shp[setting.shp[i].color + 1][1], color_shp[setting.shp[i].color + 1][2] + 0.20, color_shp[setting.shp[i].color + 1][3], 1.00)), 60)
					end
					gui.FaText(180 + x_sp, 28 + y_sp, fa.ELLIPSIS, fa_font[5], imgui.ImVec4(1.00, 1.00, 1.00, 1.00))
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1.00, 1.00, 1.00, 1.00))
					if setting.shp[i].name ~= '' then
						local wrapped_text, newline_count = wrapText(u8:decode(setting.shp[i].name), 21, 63)
						gui.Text(26 + x_sp, 91 + y_sp - (newline_count * 17), wrapped_text, bold_font[1])
					else
						gui.Text(26 + x_sp, 91 + y_sp, 'Без названия', bold_font[1])
					end
					imgui.PopStyleColor(1)
					imgui.Dummy(imgui.ImVec2(0, 19))
					
					if i % 4 == 0 then
						bool_shp_y = bool_shp_y + 1
						bool_shp_x = 0
					else
						bool_shp_x = bool_shp_x + 1
					end
				else
					local x_sp = (204 * bool_shp_x)
					local y_sp = (108 * bool_shp_y)
					local select_del = false
					for s = 1, #shp_edit_all[2] do
						if shp_edit_all[2][s] == i then
							select_del = true
							break
						end
					end
					
					if not select_del then
						gui.Draw({16 + x_sp, 16 + y_sp}, {196, 100}, imgui.ImVec4(0.40, 0.40, 0.40, 1.00), 10, 15)
					else
						gui.Draw({16 + x_sp, 16 + y_sp}, {196, 100}, cl.def, 10, 15)
					end
					imgui.SetCursorPos(imgui.ImVec2(16 + x_sp, 16 + y_sp))
					if imgui.InvisibleButton(u8'##Выбрать шпору для удаления ' .. i, imgui.ImVec2(196, 100)) then
						if select_del then
							for s = 1, #shp_edit_all[2] do
								if shp_edit_all[2][s] == i then
									table.remove(shp_edit_all[2], s)
									break
								end
							end
						else
							table.insert(shp_edit_all[2], i)
						end
					end
					gui.FaText(26 + x_sp, 26 + y_sp, all_icon_shpora[setting.shp[i].icon], fa_font[5], imgui.ImVec4(1.00, 1.00, 1.00, 1.00))
					imgui.SetCursorPos(imgui.ImVec2(16 + x_sp, 16 + y_sp))
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1.00, 1.00, 1.00, 1.00))
					if setting.shp[i].name ~= '' then
						local wrapped_text, newline_count = wrapText(u8:decode(setting.shp[i].name), 21, 63)
						gui.Text(26 + x_sp, 91 + y_sp - (newline_count * 17), wrapped_text, bold_font[1])
					else
						gui.Text(26 + x_sp, 91 + y_sp, 'Без названия', bold_font[1])
					end
					imgui.PopStyleColor(1)
					imgui.Dummy(imgui.ImVec2(0, 19))
					
					if i % 4 == 0 then
						bool_shp_y = bool_shp_y + 1
						bool_shp_x = 0
					else
						bool_shp_x = bool_shp_x + 1
					end
				end
			end
		else
			if setting.cl == 'White' then
				imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.40, 0.40, 0.40, 1.00))
			else
				imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50, 0.50, 0.50, 1.00))
			end
			gui.Text(375, 165, 'Пусто', bold_font[3])
			imgui.PopStyleColor(1)
		end
	end
	
	imgui.EndChild()
end

