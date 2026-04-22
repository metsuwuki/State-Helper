--[[
Open with encoding: CP1251
StateHelper/features/rp_zone/rp_zone_core.lua
]]

function hall.rp_zona()
	local color_ItemActive = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
	local color_ItemHovered = imgui.ImVec4(0.24, 0.24, 0.24, 1.00)
	if setting.cl == 'White' then
		color_ItemActive = imgui.ImVec4(0.78, 0.78, 0.78, 1.00)
		color_ItemHovered = imgui.ImVec4(0.83, 0.83, 0.83, 1.00)
	end
	imgui.SetCursorPos(imgui.ImVec2(4, 39))
	imgui.BeginChild(u8'РП зона', imgui.ImVec2(840, 369), false, imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollWithMouse)
	imgui.Scroller(u8'РП зона', img_step[1][0], img_duration[1][0], imgui.HoveredFlags.AllowWhenBlockedByActiveItem)
	if #setting.scene == 0 and not new_scene then
		if setting.cl == 'White' then
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.40, 0.40, 0.40, 0.50))
		else
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
		end
		gui.Text(104, 166, 'Здесь Вы можете создать скриншот ситуацию (СС) для Вашего отчёта, без сторонних программ.', font[3])
		gui.Text(163, 186, 'Нажмите Добавить в правом верхнем углу, чтобы создать Вашу первую сцену.', font[3])
		imgui.PopStyleColor(1)
	elseif #setting.scene ~= 0 and not new_scene then
		local bool_scene_x = 0
		local bool_scene_y = 0
		local color_scene = {{1.00, 0.62, 0.04}, {1.00, 0.26, 0.23}, {1.00, 0.82, 0.04}, {0.19, 0.80, 0.35}, {0.00, 0.80, 0.76}, {0.04, 0.49, 1.00}, {0.37, 0.35, 0.93}, {0.75, 0.33, 0.95}, {1.00, 0.20, 0.37}, {1.00, 0.55, 0.55}, {0.67, 0.55, 0.41}}
		for i = 1, #setting.scene do
			local x_sp = (204 * bool_scene_x)
			local y_sp = (108 * bool_scene_y)
			gui.Draw({16 + x_sp, 16 + y_sp}, {196, 100}, imgui.ImVec4(color_scene[setting.scene[i].color + 1][1], color_scene[setting.scene[i].color + 1][2], color_scene[setting.scene[i].color + 1][3], 1.00), 10, 15)
			imgui.SetCursorPos(imgui.ImVec2(16 + x_sp, 16 + y_sp))
			if imgui.InvisibleButton(u8'##Открыть сцену' .. i, imgui.ImVec2(156, 100)) then
				scene = setting.scene[i]
				scene_active = true
				scene_edit_pos = false
				windows.main[0] = false
				imgui.ShowCursor = false
				displayRadar(false)
				displayHud(false)
				lockPlayerControl(true)
				posX, posY, posZ = getCharCoordinates(playerPed)
				setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
				angZ = getCharHeading(playerPed)
				angZ = angZ * -1.0
				angY = 0.0
				sampTextdrawDelete(449)
			end
			if imgui.IsItemActive() then
				gui.Draw({16 + x_sp, 16 + y_sp}, {196, 100}, imgui.ImVec4(color_scene[setting.scene[i].color + 1][1], color_scene[setting.scene[i].color + 1][2] - 0.10, color_scene[setting.scene[i].color + 1][3], 1.00), 10, 15)
			end
			imgui.SetCursorPos(imgui.ImVec2(172 + x_sp, 56 + y_sp))
			if imgui.InvisibleButton(u8'##Открыть сцену 2' .. i, imgui.ImVec2(40, 60)) then
				scene = setting.scene[i]
				scene_active = true
				scene_edit_pos = false
				windows.main[0] = false
				imgui.ShowCursor = false
				displayRadar(false)
				displayHud(false)
				lockPlayerControl(true)
				posX, posY, posZ = getCharCoordinates(playerPed)
				setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
				angZ = getCharHeading(playerPed)
				angZ = angZ * -1.0
				angY = 0.0
				sampTextdrawDelete(449)
			end
			if imgui.IsItemActive() then
				gui.Draw({16 + x_sp, 16 + y_sp}, {196, 100}, imgui.ImVec4(color_scene[setting.scene[i].color + 1][1], color_scene[setting.scene[i].color + 1][2] - 0.10, color_scene[setting.scene[i].color + 1][3], 1.00), 10, 15)
			end
			gui.FaText(26 + x_sp, 26 + y_sp, all_icon_shpora[setting.scene[i].icon], fa_font[5], imgui.ImVec4(1.00, 1.00, 1.00, 1.00))
			imgui.SetCursorPos(imgui.ImVec2(16 + x_sp, 16 + y_sp))
			
			imgui.SetCursorPos(imgui.ImVec2(189 + x_sp, 39 + y_sp))
			local p = imgui.GetCursorScreenPos()
			imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x, p.y), 15, imgui.GetColorU32Vec4(imgui.ImVec4(color_scene[setting.scene[i].color + 1][1], color_scene[setting.scene[i].color + 1][2] + 0.10, color_scene[setting.scene[i].color + 1][3], 1.00)), 60)
			imgui.SetCursorPos(imgui.ImVec2(174 + x_sp, 24 + y_sp))
			if imgui.InvisibleButton(u8'##Открыть для редактирования сцены ' .. i, imgui.ImVec2(30, 30)) then
				new_scene = true
				scene = setting.scene[i]
				num_scene = i
				font_sc = renderCreateFont('Arial', scene.size, scene.flag)
			end
			if imgui.IsItemActive() then
				imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x, p.y), 15, imgui.GetColorU32Vec4(imgui.ImVec4(color_scene[setting.scene[i].color + 1][1], color_scene[setting.scene[i].color + 1][2] + 0.20, color_scene[setting.scene[i].color + 1][3], 1.00)), 60)
			end
			gui.FaText(180 + x_sp, 28 + y_sp, fa.ELLIPSIS, fa_font[5], imgui.ImVec4(1.00, 1.00, 1.00, 1.00))
			if setting.scene[i].name ~= '' then
				local wrapped_text, newline_count = wrapText(u8:decode(setting.scene[i].name), 21, 63)
				gui.Text(26 + x_sp, 91 + y_sp - (newline_count * 17), wrapped_text, bold_font[1])
			else
				gui.Text(26 + x_sp, 91 + y_sp, 'Без названия', bold_font[1])
			end
			imgui.Dummy(imgui.ImVec2(0, 19))
			
			if i % 4 == 0 then
				bool_scene_y = bool_scene_y + 1
				bool_scene_x = 0
			else
				bool_scene_x = bool_scene_x + 1
			end
		end
	elseif new_scene then
		gui.Draw({16, 16}, {808, 37}, cl.tab, 7, 15)
		gui.Text(26, 26, 'Имя сцены', font[3])
		scene.name = gui.InputText({139, 28}, 665, scene.name, u8'Имя сцены', 400, u8'Вводите текст')
		
		gui.Draw({16, 62}, {808, 37}, cl.tab, 7, 15)
		gui.Text(26, 72, 'Предосмотр сцены во время её редактирования', font[3])
		imgui.SetCursorPos(imgui.ImVec2(783, 69))
		if gui.Switch(u8'##Переключить предосмотр сцены', scene.preview) then
			scene.preview = not  scene.preview
		end
		
		gui.Draw({16, 109}, {808, 227}, cl.tab, 7, 15)
		gui.DrawLine({16, 146}, {824, 146}, cl.line)
		gui.DrawLine({16, 184}, {824, 184}, cl.line)
		gui.DrawLine({16, 222}, {824, 222}, cl.line)
		gui.DrawLine({16, 260}, {824, 260}, cl.line)
		gui.DrawLine({16, 298}, {824, 298}, cl.line)
		gui.Text(26, 119, 'Размер шрифта', font[3])
		gui.Text(26, 157, 'Расстояние между строками', font[3])
		gui.Text(26, 195, 'Прозрачность текста', font[3])
		gui.Text(26, 233, 'Флаг шрифта', font[3])
		gui.Text(26, 271, 'Инверсировать текст', font[3])
		gui.Text(26, 309, 'Положение текста на экране', font[3])
		
		local bool_set_size = imgui.new.float(scene.size)
		bool_set_size[0] = gui.SliderBar('##Размер шрифта', bool_set_size, 1, 50, 152, {671, 116})
		if bool_set_size[0] ~= scene.size then
			scene.size = floor(bool_set_size[0])
			font_sc = renderCreateFont('Arial', scene.size, scene.flag)
			save()
		end
		local bool_set_dist = imgui.new.float(scene.dist)
		bool_set_dist[0] = gui.SliderBar('##Расстояние между строками', bool_set_dist, 0, 50, 152, {671, 154})
		if bool_set_dist[0] ~= scene.dist then
			scene.dist = floor(bool_set_dist[0])
			save()
		end
		local bool_set_vis = imgui.new.float(scene.vis)
		bool_set_vis[0] = gui.SliderBar('##Прозрачность текста', bool_set_vis, 0, 100, 152, {671, 192})
		if bool_set_vis[0] ~= scene.vis then
			scene.vis = floor(bool_set_vis[0])
			save()
		end
		local bool_set_flag = scene.flag
		scene.flag = gui.ListTableMove({794, 233}, {u8'Без обводки', u8'Без обводки наклонённый', u8'Без обводки жирный наклонённый', u8'С обводкой', u8'С обводкой жирный', u8'С обводкой наклонённый', u8'С обводкой жирный наклонённый', u8'Без обводки с тенью', u8'Без обводки жирный с тенью', u8'Без обводки с тенью наклонённый', u8'Без обводки с тенью жирный наклонённый', u8'С обводкой и тенью', u8'С обводкой и тенью жирный'}, scene.flag, 'Select Size Scene')
		if scene.flag ~= bool_set_flag then
			font_sc = renderCreateFont('Arial', scene.size, scene.flag)
		end
		imgui.SetCursorPos(imgui.ImVec2(783, 267))
		if gui.Switch(u8'##Инверсировать текст', scene.invers) then
			scene.invers = not  scene.invers
		end
		if gui.Button(u8'Изменить...##положение текста', {713, 304}, {100, 27}) then
			scene_edit()
		end
		
		local function accent_col(num_acc, color_acc, color_acc_act)
			imgui.SetCursorPos(imgui.ImVec2(356 + (num_acc * 44), 364))
			local p = imgui.GetCursorScreenPos()
			
			imgui.SetCursorPos(imgui.ImVec2(345 + (num_acc * 44), 354))
			if imgui.InvisibleButton(u8'##Выбор цвета' .. num_acc, imgui.ImVec2(22, 22)) then
				scene.color = num_acc
			end
			if imgui.IsItemActive() then
				imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x, p.y + 0.5), 12, imgui.GetColorU32Vec4(imgui.ImVec4(color_acc_act[1], color_acc_act[2], color_acc_act[3] ,1.00)), 60)
			else
				imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x, p.y + 0.5),  12, imgui.GetColorU32Vec4(imgui.ImVec4(color_acc[1], color_acc[2], color_acc[3] ,1.00)), 60)
			end
			if num_acc == scene.color then
				imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x, p.y + 0.5), 4, imgui.GetColorU32Vec4(imgui.ImVec4(1.00, 1.00, 1.00 ,1.00)), 60)
			end
		end
		
		gui.Draw({16, 346}, {808, 75}, cl.tab, 7, 15)
		gui.DrawLine({16, 383}, {824, 383}, cl.line)
		gui.Text(26, 356, 'Цвет карточки', font[3])
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
		
		gui.Text(26, 394, 'Значок карточки', font[3])
		gui.FaText(150, 394, all_icon_shpora[scene.icon], fa_font[4])
		if gui.Button(u8'Выбрать...##Иконку карточки', {713, 389}, {100, 27}) then
			imgui.OpenPopup(u8'Установить значок карточки в рп зоне')
		end
		
		if imgui.BeginPopupModal(u8'Установить значок карточки в рп зоне', null, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar) then
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
			imgui.BeginChild(u8'Установка значка в рп зоне', imgui.ImVec2(243, 340), false)
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
					scene.icon = return_icon
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
		
		
		local pos_pl = 123
		gui.Text(379, 312 + pos_pl, 'Отыгровки', bold_font[1])
		if #scene.rp ~= 0 then
			for i = 1, #scene.rp do
				gui.Draw({16, 337 + pos_pl}, {808, 151}, cl.tab, 7, 15)
				if i <= 9 then
					gui.Text(5, 338 + pos_pl, tostring(i), font[2])
				else
					gui.Text(2, 338 + pos_pl, tostring(i), font[2])
				end
				gui.Text(26, 347 + pos_pl, 'Режим отображения', font[3])
				scene.rp[i].var = gui.ListTableMove({794, 347 + pos_pl}, {u8'Свой текст и свой цвет текста', u8'Разговорная речь', u8'/me', u8'/do', u8'/todo', u8'Телефон'}, scene.rp[i].var, 'Select Var Rp Zone' .. i)
				gui.DrawLine({16, 374 + pos_pl}, {824, 374 + pos_pl}, cl.line)
				if scene.rp[i].var ~= 5 then
					gui.Text(26, 385 + pos_pl, 'Текст отыгровки', font[3])
					scene.rp[i].text1 = gui.InputText({160, 387 + pos_pl}, 644, scene.rp[i].text1, u8'Текст отыгровки1' .. i, 400, u8'Введите текст Вашей отыгровки')
				else
					scene.rp[i].text1 = gui.InputText({32, 387 + pos_pl}, 370, scene.rp[i].text1, u8'Текст отыгровки1' .. i, 400, u8'Введите текст речи')
					scene.rp[i].text2 = gui.InputText({434, 387 + pos_pl}, 370, scene.rp[i].text2, u8'Текст отыгровки2' .. i, 400, u8'Введите текст действия')
				end
				gui.DrawLine({16, 412 + pos_pl}, {824, 412 + pos_pl}, cl.line)
				
				if scene.rp[i].var ~= 1 then
					gui.Text(26, 423 + pos_pl, 'Имя Вашего персонажа', font[3])
					scene.rp[i].nick = gui.InputText({610, 425 + pos_pl}, 194, scene.rp[i].nick, u8'Имя персонажа' .. i, 200, u8'Введите имя или никнейм')
				else
					local col_set = convert_color(scene.rp[i].color)
					gui.Text(26, 423 + pos_pl, 'Цвет отображаемого текста', font[3])
					imgui.PushStyleVarVec2(imgui.StyleVar.FramePadding, imgui.ImVec2(6.5, 6.5))
					imgui.SetCursorPos(imgui.ImVec2(787, 418 + pos_pl))
					if imgui.ColorEdit4('##Color Scene' .. i, col_set, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.NoLabel + imgui.ColorEditFlags.NoAlpha) then
						local c = imgui.ImVec4(col_set[0], col_set[1], col_set[2], col_set[3])
						scene.rp[i].color = imgui.ColorConvertFloat4ToARGB(c)
					end
					imgui.PopStyleVar(1)
				end
				gui.DrawLine({16, 450 + pos_pl}, {824, 450 + pos_pl}, cl.line)
				if gui.Button(u8'Удалить отыгровку##' .. i, {340, 455 + pos_pl}, {160, 27}) then
					table.remove(scene.rp, i)
					break
				end
				
				
				pos_pl = pos_pl + 161
			end
		end
		
		if gui.Button(u8'Добавить отыгровку', {340, 344 + pos_pl}, {160, 27}) then
			table.insert(scene.rp, {
				text1 = '',
				text2 = '',
				nick = sampGetPlayerNickname(my.id),
				var = 1,
				color = 0xFFFFFFFF
			})
		end
		
		imgui.Dummy(imgui.ImVec2(0, 20))
	end
	
	imgui.EndChild()
end

