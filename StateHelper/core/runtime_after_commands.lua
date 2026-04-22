--[[
Open with encoding: CP1251
StateHelper/core/runtime_after_commands.lua
]]

function download_admin_list()
	local url = sh_project_remote_data_url('nicks.json')
	local save_path = dir .. '/config/Admins.json'
	
	downloadUrlToFile(url, save_path, function(id, status)
	end)
end
download_admin_list()

function get_last_lines(log, n)
	local function split_text(input, length)
		local parts = {}
		while #input > length do
			local part = input:sub(1, length)
			table.insert(parts, part)
			input = input:sub(length + 1)
		end
		
		if #input > 0 then
			table.insert(parts, input)
		end
		
		return parts
	end
	
	local lines = {}
	for line in log:gmatch("[^\n]+") do
		table.insert(lines, line)
	end
	
	local start_index = #lines - n + 1
	if start_index < 1 then start_index = 1 end

	local last_lines = {}
	local num_str = 1
	for i = start_index, #lines do
		local name_script_error, line_error, error_text
		
		if lines[i]:find("%(error%)") then
			_, name_script_error, line_error, error_text = lines[i]:match("(%S+)%s*:%s*(.-%.lua):(%d+):%s*(.+)")
			if not line_error then
				_, name_script_error, error_text = lines[i]:match("(%S+)%s*:%s*(.+)")
				line_error = "???"
			end

			if name_script_error and error_text then
				local formatted_line = string.format("[%d] [Лог краша] {FFFFFF}Ошибка в скрипте %s[%s], строка %s: %s", num_str, name_script_error, scr.version, line_error, error_text)
				local parts = split_text(formatted_line, 120)
				for j, part in ipairs(parts) do
					table.insert(last_lines, (j == 1 and "" or "{FFFFFF}") .. part)
				end
				num_str = num_str + 1
			end
		elseif lines[i]:find('in function') and not lines[i]:find('>$') then
			_, name_script_error, line_error, error_text = lines[i]:match("stack traceback:%s*(.-%.lua):(%d+):%s*(.+)")
			if not line_error then
				line_error = "???"
				name_script_error = "script"
				_, error_text = lines[i]:match("stack traceback:%s*(.+)")
			end
			
			if error_text then
				local formatted_line = string.format("[%d] [Лог краша] {FFFFFF}Ошибка функции в скрипте %s[%s], строка %s: %s", num_str, name_script_error, scr.version, line_error, error_text)
				local parts = split_text(formatted_line, 120)
				for j, part in ipairs(parts) do
					table.insert(last_lines, (j == 1 and "" or "{FFFFFF}") .. part)
				end
				num_str = num_str + 1
			end
		end
	end

	return last_lines
end

function reset_state()
	scene_active = false
	scene_edit_pos = false
	new_scene = false
	off_scene = false
	change_pos_onstat = false
	is_mini_player_pos = false
	camhack_active = false
	if isPlayerControlLocked() then
		lockPlayerControl(false)
	end
	displayRadar(true)
	displayHud(true)
	restoreCameraJumpcut()
	setCameraBehindPlayer()
	sampSetCursorMode(0)
	imgui.ShowCursor = true
	setVirtualKeyDown(0x79, false)
	evalanon("document.body.style.display = 'block'")
end

function onScriptTerminate(script, game_quit)
	if script == thisScript() then
		if type(release_music_cover_texture) == 'function' then
			pcall(release_music_cover_texture)
		end

		local f = io.open(dir .. '/moonloader.log')
		local crash_log = f:read('*a')
		f:close()
		
		local log_array = get_last_lines(crash_log, 10)
		local clipboard = {}
		if #log_array ~= 0 then
			if setting.show_logs then
				sampAddChatMessage('[SH] Скрипт неожиданно завершил работу со следующими ошибками:', 0xFF5345)
			end
		else
			return
		end
		
		if setting.show_logs then
			for i = 1, #log_array do
				sampAddChatMessage(log_array[i], 0xFF5345)
				table.insert(clipboard, u8(log_array[i]))
			end
		end
		imgui.SetClipboardText(table.concat(clipboard, '\n'))
		local f = io.open(sh_legacy_data_path('crashlog.log'), 'w')
		f:write(table.concat(clipboard, '\n'))
		f:flush()
		f:close()
		
		if setting.show_logs then
			sampAddChatMessage('[SH] Лог краша сохранён в файлах скрипта, а также скопирован в буфер обмена.', 0xFF5345)
		else
			sampAddChatMessage('[SH] Скрипт неожиданно завершил работу. Лог сохранён в файлах скрипта, а также скопирован в буфер обмена.', 0xFF5345)
		end
	end
