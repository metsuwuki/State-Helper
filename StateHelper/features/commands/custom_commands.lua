--[[
Open with encoding: CP1251
StateHelper/features/commands/custom_commands.lua
]]

function hall.cmd()
	local to_delete = nil
	local color_ItemActive = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
	local color_ItemHovered = imgui.ImVec4(0.24, 0.24, 0.24, 1.00)
	if setting.cl == 'White' then
		color_ItemActive = imgui.ImVec4(0.78, 0.78, 0.78, 1.00)
		color_ItemHovered = imgui.ImVec4(0.83, 0.83, 0.83, 1.00)
	end
	
	if not edit_tab_cmd then
		gui.Draw({4, 39}, {221, 369}, cl.tab, 0, 15)
		gui.DrawLine({225, 39}, {225, 408}, cl.line)
		
		imgui.SetCursorPos(imgui.ImVec2(4, 39))
		imgui.BeginChild(u8'Папки команд', imgui.ImVec2(220, 369), false, imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollWithMouse)
		imgui.Scroller(u8'Папки команд', img_step[1][0], img_duration[1][0], imgui.HoveredFlags.AllowWhenBlockedByActiveItem)
		local ps = {3, 2, 0}
		local ps_y = 0
		
		local function TableMove(pos_draw, name_table)
			local col_stand_imvec4 = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
			local return_bool = 0
			local arg_table = {u8'Запустить', u8'Редактировать', u8'Удалить'}
			local icon_table = {fa.CIRCLE_PLAY, fa.PEN_RULER, fa.TRASH}
			imgui.PushFont(font[3])
			
			if table_move_cmd == name_table then
				imgui.SetCursorPos(imgui.ImVec2(pos_draw[1], pos_draw[2]))
				imgui.BeginChild(u8'Окно выбора действия с командой' .. name_table, imgui.ImVec2(140, 83), false, imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse)
				
				imgui.SetCursorPos(imgui.ImVec2(0, 0))
				local p = imgui.GetCursorScreenPos()
				imgui.GetWindowDrawList():AddRectFilled(imgui.ImVec2(p.x, p.y), imgui.ImVec2(p.x + 140, p.y + 81), imgui.GetColorU32Vec4(cl.bg), 7, 15)
				
				for m = 1, 3 do
					local col_stand_imvec4_2 = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
					imgui.SetCursorPos(imgui.ImVec2(0, 1 + (m - 1) * 27))
					if imgui.InvisibleButton('##TableMoveSelect ' .. name_table .. m, imgui.ImVec2(140, 27)) then
						table_move_cmd = ''
						return_bool = m
					end
					if imgui.IsItemActive() then
						col_stand_imvec4_2 = cl.def
					elseif imgui.IsItemHovered() then
						col_stand_imvec4_2 = cl.bg2
					end
					imgui.SetCursorPos(imgui.ImVec2(1, 1 + (m - 1) * 27))
					local p = imgui.GetCursorScreenPos()
					local flag = {0, 0}
					if m == 1 then 
						flag = {4, 3}
					elseif m == 3 then
						flag = {4, 12}
					end
					imgui.GetWindowDrawList():AddRectFilled(imgui.ImVec2(p.x, p.y), imgui.ImVec2(p.x + 138, p.y + 27), imgui.GetColorU32Vec4(col_stand_imvec4_2), flag[1], flag[2])
					
					imgui.SetCursorPos(imgui.ImVec2(25, 6 + ((m - 1) * 27)))
					imgui.Text(arg_table[m])
					
					imgui.PushFont(fa_font[2])
					imgui.SetCursorPos(imgui.ImVec2(7, 6 + ((m - 1) * 27)))
					imgui.Text(icon_table[m])
					imgui.PopFont()
				end
				imgui.SetCursorPos(imgui.ImVec2(0, 0))
				local p = imgui.GetCursorScreenPos()
				imgui.GetWindowDrawList():AddRect(imgui.ImVec2(p.x, p.y), imgui.ImVec2(p.x + 140, p.y + 82), imgui.GetColorU32Vec4(cl.def), 7, 15)
				imgui.EndChild()
				
				if imgui.IsMouseReleased(0) and not imgui.IsItemHovered() then
					table_move_cmd = ''
				end
			end
			
			imgui.PopFont()
			
			return return_bool
		end
		local function FolderMove(pos_draw, name_table)
			local col_stand_imvec4 = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
			local return_bool = 0
			local arg_table = {u8'Переименовать', u8'Удалить'}
			local icon_table = {fa.PEN_TO_SQUARE, fa.TRASH}
			imgui.PushFont(font[3])
			
			if table_move_cmd == name_table then
				imgui.SetCursorPos(imgui.ImVec2(pos_draw[1], pos_draw[2]))
				imgui.BeginChild(u8'Окно выбора действия с папкой' .. name_table, imgui.ImVec2(160, 56), false, imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse)
				
				imgui.SetCursorPos(imgui.ImVec2(0, 0))
				local p = imgui.GetCursorScreenPos()
				imgui.GetWindowDrawList():AddRectFilled(imgui.ImVec2(p.x, p.y), imgui.ImVec2(p.x + 160, p.y + 54), imgui.GetColorU32Vec4(cl.bg), 7, 15)
				local text_and_icon_color = (setting.cl == 'White') and imgui.ImVec4(0.0, 0.0, 0.0, 1.0) or imgui.ImVec4(1.0, 1.0, 1.0, 1.0)
				for m = 1, #arg_table do
					local col_stand_imvec4_2 = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
					imgui.SetCursorPos(imgui.ImVec2(0, 1 + (m - 1) * 27))
					if imgui.InvisibleButton('##FolderMoveSelect ' .. name_table .. m, imgui.ImVec2(160, 27)) then
						table_move_cmd = ''
						return_bool = m
					end
					if imgui.IsItemActive() then
						col_stand_imvec4_2 = cl.def
					elseif imgui.IsItemHovered() then
						col_stand_imvec4_2 = cl.bg2
					end
					imgui.SetCursorPos(imgui.ImVec2(1, 1 + (m - 1) * 27))
					local p = imgui.GetCursorScreenPos()
					local flag = {0, 0}
					if m == 1 then
						flag = {4, 3}
					elseif m == #arg_table then
						flag = {4, 12}
					end
					imgui.GetWindowDrawList():AddRectFilled(imgui.ImVec2(p.x, p.y), imgui.ImVec2(p.x + 158, p.y + 27), imgui.GetColorU32Vec4(col_stand_imvec4_2), flag[1], flag[2])
					imgui.PushStyleColor(imgui.Col.Text, text_and_icon_color)
					imgui.SetCursorPos(imgui.ImVec2(25, 6 + ((m - 1) * 27)))
					imgui.Text(arg_table[m])
					imgui.PushFont(fa_font[2])
					imgui.SetCursorPos(imgui.ImVec2(7, 6 + ((m - 1) * 27)))
					imgui.Text(icon_table[m])
					imgui.PopFont()
					imgui.PopStyleColor()
				end
				imgui.SetCursorPos(imgui.ImVec2(0, 0))
				local p = imgui.GetCursorScreenPos()
				imgui.GetWindowDrawList():AddRect(imgui.ImVec2(p.x, p.y), imgui.ImVec2(p.x + 160, p.y + 55), imgui.GetColorU32Vec4(cl.def), 7, 15)
				imgui.EndChild()
				
				if imgui.IsMouseReleased(0) and not imgui.IsItemHovered() then
					table_move_cmd = ''
				end
			end
			
			imgui.PopFont()
			
			return return_bool
		end

		local function folder_list_defoult(TEXT, FA, NUM, POS) --> Отрисовка стандартных папок
			POS = ((POS - 1) * 30) + ps_y
			local return_break = false
			--> Отрисовка кнопки перехода
			imgui.SetCursorPos(imgui.ImVec2(25, 15 + POS))
			if not edit_all_cmd or (edit_all_cmd and NUM <=7 ) then
				if imgui.InvisibleButton(u8'##Открыть папку' .. NUM, imgui.ImVec2(172, 24)) then
					int_cmd.folder = NUM
					edit_all_cmd = false
					an[13] = 0
					an[12][3] = false
					an[12][2] = 0
				end

				if imgui.IsItemClicked(1) and NUM > 7 then
					table_move_cmd = 'FOLDER_MOVE ' .. NUM
				end

				if imgui.IsItemActive() and int_cmd.folder ~= NUM and table_move_cmd == ''  then
					gui.Draw({25, 15 + POS}, {172, 24}, color_ItemActive, 5, 15)
				elseif imgui.IsItemHovered() and int_cmd.folder ~= NUM and table_move_cmd == ''  then
					gui.Draw({25, 15 + POS}, {172, 24}, color_ItemHovered, 5, 15)
				elseif int_cmd.folder == NUM then
					if setting.cl == 'White' then
						gui.Draw({25, 15 + POS}, {172, 24}, imgui.ImVec4(0.76, 0.76, 0.76, 1.00), 5, 15)
					else
						gui.Draw({25, 15 + POS}, {172, 24}, imgui.ImVec4(0.18, 0.18, 0.18, 1.00), 5, 15)
					end
				end
			end
			--> Отрисовка кнопки листа
			local vis_fa = 0.50
			imgui.SetCursorPos(imgui.ImVec2(7, 17 + POS))
			if imgui.InvisibleButton(u8'##Раскрыть лист' .. NUM, imgui.ImVec2(19, 19)) then
				cmd[2][NUM][2] = not cmd[2][NUM][2]
			end
			if imgui.IsItemHovered() then
				if an[6][2] ~= NUM then
					an[6][2] = NUM
					an[6][1] = 0
				end
				if an[6][1] < 0.50 then
					an[6][1] = an[6][1] + (anim * 1.5)
				end
				vis_fa = vis_fa + an[6][1]
			elseif an[6][2] == NUM and an[6][1] > 0 then
				an[6][1] = an[6][1] - (anim * 1.5)
				vis_fa = vis_fa + an[6][1]
			end
			
			--> Отрисовка текста и иконки
			imgui.PushStyleColor(imgui.Col.Text, cl.def)
			imgui.PushFont(fa_font[3])
			imgui.SetCursorPos(imgui.ImVec2(31 + FA.SDVIG[1], 18 + FA.SDVIG[2] + POS))
			if not edit_all_cmd or (edit_all_cmd and NUM <= 7) then
				imgui.Text(FA.ICON_FOLDER)
			else
				imgui.SetCursorPos(imgui.ImVec2(29 + FA.SDVIG[1], 18 + FA.SDVIG[2] + POS))
				if imgui.InvisibleButton('##DEL_FOLDER' .. NUM, imgui.ImVec2(19, 19)) then
					imgui.OpenPopup(u8'Удалить папку?' .. NUM)
				end
				if imgui.IsItemActive() then
					gui.FaText(31 + FA.SDVIG[1], 19 + FA.SDVIG[2] + POS, fa.CIRCLE_MINUS, fa_font[3], imgui.ImVec4(1.00, 0.09, 0.19, 1.00))
				else
					gui.FaText(31 + FA.SDVIG[1], 19 + FA.SDVIG[2] + POS, fa.CIRCLE_MINUS, fa_font[3], imgui.ImVec4(1.00, 0.23, 0.19, 1.00))
				end
			end

			if NUM > 7 then
				local folder_action = FolderMove({25, 15 + POS + 26}, 'FOLDER_MOVE ' .. NUM)
				if folder_action == 1 then
					edit_all_cmd = true
				elseif folder_action == 2 then
					imgui.OpenPopup(u8'Удалить папку?' .. NUM)
				end
			end

			if imgui.BeginPopupModal(u8'Удалить папку?' .. NUM, nil, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar) then
				if setting.cl == 'White' then
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.00, 0.00, 0.00, 1.00))
				else
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1.00, 1.00, 1.00, 1.00))
				end
				gui.Text(25, 5, 'Удалить папку\nи все команды внутри неё?', font[3])
				imgui.PopStyleColor(1)
				if gui.Button(u8'Удалить', {24, 43}, {90, 27}) then
					if #cmd[1] > 0 then
						for j = #cmd[1], 1, -1 do
							if cmd[1][j].folder == NUM then
								if #cmd[1][j].key[2] ~= 0 then
									rkeys.unRegisterHotKey(cmd[1][j].key[2])
								end
								if cmd[1][j].cmd ~= '' then
									sampUnregisterChatCommand(cmd[1][j].cmd)
								end
								table.remove(cmd[1], j)
							elseif cmd[1][j].folder > NUM then
								cmd[1][j].folder = cmd[1][j].folder - 1
							end
						end
					end
					table.remove(cmd[2], NUM)
					save_cmd()
					add_cmd_in_all_cmd()
					return_break = true
					imgui.CloseCurrentPopup()
				end
				if gui.Button(u8'Отмена', {141, 43}, {90, 27}) then
					imgui.CloseCurrentPopup()
				end
				imgui.EndPopup()
			end

			if return_break then
				imgui.PopStyleColor(1)
				imgui.PopFont()
				return true 
			end
			if setting.cl == 'White' then
				imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.40 - (vis_fa / 2), 0.40 - (vis_fa / 2), 0.40 - (vis_fa / 2), vis_fa))
			else
				imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 + (vis_fa / 2), 0.50 + (vis_fa / 2), 0.50 + (vis_fa / 2), vis_fa))
			end
			if cmd[2][NUM][2] then
				imgui.SetCursorPos(imgui.ImVec2(10, 18 + POS))
				imgui.Text(fa.ANGLE_DOWN)
			else
				imgui.SetCursorPos(imgui.ImVec2(13, 18 + POS))
				imgui.Text(fa.ANGLE_RIGHT)
			end
			imgui.PopStyleColor(2)
			imgui.PopFont()
			if (edit_name_folder and NUM == #cmd[2]) or (edit_all_cmd and NUM > 7) then
				imgui.PushFont(font[3])
				local txt_inp_buf = imgui.new.char[40](cmd[2][NUM][1])
				imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImVec4(0.30, 0.30, 0.30, 1.00))
				imgui.SetCursorPos(imgui.ImVec2(53, 20 + POS))
				imgui.PushItemWidth(140)
				imgui.InputText('##NAME_FOLDER' .. NUM, txt_inp_buf, ffi.sizeof(txt_inp_buf))
				imgui.PopStyleColor(1)
				if not focus_input_bool and not imgui.IsItemActive() and not edit_all_cmd then
					edit_name_folder = false
					save_cmd()
				end
				if cmd[2][NUM][1] == '' then
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
					gui.Text(53, 20 + POS, 'Имя файла', font[3])
					imgui.PopStyleColor(1)
				end
				imgui.PopItemWidth()
				cmd[2][NUM][1] = ffi.string(txt_inp_buf)
				
				if focus_input_bool and not scroll_input_bool and not edit_all_cmd then
					imgui.SetKeyboardFocusHere(-1)
					focus_input_bool = false
				end
				if scroll_input_bool and not edit_all_cmd then
					imgui.SetScrollY(imgui.GetScrollMaxY() + 20)
					scroll_input_bool = false
				end
				imgui.PopFont()
			else
				gui.Text(53, 20 + POS, TEXT, font[3])
			end
			
			if cmd[2][NUM][2] then
				POS = POS - ps_y
				local param_bool = true
				if #cmd[1] ~= 0 then
					for g = 1, #cmd[1] do
						if cmd[1][g].folder == NUM or NUM == 1 then
							imgui.SetCursorPos(imgui.ImVec2(52, 41 + POS + ps_y))
							if imgui.InvisibleButton('##SELECT_CMD' .. NUM .. g, imgui.ImVec2(155, 21)) then
								table_move_cmd = 'SEL_CMD_MOVE ' .. NUM .. g
							end
							if imgui.IsItemActive() and table_move_cmd == ''  then
								gui.Draw({52, 41 + POS + ps_y}, {155, 21}, color_ItemActive, 5, 15)
							elseif imgui.IsItemHovered() and table_move_cmd == ''  then
								gui.Draw({52, 41 + POS + ps_y}, {155, 21}, color_ItemHovered, 5, 15)
							end
							
							if setting.cl == 'White' then
								imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.25, 0.25, 0.25, 0.70))
							else
								imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.75, 0.75, 0.75, 0.50))
							end
							gui.Text(60, 43 + POS + ps_y, '/' .. u8:decode(cmd[1][g].cmd), font[3])
							imgui.PopStyleColor(1)
							local bool_tm = TableMove({52, 41 + POS + ps_y}, 'SEL_CMD_MOVE ' .. NUM .. g)
							if bool_tm == 1 then
								cmd_start('', tostring(cmd[1][g].UID) .. cmd[1][g].cmd)
							elseif bool_tm == 2 then
								edit_tab_cmd = true
								bl_cmd = cmd[1][g]
								cmd_memory = bl_cmd.cmd
								type_cmd = g
							elseif bool_tm == 3 then
								if #cmd[1][g].key[2] ~= 0 then
									rkeys.unRegisterHotKey(cmd[1][g].key[2])
									for ke = 1, #all_keys do
										if table.concat(all_keys[ke], ' ') == table.concat(cmd[1][g].key[2], ' ') then
											table.remove(all_keys, ke)
										end
									end
								end
								if cmd[1][g].cmd ~= '' then
									sampUnregisterChatCommand(cmd[1][g].cmd)
								end
								table.remove(cmd[1], g)
								save_cmd()
							end
							ps_y = ps_y + 22
							param_bool = false
						end
					end
				end
				if param_bool then
					if setting.cl == 'White' then
						imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.40, 0.40, 0.40, 0.50))
					else
						imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
					end
					gui.Text(60, 43 + POS + ps_y, 'Пусто', font[3])
					imgui.PopStyleColor(1)
					ps_y = ps_y + 18
				end
			end
			
			if return_break then return true end
		end
		
		--> Реализация папок
		folder_list_defoult(
			'Все команды',
			{ICON_FOLDER = fa.GLOBE, SDVIG = {0, 0}},
			1,
			1
		)
		
		folder_list_defoult(
			'Избранные',
			{ICON_FOLDER = fa.STAR, SDVIG = {-1, -1}},
			2,
			2 + ps[3]
		)
		
		--> Лист организации
		local pos_list_org = (ps[3] * 30)
		imgui.SetCursorPos(imgui.ImVec2(10, 85 + pos_list_org + ps_y))
		if imgui.InvisibleButton(u8'##Раскрыть лист организации', imgui.ImVec2(111, 19)) then
			int_cmd.group[1] = not int_cmd.group[1]
		end
		if imgui.IsItemActive() and table_move_cmd == ''  then
			gui.Draw({10, 85 + pos_list_org + ps_y}, {111, 19}, color_ItemActive, 5, 15)
		elseif imgui.IsItemHovered() and table_move_cmd == ''  then
			gui.Draw({10, 85 + pos_list_org + ps_y}, {111, 19}, color_ItemHovered, 5, 15)
		end
		if setting.cl == 'White' then
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.40, 0.40, 0.40, 0.50))
		else
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
		end
		gui.Text(13, 86 + pos_list_org + ps_y, 'Организация', font[3])
		if int_cmd.group[1] then
			gui.FaText(106, 86 + pos_list_org + ps_y, fa.ANGLE_DOWN, fa_font[3], imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
		else
			gui.FaText(106, 86 + pos_list_org + ps_y, fa.ANGLE_RIGHT, fa_font[3], imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
		end
		imgui.PopStyleColor(1)
		
		if int_cmd.group[1] then
			folder_list_defoult(
				'Основные',
				{ICON_FOLDER = fa.HOUSE, SDVIG = {-1, 0}},
				3,
				4.2 + ps[3]
			)
			folder_list_defoult(
				'Фракционные',
				{ICON_FOLDER = fa.BRIEFCASE, SDVIG = {0, 1}},
				4,
				5.2 + ps[3]
			)
			folder_list_defoult(
				'Для руководства',
				{ICON_FOLDER = fa.USER_TIE, SDVIG = {0, 0}},
				5,
				6.2 + ps[3]
			)
		else
			ps[1] = 0
		end
		
		--> Лист общих
		local pos_list_o = (ps[1] * 30)
		if setting.cl == 'White' then
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.40, 0.40, 0.40, 0.50))
		else
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
		end
		imgui.SetCursorPos(imgui.ImVec2(10, 121 + pos_list_o + ps_y))
		if imgui.InvisibleButton(u8'##Раскрыть лист общих', imgui.ImVec2(71, 19)) then
			int_cmd.group[2] = not int_cmd.group[2]
		end
		if imgui.IsItemActive() and table_move_cmd == ''  then
			gui.Draw({10, 121 + pos_list_o + ps_y}, {71, 19}, color_ItemActive, 5, 15)
		elseif imgui.IsItemHovered() and table_move_cmd == ''  then
			gui.Draw({10, 121 + pos_list_o + ps_y}, {71, 19}, color_ItemHovered, 5, 15)
		end
		gui.Text(13, 122 + pos_list_o + ps_y, 'Общие', font[3])
		if int_cmd.group[2] then
			gui.FaText(66, 122 + pos_list_o + ps_y, fa.ANGLE_DOWN, fa_font[3], imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
		else
			gui.FaText(66, 122 + pos_list_o + ps_y, fa.ANGLE_RIGHT, fa_font[3], imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
		end
		imgui.PopStyleColor(1)
		
		if int_cmd.group[2] then
			folder_list_defoult(
				'Лекции',
				{ICON_FOLDER = fa.MICROPHONE, SDVIG = {0, 0}},
				6,
				5.4 + ps[1]
			)
			folder_list_defoult(
				'Разное',
				{ICON_FOLDER = fa.LAYER_GROUP, SDVIG = {-2, 0}},
				7,
				6.4 + ps[1]
			)
		else
			ps[2] = 0
		end
		
		--> Лист личных
		local pos_list_l = ((ps[1] * 30) + (ps[2] * 30)) + ps_y
		imgui.SetCursorPos(imgui.ImVec2(10, 157 + pos_list_l))
		if imgui.InvisibleButton(u8'##Раскрыть лист личных', imgui.ImVec2(76, 19)) then
			int_cmd.group[3] = not int_cmd.group[3]
		end
		if imgui.IsItemActive() and table_move_cmd == ''  then
			gui.Draw({10,  157 + pos_list_l}, {76, 19}, color_ItemActive, 5, 15)
		elseif imgui.IsItemHovered() and table_move_cmd == ''  then
			gui.Draw({10,  157 + pos_list_l}, {76, 19}, color_ItemHovered, 5, 15)
		end
		if setting.cl == 'White' then
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.40, 0.40, 0.40, 0.50))
		else
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
		end
		gui.Text(13, 158 + pos_list_l, 'Личные', font[3])
		imgui.PopStyleColor(1)
		if int_cmd.group[3] then
			gui.FaText(71, 158 + pos_list_l, fa.ANGLE_DOWN, fa_font[3], imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
		else
			gui.FaText(71, 158 + pos_list_l, fa.ANGLE_RIGHT, fa_font[3], imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
		end
		if imgui.IsMouseReleased(0) then
			edit_name_folder = false
			save_cmd()
		end
		if not edit_all_cmd then
			imgui.SetCursorPos(imgui.ImVec2(88, 157 + pos_list_l))
			if imgui.InvisibleButton(u8'##Добавить новую личную папку', imgui.ImVec2(20, 19)) then
				table.insert(cmd[2], {u8'Новая папка ' .. tostring(#cmd[2] - 6), false})
				edit_name_folder = true
				focus_input_bool = true
				scroll_input_bool = true
				save_cmd()
			end
			if imgui.IsItemActive() then
				gui.DrawCircle({91 + 7, 157.5 + pos_list_l + 8.5}, 11, color_ItemActive)
			elseif imgui.IsItemHovered() then
				gui.DrawCircle({91 + 7, 157.5 + pos_list_l + 8.5}, 11, color_ItemHovered)
			end
			gui.FaText(91, 158 + pos_list_l, fa.PLUS, fa_font[3], cl.def)
		end
		
		if int_cmd.group[3] then
			if #cmd[2] == 7 then
				if setting.cl == 'White' then
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.40, 0.40, 0.40, 0.50))
				else
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
				end
				gui.Text(36, 184 + pos_list_l, 'Пусто', font[3])
				imgui.PopStyleColor(1)
			else
				for f = 8, #cmd[2] do
					if folder_list_defoult(
						u8:decode(cmd[2][f][1]),
						{ICON_FOLDER = fa.FOLDER, SDVIG = {-2, 0}},
						f,
						3.6 + (f - 5) + ps[1] + ps[2]
					) then break end
				end
			end
		end
		
		imgui.Dummy(imgui.ImVec2(0, 14))
		
		imgui.EndChild()
		
		imgui.SetCursorPos(imgui.ImVec2(226, 39))
		imgui.BeginChild(u8'Список команд', imgui.ImVec2(620, 369), false, imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollWithMouse)
		imgui.Scroller(u8'Список команд', img_step[1][0], img_duration[1][0], imgui.HoveredFlags.AllowWhenBlockedByActiveItem)
		
		local function search_for_matches(sought_after, match_text)
			local result_match = false
			
			sought_after = to_lowercase(sought_after)
			match_text = to_lowercase(match_text)
			
			sought_after = sought_after:gsub('[%^%$%(%)%%%.%[%]%*%+%-%?]', '%%%0')
			
			if match_text:find(sought_after) then
				result_match = true
			end

			return result_match
		end
		
		local presence_of_a_team = false
		if #cmd[1] ~= 0 then
			local pos_i = 0
			for i = 1, #cmd[1] do
				if cmd[1][i].folder == int_cmd.folder or int_cmd.folder == 1 then
					if search_cmd ~= '' then
						if not search_for_matches(u8:decode(search_cmd), cmd[1][i].cmd .. ' ' .. u8:decode(cmd[1][i].desc)) then
							goto continue_cmd_loop
						end
					end
					
					presence_of_a_team = true
					pos_i = pos_i + 1
					local pl_y = pos_i * 55
					
					if pos_i < 10 then
						gui.Text(5, -37 + pl_y, tostring(pos_i), font[2])
					elseif pos_i >= 10 and pos_i < 100 then
						gui.Text(2, -37 + pl_y, tostring(pos_i), font[2])
					elseif pos_i >= 100 then
						gui.Text(1, -37 + pl_y, tostring(pos_i), font[1])
					end
					
					if an[12][2] ~= 0 and an[12][1] == i then
						imgui.SetCursorPos(imgui.ImVec2(556, -39 + pl_y))
						if imgui.InvisibleButton(u8'DEL_CMD '.. i, imgui.ImVec2(45, 45)) then
							cmd_del_i = i
							imgui.OpenPopup(u8'Подтверждение удаления команды2' .. i)
						end
						
						if imgui.IsItemActive() then
							gui.Draw({556, -39 + pl_y}, {45, 45}, imgui.ImVec4(1.00, 0.13, 0.19, 1.00), 6, 10)
						else
							gui.Draw({556, -39 + pl_y}, {45, 45}, imgui.ImVec4(1.00, 0.23, 0.19, 1.00), 6, 10)
						end
						imgui.SetCursorPos(imgui.ImVec2(511, -39 + pl_y))
						if imgui.InvisibleButton(u8'EDIT_CMD '.. i, imgui.ImVec2(45, 45)) then
							edit_tab_cmd = true
							bl_cmd = deepcopy(cmd[1][i])
							cmd_memory = bl_cmd.cmd
							type_cmd = i
							an[12][2] = 0
							an[12][3] = false
						end
						if imgui.IsItemActive() then
							gui.Draw({511, -39 + pl_y}, {45, 45}, imgui.ImVec4(1.00, 0.48, 0.00, 1.00), 0, 0)
						else
							gui.Draw({511, -39 + pl_y}, {45, 45}, imgui.ImVec4(1.00, 0.58, 0.00, 1.00), 0, 0)
						end
						imgui.SetCursorPos(imgui.ImVec2(466, -39 + pl_y))
						if imgui.InvisibleButton(u8'START_CMD '.. i, imgui.ImVec2(45, 45)) then
							an[12][2] = 0
							an[12][3] = false
							cmd_start('', tostring(cmd[1][i].UID) .. cmd[1][i].cmd)
						end
						if imgui.IsItemActive() then
							gui.Draw({466, -39 + pl_y}, {45, 45}, imgui.ImVec4(0.19, 0.59, 0.78, 1.00), 0, 0)
						else
							gui.Draw({466, -39 + pl_y}, {45, 45}, imgui.ImVec4(0.19, 0.69, 0.78, 1.00), 0, 0)
						end
						gui.FaText(571, -26 + pl_y, fa.TRASH, fa_font[4], imgui.ImVec4(0.90, 0.90, 0.90, 1.00))
						gui.FaText(525, -25 + pl_y, fa.PEN_RULER, fa_font[4], imgui.ImVec4(0.90, 0.90, 0.90, 1.00))
						gui.FaText(480, -25 + pl_y, fa.CIRCLE_PLAY, fa_font[4], imgui.ImVec4(0.90, 0.90, 0.90, 1.00))
					end
if imgui.BeginPopupModal(u8'Подтверждение удаления команды2' .. i, null, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar) then
						imgui.SetCursorPos(imgui.ImVec2(10, 10))
						if imgui.InvisibleButton(u8'##Закрыть окно удаления команды', imgui.ImVec2(16, 16)) then
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
						imgui.BeginChild(u8'Подтверждение удаления команды ', imgui.ImVec2(261, 90), false, imgui.WindowFlags.NoScrollbar)
						
						gui.Text(25, 5, 'Вы уверены, что хотите удалить \n					 команду?', font[3])
						if gui.Button(u8'Удалить', {24, 50}, {90, 27}) then
							to_delete = cmd_del_i
							imgui.CloseCurrentPopup()
						end
						if gui.Button(u8'Отмена', {141, 50}, {90, 27}) then
							imgui.CloseCurrentPopup()
						end
						imgui.EndChild()
						imgui.EndPopup()
					end
						
					local pl_x = 0
					if an[12][1] == i then
						pl_x = an[12][2]
					end
					imgui.SetCursorPos(imgui.ImVec2(16 + pl_x + an[13], -39 + pl_y))
					if imgui.InvisibleButton(u8'SEL_CMD '.. i, imgui.ImVec2(586, 45)) then
						if an[13] == 0 then
							if an[12][1] ~= i then
								an[12][3] = true
								an[12][2] = 0
							else
								an[12][3] = not an[12][3]
							end
							an[12][1] = i
						end
					end
					if not imgui.IsItemHovered() and imgui.IsMouseReleased(0) and an[12][1] == i then
						an[12][3] = false
					end
					if an[12][1] == i and an[12][3] then
						gui.Draw({16 + pl_x, -39 + pl_y}, {586, 45}, cl.tab, 5, 5)
					else
						if edit_all_cmd and #table_select_cmd ~= 0 then
							local bool_sdf = false
							for h = 1, #table_select_cmd do
								if table_select_cmd[h] == i then
									bool_sdf = true
								end
							end
							if bool_sdf then
								gui.Draw({16 + pl_x, -39 + pl_y}, {586, 45}, cl.bg, 5, 15)
							else
								gui.Draw({16 + pl_x, -39 + pl_y}, {586, 45}, cl.tab, 5, 15)
							end
						else
							gui.Draw({16 + pl_x, -39 + pl_y}, {586, 45}, cl.tab, 5, 15)
						end
					end
					if an[13] > 0 then
						imgui.SetCursorPos(imgui.ImVec2(16, -39 + pl_y))
						if imgui.InvisibleButton(u8'CHECK_CMD '.. i, imgui.ImVec2(38, 45)) then
							if #table_select_cmd ~= 0 then
								local remove_bool_comp = 0
								for h = 1, #table_select_cmd do
									if table_select_cmd[h] == i then
										remove_bool_comp = h
										break
									end
								end
								if remove_bool_comp == 0 then
									table.insert(table_select_cmd, i)
								else
									table.remove(table_select_cmd, remove_bool_comp)
								end
							else
								table.insert(table_select_cmd, i)
							end
						end
					end
					if cmd[1][i].cmd ~= '' then
						gui.Text(26 + pl_x + an[13], -33 + pl_y, '/' .. u8:decode(cmd[1][i].cmd), font[3])
					else
						gui.Text(26 + pl_x + an[13], -33 + pl_y, 'Без назначенной команды', font[3])
					end
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
					if cmd[1][i].desc ~= '' and cmd[1][i].desc ~= ' ' then
						gui.Text(26 + pl_x + an[13], -16 + pl_y, u8:decode(cmd[1][i].desc), font[2])
					else
						gui.Text(26 + pl_x + an[13], -16 + pl_y, 'Без описания', font[2])
					end
					if an[12][1] == i then
						if an[12][2] > -136 and an[12][3] then
							an[12][2] = an[12][2] - (anim * 900)
						elseif an[12][2] <= -136 and an[12][3] then
							an[12][2] = -136
						elseif an[12][2] < 0 then
							an[12][2] = an[12][2] + (anim * 900)
						elseif an[12][2] >= 0 then
							an[12][2] = 0
						end
					end
					imgui.PopStyleColor(1)
					
					if edit_all_cmd then
						gui.DrawCircleEmp({35, -17 + pl_y}, 9, cl.bg2, 2)
						if #table_select_cmd ~= 0 then
							for h = 1, #table_select_cmd do
								if table_select_cmd[h] == i then
									gui.FaText(29, -24 + pl_y, fa.CHECK, fa_font[2])
								end
							end
						end
						
						if an[13] < 30 then
							an[13] = an[13] + (anim * 200)
						else
							an[13] = 30
						end
					else
						if an[13] > 0 then
							an[13] = an[13] - (anim * 200)
						else
							an[13] = 0
						end
					end
				end
				
				::continue_cmd_loop::
			end
			if to_delete then
				if cmd[1][to_delete] then
					if #cmd[1][to_delete].key[2] ~= 0 then
						rkeys.unRegisterHotKey(cmd[1][to_delete].key[2])
						for ke = #all_keys, 1, -1 do
							if table.concat(all_keys[ke], ' ') == table.concat(cmd[1][to_delete].key[2], ' ') then
								table.remove(all_keys, ke)
								break
							end
						end
					end
					if cmd[1][to_delete].cmd ~= '' then
						sampUnregisterChatCommand(cmd[1][to_delete].cmd)
					end
					table.remove(cmd[1], to_delete)
					an[12][2] = 0
					an[12][3] = false
					save_cmd()
					add_cmd_in_all_cmd()
				end
			end
			imgui.Dummy(imgui.ImVec2(0, 20))
		end
		
		if not presence_of_a_team then
			--edit_all_cmd = false --976
			if setting.cl == 'White' then
				imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.40, 0.40, 0.40, 1.00))
			else
				imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50, 0.50, 0.50, 1.00))
			end
			gui.Text(262, 165, 'Пусто', bold_font[3])
			imgui.PopStyleColor(1)
		end
		
		imgui.EndChild()
		hovered_bool_not_child = imgui.IsItemHovered()
	else
		imgui.SetCursorPos(imgui.ImVec2(4, 39))
		imgui.BeginChild(u8'Редактор команд', imgui.ImVec2(840, 369), false, imgui.WindowFlags.NoScrollWithMouse)
		imgui.Scroller(u8'Редактор команд', img_step[1][0], img_duration[1][0], imgui.HoveredFlags.AllowWhenBlockedByActiveItem)
		
		--> Основные настройки команды
		gui.DrawBox({16, 16}, {396, 113}, cl.tab, cl.line, 7, 15)
		gui.DrawBox({428, 16}, {396, 113}, cl.tab, cl.line, 7, 15)
		
		gui.Text(26, 26, 'Команда', font[3])
		bl_cmd.cmd = gui.InputText({191, 28}, 200, bl_cmd.cmd, u8'Установка команды', 30, u8'Введите команду', 'esp')
		gui.DrawLine({16, 53}, {412, 53}, cl.line)
		gui.Text(26, 64, 'Описание', font[3])
		bl_cmd.desc = gui.InputText({191, 66}, 200, bl_cmd.desc, u8'Описание команды', 150, u8'Введите описание команды')
		gui.DrawLine({16, 91}, {412, 91}, cl.line)
		if bl_cmd.key[1] == '' then
			gui.Text(26, 102, 'Клавиша активации - Отсутствует', font[3])
		else
			gui.Text(26, 102, 'Клавиша активации - ' .. bl_cmd.key[1], font[3])
		end
		
		if gui.Button(u8'Назначить...', {301, 98}, {100, 25}) then
			imgui.OpenPopup(u8'Назначить клавишу активации в редакторе команд')
			current_key = {'', {}}
			lockPlayerControl(true)
			edit_key = true
			key_bool_cur = bl_cmd.key[2]
		end
		local bool_result = key_edit(u8'Назначить клавишу активации в редакторе команд', bl_cmd.key)
		if bool_result[1] then
			bl_cmd.key = bool_result[2]
		end
		gui.Text(438, 26, 'Доступ к команде', font[3])
		bl_cmd.rank = gui.Counter({799, 26}, u8'С ' .. bl_cmd.rank .. u8' ранга', bl_cmd.rank, 1, 10, u8'Доступ ранга для команды')
		gui.DrawLine({428, 56}, {824, 56}, cl.line)
		gui.Text(438, 64, 'Папка хранения', font[3])
		local table_all_folder = {}
		for f = 1, #cmd[2] do
			if f <= 7 then
				table.insert(table_all_folder, u8(cmd[2][f][1]))
			else
				table.insert(table_all_folder, cmd[2][f][1])
			end
		end
		bl_cmd.folder = gui.ListTableMove({794, 64}, table_all_folder, bl_cmd.folder, 'Select Folder')
		gui.DrawLine({428, 91}, {824, 91}, cl.line)
		gui.Text(438, 102, 'Отправлять последнее сообщение в чат', font[3])
		imgui.SetCursorPos(imgui.ImVec2(783, 98))
		if gui.Switch(u8'##Последнее сообщение в чат', bl_cmd.send_end_mes) then
			bl_cmd.send_end_mes = not bl_cmd.send_end_mes
		end
		
		gui.DrawBox({16, 145}, {808, 37}, cl.tab, cl.line, 7, 15)
		gui.Text(26, 155, 'Задержка проигрывания отыгровки', font[3])
		local color_plus_bg, color_plus_text = cl.bg, cl.text
		if bl_cmd.delay >= 20.0 then
			color_plus_bg = imgui.ImVec4(0.40, 0.40, 0.40, 0.50)
			color_plus_text = (setting.cl == 'White' and imgui.ImVec4(0.50, 0.50, 0.50, 1.00)) or imgui.ImVec4(0.7, 0.7, 0.7, 1.00)
		else
			imgui.SetCursorPos(imgui.ImVec2(795, 152))
			if imgui.InvisibleButton(u8'##Прибавить к задержке', imgui.ImVec2(20, 20)) then
				bl_cmd.delay = round(bl_cmd.delay + 0.1, 1)
			end
			if imgui.IsItemActive() then
				color_plus_bg = cl.def
				color_plus_text = imgui.ImVec4(0.95, 0.95, 0.95, 1.00)
			end
		end
		gui.DrawCircle({804, 162}, 9.5, color_plus_bg)
		gui.FaText(799, 155, fa.PLUS, fa_font[2], color_plus_text)
		local color_minus_bg, color_minus_text = cl.bg, cl.text
		if bl_cmd.delay <= 0.5 then
			color_minus_bg = imgui.ImVec4(0.40, 0.40, 0.40, 0.50)
			color_minus_text = (setting.cl == 'White' and imgui.ImVec4(0.50, 0.50, 0.50, 1.00)) or imgui.ImVec4(0.7, 0.7, 0.7, 1.00)
		else
			imgui.SetCursorPos(imgui.ImVec2(545, 152))
			if imgui.InvisibleButton(u8'##Убавить от задержки', imgui.ImVec2(20, 20)) then
				bl_cmd.delay = round(bl_cmd.delay - 0.1, 1)
			end
			if imgui.IsItemActive() then
				color_minus_bg = cl.def
				color_minus_text = imgui.ImVec4(0.95, 0.95, 0.95, 1.00)
			end
		end
		gui.DrawCircle({555, 162}, 9.5, color_minus_bg)
		gui.FaText(550, 155, fa.MINUS, fa_font[2], color_minus_text)
		local bool_delay = imgui.new.float(bl_cmd.delay)
		local new_main_delay = gui.SliderBar('##Прозрачность текста', bool_delay, 0.5, 20, 140, {643, 152})
		if new_main_delay ~= bl_cmd.delay then
			bl_cmd.delay = round(new_main_delay, 1)
		end
		gui.Text(575, 155, tostring(bl_cmd.delay) .. ' сек.', font[3])
		
		local pixel_y_arg = #bl_cmd.arg * 72
		local pixel_y_var = #bl_cmd.var * 36
		if pixel_y_arg > pixel_y_var or pixel_y_arg == pixel_y_var then
			pxl = pixel_y_arg
		else
			pxl = pixel_y_var
		end
		gui.Text(25, 201, 'Аргументы', bold_font[1])
		gui.DrawBox({16, 226}, {396, 43 + pixel_y_arg}, cl.tab, cl.line, 7, 15)
		if #bl_cmd.arg <= 7 then
			if gui.Button(u8'Добавить аргумент', {140, 234 + pixel_y_arg}, {148, 27}) then
				table.insert(bl_cmd.arg, {name = 'arg' .. (#bl_cmd.arg + 1), desc = u8'Аргумент ' .. tostring(#bl_cmd.arg + 1), type = 1})
			end
		else
			gui.Button(u8'Добавить аргумент##неактив', {140, 234 + pixel_y_arg}, {148, 27}, false)
		end
		
		if #bl_cmd.arg ~= 0 then
			for arg = 1, #bl_cmd.arg do
				local y_arg = (arg * 72)
				gui.Text(26, 163 + y_arg, 'Имя', font[3])
				bl_cmd.arg[arg].name = gui.InputText({66, 165 + y_arg}, 110, bl_cmd.arg[arg].name, u8'Имя аргумента' .. arg, 20, u8'Имя аргумента', 'esp')
				bl_cmd.arg[arg].type = gui.ListTableMove({362, 163 + y_arg}, {u8'Тип: текстовый', u8'Тип: числовой'}, bl_cmd.arg[arg].type, 'Select Type' .. arg)
				gui.Text(26, 197 + y_arg, 'Предназначение', font[3])
				bl_cmd.arg[arg].desc = gui.InputText({149, 199 + y_arg}, 223, bl_cmd.arg[arg].desc, u8'Предназначение аргумента' .. arg, 60, u8'Текст')
				
				imgui.SetCursorPos(imgui.ImVec2(389, 180 + y_arg))
				if imgui.InvisibleButton(u8'##Удалить аргумент' .. arg, imgui.ImVec2(21, 20)) then
					table.remove(bl_cmd.arg, arg)
					break
				end
				local an_arg = 0
				if imgui.IsItemActive() then
					if an[9][3] < 0.45 then
						an[9][3] = an[9][3] + (anim * 1.3)
					end
					an[9][4] = arg
					if an[9][4] == arg then
						an_arg = an[9][3]
					end
				elseif imgui.IsItemHovered() then
					if an[9][3] < 0.45 then
						an[9][3] = an[9][3] + (anim * 1.3)
					end
					if an[9][4] == arg then
						an_arg = an[9][3]
					else
						an[9][4] = arg
						an[9][3] = 0
					end
				elseif an[9][4] == arg then
					if an[9][3] > 0 then
						an[9][3] = an[9][3] - (anim * 1.3)
					end
					an_arg = an[9][3]
				end
				if setting.cl == 'White' then
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 - an_arg, 0.50 - an_arg, 0.50 - an_arg, 1.00))
				else
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 + an_arg, 0.50 + an_arg, 0.50 + an_arg, 1.00))
				end
				gui.FaText(391, 181 + y_arg, fa.CIRCLE_XMARK, fa_font[4])
				imgui.PopStyleColor(1)
				
				gui.Text(5, 181 + y_arg, tostring(arg), font[2])
				gui.DrawLine({16, 225 + y_arg}, {412, 225 + y_arg}, cl.line)
			end
		end
		
		gui.Text(437, 201, 'Переменные', bold_font[1])
		gui.DrawBox({428, 226}, {396, 43 + pixel_y_var}, cl.tab, cl.line, 7, 15)
		if gui.Button(u8'Добавить переменную', {542, 234 + pixel_y_var}, {168, 27}) then
			table.insert(bl_cmd.var, {name = 'var' .. (#bl_cmd.var + 1), value = ''})
		end
		
		if #bl_cmd.var ~= 0 then
			for var = 1, #bl_cmd.var do
				local y_var = (var * 36)
				gui.Text(438, 199 + y_var, 'Имя', font[3])
				bl_cmd.var[var].name = gui.InputText({478, 201 + y_var}, 100, bl_cmd.var[var].name, u8'Имя переменной' .. var, 20, u8'Имя переменной', 'esp')
				gui.Text(614, 199 + y_var, 'Значение', font[3])
				bl_cmd.var[var].value = gui.InputText({689, 201 + y_var}, 100, bl_cmd.var[var].value, u8'Значение переменной' .. var, 200, u8'Значение')
				
				imgui.SetCursorPos(imgui.ImVec2(801, 198 + y_var))
				if imgui.InvisibleButton(u8'##Удалить переменную' .. var, imgui.ImVec2(21, 20)) then
					table.remove(bl_cmd.var, var)
					break
				end
				local an_var = 0
				if imgui.IsItemActive() then
					if an[9][1] < 0.45 then
						an[9][1] = an[9][1] + (anim * 1.3)
					end
					if an[9][2] == var then
						an_var = an[9][1]
					end
				elseif imgui.IsItemHovered() then
					if an[9][1] < 0.45 then
						an[9][1] = an[9][1] + (anim * 1.3)
					end
					if an[9][2] == var then
						an_var = an[9][1]
					else
						an[9][2] = var
						an[9][1] = 0
					end
				elseif an[9][2] == var then 
					if an[9][1] > 0 then
						an[9][1] = an[9][1] - (anim * 1.3)
					end
					an_var = an[9][1]
				end
				if setting.cl == 'White' then
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 - an_var, 0.50 - an_var, 0.50 - an_var, 1.00))
				else
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 + an_var, 0.50 + an_var, 0.50 + an_var, 1.00))
				end
				gui.FaText(803, 199 + y_var, fa.CIRCLE_XMARK, fa_font[4])
				imgui.PopStyleColor(1)
				
				if var < 10 then
					gui.Text(417, 199 + y_var, tostring(var), font[2])
				else
					gui.Text(413, 199 + y_var, tostring(var), font[2])
				end
				gui.DrawLine({428, 225 + y_var}, {824, 225 + y_var}, cl.line)
			end
		end
		pxl = pxl + 14
		gui.DrawLine({16, 271 + pxl}, {824, 271 + pxl}, cl.line)
		local scroll_pos_y = imgui.GetScrollY()
		if #bl_cmd.act ~= 0 then
			local function anim_vis(i_act)
				local an_act = 0
				if imgui.IsItemActive() then
					if an[10][1] < 0.45 then
						an[10][1] = an[10][1] + (anim * 1.3)
					end
					if an[10][2] == i_act then
						an_act = an[10][1]
					end
				elseif imgui.IsItemHovered() then
					if an[10][1] < 0.45 then
						an[10][1] = an[10][1] + (anim * 1.3)
					end
					if an[10][2] == i_act then
						an_act = an[10][1]
					else
						an[10][2] = i_act
						an[10][1] = 0
					end
				elseif an[10][2] == i_act then 
					if an[10][1] > 0 then
						an[10][1] = an[10][1] - (anim * 1.3)
					end
					an_act = an[10][1]
				end
				
				return an_act
			end
			
			local if_disp = 0
			local bool_y = 0
			local num_el_if = 0
			local collapsed_level = 0
			for i = 1, #bl_cmd.act do
				if collapsed_level > 0 then
					if bl_cmd.act[i][1] == 'IF' then
						collapsed_level = collapsed_level + 1
					elseif bl_cmd.act[i][1] == 'END' then
						collapsed_level = collapsed_level - 1
					end
					if collapsed_level > 0 then
						goto continue_loop_render
					end
				end
				if if_disp > 168 then
					if_disp = 168
				end
				local optimization
				if (scroll_pos_y - 2000) < pxl and (scroll_pos_y + 2000) > pxl then
					optimization = false
				else
					optimization = true
				end
				if not optimization then
					if i < 10 then
						gui.Text(5, 290 + pxl, tostring(i), font[2])
					elseif i >= 10 and i < 100 then
						gui.Text(2, 290 + pxl, tostring(i), font[2])
					elseif i >= 100 then
						gui.Text(1, 290 + pxl, tostring(i), font[1])
					end
				end
				
				local function remove_action(pixel_y, i_act)
					if not optimization then
						imgui.SetCursorPos(imgui.ImVec2(799, 293 + pixel_y))
						if imgui.InvisibleButton('##DEL' .. i_act, imgui.ImVec2(21, 22)) then
							return true
						end
						local anim_act = anim_vis(i_act)
						if setting.cl == 'White' then
							imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 - anim_act, 0.50 - anim_act, 0.50 - anim_act, 1.00))
						else
							imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 + anim_act, 0.50 + anim_act, 0.50 + anim_act, 1.00))
						end
						gui.FaText(801, 295 + pixel_y, fa.CIRCLE_XMARK, fa_font[4])
						imgui.PopStyleColor(1)
						
						return false
					end
				end
				
				local function add_action_other(pos_but_action, i_act)
					imgui.SetCursorPos(imgui.ImVec2(20, pos_but_action))
					if imgui.InvisibleButton('NEW_ACT' .. i_act, imgui.ImVec2(800, 16)) then
						number_i_cmd = i_act
						imgui.OpenPopup(u8'Добавление действия')
					end
					if imgui.IsItemHovered() then
						if i_act ~= an[11][1] then
							an[11][1] = i_act
							an[11][2] = 0
						end
						if i_act == an[11][1] then
							an[11][2] = an[11][2] + (anim * 5)
						end
					elseif not imgui.IsItemHovered() and i_act == an[11][1] then
						an[11][1] = 0
					end
					if imgui.IsItemActive() and i_act == an[11][1] and an[11][2] > 1.5 then
						if setting.cl == 'White' then
							gui.Draw({20, pos_but_action - 1}, {800, 14}, imgui.ImVec4(0.75, 0.75, 0.75, 1.00), 0, 15)
						else
							gui.Draw({20, pos_but_action - 1}, {800, 14}, imgui.ImVec4(0.20, 0.20, 0.20, 1.00), 0, 15)
						end
						gui.Text(307, pos_but_action, 'Добавить новое действие в это место', font[3])
						gui.FaText(287, pos_but_action + 1, fa.CIRCLE_PLUS, fa_font[2], imgui.ImVec4(0.30, 0.75, 0.39, 1.00))
					elseif imgui.IsItemHovered() and i_act == an[11][1] and an[11][2] > 1.5 then
						if setting.cl == 'White' then
							gui.Draw({20, pos_but_action + 1}, {800, 14}, imgui.ImVec4(0.80, 0.80, 0.80, 1.00), 0, 15)
						else
							gui.Draw({20, pos_but_action + 1}, {800, 14}, imgui.ImVec4(0.25, 0.25, 0.25, 1.00), 0, 15)
						end
						gui.Text(307, pos_but_action, 'Добавить новое действие в это место', font[3])
						gui.FaText(287, pos_but_action + 1, fa.CIRCLE_PLUS, fa_font[2], imgui.ImVec4(0.30, 0.75, 0.39, 1.00))
					end
				end
				
				local bool_if_line = false
				
				if if_disp > 0 then
					for y = 1, (if_disp / 24) do
						if (i - 1) ~= 0 then
							if bl_cmd.act[i - 1][1] == 'IF' then
								bool_if_line = true
							end
						end
						if y ~= (if_disp / 24) and bool_if_line then
							bool_if_line = false
						end
						if num_el_if >= 7 then
							bool_if_line = false
						end
						if not bool_if_line then
							gui.DrawLine({24 + ((y - 1) * 24), 319 + bool_y}, {24 + ((y - 1) * 24), 319 + pxl}, cl.line, 2)
						elseif bl_cmd.act[i - 1][2] == 1 then
							gui.DrawLine({24 + ((y - 1) * 24), 319 + bool_y}, {24 + ((y - 1) * 24), 319 + pxl}, cl.line, 2)
						else
							gui.DrawLine({24 + ((y - 1) * 24), 319 + bool_y + 36}, {24 + ((y - 1) * 24), 319 + pxl}, cl.line, 2)
						end
					end
				end
				bool_y = pxl
				
				if bl_cmd.act[i][1] == 'SEND' then
					if not optimization then
						gui.DrawBox({16 + if_disp, 288 + pxl}, {808 - if_disp, 61}, cl.tab, cl.line, 7, 15)
						gui.Draw({21 + if_disp, 293 + pxl}, {21, 21}, imgui.ImVec4(1.00, 0.58, 0.00, 1.00), 3, 15)
						gui.DrawLine({16 + if_disp, 319 + pxl}, {824, 319 + pxl}, cl.line)
						gui.FaText(23 + 1 + if_disp, 295 + pxl, fa.SHARE, fa_font[3], imgui.ImVec4(0.90, 0.90, 0.90, 1.00))
						gui.Text(50 + if_disp, 295 + pxl, 'Отправить сообщение в чат', font[3])
						if AddMoveButtons(i, pxl) then break end
						if remove_action(pxl, i) then
							table.remove(bl_cmd.act, i)
							break
						end
						
						if gui.Button(u8'Вставить тег...##' .. i, {701, 323 + pxl}, {112, 23}) then
							popup_open_tags = true
							insert_tag_popup[3] = true
							insert_tag_popup[1] = i
						end
						
						imgui.PushFont(font[3])
						if insert_tag_popup[1] == i and not insert_tag_popup[3] then
							if bl_cmd.act[i][2] ~= '' then
								bl_cmd.act[i][2] = bl_cmd.act[i][2] .. ' ' .. insert_tag_popup[2]
							else
								bl_cmd.act[i][2] = bl_cmd.act[i][2] .. insert_tag_popup[2]
							end
							insert_tag_popup[1] = 0
							insert_tag_popup[2] = ''
						end
						local txt_inp_buf = imgui.new.char[600](bl_cmd.act[i][2])
						imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImVec4(0.30, 0.30, 0.30, 0.00))
						imgui.SetCursorPos(imgui.ImVec2(27 + if_disp, 326 + pxl))
						imgui.PushItemWidth(662 - if_disp)
						imgui.InputText('##SEND_CHAT' .. i, txt_inp_buf, ffi.sizeof(txt_inp_buf))
						if bl_cmd.act[i][2] == '' then
							imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
							gui.Text(29 + if_disp, 326 + pxl, 'Текст', font[3])
							imgui.PopStyleColor(1)
						end
						imgui.PopItemWidth()
						bl_cmd.act[i][2] = ffi.string(txt_inp_buf)
						imgui.PopStyleColor(1)
						imgui.SetCursorPos(imgui.ImVec2(27 + if_disp, 326 + pxl))
						imgui.PopFont()
					end
					pxl = pxl + 77
					if not optimization then
						add_action_other(272 + pxl, i)
					end
				elseif bl_cmd.act[i][1] == 'SEND_CMD' then
					if not optimization then
						gui.DrawBox({16 + if_disp, 288 + pxl}, {808 - if_disp, 61}, cl.tab, cl.line, 7, 15)
						gui.Draw({21 + if_disp, 293 + pxl}, {21, 21}, imgui.ImVec4(0.20, 0.60, 0.80, 1.00), 3, 15)
						gui.DrawLine({16 + if_disp, 319 + pxl}, {824, 319 + pxl}, cl.line)
						gui.FaText(23 + 1 + if_disp, 295 + pxl, fa.TERMINAL, fa_font[3], imgui.ImVec4(0.90, 0.90, 0.90, 1.00))
						gui.Text(50 + if_disp, 295 + pxl, 'Отправить пользовательскую команду', font[3])
						gui.Text(523, 295 + pxl, 'Останавливать отыгровки:', font[3])
						imgui.SetCursorPos(imgui.ImVec2(703, 290 + pxl))
						if gui.Switch(u8'##StopPlayback' .. i, bl_cmd.act[i][3]) then
							bl_cmd.act[i][3] = not bl_cmd.act[i][3]
						end
						if AddMoveButtons(i, pxl) then break end
						if remove_action(pxl, i) then
							table.remove(bl_cmd.act, i)
							break
						end
						
						if gui.Button(u8'Вставить тег...##' .. i, {701, 323 + pxl}, {112, 23}) then
							popup_open_tags = true
							insert_tag_popup[3] = true
							insert_tag_popup[1] = i
						end
						
						imgui.PushFont(font[3])
						if insert_tag_popup[1] == i and not insert_tag_popup[3] then
							if bl_cmd.act[i][2] ~= '' then
								bl_cmd.act[i][2] = bl_cmd.act[i][2] .. ' ' .. insert_tag_popup[2]
							else
								bl_cmd.act[i][2] = bl_cmd.act[i][2] .. insert_tag_popup[2]
							end
							insert_tag_popup[1] = 0
							insert_tag_popup[2] = ''
						end
						local txt_inp_buf = imgui.new.char[600](bl_cmd.act[i][2])
						imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImVec4(0.30, 0.30, 0.30, 0.00))
						imgui.SetCursorPos(imgui.ImVec2(27 + if_disp, 326 + pxl))
						imgui.PushItemWidth(662 - if_disp)
						imgui.InputText('##SEND_CMD_CHAT' .. i, txt_inp_buf, ffi.sizeof(txt_inp_buf))
						if bl_cmd.act[i][2] == '' then
							imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
							gui.Text(29 + if_disp, 326 + pxl, 'Команда', font[3])
							imgui.PopStyleColor(1)
						end
						imgui.PopItemWidth()
						bl_cmd.act[i][2] = ffi.string(txt_inp_buf)
						imgui.PopStyleColor(1)
						imgui.SetCursorPos(imgui.ImVec2(27 + if_disp, 326 + pxl))
						imgui.PopFont()
					end
					pxl = pxl + 77
					if not optimization then
						add_action_other(272 + pxl, i)
					end
				elseif bl_cmd.act[i][1] == 'OPEN_INPUT' then
					if not optimization then
						gui.DrawBox({16 + if_disp, 288 + pxl}, {808 - if_disp, 61}, cl.tab, cl.line, 7, 15)
						gui.Draw({21 + if_disp, 293 + pxl}, {21, 21}, imgui.ImVec4(1.00, 0.30, 0.00, 1.00), 3, 15)
						gui.DrawLine({16 + if_disp, 319 + pxl}, {824, 319 + pxl}, cl.line)
						gui.FaText(23 + if_disp, 295 + pxl, fa.KEYBOARD, fa_font[3], imgui.ImVec4(0.90, 0.90, 0.90, 1.00))
						gui.Text(50 + if_disp, 295 + pxl, 'Открыть игровой чат с текстом', font[3])
						if AddMoveButtons(i, pxl) then break end
						if remove_action(pxl, i) then
							table.remove(bl_cmd.act, i)
							break
						end
						
						if gui.Button(u8'Вставить тег...##' .. i, {701, 323 + pxl}, {112, 23}) then
							popup_open_tags = true
							insert_tag_popup[3] = true
							insert_tag_popup[1] = i
						end
						
						imgui.PushFont(font[3])
						if insert_tag_popup[1] == i and not insert_tag_popup[3] then
							if bl_cmd.act[i][2] ~= '' then
								bl_cmd.act[i][2] = bl_cmd.act[i][2] .. ' ' .. insert_tag_popup[2]
							else
								bl_cmd.act[i][2] = bl_cmd.act[i][2] .. insert_tag_popup[2]
							end
							insert_tag_popup[1] = 0
							insert_tag_popup[2] = ''
						end
						local txt_inp_buf = imgui.new.char[600](bl_cmd.act[i][2])
						imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImVec4(0.30, 0.30, 0.30, 0.00))
						imgui.SetCursorPos(imgui.ImVec2(27 + if_disp, 326 + pxl))
						imgui.PushItemWidth(662 - if_disp)
						imgui.InputText('##OPEN_CHAT_TEXT' .. i, txt_inp_buf, ffi.sizeof(txt_inp_buf))
						if bl_cmd.act[i][2] == '' then
							imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
							gui.Text(29 + if_disp, 326 + pxl, 'Текст', font[3])
							imgui.PopStyleColor(1)
						end
						imgui.PopItemWidth()
						bl_cmd.act[i][2] = ffi.string(txt_inp_buf)
						imgui.PopStyleColor(1)
						imgui.SetCursorPos(imgui.ImVec2(27 + if_disp, 326 + pxl))
						imgui.PopFont()
					end
					
					pxl = pxl + 77
					if not optimization then
						add_action_other(272 + pxl, i)
					end
				elseif bl_cmd.act[i][1] == 'WAIT_ENTER' then
					if not optimization then
						gui.DrawBox({16 + if_disp, 288 + pxl}, {808 - if_disp, 31}, cl.tab, cl.line, 7, 15)
						gui.Draw({21 + if_disp, 293 + pxl}, {21, 21}, imgui.ImVec4(0.30, 0.75, 0.39, 1.00), 3, 15)
						gui.FaText(23 + 3 + if_disp, 295 + pxl, fa.HOURGLASS, fa_font[3], imgui.ImVec4(0.90, 0.90, 0.90, 1.00))
						gui.Text(50 + if_disp, 295 + pxl, 'Ожидание нажатия клавиши Enter', font[3])
						if AddMoveButtons(i, pxl) then break end
						if remove_action(pxl, i) then
							table.remove(bl_cmd.act, i)
							break
						end
					end
					
					pxl = pxl + 47
					if not optimization then
						add_action_other(272 + pxl, i)
					end
				elseif bl_cmd.act[i][1] == 'SEND_ME' then
					if not optimization then
						gui.DrawBox({16 + if_disp, 288 + pxl}, {808 - if_disp, 61}, cl.tab, cl.line, 7, 15)
						gui.Draw({21 + if_disp, 293 + pxl}, {21, 21}, imgui.ImVec4(1.00, 0.58, 0.00, 1.00), 3, 15)
						gui.DrawLine({16 + if_disp, 319 + pxl}, {824, 319 + pxl}, cl.line)
						gui.FaText(23  + if_disp, 295 + pxl, fa.SHARE_FROM_SQUARE, fa_font[3], imgui.ImVec4(0.90, 0.90, 0.90, 1.00))
						gui.Text(50 + if_disp, 295 + pxl, 'Вывести в чат информацию для себя', font[3])
						if AddMoveButtons(i, pxl) then break end
						if remove_action(pxl, i) then
							table.remove(bl_cmd.act, i)
							break
						end
						
						if gui.Button(u8'Вставить тег...##' .. i, {701, 323 + pxl}, {112, 23}) then
							popup_open_tags = true
							insert_tag_popup[3] = true
							insert_tag_popup[1] = i
						end
						
						if insert_tag_popup[1] == i and not insert_tag_popup[3] then
							if bl_cmd.act[i][2] ~= '' then
								bl_cmd.act[i][2] = bl_cmd.act[i][2] .. ' ' .. insert_tag_popup[2]
							else
								bl_cmd.act[i][2] = bl_cmd.act[i][2] .. insert_tag_popup[2]
							end
							insert_tag_popup[1] = 0
							insert_tag_popup[2] = ''
						end
						
						imgui.PushFont(font[3])
						local txt_inp_buf = imgui.new.char[600](bl_cmd.act[i][2])
						imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImVec4(0.30, 0.30, 0.30, 0.00))
						imgui.SetCursorPos(imgui.ImVec2(27 + if_disp, 326 + pxl))
						imgui.PushItemWidth(662 - if_disp)
						imgui.InputText('##SEND_CHAT' .. i, txt_inp_buf, ffi.sizeof(txt_inp_buf))
						if bl_cmd.act[i][2] == '' then
							imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
							gui.Text(29 + if_disp, 326 + pxl, 'Текст', font[3])
							imgui.PopStyleColor(1)
						end
						imgui.PopItemWidth()
						bl_cmd.act[i][2] = ffi.string(txt_inp_buf)
						imgui.PopStyleColor(1)
						imgui.SetCursorPos(imgui.ImVec2(27, 326 + pxl))
						imgui.PopFont()
					end
					
					pxl = pxl + 77
					if not optimization then
						add_action_other(272 + pxl, i)
					end
				elseif bl_cmd.act[i][1] == 'NEW_VAR' then
					if not optimization then
						gui.DrawBox({16 + if_disp, 288 + pxl}, {808 - if_disp, 65}, cl.tab, cl.line, 7, 15)
						gui.Draw({21 + if_disp, 293 + pxl}, {21, 21}, imgui.ImVec4(0.00, 0.48, 1.00, 1.00), 3, 15)
						gui.DrawLine({16 + if_disp, 319 + pxl}, {824, 319 + pxl}, cl.line)
						gui.FaText(23 + if_disp, 295 + pxl, fa.SQUARE_ROOT_VARIABLE, fa_font[3], imgui.ImVec4(0.90, 0.90, 0.90, 1.00))
						gui.Text(50 + if_disp, 295 + pxl, 'Задать для переменной', font[3])
						if AddMoveButtons(i, pxl) then break end
						if remove_action(pxl, i) then
							table.remove(bl_cmd.act, i)
							break
						end
						
						gui.Text(26 + if_disp, 328 + pxl, 'Имя переменной', font[3])
						bl_cmd.act[i][2] = gui.InputText({154 + if_disp, 330 + pxl}, 120, bl_cmd.act[i][2], u8'Имя var' .. i, 20, u8'Имя переменной', 'esp')
						gui.Text(500, 328 + pxl, 'Значение', font[3])
						bl_cmd.act[i][3] = gui.InputText({577, 330 + pxl}, 227, bl_cmd.act[i][3], u8'Значение var' .. i, 200, u8'Значение переменной')
					end
					
					pxl = pxl + 81
					if not optimization then
						add_action_other(272 + pxl, i)
					end
				elseif bl_cmd.act[i][1] == 'DIALOG' then
					if not optimization then
						gui.DrawBox({16 + if_disp, 288 + pxl}, {808 - if_disp, 99 + (#bl_cmd.act[i][3] * 34)}, cl.tab, cl.line, 7, 15)
						gui.Draw({21 + if_disp, 293 + pxl}, {21, 21}, imgui.ImVec4(0.69, 0.32, 0.87, 1.00), 3, 15)
						gui.DrawLine({16 + if_disp, 319 + pxl}, {824, 319 + pxl}, cl.line)
						gui.FaText(23 + 1 + if_disp, 295 + pxl, fa.BARS_STAGGERED, fa_font[3], imgui.ImVec4(0.90, 0.90, 0.90, 1.00))
						gui.Text(50 + if_disp, 295 + pxl, 'Диалог выбора дальнейшего действия', font[3])
						if AddMoveButtons(i, pxl) then break end
						if remove_action(pxl, i) then
							table.remove(bl_cmd.act, i)
							break
						end
						
						gui.Text(26 + if_disp, 328 + pxl, 'Имя диалога', font[3])
						bl_cmd.act[i][2] = gui.InputText({123 + if_disp, 330 + pxl}, 120, bl_cmd.act[i][2], u8'Имя диалога' .. i, 20, u8'Имя диалога', 'esp')
						gui.DrawLine({16 + if_disp, 353 + pxl}, {824, 353 + pxl}, cl.line)
					end
					local max_variants = 10
					local count = math.min(#bl_cmd.act[i][3], max_variants)
					for vr = 1, count do
						if not optimization then
							local txt_inp_buf = imgui.new.char[60](bl_cmd.act[i][3][vr])
							imgui.SetCursorPos(imgui.ImVec2(50 + if_disp, 362 + pxl))
							imgui.PushItemWidth(763 - if_disp)
							imgui.InputText('##BOOL_DIALOG' .. i .. vr, txt_inp_buf, ffi.sizeof(txt_inp_buf))
							if bl_cmd.act[i][3][vr] == '' then
								imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
								gui.Text(52 + if_disp, 362 + pxl, 'Текст варианта', font[3])
								imgui.PopStyleColor(1)
							end
							imgui.PopItemWidth()
							bl_cmd.act[i][3][vr] = ffi.string(txt_inp_buf)
							imgui.SetCursorPos(imgui.ImVec2(24 + if_disp, 358 + pxl))
							if imgui.InvisibleButton('DEL_OPTION' .. i .. vr, imgui.ImVec2(23, 23)) then
								table.remove(bl_cmd.act[i][3], vr)
								break
							end
							if imgui.IsItemActive() then
								gui.FaText(27 + if_disp, 361 + pxl, fa.CIRCLE_MINUS, fa_font[4], imgui.ImVec4(1.00, 0.09, 0.19, 1.00))
							else
								gui.FaText(27 + if_disp, 361 + pxl, fa.CIRCLE_MINUS, fa_font[4], imgui.ImVec4(1.00, 0.23, 0.19, 1.00))
							end
							gui.DrawLine({16 + if_disp, 387 + pxl}, {824, 387 + pxl}, cl.line)
						end
						pxl = pxl + 34
					end
					if not optimization then
						if #bl_cmd.act[i][3] <= 9 then
							imgui.SetCursorPos(imgui.ImVec2(23 + if_disp, 358 + pxl))
							if imgui.InvisibleButton('NEW_OPTION' .. i, imgui.ImVec2(196, 23)) then
								table.insert(bl_cmd.act[i][3], '')
							end
							if imgui.IsItemActive() then
								if setting.cl == 'White' then
									gui.Draw({23 + if_disp, 358 + pxl}, {196, 23}, imgui.ImVec4(0.75, 0.75, 0.75, 1.00), 7, 15)
								else
									gui.Draw({23 + if_disp, 358 + pxl}, {196, 23}, imgui.ImVec4(0.20, 0.20, 0.20, 1.00), 7, 15)
								end
							elseif imgui.IsItemHovered() then
								if setting.cl == 'White' then
									gui.Draw({23 + if_disp, 358 + pxl}, {196, 23}, imgui.ImVec4(0.80, 0.80, 0.80, 1.00), 7, 15)
								else
									gui.Draw({23 + if_disp, 358 + pxl}, {196, 23}, imgui.ImVec4(0.25, 0.25, 0.25, 1.00), 7, 15)
								end
							end
							gui.Text(52 + if_disp, 362 + pxl, 'Добавить новый вариант', font[3])
							gui.FaText(27 + if_disp, 361 + pxl, fa.CIRCLE_PLUS, fa_font[4], imgui.ImVec4(0.30, 0.75, 0.39, 1.00))
						else
							imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
							gui.Text(52 + if_disp, 362 + pxl, 'Добавить новый вариант', font[3])
							imgui.PopStyleColor(1)
							gui.FaText(27 + if_disp, 361 + pxl, fa.CIRCLE_PLUS, fa_font[4], imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
						end
					end
					
					pxl = pxl + 115
					if not optimization then
						add_action_other(272 + pxl, i)
					end
				elseif bl_cmd.act[i][1] == 'IF' then
					local param_plus = 0
					if bl_cmd.act[i][2] ~= 1 and not bl_cmd.act[i][6] then
						param_plus = 36
					end
					if not optimization then
						gui.DrawBox({16 + if_disp, 288 + pxl}, {808 - if_disp, 31 + param_plus}, cl.tab, cl.line, 7, 15)
						gui.Draw({21 + if_disp, 293 + pxl}, {21, 21}, imgui.ImVec4(0.56, 0.56, 0.58, 1.00), 3, 15)
						--gui.FaText(23 + 2 + if_disp, 295 + pxl, fa.ARROWS_CROSS, fa_font[3], imgui.ImVec4(0.90, 0.90, 0.90, 1.00))
						imgui.SetCursorPos(imgui.ImVec2(16 + if_disp, 288 + pxl))
						if imgui.InvisibleButton('##TOGGLE_COLLAPSE' .. i, imgui.ImVec2(21, 31)) then
							bl_cmd.act[i][6] = not bl_cmd.act[i][6]
						end
						local collapse_icon = bl_cmd.act[i][6] and fa.SQUARE_PLUS or fa.SQUARE_MINUS
						gui.FaText(18 + if_disp, 290 + pxl, collapse_icon, fa_font[4], imgui.ImVec4(0.90, 0.90, 0.90, 1.00))
						gui.Text(50 + if_disp, 295 + pxl, 'Если', font[3])
						if bl_cmd.act[i][6] then
							local hidden_lines = 0
							local nesting_level = 1
							for j = i + 1, #bl_cmd.act do
								if bl_cmd.act[j][1] == 'IF' then
									nesting_level = nesting_level + 1
								elseif bl_cmd.act[j][1] == 'END' then
									nesting_level = nesting_level - 1
								end
								if nesting_level == 0 then break end
								hidden_lines = hidden_lines + 1
							end
							local text_to_display = '... (' .. hidden_lines .. ' строк)'
							local text_size = imgui.CalcTextSize(u8(text_to_display))
							imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50, 0.50, 0.50, 0.70))
							gui.Text(734 - text_size.x - if_disp, 295 + pxl, text_to_display, font[3])
							imgui.PopStyleColor(1)
						end
						if bl_cmd.act[i][2] ~= 1 and not bl_cmd.act[i][6] then
							gui.DrawLine({16 + if_disp, 319 + pxl}, {824, 319 + pxl}, cl.line)
						end
						if AddMoveButtons(i, pxl) then break end
						if remove_action(pxl, i) then
							local remove_array = {i}
							for j = 1, #bl_cmd.act do
								if bl_cmd.act[j][1] == 'ELSE' then
									if bl_cmd.act[j][2] == bl_cmd.act[i][4] then
										table.insert(remove_array, j)
									end
								elseif bl_cmd.act[j][1] == 'END' then
									if bl_cmd.act[j][2] == bl_cmd.act[i][4] then
										table.insert(remove_array, j)
									end
								end
							end
							table.sort(remove_array, function(a, b) return a > b end)
							for _, index in ipairs(remove_array) do
								table.remove(bl_cmd.act, index)
							end
							break
						end
						local param_edit = bl_cmd.act[i][2]
						bl_cmd.act[i][2] = gui.ListTableMove({265 + if_disp, 295 + pxl}, {u8'Входные данные', u8'В диалоге выбран вариант', u8'Сравнение аргумента', u8'Сравнение переменной'}, bl_cmd.act[i][2], 'Select if' .. i)
						if param_edit ~= bl_cmd.act[i][2] then
							if bl_cmd.act[i][2] == 2 then
								bl_cmd.act[i][3] = {'', '1'}
							else
								bl_cmd.act[i][3] = {'', ''}
							end
						end
						if not bl_cmd.act[i][6] then
							if bl_cmd.act[i][2] == 2 then
								gui.Text(26 + if_disp, 329 + pxl, 'Имя диалога', font[3])
								bl_cmd.act[i][3][1] = gui.InputText({127 + if_disp, 331 + pxl}, 120, bl_cmd.act[i][3][1], u8'Имя диалога' .. i, 20, u8'Имя диалога', 'esp')
								gui.Text(300 + if_disp, 329 + pxl, 'Выбранный вариант', font[3])
								local param_opt = tonumber(bl_cmd.act[i][3][2])
								param_opt = gui.Counter({460 + if_disp, 329 + pxl}, tostring(param_opt), param_opt, 1, 99, u8'Выбранный вариант' .. i)
								bl_cmd.act[i][3][2] = tostring(param_opt)
							elseif bl_cmd.act[i][2] == 3 then
								gui.Text(26 + if_disp, 329 + pxl, 'Имя аргумента', font[3])
								bl_cmd.act[i][3][1] = gui.InputText({139 + if_disp, 331 + pxl}, 120, bl_cmd.act[i][3][1], u8'Имя аргумента ' .. i, 20, u8'Имя аргумента', 'esp')
								gui.Text(389 + if_disp, 329 + pxl, 'Значение', font[3])
								bl_cmd.act[i][3][2] = gui.InputText({467 + if_disp, 331 + pxl}, 336 - if_disp, bl_cmd.act[i][3][2], u8'Значение равенства arg' .. i, 500, u8'Значение')
								bl_cmd.act[i][5] = gui.ListTableMove({600 + if_disp, 295 + pxl}, {u8'Аргумент равен', u8'Аргумент больше, чем значение', u8'Аргумент больше или равняется значению', u8'Аргумент меньше значения', u8'Аргумент меньше или равняется значению', u8'Аргумент не равен значению'}, bl_cmd.act[i][5], 'Select Equality Values Arg' .. i)
							elseif bl_cmd.act[i][2] == 4 then
								gui.Text(26 + if_disp, 329 + pxl, 'Имя переменной', font[3])
								bl_cmd.act[i][3][1] = gui.InputText({151 + if_disp, 331 + pxl}, 120, bl_cmd.act[i][3][1], u8'Имя переменной ' .. i, 20, u8'Имя переменной', 'esp')
								gui.Text(389 + if_disp, 329 + pxl, 'Значение', font[3])
								bl_cmd.act[i][3][2] = gui.InputText({467 + if_disp, 331 + pxl}, 336 - if_disp, bl_cmd.act[i][3][2], u8'Значение равенства var' .. i, 500, u8'Значение')
								bl_cmd.act[i][5] = gui.ListTableMove({600 + if_disp, 295 + pxl}, {u8'Переменная равна', u8'Переменная больше, чем значение', u8'Переменная больше или равняется значению', u8'Переменная меньше значения', u8'Переменная меньше или равняется значению', u8'Переменная не равна значению'}, bl_cmd.act[i][5], 'Select Equality Values Var' .. i)
							end
						end
					end
					if bl_cmd.act[i][6] then 
						collapsed_level = 1
						pxl = pxl + 47
					else
						pxl = pxl + 47 + param_plus
						if_disp = if_disp + 24
						num_el_if = num_el_if + 1
					end
					if not optimization and not bl_cmd.act[i][6] then
						add_action_other(272 + pxl, i)
					end
				elseif bl_cmd.act[i][1] == 'ELSE' then
					local bool_if_disp = 0
					if if_disp > 0 and num_el_if <= 7 then
						bool_if_disp = if_disp - 24
					elseif num_el_if > 7 then
						bool_if_disp = 168
					end
					if not optimization then
						gui.DrawBox({16 + bool_if_disp, 288 + pxl}, {808 - bool_if_disp, 31}, cl.tab, cl.line, 7, 15)
						gui.Draw({21 + bool_if_disp, 293 + pxl}, {21, 21}, imgui.ImVec4(0.56, 0.56, 0.58, 1.00), 3, 15)
						gui.FaText(23 + 2 + bool_if_disp, 295 + pxl, fa.ARROWS_CROSS, fa_font[3], imgui.ImVec4(0.90, 0.90, 0.90, 1.00))
						gui.Text(50 + bool_if_disp, 295 + pxl, 'Иначе', font[3])
					end
					
					pxl = pxl + 47
					if not optimization then
						add_action_other(272 + pxl, i)
					end
				elseif bl_cmd.act[i][1] == 'END' then
					if if_disp > 0 and num_el_if <= 7 then
						if_disp = if_disp - 24
					end
					num_el_if = num_el_if - 1
					if not optimization then
						gui.DrawBox({16 + if_disp, 288 + pxl}, {808 - if_disp, 31}, cl.tab, cl.line, 7, 15)
						gui.Draw({21 + if_disp, 293 + pxl}, {21, 21}, imgui.ImVec4(0.56, 0.56, 0.58, 1.00), 3, 15)
						gui.FaText(23 + 2 + if_disp, 295 + pxl, fa.ARROWS_CROSS, fa_font[3], imgui.ImVec4(0.90, 0.90, 0.90, 1.00))
						gui.Text(50 + if_disp, 295 + pxl, 'Конец условия', font[3])
					end
					
					pxl = pxl + 47
					if not optimization then
						add_action_other(272 + pxl, i)
					end
				elseif bl_cmd.act[i][1] == 'STOP' then
					if not optimization then
						gui.DrawBox({16 + if_disp, 288 + pxl}, {808 - if_disp, 31}, cl.tab, cl.line, 7, 15)
						gui.Draw({21 + if_disp, 293 + pxl}, {21, 21}, imgui.ImVec4(0.56, 0.56, 0.58, 1.00), 3, 15)
						gui.FaText(23 + 1 + if_disp, 295 + pxl, fa.HAND, fa_font[3], imgui.ImVec4(0.90, 0.90, 0.90, 1.00))
						gui.Text(50 + if_disp, 295 + pxl, 'Остановить отыгровку', font[3])
						if AddMoveButtons(i, pxl) then break end
						if remove_action(pxl, i) then
							table.remove(bl_cmd.act, i)
							break
						end
					end
					
					pxl = pxl + 47
					if not optimization then
						add_action_other(272 + pxl, i)
					end
				elseif bl_cmd.act[i][1] == 'COMMENT' then
					if not optimization then
						gui.DrawBox({16 + if_disp, 288 + pxl}, {808 - if_disp, 61}, cl.tab, cl.line, 7, 15)
						gui.Draw({21 + if_disp, 293 + pxl}, {21, 21}, imgui.ImVec4(1.00, 0.58, 0.00, 1.00), 3, 15)
						gui.DrawLine({16 + if_disp, 319 + pxl}, {824, 319 + pxl}, cl.line)
						gui.FaText(23 + 1 + if_disp, 295 - 1 + pxl, fa.COMMENT, fa_font[3], imgui.ImVec4(0.90, 0.90, 0.90, 1.00))
						gui.Text(50 + if_disp, 295 + pxl, 'Комментарий', font[3])
						if AddMoveButtons(i, pxl) then break end
						if remove_action(pxl, i) then
							table.remove(bl_cmd.act, i)
							break
						end
						
						imgui.PushFont(font[3])
						local txt_inp_buf = imgui.new.char[600](bl_cmd.act[i][2])
						imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImVec4(0.30, 0.30, 0.30, 0.00))
						imgui.SetCursorPos(imgui.ImVec2(27 + if_disp, 326 + pxl))
						imgui.PushItemWidth(786 - if_disp)
						imgui.InputText('##COMMENT' .. i, txt_inp_buf, ffi.sizeof(txt_inp_buf))
						if bl_cmd.act[i][2] == '' then
							imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
							gui.Text(29 + if_disp, 326 + pxl, 'Текст', font[3])
							imgui.PopStyleColor(1)
						end
						imgui.PopItemWidth()
						bl_cmd.act[i][2] = ffi.string(txt_inp_buf)
						imgui.PopStyleColor(1)
						imgui.SetCursorPos(imgui.ImVec2(27 + if_disp, 326 + pxl))
						imgui.PopFont()
					end
					
					pxl = pxl + 77
					if not optimization then
						add_action_other(272 + pxl, i)
					end
				elseif bl_cmd.act[i][1] == 'DELAY' then
					if not optimization then
						gui.DrawBox({16 + if_disp, 288 + pxl}, {808 - if_disp, 31}, cl.tab, cl.line, 7, 15)
						gui.Draw({21 + if_disp, 293 + pxl}, {21, 21}, imgui.ImVec4(1.00, 0.50, 0.88, 1.00), 3, 15)
						gui.FaText(23 + 1 + if_disp, 295 + pxl, fa.CLOCK_ROTATE_LEFT, fa_font[3], imgui.ImVec4(0.90, 0.90, 0.90, 1.00))
						gui.Text(50 + if_disp, 295 + pxl, 'Изменить задержку проигрывания отыгровки', font[3])
						local bool_new_delay = imgui.new.float(bl_cmd.act[i][2])
						local new_delay_value = gui.SliderBar('##Изменить задержку отыгровки ' .. i, bool_new_delay, 0.5, 20, 180, {554, 292 + pxl})
						if new_delay_value ~= bl_cmd.act[i][2] then
							bl_cmd.act[i][2] = round(new_delay_value, 1)
							delay_act_def = bl_cmd.act[i][2]
						end
						gui.Text(496, 295 + pxl, tostring(bl_cmd.act[i][2]) .. ' сек.', font[3])
						if AddMoveButtons(i, pxl) then break end
						if remove_action(pxl, i) then
							table.remove(bl_cmd.act, i)
							break
						end
					end
					
					pxl = pxl + 47
					if not optimization then
						add_action_other(272 + pxl, i)
					end
				elseif bl_cmd.act[i][1] == 'SEND_DIALOG' then
					if not optimization then
						gui.DrawBox({16 + if_disp, 288 + pxl}, {808 - if_disp, 61}, cl.tab, cl.line, 7, 15)
						gui.Draw({21 + if_disp, 293 + pxl}, {21, 21}, imgui.ImVec4(0.20, 0.60, 0.80, 1.00), 3, 15)
						gui.DrawLine({16 + if_disp, 319 + pxl}, {824, 319 + pxl}, cl.line)
						gui.FaText(23 + 1 + if_disp, 295 + pxl, fa.PEN_TO_SQUARE, fa_font[3], imgui.ImVec4(0.90, 0.90, 0.90, 1.00))
						gui.Text(50 + if_disp, 295 + pxl, 'Отправить текст в диалог', font[3])
						if AddMoveButtons(i, pxl) then break end
						if remove_action(pxl, i) then
							table.remove(bl_cmd.act, i)
							break
						end

						if gui.Button(u8'Вставить тег...##' .. i, {701, 323 + pxl}, {112, 23}) then
							popup_open_tags = true
							insert_tag_popup[3] = true
							insert_tag_popup[1] = i
						end

						imgui.PushFont(font[3])
						if insert_tag_popup[1] == i and not insert_tag_popup[3] then
							if bl_cmd.act[i][2] ~= '' then
								bl_cmd.act[i][2] = bl_cmd.act[i][2] .. ' ' .. insert_tag_popup[2]
							else
								bl_cmd.act[i][2] = bl_cmd.act[i][2] .. insert_tag_popup[2]
							end
							insert_tag_popup[1] = 0
							insert_tag_popup[2] = ''
						end
						local txt_inp_buf = imgui.new.char[600](bl_cmd.act[i][2])
						imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImVec4(0.30, 0.30, 0.30, 0.00))
						imgui.SetCursorPos(imgui.ImVec2(27 + if_disp, 326 + pxl))
						imgui.PushItemWidth(662 - if_disp)
						imgui.InputText('##SEND_DIALOG_TEXT' .. i, txt_inp_buf, ffi.sizeof(txt_inp_buf))
						if bl_cmd.act[i][2] == '' then
							imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
							gui.Text(29 + if_disp, 326 + pxl, 'Текст', font[3])
							imgui.PopStyleColor(1)
						end
						imgui.PopItemWidth()
						bl_cmd.act[i][2] = ffi.string(txt_inp_buf)
						imgui.PopStyleColor(1)
						imgui.SetCursorPos(imgui.ImVec2(27 + if_disp, 326 + pxl))
						imgui.PopFont()
					end
					pxl = pxl + 77
					if not optimization then
						add_action_other(272 + pxl, i)
					end
				elseif bl_cmd.act[i][1] == 'SELECT_DIALOG_ROW' then
					if not optimization then
						gui.DrawBox({16 + if_disp, 288 + pxl}, {808 - if_disp, 31}, cl.tab, cl.line, 7, 15)
						gui.Draw({21 + if_disp, 293 + pxl}, {21, 21}, imgui.ImVec4(0.20, 0.80, 0.60, 1.00), 3, 15)
						gui.FaText(23 + 1 + if_disp + 4, 295 + pxl, fa.ARROW_POINTER, fa_font[3], imgui.ImVec4(0.90, 0.90, 0.90, 1.00))
						gui.Text(50 + if_disp, 295 + pxl, 'Нажать рядок в диалоге', font[3])
						if AddMoveButtons(i, pxl) then break end
						if remove_action(pxl, i) then
							table.remove(bl_cmd.act, i)
							break
						end

						gui.Text(568 + if_disp, 295 + pxl, 'Номер рядка (от 1):', font[3])
						local bool_set_row = bl_cmd.act[i][2]
						bl_cmd.act[i][2] = gui.InputText({708 + if_disp, 297 + pxl}, 15, bl_cmd.act[i][2], u8'Номер рядка диалога'..i, 5, u8'№', 'num')
						if bl_cmd.act[i][2] == '' then
							bl_cmd.act[i][2] = '0'
						end
					end
					pxl = pxl + 47
					if not optimization then
						add_action_other(272 + pxl, i)
					end
				end
				::continue_loop_render::
			end
		end
		
		--> Варианты действий
		local function add_action(NUM_ACTION, FA, TEXT_ACTION)
			pxl = pxl + 37
			local BOOL = false
			
			imgui.SetCursorPos(imgui.ImVec2(260, 333 + pxl))
			if imgui.InvisibleButton(u8'Добавить действие в команде ' .. NUM_ACTION, imgui.ImVec2(320, 27)) then
				bl_cmd.id_element = bl_cmd.id_element + 1
				BOOL = true
			end
			if imgui.IsItemActive() then
				gui.Draw({261, 333 + pxl}, {318, 29}, cl.bg, 3, 15)
			elseif imgui.IsItemHovered() then
				gui.Draw({261, 333 + pxl}, {318, 29}, cl.bg2, 3, 15)
			end
			
			gui.DrawEmp({260, 332 + pxl}, {320, 31}, cl.line, 5, 15, 1)
			gui.Draw({265, 337 + pxl}, {21, 21}, FA.COLOR_BG, 3, 15)
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.90, 0.90, 0.90, 1.00))
			gui.FaText(267 + FA.SDVIG[1], 339 + FA.SDVIG[2] + pxl, FA.ICON, fa_font[3])
			imgui.PopStyleColor(1)
			gui.Text(294, 339 + pxl, TEXT_ACTION, font[3])
			imgui.PushStyleColor(imgui.Col.Text, cl.def)
			gui.FaText(560, 339 + pxl, fa.PLUS, fa_font[3])
			imgui.PopStyleColor(1)
			
			return BOOL
		end
		
		if #bl_cmd.act == 0 then
			gui.Text(304, 301 + pxl, 'Варианты первого действия', bold_font[1])
			gui.FaText(523, 302 + pxl, fa.ANGLE_DOWN, fa_font[4])
		else
			gui.Text(286, 301 + pxl, 'Варианты следующего действия', bold_font[1])
			gui.FaText(539, 302 + pxl, fa.ANGLE_DOWN, fa_font[4])
		end
		
		pxl = pxl - 35
		if add_action(1, {ICON = fa.SHARE, COLOR_BG = imgui.ImVec4(1.00, 0.58, 0.00, 1.00), SDVIG = {1, 0}}, 'Отправить сообщение в чат') then
			table.insert(bl_cmd.act, {
				'SEND',
				''
			})
		end
		if add_action(2, {ICON = fa.TERMINAL, COLOR_BG = imgui.ImVec4(0.20, 0.60, 0.80, 1.00), SDVIG = {0, 0}}, 'Отправить пользовательскую команду') then
			table.insert(bl_cmd.act, {
				'SEND_CMD',
				'',
				false
			})
			imgui.CloseCurrentPopup()
		end
		if add_action(3, {ICON = fa.KEYBOARD, COLOR_BG = imgui.ImVec4(1.00, 0.30, 0.00, 1.00), SDVIG = {0, 0}}, 'Открыть игровой чат с текстом') then
			table.insert(bl_cmd.act, {
				'OPEN_INPUT',
				''
			})
		end
		if add_action(4, {ICON = fa.HOURGLASS, COLOR_BG = imgui.ImVec4(0.30, 0.75, 0.39, 1.00), SDVIG = {3, 0}}, 'Ожидание нажатия Enter') then
			table.insert(bl_cmd.act, {
				'WAIT_ENTER'
			})
		end
		if add_action(5, {ICON = fa.SHARE_FROM_SQUARE, COLOR_BG = imgui.ImVec4(1.00, 0.58, 0.00, 1.00), SDVIG = {0, 0}}, 'Вывести информацию для себя') then
			table.insert(bl_cmd.act, {
				'SEND_ME',
				''
			})
		end
		if add_action(6, {ICON = fa.SQUARE_ROOT_VARIABLE, COLOR_BG = imgui.ImVec4(0.00, 0.48, 1.00, 1.00), SDVIG = {0, 0}}, 'Задать для переменной') then
			table.insert(bl_cmd.act, {
				'NEW_VAR',
				'', --> Имя переменной
				'' --> Значение переменной
			})
		end
		if add_action(7, {ICON = fa.BARS_STAGGERED, COLOR_BG = imgui.ImVec4(0.69, 0.32, 0.87, 1.00), SDVIG = {1, 0}}, 'Диалог выбора действия') then
			table.insert(bl_cmd.act, {
				'DIALOG',
				'', --> Имя диалога
				{'', ''} --> Варианты действий
			})
		end
		if add_action(8, {ICON = fa.ARROWS_CROSS, COLOR_BG = imgui.ImVec4(0.56, 0.56, 0.58, 1.00), SDVIG = {2, 0}}, 'Если') then
			table.insert(bl_cmd.act, {
				'IF',
				1, --> Условие
				{'', ''}, --> Входные данные,
				bl_cmd.id_element,
				1
			})
			table.insert(bl_cmd.act, {
				'ELSE',
				bl_cmd.id_element
			})
			table.insert(bl_cmd.act, {
				'END',
				bl_cmd.id_element
			})
		end
		if add_action(9, {ICON = fa.CLOCK_ROTATE_LEFT, COLOR_BG = imgui.ImVec4(1.00, 0.50, 0.88, 1.00), SDVIG = {1, 0}}, 'Изменить задержку отыгровки') then
			table.insert(bl_cmd.act, {
				'DELAY',
				delay_act_def
			})
		end
		if add_action(10, {ICON = fa.HAND, COLOR_BG = imgui.ImVec4(0.56, 0.56, 0.58, 1.00), SDVIG = {1, 0}}, 'Остановить отыгровку') then
			table.insert(bl_cmd.act, {
				'STOP'
			})
		end
		if add_action(11, {ICON = fa.COMMENT, COLOR_BG = imgui.ImVec4(1.00, 0.58, 0.00, 1.00), SDVIG = {1, -1}}, 'Комментарий') then
			table.insert(bl_cmd.act, {
				'COMMENT',
				''
			})
		end
		if add_action(12, {ICON = fa.PEN_TO_SQUARE, COLOR_BG = imgui.ImVec4(0.20, 0.60, 0.80, 1.00), SDVIG = {0, 0}}, 'Отправить текст в диалог') then
			table.insert(bl_cmd.act, {
				'SEND_DIALOG',
				''
			})
		end
		if add_action(13, {ICON = fa.ARROW_POINTER, COLOR_BG = imgui.ImVec4(0.20, 0.80, 0.60, 1.00), SDVIG = {5, 0}}, 'Нажать рядок в диалоге') then
			table.insert(bl_cmd.act, {
				'SELECT_DIALOG_ROW',
				'1'
			})
		end
		imgui.Dummy(imgui.ImVec2(0, 17))
		new_action_popup()
		tags_in_cmd()
		imgui.EndChild()
	end
end

