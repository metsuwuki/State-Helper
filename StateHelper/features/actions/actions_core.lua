--[[
Open with encoding: CP1251
StateHelper/features/actions/actions_core.lua
]]

function hall.actions()
	local color_ItemActive = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
	local color_ItemHovered = imgui.ImVec4(0.24, 0.24, 0.24, 1.00)
	if setting.cl == 'White' then
		color_ItemActive = imgui.ImVec4(0.78, 0.78, 0.78, 1.00)
		color_ItemHovered = imgui.ImVec4(0.83, 0.83, 0.83, 1.00)
	end
	imgui.SetCursorPos(imgui.ImVec2(4, 39))
	imgui.BeginChild(u8'Действия', imgui.ImVec2(840, 369), false, imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollWithMouse)
	imgui.Scroller(u8'Действия', img_step[1][0], img_duration[1][0], imgui.HoveredFlags.AllowWhenBlockedByActiveItem)
	gui.Text(25, 12, 'Действия с чатом', bold_font[1])
	gui.DrawBox({16, 37}, {808, 113}, cl.tab, cl.line, 7, 15)
	gui.DrawLine({16, 74}, {824, 74}, cl.line)
	gui.DrawLine({16, 112}, {824, 112}, cl.line)
	gui.Text(26, 47, 'Скрыть все сообщения в чате, кроме РП действий и диалогов', font[3])
	imgui.SetCursorPos(imgui.ImVec2(783, 44))
	if gui.Switch(u8'##Скрыть все сообщения кроме РП действий', actions_set.remove_mes) then
		actions_set.remove_mes = not actions_set.remove_mes
	end
	gui.Text(26, 85, 'Скрыть РП действия и диалоги от других игроков', font[3])
	imgui.SetCursorPos(imgui.ImVec2(783, 82))
	if gui.Switch(u8'##Скрыть все сообщения', actions_set.remove_rp) then
		actions_set.remove_rp = not actions_set.remove_rp
	end
	if gui.Button(u8'Очистить игровой чат', {335, 118}, {170, 27}) then
		for qua = 1, 70 do
			sampAddChatMessage('', 0xFFFFFF)
		end
	end
	
	gui.Text(25, 165, 'Действия с миром', bold_font[1])
	gui.DrawBox({16, 190}, {808, 151}, cl.tab, cl.line, 7, 15)
	gui.DrawLine({16, 227}, {824, 227}, cl.line)
	gui.DrawLine({16, 265}, {824, 265}, cl.line)
	gui.DrawLine({16, 303}, {824, 303}, cl.line)
	if gui.Button(u8'Переключить показ никнеймов игроков', {220, 195}, {400, 27}) then
		local Hnick = sampGetServerSettingsPtr()
		if Hnick ~= 0 then
			local currentDist = mem.getfloat(Hnick + 39)
			local currentWall = mem.getint8(Hnick + 47)

			if currentDist < 1.0 then
				mem.setfloat(Hnick + 39, 50.0)
				mem.setint8(Hnick + 47, 1)
			else
				mem.setfloat(Hnick + 39, 0.00001)
				mem.setint8(Hnick + 47, 0)
			end
		end
	end


	if gui.Button(u8'Узнать дистанцию до серверной метки на карте', {220, 233}, {400, 27}) then
		local my_int = getActiveInterior()
		if my_int == 0 then
			local bool_result, pos_X, pos_Y, pos_Z = getTargetServerCoordinates()
			if bool_result then
				local x_player, y_player, z_player = getCharCoordinates(PLAYER_PED)
				local distance = getDistanceBetweenCoords3d(pos_X, pos_Y, pos_Z, x_player, y_player, z_player)
				if not setting.cef_notif then
				sampAddChatMessage('[SH] {FFFFFF}{f7c52f}Расстояние от Вас до метки: ' .. removeDecimalPart(distance) .. ' м.', 0xFF5345)
				else
					cefnotig('{FF5345}[SH] {FFFFFF}{f7c52f}Расстояние от Вас до метки: ' .. removeDecimalPart(distance) .. ' м.', 4000)
				end
			else
				if not setting.cef_notif then
				sampAddChatMessage('[SH] {FFFFFF}{f7c52f}Невозможно определить дистанцию, так как отсутствует метка.', 0xFF5345)
				else
					cefnotig('{FF5345}[SH] {FFFFFF}{f7c52f}Невозможно определить дистанцию, так как отсутствует метка.', 4000)
				end
			end
		else
			if not setting.cef_notif then
				sampAddChatMessage('[SH] {FFFFFF}{f7c52f}Невозможно определить дистанцию, так как Вы находитесь в интерьере.', 0xFF5345)
			else
				cefnotig("{FF5345}[SH] {FFFFFF}{f7c52f}Невозможно определить дистанцию, так как Вы находитесь в интерьере.", 4000)
			end
		end
	end
	if gui.Button(u8'Узнать дистанцию до собственной метки на карте', {220, 271}, {400, 27}) then
		local my_int = getActiveInterior()
		if my_int == 0 then
			local bool_result, pos_X, pos_Y, pos_Z = getTargetBlipCoordinates()
			if bool_result then
				local x_player, y_player, z_player = getCharCoordinates(PLAYER_PED)
				local distance = getDistanceBetweenCoords3d(pos_X, pos_Y, pos_Z, x_player, y_player, z_player)
				if not setting.cef_notif then
					sampAddChatMessage('[SH] {FFFFFF}{f7c52f}Расстояние от Вас до метки: ' .. removeDecimalPart(distance) .. ' м.', 0xFF5345)
				else
					cefnotig('{FF5345}[SH] {FFFFFF}{f7c52f}Расстояние от Вас до метки: ' .. removeDecimalPart(distance) .. ' м.', 4000)
				end
			else
				if not setting.cef_notif then
					sampAddChatMessage('[SH] {FFFFFF}{f7c52f}Невозможно определить дистанцию, так как отсутствует метка.', 0xFF5345)
				else
					cefnotig("{FF5345}[SH] {FFFFFF}{f7c52f}Невозможно определить дистанцию, так как отсутствует метка.", 5000)
				end
			end
		else
			if not setting.cef_notif then
				sampAddChatMessage('[SH] {FFFFFF}{f7c52f}Невозможно определить дистанцию, так как Вы находитесь в интерьере.', 0xFF5345)
			else
				cefnotig("{FF5345}[SH] {FFFFFF}{f7c52f}Невозможно определить дистанцию, так как Вы находитесь в интерьере.", 4000)
			end
		end
	end
	
	if gui.Button(u8'Закрыть соединение с сервером', {220, 309}, {400, 27}) then
		close_connect()
	end
	
	gui.Text(25, 356, 'Действия с программой', bold_font[1])
	gui.DrawBox({16, 381}, {808, 113}, cl.tab, cl.line, 7, 15)
	gui.DrawLine({16, 418}, {824, 418}, cl.line)
	gui.DrawLine({16, 456}, {824, 456}, cl.line)
	if gui.Button(u8'Перезагрузить скрипт', {220, 386}, {400, 27}) then
		showCursor(false)
		scr:reload()
	end
	if gui.Button(script_ac.reset == 0 and u8'Сбросить все настройки скрипта' or u8'Нажмите снова для сброса настроек', {220, 424}, {400, 27}) then 
		script_ac.reset = script_ac.reset + 1
		if script_ac.reset > 1 then
			os.remove((type(sh_data_path) == 'function' and sh_data_path(dir, 'Настройки.json')) or (dir .. '/State Helper/Настройки.json'))
			remove((type(sh_data_path) == 'function' and sh_data_path(dir, 'Отыгровки')) or (dir .. '/State Helper/Отыгровки'))
			if not setting.cef_notif then
				sampAddChatMessage('[SH] {FFFFFF}Настройки сброшены. Перезагрузка скрипта...', 0xFF5345)
			else
				cefnotig("[SH] {FFFFFF}Настройки сброшены. Перезагрузка скрипта...", 3000)
			end
			showCursor(false)
			scr:reload()
		end
	end
	if gui.Button(script_ac.del == 0 and u8'Удалить скрипт с этого устройства' or u8'Нажмите снова для удаления скрипта', {220, 462}, {400, 27}) then
		script_ac.del = script_ac.del + 1
		if script_ac.del > 1 then
			if not setting.cef_notif then
				sampAddChatMessage('[SH] {FFFFFF}Скрипт удалён. Настройки сохранены, Вы можете снова установить его в любое время.', 0xFF5345)
			else
				cefnotig("{FF5345}[SH] {FFFFFF}Скрипт удалён. Настройки сохранены, Вы можете снова установить его в любое время.", 4000)
			end
			windows.main[0] = false
			showCursor(false)
			os.remove(scr.path)
			scr:reload()
		end
	end
	
	imgui.Dummy(imgui.ImVec2(0, 21))
	imgui.EndChild()
end