end
--[[ Потипу окно редактирования должно было быть)

local inputTextCallback = ffi.cast("ImGuiInputTextCallback", function(data)
	if needSetCursorToEnd then
		data.CursorPos = #ffi.string(inputField)
		needSetCursorToEnd = false
	end
	return 0
end)

function SmiEdit()
	if not dialogData then return end
		local startIdx, endIdx = string.find(dialogText, "{33AA33}([^\n]+)")
		if imgui.IsItemHovered() then
			gui.DrawLine({arrowPosX - 5, arrowPosY - 5}, {arrowPosX + 5, arrowPosY}, imgui.ImVec4(0.98, 0.30, 0.38, 1.00), 2)
			gui.DrawLine({arrowPosX + 5, arrowPosY}, {arrowPosX - 5, arrowPosY + 5}, imgui.ImVec4(0.98, 0.30, 0.38, 1.00), 2)
			imgui.SetTooltip(u8("Скопировать в поле ввода"))
		else
			gui.DrawLine({arrowPosX - 5, arrowPosY - 5}, {arrowPosX + 5, arrowPosY}, imgui.ImVec4(0.98, 0.40, 0.38, 1.00), 2)
			gui.DrawLine({arrowPosX + 5, arrowPosY}, {arrowPosX - 5, arrowPosY + 5}, imgui.ImVec4(0.98, 0.40, 0.38, 1.00), 2)
		end



	end
]]

local weatherNames = {	--> Названия погоды
	["Чистое небо"] = {0, 1, 2, 3, 4, 5, 6, 7},
	["Гроза с молниями"] = {8},
	["Густой туман и пасмурно"] = {9},
	["Ясное чистое небо"] = {10},
	["Дикое пекло и жара"] = {11},
	["Смуглая неприятная погода"] = {12, 13, 14, 15},
	["Тусклый дождливый день"] = {16},
	["Жаркая погода"] = {17, 18},
	["Песчаная буря"] = {19},
	["Туманная мрачная погода"] = {20},
	["Ночь с пурпурным небом"] = {21},
	["Ночь с зеленоватым оттенком"] = {22},
	["Бледно-оранжевые тона"] = {23, 24, 25, 26},
	["Свежий синий"] = {27, 28, 29},
	["Темный неясный чирок"] = {30},
	["Неясная погода"] = {31, 32},
	["Вечер в коричневатых оттенках"] = {33},
	["Сине-пурпурные оттенки"] = {34},
	["Тусклая унылая погода"] = {35},
	["Яркий туман"] = {36},
	["Яркая погода"] = {37, 38},
	["Очень яркая ослепительная погода"] = {39},
	["Неясная пурпурно-синяя"] = {40, 41, 42},
	["Темные едкие облака"] = {43},
	["Черно-белое контрастное небо"] = {44},
	["Пурпурное мистическое небо"] = {45},
}

function processCommand(param, mode)	--> Изменение времени/погоды
	local num = tonumber(param)
	if mode == "time" then
		if num and num >= 0 and num <= 23 then
			setting.time = num
			local bs = raknetNewBitStream()
			raknetBitStreamWriteInt8(bs, num)
			raknetEmulRpcReceiveBitStream(94, bs)
			raknetDeleteBitStream(bs)
			if not setting.cef_notif then
				sampAddChatMessage('[SH]{FFFFFF} Установлено время: ' .. num .. ":00", 0xFF5345)
			else
				cefnotig('{FF5345}[SH]{FFFFFF} Установлено время: ' .. num .. ":00", 3000)
			end
			save()
		elseif param == "OFF" or param == "off" or param == "щаа" then
			setting.time = '-1'
			if not setting.cef_notif then
				sampAddChatMessage('[SH]{FFFFFF} Сервер теперь может изменять время', 0xFF5345)
			else
				cefnotig('{FF5345}[SH]{FFFFFF} Сервер теперь может изменять время', 3000)
			end
			save()
		else
			if not setting.cef_notif then
				sampAddChatMessage('[SH]{FFFFFF} Используйте: /st [0 - 23 | off - отключить]', 0xFF5345)
			else
				cefnotig('{FF5345}[SH]{FFFFFF} Используйте: /st [0 - 23 | off - отключить]', 3000)
			end
		end
	elseif mode == "weather" then
		if num and num >= 0 and num <= 45 then
			setting.weather = num
			local weatherName = "Неизвестная погода"
			for name, indices in pairs(weatherNames or {}) do
				for _, index in ipairs(indices) do
					if index == num then
						weatherName = name
						break
					end
				end
				if weatherName ~= "Неизвестная погода" then break end
			end
			local bs = raknetNewBitStream()
			raknetBitStreamWriteInt8(bs, num)
			raknetEmulRpcReceiveBitStream(152, bs)
			raknetDeleteBitStream(bs)
			if not setting.cef_notif then
				sampAddChatMessage('[SH]{FFFFFF} Установлена погода: ' .. weatherName .. ' [' .. num .. ']', 0xFF5345)
			else
				cefnotig('{FF5345}[SH]{FFFFFF} Установлена погода: ' .. weatherName .. ' [' .. num .. ']', 2000)
			end
			bweather = true
		elseif param == "OFF" or param == "off" or param == "щаа" then
			if not setting.cef_notif then
				sampAddChatMessage('[SH]{FFFFFF} Сервер теперь может изменять погоду', 0xFF5345)
			else
				cefnotig('{FF5345}[SH]{FFFFFF} Сервер теперь может изменять погоду', 2000)
			end
			bweather = false
		else
			if not setting.cef_notif then
				sampAddChatMessage('[SH]{FFFFFF} Используйте: /sw [0 - 45 | off - отключить]', 0xFF5345)
			else
				cefnotig('{FF5345}[SH]{FFFFFF} Используйте: /sw [0 - 45 | off - отключить]', 2000)
			end
		end
	end
