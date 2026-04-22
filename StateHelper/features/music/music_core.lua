--[[
Open with encoding: CP1251
StateHelper/features/music/music_core.lua
]]

function hall.music()
	local color_ItemActive = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
	local color_ItemHovered = imgui.ImVec4(0.24, 0.24, 0.24, 1.00)
	if setting.cl == 'White' then
		color_ItemActive = imgui.ImVec4(0.78, 0.78, 0.78, 1.00)
		color_ItemHovered = imgui.ImVec4(0.83, 0.83, 0.83, 1.00)
	end
	imgui.SetCursorPos(imgui.ImVec2(4, 39))
	imgui.BeginChild(u8'Музыка', imgui.ImVec2(840, 369), false, imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollWithMouse)
	imgui.Scroller(u8'Музыка', img_step[1][0], img_duration[1][0], imgui.HoveredFlags.AllowWhenBlockedByActiveItem)
	
	local name_record = {'Record', 'Megamix', 'Party 24/7', 'Phonk', 'Гоп FM', 'Руки Вверх', 'Dupstep', 'Big Hits', 'Organic', 'Russian Hits'}
	local name_radio = {'Европа Плюс', 'DFM', 'Шансон', 'Радио Дача', 'Дорожное', 'Маяк', 'Наше', 'LoFi Hip-Hop', 'Максимум', '90s Eurodance'}
	local function DrawShadow(pos_draw, size_imvec2, col_shadow_imvec4, radius_draw, flag_draw, shadow_offset, shadow_steps)
		imgui.SetCursorPos(imgui.ImVec2(0, 0))
		local p = imgui.GetCursorScreenPos()
		local draw_list = imgui.GetWindowDrawList()
		local base_x, base_y = p.x + pos_draw[1], p.y + pos_draw[2]
		local width, height = size_imvec2[1], size_imvec2[2]

		for i = 1, shadow_steps do
			local alpha = col_shadow_imvec4.w * (1 - i / shadow_steps)
			local shadow_color = imgui.ImVec4(col_shadow_imvec4.x, col_shadow_imvec4.y, col_shadow_imvec4.z, alpha)
			draw_list:AddRectFilled(
				imgui.ImVec2(base_x - i, base_y - i),
				imgui.ImVec2(base_x + width + i, base_y + height + i),
				imgui.GetColorU32Vec4(shadow_color),
				radius_draw,
				flag_draw
			)
		end
	end
	local function tab_music_switch(table_tab) --tab_music
		local x_posM = 0
		for i = 1, #table_tab do
			imgui.PushFont(bold_font[1])
			local calc_text_music_tab = imgui.CalcTextSize(u8(table_tab[i]))
			imgui.PopFont()
			imgui.SetCursorPos(imgui.ImVec2(24 + x_posM, 10))
			if imgui.InvisibleButton(u8'##Переход к вкладке в музыке' .. i, imgui.ImVec2(calc_text_music_tab.x + 14, 28)) then
				tab_music = i
			end
			if imgui.IsItemHovered() and tab_music ~= i then
				gui.Draw({24 + x_posM, 10}, {calc_text_music_tab.x + 14, 28}, cl.bg, 7, 15)
			end
			if tab_music == i then
				if setting.cl == 'Black' then
					DrawShadow({24 + x_posM, 10}, {calc_text_music_tab.x + 14, 28}, imgui.ImVec4(0.20, 0.20, 0.20, 0.3), 14, 15, 5, 9)
				else
					DrawShadow({24 + x_posM, 10}, {calc_text_music_tab.x + 14, 28}, imgui.ImVec4(0.80, 0.80, 0.80, 0.3), 14, 15, 5, 9)
				end
				gui.Draw({24 + x_posM, 10}, {calc_text_music_tab.x + 14, 28}, cl.bg2, 7, 15)
			end
			gui.Text(31 + x_posM, 14, table_tab[i], bold_font[1])
			
			x_posM = x_posM + calc_text_music_tab.x + 65
		end
	end
	--tab_music_switch({'Поиск в интернете', 'Избранные', 'Радио Рекорд', 'Другие радио', 'Настройки'})
	
	local function InputTextForMusic(pos_draw, size_input, arg_text, name_input, buf_size_input, text_about)
		local arg_text_buf = imgui.new.char[buf_size_input](arg_text or '')
		local col_stand_imvec4 = cl.bg
		local bool_return_true = false
		
		gui.Draw({pos_draw[1], pos_draw[2] - 5}, {size_input, 25}, col_stand_imvec4, 7, 5)
		imgui.SetCursorPos(imgui.ImVec2(pos_draw[1] + size_input, pos_draw[2] - 5))
		if imgui.InvisibleButton(u8'##Поиск в интернете', imgui.ImVec2(39, 25)) then
			bool_return_true = true
		end
		if imgui.IsItemActive() then
			gui.Draw({pos_draw[1] + size_input, pos_draw[2] - 5}, {39, 25}, cl.bg, 7, 10)
		else
			gui.Draw({pos_draw[1] + size_input, pos_draw[2] - 5}, {39, 25}, cl.bg2, 7, 10)
		end
		imgui.SetCursorPos(imgui.ImVec2(pos_draw[1] + size_input + 13, pos_draw[2]))
		imgui.PushFont(fa_font[2])
		imgui.Text(fa.MAGNIFYING_GLASS)
		imgui.PopFont()
		
		
		imgui.SetCursorPos(imgui.ImVec2(pos_draw[1] + 6, pos_draw[2] - 1))
		imgui.PushItemWidth(size_input - 6)
		
		if not bool_return_true then
			bool_return_true = imgui.InputText('##inp' .. name_input, arg_text_buf, ffi.sizeof(arg_text_buf), imgui.InputTextFlags.EnterReturnsTrue)
		else
			imgui.InputText('##inp' .. name_input, arg_text_buf, ffi.sizeof(arg_text_buf))
		end
		
		if text_about ~= nil and (ffi.string(arg_text_buf) == '' and not imgui.IsItemActive()) then
			imgui.SetCursorPos(imgui.ImVec2(pos_draw[1] + 23, pos_draw[2] - 1))
			imgui.PushFont(font[3])
			imgui.TextColored(imgui.ImVec4(0.50, 0.50, 0.50, 0.50), text_about)
			imgui.PopFont()
			
			imgui.SetCursorPos(imgui.ImVec2(pos_draw[1] + 5, pos_draw[2] - 1))
			imgui.PushFont(fa_font[2])
			imgui.TextColored(imgui.ImVec4(0.50, 0.50, 0.50, 0.50), fa.MAGNIFYING_GLASS)
			imgui.PopFont()
		end
		
		
		return ffi.string(arg_text_buf), bool_return_true
	end
	
	local function tab_music_list(table_tab)
		local y_posM = 0
		for i = 1, #table_tab do
			imgui.SetCursorPos(imgui.ImVec2(6, 11 + y_posM))
			if imgui.InvisibleButton(u8'##Переход к вкладке в музыке' .. i, imgui.ImVec2(131, 27)) then
				tab_music = i
			end
			if imgui.IsItemHovered() and tab_music ~= i then
				gui.Draw({6, 11 + y_posM}, {131, 27}, cl.bg, 7, 15)
			end
			if tab_music == i then
				gui.Draw({6, 11 + y_posM}, {131, 27}, cl.bg2, 7, 15)
			end
		
			imgui.PushFont(font[3])
			imgui.SetCursorPos(imgui.ImVec2(38, 16 + y_posM))
			--gui.Text(26, 16 + y_posM, table_tab[i], font[3])
			if tab_music ~= i then
				if setting.cl == 'Black' then
					imgui.TextColored(imgui.ImVec4(0.60, 0.60, 0.60, 1.00), u8(table_tab[i][1]))
				else
					imgui.TextColored(imgui.ImVec4(0.40, 0.40, 0.40, 1.00), u8(table_tab[i][1]))
				end
			else
				gui.Text(38, 16 + y_posM, table_tab[i][1], font[3])
			end
			imgui.PopFont()
			
			imgui.PushFont(fa_font[2])
			imgui.SetCursorPos(imgui.ImVec2(16, 16 + y_posM))
			if i == 4 then
				imgui.SetCursorPos(imgui.ImVec2(15, 16 + y_posM))
			end
			if tab_music ~= i then
				if setting.cl == 'Black' then
					imgui.TextColored(imgui.ImVec4(0.60, 0.60, 0.60, 1.00), table_tab[i][2])
				else
					imgui.TextColored(imgui.ImVec4(0.40, 0.40, 0.40, 1.00), table_tab[i][2])
				end
			else
				imgui.Text(table_tab[i][2])
			end
			
			imgui.PopFont()
			
			y_posM = y_posM + 32
		end
	end
	gui.Draw({0, 0}, {143, 369}, cl.tab)
	tab_music_list({{'Поиск', fa.MAGNIFYING_GLASS}, {'Добавленные', fa.HEART}, {'Плейлисты', fa.LIST}, {'Другие радио', fa.RADIO}, {'Настройки', fa.GEAR}})
	gui.DrawLine({143, 0}, {143, 369}, cl.line)
	if tab_music > 5 then
		tab_music = 5
	end
	
	if tab_music == 1 then
		mus.search, bool_mus_search = InputTextForMusic({159, 17}, 627, mus.search, u8'Поиск музыки в интернете', 256, u8'Введите название трека или исполнителя')
		if bool_mus_search and mus.search ~= '' then
			find_track_link(mus.search, 1)
		end
		gui.DrawLine({156, 49}, {829, 49}, cl.line)
		
		local function select_draw(m, y_pos_tra, tab_cl, track_is_playing_now, added_track)
			gui.Draw({8, 6 + y_pos_tra}, {675, 37}, tab_cl, 7, 15)
			
			imgui.SetCursorPos(imgui.ImVec2(638, 13 + y_pos_tra))
			
			if imgui.InvisibleButton(u8'##Добавить в избранное' .. m, imgui.ImVec2(24, 24)) then
				if added_track then
					for k = 1, #setting.tracks do
						if setting.tracks[k].link == tracks[m].link then
							table.remove(setting.tracks, k)
							break
						end
					end
				else
					table.insert(setting.tracks, tracks[m])
				end
				save()
			end
			imgui.SetItemAllowOverlap()
			if track_is_playing_now then
				if imgui.IsItemHovered() and not imgui.IsItemActive() then
					if an[22][4] < 1.00 then
						an[22][4] = an[22][4] + (anim * 3)
					end
				else
					if an[22][4] > 0 then
						an[22][4] = an[22][4] - (anim * 3)
					end
				end
			else
				if imgui.IsItemActive() or imgui.IsItemHovered() then
					if an[22][5] < 1.00 then
						an[22][5] = an[22][5] + (anim * 3)
					end
				else
					if an[22][5] > 0 then
						an[22][5] = an[22][5] - (anim * 3)
					end
				end
			end
			local fa_heart = added_track and fa.HEART_CRACK or fa.HEART
			imgui.PushFont(fa_font[3])
			imgui.SetCursorPos(imgui.ImVec2(645, 16 + y_pos_tra))
			imgui.TextColored(imgui.ImVec4(0.50, 0.50, 0.50, 0.50), fa_heart)
			imgui.SetCursorPos(imgui.ImVec2(645, 16 + y_pos_tra))
			if track_is_playing_now then
				imgui.TextColored(imgui.ImVec4(1.00, 0.10, 0.00, an[22][4]), fa_heart)
			else
				imgui.TextColored(imgui.ImVec4(1.00, 0.10, 0.00, an[22][5]), fa_heart)
			end
			imgui.PopFont()
		end
		
		if #tracks ~= 0 and tracks[1] and tracks[1].artist ~= 'Ошибка404' then
			local height = (play.status == 'NULL') and 319 or 264
			imgui.SetCursorPos(imgui.ImVec2(144, 50))
			imgui.BeginChild(u8'Лист найденных треков', imgui.ImVec2(694, height), false, imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollWithMouse)
			imgui.Scroller(u8'Лист найденных треков', img_step[1][0], img_duration[1][0], imgui.HoveredFlags.AllowWhenBlockedByActiveItem)
			local y_pos_tr = 0
			for m = 1, #tracks do
				local added_track = false
				if #setting.tracks ~= 0 then
					for t = 1, #setting.tracks do
						if setting.tracks[t].link  == tracks[m].link then
							added_track = true
							break
						end
					end
				end
				local track_is_playing_now = play.status ~= 'NULL' and play.tab == 'SEARCH' and play.info and play.info.link and tracks[m].link == play.info.link
				local bool_hovered = false
				imgui.SetCursorPos(imgui.ImVec2(8, 6 + y_pos_tr))
				if imgui.InvisibleButton(u8'##Включить трек' .. m, imgui.ImVec2(632, 37)) then
					if not track_is_playing_now then
						play_song(tracks[m], play.repeat_track == 2, m, 'SEARCH')
					end
				end
				if imgui.IsItemActive() and not track_is_playing_now then
					select_draw(m, y_pos_tr, cl.bg2, track_is_playing_now, added_track)
					bool_hovered = true
				elseif imgui.IsItemHovered() and not track_is_playing_now then
					select_draw(m, y_pos_tr, cl.tab, track_is_playing_now, added_track)
					bool_hovered = true
				elseif track_is_playing_now then
					select_draw(m, y_pos_tr, cl.bg2, track_is_playing_now, added_track)
				else
					imgui.PushFont(font[3])
					local calc_time = imgui.CalcTextSize(tracks[m].time)
					imgui.SetCursorPos(imgui.ImVec2(670 - calc_time.x, 16 + y_pos_tr))
					imgui.TextColored(imgui.ImVec4(0.50, 0.50, 0.50, 0.50), tracks[m].time)
					imgui.PopFont()
				end
				
				imgui.SetCursorPos(imgui.ImVec2(640, 6 + y_pos_tr))
				if imgui.InvisibleButton(u8'##Пустая кнопка' .. m, imgui.ImVec2(43, 37)) then
					if added_track then
						for k = 1, #setting.tracks do
							if setting.tracks[k].link == tracks[m].link then
								table.remove(setting.tracks, k)
								break
							end
						end
					else
						table.insert(setting.tracks, tracks[m])
					end
				end
				if imgui.IsItemHovered() and not track_is_playing_now then
					select_draw(m, y_pos_tr, cl.tab, track_is_playing_now, added_track)
				elseif not bool_hovered and not track_is_playing_now then
					imgui.PushFont(font[3])
					local calc_time = imgui.CalcTextSize(tracks[m].time)
					imgui.SetCursorPos(imgui.ImVec2(670 - calc_time.x, 16 + y_pos_tr))
					imgui.TextColored(imgui.ImVec4(0.50, 0.50, 0.50, 0.50), tracks[m].time)
					imgui.PopFont()
				end
				
				if m <= 9 then
					imgui.SetCursorPos(imgui.ImVec2(17, 16 + y_pos_tr))
				else
					imgui.SetCursorPos(imgui.ImVec2(15, 16 + y_pos_tr))
				end
				imgui.PushFont(font[3])
				imgui.TextColored(imgui.ImVec4(0.50, 0.50, 0.50, 0.50), tostring(m))
				imgui.PopFont()
				local artist_and_name, newline_count = wrapText(tracks[m].artist .. ' - ' .. tracks[m].name, 78, 78)
				gui.Text(43, 16 + y_pos_tr, artist_and_name, font[3])
				
				y_pos_tr = y_pos_tr + 40
			end
			imgui.Dummy(imgui.ImVec2(0, 20))
			imgui.EndChild()
		elseif tracks[1] and tracks[1].artist == 'Ошибка404' then
			if setting.cl == 'White' then
				imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.40, 0.40, 0.40, 0.50))
			else
				imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
			end
			if play.status ~= 'NULL' then
				gui.Text(345, 162, 'Ничего не найдено', bold_font[3])
			else
				gui.Text(345, 189, 'Ничего не найдено', bold_font[3])
				
			end
			imgui.PopStyleColor(1)
		end
	elseif tab_music == 2 then
		local function select_draw(m, y_pos_tra, tab_cl, track_is_playing_now)
			gui.Draw({8, 6 + y_pos_tra}, {675, 37}, tab_cl, 7, 15)
			
			imgui.SetCursorPos(imgui.ImVec2(638, 13 + y_pos_tra))
			
			if imgui.InvisibleButton(u8'##Убрать из избранных' .. m, imgui.ImVec2(24, 24)) then
				table.remove(setting.tracks, m)
				save()
				return true
			end
			imgui.SetItemAllowOverlap()
			if track_is_playing_now then
				if imgui.IsItemHovered() and not imgui.IsItemActive() then
					if an[22][4] < 1.00 then
						an[22][4] = an[22][4] + (anim * 3)
					end
				else
					if an[22][4] > 0 then
						an[22][4] = an[22][4] - (anim * 3)
					end
				end
			else
				if imgui.IsItemActive() or imgui.IsItemHovered() then
					if an[22][5] < 1.00 then
						an[22][5] = an[22][5] + (anim * 3)
					end
				else
					if an[22][5] > 0 then
						an[22][5] = an[22][5] - (anim * 3)
					end
				end
			end
			imgui.PushFont(fa_font[3])
			imgui.SetCursorPos(imgui.ImVec2(645, 16 + y_pos_tra))
			imgui.TextColored(imgui.ImVec4(0.50, 0.50, 0.50, 0.50), fa.TRASH_XMARK)
			imgui.SetCursorPos(imgui.ImVec2(645, 16 + y_pos_tra))
			if track_is_playing_now then
				imgui.TextColored(imgui.ImVec4(1.00, 0.10, 0.00, an[22][4]), fa.TRASH_XMARK)
			else
				imgui.TextColored(imgui.ImVec4(1.00, 0.10, 0.00, an[22][5]), fa.TRASH_XMARK)
			end
			imgui.PopFont()
		end
		
		if #setting.tracks ~= 0 then
			local height = (play.status == 'NULL') and 369 or 314
			imgui.SetCursorPos(imgui.ImVec2(144, 0))
			imgui.BeginChild(u8'Лист добавленных треков', imgui.ImVec2(694, height), false, imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollWithMouse)
			imgui.Scroller(u8'Лист добавленных треков', img_step[1][0], img_duration[1][0], imgui.HoveredFlags.AllowWhenBlockedByActiveItem)
			local y_pos_tr = 0
			for m = 1, #setting.tracks do
				local break_bool = false
				local track_is_playing_now = play.status ~= 'NULL' and play.tab == 'ADD' and play.info and play.info.link and setting.tracks[m].link == play.info.link
				local bool_hovered = false
				imgui.SetCursorPos(imgui.ImVec2(8, 6 + y_pos_tr))
				if imgui.InvisibleButton(u8'##Включить трек' .. m, imgui.ImVec2(632, 37)) then
					if not track_is_playing_now then
						play_song(setting.tracks[m], play.repeat_track == 2, m, 'ADD')
					end
				end
				if imgui.IsItemActive() and not track_is_playing_now then
					if select_draw(m, y_pos_tr, cl.bg2, track_is_playing_now) then break end
					bool_hovered = true
				elseif imgui.IsItemHovered() and not track_is_playing_now then
					if select_draw(m, y_pos_tr, cl.bg2, track_is_playing_now) then break end
					bool_hovered = true
				elseif track_is_playing_now then
					if select_draw(m, y_pos_tr, cl.bg2, track_is_playing_now) then break end
				else
					imgui.PushFont(font[3])
					local calc_time = imgui.CalcTextSize(setting.tracks[m].time)
					imgui.SetCursorPos(imgui.ImVec2(670 - calc_time.x, 16 + y_pos_tr))
					imgui.TextColored(imgui.ImVec4(0.50, 0.50, 0.50, 0.50), setting.tracks[m].time)
					imgui.PopFont()
				end
				
				imgui.SetCursorPos(imgui.ImVec2(640, 6 + y_pos_tr))
				if imgui.InvisibleButton(u8'##Пустая кнопка' .. m, imgui.ImVec2(43, 37)) then
					table.remove(setting.tracks, m)
					break
				end
				if imgui.IsItemHovered() and not track_is_playing_now then
					if select_draw(m, y_pos_tr, cl.bg2, track_is_playing_now) then break end
				elseif not bool_hovered and not track_is_playing_now then
					imgui.PushFont(font[3])
					local calc_time = imgui.CalcTextSize(setting.tracks[m].time)
					imgui.SetCursorPos(imgui.ImVec2(670 - calc_time.x, 16 + y_pos_tr))
					imgui.TextColored(imgui.ImVec4(0.50, 0.50, 0.50, 0.50), setting.tracks[m].time)
					imgui.PopFont()
				end
				
				if m <= 9 then
					imgui.SetCursorPos(imgui.ImVec2(17, 16 + y_pos_tr))
				else
					imgui.SetCursorPos(imgui.ImVec2(15, 16 + y_pos_tr))
				end
				imgui.PushFont(font[3])
				imgui.TextColored(imgui.ImVec4(0.50, 0.50, 0.50, 0.50), tostring(m))
				imgui.PopFont()
				local artist_and_name, newline_count = wrapText(setting.tracks[m].artist .. ' - ' .. setting.tracks[m].name, 78, 78)
				gui.Text(43, 16 + y_pos_tr, artist_and_name, font[3])
				
				y_pos_tr = y_pos_tr + 40
			end
			imgui.Dummy(imgui.ImVec2(0, 20))
			imgui.EndChild()
		else
			if setting.cl == 'White' then
				imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.40, 0.40, 0.40, 0.50))
			else
				imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
			end
			gui.Text(445, 164, 'Пусто', bold_font[3])
			imgui.PopStyleColor(1)
		end
	elseif tab_music == 3 then
		if setting.cl == 'White' then
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.40, 0.40, 0.40, 0.50))
		else
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
		end
		gui.Text(407, 164, 'В разработке', bold_font[3])
		gui.FaText(371, 170, fa.HAMMER, fa_font[5])
		imgui.PopStyleColor(1)
		--[[
		local pos_sheet = {x = 160, y = 15} -- Размеры карточки: 154 x 162
		
		if #setting.playlist ~= 0 then
			for i = 1, #setting.playlist do
				
				
				if pos_sheet.x ~= 670 then
					pos_sheet.x = pos_sheet.x + 170
				else
					pos_sheet.x = 160
					pos_sheet.y = pos_sheet.y + 177
				end
			end
		end
		
		
		imgui.SetCursorPos(imgui.ImVec2(pos_sheet.x, pos_sheet.y))
		if imgui.InvisibleButton(u8'##Создать плейлист', imgui.ImVec2(154, 162)) then
			local playlist_info = {
				name = 'Плейлист ' .. (#setting.playlist + 1),
				color = 1,
				tracks = {}
			}
			table.insert(setting.playlist, playlist_info)
		end
		if imgui.IsItemActive() then
			gui.Draw({pos_sheet.x, pos_sheet.y}, {154, 162}, cl.def, 7, 15)
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.95, 0.95, 0.95, 1.00))
			gui.Text(pos_sheet.x + 35, pos_sheet.y + 72, 'Новый плейлист', font[3])
			gui.FaText(pos_sheet.x + 15, pos_sheet.y + 71, fa.CIRCLE_PLUS, fa_font[3])
			imgui.PopStyleColor(1)
		else
			gui.Draw({pos_sheet.x, pos_sheet.y}, {154, 162}, cl.tab, 7, 15)
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.40, 0.40, 0.40, 1.00))
			gui.Text(pos_sheet.x + 35, pos_sheet.y + 72, 'Новый плейлист', font[3])
			gui.FaText(pos_sheet.x + 15, pos_sheet.y + 71, fa.CIRCLE_PLUS, fa_font[3])
			imgui.PopStyleColor(1)
		end
		]]
		
	elseif tab_music == 4 then
		local height = (play.status == 'NULL') and 369 or 314
		imgui.SetCursorPos(imgui.ImVec2(144, 0))
		imgui.BeginChild(u8'Радиостанции', imgui.ImVec2(694, height), false, imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollWithMouse)
		
		imgui.SetCursorPos(imgui.ImVec2(0, 0))
		local p_cursor_screen = imgui.GetCursorScreenPos()
		local s_image = imgui.ImVec2(92, 92)
		local radio_link = {
			[1] = 'https://ep128.hostingradio.ru:8030/ep128',
			[2] = 'https://dfm.hostingradio.ru/dfm128.mp3',
			[3] = 'https://chanson.hostingradio.ru:8041/chanson-uncensored128.mp3',
			[4] = 'http://listen.vdfm.ru:8000/dacha',
			[5] = 'http://dorognoe.hostingradio.ru:8000/dorognoe',
			[6] = 'http://icecast.vgtrk.cdnvideo.ru/mayakfm_mp3_192kbps',
			[7] = 'http://nashe1.hostingradio.ru/nashe-128.mp3',
			[8] = 'http://node-33.zeno.fm/0r0xa792kwzuv?rj-ttl=5&rj-tok=AAABfMtdjJ4AtC1pGWo1_ohFMw',
			[9] = 'https://maximum.hostingradio.ru/maximum128.mp3',
			[10] = 'http://listen1.myradio24.com:9000/5967'
		}
		for i = 0, 4 do
			imgui.SetCursorPos(imgui.ImVec2(9 + (i * 137), 9))
			if imgui.InvisibleButton(u8'##Включить радиостанцию' .. i, imgui.ImVec2(128, (height - 27) / 2)) then
				play_song(radio_link[i + 1], true, i + 1, 'RADIO')
			end
			if play.status ~= 'NULL' and play.tab == 'RADIO' and play.i == i + 1 then
				gui.Draw({9 + (i * 137), 9}, {128, (height - 27) / 2}, imgui.ImVec4(0.99, 0.35, 0.12, 0.90), 7, 15)
			else
				if imgui.IsItemActive() then
					gui.Draw({9 + (i * 137), 9}, {128, (height - 27) / 2}, cl.bg, 7, 15)
				else
					gui.Draw({9 + (i * 137), 9}, {128, (height - 27) / 2}, cl.tab, 7, 15)
				end
			end
			local radio_texture = (image_radio and image_radio[i + 1]) or image_no_label
			if radio_texture ~= nil then
				imgui.GetWindowDrawList():AddImageRounded(radio_texture, imgui.ImVec2(p_cursor_screen.x + 27 + (i * 137), p_cursor_screen.y + 20), imgui.ImVec2(p_cursor_screen.x + 27 + (i * 137) + s_image.x, p_cursor_screen.y + 20 + s_image.y), imgui.ImVec2(0, 0), imgui.ImVec2(1, 1), imgui.GetColorU32Vec4(imgui.ImVec4(1.00, 1.00, 1.00, 1.00)), 0)
			end
			
			imgui.PushFont(font[3])
			local calc_radio = imgui.CalcTextSize(u8(name_radio[i + 1]))
			gui.Text(((i + 1) * 137) - 64 - (calc_radio.x / 2), ((height - 27) / 2) - 20, name_radio[i + 1], font[3])
			imgui.PopFont()
		end
		for i = 0, 4 do
			imgui.SetCursorPos(imgui.ImVec2(9 + (i * 137), 18 + ((height - 27) / 2)))
			if imgui.InvisibleButton(u8'##Включить радиостанцию  ' .. i, imgui.ImVec2(128, (height - 27) / 2)) then
				play_song(radio_link[i + 6], true, i + 6, 'RADIO')
			end
			if play.status ~= 'NULL' and play.tab == 'RADIO' and play.i == i + 6 then
				gui.Draw({9 + (i * 137), 18 + ((height - 27) / 2)}, {128, (height - 27) / 2}, imgui.ImVec4(0.99, 0.35, 0.12, 0.90), 7, 15)
			else
				if imgui.IsItemActive() then
					gui.Draw({9 + (i * 137), 18 + ((height - 27) / 2)}, {128, (height - 27) / 2}, cl.bg, 7, 15)
				else
					gui.Draw({9 + (i * 137), 18 + ((height - 27) / 2)}, {128, (height - 27) / 2}, cl.tab, 7, 15)
				end
			end
			local radio_texture = (image_radio and image_radio[i + 6]) or image_no_label
			if radio_texture ~= nil then
				imgui.GetWindowDrawList():AddImageRounded(radio_texture, imgui.ImVec2(p_cursor_screen.x + 27 + (i * 137), p_cursor_screen.y + 29 + ((height - 27) / 2)), imgui.ImVec2(p_cursor_screen.x + 27 + (i * 137) + s_image.x, p_cursor_screen.y + 29 + ((height - 27) / 2) + s_image.y), imgui.ImVec2(0, 0), imgui.ImVec2(1, 1), imgui.GetColorU32Vec4(imgui.ImVec4(1.00, 1.00, 1.00 ,1.00)), 0)
			end
			
			imgui.PushFont(font[3])
			local calc_radio = imgui.CalcTextSize(u8(name_radio[i + 6]))
			gui.Text(((i + 1) * 137) - 64 - (calc_radio.x / 2), height - 18 - 20, name_radio[i + 6], font[3])
			imgui.PopFont()
		end
		
		imgui.EndChild()
	elseif tab_music == 5 then
		gui.Draw({160, 16}, {664, 75}, cl.tab, 7, 15)
		gui.DrawLine({160, 53}, {824, 53}, cl.line)

		gui.Text(170, 26, 'Отображать мини-плеер на экране', font[3])
		imgui.SetCursorPos(imgui.ImVec2(783, 21))
		if gui.Switch(u8'##Отображать мини-плеер на экране', setting.mini_player) then
			setting.mini_player = not setting.mini_player
			save()
		end

		gui.Text(170, 64, 'Изменить местоположение окна', font[3])
		if gui.Button(u8'Изменить...', {713, 60}, {100, 27}) then
			mini_player_position()
		end
		
		imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50, 0.50, 0.50, 1.00))
		gui.Text(170, 98, 'Некоторые сервисы и функции могут быть недоступны в Вашей стране или регионе.', font[2])
		imgui.PopStyleColor(1)
	end
	
	if play.status ~= 'NULL' then
		if setting.cl == 'Black' then
			gui.Draw({0, 314}, {840, 55}, imgui.ImVec4(0.09, 0.09, 0.09, 1.00))
		else
			gui.Draw({0, 314}, {840, 55}, imgui.ImVec4(0.83, 0.83, 0.83, 1.00))
		end
		
		imgui.SetCursorPos(imgui.ImVec2(25, 332))
		if imgui.InvisibleButton(u8'##Переключить на трек назад', imgui.ImVec2(23, 23)) then
			if play.tab ~= 'RECORD' and play.tab ~= 'RADIO' then
				back_track()
			end
		end
		if imgui.IsItemActive() or imgui.IsItemHovered() then
			if an[22][1] < 0.45 then
				an[22][1] = an[22][1] + (anim * 1)
			end
		else
			if an[22][1] > 0 then
				an[22][1] = an[22][1] - (anim * 1)
			end
		end
		
		imgui.SetCursorPos(imgui.ImVec2(60, 332))
		if imgui.InvisibleButton(u8'##Поставить трек на паузу', imgui.ImVec2(23, 23)) then
			set_song_status('PLAY_OR_PAUSE')
		end
		if imgui.IsItemActive() or imgui.IsItemHovered() then
			if an[22][2] < 0.45 then
				an[22][2] = an[22][2] + (anim * 1)
			end
		else
			if an[22][2] > 0 then
				an[22][2] = an[22][2] - (anim * 1)
			end
		end
		
		imgui.SetCursorPos(imgui.ImVec2(95, 332))
		if imgui.InvisibleButton(u8'##Переключить на трек вперёд', imgui.ImVec2(23, 23)) then
			if play.tab ~= 'RECORD' and play.tab ~= 'RADIO' then
				next_track(true)
			end
		end
		if imgui.IsItemActive() or imgui.IsItemHovered() then
			if an[22][3] < 0.45 then
				an[22][3] = an[22][3] + (anim * 1)
			end
		else
			if an[22][3] > 0 then
				an[22][3] = an[22][3] - (anim * 1)
			end
		end
		
		if setting.cl == 'White' then
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 - an[22][1], 0.50 - an[22][1], 0.50 - an[22][1], 1.00))
		else
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 + an[22][1], 0.50 + an[22][1], 0.50 + an[22][1], 1.00))
		end
		gui.FaText(31, 335, fa.BACKWARD_STEP, fa_font[4])
		if setting.cl == 'White' then
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 - an[22][2], 0.50 - an[22][2], 0.50 - an[22][2], 1.00))
		else
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 + an[22][2], 0.50 + an[22][2], 0.50 + an[22][2], 1.00))
		end
		if play.status == 'PLAY' then
			gui.FaText(66, 335, fa.PAUSE, fa_font[4])
		else
			gui.FaText(66, 335, fa.PLAY, fa_font[4])
		end
		if setting.cl == 'White' then
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 - an[22][3], 0.50 - an[22][3], 0.50 - an[22][3], 1.00))
		else
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 + an[22][3], 0.50 + an[22][3], 0.50 + an[22][3], 1.00))
		end
		gui.FaText(101, 335, fa.FORWARD_STEP, fa_font[4])
		imgui.PopStyleColor(3)
		
		local window_pos = imgui.GetCursorScreenPos()
		local mouse_pos_all_screen = imgui.GetMousePos()
		local mouse_pos = mouse_pos_all_screen.x - window_pos.x - 27
		if mouse_pos <= 0 then
			mouse_pos = 0.01
		elseif mouse_pos >= 786 then
			mouse_pos = 785.99
		end
			
		if play.tab ~= 'RECORD' and play.tab ~= 'RADIO' then
			gui.Draw({27, 314}, {786, 4}, imgui.ImVec4(0.21, 0.21, 0.21, 1.00), 20, 15)
			
			
			imgui.SetCursorPos(imgui.ImVec2(27, 314))
			imgui.InvisibleButton(u8'##Перемотка трека', imgui.ImVec2(786, 10))
			if imgui.IsItemActive() then
				gui.Draw({27, 314}, {mouse_pos, 4}, cl.def, 20, 15)
				bool_button_active_music = true
			else
				if bool_button_active_music then
					bool_button_active_music = false
					rewind_song((play.len_time / 786) * mouse_pos)
					gui.Draw({27, 314}, {mouse_pos, 4}, cl.def, 20, 15)
				else
					gui.Draw({27, 314}, {(786 / play.len_time) * play.pos_time, 4}, cl.def, 20, 15)
				end
			end
			if imgui.IsItemHovered() or imgui.IsItemActive() then
				local new_pos_track = format_time(mouse_pos / (786 / play.len_time))
				imgui.SetCursorPos(imgui.ImVec2(mouse_pos - 1, 267))
				imgui.BeginChild(u8'Багфикс предыдущего чайлда', imgui.ImVec2(57, 42), false, imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollWithMouse)
				gui.FaText(10, 4, fa.MESSAGE_MIDDLE, fa_font[6], imgui.ImVec4(0.20, 0.20, 0.20, 1.00))
				gui.FaText(1, 0, fa.SQUARE, fa_font[6], imgui.ImVec4(0.20, 0.20, 0.20, 1.00))
				gui.FaText(24, 0, fa.SQUARE, fa_font[6], imgui.ImVec4(0.20, 0.20, 0.20, 1.00))
				imgui.PushFont(font[2])
				calc_text_time_song = imgui.CalcTextSize(tostring(new_pos_track))
				imgui.PopFont()
				imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1.00, 1.00, 1.00, 1.00))
				gui.Text(44 - calc_text_time_song.x, 11, tostring(new_pos_track), font[2])
				imgui.PopStyleColor(1)
				imgui.EndChild()
			end
		else
			gui.Draw({27, 314}, {786, 4}, cl.def, 20, 15)
		end
		
		draw_gradient_image_music(0.9, 153, 331, 25, 25)
		imgui.SetCursorPos(imgui.ImVec2(145, 323))
		if play.status_image == play.i and play.i ~= 0 then
			local p_cursor_screen = imgui.GetCursorScreenPos()
			local s_image = imgui.ImVec2(41, 41)
			local current_cover = play.image_label or image_no_label
			if current_cover ~= nil then
				imgui.GetWindowDrawList():AddImageRounded(current_cover, p_cursor_screen, imgui.ImVec2(p_cursor_screen.x + s_image.x, p_cursor_screen.y + s_image.y), imgui.ImVec2(0, 0), imgui.ImVec2(1, 1), imgui.GetColorU32Vec4(imgui.ImVec4(1.00, 1.00, 1.00 ,1.00)), 10)
			end
		else
			if image_no_label ~= nil then
				imgui.Image(image_no_label, imgui.ImVec2(41, 41))
			end
		end
		
		if play.tab == 'RECORD' then
			gui.Text(197, 326, name_record[play.i], font[3])
			imgui.PushFont(font[3])
			imgui.SetCursorPos(imgui.ImVec2(197, 344))
			imgui.TextColored(imgui.ImVec4(0.60, 0.60, 0.60, 1.00), u8('Record'))
			imgui.PopFont()
		elseif play.tab == 'RADIO' then
			gui.Text(197, 326, name_radio[play.i], font[3])
			imgui.PushFont(font[3])
			imgui.SetCursorPos(imgui.ImVec2(197, 344))
			imgui.TextColored(imgui.ImVec4(0.60, 0.60, 0.60, 1.00), u8('Radio'))
			imgui.PopFont()
		else
			local track_name, newline_count_2 = wrapText(play.info.name, 75, 75)
			local track_artist, newline_count_2 = wrapText(play.info.artist, 70, 70)
			gui.Text(197, 326, track_name, font[3])
			imgui.PushFont(font[3])
			imgui.SetCursorPos(imgui.ImVec2(197, 344))
			if setting.cl == 'Black' then
				imgui.TextColored(imgui.ImVec4(0.60, 0.60, 0.60, 1.00), u8(track_artist))
			else
				imgui.TextColored(imgui.ImVec4(0.30, 0.30, 0.30, 1.00), u8(track_artist))
			end
			imgui.PopFont()
		end
		imgui.SetCursorPos(imgui.ImVec2(716 - an[23], 332))
		if imgui.InvisibleButton(u8'##Остановить трек', imgui.ImVec2(23, 23)) then
			set_song_status('STOP')
		end
		
		if imgui.IsItemActive() then
			gui.FaText(722 - an[23], 335, fa.STOP, fa_font[4], cl.def)
		else
			gui.FaText(722 - an[23], 335, fa.STOP, fa_font[4], imgui.ImVec4(0.50, 0.50, 0.50, 1.00))
		end
		if play.tab ~= 'RECORD' and play.tab ~= 'RADIO' then
			imgui.SetCursorPos(imgui.ImVec2(751 - an[23], 332))
			if imgui.InvisibleButton(u8'##Переключить повтор треков', imgui.ImVec2(23, 23)) then
				if play.repeat_track == 0 then
					play.repeat_track = 1
				elseif play.repeat_track == 1 then
					play.repeat_track = 2
				else
					play.repeat_track = 0
				end
			end
		end
		
		local mouse_pos_vol = mouse_pos_all_screen.x - window_pos.x - 753
		if mouse_pos_vol <= 0 then
			mouse_pos_vol = 0.01
		elseif mouse_pos_vol >= 60 then
			mouse_pos_vol = 59.99
		end
		imgui.SetCursorPos(imgui.ImVec2(786 - an[23], 332))
		if imgui.InvisibleButton(u8'##Управлять громкостью воспроизведения', imgui.ImVec2(23 + an[23], 23)) then
			
		end
		if imgui.IsItemHovered() or imgui.IsItemActive() then
			if an[23] < 70 then
				an[23] = an[23] + (anim * 220)
			else
				an[23] = 70
			end
		else
			if an[23] > 0 then
				an[23] = an[23] - (anim * 220)
			else
				an[23] = 0
			end
		end
		
		if imgui.IsItemActive() then
			play.volume = mouse_pos_vol / 60
			bool_button_active_volume = true
		else
			if bool_button_active_volume then
				bool_button_active_volume = false
				volume_song(play.volume)
			end
		end
		
		local x_size_volume_draw = an[23]
		local x_size_volume = 0
		if x_size_volume_draw > 60 then x_size_volume_draw = 60 end
		if x_size_volume_draw >= 60 - ((60 * play.volume)) then
			x_size_volume = x_size_volume_draw - (60 - ((60 * play.volume)))
		end
		
		if an[23] > 0.5 then
			gui.Draw({813 - x_size_volume_draw, 342}, {x_size_volume_draw, 4}, imgui.ImVec4(0.21, 0.21, 0.21, 1.00), 20, 15)
			gui.Draw({813 - x_size_volume_draw, 342}, {x_size_volume, 4}, cl.def, 20, 15)
		end
		
		if play.tab ~= 'RECORD' and play.tab ~= 'RADIO' then
			if play.repeat_track == 0 then
				gui.FaText(757 - an[23], 335, fa.REPEAT, fa_font[4], imgui.ImVec4(0.50, 0.50, 0.50, 1.00))
			elseif play.repeat_track == 1 then
				gui.FaText(757 - an[23], 335, fa.REPEAT, fa_font[4], cl.def)
			else
				gui.FaText(757 - an[23], 335, fa.REPEAT_1, fa_font[4], cl.def)
			end
		end
			
		if play.volume >= 0.7 then
			gui.FaText(792 - an[23], 335, fa.VOLUME_HIGH, fa_font[4], imgui.ImVec4(0.50, 0.50, 0.50, 1.00))
		elseif play.volume >= 0.4 then
			gui.FaText(791 - an[23], 335, fa.VOLUME, fa_font[4], imgui.ImVec4(0.50, 0.50, 0.50, 1.00))
		elseif play.volume >= 0.03 then
			gui.FaText(792 - an[23], 335, fa.VOLUME_LOW, fa_font[4], imgui.ImVec4(0.50, 0.50, 0.50, 1.00))
		else
			gui.FaText(790 - an[23], 335, fa.VOLUME_SLASH, fa_font[4], imgui.ImVec4(0.50, 0.50, 0.50, 1.00))
		end
	end
	
	imgui.EndChild()
	
end