end

function hook.onSetWeather(weather)
	if bweather then
		return false
	end
	return true
end

function updateTime()
	if setting.time then
		local time = tonumber(setting.time)
		if time and time >= 0 and time <= 23 then
			setTimeOfDay(time, 0)
		end
	end
end

function correct_chat(text) --> Исправление чата
	if not text or text:match("^%s*$") then return text end
	text = text:gsub("^%s*(.-)%s*$", "%1")
	text = text:gsub(",(%S)", ", %1")
	local first_char = text:sub(1, 1)
	local rest_of_text = text:sub(2)
	local lower = 'абвгґдеєжзиіїйклмнопрстуфхцчшщьюяё'
	local upper = 'АБВГҐДЕЄЖЗИІЇЙКЛМНОПРСТУФХЦЧШЩЬЮЯЁ'
	local pos = lower:find(first_char, 1, true)
	if pos then
		first_char = upper:sub(pos, pos)
	else
		first_char = first_char:upper()
	end
	text = first_char .. rest_of_text
	text = text:gsub("([.?!]%s*)([абвгґдеєжзиіїйклмнопрстуфхцчшщьюяёa-z])", function(punctuation_and_space, letter)
		local pos_cyr = lower:find(letter, 1, true)
		if pos_cyr then
			return punctuation_and_space .. upper:sub(pos_cyr, pos_cyr)
		else
			return punctuation_and_space .. letter:upper()
		end
	end)
	if not text:match('[%.%!%?%,%/%\\%)%(%:]$') then
		text = text .. '.'
	end
	return text
end

function remove(path)
	if lfs.attributes(path, "mode") == "directory" then
		for file in lfs.dir(path) do
			if file ~= "." and file ~= ".." then
				remove(path .. "/" .. file)
			end
		end
		lfs.rmdir(path)
	else
		os.remove(path)
	end
end

function AddMoveButtons(i, pxl) --> Изменения очередность действий
	local should_break = false
	local current_action_type = bl_cmd.act[i][1]
	if current_action_type == 'ELSE' or current_action_type == 'END' then
		return false
	end
	local startIndex = i
	local endIndex = i
	if current_action_type == 'IF' then
		local if_id = bl_cmd.act[i][4]
		local nest_level = 0
		for j = i + 1, #bl_cmd.act do
			if bl_cmd.act[j][1] == 'IF' then
				nest_level = nest_level + 1
			elseif bl_cmd.act[j][1] == 'END' then
				if nest_level == 0 and bl_cmd.act[j][2] == if_id then
					endIndex = j
					break
				else
					nest_level = nest_level - 1
				end
			end
		end
	end
	if startIndex > 1 then
		imgui.SetCursorPos(imgui.ImVec2(770, 293 + pxl))
		if imgui.InvisibleButton("##UP" .. i, imgui.ImVec2(21, 22)) then
			local block = {}
			for k = startIndex, endIndex do
				table.insert(block, bl_cmd.act[k])
			end
			for k = endIndex, startIndex, -1 do
				table.remove(bl_cmd.act, k)
			end
			for k = 1, #block do
				table.insert(bl_cmd.act, startIndex - 1 + k - 1, block[k])
			end
			should_break = true
		end
		local is_hovered_up = imgui.IsItemHovered()
		if is_hovered_up then imgui.PushStyleColor(imgui.Col.Text, cl.def) end
		gui.FaText(772, 295 + pxl, fa.ARROW_UP, fa_font[4])
		if is_hovered_up then imgui.PopStyleColor() end
	end
	if endIndex < #bl_cmd.act then
		imgui.SetCursorPos(imgui.ImVec2(740, 293 + pxl))
		if imgui.InvisibleButton("##DOWN" .. i, imgui.ImVec2(21, 22)) then
			local block = {}
			for k = startIndex, endIndex do
				table.insert(block, bl_cmd.act[k])
			end
			for k = endIndex, startIndex, -1 do
				table.remove(bl_cmd.act, k)
			end
			for k = 1, #block do
				table.insert(bl_cmd.act, startIndex + k, block[k])
			end
			should_break = true
		end
		local is_hovered_down = imgui.IsItemHovered()
		if is_hovered_down then imgui.PushStyleColor(imgui.Col.Text, cl.def) end
		gui.FaText(742, 295 + pxl, fa.ARROW_DOWN, fa_font[4])
		if is_hovered_down then imgui.PopStyleColor() end
	end
	return should_break
end

--> Функции для полиции
local function sh_vehicle_log(message)
	print('[SH][vehicle] ' .. tostring(message))
end

local function sh_vehicle_sanitize_json(content)
	if type(content) ~= 'string' then
		return false, 'invalid_content_type'
	end

	local sanitized = content:gsub('^\239\187\191', '')
	sanitized = sanitized:gsub('^%s+', ''):gsub('%s+$', '')

	if sanitized == '' then
		return false, 'json_empty'
	end

	local first_char = sanitized:sub(1, 1)
	if first_char ~= '{' and first_char ~= '[' then
		return false, 'json_unexpected_prefix:' .. tostring(string.byte(first_char) or 'nil')
	end

	return true, sanitized
end

local function sh_vehicle_extract_payload(decoded_data)
	if type(decoded_data) ~= 'table' then
		return nil, {}, 'root_not_table'
	end

	local version = decoded_data.version and tostring(decoded_data.version) or nil
	local vehicles = {}

	if type(decoded_data[1]) == 'table' then
		vehicles = decoded_data
		if not version and decoded_data[1].version then
			version = tostring(decoded_data[1].version)
		end
	elseif type(decoded_data.vehicles) == 'table' then
		vehicles = decoded_data.vehicles
	elseif type(decoded_data.items) == 'table' then
		vehicles = decoded_data.items
	elseif type(decoded_data.list) == 'table' then
		vehicles = decoded_data.list
	end

	return version, vehicles, nil
end

function checkVehicleData()
	local vehicle_data_url = sh_project_remote_data_url('vehicle.json')
	local local_path = type(sh_data_path) == 'function'
		and sh_data_path(dir, 'Police', 'vehicle.json')
		or sh_legacy_data_path('Police', 'vehicle.json')

	local function loadVehicleNames()
		local f = io.open(local_path, 'rb')
		if f then
			local data = f:read('*a')
			f:close()
			local sanitized_ok, sanitized_data = sh_vehicle_sanitize_json(data)
			if not sanitized_ok then
				sh_vehicle_log('vehicle.json sanitize failed: ' .. tostring(sanitized_data))
				return
			end

			local res, decoded_data = pcall(decodeJson, sanitized_data)
			if res and type(decoded_data) == 'table' then
				local version, vehicles = sh_vehicle_extract_payload(decoded_data)
				vehicleNames = {}
				local loaded_count = 0

				if version then
					localVehicleVersion = version
				end

				for _, vehicle in ipairs(vehicles) do
					if type(vehicle) == 'table' and vehicle.model_id and vehicle.name then
						vehicleNames[vehicle.model_id] = u8:decode(vehicle.name)
						loaded_count = loaded_count + 1
					end
				end

				if loaded_count == 0 then
					sh_vehicle_log('vehicle.json loaded without vehicle entries; version=' .. tostring(localVehicleVersion))
				else
					sh_vehicle_log('vehicle.json loaded: version=' .. tostring(localVehicleVersion) .. ', entries=' .. tostring(loaded_count))
				end
			else
				sh_vehicle_log('vehicle.json decode failed: ' .. tostring(decoded_data))
			end
		else
			sh_vehicle_log('vehicle.json open failed: ' .. tostring(local_path))
		end
	end
	
	if not doesFileExist(local_path) then
		sh_vehicle_log('vehicle.json missing, downloading from remote')
		downloadUrlToFile(vehicle_data_url, local_path, function(id, status)
			if status == dlstatus.STATUS_ENDDOWNLOADDATA then
				loadVehicleNames()
			end
		end)
	else
		loadVehicleNames()
	end
end

function getNearestVehicleModel()
	local closestCar = nil
	local minDist = 150.0
	local myX, myY, myZ = getCharCoordinates(PLAYER_PED)
	local myCar = isCharInAnyCar(PLAYER_PED) and getCarCharIsUsing(PLAYER_PED) or nil

	for _, vehicle in ipairs(getAllVehicles()) do
		if vehicle ~= myCar and doesCharExist(getDriverOfCar(vehicle)) then
			local vehX, vehY, vehZ = getCarCoordinates(vehicle)
			local dist = getDistanceBetweenCoords3d(myX, myY, myZ, vehX, vehY, vehZ)
			if dist < minDist then
				minDist = dist
				closestCar = vehicle
			end
		end
	end

	if closestCar then
		local modelId = getCarModel(closestCar)
		if vehicleNames and vehicleNames[modelId] then
			return vehicleNames[modelId]
		else
			return "Модель " .. modelId
		end
	else
		return "Неизвестно"
	end
end

function getNearestVehicleSpeed()
	local closestCar = nil
	local minDist = 150.0
	local myX, myY, myZ = getCharCoordinates(PLAYER_PED)
	local myCar = isCharInAnyCar(PLAYER_PED) and getCarCharIsUsing(PLAYER_PED) or nil

	for _, vehicle in ipairs(getAllVehicles()) do
		if vehicle ~= myCar and doesCharExist(getDriverOfCar(vehicle)) then
			local vehX, vehY, vehZ = getCarCoordinates(vehicle)
			local dist = getDistanceBetweenCoords3d(myX, myY, myZ, vehX, vehY, vehZ)
			if dist < minDist then
				minDist = dist
				closestCar = vehicle
			end
		end
	end

	if closestCar then
		local speed = math.floor(getCarSpeed(closestCar) * 3.60)
		return tostring(speed)
	else
		return "0"
	end
end

function getCurrentMapSquare()
	local alphabet = 'АБВГДЖЗИКЛМНОПРСТУФХЦЧШЯ'
	local x, y = getCharCoordinates(PLAYER_PED)
	local gridX = math.ceil((x + 3000) / 250)
	local gridY = math.ceil((y * -1 + 3000) / 250)
	local yLetter = string.sub(alphabet, gridY, gridY)
	if yLetter and gridX > 0 and gridX <= 24 then
		return yLetter .. '-' .. gridX
	else
		return 'Вне карты'
	end
end

function download_wanted_reasons()
	if s_na == '' then return end
	local url = sh_project_remote_data_url('AutoSu/' .. s_na .. '.json')
	local auto_su_dir = sh_legacy_data_path('Police', 'AutoSu') .. '/'
	if not doesDirectoryExist(auto_su_dir) then
		createDirectory(auto_su_dir)
	end
	local file_path = auto_su_dir .. s_na .. '.json' 
	if not doesFileExist(file_path) then
		downloadUrlToFile(url, file_path, function(id, status)
			if status == dlstatus.STATUS_ENDDOWNLOADDATA then
			
			elseif status == dlstatus.STATUS_DOWNLOAD_ERROR then
				if not setting.cef_notif then
					sampAddChatMessage('[SH]{FFFFFF} Не удалось скачать файл с розыском для вашего сервера.', 0xFF5345)
				else
					cefnotig("{FF5345}[SH]{FFFFFF} Не удалось скачать файл с розыском для вашего сервера.", 2000)
				end
			end
		end)
	end
end

function download_ticket_reasons()
    if s_na == '' then return end
    
    local url = sh_project_remote_data_url('AutoTicket/' .. s_na .. '.json')
    local auto_ticket_dir = sh_legacy_data_path('Police', 'AutoTicket') .. '/'
    
    if not doesDirectoryExist(auto_ticket_dir) then
        createDirectory(auto_ticket_dir)
    end
    
    local file_path = auto_ticket_dir .. s_na .. '.json'
    
    if not doesFileExist(file_path) then
        downloadUrlToFile(url, file_path, function(id, status)
            if status == dlstatus.STATUS_ENDDOWNLOADDATA then
				if not setting.cef_notif then
					sampAddChatMessage('[SH]{23E64A} База штрафов для сервера ' .. s_na .. ' загружена.', 0x23E64A)
				else
					cefnotig('{FF5345}[SH] {FFFFFF}База штрафов для сервера ' .. s_na .. ' загружена.', 2000)
				end
			elseif status == dlstatus.STATUS_DOWNLOADERROR then
				if not setting.cef_notif then
					sampAddChatMessage('[SH]{FF5345} Не удалось скачать базу штрафов для сервера ' .. s_na, 0xFF5345)
				else
					cefnotig('{FF5345}[SH] {FFFFFF}Не удалось скачать базу штрафов для сервера ' .. s_na, 2000)
				end
			end
        end)
    end
end


function download_punish_reasons()
    if s_na == '' then return end

    local tsr_dir = sh_legacy_data_path('TSR') .. '/'
    if not doesDirectoryExist(tsr_dir) then
        createDirectory(tsr_dir)
    end
    
    local auto_punish_dir = tsr_dir .. 'AutoPunish/'
    if not doesDirectoryExist(auto_punish_dir) then
        createDirectory(auto_punish_dir)
    end
    
    local url = sh_project_remote_data_url('AutoPunish/' .. s_na .. '.json')
    local file_path = auto_punish_dir .. s_na .. '.json'
    
    if not doesFileExist(file_path) then
        downloadUrlToFile(url, file_path, function(id, status)
            if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                if not setting.cef_notif then
					sampAddChatMessage('[SH]{23E64A} База наказаний для сервера ' .. s_na .. ' загружена.', 0x23E64A)
				else
					cefnotig('{FF5345}[SH] {FFFFFF}База наказаний для сервера ' .. s_na .. ' загружена.', 2000)
				end
				load_punish_reasons()
			elseif status == dlstatus.STATUS_DOWNLOADERROR then
				if not setting.cef_notif then
					sampAddChatMessage('[SH]{FF5345} Не удалось скачать базу наказаний для сервера ' .. s_na, 0xFF5345)
				else
					cefnotig('{FF5345}[SH] {FFFFFF}Не удалось скачать базу наказаний для сервера ' .. s_na, 2000)
				end
            end
        end)
    else
        load_punish_reasons()
    end
end

function load_punish_reasons()
    local tsr_dir = sh_legacy_data_path('TSR') .. '/'
    local auto_punish_dir = tsr_dir .. 'AutoPunish/'
    local file_path = auto_punish_dir .. s_na .. '.json'
    
    if doesFileExist(file_path) then
        local file = io.open(file_path, 'r')
        if file then
            local data = file:read('*a')
            file:close()
            local success, decoded_data = pcall(decodeJson, data)
            if success and type(decoded_data) == 'table' then
                smartPunishState.reasons = decoded_data
                if not setting.cef_notif then
					sampAddChatMessage('[SH]{23E64A} База наказаний загружена', 0x23E64A)
				else
					cefnotig('{FF5345}[SH] {FFFFFF}База наказаний загружена', 2000)
				end
                return true
            else
                smartPunishState.reasons = {}
                if not setting.cef_notif then
					sampAddChatMessage('[SH]{23E64A} Ошибка чтения файла наказаний', 0x23E64A)
				else
					cefnotig('{FF5345}[SH] {FFFFFF}Ошибка чтения файла наказаний', 2000)
				end
                return false
            end
        end
    else
        smartPunishState.reasons = nil
        if not setting.cef_notif then
            sampAddChatMessage('[SH]{FF5345} Файл наказаний не найден. Скачиваю...', 0xFF5345)
        end
        download_punish_reasons()
        return false
    end
end

function send_ticket_commands(id, amount, code)
	local commands_to_send = {}
	local use_writeticket = true
	local penaltyValue = tonumber(amount) or 0
	if setting.police_settings.smart_ticket_trade and penaltyValue > 500000 then
		use_writeticket = false
	end
	if use_writeticket then
		table.insert(commands_to_send, string.format('/writeticket %d %d %s', id, penaltyValue, u1251:iconv(code)))
	end
	--> отыгровка
	table.insert(commands_to_send, '/me ')
	table.insert(commands_to_send, '/me ')
	
	send_smart_su_commands(commands_to_send)
end

--[[
function send_take_command(id)
	sampSetChatInputText('/take ' .. id)
	sampSetChatInputEnabled(true)
end]]

function parsePenaltyRangeOrTake(penaltyStr)
	local result = { type = 'unknown' }
	if penaltyStr:lower() == 'take' then
		result.type = 'take'
	elseif penaltyStr:match('^(%d+)$') then
		result.type = 'number'
		result.value = tonumber(penaltyStr)
	elseif penaltyStr:match('^(%d+)%s*-%s*(%d+)$') then
		local minVal, maxVal = penaltyStr:match('^(%d+)%s*-%s*(%d+)$')
		result.type = 'range'
		result.min = tonumber(minVal)
		result.max = tonumber(maxVal)
		if result.min > result.max then
			result.min, result.max = result.max, result.min
		end
	elseif penaltyStr:match('^(%d+)%s*-%s*take$') then
		result.type = 'number-take'
		result.value = tonumber(penaltyStr:match('^(%d+)'))
	end
	return result
end

function send_smart_su_commands(commands)
	if thread:status() ~= 'dead' then
		if not setting.cef_notif then
			sampAddChatMessage('[SH] {FFFFFF}Дождитесь завершения предыдущей отыгровки.', 0xFF5345)
		else
			cefnotig('{FF5345}[SH] {FFFFFF}Дождитесь завершения предыдущей отыгровки.', 2000)
		end
		return
	end
	thread = lua_thread.create(function(cmd_table)
		for _, text in ipairs(cmd_table) do
			sampSendChat(text)
			wait(1300)
		end
	end, commands)
end

function send_smart_ticket_commands(commands)
	lua_thread.create(function()
		for _, cmd in ipairs(commands) do
			sampSendChat(cmd)
			wait(800) 
		end
	end)
end

function parsePenaltyRange(rangeStr)
	local startNum, endNum = rangeStr:match("(%d+)%s*-%s*(%d+)")
	if startNum and endNum then
		local penalties = {}
		for i = tonumber(startNum), tonumber(endNum) do
			table.insert(penalties, i)
		end
		return penalties
	end
	return nil
end

function smart_su_func(arg)
	local id = tonumber(arg)
	if id == nil or not sampIsPlayerConnected(id) then
		if not setting.cef_notif then
			sampAddChatMessage('[SH]{FFFFFF} Используйте {a8a8a8}/su [id игрока]', 0xFF5345)
		else
			cefnotig('{FF5345}[SH]{FFFFFF} Используйте {a8a8a8}/su [id игрока]', 2000)
		end
		return
	end
	local auto_su_dir = sh_legacy_data_path('Police', 'AutoSu') .. '/'
	if not doesDirectoryExist(auto_su_dir) then
		createDirectory(auto_su_dir)
	end
	local file_path = auto_su_dir .. s_na .. '.json'
	if doesFileExist(file_path) then
		local file = io.open(file_path, 'r')
		if file then
			local data = file:read('*a')
			file:close()
			local success, decoded_data = pcall(decodeJson, data)
			if success then
				smartSuState.reasons = decoded_data
			else
				if not setting.cef_notif then
					sampAddChatMessage('[SH]{FFFFFF} Ошибка чтения файла ' .. s_na .. '.json. Файл может быть поврежден.', 0xFF5345)
				else
					cefnotig('{FF5345}[SH]{FFFFFF} Ошибка чтения файла ' .. s_na .. '.json. Файл может быть поврежден.', 2000)
				end
				smartSuState.reasons = {}
			end
		end
	else
		if not setting.cef_notif then
			sampAddChatMessage('[SH]{FFFFFF} Файл розыска ' .. s_na .. '.json не найден. Скачивание...', 0xFF5345)
		else
			cefnotig('{FF5345}[SH]{FFFFFF} Файл розыска ' .. s_na .. '.json не найден. Скачивание...', 2000)
		end
		download_wanted_reasons()
		smartSuState.reasons = {}
	end
	smartSuState.targetId[0] = id
	windows.smart_su[0] = true
	smartSuState.anim.is_opening = true
	smartSuState.anim.is_closing = false
end

function smart_ticket_func(arg)
    local id = tonumber(arg)
    if id == nil or not sampIsPlayerConnected(id) then
        if not setting.cef_notif then
            sampAddChatMessage('[SH]{FFFFFF} Используйте {a8a8a8}/ticket [id игрока]', 0xFF5345)
        else
            cefnotig('{FF5345}[SH]{FFFFFF} Используйте {a8a8a8}/ticket [id игрока]', 2000)
        end
        return
    end
    
    local auto_ticket_dir = sh_legacy_data_path('Police', 'AutoTicket') .. '/'
    if not doesDirectoryExist(auto_ticket_dir) then
        createDirectory(auto_ticket_dir)
    end
    
    local file_path = auto_ticket_dir .. s_na .. '.json'
    
    if doesFileExist(file_path) then
        local file = io.open(file_path, 'r')
        if file then
            local data = file:read('*a')
            file:close()
            local success, decoded_data = pcall(decodeJson, data)
            if success then
                smartTicketState.reasons = decoded_data
            else
                if not setting.cef_notif then
                    sampAddChatMessage('[SH]{FFFFFF} Ошибка чтения файла штрафов. Файл поврежден.', 0xFF5345)
                end
                smartTicketState.reasons = {}
            end
        end
    else
        if not setting.cef_notif then
            sampAddChatMessage('[SH]{FFFFFF} Файл штрафов не найден. Скачивание...', 0xFF5345)
        end
        download_ticket_reasons()
        smartTicketState.reasons = {}
    end
    
    smartTicketState.targetId[0] = id
    smartTicketState.searchQuery = ''
    smartTicketState.chapterStates = {}
    windows.smart_ticket[0] = true
    smartTicketState.anim.is_opening = true
    smartTicketState.anim.is_closing = false
end

function changeWantedPosition()
	if setting.police_settings.wanted_list.func then
		pos_new_wanted = lua_thread.create(function()
			local backup = {
				['x'] = setting.police_settings.wanted_list.pos.x,
				['y'] = setting.police_settings.wanted_list.pos.y
			}
			local ChangePos = true
			sampSetCursorMode(4)
			windows.main[0] = false
			if not setting.cef_notif then
				sampAddChatMessage('[SH]{FFFFFF} Нажмите {FF6060}ЛКМ{FFFFFF}, чтобы применить или {FF6060}ESC{FFFFFF} для отмены.', 0xFF5345)
			else
				cefnotig("{FF5345}[SH]{FFFFFF} Нажмите {FF6060}ЛКМ{FFFFFF}, чтобы применить или {FF6060}ESC{FFFFFF} для отмены.", 3000)
			end
			if not sampIsChatInputActive() then
				while not sampIsChatInputActive() and ChangePos do
					wait(0)
					local cX, cY = getCursorPos()
					setting.police_settings.wanted_list.pos.x = cX
					setting.police_settings.wanted_list.pos.y = cY
					if isKeyDown(0x01) then
						while isKeyDown(0x01) do wait(0) end
						ChangePos = false
						save()
						if not setting.cef_notif then
							sampAddChatMessage('[SH]{FFFFFF} Позиция сохранена.', 0xFF5345)
						else
							cefnotig("{FF5345}[SH]{FFFFFF} Позиция сохранена.", 2000)
						end
					elseif isKeyJustPressed(VK_ESCAPE) then
						ChangePos = false
						setting.police_settings.wanted_list.pos.x = backup['x']
						setting.police_settings.wanted_list.pos.y = backup['y']
					end
				end
			end
			sampSetCursorMode(0)
			windows.main[0] = true
			imgui.ShowCursor = true
			ChangePos = false
		end)
	end
end

--> Функция отслеживания игрока по ID
function toggleTracking(id)
    
    if trackingState.isTracking then
        trackingState.isTracking = false
        trackingState.targetId = nil
        
        if trackingState.thread and trackingState.thread:status() ~= 'dead' then
            trackingState.thread:terminate()
        end
        
        if not setting.cef_notif then
            sampAddChatMessage("[SH]{FF5345} Отслеживание игрока остановлено.", 0xFF5345)
        else
            cefnotig("{FF5345}[SH] Отслеживание игрока остановлено.", 3000)
        end
        return
    end
    
    
    id = tonumber(id)
    if not id then
        if not setting.cef_notif then
            sampAddChatMessage("[SH]{FFFFFF} Используйте: /afind [id игрока]", 0xFF5345)
        else
            cefnotig("{FF5345}[SH]{FFFFFF} Используйте: /afind [id игрока]", 3000)
        end
        return
    end
    
    if not sampIsPlayerConnected(id) then
        if not setting.cef_notif then
            sampAddChatMessage("[SH]{FFFFFF} Игрок с ID " .. id .. " не найден.", 0xFF5345)
        else
            cefnotig("{FF5345}[SH]{FFFFFF} Игрок с ID " .. id .. " не найден.", 3000)
        end
        return
    end
    
    
    trackingState.isTracking = true
    trackingState.targetId = id
    
    if not setting.cef_notif then
        sampAddChatMessage("[SH]{23E64A} Начато отслеживание игрока " .. sampGetPlayerNickname(id) .. " [" .. id .. "].", 0x23E64A)
        sampAddChatMessage("[SH]{FF5345} Повторный /afind остановит отслеживание.", 0xFF5345)
    else
        cefnotig("{23E64A}[SH] Начато отслеживание игрока " .. sampGetPlayerNickname(id) .. " [" .. id .. "].", 3000)
        cefnotig("{FF5345}[SH] Повторный /afind остановит отслеживание.", 3000)
    end
    
    trackingState.thread = lua_thread.create(function()
        while trackingState.isTracking do
            if not sampIsPlayerConnected(trackingState.targetId) then
                if not setting.cef_notif then
                    sampAddChatMessage("[SH]{FF5345} Игрок " .. trackingState.targetId .. " вышел из игры. Отслеживание остановлено.", 0xFF5345)
                else
                    cefnotig("{FF5345}[SH] Игрок " .. trackingState.targetId .. " вышел из игры. Отслеживание остановлено.", 3000)
                end
                trackingState.isTracking = false
                trackingState.targetId = nil
                break
            end
            
            sampSendChat("/find " .. trackingState.targetId)
            
            local waitTime = trackingState.updateInterval
            local steps = 10
            for i = 1, steps do
                wait(waitTime / steps)
                if not trackingState.isTracking then
                    break
                end
            end
        end
    end)
end
