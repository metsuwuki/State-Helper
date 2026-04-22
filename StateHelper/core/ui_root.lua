--[[
Open with encoding: CP1251
StateHelper/core/ui_root.lua
]]

function hall.help()
	local color_ItemActive = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
	local color_ItemHovered = imgui.ImVec4(0.24, 0.24, 0.24, 1.00)
	if setting.cl == 'White' then
		color_ItemActive = imgui.ImVec4(0.78, 0.78, 0.78, 1.00)
		color_ItemHovered = imgui.ImVec4(0.83, 0.83, 0.83, 1.00)
	end
	imgui.SetCursorPos(imgui.ImVec2(4, 39))
	imgui.BeginChild(u8'Поддержка', imgui.ImVec2(840, 369), false, imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollWithMouse)
	imgui.Scroller(u8'Поддержка', img_step[1][0], img_duration[1][0], imgui.HoveredFlags.AllowWhenBlockedByActiveItem)
	imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.60, 0.60, 0.60, 0.60))
	gui.Text(181, 158, 'Скоро здесь будет удобный чат с поддержкой, пока что он в разработке.', font[3])
	gui.Text(58, 176, 'Пожалуйста, напишите в наш официальный Дискорд-канал, если у Вас есть вопрос, жалоба или предложение.', font[3])
	gui.Text(121, 194, 'Ссылка на наш канал: https://discord.gg/VDEkTZ9SUB (кликните здесь, чтобы скопировать).', font[3])
	if an[26] > 0 then
		an[26] = an[26] - (anim * 2)
	end
	imgui.SetCursorPos(imgui.ImVec2(264, 194))
	imgui.PushFont(font[3])
	imgui.TextColored(imgui.ImVec4(0.20, 0.78, 0.35, an[26]), u8('https://discord.gg/VDEkTZ9SUB'))
	imgui.PopFont()
	imgui.SetCursorPos(imgui.ImVec2(119, 194))
	if imgui.InvisibleButton(u8'##Скопировать ссылку дискорд-канала', imgui.ImVec2(602, 16)) then
		imgui.SetClipboardText(u8('https://discord.gg/VDEkTZ9SUB'))
		an[26] = 3
	end
	imgui.PopStyleColor(1)
	imgui.EndChild()
end

function format_time(seconds)
	seconds = math.floor(seconds + 0.5)
	
	local hours = math.floor(seconds / 3600)
	local minutes = math.floor((seconds % 3600) / 60)
	local secs = seconds % 60

	if hours > 0 then
		return string.format('%02d:%02d:%02d', hours, minutes, secs)
	else
		return string.format('%02d:%02d', minutes, secs)
	end
end

function update_text_dep()
	if setting.adress_format_dep == 1 then
		dep_text = u8'/d [' .. setting.my_tag_dep .. '] - [' .. setting.alien_tag_dep .. ']: '
	elseif setting.adress_format_dep == 2 then
		dep_text = u8'/d [' .. setting.my_tag_dep .. '] to [' .. setting.alien_tag_dep .. ']: '
	elseif setting.adress_format_dep == 3 then
		dep_text = u8'/d к ' .. setting.alien_tag_dep .. ', '
	elseif setting.adress_format_dep == 4 then
		dep_text = u8'/d [' .. setting.my_tag_dep .. '] - ['.. setting.wave_tag_dep .. '] - [' .. setting.alien_tag_dep .. ']: '
	elseif setting.adress_format_dep == 5 then
		dep_text = u8'/d [' .. setting.my_tag_dep .. u8'] з.к. [' .. setting.alien_tag_dep .. ']: '
	end
end

function getMonthName(monthNumber)
	local months = {
		'Январь', 'Февраль', 'Март', 'Апрель', 
		'Май', 'Июнь', 'Июль', 'Август', 
		'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'
	}
	
	if monthNumber >= 1 and monthNumber <= 12 then
		return months[monthNumber]
	else
		return '' 
	end
end

function getMonthInfo(month, year)
	if month < 1 or month > 12 then
		error("Месяц должен быть в диапазоне от 1 до 12")
	end
	local daysInMonth = {
		31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
	}
	local function isLeapYear(year)
		return (year % 4 == 0 and year % 100 ~= 0) or (year % 400 == 0)
	end
	if isLeapYear(year) then
		daysInMonth[2] = 29
	end
	local t = os.time({year = year, month = month, day = 1})
	local weekday = tonumber(os.date("%w", t))
	weekday = (weekday == 0) and 7 or weekday
	local daysString = tonumber(daysInMonth[month])

	return {weekday, daysString}
end

function get_today_date()
	local current_time = os.date("*t")

	local date_array = {
		current_time.day,
		current_time.month,
		current_time.year
	}

	return date_array
end
function new_text_block_popup()
	print(1)
	if imgui.BeginPopupModal(u8'Текстовый блок', null, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar) then
		imgui.SetCursorPos(imgui.ImVec2(10, 10))
		print(2)
		if imgui.InvisibleButton(u8'##Закрыть окно текстового блока', imgui.ImVec2(16, 16)) then
			imgui.CloseCurrentPopup()
		end
		imgui.SetCursorPos(imgui.ImVec2(16, 16))
		imgui.BeginChild(u8'Текстовый блок добавление', imgui.ImVec2(346, 420), false, imgui.WindowFlags.NoScrollbar)
		if imgui.IsItemHovered() then
			imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x - 0.4, p.y - 0.2), 7, imgui.GetColorU32Vec4(imgui.ImVec4(0.98, 0.32, 0.38 ,1.00)), 60)
		else
			imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x - 0.4, p.y - 0.2), 7, imgui.GetColorU32Vec4(imgui.ImVec4(0.98, 0.42, 0.38 ,1.00)), 60)
		end
		gui.DrawLine({10, 31}, {346, 31}, cl.line)
		local text_multiline = imgui.new.char[512000]('')
		imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImVec4(0.50, 0.50, 0.50, 0.00))
		imgui.PushStyleVarVec2(imgui.StyleVar.FramePadding, imgui.ImVec2(5, 5))
		imgui.PushFont(font[3])
		imgui.InputTextMultiline('##Окно ввода текста шпаргалки', text_multiline, ffi.sizeof(text_multiline), imgui.ImVec2(803, 205))
		imgui.PopStyleColor()
		imgui.PopStyleVar(1)
		imgui.PopFont()
		imgui.EndChild()
		imgui.EndPopup()
	end
end
local text_multilineBlock = imgui.new.char[512000]('')
function new_action_popup()
	if imgui.BeginPopupModal(u8'Добавление действия', null, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar) then
		imgui.SetCursorPos(imgui.ImVec2(10, 10))
		if imgui.InvisibleButton(u8'##Закрыть окно добавления действия', imgui.ImVec2(16, 16)) then
			imgui.CloseCurrentPopup()
		end
		imgui.SetCursorPos(imgui.ImVec2(16, 16))
		local p = imgui.GetCursorScreenPos()
		if imgui.IsItemHovered() then
			imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x - 0.4, p.y - 0.2), 7, imgui.GetColorU32Vec4(imgui.ImVec4(0.98, 0.32, 0.38 ,1.00)), 60)
		else
			imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x - 0.4, p.y - 0.2), 7, imgui.GetColorU32Vec4(imgui.ImVec4(0.98, 0.42, 0.38 ,1.00)), 60)
		end
		gui.DrawLine({10, 31}, {746, 31}, cl.line)
		imgui.SetCursorPos(imgui.ImVec2(6, 48))
		imgui.BeginChild(u8'Добавление действия в команду', imgui.ImVec2(746, 720), false, imgui.WindowFlags.NoScrollbar)
		local pix_y = -37
		local function add_action(NUM_ACTION, FA, TEXT_ACTION)
			pix_y = pix_y + 37
			local dopOt = 0
			local BOOL = false
			if NUM_ACTION == 14 then
				dopOt = 200
			end
			imgui.SetCursorPos(imgui.ImVec2(11, 1 + pix_y))
			if imgui.InvisibleButton(u8'Добавить действие в команде в popup' .. NUM_ACTION, imgui.ImVec2(720, 27)) then
				bl_cmd.id_element = bl_cmd.id_element + 1
				BOOL = true
			end
			if imgui.IsItemActive() then
				gui.Draw({11, 1 + pix_y}, {718, 29}, cl.bg, 3, 15)
			elseif imgui.IsItemHovered() then
				gui.Draw({11, 1 + pix_y}, {718, 29}, cl.bg2, 3, 15)
			end
			
			gui.DrawEmp({10, 0 + pix_y}, {720, 31+dopOt}, cl.line, 5, 15, 1)
			gui.Draw({15, 5 + pix_y}, {21, 21}, FA.COLOR_BG, 3, 15)
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.90, 0.90, 0.90, 1.00))
			gui.FaText(17 + FA.SDVIG[1], 7 + FA.SDVIG[2] + pix_y, FA.ICON, fa_font[3])
			imgui.PopStyleColor(1)
			gui.Text(44, 7 + pix_y, TEXT_ACTION, font[3])
			imgui.PushStyleColor(imgui.Col.Text, cl.def)
			gui.FaText(710, 7 + pix_y, fa.PLUS, fa_font[3])
			imgui.PopStyleColor(1)
			if NUM_ACTION == 14 then
				imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImVec4(0.50, 0.50, 0.50, 0.00))
				imgui.PushStyleVarVec2(imgui.StyleVar.FramePadding, imgui.ImVec2(15, 5))
				imgui.PushFont(font[3])
				imgui.InputTextMultiline('##Окно ввода текста шпаргалки', text_multilineBlock, ffi.sizeof(text_multilineBlock), imgui.ImVec2(718, 190))
				imgui.PopStyleColor()
				imgui.PopStyleVar(1)
				imgui.PopFont()
			end
			return BOOL
		end
		if add_action(1, {ICON = fa.SHARE, COLOR_BG = imgui.ImVec4(1.00, 0.58, 0.00, 1.00), SDVIG = {1, 0}}, 'Отправить сообщение в чат') then
			table.insert(bl_cmd.act, number_i_cmd + 1, {
				'SEND',
				''
			})
			imgui.CloseCurrentPopup()
		end
		if add_action(2, {ICON = fa.TERMINAL, COLOR_BG = imgui.ImVec4(0.20, 0.60, 0.80, 1.00), SDVIG = {0, 0}}, 'Отправить пользовательскую команду') then
			table.insert(bl_cmd.act, number_i_cmd + 1, {
				'SEND_CMD',
				'',
				false
			})
			imgui.CloseCurrentPopup()
		end
		if add_action(3, {ICON = fa.KEYBOARD, COLOR_BG = imgui.ImVec4(1.00, 0.30, 0.00, 1.00), SDVIG = {0, 0}}, 'Открыть игровой чат с текстом') then
			table.insert(bl_cmd.act, number_i_cmd + 1, {
				'OPEN_INPUT',
				''
			})
			imgui.CloseCurrentPopup()
		end
		if add_action(4, {ICON = fa.HOURGLASS, COLOR_BG = imgui.ImVec4(0.30, 0.75, 0.39, 1.00), SDVIG = {3, 0}}, 'Ожидание нажатия Enter') then
			table.insert(bl_cmd.act, number_i_cmd + 1, {
				'WAIT_ENTER'
			})
			imgui.CloseCurrentPopup()
		end
		if add_action(5, {ICON = fa.SHARE_FROM_SQUARE, COLOR_BG = imgui.ImVec4(1.00, 0.58, 0.00, 1.00), SDVIG = {0, 0}}, 'Вывести информацию для себя') then
			table.insert(bl_cmd.act, number_i_cmd + 1, {
				'SEND_ME',
				''
			})
			imgui.CloseCurrentPopup()
		end
		if add_action(6, {ICON = fa.SQUARE_ROOT_VARIABLE, COLOR_BG = imgui.ImVec4(0.00, 0.48, 1.00, 1.00), SDVIG = {0, 0}}, 'Задать для переменной') then
			table.insert(bl_cmd.act, number_i_cmd + 1, {
				'NEW_VAR',
				'', --> Имя переменной
				'' --> Значение переменной
			})
			imgui.CloseCurrentPopup()
		end
		if add_action(7, {ICON = fa.BARS_STAGGERED, COLOR_BG = imgui.ImVec4(0.69, 0.32, 0.87, 1.00), SDVIG = {1, 0}}, 'Диалог выбора действия') then
			table.insert(bl_cmd.act, number_i_cmd + 1, {
				'DIALOG',
				'', --> Имя диалога
				{'', ''} --> Варианты действий
			})
			imgui.CloseCurrentPopup()
		end
		if add_action(8, {ICON = fa.ARROWS_CROSS, COLOR_BG = imgui.ImVec4(0.56, 0.56, 0.58, 1.00), SDVIG = {2, 0}}, 'Если') then
			table.insert(bl_cmd.act, number_i_cmd + 1, {
				'IF',
				1, --> Условие
				{'', ''}, --> Входные данные,
				bl_cmd.id_element,
				1,
				false --> Свернутый блок
			})
			table.insert(bl_cmd.act, number_i_cmd + 2, {
				'ELSE',
				bl_cmd.id_element
			})
			table.insert(bl_cmd.act, number_i_cmd + 3, {
				'END',
				bl_cmd.id_element
			})
			imgui.CloseCurrentPopup()
		end
		if add_action(9, {ICON = fa.CLOCK_ROTATE_LEFT, COLOR_BG = imgui.ImVec4(1.00, 0.50, 0.88, 1.00), SDVIG = {1, 0}}, 'Изменить задержку отыгровки') then
			table.insert(bl_cmd.act, number_i_cmd + 1, {
				'DELAY',
				delay_act_def
			})
			imgui.CloseCurrentPopup()
		end
		if add_action(10, {ICON = fa.HAND, COLOR_BG = imgui.ImVec4(0.56, 0.56, 0.58, 1.00), SDVIG = {1, 0}}, 'Остановить отыгровку') then
			table.insert(bl_cmd.act, number_i_cmd + 1, {
				'STOP'
			})
			imgui.CloseCurrentPopup()
		end
		if add_action(11, {ICON = fa.COMMENT, COLOR_BG = imgui.ImVec4(1.00, 0.58, 0.00, 1.00), SDVIG = {1, -1}}, 'Комментарий') then
			table.insert(bl_cmd.act, number_i_cmd + 1, {
				'COMMENT',
				''
			})
			imgui.CloseCurrentPopup()
		end
			if add_action(12, {ICON = fa.PEN_TO_SQUARE, COLOR_BG = imgui.ImVec4(0.20, 0.60, 0.80, 1.00), SDVIG = {0, 0}}, 'Отправить текст в диалог') then
			table.insert(bl_cmd.act, number_i_cmd + 1, {
				'SEND_DIALOG',
				''
			})
			imgui.CloseCurrentPopup()
		end
		if add_action(13, {ICON = fa.ARROW_POINTER, COLOR_BG = imgui.ImVec4(0.20, 0.80, 0.60, 1.00), SDVIG = {5, 0}}, 'Нажать рядок в диалоге') then
			table.insert(bl_cmd.act, number_i_cmd + 1, {
				'SELECT_DIALOG_ROW',
				'1'
			})
			imgui.CloseCurrentPopup()
		end
		if add_action(14, {ICON = fa.SHARE, COLOR_BG = imgui.ImVec4(1.00, 0.58, 0.00, 1.00), SDVIG = {1, 0}}, 'Открыть текстовый блок') then
			local text_to_process = ffi.string(text_multilineBlock)
			local lines = {}
			for line in text_to_process:gmatch("(.-)[\r\n]") do
				local trimmed_line = line:match("^%s*(.-)%s*$")
				if trimmed_line ~= "" then
					table.insert(lines, trimmed_line)
				end
			end
			local last_line = text_to_process:match("([^\r\n]*)$")
			if last_line and last_line ~= "" and not text_to_process:match("[\r\n]$") then
				local trimmed_last_line = last_line:match("^%s*(.-)%s*$")
				if trimmed_last_line ~= "" then
					table.insert(lines, trimmed_last_line)
				end
			end
			local insert_index = number_i_cmd + 1
			for i, line in ipairs(lines) do
				table.insert(bl_cmd.act, insert_index, {
					'SEND',
					line
				})
				insert_index = insert_index + 1
			end
			text_multilineBlock = imgui.new.char[512000]('') 
			imgui.CloseCurrentPopup()
		end
		imgui.EndChild()
		--new_text_block_popup()
		imgui.EndPopup()
	end
end

function tags_in_cmd()
	if popup_open_tags then
		popup_open_tags = false
		imgui.OpenPopup(u8'Теги в командах')
	end
	if imgui.BeginPopupModal(u8'Теги в командах', null, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar) then
		imgui.SetCursorPos(imgui.ImVec2(10, 10))
		if imgui.InvisibleButton(u8'##Закрыть окно тегов', imgui.ImVec2(16, 16)) then
			imgui.CloseCurrentPopup()
		end
		imgui.SetCursorPos(imgui.ImVec2(16, 16))
		local p = imgui.GetCursorScreenPos()
		if imgui.IsItemHovered() then
			imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x - 0.4, p.y - 0.2), 7, imgui.GetColorU32Vec4(imgui.ImVec4(0.98, 0.32, 0.38 ,1.00)), 60)
		else
			imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x - 0.4, p.y - 0.2), 7, imgui.GetColorU32Vec4(imgui.ImVec4(0.98, 0.42, 0.38 ,1.00)), 60)
		end
		imgui.PushFont(font[2])
		imgui.SetCursorPos(imgui.ImVec2(172, 8))
		imgui.TextColored(imgui.ImVec4(0.50, 0.50, 0.50, 0.50), u8'Нажмите на тег, чтобы скопировать его')
		imgui.PopFont()
		gui.DrawLine({10, 32}, {536, 32}, cl.line)
		imgui.SetCursorPos(imgui.ImVec2(6, 33))
		imgui.BeginChild(u8'Выбор тегов в командах', imgui.ImVec2(540, 335), false)
		local all_list_tags = {
			{'{mynick}', 'Выведет Ваш никнейм на английском'},
			{'{myid}', 'Выведет Ваш id'},
			{'{mynickrus}', 'Выведет Ваш никнейм на русском'},
			{'{myrank}', 'Выведет Вашу должность'},
			{'{time}', 'Выведет текущее время'},
			{'{day}', 'Выведет текущий день'},
			{'{week}', 'Выведет текущую неделю'},
			{'{month}', 'Выведет текущий месяц'},
			{'{getplnick[id игрока]}', 'Выведет ник игрока по его ID'},
			{'{med7}', 'Выведет цену на новую мед. карту на 7 дней'},
			{'{med14}', 'Выведет цену на новую мед. карту на 14 дней'},
			{'{med30}', 'Выведет цену на новую мед. карту на 30 дней'},
			{'{med60}', 'Выведет цену на новую мед. карту на 60 дней'},
			{'{medup7}', 'Выведет цену на обновлённую мед. карту на 7 дней'},
			{'{medup14}', 'Выведет цену на обновлённую мед. карту на 14 дней'},
			{'{medup30}', 'Выведет цену на обновлённую мед. карту на 30 дней'},
			{'{medup60}', 'Выведет цену на обновлённую мед. карту на 60 дней'},
			{'{pricenarko}', 'Выведет цену на снятие укропозависимости'},
			{'{pricerecept}', 'Выведет цену на рецепт'},
			{'{priceant}', 'Выведет цену на антибиотик'},
			{'{pricelec}', 'Выведет цену на лечение'},
			{'{priceosm}', 'Выведет цену на мед. осмотр'},
			{'{priceguard}', 'Выведет цену на лечение охранника'},
			{'{priceauto1}', 'Выведет цену на авто на 1 месяц'},
			{'{priceauto2}', 'Выведет цену на авто на 2 месяца'},
			{'{priceauto3}', 'Выведет цену на авто на 3 месяца'},
			{'{pricemoto1}', 'Выведет цену на мото на 1 месяц'},
			{'{pricemoto2}', 'Выведет цену на мото на 2 месяца'},
			{'{pricemoto3}', 'Выведет цену на мото на 3 месяца'},
			{'{pricefly}', 'Выведет цену на полёты'},
			{'{pricefish1}', 'Выведет цену на рыбалку на 1 месяц'},
			{'{pricefish2}', 'Выведет цену на рыбалку на 2 месяца'},
			{'{pricefish3}', 'Выведет цену на рыбалку на 3 месяца'},
			{'{priceswim1}', 'Выведет цену на водный транспорт на 1 месяц'},
			{'{priceswim2}', 'Выведет цену на водный транспорт на 2 месяца'},
			{'{priceswim3}', 'Выведет цену на водный транспорт на 3 месяца'},
			{'{pricegun1}', 'Выведет цену на оружие на 1 месяц'},
			{'{pricegun2}', 'Выведет цену на оружие на 2 месяца'},
			{'{pricegun3}', 'Выведет цену на оружие на 3 месяца'},
			{'{pricehunt1}', 'Выведет цену на охоту на 1 месяц'},
			{'{pricehunt2}', 'Выведет цену на охоту на 2 месяца'},
			{'{pricehunt3}', 'Выведет цену на охоту на 3 месяца'},
			{'{priceexc1}', 'Выведет цену на раскопки на 1 месяц'},
			{'{priceexc2}', 'Выведет цену на раскопки на 2 месяца'},
			{'{priceexc3}', 'Выведет цену на раскопки на 3 месяца'},
			{'{pricetaxi1}', 'Выведет цену на такси на 1 месяц'},
			{'{pricetaxi2}', 'Выведет цену на такси на 2 месяца'},
			{'{pricetaxi3}', 'Выведет цену на такси на 3 месяца'},
			{'{pricemeh1}', 'Выведет цену на механика на 1 месяц'},
			{'{pricemeh2}', 'Выведет цену на механика на 2 месяца'},
			{'{pricemeh3}', 'Выведет цену на механика на 3 месяца'},
			{'{sex[муж. текст][жен. текст]}', 'Добавит текст в соответствии с выбранным полом'},
			{'{dialoglic[id лицензии][id срока][id игрока]}', 'Автовыбор диалога с лицензией'},
			{'{target}', 'Выведет id с последнего прицела на игрока'},
			{'{prtsc}', 'Сделает скриншот игры F8'},
			{'{random[мин. число][мах. число]}', 'Выведет рандомное число'},
			{'{nearplayer}', 'Получить id ближайшего игрока'},
			{'{getlevel[id игрока]}', 'Получить игровой уровень игрока'},
			{'{spcar}', 'Заспавнить транспорт организации (/lmenu)'},
			{'{PhoneApp[номер приложения]}', 'Открывает приложение в телефоне по списку'},
			{'{city}', 'Получить название текещуго города'},
			{'{veh_model}', 'Получить марку ближайшего транспорта с водителем (до 150м)'},
			{'{veh_speed}', 'Получить скорость ближайшего транспорта с водителем (до 150м)'},
			{'{square}', 'Получить текущий квадрат'},
			{'{pursuit_id}', 'Выдает id человека за которым вы в погоне'}
			--{'{unprison[id игрока]}', 'Автоматически подчищать задания для УДО (ТСР)'},
		}
		
		if an[25][1] > 0 then
			an[25][1] = an[25][1] - (anim * 2)
		end
		local pos_y_list = 0
		imgui.PushFont(font[3])
		for i = 1, #all_list_tags do
			local calc_text = imgui.CalcTextSize(u8(all_list_tags[i][1]))
			imgui.SetCursorPos(imgui.ImVec2(10, 5 + pos_y_list))
			imgui.Text(u8(all_list_tags[i][1]))
			imgui.SetCursorPos(imgui.ImVec2(10 + calc_text.x + 7, 5 + pos_y_list))
			imgui.TextColored(imgui.ImVec4(0.50, 0.50, 0.50, 0.50), u8(all_list_tags[i][2]))
			if an[25][2] == i then
				imgui.SetCursorPos(imgui.ImVec2(10, 5 + pos_y_list))
				imgui.TextColored(imgui.ImVec4(0.20, 0.78, 0.35, an[25][1]), u8(all_list_tags[i][1]))
				imgui.SetCursorPos(imgui.ImVec2(10 + calc_text.x + 7, 5 + pos_y_list))
				imgui.TextColored(imgui.ImVec4(0.20, 0.78, 0.35, an[25][1]), u8(all_list_tags[i][2]))
			end
			imgui.SetCursorPos(imgui.ImVec2(5, pos_y_list + 2))
			if imgui.InvisibleButton(u8'##Скопировать тег для команды ' .. i, imgui.ImVec2(519, 23)) then
				if insert_tag_popup[3] then
					insert_tag_popup[2] = u8(all_list_tags[i][1])
					insert_tag_popup[3] = false
					imgui.CloseCurrentPopup()
				else
					imgui.SetClipboardText(u8(all_list_tags[i][1]))
					an[25][1] = 3
					an[25][2] = i
				end
			end
			
			pos_y_list = pos_y_list + 25
		end
		imgui.PopFont()
		
		imgui.Dummy(imgui.ImVec2(0, 10))
		imgui.EndChild()
		imgui.EndPopup()
	end
end

function tags_in_call()
	if popup_open_tags_call then
		popup_open_tags_call = false
		imgui.OpenPopup(u8'Теги в вызовах')
	end
	if imgui.BeginPopupModal(u8'Теги в вызовах', null, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar) then
		imgui.SetCursorPos(imgui.ImVec2(10, 10))
		if imgui.InvisibleButton(u8'##Закрыть окно тегов вызовов', imgui.ImVec2(16, 16)) then
			imgui.CloseCurrentPopup()
		end
		imgui.SetCursorPos(imgui.ImVec2(16, 16))
		local p = imgui.GetCursorScreenPos()
		if imgui.IsItemHovered() then
			imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x - 0.4, p.y - 0.2), 7, imgui.GetColorU32Vec4(imgui.ImVec4(0.98, 0.32, 0.38 ,1.00)), 60)
		else
			imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x - 0.4, p.y - 0.2), 7, imgui.GetColorU32Vec4(imgui.ImVec4(0.98, 0.42, 0.38 ,1.00)), 60)
		end
		imgui.PushFont(font[2])
		imgui.SetCursorPos(imgui.ImVec2(172, 8))
		imgui.TextColored(imgui.ImVec4(0.50, 0.50, 0.50, 0.50), u8'Нажмите на тег, чтобы скопировать его')
		imgui.PopFont()
		gui.DrawLine({10, 32}, {536, 32}, cl.line)
		imgui.SetCursorPos(imgui.ImVec2(6, 33))
		imgui.BeginChild(u8'Выбор тегов в вызовах', imgui.ImVec2(540, 335), false)
		local all_list_tags = {
			{'{level}', 'Выведет уровень выбранного пожара'},
			{'{mynick}', 'Выведет Ваш никнейм на английском'},
			{'{myid}', 'Выведет Ваш id'},
			{'{mynickrus}', 'Выведет Ваш никнейм на русском'},
			{'{myrank}', 'Выведет Вашу должность'},
			{'{sex[муж. текст][жен. текст]}', 'Добавит текст в соответствии с выбранным полом'},
		}
		
		if an[30][1] > 0 then
			an[30][1] = an[30][1] - (anim * 2)
		end
		local pos_y_list = 0
		imgui.PushFont(font[3])
		for i = 1, #all_list_tags do
			local calc_text = imgui.CalcTextSize(u8(all_list_tags[i][1]))
			imgui.SetCursorPos(imgui.ImVec2(10, 5 + pos_y_list))
			imgui.Text(u8(all_list_tags[i][1]))
			imgui.SetCursorPos(imgui.ImVec2(10 + calc_text.x + 7, 5 + pos_y_list))
			imgui.TextColored(imgui.ImVec4(0.50, 0.50, 0.50, 0.50), u8(all_list_tags[i][2]))
			if an[30][2] == i then
				imgui.SetCursorPos(imgui.ImVec2(10, 5 + pos_y_list))
				imgui.TextColored(imgui.ImVec4(0.20, 0.78, 0.35, an[30][1]), u8(all_list_tags[i][1]))
				imgui.SetCursorPos(imgui.ImVec2(10 + calc_text.x + 7, 5 + pos_y_list))
				imgui.TextColored(imgui.ImVec4(0.20, 0.78, 0.35, an[30][1]), u8(all_list_tags[i][2]))
			end
			imgui.SetCursorPos(imgui.ImVec2(5, pos_y_list + 2))
			if imgui.InvisibleButton(u8'##Скопировать тег для команды ' .. i, imgui.ImVec2(519, 23)) then
				if insert_tag_popup[3] then
					insert_tag_popup[2] = u8(all_list_tags[i][1])
					insert_tag_popup[3] = false
					imgui.CloseCurrentPopup()
				else
					imgui.SetClipboardText(u8(all_list_tags[i][1]))
					an[30][1] = 3
					an[30][2] = i
				end
			end
			
			pos_y_list = pos_y_list + 25
		end
		imgui.PopFont()
		
		imgui.Dummy(imgui.ImVec2(0, 10))
		imgui.EndChild()
		imgui.EndPopup()
	end
end

function cmd_edit(nm_cmd_edit, cmd_cur)
	local new_cmd_return
	if imgui.BeginPopupModal(nm_cmd_edit, null, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar) then
		imgui.SetCursorPos(imgui.ImVec2(10, 10))
		if imgui.InvisibleButton(u8'##Закрыть ' .. nm_cmd_edit, imgui.ImVec2(16, 16)) then
			lockPlayerControl(false)
			edit_cmd = false
			imgui.CloseCurrentPopup()
		end
		imgui.SetCursorPos(imgui.ImVec2(16, 16))
		local p = imgui.GetCursorScreenPos()
		if imgui.IsItemHovered() then
			imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x - 0.4, p.y - 0.2), 7, imgui.GetColorU32Vec4(imgui.ImVec4(0.98, 0.32, 0.38 ,1.00)), 60)
		else
			imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x - 0.4, p.y - 0.2), 7, imgui.GetColorU32Vec4(imgui.ImVec4(0.98, 0.42, 0.38 ,1.00)), 60)
		end
		imgui.SetCursorPos(imgui.ImVec2(10, 35))
		imgui.BeginChild(u8'Назначение команды ' .. nm_cmd_edit, imgui.ImVec2(357, 171), false, imgui.WindowFlags.NoScrollbar)
		
		imgui.PushFont(font[3])
		imgui.SetCursorPos(imgui.ImVec2(10, 0))
		imgui.Text(u8'Введите необходимую команду')
		imgui.SetCursorPos(imgui.ImVec2(10, 25))
		imgui.Text(u8'Текущая команда:')
		imgui.SetCursorPos(imgui.ImVec2(135, 25))
		if cmd_cur == '' then
			imgui.TextColored(imgui.ImVec4(0.90, 0.22, 0.22, 1.00), u8'Отсутствует')
		else
			imgui.TextColored(imgui.ImVec4(0.90, 0.63, 0.22, 1.00), '/' .. cmd_cur)
		end
		gui.DrawLine({0, 50}, {381, 50}, cl.line)
		imgui.SetCursorPos(imgui.ImVec2(10, 70))
		imgui.Text('/')
		new_cmd = gui.InputText({27, 71}, 300, new_cmd, u8'Назначение команды', 60, u8'Введите команду', 'en')
		gui.DrawLine({0, 103}, {381, 103}, cl.line)
		local bool_new_cmd = false
		if #all_cmd ~= 0 then
			for i = 1, #all_cmd do
				if all_cmd[i] == new_cmd and new_cmd ~= cmd_cur then
					bool_new_cmd = true
					break
				end
			end
		end
		
		if not bool_new_cmd then
			imgui.SetCursorPos(imgui.ImVec2(67, 110))
			imgui.TextColored(imgui.ImVec4(0.08, 0.64, 0.11, 1.00), u8'Всё хорошо! Можете применять.')
			if gui.Button(u8'Применить', {10, 132}, {158, 27}) then
				if new_cmd ~= cmd_cur then
					if #all_cmd ~= 0 then
						for m = 1, #all_cmd do
							if all_cmd[m] == cmd_cur then
								sampUnregisterChatCommand(all_cmd[m])
								table.remove(all_cmd, m)
								new_cmd_return = ''
								break
							end
						end
					end
					if new_cmd ~= '' then
						table.insert(all_cmd, new_cmd)
						new_cmd_return = new_cmd
					end
				end
				
				lockPlayerControl(false)
				edit_cmd = false
				imgui.CloseCurrentPopup()
			end
		else
			imgui.SetCursorPos(imgui.ImVec2(69, 110))
			imgui.TextColored(imgui.ImVec4(0.90, 0.22, 0.22 ,1.00), u8'Такая команда уже существует!')
			if gui.Button(u8'Применить', {10, 132}, {158, 27}, false) then
				
			end
		end
		imgui.PopFont()
		
		if gui.Button(u8'Отменить', {179, 132}, {158, 27}) then
			lockPlayerControl(false)
			edit_cmd = false
			imgui.CloseCurrentPopup()
		end
		
		imgui.EndChild()
		imgui.EndPopup()
	end
	
	return new_cmd_return
end

function key_edit(name_popup_key, key_cur)
	if imgui.BeginPopupModal(name_popup_key, null, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar) then
		imgui.SetCursorPos(imgui.ImVec2(10, 10))
		if imgui.InvisibleButton(u8'##Закрыть окно' .. name_popup_key, imgui.ImVec2(16, 16)) then
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
		imgui.BeginChild(u8'Назначение клавиши' .. name_popup_key, imgui.ImVec2(390, 181), false, imgui.WindowFlags.NoScrollbar)
		
		imgui.PushFont(font[3])
		imgui.SetCursorPos(imgui.ImVec2(10, 0))
		imgui.Text(u8'Нажмите на необходимую клавишу или комбинацию')
		imgui.SetCursorPos(imgui.ImVec2(10, 25))
		imgui.Text(u8'Текущее сочетание:')
		imgui.SetCursorPos(imgui.ImVec2(145, 25))
		if #key_bool_cur == 0 then
			imgui.TextColored(imgui.ImVec4(0.90, 0.22, 0.22 ,1.00), u8'Отсутствует')
		else
			local all_key = {}
			for i = 1, #key_bool_cur do
				table.insert(all_key, vkeys.id_to_name(key_bool_cur[i]))
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
			if not compare_array_disable_order(key_cur[2], current_key[2]) then
				local is_hot_key_done = false
				local num_hot_key_remove = 0
				local remove_sd = false
				
				if #current_key[2] == 0 and #key_cur[2] ~= 0 then
					remove_sd = true
					for i = 1, #all_keys do
						if compare_array_disable_order(all_keys[i], key_cur[2]) then
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
							if compare_array_disable_order(all_keys[i], key_cur[2]) then
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
							rkeys.unRegisterHotKey(key_cur[2])
						end
						key_cur[2] = current_key[2]
						key_cur[1] = current_key[1]
						table.insert(all_keys, current_key[2])
						rkeys.registerHotKey(current_key[2], 3, true, function() on_hot_key(key_cur[2]) end)
						lockPlayerControl(false)
						edit_key = false
						imgui.CloseCurrentPopup()
						return {true, key_cur}
					end
				else
					table.remove(all_keys, num_hot_key_remove)
					rkeys.unRegisterHotKey(key_cur[2])
					key_cur = {'', {}}
					lockPlayerControl(false)
					edit_key = false
					imgui.CloseCurrentPopup()
					return {true, key_cur}
				end
			else
				lockPlayerControl(false)
				edit_key = false
				imgui.CloseCurrentPopup()
				return {false, key_cur}
			end
			save()
		end
		if gui.Button(u8'Очистить', {194, 144}, {186, 29}) then
			current_key = {'', {}}
		end
			
		imgui.EndChild()
		imgui.EndPopup()
	end
	
	return {false, key_cur}
end

function draw_gradient_border(time, speed_border)
	local function transfusion(speed_f, pl_rgb)
		local r = math.floor(math.sin((os.clock() + pl_rgb) * speed_f) * 127 + 128) / 255
		local g = math.floor(math.sin((os.clock() + pl_rgb) * speed_f + 2) * 127 + 128) / 255
		local b = math.floor(math.sin((os.clock() + pl_rgb) * speed_f + 4) * 127 + 128) / 255
		
		return imgui.ImVec4(r, g, b, 1.00)
	end
	local color = transfusion(speed_border, 0.15)
	imgui.SetCursorPos(imgui.ImVec2(0, 0))
	local p = imgui.GetCursorScreenPos()
	imgui.GetWindowDrawList():AddRect(imgui.ImVec2(p.x + 4, p.y + 4), imgui.ImVec2(p.x + 844, p.y + 444), imgui.GetColorU32Vec4(color), 11, 15, 2)
end

function draw_gradient_image_music(speed_border, x_b, y_b, s_b_x, s_b_y, radius)
	local function transfusion(speed_f, pl_rgb, visible_text)
		local r = math.floor(math.sin((os.clock() + pl_rgb) * speed_f) * 127 + 128) / 255
		local g = math.floor(math.sin((os.clock() + pl_rgb) * speed_f + 2) * 127 + 128) / 255
		local b = math.floor(math.sin((os.clock() + pl_rgb) * speed_f + 4) * 127 + 128) / 255
		
		return imgui.ImVec4(r, g, b, (visible_text or 1))
	end
	
	imgui.SetCursorPos(imgui.ImVec2(0, 0))
	local p = imgui.GetCursorScreenPos()
	local base_x, base_y = p.x + x_b, p.y + y_b
	local width, height = s_b_x, s_b_y
	local color2 = transfusion(speed_border, 0.15, 0.4)

	for i = 1, 15 do
		local alpha = color2.w * (1 - i / 15)
		local color = transfusion(speed_border, 0.15, alpha)
		imgui.GetWindowDrawList():AddRectFilled(imgui.ImVec2(base_x - i, base_y - i), imgui.ImVec2(base_x + width + i, base_y + height + i), imgui.GetColorU32Vec4(color), radius or 15 , 15)
	end
end

win.main = imgui.OnFrame(
	function() return windows.main[0] end,
	function(main)
		local coud = imgui.Cond.FirstUseEver
		if anim_func or close_win_anim then
			coud = imgui.Cond.Always
		end
		if anim_func then
			close_win_anim = false
			if win_x > sx / 2 then
				win_x = win_x - (anim * 4500)
				if win_x <= sx / 2 then 
					win_x = sx / 2 
					anim_func = false
				end
			end
		end
		imgui.SetNextWindowPos(imgui.ImVec2(win_x, win_y), coud, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(848, 448)) --> 848 x 448
		imgui.Begin('Main', windows.main,  imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoResize)
		bug_fix_input()
		
		if close_win_anim then
			main.HideCursor = true
		else
			main.HideCursor = false
		end
		--> Основной фон и полигоны
		if setting.first_start then
			local times = os.clock() * 2
			draw_gradient_border(times, 0.9)
		end
		
		local window_bg_color = imgui.ImVec4(cl.main.x, cl.main.y, cl.main.z, setting.window_alpha)
		gui.Draw({4, 4}, {840, 440}, window_bg_color, 12, 15)
	
		if setting.first_start then
			if first_start == 0 then
				imgui.SetCursorPos(imgui.ImVec2(317, 187))
				imgui.PushFont(bold_font[2])
				an[1] = an[1] - (anim * 1.4)
				gui.TextGradient('Привет', 0.5, an[1])
				imgui.PopFont()
				
				if an[1] < 0 then first_start = 1 end
			elseif first_start == 1 then
				imgui.SetCursorPos(imgui.ImVec2(45, 187))
				imgui.PushFont(bold_font[2])
				if an[2] >= 2 then stop_anim[1] = true end
				if not stop_anim[1] then
					an[2] = an[2] + (anim * 1.4)
				else
					an[2] = an[2] - (anim * 1.4)
				end
				
				gui.TextGradient('Давайте настроим хелпер', 0.5, an[2])
				imgui.PopFont()
				
				if an[2] < 0 then first_start = 2 end
			elseif first_start == 2 then
				imgui.SetCursorPos(imgui.ImVec2(78, an[4]))
				imgui.PushFont(bold_font[2])
				if an[3] <= 1.2 then
					an[3] = an[3] + (anim * 0.7)
				elseif an[4] > 40 then
					an[4] = an[4] - (anim * 290)
				end
				gui.TextGradient('Выберите организацию', 0.5, an[3])
				imgui.PopFont()
				if an[4] <= 40 then
					gui.DrawLine({24, 391}, {824, 391}, imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
					if gui.Button(u8'Продолжить', {715, 403}, {104, 30}) then
						first_start = 3
					end

				local start_orgs = {
					u8'Центр Лицензирования',
					u8'Правительство',
					u8'Пожарный департамент',
					u8'Тюрьма строгого режима',
					u8'Больница',
					u8'Армия',
					u8'Министерство Юстиции',
					u8'СМИ'
				}
				local vis_targ = 0

				if setting.org == 5 then vis_targ = 1
					elseif setting.org == 6 then vis_targ = 2
					elseif setting.org == 9 then vis_targ = 3
					elseif setting.org == 10 then vis_targ = 4
					elseif setting.org >= 1 and setting.org <= 4 then vis_targ = 5
					elseif setting.org >= 7 and setting.org <= 8 then vis_targ = 6
					elseif setting.org >= 11 and setting.org <= 15 then vis_targ = 7
					elseif setting.org >= 16 and setting.org <= 18 then vis_targ = 8 
				end

				local new_targ = gui.LT_First_Start({300, 116}, {249, 198}, start_orgs, vis_targ, u8'Выбрать организацию')

				if new_targ ~= vis_targ then
					hospital_spoiler[0] = (new_targ == 5)
					army_spoiler[0] = (new_targ == 6)
					smi_spoiler[0] = (new_targ == 8)
					police_spoiler[0] = (new_targ == 7)
					if new_targ == 1 then setting.org = 5
					elseif new_targ == 2 then setting.org = 6
					elseif new_targ == 3 then setting.org = 9
					elseif new_targ == 4 then setting.org = 10
					elseif new_targ == 5 then setting.org = 1
					elseif new_targ == 6 then setting.org = 7
					elseif new_targ == 7 then setting.org = 11
					elseif new_targ == 8 then setting.org = 16
					end
				end

				local arrow_x = 525
				local base_y = 116 + 4
				local item_height = 25

				local hospital_y = base_y + ((5 - 1) * item_height)
				local hospital_icon = hospital_spoiler[0] and fa.CARET_LEFT or fa.CARET_RIGHT
				gui.FaText(arrow_x, hospital_y, hospital_icon, fa_font[2])

				local army_y = base_y + ((6 - 1) * item_height)
				local army_icon = army_spoiler[0] and fa.CARET_LEFT or fa.CARET_RIGHT
				gui.FaText(arrow_x, army_y, army_icon, fa_font[2])
				
				local police_y = base_y + ((7 - 1) * item_height)
				local police_icon = police_spoiler[0] and fa.CARET_LEFT or fa.CARET_RIGHT
				gui.FaText(arrow_x, police_y, police_icon, fa_font[2])

				local smi_y = base_y + ((8 - 1) * item_height)
				local smi_icon = smi_spoiler[0] and fa.CARET_LEFT or fa.CARET_RIGHT
				gui.FaText(arrow_x, smi_y, smi_icon, fa_font[2])

				if hospital_spoiler[0] then
					local hospital_cities = {u8'Больница Лос-Сантос', u8'Больница Сан-Фиерро', u8'Больница Лас-Вентурас', u8'Больница Джефферсон'}
					local visually_selected_hospital = (setting.org >= 1 and setting.org <= 4) and setting.org or 1
					local new_hospital_selection = gui.LT_First_Start({560, 116 + ((5 - 1) * 25)}, {249, 98}, hospital_cities, visually_selected_hospital, u8'Выбрать больницу')
					if new_hospital_selection ~= visually_selected_hospital then
						setting.org = new_hospital_selection
					end
				end
				if army_spoiler[0] then
					local army_cities = {u8'Армия Лос-Сантос', u8'Армия Сан-Фиерро'}
					local visually_selected_army = (setting.org >= 7 and setting.org <= 8) and (setting.org - 6) or 1
					local new_army_selection = gui.LT_First_Start({560, 116 + ((6 - 1) * 25)}, {249, 47}, army_cities, visually_selected_army, u8'Выбрать армию')
					if new_army_selection ~= visually_selected_army then
						setting.org = new_army_selection + 6
					end
				end
				if smi_spoiler[0] then
					local smi_cities = {u8'СМИ ЛС', u8'СМИ СФ', u8'СМИ ЛВ'}
					local visually_selected_smi = (setting.org >= 16 and setting.org <= 18) and (setting.org - 15) or 1
					local new_smi_selection = gui.LT_First_Start({560, 116 + ((8 - 1) * 25)}, {249, 73}, smi_cities, visually_selected_smi, u8'Выбрать СМИ')
					if new_smi_selection ~= visually_selected_smi then
						setting.org = new_smi_selection + 15
					end
				end
				if police_spoiler[0] then
					local police_deps = {u8'Полиция Лос-Сантос', u8'Полиция Лас-Вентурас', u8'Полиция Сан-Фиерро', u8'Полиция Рэд-Каунти', u8'ФБР'}
					local visually_selected_police = (setting.org >= 11 and setting.org <= 15) and (setting.org - 10) or 1
					local new_police_selection = gui.LT_First_Start({560, 116 + ((7 - 1) * 25)}, {249, 125}, police_deps, visually_selected_police, u8'Выбрать департамент')
					if new_police_selection ~= visually_selected_police then
						setting.org = new_police_selection + 10
					end
				end
			end
			elseif first_start == 3 then
				imgui.PushFont(bold_font[2])
				imgui.SetCursorPos(imgui.ImVec2(120, an[4]))
				gui.TextGradient('Никнейм на русском', 0.5, 1.00)
				imgui.PopFont()
				gui.DrawLine({24, 391}, {824, 391}, imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
				if not setting.name_rus:find('%S+%s+%S+') then
					gui.Button(u8'Продолжить', {715, 403}, {104, 30}, false)
				else
					if gui.Button(u8'Продолжить', {715, 403}, {104, 30}) then
						first_start = 4
					end
				end
				if gui.Button(u8'Назад', {640, 403}, {62, 30}) then
					first_start = 2
				end
				
				setting.name_rus = gui.InputText({272, 231}, 300, setting.name_rus, u8'Имя на русском', 60, u8'Введите Ваш никнейм на русском', 'rus')
			elseif first_start == 4 then
				imgui.PushFont(bold_font[2])
				imgui.SetCursorPos(imgui.ImVec2(83, an[4]))
				gui.TextGradient('Пол Вашего персонажа', 0.5, 1.00)
				imgui.PopFont()
				gui.DrawLine({24, 391}, {824, 391}, imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
				if gui.Button(u8'Продолжить', {715, 403}, {104, 30}) then
					first_start = 5
				end
				if gui.Button(u8'Назад', {640, 403}, {62, 30}) then
					first_start = 3
				end
				
				setting.sex = gui.ListTableHorizontal({304, 229}, {u8'Мужской', u8'Женский'}, setting.sex, u8'Выбрать пол персонажа')
			elseif first_start == 5 then
				imgui.PushFont(bold_font[2])
				imgui.SetCursorPos(imgui.ImVec2(160, an[4]))
				gui.TextGradient('Тема оформления', 0.5, 1.00)
				imgui.PopFont()
				
				gui.Draw({148, 162}, {252, 132}, imgui.ImVec4(0.98, 0.98, 0.98, 1.00), 7, 15)
				gui.Draw({448, 162}, {252, 132}, imgui.ImVec4(0.10, 0.10, 0.10, 1.00), 7, 15)
				
				--> Дизайн окон выбора темы
				gui.Draw({148, 162}, {252, 20}, imgui.ImVec4(0.91, 0.89, 0.76, 1.00), 7, 3)
				gui.Draw({448, 162}, {252, 20}, imgui.ImVec4(0.13, 0.13, 0.13, 1.00), 7, 3)
				gui.Draw({148, 274}, {252, 20}, imgui.ImVec4(0.91, 0.89, 0.76, 1.00), 7, 12)
				gui.Draw({448, 274}, {252, 20}, imgui.ImVec4(0.13, 0.13, 0.13, 1.00), 7, 12)
				gui.Draw({181, 279}, {10, 10}, imgui.ImVec4(0.81, 0.79, 0.66, 1.00), 3, 15)
				gui.Draw({224, 279}, {10, 10}, imgui.ImVec4(0.81, 0.79, 0.66, 1.00), 3, 15)
				gui.Draw({267, 279}, {10, 10}, imgui.ImVec4(0.81, 0.79, 0.66, 1.00), 3, 15)
				gui.Draw({310, 279}, {10, 10}, imgui.ImVec4(0.81, 0.79, 0.66, 1.00), 3, 15)
				gui.Draw({353, 279}, {10, 10}, imgui.ImVec4(0.81, 0.79, 0.66, 1.00), 3, 15)
				gui.Draw({481, 279}, {10, 10}, imgui.ImVec4(0.20, 0.20, 0.20, 1.00), 3, 15)
				gui.Draw({524, 279}, {10, 10}, imgui.ImVec4(0.20, 0.20, 0.20, 1.00), 3, 15)
				gui.Draw({567, 279}, {10, 10}, imgui.ImVec4(0.20, 0.20, 0.20, 1.00), 3, 15)
				gui.Draw({610, 279}, {10, 10}, imgui.ImVec4(0.20, 0.20, 0.20, 1.00), 3, 15)
				gui.Draw({653, 279}, {10, 10}, imgui.ImVec4(0.20, 0.20, 0.20, 1.00), 3, 15)
				gui.Draw({244, 167}, {60, 10}, imgui.ImVec4(0.60, 0.60, 0.60, 0.30), 15, 15)
				gui.Draw({158, 197}, {200, 10}, imgui.ImVec4(0.60, 0.60, 0.60, 0.30), 15, 15)
				gui.Draw({158, 222}, {100, 10}, imgui.ImVec4(0.60, 0.60, 0.60, 0.30), 15, 15)
				gui.Draw({158, 247}, {150, 10}, imgui.ImVec4(0.60, 0.60, 0.60, 0.30), 15, 15)
				gui.Draw({544, 167}, {60, 10}, imgui.ImVec4(0.60, 0.60, 0.60, 0.30), 15, 15)
				gui.Draw({458, 197}, {200, 10}, imgui.ImVec4(0.40, 0.40, 0.40, 0.30), 15, 15)
				gui.Draw({458, 222}, {100, 10}, imgui.ImVec4(0.40, 0.40, 0.40, 0.30), 15, 15)
				gui.Draw({458, 247}, {150, 10}, imgui.ImVec4(0.40, 0.40, 0.40, 0.30), 15, 15)
				gui.DrawCircle({158, 172}, 4, imgui.ImVec4(0.98, 0.40, 0.38, 1.00))
				gui.DrawCircle({458, 172}, 4, imgui.ImVec4(0.98, 0.40, 0.38, 1.00))
				
				if setting.cl == 'White' then
					gui.DrawEmp({148, 162}, {252, 132}, cl.def, 7, 15, 3)
				else
					gui.DrawEmp({448, 162}, {252, 132}, cl.def, 7, 15, 3)
				end
				
				imgui.SetCursorPos(imgui.ImVec2(148, 162))
				if imgui.InvisibleButton(u8'##Выбрать светлую тему', imgui.ImVec2(252, 132)) then
					if setting.cl ~= 'White' then
						change_design('White')
					end
				end
				imgui.SetCursorPos(imgui.ImVec2(448, 162))
				if imgui.InvisibleButton(u8'##Выбрать тёмную тему', imgui.ImVec2(252, 132)) then
					if setting.cl ~= 'Black' then
						change_design('Black')
					end
				end
				
				gui.Text(247, 309, 'Светлая', font[3])
				gui.Text(550, 309, 'Тёмная', font[3])
				
				gui.DrawLine({24, 391}, {824, 391}, imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
				if gui.Button(u8'Продолжить', {715, 403}, {104, 30}) then
					first_start = 6
				end
				if gui.Button(u8'Назад', {640, 403}, {62, 30}) then
					first_start = 4
				end
			elseif first_start == 6 then
				imgui.PushFont(bold_font[2])
				imgui.SetCursorPos(imgui.ImVec2(29, an[4]))
				gui.TextGradient('Лицензионное соглашение', 0.5, 1.00)
				imgui.PopFont()
				gui.Draw({28, 114}, {792, 253}, cl.tab, 7, 15)
				imgui.SetCursorPos(imgui.ImVec2(38, 114))
				imgui.BeginChild(u8'Лицензионное соглашение', imgui.ImVec2(782, 253), false, imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollWithMouse)
				imgui.Scroller(u8'Лицензионное соглашение', img_step[1][0], img_duration[1][0], imgui.HoveredFlags.AllowWhenBlockedByActiveItem)
				imgui.SetCursorPosY(14)
				imgui.PushFont(bold_font[1])
				imgui.SetCursorPosX(10)
				imgui.Text(u8'1. Основные термины и определения')
				imgui.PopFont()
				imgui.PushFont(font[3])
				imgui.TextWrapped(u8'1.1 Правообладатель - ИТД Марсель Афанасьев: это лицо, которое обладает правами собственности на интеллектуальную собственность, такую как авторские права, патенты, торговые марки и другие права, связанные с созданием и использованием интеллектуальных продуктов или изобретений. Термин "Правообладатель" также включает в себя разработчика, менеджера, директора, поставщика и других ответственных сторон, участвующих в создании, управлении и поставке Программы (см. определение ниже). Это объединяющий термин, включающий все заинтересованные стороны, которые имеют право предоставлять разрешения на использование Программы (см. определение ниже) и управлять правами доступа в соответствии с данным Лицензионным соглашением (данный договор между двумя сторонами: (Пользователь (см. определение ниже) и Правообладатель), далее "Соглашение").\nПравообладателем данной Программы (см. определение ниже), а также официальным обладателем авторских прав и интеллектуальной собственности, является единственное лицо. Все иные лица, причастные к созданию, разработке, поддержке и другим терминам включающих в себя определение из термина Правообладателя, за исключением правами собственности на интеллектуальную собственность, такую как авторские права, патенты, торговые марки и другие права, связанные с созданием и использованием интеллектуальных продуктов или изобретений данного программного обеспечения (далее "ПО"), являются партнёрами (далее "Партнёр", "Партнёры") Правообладателя.\n')
				imgui.TextWrapped(u8'Термин относится к ПО, в котором находится данное Лицензионное соглашение или на одном виртуальном, облачном или удалённом носителе, учётной записи одного Пользователя всего ресурса, сайта или хранилища, на котором расположено ПО.\n\n')
				imgui.TextWrapped(u8'1.2 Программа - это ПО, принадлежащее Правообладателю, которое было приобретено и установлено на Носитель (см. определение ниже) технического устройства. Из списка выпущенных Правообладателем Программ, данный термин относится ко всем ПО, включающих в своём названии словосочетание "State Helper", написанное на английском языке в любом из возможных вариантов регистра букв.\nНаименование ПО можно найти в свойствах файла установленного с источников Правообладателя в случае, если файл не был отредактирован в последствии перемещения его на Носитель (см. определение ниже) технического устройства.\n\n')
				imgui.TextWrapped(u8'1.3 Носитель - устройство или средство, используемое для хранения и передачи данных. Это может быть физический объект, такой как жёсткий диск, USB-флешка, CD, DVD, Blu-ray диск или другие съёмные устройства хранения информации.\n\n1.4 Arizona Role Play - это проект ролевой игры (Role-Play) на платформе SA:MP (San Andreas Multiplayer), принадлежащий игровой компании Arizona Games. В этом проекте игроки могут взаимодействовать в виртуальном мире, исполняя определенные роли и выполняя задания в атмосфере, созданной на базе игры Grand Theft Auto: San Andreas с использованием мультиплеерной платформы SA:MP.\n\n1.5 Руководство пользователя - документ, который содержит инструкцию о том, как правильно использовать Программу, предоставленную Правообладателем.\n\n1.6 Пользователь - человек, установивший или использующий Программу, предоставленную Правообладателем.\n\n1.7 Блокировка программы - это техническая или программная мера, которая преднамеренно ограничивает доступ Пользователя к определенным функциям, данным или ресурсам Программы.\n\n1.8 Интернет - информационно-телекоммуникационная сеть, т. е. технологическая система, предназначенная для передачи по линиям связи информации, доступ к которой осуществляется с использованием средств вычислительной техники.\n\n1.9 Установка - процесс размещения Программы на компьютере или устройстве, чтобы она стала доступной и готовой к использованию. Во время установки происходит копирование файлов Программы на жёсткий диск или другое физическое хранилище, кроме тех, доступ к которым требует наличия Интернета.\n\n')
				imgui.TextWrapped(u8'1.10 Игра - конкретный вид развлекательной деятельности, не связанный с непосредственными задачами жизнеобеспечения, выполняющий функции заполнения досуга человека.\n\n1.11 Версия программы - присвоенный номер Программы, позволяющий определить новизну ПО, т. е. дату его выхода, а также различия относительно предыдущих версий Программы.\nВерсия программы отображена в самой Программе под соответствующим названием включающая в своём словосочетании слово "Версия".\n\n1.12 Закрытое тестирование - процесс исследования, испытания ПО, имеющий своей целью проверку соответствия между реальным поведением программы и её ожидаемым поведением на конечном наборе тестов, выбранных определённым образом.\nПроцесс осуществляется без учёта возможности публикации такого ПО в общий доступ, дающий возможность любому Пользователю осуществить установку ПО.\nТермин применяется к Программе, имеющей в своём программном коде заданную условную переменную "Beta" не соответствующей второму числу текущей Версии программы.\n\n')
				imgui.PushFont(bold_font[1])
				imgui.SetCursorPosX(10)
				imgui.Text(u8'2. Лицензия')
				imgui.PopFont()
				imgui.TextWrapped(u8'2.1 Правообладатель предоставляет Вам неисключительную лицензию на использование Программы для упрощения процесса Игры на проекте Arizona Role Play, описанных в Руководстве пользователя, при условии, в котором Вами соблюдены все необходимые требования, описанные в Руководстве пользователя, а также всех ограничений и условий использования Программы, указанных в настоящем Соглашении.\nВ случае использования Программы для тестирования функциональности, Правообладатель предоставляет Вам неисключительную лицензию на тестирование программы при условии соблюдения Вами всех необходимых требований, описанных в Руководстве пользователя, а также всех ограничений и условий использования Программы, указанных в настоящем Соглашении.\n\n')
				imgui.TextWrapped(u8'2.2 При соблюдении определённых условий Вы можете создать копию программы типа "Закрытое тестирование" с единственной целью архивирования и замены правомерно установленного экземпляра в случае его утери, уничтожения или непригодности. Тем не менее, использование такой копии для иных целей запрещено, и владение ею должно прекратиться, если обладание правомерным экземпляром программы прекращается.\n\n')
				imgui.TextWrapped(u8'2.3 После установки программы Вам, по возможности, предоставляется право получать от Правообладателя или его Партнёров:\n- новые версии ПО по мере их выхода (через Интернет)\n- техническую поддержку (через Интернет)\n- доступ к информационным и вспомогательным ресурсам Правообладателя.\nДанные возможности не могут быть гарантированы Правообладателем и в праве перестать быть доступными любому Пользователю Программы в любой момент времени без объяснения причин.\n\n')
				imgui.TextWrapped(u8'2.4 В случае установки Программы типа "Закрытое тестирование" через Интернет, Вы имеете право использовать такую копию Программы исключительно на одном техническом устройстве или Ностеле. Количество созданных копий Программы на одном устройстве неограниченно. Запрещается создавать, распространять, передавать копию такой Программы через облачные хранилища, где доступ к ней могут получить другие лица, кроме Вас. Запрещается копировать такую Программу на носитель, физический доступ к которому у Вас отсутствует. Запрещено устанавливать такую копию Программу на любой носитель с источников, не включённых в перечень, описанный в данном Соглашении.\n\n')
				imgui.TextWrapped(u8'2.5 Программа считается установленной с момента её размещения на Носитель Пользователя, независимо от того, запущена она впоследствии Пользователем или нет.\n\n')
				
				imgui.PushFont(bold_font[1])
				imgui.SetCursorPosX(10)
				imgui.Text(u8'3. Обновления')
				imgui.PopFont()
				imgui.TextWrapped(u8'После установки программы на Носитель, Правообладатель предоставляет возможность Пользователям выбирать способ обновления Программы. Если Пользователь сам решит использовать автоматическое обновление, поставив соответствующую галочку в самой Программе, тогда обновления будут проводиться без дополнительного разрешения или согласия с его стороны.\n\nВ противном случае, если Пользователь не выбрал автоматическое обновление, процесс установки обновления будет требовать подтверждения Пользователя в самой Программе. Пользователю будет предоставлена возможность ознакомиться с деталями обновления и дать согласие на его установку перед началом процесса.\n\n')
				imgui.TextWrapped(u8'Независимо от выбранного способа обновления, каждое обновление будет регулироваться настоящим Соглашением, а содержание, функции и возможности обновленной Программы определяются исключительно Правообладателем. Эти обновления могут включать как добавление, так и удаление функций Программы, а также полную замену Программы. При этом Вам может быть ограничено использование Программы или устройства (включая определенные функции) до тех пор, пока обновление не будет полностью установлено или активировано.\n\nПравообладатель может прекратить предоставление поддержки Программы, пока Вы не установите все доступные обновления. Необходимость и периодичность предоставления обновлений определяется Правообладателем по его усмотрению, и Правообладатель не обязан предоставлять Вам обновления. Также Правообладатель может прекратить предоставление обновлений для версий Программы, отличных от наиболее новой версии, или для обновлений, которые не поддерживают использование Программы с различными версиями операционных систем или другим ПО.\n\n')
				imgui.PushFont(bold_font[1])
				imgui.SetCursorPosX(10)
				imgui.Text(u8'4. Права собственности')
				imgui.PopFont()
				imgui.TextWrapped(u8'4.1 Программа и её программный код являются интеллектуальной собственностью Правообладателя и защищены применимым авторским правом, а также международными договорами и законодательством Российской Федерации. Если Вы являетесь Пользователем, установившим Программу на законных основаниях, то Вы имеете право просматривать открытый программный код Программы. Предоставляя свои комментарии и предложения, касающиеся Программы, Вы предоставляете Правообладателю разрешение на их использование при разработке своих настоящих или будущих продуктов или услуг. При этом, Вы соглашаетесь, что такое использование не потребует выплаты компенсации и дополнительного разрешения от Вас на хранение или использование Ваших материалов.\n\n')
				imgui.TextWrapped(u8'4.2 Помимо указанных в настоящем Соглашении, владение Программой и её использование не предоставляют Вам какие-либо права на Программу или программный код, включая авторские права, патенты, торговые знаки и другие права интеллектуальной собственности. Все такие права полностью принадлежат Правообладателю Программы.\n\n')
				imgui.TextWrapped(u8'4.3 Вы не имеете права копировать или использовать Программу или её программный код, за исключением случаев, описанных в разделе 2 настоящего Соглашения.\n\n')
				imgui.PushFont(bold_font[1])
				imgui.SetCursorPosX(10)
				imgui.Text(u8'5. Конфиденциальность')
				imgui.PopFont()
				imgui.TextWrapped(u8'Вы даете Правообладателю и партнёрам Правообладателя согласие на использование Ваших данных в соответствии с политикой конфиденциальности. Вы осознаете, что Ваши данные будут использоваться для различных целей, таких как обработка событий использования Программы, улучшения Программы, предоставления Вам информации об установленной Программе и предложение Вам других Программ.\n\nВы также подтверждаете, что Правообладатель может передавать Ваши данные партнёрам Правообладателя, таким как поставщики платформы электронной коммерции, обработчики платежей, поставщики поддержки, услуг и Программ от имени Правообладателя, а также поставщики, предоставляющие Правообладателю или партнёрам Правообладателя аналитические данные о покупках и сбоях в работе Программы.\n\n')
				imgui.PushFont(bold_font[1])
				imgui.SetCursorPosX(10)
				imgui.Text(u8'6. Прекращение действия')
				imgui.PopFont()
				imgui.TextWrapped(u8'6.1 Если Вы нарушите любое из обязательств, установленных в данном соглашении, включая обязательства, определённые в разделах 2 или 5, настоящее Соглашение автоматически прекратится и Вы лишитесь права на получение обновлений Программы. При возникновении нарушения, которое причинило ущерб Правообладателю, Правообладатель имеет право обратиться к законным средствам защиты, предусмотренным законодательством. Отказ от ответственности и ограничения, установленные для Правообладателя в данном соглашении, будут действовать и после его прекращения.\n\n')
				imgui.TextWrapped(u8'6.2 Правообладатель имеет право уведомить Вас и прекратить действие данного Соглашения относительно конкретной Программы или всех Программ в любое удобное время. После фактического прекращения действия Соглашения Вы теряете право на использование Программы.\n\n')
				imgui.PushFont(bold_font[1])
				imgui.SetCursorPosX(10)
				imgui.Text(u8'7. Основные положения ответственности сторон')
				imgui.PopFont()
				imgui.TextWrapped(u8'7.1 Правообладатель не несёт никакой ответственности в следующих случаях:\n\n7.1.1 Программа не работает должным образом в связи с нестабильным подключением интернета, устаревшими или неработоспособными техническими характеристиками устройства или Носителя, на которое установлена Программа, недостающим дополнительным ПО, которое обеспечивает необходимую работу Программы, либо из-за пользовательского редактирования программного кода Программы.\n\n7.1.2 Нарушение одного и более пунктов данного Соглашения, после установки Программы.\n\n')
				imgui.TextWrapped(u8'7.1.3 Утеря одной или нескольких копий Программы после её установки.\n\n7.1.4 Потеря трудоспособности Пользователя по любой причине, вследствие чего Пользователь не имеет более физической возможности использовать Программу.\n\n7.1.5 Пользователь согласился использовать Программу, прочитав Лицензионное соглашение, но в последствии, по собственной инициативе, решил отказаться от использования Программы.\n\n7.1.6 Пользователь не получает обновления Программы.\n\n7.1.7 Пользователь не имеет свободного места для установки Программы на Носитель.\n\n7.1.8 Пользователь не имеет возможности установить Программу в связи с отсутствием или нестабильным подключением Интернета.\n\n7.1.9 Пользователь не имеет возможности установить Программу в связи с ограничениями в стране или регионе, в котором он находится.\n\n7.1.10 Пользователь не имеет возможности установить Программу в связи с ПО, через которое он пытается совершить установку.\n\n')
				imgui.TextWrapped(u8'7.1.11 Пользователя не удовлетворили ожидания процесса работы Программы или его функциональные возможности.\n\n7.1.12 Пользователь погиб, либо получил физическую или моральную травму в результате пользования Программой.\n\n7.2 Пользователь несёт полную ответственность перед Правообладателем за соблюдение условий Соглашения.\n\n7.3 Программа предоставляется на международных условиях «как есть» (as is). Правообладатель не гарантирует безошибочную и бесперебойную работы Программы, её отдельных компонентов, функциональности, каким-либо целям и ожиданиям Пользователя, а также не предоставляет никаких иных гарантий, прямо не указанных в Соглашении.\n\n7.4 Правообладатель вправе изменить условия настоящего Соглашения в любой момент времени без предварительного уведомления Пользователя об этом.\n\n')
				imgui.PushFont(bold_font[1])
				imgui.SetCursorPosX(10)
				imgui.Text(u8'8. Общие положения')
				imgui.PopFont()
				imgui.TextWrapped(u8'8.1 Уведомления. В произвольное время Поставщик может направить Вам уведомление по электронной почте, через всплывающее окно, диалоговое окно или другие средства, даже если в некоторых случаях Вы можете не получить уведомление до тех пор, пока не запустите Программу. Такое уведомление считается доставленным с момента, когда Правообладатель сделал его доступным через Программу, независимо от фактического времени получения.\n\n8.2 Вопросы по данному Соглашению. Если у Вас возникнут вопросы относительно данного Соглашения или потребуется получить дополнительную информацию от Правообладателя, обратитесь по указанному ниже адресу электронной почты: morte4569@vk.com.\n\n')
				imgui.TextWrapped(u8'8.3 Импедимент выполнения обязательств. В случае каких-либо сбоев или снижения производительности, полностью или частично обусловленных непредвиденными ситуациями в предоставлении коммунальных услуг (включая электроэнергию), проблемами с подключением к интернету, недоступностью телекоммуникационных или информационно-технологических услуг, неисправностями телекоммуникационного или ИТ-оборудования, забастовками и другими подобными акциями, террористическими актами, DDoS-атаками и другими атаками и нарушениями ИТ-характера, стихийными бедствиями или обстоятельствами, которые находятся вне контроля Правообладателя, включая наводнения, саботаж, пожары, войны, спец. военные операции, нападения, теракты и прочие обстоятельства непреодолимой силы, а также любыми другими причинами, которые не поддаются существенному влиянию со стороны Правообладателя, Правообладатель освобождается от ответственности за такие события.\n\n')
				imgui.TextWrapped(u8'8.4 Передача прав и обязательств. Вам не разрешается передавать Ваши права или обязательства, установленные настоящим Соглашением, без предварительного письменного согласия Правообладателя. Своей стороной, Правообладатель вправе передать настоящее Соглашение в любой момент по своему усмотрению, без необходимости получения Вашего предварительного согласия в письменной форме.\n\n8.5 Подключение к Интернету. Для работы Программы необходимо обеспечить активное и стабильное подключение к Интернету. За обеспечение постоянного активного и стабильного Интернет-соединения отвечает лично Пользователь.\n\n')
				imgui.PushFont(bold_font[1])
				imgui.SetCursorPosX(10)
				imgui.Text(u8'9. Ответственности сторон при использовании Программы')
				imgui.PopFont()
				imgui.TextWrapped(u8'9.1 Программа обладает функцией обновления, осуществляемой путём загрузки файлов на тот же носитель, на котором установлена Программа.\n\n9.2 При установке и запуске Программы, Пользователь выражает своё согласие на получение неограниченного количества необходимых файлов для работы Программы с расширениями исполняемых файлов в форматах jpg, png, ttf, json, lua и txt в любой момент времени в процессе работы программы, а также на обработку файлов любого размера, не превышающего 8589934592 бит.\n\n9.3 Пользователь соглашается с тем, что Программа имеет право на неограниченное количество перезаписей и чтений установленных файлов в процессе её работы, без предварительного уведомления Пользователя Программы об этом.\n\n9.4 Пользователь принимает факт и соглашается с тем, что в любой момент времени по любой причине Программа или её файлы могут быть безвозвратно уничтожены в связи с сбоями Программы.\n\n')
				imgui.TextWrapped(u8'9.5 Правообладатель не несёт ответственности в случае сбоя операционной системы Пользователя (далее "ОС"), который может привести к временной или постоянной невозможности пользования ОС, а также к возможному уничтожению ОС с Носителя Пользователя в ходе выполнения Программы.\n\n9.6 Правообладатель не несёт ответственности за ошибки, допущенные Пользователем при использовании Программы, которые могут вызвать проблемы в ходе Игры, а также могут привести к ограничениям в использовании Игры, включая блокировку игрового аккаунта.\n\n9.7 Правообладатель осознаёт ответственность за намеренную кражу, попытку кражи, распространение, неправомерное использование личных данных пользователя с его технического Носителя. Правообладатель принимает на себя ответственность, при условии установки программы от официального лица в виде Правообладателя Программы, что Правообладатель понесёт ответственность согласно 273 ст. Уголовного Кодекса Российской Федерации (страна проживания Правообладателя) в случае распространения вредоносных программ на техническое устройство или технический Носитель Пользователя.\n')
				imgui.TextWrapped(u8'Правообладатель гарантирует отсутствие вредоносных файлов, вредоносных программ и модификаций в Программе и использующих ею файлов.\n\n9.8 Правообладатель вправе отправлять Пользователю уведомления любого типа, любого содержания, любой длительности отображения, в любой момент времени, в любом количестве и без предварительного информирования Пользователя об этом событии в самой Программе.\n\n9.9 Правообладатель наделил Программу возможностью в процессе её работы безвозвратно уничтожать, изменять содержимое или название файлов любого расширения, которые принадлежат Правообладателю или были созданы самой Программой в ходе её работы. Пользователь соглашается с этим решением.')
				imgui.PopFont()
				imgui.Dummy(imgui.ImVec2(0, 14))
				imgui.EndChild()
				gui.DrawLine({24, 391}, {824, 391}, imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
				if gui.Button(u8'Принимаю', {715, 403}, {104, 30}) then
					first_start = 7
				end
				if gui.Button(u8'Назад', {640, 403}, {62, 30}) then
					first_start = 5
				end
			elseif first_start == 7 then
				imgui.PushFont(bold_font[2])
				imgui.SetCursorPos(imgui.ImVec2(247, an[4]))
				gui.TextGradient('Обновления', 0.5, 1.00)
				imgui.PopFont()
				if new_version == '0' or error_update then
					if search_for_new_version == 0 or error_update  then
						gui.Text(290, 221, 'Установлена актуальная версия скрипта.', font[3])
						gui.Text(324, 243, 'Можете завершать настройку.', font[3])
					else
						gui.Text(318, 230, 'Поиск обновлений, подождите...', font[3])
					end
				else
					if update_request == 0 then
						gui.Text(320, 221, 'Доступна новая версия скрипта.', font[3])
						gui.Text(235, 243, 'Для завершения настройки, установите новейшую версию.', font[3])
					else
						gui.Text(342, 231, 'Обновление запрошено...', font[3])
					end
				end
				
				gui.DrawLine({24, 391}, {824, 391}, imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
				
				if new_version == '0' or error_update  then
					if search_for_new_version == 0 or error_update then
						if gui.Button(u8'Завершить', {715, 403}, {104, 30}) then
							first_start = 7
							setting.first_start = false
							for i = 1, #cmd_defoult.all do
								local new_cmd = deep_copy(cmd_defoult.all[i])
								table.insert(cmd[1], new_cmd)
								sampRegisterChatCommand(new_cmd.cmd, function(arg) 
								cmd_start(arg, tostring(new_cmd.UID) .. new_cmd.cmd) end)
							end
							if setting.org <= 4 then --> Для Больниц
								for i = 1, #cmd_defoult.hospital do
									table.insert(cmd[1], cmd_defoult.hospital[i])
									sampRegisterChatCommand(cmd_defoult.hospital[i].cmd, function(arg) 
									cmd_start(arg, tostring(cmd_defoult.hospital[i].UID) .. cmd_defoult.hospital[i].cmd) end)
								end
								
								if s_na == 'Phoenix' then 
									for i = 1, #cmd[1] do
										if cmd[1][i].cmd == 'mc' then
											cmd[1][i] = mc_phoenix
										end
									end
								end
							elseif setting.org == 5 then --> Для ЦЛ
								for i = 1, #cmd_defoult.driving_school do
									table.insert(cmd[1], cmd_defoult.driving_school[i])
									sampRegisterChatCommand(cmd_defoult.driving_school[i].cmd, function(arg) 
									cmd_start(arg, tostring(cmd_defoult.driving_school[i].UID) .. cmd_defoult.driving_school[i].cmd) end)
								end
							elseif setting.org == 6 then --> Для Права
								for i = 1, #cmd_defoult.government do
									table.insert(cmd[1], cmd_defoult.government[i])
									sampRegisterChatCommand(cmd_defoult.government[i].cmd, function(arg) 
									cmd_start(arg, tostring(cmd_defoult.government[i].UID) .. cmd_defoult.government[i].cmd) end)
								end
							elseif setting.org == 7 or setting.org == 8 then --> Для Армии
								for i = 1, #cmd_defoult.army do
									table.insert(cmd[1], cmd_defoult.army[i])
									sampRegisterChatCommand(cmd_defoult.army[i].cmd, function(arg) 
									cmd_start(arg, tostring(cmd_defoult.army[i].UID) .. cmd_defoult.army[i].cmd) end)
								end
								setting.gun_func = true
							elseif setting.org == 9 then --> Для Пожарки
								for i = 1, #cmd_defoult.fire_department do
									table.insert(cmd[1], cmd_defoult.fire_department[i])
									sampRegisterChatCommand(cmd_defoult.fire_department[i].cmd, function(arg) 
									cmd_start(arg, tostring(cmd_defoult.fire_department[i].UID) .. cmd_defoult.fire_department[i].cmd) end)
								end
							elseif setting.org == 10 then --> Для ТСР
								for i = 1, #cmd_defoult.jail do
									table.insert(cmd[1], cmd_defoult.jail[i])
									sampRegisterChatCommand(cmd_defoult.jail[i].cmd, function(arg) 
									cmd_start(arg, tostring(cmd_defoult.jail[i].UID) .. cmd_defoult.jail[i].cmd) end)
								end
								setting.gun_func = true
							--elseif setting.org >= 11 and setting.org <= 13 then --> Для СМИ
							--	for i = 1, #cmd_defoult.smi do
							--		table.insert(cmd[1], cmd_defoult.smi[i])
							--		sampRegisterChatCommand(cmd_defoult.smi[i].cmd, function(arg) 
							--		cmd_start(arg, tostring(cmd_defoult.smi[i].UID) .. cmd_defoult.smi[i].cmd) end)
							--	end
							elseif setting.org >= 11 and setting.org <= 15 then --> Для полиции
								for i = 1, #cmd_defoult.police do
									table.insert(cmd[1], cmd_defoult.police[i])
									sampRegisterChatCommand(cmd_defoult.police[i].cmd, function(arg) 
									cmd_start(arg, tostring(cmd_defoult.police[i].UID) .. cmd_defoult.police[i].cmd) end)
								end
								setting.gun_func = true
							end
							add_cmd_in_all_cmd()
							save_cmd()
							save()
						end
					else
						gui.Button(u8'Завершить', {715, 403}, {104, 30}, false)
					end
				else
					if update_request == 0 then
						if gui.Button(u8'Обновить', {715, 403}, {104, 30}) then
							update_request = 25
							update_download()
						end
					else
						gui.Button(u8'Обновить', {715, 403}, {104, 30}, false)
					end
				end
				if gui.Button(u8'Назад', {640, 403}, {62, 30}) then
					first_start = 6
				end
			end
		end
		
		if not setting.first_start then
			if tab == 'settings' then
				hall.settings()
			elseif tab == 'cmd' then
				hall.cmd()
			elseif tab == 'shpora' then
				hall.shpora()
			elseif tab == 'dep' then
				hall.dep()
			elseif tab == 'sob' then
				hall.sob()
			elseif tab == 'reminder' then
				hall.reminder()
			elseif tab == 'stat' then
				hall.stat()
			elseif tab == 'music' then
				hall.music()
			elseif tab == 'rp_zona' then
				hall.rp_zona()
			elseif tab == 'actions' then
				hall.actions()
			elseif tab == 'help' then
				hall.help()
			end
			
			--> Отображение вкладок
			gui.Draw({4, 4}, {840, 34}, cl.tab, 12, 3)
			gui.Draw({4, 409}, {840, 35}, cl.tab, 12, 12)
			imgui.PushFont(bold_font[1])
			local calc = imgui.CalcTextSize(name_tab)
			gui.Text((424 - calc.x / 2), 11, u8:decode(name_tab))
			imgui.PopFont()
			element_order(setting.tab)
			
			local color_ItemActive = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
			local color_ItemHovered = imgui.ImVec4(0.24, 0.24, 0.24, 1.00)
			if setting.cl == 'White' then
				color_ItemActive = imgui.ImVec4(0.78, 0.78, 0.78, 1.00)
				color_ItemHovered = imgui.ImVec4(0.83, 0.83, 0.83, 1.00)
			end
			
			if tab == 'settings' and setting.org == 9 and tab_settings == 6 then
				imgui.SetCursorPos(imgui.ImVec2(802, 5))
				if imgui.InvisibleButton(u8'##Посмотреть теги вызовов', imgui.ImVec2(35, 32)) then
					popup_open_tags_call = true
				end
				if imgui.IsItemActive() or imgui.IsItemHovered() then
					if an[29] < 0.45 then
						an[29] = an[29] + (anim * 1)
					end
				else
					if an[29] > 0 then
						an[29] = an[29] - (anim * 1)
					end
				end
				if setting.cl == 'White' then
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 - an[29], 0.50 - an[29], 0.50 - an[29], 1.00))
				else
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 + an[29], 0.50 + an[29], 0.50 + an[29], 1.00))
				end
				gui.FaText(811, 6, fa.TAGS, fa_font[4])
				gui.Text(805, 22, 'Теги')
				imgui.PopStyleColor(1)
			end
			
			if not edit_tab_cmd and tab == 'cmd' then
				if not edit_all_cmd then
					local function InputTextForSearchCmd(pos_draw, size_input, arg_text, name_input, buf_size_input, text_about)
						local arg_text_buf = imgui.new.char[buf_size_input](arg_text or '')
						local col_stand_imvec4 = cl.bg
						
						gui.Draw({pos_draw[1], pos_draw[2] - 5}, {size_input, 24}, col_stand_imvec4, 5, 15)
						imgui.SetCursorPos(imgui.ImVec2(pos_draw[1] + 6, pos_draw[2] - 1))
						imgui.PushItemWidth(size_input - 6)
						
						imgui.InputText('##inp' .. name_input, arg_text_buf, ffi.sizeof(arg_text_buf))
						
						if text_about ~= nil and (ffi.string(arg_text_buf) == '' and not imgui.IsItemActive()) then
							imgui.SetCursorPos(imgui.ImVec2(pos_draw[1] + 25, pos_draw[2] - 1))
							imgui.PushFont(font[3])
							imgui.TextColored(imgui.ImVec4(0.50, 0.50, 0.50, 0.50), text_about)
							imgui.PopFont()
							
							imgui.SetCursorPos(imgui.ImVec2(pos_draw[1] + 7, pos_draw[2] - 1))
							imgui.PushFont(fa_font[2])
							imgui.TextColored(imgui.ImVec4(0.50, 0.50, 0.50, 0.50), fa.MAGNIFYING_GLASS)
							imgui.PopFont()
						end
						
						return ffi.string(arg_text_buf)
					end
					search_cmd = InputTextForSearchCmd({540, 14}, 150, search_cmd, u8'Поиск команды', 32, u8'Поиск')
					imgui.SetCursorPos(imgui.ImVec2(772, 5))
					if imgui.InvisibleButton(u8'##Создать команду', imgui.ImVec2(65, 32)) then
						edit_tab_cmd = true
						local bool_cmd_new = {
							cmd = '',
							delay = 2.5,
							key = {'', {}},
							desc = '',
							folder = int_cmd.folder,
							rank = 1,
							send_end_mes = true,
							arg = {},
							var = {},
							act = {},
							id_element = 0,
							UID = math.random(20, 95000000)
						}
						bl_cmd = bool_cmd_new
						cmd_memory = ''
						type_cmd = #cmd[1] + 1
						edit_all_cmd = false
						an[13] = 0
					end
					
					if imgui.IsItemActive() or imgui.IsItemHovered() then
						if an[7][1] < 0.45 then
							an[7][1] = an[7][1] + (anim * 1)
						end
					else
						if an[7][1] > 0 then
							an[7][1] = an[7][1] - (anim * 1)
						end
					end

					local folder_has_commands = false
					if int_cmd.folder == 1 and #cmd[1] > 0 then
						folder_has_commands = true
					else
						for i = 1, #cmd[1] do
							if cmd[1][i].folder == int_cmd.folder then
								folder_has_commands = true
								break
							end
						end
					end

					if folder_has_commands then
						imgui.SetCursorPos(imgui.ImVec2(705, 5))
						if imgui.InvisibleButton(u8'##Выбор команд', imgui.ImVec2(60, 32)) then
							edit_all_cmd = not edit_all_cmd
							table_select_cmd = {}
							an[12][2] = 0
							an[12][3] = false
						end
						if imgui.IsItemActive() or imgui.IsItemHovered() then
							if an[7][2] < 0.45 then
								an[7][2] = an[7][2] + (anim * 1)
							end
						else
							if an[7][2] > 0 then
								an[7][2] = an[7][2] - (anim * 1)
							end
						end
						if setting.cl == 'White' then
							imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 - an[7][2], 0.50 - an[7][2], 0.50 - an[7][2], 1.00))
						else
							imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 + an[7][2], 0.50 + an[7][2], 0.50 + an[7][2], 1.00))
						end
						gui.FaText(727, 6, fa.LIST_CHECK, fa_font[4])
						gui.Text(711, 22, 'Выбрать')
						imgui.PopStyleColor(1)
					end
					
					if setting.cl == 'White' then
						imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 - an[7][1], 0.50 - an[7][1], 0.50 - an[7][1], 1.00))
					else
						imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 + an[7][1], 0.50 + an[7][1], 0.50 + an[7][1], 1.00))
					end
					gui.FaText(797, 6, fa.PLUS, fa_font[4])
					gui.Text(777, 22, 'Добавить')
					imgui.PopStyleColor(1)
					
				else
					imgui.SetCursorPos(imgui.ImVec2(780, 5))
					if imgui.InvisibleButton(u8'##Удалить выбранные команды', imgui.ImVec2(57, 32)) then
						edit_all_cmd = false
						table.sort(table_select_cmd, function(a, b) return a > b end)
						for _, index in ipairs(table_select_cmd) do
							if cmd[1][index] then
								if cmd[1][index].cmd ~= '' then
									sampUnregisterChatCommand(cmd[1][index].cmd)
								end
								if #cmd[1][index].key[2] ~= 0 then
									rkeys.unRegisterHotKey(cmd[1][index].key[2])
									for ke = #all_keys, 1, -1 do
										if all_keys[ke] and cmd[1][index].key[2] and table.concat(all_keys[ke], ' ') == table.concat(cmd[1][index].key[2], ' ') then
											table.remove(all_keys, ke)
											break
										end
									end
								end
								table.remove(cmd[1], index)
							end
						end
						add_cmd_in_all_cmd()
						save_cmd()
					end
					if imgui.IsItemActive() or imgui.IsItemHovered() then
						if an[14][1] < 0.45 then
							an[14][1] = an[14][1] + (anim * 1)
						end
					else
						if an[14][1] > 0 then
							an[14][1] = an[14][1] - (anim * 1)
						end
					end
					if setting.cl == 'White' then
						imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 - an[14][1], 0.50 - an[14][1], 0.50 - an[14][1], 1.00))
					else
						imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 + an[14][1], 0.50 + an[14][1], 0.50 + an[14][1], 1.00))
					end
					gui.FaText(801, 6, fa.TRASH, fa_font[4])
					gui.Text(784, 22, 'Удалить')
					imgui.PopStyleColor(1)
					
					imgui.SetCursorPos(imgui.ImVec2(704, 5))
					if imgui.InvisibleButton(u8'##Отменить выбор команд', imgui.ImVec2(64, 32)) then
						edit_all_cmd = false
					end
					
					if imgui.IsItemActive() or imgui.IsItemHovered() then
						if an[14][2] < 0.45 then
							an[14][2] = an[14][2] + (anim * 1)
						end
					else
						if an[14][2] > 0 then
							an[14][2] = an[14][2] - (anim * 1)
						end
					end
					if setting.cl == 'White' then
						imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 - an[14][2], 0.50 - an[14][2], 0.50 - an[14][2], 1.00))
					else
						imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 + an[14][2], 0.50 + an[14][2], 0.50 + an[14][2], 1.00))
					end
					gui.FaText(731, 6, fa.XMARK, fa_font[4])
					gui.Text(707, 22, 'Отменить')
					imgui.PopStyleColor(1)
				end
			elseif edit_tab_cmd and tab == 'cmd' then
				imgui.SetCursorPos(imgui.ImVec2(182, 5))
				if imgui.InvisibleButton(u8'##Выйти из редактора команд', imgui.ImVec2(48, 32)) then
					edit_tab_cmd = false
					edit_all_cmd = false
					an[13] = 0
					if #bl_cmd.key[2] ~= 0 and type_cmd == (#cmd[1] + 1) then
						for ke = 1, #all_keys do
							if table.concat(all_keys[ke], ' ') == table.concat(bl_cmd.key[2], ' ') then
								table.remove(all_keys, ke)
							end
						end
					end
				end
				if imgui.IsItemActive() or imgui.IsItemHovered() then
					if an[8][1] < 0.45 then
						an[8][1] = an[8][1] + (anim * 1)
					end
				else
					if an[8][1] > 0 then
						an[8][1] = an[8][1] - (anim * 1)
					end
				end
				
				imgui.SetCursorPos(imgui.ImVec2(120, 5))
				if imgui.InvisibleButton(u8'##Удалить команду', imgui.ImVec2(56, 32)) then
					imgui.OpenPopup(u8'Подтверждение удаления команды')
				end
				if imgui.IsItemActive() or imgui.IsItemHovered() then
					if an[8][2] < 0.45 then
						an[8][2] = an[8][2] + (anim * 1)
					end
				else
					if an[8][2] > 0 then
						an[8][2] = an[8][2] - (anim * 1)
					end
				end
				
				imgui.SetCursorPos(imgui.ImVec2(45, 5))
				if imgui.InvisibleButton(u8'##Сохранить команду', imgui.ImVec2(64, 32)) then
					if bl_cmd.cmd ~= '' then
						local bool_true_cmd = 0
						for m = 1, #all_cmd do
							if all_cmd[m] == bl_cmd.cmd then
								bool_true_cmd = m
								break
							end
						end
						
						if bool_true_cmd == 0 or cmd_memory == bl_cmd.cmd then
							local final_cmd_data = deep_copy(bl_cmd)

							if type_cmd == #cmd[1] + 1 then
								table.insert(cmd[1], final_cmd_data)
							else
								cmd[1][type_cmd] = final_cmd_data
							end

							if cmd_memory ~= '' and cmd_memory ~= final_cmd_data.cmd then
								for y = 1, #all_cmd do
									if all_cmd[y] == cmd_memory then
										table.remove(all_cmd, y)
										sampUnregisterChatCommand(cmd_memory)
										break
									end
								end
							end

							table.insert(all_cmd, final_cmd_data.cmd)
							sampRegisterChatCommand(final_cmd_data.cmd, function(arg) cmd_start(arg, tostring(final_cmd_data.UID) .. final_cmd_data.cmd) end)
							
							edit_tab_cmd = false
							edit_all_cmd = false
							an[13] = 0
							save_cmd()
						else
							imgui.OpenPopup(u8'Ошибка сохранения команды')
							error_save_cmd = 1
						end
					elseif cmd_memory ~= '' then
						--imgui.OpenPopup(u8'Ошибка сохранения команды')
						--error_save_cmd = 0
						for y = 1, #all_cmd do
							if all_cmd[y] == cmd_memory then
								table.remove(all_cmd, y)
								sampUnregisterChatCommand(cmd_memory)
								save_cmd()
								break
							end
						end
						cmd[1][type_cmd] = bl_cmd
						edit_tab_cmd = false
						edit_all_cmd = false
						an[13] = 0
					else
						cmd[1][type_cmd] = bl_cmd
						edit_tab_cmd = false
						edit_all_cmd = false
						an[13] = 0
					end
					save_cmd()
				end
				if imgui.IsItemActive() or imgui.IsItemHovered() then
					if an[8][3] < 0.45 then
						an[8][3] = an[8][3] + (anim * 1)
					end
				else
					if an[8][3] > 0 then
						an[8][3] = an[8][3] - (anim * 1)
					end
				end
				
				if imgui.BeginPopupModal(u8'Подтверждение удаления команды', null, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar) then
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
						if type_cmd ~= #cmd[1] + 1 then
							if #cmd[1][type_cmd].key[2] ~= 0 then
								rkeys.unRegisterHotKey(cmd[1][type_cmd].key[2])
								for ke = 1, #all_keys do
									if table.concat(all_keys[ke], ' ') == table.concat(cmd[1][type_cmd].key[2], ' ') then
										table.remove(all_keys, ke)
									end
								end
							end
							if #bl_cmd.key[2] ~= 0 then
								for ke = 1, #all_keys do
									if table.concat(all_keys[ke], ' ') == table.concat(bl_cmd.key[2], ' ') then
										table.remove(all_keys, ke)
									end
								end
							end
							if cmd[1][type_cmd].cmd ~= '' then
								sampUnregisterChatCommand(cmd[1][type_cmd].cmd)
							end
							table.remove(cmd[1], type_cmd)
							add_cmd_in_all_cmd()
						end
						if #bl_cmd.key[2] ~= 0 then
							for ke = 1, #all_keys do
								if table.concat(all_keys[ke], ' ') == table.concat(bl_cmd.key[2], ' ') then
									table.remove(all_keys, ke)
								end
							end
						end
						edit_tab_cmd = false
						edit_all_cmd = false
						an[13] = 0
						save_cmd()
						imgui.CloseCurrentPopup()
					end
					if gui.Button(u8'Отмена', {141, 50}, {90, 27}) then
						imgui.CloseCurrentPopup()
					end
					imgui.EndChild()
					imgui.EndPopup()
				end
				
				if imgui.BeginPopupModal(u8'Ошибка сохранения команды', null, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar) then
					imgui.SetCursorPos(imgui.ImVec2(10, 10))
					if imgui.InvisibleButton(u8'##Закрыть окно ошибки сохранения команды', imgui.ImVec2(16, 16)) then
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
					imgui.BeginChild(u8'Инфомарция об ошибке в команде', imgui.ImVec2(261, 71), false, imgui.WindowFlags.NoScrollbar)
					
					gui.FaText(110, 0, fa.OCTAGON_EXCLAMATION, fa_font[6], imgui.ImVec4(1.00, 0.07, 0.00, 1.00))
					
					imgui.PushFont(bold_font[1])
					if error_save_cmd == 0 then
						gui.Text(59, 41, 'Впишите команду')
					else
						gui.Text(9, 41, 'Такая команда уже существует')
					end
					imgui.PopFont()
					
					imgui.EndChild()
					imgui.EndPopup()
				end
				
				if setting.cl == 'White' then
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 - an[8][1], 0.50 - an[8][1], 0.50 - an[8][1], 1.00))
				else
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 + an[8][1], 0.50 + an[8][1], 0.50 + an[8][1], 1.00))
				end
				gui.FaText(197, 6, fa.ARROW_RIGHT_TO_BRACKET, fa_font[4])
				gui.Text(187, 22, 'Выйти')
				imgui.PopStyleColor(1)
				if setting.cl == 'White' then
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 - an[8][2], 0.50 - an[8][2], 0.50 - an[8][2], 1.00))
				else
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 + an[8][2], 0.50 + an[8][2], 0.50 + an[8][2], 1.00))
				end
				gui.FaText(140, 6, fa.TRASH, fa_font[4])
				gui.Text(123, 22, 'Удалить')
				imgui.PopStyleColor(1)
				if setting.cl == 'White' then
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 - an[8][3], 0.50 - an[8][3], 0.50 - an[8][3], 1.00))
				else
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 + an[8][3], 0.50 + an[8][3], 0.50 + an[8][3], 1.00))
				end
				gui.FaText(70, 6, fa.FLOPPY_DISK, fa_font[4])
				gui.Text(47, 22, 'Сохранить')
				imgui.PopStyleColor(1)
				
				
				imgui.SetCursorPos(imgui.ImVec2(775, 5))
				if imgui.InvisibleButton(u8'##Добавить действие', imgui.ImVec2(62, 32)) then
					number_i_cmd = #bl_cmd.act
					imgui.OpenPopup(u8'Добавление действия')
				end
				if imgui.IsItemActive() or imgui.IsItemHovered() then
					if an[8][4] < 0.45 then
						an[8][4] = an[8][4] + (anim * 1)
					end
				else
					if an[8][4] > 0 then
						an[8][4] = an[8][4] - (anim * 1)
					end
				end
				if setting.cl == 'White' then
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 - an[8][4], 0.50 - an[8][4], 0.50 - an[8][4], 1.00))
				else
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 + an[8][4], 0.50 + an[8][4], 0.50 + an[8][4], 1.00))
				end
				gui.FaText(797, 6, fa.PLUS, fa_font[4])
				gui.Text(777, 22, 'Действие')
				imgui.PopStyleColor(1)
				
				imgui.SetCursorPos(imgui.ImVec2(730, 5))
				if imgui.InvisibleButton(u8'##Посмотреть теги', imgui.ImVec2(35, 32)) then
					popup_open_tags = true
				end
				if imgui.IsItemActive() or imgui.IsItemHovered() then
					if an[8][6] < 0.45 then
						an[8][6] = an[8][6] + (anim * 1)
					end
				else
					if an[8][6] > 0 then
						an[8][6] = an[8][6] - (anim * 1)
					end
				end
				if setting.cl == 'White' then
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 - an[8][6], 0.50 - an[8][6], 0.50 - an[8][6], 1.00))
				else
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 + an[8][6], 0.50 + an[8][6], 0.50 + an[8][6], 1.00))
				end
				gui.FaText(739, 6, fa.TAGS, fa_font[4])
				gui.Text(733, 22, 'Теги')
				imgui.PopStyleColor(1)
				
				imgui.SetCursorPos(imgui.ImVec2(652, 5))
				if imgui.InvisibleButton(u8'##Открыть просмотр', imgui.ImVec2(68, 32)) then
					
				end
				if imgui.IsItemActive() or imgui.IsItemHovered() then
					if an[8][5] < 0.45 then
						an[8][5] = an[8][5] + (anim * 1)
					end
				else
					if an[8][5] > 0 then
						an[8][5] = an[8][5] - (anim * 1)
					end
				end
				if setting.cl == 'White' then
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 - an[8][5], 0.50 - an[8][5], 0.50 - an[8][5], 1.00))
				else
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 + an[8][5], 0.50 + an[8][5], 0.50 + an[8][5], 1.00))
				end
				--gui.FaText(674, 6, fa.EYE, fa_font[4])
				--gui.Text(654, 22, 'Просмотр')
				imgui.PopStyleColor(1)
			end
			if not edit_tab_shpora and tab == 'shpora' then
				if not shp_edit_all[1] then
					imgui.SetCursorPos(imgui.ImVec2(772, 5))
					if imgui.InvisibleButton(u8'##Создать шпаргалку', imgui.ImVec2(65, 32)) then
						edit_tab_shpora = true
						cmd_memory_shpora = ''
						local bool_shpora_new = {
							name = '',
							icon = 11,
							color = 0,
							cmd = '',
							key = {'', {}},
							text = '',
							UID = math.random(100, 95000000)
						}
						shpora_bool = bool_shpora_new
						num_shpora = #setting.shp + 1
					end
					
					if imgui.IsItemActive() or imgui.IsItemHovered() then
						if an[17][1] < 0.45 then
							an[17][1] = an[17][1] + (anim * 1)
						end
					else
						if an[17][1] > 0 then
							an[17][1] = an[17][1] - (anim * 1)
						end
					end
					
					if setting.cl == 'White' then
						imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 - an[17][1], 0.50 - an[17][1], 0.50 - an[17][1], 1.00))
					else
						imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 + an[17][1], 0.50 + an[17][1], 0.50 + an[17][1], 1.00))
					end
					gui.FaText(797, 6, fa.PLUS, fa_font[4])
					gui.Text(777, 22, 'Добавить')
					imgui.PopStyleColor(1)
					
					if #setting.shp ~= 0 then
						imgui.SetCursorPos(imgui.ImVec2(705, 5))
						if imgui.InvisibleButton(u8'##Выбор шпаргалок', imgui.ImVec2(60, 32)) then
							shp_edit_all = {true, {}}
						end
						
						if imgui.IsItemActive() or imgui.IsItemHovered() then
							if an[17][2] < 0.45 then
								an[17][2] = an[17][2] + (anim * 1)
							end
						else
							if an[17][2] > 0 then
								an[17][2] = an[17][2] - (anim * 1)
							end
						end
						if setting.cl == 'White' then
							imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 - an[17][2], 0.50 - an[17][2], 0.50 - an[17][2], 1.00))
						else
							imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 + an[17][2], 0.50 + an[17][2], 0.50 + an[17][2], 1.00))
						end
						gui.FaText(727, 6, fa.LIST_CHECK, fa_font[4])
						gui.Text(711, 22, 'Выбрать')
						imgui.PopStyleColor(1)
					end
				else
					imgui.SetCursorPos(imgui.ImVec2(780, 5))
					if imgui.InvisibleButton(u8'##Удалить выбранные шпаргалки', imgui.ImVec2(57, 32)) then
						table.sort(shp_edit_all[2], function(a, b) return a > b end)
						for _, index in ipairs(shp_edit_all[2]) do
							if setting.shp[index].cmd ~= '' then
								sampUnregisterChatCommand(setting.shp[index].cmd)
							end
							if #setting.shp[index].key[2] ~= 0 then
								rkeys.unRegisterHotKey(setting.shp[index].key[2])
								for ke = 1, #all_keys do
									if table.concat(all_keys[ke], ' ') == table.concat(setting.shp[index].key[2], ' ') then
										table.remove(all_keys, ke)
									end
								end
							end
							table.remove(setting.shp, index)
						end
						shp_edit_all = {false, {}}
						add_cmd_in_all_cmd()
					end
					
					if imgui.IsItemActive() or imgui.IsItemHovered() then
						if an[17][1] < 0.45 then
							an[17][1] = an[17][1] + (anim * 1)
						end
					else
						if an[17][1] > 0 then
							an[17][1] = an[17][1] - (anim * 1)
						end
					end
					if setting.cl == 'White' then
						imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 - an[17][1], 0.50 - an[17][1], 0.50 - an[17][1], 1.00))
					else
						imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 + an[17][1], 0.50 + an[17][1], 0.50 + an[17][1], 1.00))
					end
					gui.FaText(801, 6, fa.TRASH, fa_font[4])
					gui.Text(784, 22, 'Удалить')
					imgui.PopStyleColor(1)
					
					imgui.SetCursorPos(imgui.ImVec2(704, 5))
					if imgui.InvisibleButton(u8'##Отменить выбор шпаргалок', imgui.ImVec2(64, 32)) then
						shp_edit_all = {false, {}}
					end
					
					if imgui.IsItemActive() or imgui.IsItemHovered() then
						if an[17][2] < 0.45 then
							an[17][2] = an[17][2] + (anim * 1)
						end
					else
						if an[17][2] > 0 then
							an[17][2] = an[17][2] - (anim * 1)
						end
					end
					if setting.cl == 'White' then
						imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 - an[17][2], 0.50 - an[17][2], 0.50 - an[17][2], 1.00))
					else
						imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 + an[17][2], 0.50 + an[17][2], 0.50 + an[17][2], 1.00))
					end
					gui.FaText(731, 6, fa.XMARK, fa_font[4])
					gui.Text(707, 22, 'Отменить')
					imgui.PopStyleColor(1)
				end
				
			elseif edit_tab_shpora and tab == 'shpora' then
				imgui.SetCursorPos(imgui.ImVec2(182, 5))
				if imgui.InvisibleButton(u8'##Выйти из редактора шпаргалки', imgui.ImVec2(48, 32)) then
					edit_tab_shpora = false
					if #shpora_bool.key[2] ~= 0 and num_shpora == (#setting.shp + 1) then
						for ke = 1, #all_keys do
							if table.concat(all_keys[ke], ' ') == table.concat(shpora_bool.key[2], ' ') then
								table.remove(all_keys, ke)
							end
						end
					end
					num_shpora = 0
				end
				if imgui.IsItemActive() then
					if an[18][1] < 0.45 then
						an[18][1] = an[18][1] + (anim * 1)
					end
				elseif imgui.IsItemHovered() then
					if an[18][1] < 0.45 then
						an[18][1] = an[18][1] + (anim * 1)
					end
				else
					if an[18][1] > 0 then
						an[18][1] = an[18][1] - (anim * 1)
					end
				end
				
				imgui.SetCursorPos(imgui.ImVec2(120, 5))
				if imgui.InvisibleButton(u8'##Удалить шпаргалку', imgui.ImVec2(56, 32)) then
					windows.shpora[0] = false
					edit_tab_shpora = false
					if (#setting.shp + 1) ~= num_shpora then
						if setting.shp[num_shpora].cmd ~= '' then
							sampUnregisterChatCommand(setting.shp[num_shpora].cmd)
						end
						if #setting.shp[num_shpora].key[2] ~= 0 then
							rkeys.unRegisterHotKey(setting.shp[num_shpora].key[2])
							for ke = 1, #all_keys do
								if table.concat(all_keys[ke], ' ') == table.concat(setting.shp[num_shpora].key[2], ' ') then
									table.remove(all_keys, ke)
								end
							end
						end
						table.remove(setting.shp, num_shpora)
						add_cmd_in_all_cmd()
					end
					if #shpora_bool.key[2] ~= 0 then
						for ke = 1, #all_keys do
							if table.concat(all_keys[ke], ' ') == table.concat(shpora_bool.key[2], ' ') then
								table.remove(all_keys, ke)
							end
						end
					end
					num_shpora = 0
					save()
				end
				if imgui.IsItemActive() then
					if an[18][2] < 0.45 then
						an[18][2] = an[18][2] + (anim * 1)
					end
				elseif imgui.IsItemHovered() then
					if an[18][2] < 0.45 then
						an[18][2] = an[18][2] + (anim * 1)
					end
				else
					if an[18][2] > 0 then
						an[18][2] = an[18][2] - (anim * 1)
					end
				end
				
				imgui.SetCursorPos(imgui.ImVec2(45, 5))
				if imgui.InvisibleButton(u8'##Сохранить шпаргалку', imgui.ImVec2(64, 32)) then
					local err_save_shpora = false
					if shpora_bool.cmd ~= '' then
						for m = 1, #all_cmd do
							if all_cmd[m] == shpora_bool.cmd then
								imgui.OpenPopup(u8'Ошибка сохранения команды в шпоре')
								err_save_shpora = true
								break
							end
						end
					end
					if not err_save_shpora then
						edit_tab_shpora = false
						if (#setting.shp + 1) ~= num_shpora then
							setting.shp[num_shpora] = shpora_bool
							if shpora_bool.cmd ~= '' then
								if cmd_memory_shpora ~= shpora_bool.cmd then
									sampUnregisterChatCommand(shpora_bool.cmd)
									sampRegisterChatCommand(shpora_bool.cmd, function(arg) cmd_shpora_open(arg, tostring(shpora_bool.UID) .. shpora_bool.cmd) end)
								end
							end
						else
							table.insert(setting.shp, shpora_bool)
							if shpora_bool.cmd ~= '' then
								sampRegisterChatCommand(shpora_bool.cmd, function(arg) cmd_shpora_open(arg, tostring(shpora_bool.UID) .. shpora_bool.cmd) end)
							end
						end
						add_cmd_in_all_cmd()
					end
					save()
				end
				if imgui.IsItemActive() then
					if an[18][3] < 0.45 then
						an[18][3] = an[18][3] + (anim * 1)
					end
				elseif imgui.IsItemHovered() then
					if an[18][3] < 0.45 then
						an[18][3] = an[18][3] + (anim * 1)
					end
				else
					if an[18][3] > 0 then
						an[18][3] = an[18][3] - (anim * 1)
					end
				end
				
				if imgui.BeginPopupModal(u8'Ошибка сохранения команды в шпоре', null, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar) then
					imgui.SetCursorPos(imgui.ImVec2(10, 10))
					if imgui.InvisibleButton(u8'##Закрыть окно ошибки сохранения команды в шпоре', imgui.ImVec2(16, 16)) then
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
					imgui.BeginChild(u8'Инфомарция об ошибке в команде в шпоре', imgui.ImVec2(261, 71), false, imgui.WindowFlags.NoScrollbar)
					
					gui.FaText(110, 0, fa.OCTAGON_EXCLAMATION, fa_font[6], imgui.ImVec4(1.00, 0.07, 0.00, 1.00))
					
					imgui.PushFont(bold_font[1])
					gui.Text(9, 41, 'Такая команда уже существует')
					imgui.PopFont()
					
					imgui.EndChild()
					imgui.EndPopup()
				end
				
				if setting.cl == 'White' then
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 - an[18][1], 0.50 - an[18][1], 0.50 - an[18][1], 1.00))
				else
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 + an[18][1], 0.50 + an[18][1], 0.50 + an[18][1], 1.00))
				end
				gui.FaText(197, 6, fa.ARROW_RIGHT_TO_BRACKET, fa_font[4])
				gui.Text(187, 22, 'Выйти')
				imgui.PopStyleColor(1)
				if setting.cl == 'White' then
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 - an[18][2], 0.50 - an[18][2], 0.50 - an[18][2], 1.00))
				else
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 + an[18][2], 0.50 + an[18][2], 0.50 + an[18][2], 1.00))
				end
				gui.FaText(140, 6, fa.TRASH, fa_font[4])
				gui.Text(123, 22, 'Удалить')
				imgui.PopStyleColor(1)
				if setting.cl == 'White' then
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 - an[18][3], 0.50 - an[18][3], 0.50 - an[18][3], 1.00))
				else
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 + an[18][3], 0.50 + an[18][3], 0.50 + an[18][3], 1.00))
				end
				gui.FaText(70, 6, fa.FLOPPY_DISK, fa_font[4])
				gui.Text(47, 22, 'Сохранить')
				imgui.PopStyleColor(1)
				
			elseif edit_rp_q_sob and tab == 'sob' then
				if setting.cl == 'White' then
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 - an[19][1], 0.50 - an[19][1], 0.50 - an[19][1], 1.00))
				else
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 + an[19][1], 0.50 + an[19][1], 0.50 + an[19][1], 1.00))
				end
				gui.FaText(70, 6, fa.FLOPPY_DISK, fa_font[4])
				gui.Text(47, 22, 'Сохранить')
				imgui.PopStyleColor(1)
				imgui.SetCursorPos(imgui.ImVec2(45, 5))
				if imgui.InvisibleButton(u8'##Сохранить отыгровки вопросов', imgui.ImVec2(64, 32)) then
					edit_rp_q_sob = false
					save()
				end
				if imgui.IsItemActive() then
					if an[19][1] < 0.45 then
						an[19][1] = an[19][1] + (anim * 1)
					end
				elseif imgui.IsItemHovered() then
					if an[19][1] < 0.45 then
						an[19][1] = an[19][1] + (anim * 1)
					end
				else
					if an[19][1] > 0 then
						an[19][1] = an[19][1] - (anim * 1)
					end
				end
				
				imgui.SetCursorPos(imgui.ImVec2(772, 5))
					if imgui.InvisibleButton(u8'##Создать новую отыгровку вопроса', imgui.ImVec2(65, 32)) then
						table.insert(setting.sob.rp_q, {name = '', rp = {''}})
						bool_sob_rp_scroll = true
					end
					
					if imgui.IsItemActive() then
						if an[19][2] < 0.45 then
							an[19][2] = an[19][2] + (anim * 1)
						end
					elseif imgui.IsItemHovered() then
						if an[19][2] < 0.45 then
							an[19][2] = an[19][2] + (anim * 1)
						end
					else
						if an[19][2] > 0 then
							an[19][2] = an[19][2] - (anim * 1)
						end
					end
					
					if setting.cl == 'White' then
						imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 - an[19][2], 0.50 - an[19][2], 0.50 - an[19][2], 1.00))
					else
						imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 + an[19][2], 0.50 + an[19][2], 0.50 + an[19][2], 1.00))
					end
					gui.FaText(797, 6, fa.PLUS, fa_font[4])
					gui.Text(777, 22, 'Добавить')
					imgui.PopStyleColor(1)
			elseif edit_rp_fit_sob and tab == 'sob' then
				if setting.cl == 'White' then
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 - an[19][1], 0.50 - an[19][1], 0.50 - an[19][1], 1.00))
				else
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 + an[19][1], 0.50 + an[19][1], 0.50 + an[19][1], 1.00))
				end
				gui.FaText(70, 6, fa.FLOPPY_DISK, fa_font[4])
				gui.Text(47, 22, 'Сохранить')
				imgui.PopStyleColor(1)
				imgui.SetCursorPos(imgui.ImVec2(45, 5))
				if imgui.InvisibleButton(u8'##Сохранить отыгровки при определении годности', imgui.ImVec2(64, 32)) then
					edit_rp_fit_sob = false
					save()
				end
				if imgui.IsItemActive() then
					if an[19][1] < 0.45 then
						an[19][1] = an[19][1] + (anim * 1)
					end
				elseif imgui.IsItemHovered() then
					if an[19][1] < 0.45 then
						an[19][1] = an[19][1] + (anim * 1)
					end
				else
					if an[19][1] > 0 then
						an[19][1] = an[19][1] - (anim * 1)
					end
				end
				
				imgui.SetCursorPos(imgui.ImVec2(772, 5))
				if imgui.InvisibleButton(u8'##Создать новую отыгровку вопроса', imgui.ImVec2(65, 32)) then
					table.insert(setting.sob.rp_fit, {name = '', rp = {''}})
					bool_sob_rp_scroll = true
				end
				
				if imgui.IsItemActive() then
					if an[19][2] < 0.45 then
						an[19][2] = an[19][2] + (anim * 1)
					end
				elseif imgui.IsItemHovered() then
					if an[19][2] < 0.45 then
						an[19][2] = an[19][2] + (anim * 1)
					end
				else
					if an[19][2] > 0 then
						an[19][2] = an[19][2] - (anim * 1)
					end
				end
				
				if setting.cl == 'White' then
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 - an[19][2], 0.50 - an[19][2], 0.50 - an[19][2], 1.00))
				else
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 + an[19][2], 0.50 + an[19][2], 0.50 + an[19][2], 1.00))
				end
				gui.FaText(797, 6, fa.PLUS, fa_font[4])
				gui.Text(777, 22, 'Добавить')
				imgui.PopStyleColor(1)
			elseif not new_reminder and tab == 'reminder' then
				imgui.SetCursorPos(imgui.ImVec2(772, 5))
				if imgui.InvisibleButton(u8'##Добавить новое напоминание', imgui.ImVec2(65, 32)) then
					new_reminder = true
					local bool_reminder_new = {
						text = '',
						year = tonumber(os.date('%Y')),
						mon = tonumber(os.date('%m')),
						day = tonumber(os.date('%d')),
						min = tonumber(os.date('%M')),
						hour = tonumber(os.date('%H')),
						repeats = {false, false, false, false, false, false, false},
						sound = false,
						last_triggered_day = nil
					}
					new_rem = bool_reminder_new
					last_child_y = {tonumber(os.date('%H')) * 60, tonumber(os.date('%M')) * 60}
					start_child = {true, true}
				end
				
				if imgui.IsItemActive() then
					if an[20][1] < 0.45 then
						an[20][1] = an[20][1] + (anim * 1)
					end
				elseif imgui.IsItemHovered() then
					if an[20][1] < 0.45 then
						an[20][1] = an[20][1] + (anim * 1)
					end
				else
					if an[20][1] > 0 then
						an[20][1] = an[20][1] - (anim * 1)
					end
				end
				
				if setting.cl == 'White' then
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 - an[20][1], 0.50 - an[20][1], 0.50 - an[20][1], 1.00))
				else
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 + an[20][1], 0.50 + an[20][1], 0.50 + an[20][1], 1.00))
				end
				gui.FaText(797, 6, fa.PLUS, fa_font[4])
				gui.Text(777, 22, 'Добавить')
				imgui.PopStyleColor(1)
			elseif new_reminder and tab == 'reminder' then
				imgui.SetCursorPos(imgui.ImVec2(45, 5))
				if imgui.InvisibleButton(u8'##Сохранить напоминание', imgui.ImVec2(64, 32)) then
					new_reminder = false
					table.insert(setting.reminder, 1, new_rem)
					save()
				end
				if imgui.IsItemActive() then
					if an[20][2] < 0.45 then
						an[20][2] = an[20][2] + (anim * 1)
					end
				elseif imgui.IsItemHovered() then
					if an[20][2] < 0.45 then
						an[20][2] = an[20][2] + (anim * 1)
					end
				else
					if an[20][2] > 0 then
						an[20][2] = an[20][2] - (anim * 1)
					end
				end
				if setting.cl == 'White' then
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 - an[20][2], 0.50 - an[20][2], 0.50 - an[20][2], 1.00))
				else
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 + an[20][2], 0.50 + an[20][2], 0.50 + an[20][2], 1.00))
				end
				gui.FaText(70, 6, fa.FLOPPY_DISK, fa_font[4])
				gui.Text(47, 22, 'Сохранить')
				imgui.PopStyleColor(1)
				
				imgui.SetCursorPos(imgui.ImVec2(120, 5))
				if imgui.InvisibleButton(u8'##Удалить напоминание', imgui.ImVec2(56, 32)) then
					new_reminder = false
				end
				if imgui.IsItemActive() then
					if an[20][3] < 0.45 then
						an[20][3] = an[20][3] + (anim * 1)
					end
				elseif imgui.IsItemHovered() then
					if an[20][3] < 0.45 then
						an[20][3] = an[20][3] + (anim * 1)
					end
				else
					if an[20][3] > 0 then
						an[20][3] = an[20][3] - (anim * 1)
					end
				end
				if setting.cl == 'White' then
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 - an[20][3], 0.50 - an[20][3], 0.50 - an[20][3], 1.00))
				else
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 + an[20][3], 0.50 + an[20][3], 0.50 + an[20][3], 1.00))
				end
				gui.FaText(140, 6, fa.TRASH, fa_font[4])
				gui.Text(123, 22, 'Удалить')
				imgui.PopStyleColor(1)
			elseif tab == 'stat' then
				imgui.SetCursorPos(imgui.ImVec2(772, 5))
				if imgui.InvisibleButton(u8'##Сбросить статистику', imgui.ImVec2(65, 32)) then
					setting.stat = {
						cl = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
						afk = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
						day = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
						all = 0,
						today = os.date('%d.%m.%y'),
						date_week = {os.date('%d.%m.%y'), '', '', '', '', '', '', '', '', ''}
					}
					stat_ses = {
						cl = 0,
						afk = 0,
						all = 0
					}
				end
				
				if imgui.IsItemActive() then
					if an[21][1] < 0.45 then
						an[21][1] = an[21][1] + (anim * 1)
					end
				elseif imgui.IsItemHovered() then
					if an[21][1] < 0.45 then
						an[21][1] = an[21][1] + (anim * 1)
					end
				else
					if an[21][1] > 0 then
						an[21][1] = an[21][1] - (anim * 1)
					end
				end

				imgui.SetCursorPos(imgui.ImVec2(700, 5))
				if imgui.InvisibleButton(u8'##Перейти в настройки статистики', imgui.ImVec2(65, 32)) then
					tab = 'settings'
					name_tab = u8'Главное'
					tab_settings = 19
					bool_go_stat_set = true
				end
				if imgui.IsItemActive() then
					if an[21][2] < 0.45 then
						an[21][2] = an[21][2] + (anim * 1)
					end
				elseif imgui.IsItemHovered() then
					if an[21][2] < 0.45 then
						an[21][2] = an[21][2] + (anim * 1)
					end
				else
					if an[21][2] > 0 then
						an[21][2] = an[21][2] - (anim * 1)
					end
				end

				imgui.SetCursorPos(imgui.ImVec2(623, 5))
				if imgui.InvisibleButton("##Остановить отыгровку", imgui.ImVec2(65, 32)) then
					track_time = not track_time
				end
				if imgui.IsItemActive() then
					if an[21][3] < 0.45 then
						an[21][3] = an[21][3] + (anim * 1)
					end
				elseif imgui.IsItemHovered() then
					if an[21][3] < 0.45 then
						an[21][3] = an[21][3] + (anim * 1)
					end
				else
					if an[21][3] > 0 then
						an[21][3] = an[21][3] - (anim * 1)
					end
				end

				if setting.cl == 'White' then
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 - an[21][1], 0.50 - an[21][1], 0.50 - an[21][1], 1.00))
				else
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 + an[21][1], 0.50 + an[21][1], 0.50 + an[21][1], 1.00))
				end
				gui.FaText(795, 6, fa.ROTATE_RIGHT, fa_font[4])
				gui.Text(777, 22, 'Сбросить')
				imgui.PopStyleColor(1)
				
				if setting.cl == 'White' then
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 - an[21][2], 0.50 - an[21][2], 0.50 - an[21][2], 1.00))
				else
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 + an[21][2], 0.50 + an[21][2], 0.50 + an[21][2], 1.00))
				end
				gui.FaText(723, 6, fa.GEAR, fa_font[4])
				gui.Text(700, 22, 'Настройки')
				imgui.PopStyleColor(1)

				if setting.cl == 'White' then
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 - an[21][3], 0.50 - an[21][3], 0.50 - an[21][3], 1.00))
				else
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 + an[21][3], 0.50 + an[21][3], 0.50 + an[21][3], 1.00))
				end
				if track_time then
					gui.FaText(650, 6, fa.PAUSE, fa_font[4])
					gui.Text(623, 22, 'Остановить')
				else
					gui.FaText(650, 6, fa.PLAY, fa_font[4])
					gui.Text(630, 22, 'Включить')
				end
				imgui.PopStyleColor(1)
			elseif not new_scene and tab == 'rp_zona' then
				imgui.SetCursorPos(imgui.ImVec2(772, 5))
				if imgui.InvisibleButton(u8'##Добавить новую сцену', imgui.ImVec2(65, 32)) then
					new_scene = true
					num_scene = 0
					local bool_scene_new = {
						name = '',
						icon = 32,
						color = 0,
						x = 20,
						y = 20,
						size = 13,
						flag = 5,
						dist = 21,
						vis = 100,
						invers = false,
						preview = false,
						rp = {}
					}
					scene = bool_scene_new
					font_sc = renderCreateFont('Arial', scene.size, scene.flag)
				end
				
				if imgui.IsItemActive() or imgui.IsItemHovered() then
					if an[24][1] < 0.45 then
						an[24][1] = an[24][1] + (anim * 1)
					end
				else
					if an[24][1] > 0 then
						an[24][1] = an[24][1] - (anim * 1)
					end
				end
				
				if setting.cl == 'White' then
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 - an[24][1], 0.50 - an[24][1], 0.50 - an[24][1], 1.00))
				else
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 + an[24][1], 0.50 + an[24][1], 0.50 + an[24][1], 1.00))
				end
				gui.FaText(797, 6, fa.PLUS, fa_font[4])
				gui.Text(777, 22, 'Добавить')
				imgui.PopStyleColor(1)
			elseif new_scene and tab == 'rp_zona' then
				imgui.SetCursorPos(imgui.ImVec2(238, 5))
				if imgui.InvisibleButton(u8'##Просмотр сцены', imgui.ImVec2(58, 32)) then
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
				if imgui.IsItemActive() or imgui.IsItemHovered() then
					if an[24][5] < 0.45 then
						an[24][5] = an[24][5] + (anim * 1)
					end
				else
					if an[24][5] > 0 then
						an[24][5] = an[24][5] - (anim * 1)
					end
				end
				imgui.SetCursorPos(imgui.ImVec2(182, 5))
				if imgui.InvisibleButton(u8'##Выйти из редактора сцены', imgui.ImVec2(48, 32)) then
					num_scene = 0
					new_scene = false
				end
				if imgui.IsItemActive() or imgui.IsItemHovered() then
					if an[24][2] < 0.45 then
						an[24][2] = an[24][2] + (anim * 1)
					end
				else
					if an[24][2] > 0 then
						an[24][2] = an[24][2] - (anim * 1)
					end
				end
				
				imgui.SetCursorPos(imgui.ImVec2(120, 5))
				if imgui.InvisibleButton(u8'##Удалить сцену', imgui.ImVec2(56, 32)) then
					if num_scene ~= 0 then
						table.remove(setting.scene, num_scene)
					end
					num_scene = 0
					new_scene = false
				end
				if imgui.IsItemActive() or imgui.IsItemHovered() then
					if an[24][3] < 0.45 then
						an[24][3] = an[24][3] + (anim * 1)
					end
				else
					if an[24][3] > 0 then
						an[24][3] = an[24][3] - (anim * 1)
					end
				end
				
				imgui.SetCursorPos(imgui.ImVec2(45, 5))
				if imgui.InvisibleButton(u8'##Сохранить сцену', imgui.ImVec2(64, 32)) then
					if num_scene == 0 then
						table.insert(setting.scene, scene)
					else
						setting.scene[num_scene] = scene
					end
					new_scene = false
					num_scene = 0
					save()
				end
				if imgui.IsItemActive() or imgui.IsItemHovered() then
					if an[24][4] < 0.45 then
						an[24][4] = an[24][4] + (anim * 1)
					end
				else
					if an[24][4] > 0 then
						an[24][4] = an[24][4] - (anim * 1)
					end
				end
				
				if setting.cl == 'White' then
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 - an[24][5], 0.50 - an[24][5], 0.50 - an[24][5], 1.00))
				else
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 + an[24][5], 0.50 + an[24][5], 0.50 + an[24][5], 1.00))
				end
				gui.FaText(258, 6, fa.EYE, fa_font[4])
				gui.Text(239, 22, 'Просмотр')
				imgui.PopStyleColor(1)
				if setting.cl == 'White' then
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 - an[24][2], 0.50 - an[24][2], 0.50 - an[24][2], 1.00))
				else
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 + an[24][2], 0.50 + an[24][2], 0.50 + an[24][2], 1.00))
				end
				gui.FaText(197, 6, fa.ARROW_RIGHT_TO_BRACKET, fa_font[4])
				gui.Text(187, 22, 'Выйти')
				imgui.PopStyleColor(1)
				if setting.cl == 'White' then
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 - an[24][3], 0.50 - an[24][3], 0.50 - an[24][3], 1.00))
				else
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 + an[24][3], 0.50 + an[24][3], 0.50 + an[24][3], 1.00))
				end
				gui.FaText(140, 6, fa.TRASH, fa_font[4])
				gui.Text(123, 22, 'Удалить')
				imgui.PopStyleColor(1)
				if setting.cl == 'White' then
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 - an[24][4], 0.50 - an[24][4], 0.50 - an[24][4], 1.00))
				else
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50 + an[24][4], 0.50 + an[24][4], 0.50 + an[24][4], 1.00))
				end
				gui.FaText(70, 6, fa.FLOPPY_DISK, fa_font[4])
				gui.Text(47, 22, 'Сохранить')
				imgui.PopStyleColor(1)
			end
			new_action_popup()
		end
		
		--> Кнопка закрытия окна
		if setting.close_button then
			imgui.SetCursorPos(imgui.ImVec2(11, 11))
			if imgui.InvisibleButton(u8'##Закрыть главное окно', imgui.ImVec2(20, 20)) or close_win.main then
				if setting.anim_win then
					close_win_anim = true
				else
					windows.main[0] = false 
					close_win.main = false
				end
			end
		end
		
		if close_win_anim then
			local size_win = imgui.GetWindowSize()
			local p = imgui.GetWindowPos()
			win_y = p.y + size_win.y / 2
			win_x = p.x + size_win.x / 2
			anim_func = false
			if win_x < sx + 800 then
				win_x = win_x + (anim * 4500)
				if win_x >= sx + 500 then 
					win_x = sx + 500 
					close_win_anim = false
					windows.main[0] = false 
					close_win.main = false
				end
			end
		end
		
		if setting.close_button then
			if imgui.IsItemHovered() then
				gui.DrawCircle({21 + an[28], 21}, 7, imgui.ImVec4(0.98, 0.30, 0.38, 1.00))
			else
				gui.DrawCircle({21 + an[28], 21}, 7, imgui.ImVec4(0.98, 0.40, 0.38, 1.00))
			end
		end
		if not setting.first_start then
			gui.DrawLine({4, 38}, {844, 38}, cl.line)
			gui.DrawLine({4, 408}, {844, 408}, cl.line)
		end
	
		imgui.End()
	end
)

win.smart_su = imgui.OnFrame(
    function() return windows.smart_su[0] end,
    function(main)
        local coud = imgui.Cond.FirstUseEver
        local size_x, size_y = 800, 600
        if smartSuState.anim.is_opening or smartSuState.anim.is_closing then
            coud = imgui.Cond.Always
        end
        if smartSuState.anim.is_opening then
            if smartSuState.anim.win_x[0] > sx / 2 then
                smartSuState.anim.win_x[0] = smartSuState.anim.win_x[0] - (anim * 4500)
                if smartSuState.anim.win_x[0] <= sx / 2 then
                    smartSuState.anim.win_x[0] = sx / 2
                    smartSuState.anim.is_opening = false
                end
            end
        elseif smartSuState.anim.is_closing then
            if smartSuState.anim.win_x[0] < sx + 400 then
                smartSuState.anim.win_x[0] = smartSuState.anim.win_x[0] + (anim * 4500)
                if smartSuState.anim.win_x[0] >= sx + 400 then
                    smartSuState.anim.is_closing = false
                    windows.smart_su[0] = false
                end
            end
        end
        imgui.SetNextWindowPos(imgui.ImVec2(smartSuState.anim.win_x[0], smartSuState.anim.win_y[0]), coud, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(size_x, size_y))
        imgui.Begin('SmartSU', windows.smart_su, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoResize)
        bug_fix_input()
        gui.Draw({4, 4}, {size_x - 8, size_y - 8}, cl.main, 12, 15)
        gui.DrawLine({4, 38}, {size_x - 4, 38}, cl.line)
        imgui.PushFont(bold_font[1])
        local title = 'Умная выдача розыска | Файл: ' .. (s_na ~= '' and (s_na .. '.json') or 'Не определен')
        local calc = imgui.CalcTextSize(u8(title))
        gui.Text((size_x / 2) - (calc.x / 2), 11, title)
        imgui.PopFont()
        if imgui.IsItemHovered() then gui.DrawCircle({21, 21}, 7, imgui.ImVec4(0.98, 0.30, 0.38, 1.00))
        else gui.DrawCircle({21, 21}, 7, imgui.ImVec4(0.98, 0.40, 0.38, 1.00)) end
        imgui.SetCursorPos(imgui.ImVec2(11, 11))
        if imgui.InvisibleButton('##close_smart_su', imgui.ImVec2(20, 20)) then
            smartSuState.anim.is_closing = true
            smartSuState.anim.is_opening = false
        end
        local targetNick = sampGetPlayerNickname(smartSuState.targetId[0])
        gui.Text(16, 45, 'Выбран игрок: ' .. targetNick .. ' [' .. smartSuState.targetId[0] .. ']', font[3])
        gui.DrawBox({16, 70}, {size_x - 32, 70}, cl.tab, cl.line, 7, 15)
        gui.Text(26, 80, 'Поиск:', font[3])
        smartSuState.searchQuery = gui.InputText({80, 80}, 690, smartSuState.searchQuery, 'smartSuState.searchQuery', 256, u8'Текст из статьи...')
        gui.DrawLine({16, 105}, {size_x - 16, 105}, cl.line)
        gui.Text(26, 112, 'Запрос в рацию:', font[3])
        imgui.SetCursorPos(imgui.ImVec2(740, 108))
        if gui.Switch('##smart_su_radio_req', setting.police_settings.smart_su_radio_req) then
            setting.police_settings.smart_su_radio_req = not setting.police_settings.smart_su_radio_req; save()
        end
        imgui.SetCursorPos(imgui.ImVec2(10, 150))
        imgui.BeginChild('##articles_list', imgui.ImVec2(size_x - 20, size_y - 160))
            if smartSuState.reasons and #smartSuState.reasons > 0 then
                for index, chapterData in ipairs(smartSuState.reasons) do
                    local has_matches = false
                    local searchText = smartSuState.searchQuery:lower()
                    if searchText == '' then
                        has_matches = true
                    else
                        for _, article in ipairs(chapterData.chapter) do
                            if article.text:lower():find(searchText, 1, true) then has_matches = true; break end
                        end
                    end
                    if has_matches then
                        if smartSuState.chapterStates[index] == nil then smartSuState.chapterStates[index] = false end
                        local item_pos_before = imgui.GetCursorPos()
                        if imgui.Selectable('##spoiler_header' .. index, smartSuState.chapterStates[index], imgui.SelectableFlags.SpanAllColumns, imgui.ImVec2(0, 25)) then
                            smartSuState.chapterStates[index] = not smartSuState.chapterStates[index]
                        end
                        local p_min, p_max = imgui.GetItemRectMin(), imgui.GetItemRectMax()
                        local bgColor = cl.tab
                        if smartSuState.chapterStates[index] then bgColor = cl.bg2 end
                        if imgui.IsItemHovered() then bgColor = cl.def end
                        imgui.GetWindowDrawList():AddRectFilled(p_min, p_max, imgui.GetColorU32Vec4(bgColor), 5)
                        local icon = smartSuState.chapterStates[index] and fa.CARET_DOWN or fa.CARET_RIGHT
                        local textColor
                        if imgui.IsItemHovered() then
                            textColor = imgui.ImVec4(1, 1, 1, 1)
                        elseif smartSuState.chapterStates[index] then
                            if setting.cl == 'White' then
                                textColor = imgui.ImVec4(0, 0, 0, 1)
                            else
                                textColor = imgui.ImVec4(1, 1, 1, 1)
                            end
                        else
                            textColor = cl.text
                        end
                        imgui.PushStyleColor(imgui.Col.Text, textColor)
                        imgui.SetCursorPos(imgui.ImVec2(item_pos_before.x + 10, item_pos_before.y + 5))
                        imgui.PushFont(fa_font[3]); imgui.Text(icon); imgui.PopFont()
                        imgui.SameLine(nil, 10)
                        imgui.Text(chapterData.headerText)
                        imgui.PopStyleColor()
                        if smartSuState.chapterStates[index] then
                            imgui.Dummy(imgui.ImVec2(0, 5))
                            imgui.Indent(20)
                            for _, article in ipairs(chapterData.chapter) do
                                if searchText == '' or article.text:lower():find(searchText, 1, true) then
                                    local article_pos_before = imgui.GetCursorPos()
                                    local article_height = 22
                                    
                                    local penalty = article.penalty
									local penalty_text = ''
									if type(penalty) == 'number' then
										penalty_text = string.format(' - %d ' .. u8'ур.', penalty)
									elseif type(penalty) == 'string' and penalty:find('%-') then
										penalty_text = string.format(' - %s ' .. u8'ур.', penalty)
									end
                                    
                                    local full_text = article.text .. penalty_text
                                    
                                    local available_width = imgui.GetContentRegionAvail().x
                                    
                                    local display_text = full_text
                                    imgui.PushFont(font[3])
                                    local text_width = imgui.CalcTextSize(display_text).x
                                    if text_width > available_width - 15 then
                                        local max_len = #article.text - 7
                                        if max_len < 5 then max_len = 5 end
                                        local truncated_article = article.text:sub(1, max_len) .. '...'
                                        display_text = truncated_article .. penalty_text
                                        text_width = imgui.CalcTextSize(display_text).x
                                        while text_width > available_width - 15 and #truncated_article > 5 do
                                            truncated_article = truncated_article:sub(1, -5) .. '...'
                                            display_text = truncated_article .. penalty_text
                                            text_width = imgui.CalcTextSize(display_text).x
                                        end
                                    end
                                    imgui.PopFont()
                                    
                                    if imgui.InvisibleButton('##article' .. article.code, imgui.ImVec2(available_width, article_height)) then
                                        local commands_to_send = {}
                                        if type(article.penalty) == 'string' and article.penalty:find('-') then
                                            smartSuState.selectedArticle = article
                                            smartSuState.showPenaltySelector[0] = true
                                        else
                                            local penaltyValue = tonumber(article.penalty) or 0
                                            if setting.police_settings.smart_su_radio_req then
                                                table.insert(commands_to_send, string.format('/r Запрашиваю розыск на дело: "%d" степень розыска: "%d" с причиной: "%s"', smartSuState.targetId[0], penaltyValue, u1251:iconv(article.code)))
                                                table.insert(commands_to_send, '/r Доказательства есть на боди-камере!')
                                            else
                                                table.insert(commands_to_send, '/me правой рукой снял рацию с пояса, сообщил диспетчеру приметы подозреваемого')
                                                table.insert(commands_to_send, string.format('/su %d %d %s', smartSuState.targetId[0], penaltyValue, u1251:iconv(article.code)))
                                                table.insert(commands_to_send, '/do Преступник занесен в базу данных преступников.')
                                            end
                                            send_smart_su_commands(commands_to_send)
                                            smartSuState.anim.is_closing = true
                                            smartSuState.anim.is_opening = false
                                        end
                                    end
                                    local article_p_min, article_p_max = imgui.GetItemRectMin(), imgui.GetItemRectMax()
                                    local articleTextColor = cl.text
                                    if imgui.IsItemHovered() then
                                        imgui.GetWindowDrawList():AddRectFilled(article_p_min, article_p_max, imgui.GetColorU32Vec4(cl.def), 5)
                                        articleTextColor = imgui.ImVec4(1, 1, 1, 1)
                                    end
                                    imgui.PushStyleColor(imgui.Col.Text, articleTextColor)
                                    imgui.SetCursorPos(imgui.ImVec2(article_pos_before.x + 5, article_pos_before.y + 3))
                                    imgui.PushFont(font[3])
                                    imgui.Text(display_text)
                                    imgui.PopFont()
                                    imgui.PopStyleColor()
                                end
                            end
                            imgui.Unindent(20)
                        end
                        imgui.Dummy(imgui.ImVec2(0, 5))
                    end
                end
            else
                gui.Text((size_x - 20) / 2 - 100, (size_y - 115) / 2 - 50, 'Загрузка данных о розыске...', font[3])
            end
        imgui.EndChild()
        if smartSuState.showPenaltySelector[0] then
            imgui.OpenPopup('PenaltySelector')
            smartSuState.showPenaltySelector[0] = false
        end
        if smartSuState.selectedArticle then
            local text1 = u8 "Выберите уровень розыска для статьи:"
            local text2 = u8(smartSuState.selectedArticle.text)
            local width1 = imgui.CalcTextSize(text1).x
            local width2 = imgui.CalcTextSize(text2).x
            local p_button_size = {x = 40, y = 25}
            local button_spacing = 5.0
            local penalties = parsePenaltyRange(smartSuState.selectedArticle.penalty)
            local buttons_width = 0
            if penalties and #penalties > 0 then
                buttons_width = (#penalties * p_button_size.x) + ((#penalties - 1) * button_spacing)
            end
            local new_width = math.max(width1, width2, buttons_width) + 40
            imgui.SetNextWindowSize(imgui.ImVec2(new_width, 150))
        end
        if imgui.BeginPopupModal('PenaltySelector', nil, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
            if smartSuState.selectedArticle then
                gui.Draw({0, 0}, {imgui.GetWindowWidth(), imgui.GetWindowHeight()}, cl.main, 7, 15)
                gui.DrawEmp({0, 0}, {imgui.GetWindowWidth(), imgui.GetWindowHeight()}, cl.line, 7, 15, 1)
                local window_width = imgui.GetWindowWidth()
                local text1 = u8 "Выберите уровень розыска для статьи:"
                local text1_width = imgui.CalcTextSize(text1).x
                imgui.SetCursorPos(imgui.ImVec2((window_width - text1_width) / 2, 8))
                imgui.Text(text1)
                local text2 = (smartSuState.selectedArticle.text)
                local text2_width = imgui.CalcTextSize(text2).x
                imgui.SetCursorPos(imgui.ImVec2((window_width - text2_width) / 2, 30))
                imgui.TextColored(cl.def, text2)
                gui.DrawLine({4, 55}, {imgui.GetWindowWidth() - 4, 55}, cl.line)
                local penalties = parsePenaltyRange(smartSuState.selectedArticle.penalty)
                if penalties and #penalties > 0 then
                    local p_button_size = {x = 40, y = 25}
                    local button_spacing = 5.0
                    local total_buttons_width = (#penalties * p_button_size.x) + ((#penalties - 1) * button_spacing)
                    local start_x = (window_width - total_buttons_width) / 2
                    local cursor_y = 65
                    for i, p_value in ipairs(penalties) do
                        if gui.Button(tostring(p_value) .. '##penalty' .. i, {start_x, cursor_y}, {p_button_size.x, p_button_size.y}) then
                            local commands_to_send = {}
                            if setting.police_settings.smart_su_radio_req then
                                table.insert(commands_to_send, string.format('/r Запрашиваю розыск на дело: "%d" степень розыска: "%d" с причиной: "%s"', smartSuState.targetId[0], p_value, u1251:iconv(smartSuState.selectedArticle.code)))
                                table.insert(commands_to_send, '/r Доказательства есть на боди-камере!')
                            else
                                table.insert(commands_to_send, '/me правой рукой снял рацию с пояса, сообщил диспетчеру приметы подозреваемого')
                                table.insert(commands_to_send, string.format('/su %d %d %s', smartSuState.targetId[0], p_value, u1251:iconv(smartSuState.selectedArticle.code)))
                                table.insert(commands_to_send, '/do Преступник занесен в базу данных преступников.')
                            end
                            send_smart_su_commands(commands_to_send)
                            smartSuState.anim.is_closing = true
                            smartSuState.anim.is_opening = false
                            imgui.CloseCurrentPopup()
                        end
                        start_x = start_x + p_button_size.x + button_spacing
                    end
                end
                gui.DrawLine({4, 105}, {imgui.GetWindowWidth() - 4, 105}, cl.line)
                if gui.Button(u8 "Отмена", {(imgui.GetWindowWidth() / 2) - 50, 115}, {100, 25}) then
                    imgui.CloseCurrentPopup()
                end
            end
            imgui.EndPopup()
        end
        imgui.End()
    end
)


win.smart_ticket = imgui.OnFrame(
    function() return windows.smart_ticket[0] end,
    function(main)
        local coud = imgui.Cond.FirstUseEver
        local size_x, size_y = 800, 600
        if smartTicketState.anim.is_opening or smartTicketState.anim.is_closing then
            coud = imgui.Cond.Always
        end
        if smartTicketState.anim.is_opening then
            if smartTicketState.anim.win_x[0] > sx / 2 then
                smartTicketState.anim.win_x[0] = smartTicketState.anim.win_x[0] - (anim * 4500)
                if smartTicketState.anim.win_x[0] <= sx / 2 then
                    smartTicketState.anim.win_x[0] = sx / 2
                    smartTicketState.anim.is_opening = false
                end
            end
        elseif smartTicketState.anim.is_closing then
            if smartTicketState.anim.win_x[0] < sx + 400 then
                smartTicketState.anim.win_x[0] = smartTicketState.anim.win_x[0] + (anim * 4500)
                if smartTicketState.anim.win_x[0] >= sx + 400 then
                    smartTicketState.anim.is_closing = false
                    windows.smart_ticket[0] = false
                end
            end
        end
        
        imgui.SetNextWindowPos(imgui.ImVec2(smartTicketState.anim.win_x[0], smartTicketState.anim.win_y[0]), coud, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(size_x, size_y))
        imgui.Begin('SmartTicket', windows.smart_ticket, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoResize)
        bug_fix_input()
        gui.Draw({4, 4}, {size_x - 8, size_y - 8}, cl.main, 12, 15)
        gui.DrawLine({4, 38}, {size_x - 4, 38}, cl.line)
        imgui.PushFont(bold_font[1])
        local title = 'Умный штраф | Файл: ' .. (s_na ~= '' and (s_na .. '.json') or 'Не определен')
        local calc = imgui.CalcTextSize(u8(title))
        gui.Text((size_x / 2) - (calc.x / 2), 11, title)
        imgui.PopFont()
        if imgui.IsItemHovered() then gui.DrawCircle({21, 21}, 7, imgui.ImVec4(0.98, 0.30, 0.38, 1.00))
        else gui.DrawCircle({21, 21}, 7, imgui.ImVec4(0.98, 0.40, 0.38, 1.00)) end
        imgui.SetCursorPos(imgui.ImVec2(11, 11))
        if imgui.InvisibleButton('##close_smart_ticket', imgui.ImVec2(20, 20)) then
            smartTicketState.anim.is_closing = true
            smartTicketState.anim.is_opening = false
        end
        
        local targetNick = sampGetPlayerNickname(smartTicketState.targetId[0])
        gui.Text(16, 45, 'Выбран игрок: ' .. targetNick .. ' [' .. smartTicketState.targetId[0] .. ']', font[3])
        
        gui.DrawBox({16, 70}, {size_x - 32, 70}, cl.tab, cl.line, 7, 15)
        gui.Text(26, 80, 'Поиск:', font[3])
        smartTicketState.searchQuery = gui.InputText({80, 80}, 690, smartTicketState.searchQuery, 'smartTicketState.searchQuery', 256, u8'Текст из статьи...')
        gui.DrawLine({16, 105}, {size_x - 16, 105}, cl.line)
        gui.Text(26, 112, 'Принимать штраф через trade / pay... если он больше 1 млн:', font[3])
        imgui.SetCursorPos(imgui.ImVec2(740, 108))
        if gui.Switch('##smart_ticket_trade', setting.police_settings.smart_ticket_trade) then
            setting.police_settings.smart_ticket_trade = not setting.police_settings.smart_ticket_trade; save()
        end
        
        imgui.SetCursorPos(imgui.ImVec2(10, 150))
        imgui.BeginChild('##articles_list', imgui.ImVec2(size_x - 20, size_y - 160))
        
        if smartTicketState.reasons and #smartTicketState.reasons > 0 then
            for index, chapterData in ipairs(smartTicketState.reasons) do
                local has_matches = false
                local searchText = smartTicketState.searchQuery:lower()
                if searchText == '' then
                    has_matches = true
                else
                    for _, article in ipairs(chapterData.chapter) do
                        if article.text:lower():find(searchText, 1, true) then has_matches = true; break end
                    end
                end
                if has_matches then
                    if smartTicketState.chapterStates[index] == nil then smartTicketState.chapterStates[index] = false end
                    local item_pos_before = imgui.GetCursorPos()
                    if imgui.Selectable('##spoiler_header' .. index, smartTicketState.chapterStates[index], imgui.SelectableFlags.SpanAllColumns, imgui.ImVec2(0, 25)) then
                        smartTicketState.chapterStates[index] = not smartTicketState.chapterStates[index]
                    end
                    local p_min, p_max = imgui.GetItemRectMin(), imgui.GetItemRectMax()
                    local bgColor = cl.tab
                    if smartTicketState.chapterStates[index] then bgColor = cl.bg2 end
                    if imgui.IsItemHovered() then bgColor = cl.def end
                    imgui.GetWindowDrawList():AddRectFilled(p_min, p_max, imgui.GetColorU32Vec4(bgColor), 5)
                    local icon = smartTicketState.chapterStates[index] and fa.CARET_DOWN or fa.CARET_RIGHT
                    local textColor
                    if imgui.IsItemHovered() then
                        textColor = imgui.ImVec4(1, 1, 1, 1)
                    elseif smartTicketState.chapterStates[index] then
                        if setting.cl == 'White' then
                            textColor = imgui.ImVec4(0, 0, 0, 1)
                        else
                            textColor = imgui.ImVec4(1, 1, 1, 1)
                        end
                    else
                        textColor = cl.text
                    end
                    imgui.PushStyleColor(imgui.Col.Text, textColor)
                    imgui.SetCursorPos(imgui.ImVec2(item_pos_before.x + 10, item_pos_before.y + 5))
                    imgui.PushFont(fa_font[3]); imgui.Text(icon); imgui.PopFont()
                    imgui.SameLine(nil, 10)
                    imgui.Text(chapterData.headerText)
                    imgui.PopStyleColor()
                    if smartTicketState.chapterStates[index] then
                        imgui.Dummy(imgui.ImVec2(0, 5))
                        imgui.Indent(20)
                        for _, article in ipairs(chapterData.chapter) do
							if searchText == '' or article.text:lower():find(searchText, 1, true) then
								local article_pos_before = imgui.GetCursorPos()
								local article_height = 22
								
								local penalty = article.penalty
								local penalty_text = ''
								if type(penalty) == 'number' then
									penalty_text = string.format(' - %d$', penalty)
								elseif type(penalty) == 'string' and penalty:find('%-') then
									penalty_text = string.format(' - %s', penalty)
								end
								
								local full_text = article.text .. penalty_text
								
								local available_width = imgui.GetContentRegionAvail().x
								
								local display_text = full_text
								imgui.PushFont(font[3])
								local text_width = imgui.CalcTextSize(display_text).x
								if text_width > available_width - 15 then
									local max_len = #article.text - 7
									if max_len < 5 then max_len = 5 end
									local truncated_article = article.text:sub(1, max_len) .. '...'
									display_text = truncated_article .. penalty_text
									text_width = imgui.CalcTextSize(display_text).x
									while text_width > available_width - 15 and #truncated_article > 5 do
										truncated_article = truncated_article:sub(1, -5) .. '...'
										display_text = truncated_article .. penalty_text
										text_width = imgui.CalcTextSize(display_text).x
									end
								end
								imgui.PopFont()
								
								if imgui.InvisibleButton('##article' .. article.code, imgui.ImVec2(available_width, article_height)) then
									local penalty = article.penalty
									local minVal, maxVal
									
									if type(penalty) == 'number' then
										local commands_to_send = {}
										local use_writeticket = true
										
										if setting.police_settings.smart_ticket_trade and penalty > 1000000 then
											use_writeticket = false
										end
										
										table.insert(commands_to_send, '/me правой рукой снял рацию с пояса, сообщил диспетчеру о нарушении')
										
										if use_writeticket then
											table.insert(commands_to_send, string.format('/writeticket %d %d %s', smartTicketState.targetId[0], penalty, u1251:iconv(article.code)))
										else
											table.insert(commands_to_send, string.format('/fine %d %d %s', smartTicketState.targetId[0], penalty, u1251:iconv(article.code)))
										end
										
										table.insert(commands_to_send, '/do Штраф выписан и занесен в базу данных.')
										
										send_smart_ticket_commands(commands_to_send)
										smartTicketState.anim.is_closing = true
										smartTicketState.anim.is_opening = false
									else
										local parts = {}
										for part in penalty:gmatch('[^-]+') do
											table.insert(parts, tonumber(part))
										end
										if #parts == 2 then
											minVal = parts[1]
											maxVal = parts[2]
										else
											minVal = tonumber(penalty) or 0
											maxVal = minVal
										end
										
										smartTicketState.selectedArticle = article
										smartTicketState.penaltyMin = minVal
										smartTicketState.penaltyMax = maxVal
										smartTicketState.penaltyValue = math.min(maxVal, math.max(minVal, math.floor((minVal + maxVal) / 20000) * 10000))
										imgui.OpenPopup('TicketValueSelector')
									end
								end
								
								local article_p_min, article_p_max = imgui.GetItemRectMin(), imgui.GetItemRectMax()
								local articleTextColor = cl.text
								if imgui.IsItemHovered() then
									imgui.GetWindowDrawList():AddRectFilled(article_p_min, article_p_max, imgui.GetColorU32Vec4(cl.def), 5)
									articleTextColor = imgui.ImVec4(1, 1, 1, 1)
								end
								
								imgui.PushStyleColor(imgui.Col.Text, articleTextColor)
								imgui.SetCursorPos(imgui.ImVec2(article_pos_before.x + 5, article_pos_before.y + 3))
								imgui.PushFont(font[3])
								imgui.Text(display_text)
								imgui.PopFont()
								imgui.PopStyleColor()
							end
						end
                        imgui.Unindent(20)
                    end
                    imgui.Dummy(imgui.ImVec2(0, 5))
                end
            end
        else
            gui.Text((size_x - 20) / 2 - 100, (size_y - 115) / 2 - 50, 'Загрузка данных о штрафах...', font[3])
        end
        imgui.EndChild()
        
        if smartTicketState.selectedArticle then
            imgui.SetNextWindowSize(imgui.ImVec2(450, 180))
            imgui.OpenPopup('TicketValueSelector')
        end
        
        if imgui.BeginPopupModal('TicketValueSelector', nil, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
            if smartTicketState.selectedArticle then
                gui.Draw({0, 0}, {imgui.GetWindowWidth(), imgui.GetWindowHeight()}, cl.main, 7, 15)
                gui.DrawEmp({0, 0}, {imgui.GetWindowWidth(), imgui.GetWindowHeight()}, cl.line, 7, 15, 1)
                local window_width = imgui.GetWindowWidth()
                
                local minVal = smartTicketState.penaltyMin
                local maxVal = smartTicketState.penaltyMax
                
                local text1 = u8'Введите сумму штрафа:'
                local text1_width = imgui.CalcTextSize(text1).x
                imgui.SetCursorPos(imgui.ImVec2((window_width - text1_width) / 2, 8))
                imgui.Text(text1)
                
                gui.DrawLine({4, 35}, {imgui.GetWindowWidth() - 4, 35}, cl.line)
                
                imgui.PushFont(bold_font[1])
                imgui.SetCursorPos(imgui.ImVec2(20, 45))
                imgui.Text(string.format('%d$', minVal))
                imgui.PopFont()

                imgui.SetCursorPos(imgui.ImVec2(65, 42))
                local current_value = imgui.new.float(smartTicketState.penaltyValue)
                local new_value = gui.SliderBar('##ticket_slider', current_value, minVal, maxVal, 250, {95, 42})
                if new_value ~= current_value[0] then
                    local stepped_value = math.floor(new_value / 10000) * 10000
                    if stepped_value < minVal then stepped_value = minVal end
                    if stepped_value > maxVal then stepped_value = maxVal end
                    current_value[0] = stepped_value
                    smartTicketState.penaltyValue = stepped_value
                end

                imgui.PushFont(bold_font[1])
                imgui.SameLine()
                imgui.SetCursorPos(imgui.ImVec2(355, 45))
                imgui.Text(string.format('%d$', maxVal))
                imgui.PopFont()
                
                local input_width = 220
                local input_x = (window_width - input_width) / 2
                local input_y = 75
                local input_height = 28

                gui.Draw({input_x - 5, input_y - 5}, {input_width + 10, input_height + 10}, cl.bg, 7, 15)
                local shadow_color = imgui.ImVec4(0.70, 0.70, 0.70, 0.50)
                if setting.cl == 'Black' then
                    shadow_color = imgui.ImVec4(0.15, 0.15, 0.15, 0.50)
                end
                gui.DrawEmp({input_x - 6, input_y - 6}, {input_width + 12, input_height + 12}, shadow_color, 7, 15, 1)

                imgui.PushFont(bold_font[1])
                local value_input = imgui.new.char[20](tostring(smartTicketState.penaltyValue))
                local text_width = imgui.CalcTextSize(tostring(smartTicketState.penaltyValue)).x
                local text_height = imgui.CalcTextSize(tostring(smartTicketState.penaltyValue)).y
                local text_x = input_x + (input_width - text_width) / 2
                local text_y = input_y + (input_height - text_height) / 2
                imgui.SetCursorPos(imgui.ImVec2(text_x, text_y))
                imgui.PushItemWidth(input_width)
                imgui.InputText('##ticket_value', value_input, ffi.sizeof(value_input), imgui.InputTextFlags.CharsDecimal)
                imgui.PopItemWidth()
                imgui.PopFont()

                local entered_value = tonumber(ffi.string(value_input))
                local is_valid = entered_value and entered_value >= minVal and entered_value <= maxVal

                if entered_value and is_valid then
                    local stepped_value = math.floor(entered_value / 10000) * 10000
                    if stepped_value < minVal then stepped_value = minVal end
                    if stepped_value > maxVal then stepped_value = maxVal end
                    smartTicketState.penaltyValue = stepped_value
                end

                if not is_valid and entered_value then
                    local error_text = string.format(u8'Сумма должна быть от %d$ до %d$', minVal, maxVal)
                    imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1.00, 0.20, 0.20, 1.00))
                    imgui.SetCursorPos(imgui.ImVec2((window_width - imgui.CalcTextSize(error_text).x) / 2, 115))
                    imgui.Text(error_text)
                    imgui.PopStyleColor(1)
                end

                gui.DrawLine({4, 135}, {imgui.GetWindowWidth() - 4, 135}, cl.line)

                if gui.Button(u8'Применить', {(imgui.GetWindowWidth() / 2) - 110, 143}, {100, 25}) and (is_valid or not entered_value) then
                    local final_value = smartTicketState.penaltyValue
                    local commands_to_send = {}
                    local use_writeticket = true
                    
                    if setting.police_settings.smart_ticket_trade and final_value > 1000000 then
                        use_writeticket = false
                    end
                    
                    table.insert(commands_to_send, '/me правой рукой снял рацию с пояса, сообщил диспетчеру о нарушении')
                    
                    if use_writeticket then
                        table.insert(commands_to_send, string.format('/writeticket %d %d %s', smartTicketState.targetId[0], final_value, u1251:iconv(smartTicketState.selectedArticle.code)))
                    else
                        table.insert(commands_to_send, string.format('/fine %d %d %s', smartTicketState.targetId[0], final_value, u1251:iconv(smartTicketState.selectedArticle.code)))
                    end
                    
                    table.insert(commands_to_send, '/do Штраф выписан и занесен в базу данных.')
                    
                    send_smart_ticket_commands(commands_to_send)
                    smartTicketState.anim.is_closing = true
                    smartTicketState.anim.is_opening = false
                    smartTicketState.selectedArticle = nil
                    imgui.CloseCurrentPopup()
                end

                if gui.Button(u8'Отмена', {(imgui.GetWindowWidth() / 2) + 10, 143}, {100, 25}) then
                    smartTicketState.selectedArticle = nil
                    imgui.CloseCurrentPopup()
                end
            end
            imgui.EndPopup()
        end
        imgui.End()
    end
)


win.smart_punish = imgui.OnFrame(
    function() return windows.smart_punish[0] end,
    function(main)
        local coud = imgui.Cond.FirstUseEver
        local size_x, size_y = 800, 600
        if smartPunishState.anim.is_opening or smartPunishState.anim.is_closing then
            coud = imgui.Cond.Always
        end
        if smartPunishState.anim.is_opening then
            if smartPunishState.anim.win_x[0] > sx / 2 then
                smartPunishState.anim.win_x[0] = smartPunishState.anim.win_x[0] - (anim * 4500)
                if smartPunishState.anim.win_x[0] <= sx / 2 then
                    smartPunishState.anim.win_x[0] = sx / 2
                    smartPunishState.anim.is_opening = false
                end
            end
        elseif smartPunishState.anim.is_closing then
            if smartPunishState.anim.win_x[0] < sx + 400 then
                smartPunishState.anim.win_x[0] = smartPunishState.anim.win_x[0] + (anim * 4500)
                if smartPunishState.anim.win_x[0] >= sx + 400 then
                    smartPunishState.anim.is_closing = false
                    windows.smart_punish[0] = false
                end
            end
        end
        
        imgui.SetNextWindowPos(imgui.ImVec2(smartPunishState.anim.win_x[0], smartPunishState.anim.win_y[0]), coud, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(size_x, size_y))
        imgui.Begin('SmartPunish', windows.smart_punish, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoResize)
        bug_fix_input()
        gui.Draw({4, 4}, {size_x - 8, size_y - 8}, cl.main, 12, 15)
        gui.DrawLine({4, 38}, {size_x - 4, 38}, cl.line)
        imgui.PushFont(bold_font[1])
        local title = 'Изменение срока'
        local calc = imgui.CalcTextSize(u8(title))
        gui.Text((size_x / 2) - (calc.x / 2), 11, title)
        imgui.PopFont()
        if imgui.IsItemHovered() then gui.DrawCircle({21, 21}, 7, imgui.ImVec4(0.98, 0.30, 0.38, 1.00))
        else gui.DrawCircle({21, 21}, 7, imgui.ImVec4(0.98, 0.40, 0.38, 1.00)) end
        imgui.SetCursorPos(imgui.ImVec2(11, 11))
        if imgui.InvisibleButton('##close_smart_punish', imgui.ImVec2(20, 20)) then
            smartPunishState.anim.is_closing = true
            smartPunishState.anim.is_opening = false
        end
        
        local targetNick = sampGetPlayerNickname(smartPunishState.targetId[0])
        gui.Text(16, 45, 'Выбран игрок: ' .. targetNick .. ' [' .. smartPunishState.targetId[0] .. ']', font[3])
        
        local previousState = smartPunishState.isIncrease
		smartPunishState.isIncrease = gui.ListTableHorizontal({(size_x - 200) / 2, 115}, {u8'Повысить срок', u8'Понизить срок'}, smartPunishState.isIncrease and 1 or 2, u8'Выбор действия')
		smartPunishState.isIncrease = (smartPunishState.isIncrease == 1)

		if previousState ~= smartPunishState.isIncrease then
			smartPunishState.chapterStates = {}
			smartPunishState.searchQuery = ''
		end
        gui.DrawBox({16, 70}, {size_x - 32, 35}, cl.tab, cl.line, 7, 15)
        gui.Text(26, 80, 'Поиск:', font[3])
        smartPunishState.searchQuery = gui.InputText({80, 80}, 690, smartPunishState.searchQuery, 'smartPunishState.searchQuery', 256, u8'Текст из статьи...')
        
        imgui.SetCursorPos(imgui.ImVec2(10, 165))
        imgui.BeginChild('##punish_list', imgui.ImVec2(size_x - 20, size_y - 210))
        
        if smartPunishState.reasons and #smartPunishState.reasons > 0 then
            local filtered_reasons = {}
            for _, chapterData in ipairs(smartPunishState.reasons) do
                local chapter_type = chapterData.type or "increase"
                if smartPunishState.isIncrease and chapter_type == "increase" then
                    table.insert(filtered_reasons, chapterData)
                elseif not smartPunishState.isIncrease and chapter_type == "decrease" then
                    table.insert(filtered_reasons, chapterData)
                end
            end
            
            if #filtered_reasons > 0 then
                for index, chapterData in ipairs(filtered_reasons) do
                    local has_matches = false
                    local searchText = smartPunishState.searchQuery:lower()
                    if searchText == '' then
                        has_matches = true
                    else
                        for _, article in ipairs(chapterData.items) do
                            if article.text:lower():find(searchText, 1, true) then has_matches = true; break end
                        end
                    end
                    if has_matches then
                        if smartPunishState.chapterStates[index] == nil then smartPunishState.chapterStates[index] = false end
                        local item_pos_before = imgui.GetCursorPos()
                        if imgui.Selectable('##spoiler_header' .. index, smartPunishState.chapterStates[index], imgui.SelectableFlags.SpanAllColumns, imgui.ImVec2(0, 25)) then
                            smartPunishState.chapterStates[index] = not smartPunishState.chapterStates[index]
                        end
                        local p_min, p_max = imgui.GetItemRectMin(), imgui.GetItemRectMax()
                        local bgColor = cl.tab
                        if smartPunishState.chapterStates[index] then bgColor = cl.bg2 end
                        if imgui.IsItemHovered() then bgColor = cl.def end
                        imgui.GetWindowDrawList():AddRectFilled(p_min, p_max, imgui.GetColorU32Vec4(bgColor), 5)
                        local icon = smartPunishState.chapterStates[index] and fa.CARET_DOWN or fa.CARET_RIGHT
                        local textColor
                        if imgui.IsItemHovered() then
                            textColor = imgui.ImVec4(1, 1, 1, 1)
                        elseif smartPunishState.chapterStates[index] then
                            if setting.cl == 'White' then
                                textColor = imgui.ImVec4(0, 0, 0, 1)
                            else
                                textColor = imgui.ImVec4(1, 1, 1, 1)
                            end
                        else
                            textColor = cl.text
                        end
                        imgui.PushStyleColor(imgui.Col.Text, textColor)
                        imgui.SetCursorPos(imgui.ImVec2(item_pos_before.x + 10, item_pos_before.y + 5))
                        imgui.PushFont(fa_font[3]); imgui.Text(icon); imgui.PopFont()
                        imgui.SameLine(nil, 10)
                        imgui.Text(chapterData.headerText)
                        imgui.PopStyleColor()
                        if smartPunishState.chapterStates[index] then
                            imgui.Dummy(imgui.ImVec2(0, 5))
                            imgui.Indent(20)
                            for _, article in ipairs(chapterData.items) do
                                if searchText == '' or article.text:lower():find(searchText, 1, true) then
                                    local article_pos_before = imgui.GetCursorPos()
                                    local article_height = 22
                                    if imgui.InvisibleButton('##article' .. article.code, imgui.ImVec2(imgui.GetContentRegionAvail().x, article_height)) then
                                        local minVal = article.min
                                        local maxVal = article.max
                                        
                                        if minVal == maxVal then
                                            local commands_to_send = {}
                                            local action = smartPunishState.isIncrease and 1 or 2
                                            table.insert(commands_to_send, '/me аккуратным движением правой руки достал КПК и включил его')
                                            table.insert(commands_to_send, '/me зашел в базу данных ТСР, и нашел заключенного')
                                            table.insert(commands_to_send, string.format('/punish %d %d %d %s', smartPunishState.targetId[0], minVal, action, u1251:iconv(article.code)))
                                            table.insert(commands_to_send, '/do На планшете появилась зеленая галка и заключенному изменился срок пребывания в тюрьме.')
                                            send_smart_punish_commands(commands_to_send)
                                            smartPunishState.anim.is_closing = true
                                            smartPunishState.anim.is_opening = false
                                        else
                                            smartPunishState.selectedArticle = article
                                            imgui.OpenPopup('PunishValueSelector')
                                        end
                                    end
                                    local article_p_min, article_p_max = imgui.GetItemRectMin(), imgui.GetItemRectMax()
                                    local articleTextColor = cl.text
                                    if imgui.IsItemHovered() then
                                        imgui.GetWindowDrawList():AddRectFilled(article_p_min, article_p_max, imgui.GetColorU32Vec4(cl.def), 5)
                                        articleTextColor = imgui.ImVec4(1, 1, 1, 1)
                                    end
                                    imgui.PushStyleColor(imgui.Col.Text, articleTextColor)
                                    imgui.SetCursorPos(imgui.ImVec2(article_pos_before.x + 5, article_pos_before.y + 3))
                                    imgui.Text(article.text)
                                    imgui.PopStyleColor()
                                    
                                    if article.min and article.max and article.min < article.max then
                                        local range_text = string.format('  [%d - %d %s]', article.min, article.max, smartPunishState.isIncrease and u8'ур.' or u8'ур.')
                                        imgui.SameLine()
                                        imgui.PushFont(font[2])
                                        imgui.SetCursorPos(imgui.ImVec2(article_pos_before.x + imgui.CalcTextSize(article.text).x + 8, article_pos_before.y + 4))
                                        imgui.TextColored(imgui.ImVec4(0.6, 0.6, 0.6, 0.8), range_text)
                                        imgui.PopFont()
                                    end
                                end
                            end
                            imgui.Unindent(20)
                        end
                        imgui.Dummy(imgui.ImVec2(0, 5))
                    end
                end
            else
                gui.Text((size_x - 20) / 2 - 100, (size_y - 210) / 2, 'Нет доступных статей для выбранного действия', font[3])
            end
        elseif smartPunishState.reasons == nil then
            gui.Text((size_x - 20) / 2 - 100, (size_y - 210) / 2, 'Система наказаний в разработке...', font[3])
        else
            gui.Text((size_x - 20) / 2 - 100, (size_y - 210) / 2, 'Загрузка данных о наказаниях...', font[3])
        end
        imgui.EndChild()
        
        if smartPunishState.selectedArticle then
			imgui.SetNextWindowSize(imgui.ImVec2(270, 140))
			imgui.OpenPopup('PunishValueSelector')
		end

		if imgui.BeginPopupModal('PunishValueSelector', nil, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
			if smartPunishState.selectedArticle then
				gui.Draw({0, 0}, {imgui.GetWindowWidth(), imgui.GetWindowHeight()}, cl.main, 7, 15)
				gui.DrawEmp({0, 0}, {imgui.GetWindowWidth(), imgui.GetWindowHeight()}, cl.line, 7, 15, 1)
				local window_width = imgui.GetWindowWidth()
				
				local minVal = smartPunishState.selectedArticle.min
				local maxVal = smartPunishState.selectedArticle.max
				local action_text = smartPunishState.isIncrease and u8'повышения' or u8'понижения'
				local text1 = u8'Выберите значение для ' .. action_text .. u8' срока:'
				
				local text1_width = imgui.CalcTextSize(text1).x
				imgui.SetCursorPos(imgui.ImVec2((window_width - text1_width) / 2, 8))
				imgui.Text(text1)
				
				gui.DrawLine({4, 35}, {imgui.GetWindowWidth() - 4, 35}, cl.line)
				
				local current_value = imgui.new.float(smartPunishState.selectedValue or math.floor((minVal + maxVal) / 2))

				imgui.PushFont(bold_font[1])
				imgui.SetCursorPos(imgui.ImVec2(20, 45))
				imgui.Text(string.format('%d', minVal))
				imgui.PopFont()

				imgui.SameLine()
				local new_value = gui.SliderBar('##punish_slider', current_value, minVal, maxVal, 180, {45, 42})
				if new_value ~= current_value[0] then
					current_value[0] = new_value
					smartPunishState.selectedValue = new_value
				end

				imgui.PushFont(bold_font[1])
				imgui.SameLine()
				imgui.SetCursorPos(imgui.ImVec2(235, 45))
				imgui.Text(string.format('%d', maxVal))
				imgui.PopFont()

				local selected_value = math.floor(current_value[0] + 0.5)

				imgui.PushFont(bold_font[1])
				local value_text = tostring(selected_value) .. u8' мес.'
				local value_width = imgui.CalcTextSize(value_text).x
				imgui.SetCursorPos(imgui.ImVec2((window_width - value_width) / 2, 75))
				imgui.TextColored(cl.def, value_text)
				imgui.PopFont()
				
				gui.DrawLine({4, 100}, {imgui.GetWindowWidth() - 4, 100}, cl.line)
				
				if gui.Button(u8'Применить', {(imgui.GetWindowWidth() / 2) - 110, 108}, {100, 25}) then
					local commands_to_send = {}
					local action = smartPunishState.isIncrease and 1 or 2
					table.insert(commands_to_send, '/me аккуратным движением правой руки достал КПК и включил его')
					table.insert(commands_to_send, '/me зашел в базу данных ТСР, и нашел заключенного')
					table.insert(commands_to_send, string.format('/punish %d %d %d %s', smartPunishState.targetId[0], selected_value, action, u1251:iconv(smartPunishState.selectedArticle.code)))
					table.insert(commands_to_send, '/do На планшете появилась зеленая галка и заключенному изменился срок пребывания в тюрьме.')
					send_smart_punish_commands(commands_to_send)
					smartPunishState.anim.is_closing = true
					smartPunishState.anim.is_opening = false
					smartPunishState.selectedArticle = nil
					smartPunishState.selectedValue = nil
					imgui.CloseCurrentPopup()
				end
				
				if gui.Button(u8'Отмена', {(imgui.GetWindowWidth() / 2) + 10, 108}, {100, 25}) then
					smartPunishState.selectedArticle = nil
					smartPunishState.selectedValue = nil
					imgui.CloseCurrentPopup()
				end
			end
			imgui.EndPopup()
		end
        imgui.End()
    end
)

--[[
local inputField = imgui.new.char[256]()

win.smi = imgui.OnFrame(
	function()
		return dialogData ~= nil
	end,
	function(main)
		SmiEdit()
	end
)
]]
win.shpora = imgui.OnFrame(
	function() return windows.shpora[0] and not scene_active end,
	function(main)
		imgui.SetNextWindowPos(imgui.ImVec2(sx / 2, sy / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(808, 708))
		imgui.Begin('Shpora', windows.shpora,  imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse + (size_win and imgui.WindowFlags.NoMove or 0))
		gui.Draw({4, 4}, {800, 700}, cl.main, 12, 15)
		gui.DrawLine({4, 38}, {804, 38}, cl.line)
		imgui.SetCursorPos(imgui.ImVec2(11, 11))
		if imgui.InvisibleButton(u8'##Закрыть окно шпаргалки', imgui.ImVec2(20, 20)) then
			windows.shpora[0] = false
		end
		if imgui.IsItemHovered() then
			gui.DrawCircle({21, 21}, 7, imgui.ImVec4(0.98, 0.30, 0.38, 1.00))
		else
			gui.DrawCircle({21, 21}, 7, imgui.ImVec4(0.98, 0.40, 0.38, 1.00))
		end
		
		imgui.SetCursorPos(imgui.ImVec2(15, 50))
		imgui.BeginChild(u8'Текст шпаргалки', imgui.ImVec2(778, 638), false)
		imgui.PushFont(font[3])
		for line in text_shpora:gmatch('[^\n]+') do
			imgui.TextWrapped(line)
		end
		imgui.PopFont()
		imgui.EndChild()
	
		imgui.End()
	end
)

win.reminder = imgui.OnFrame(
	function() return windows.reminder[0] and not scene_active end,
	function(main)
		imgui.SetNextWindowPos(imgui.ImVec2(sx / 2, sy / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(358, 158))
		imgui.Begin('Reminder', windows.reminder,  imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse + (size_win and imgui.WindowFlags.NoMove or 0))
		gui.Draw({4, 4}, {350, 150}, cl.main, 12, 15)
		gui.DrawLine({4, 38}, {354, 38}, cl.line)
		imgui.SetCursorPos(imgui.ImVec2(11, 11))
		if imgui.InvisibleButton(u8'##Закрыть окно напоминания', imgui.ImVec2(20, 20)) then
			windows.reminder[0] = false
		end
		if imgui.IsItemHovered() then
			gui.DrawCircle({21, 21}, 7, imgui.ImVec4(0.98, 0.30, 0.38, 1.00))
		else
			gui.DrawCircle({21, 21}, 7, imgui.ImVec4(0.98, 0.40, 0.38, 1.00))
		end
		
		imgui.SetCursorPos(imgui.ImVec2(15, 50))
		imgui.BeginChild(u8'Текст напоминания', imgui.ImVec2(328, 100), false)
		imgui.PushFont(font[3])
		local calc_text_rem = imgui.CalcTextSize(text_reminder)
		local wrapped_text, newline_count = wrapText(u8:decode(text_reminder), 42, 210)
		local i_line = 0
		for line in wrapped_text:gmatch('[^\n]+') do
			local calc_text_rem = imgui.CalcTextSize(u8(line))
			gui.Text(164 - (calc_text_rem.x / 2), 16 + (i_line * 15), line, font[3])
			i_line = i_line + 1
		end
		imgui.PopFont()
		imgui.EndChild()
	
		imgui.End()
	end
)
	
win.mini_player = imgui.OnFrame(
	function() return windows.player[0] and not scene_active end,
	function(mini_player)
		mini_player.HideCursor = true
		if not setting.mini_player_pos then
			setting.mini_player_pos = { x = sx / 2, y = sy - 60 }
		end
		imgui.SetNextWindowPos(imgui.ImVec2(setting.mini_player_pos.x, setting.mini_player_pos.y), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(318, 110))
		local flags = imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoFocusOnAppearing + imgui.WindowFlags.NoBringToFrontOnFocus + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoMove

		if is_mini_player_pos then
			flags = flags + imgui.WindowFlags.NoMouseInputs
		end

		imgui.Begin('Music player', windows.player, flags)
		gui.Draw({4, 4}, {310, 105}, imgui.ImVec4(0.02, 0.02, 0.02, 1.00), 12, 15)

		draw_gradient_image_music(0.9, 26, 26, 36, 36, 15)
		imgui.SetCursorPos(imgui.ImVec2(18, 18))
		local p_cursor_screen = imgui.GetCursorScreenPos()
		local s_image = imgui.ImVec2(52, 52)
		if play.status_image == play.i and play.i ~= 0 then
			imgui.GetWindowDrawList():AddImageRounded(play.image_label, p_cursor_screen, imgui.ImVec2(p_cursor_screen.x + s_image.x, p_cursor_screen.y + s_image.y), imgui.ImVec2(0, 0), imgui.ImVec2(1, 1), imgui.GetColorU32Vec4(imgui.ImVec4(1.00, 1.00, 1.00 ,1.00)), 12)
		else
			imgui.Image(image_no_label, imgui.ImVec2(52, 52))
		end

		if play.tab ~= 'RADIO' and play.tab ~= 'RECORD' then
			gui.Draw({85, 65}, {215, 4}, imgui.ImVec4(0.21, 0.21, 0.21, 1.00), 20, 15)
			gui.Draw({85, 65}, {(215 / play.len_time) * play.pos_time, 4}, cl.def, 20, 15)
		end

		local name_record = {'Record Dance', 'Megamix', 'Party 24/7', 'Phonk', 'Гоп FM', 'Руки Вверх', 'Dupstep', 'Big Hits', 'Organic', 'Russian Hits'}
		local name_radio = {'Европа Плюс', 'DFM', 'Шансон', 'Радио Дача', 'Дорожное', 'Маяк', 'Наше', 'LoFi Hip-Hop', 'Максимум', '90s Eurodance'}
		imgui.PushFont(font[3])
		if play.tab == 'RECORD' then
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1.00, 1.00, 1.00, 1.00))
			gui.Text(85, 27, name_record[play.i], font[3])
			imgui.PopStyleColor(1)
			imgui.SetCursorPos(imgui.ImVec2(85, 44))
			imgui.TextColored(imgui.ImVec4(0.60, 0.60, 0.60, 1.00), u8('Record'))

		elseif play.tab == 'RADIO' then
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1.00, 1.00, 1.00, 1.00))
			gui.Text(85, 27, name_radio[play.i], font[3])
			imgui.PopStyleColor(1)
			imgui.SetCursorPos(imgui.ImVec2(85, 44))
			imgui.TextColored(imgui.ImVec4(0.60, 0.60, 0.60, 1.00), u8('Radio'))
		else
			if play.status ~= 'NULL' then
				local track_name, _ = wrapText(play.info.name, 30, 30)
				local track_artist, _ = wrapText(play.info.artist, 28, 28)
				imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1.00, 1.00, 1.00, 1.00))
				gui.Text(85, 19, track_name, font[3])
				imgui.PopStyleColor(1)
				imgui.SetCursorPos(imgui.ImVec2(85, 37))
				imgui.TextColored(imgui.ImVec4(0.60, 0.60, 0.60, 1.00), u8(track_artist))
			end
		end
		imgui.PopFont()
		do
			local y_pos_button = 75
			local y_pos_icon = 77
			local button_size = imgui.ImVec2(20, 20)
			local icon_offset_x = 2
			local gap_between_buttons = 10
			local slider_width = 80
			local slider_height = 6
			local knob_radius = 6
			local total_width = (button_size.x * 5) + (gap_between_buttons * 4) + slider_width
			local start_x = (318 / 2) - (total_width / 2)
			local current_x = start_x
			imgui.SetCursorPos(imgui.ImVec2(current_x, y_pos_button))
			if imgui.InvisibleButton('##StopTrackMini', button_size) then
				set_song_status('STOP')
			end
			gui.FaText(current_x + icon_offset_x, y_pos_icon, fa.STOP, fa_font[2], imgui.ImVec4(0.70, 0.70, 0.70, 1.00))
			current_x = current_x + button_size.x + gap_between_buttons
			imgui.SetCursorPos(imgui.ImVec2(current_x, y_pos_button))
			if play.tab ~= 'RECORD' and play.tab ~= 'RADIO' and play.i > 1 then
				if imgui.InvisibleButton('##PreviousTrackMini', button_size) then
					back_track()
				end
				gui.FaText(current_x + icon_offset_x, y_pos_icon, fa.BACKWARD_STEP, fa_font[2], imgui.ImVec4(0.70, 0.70, 0.70, 1.00))
			else
				gui.FaText(current_x + icon_offset_x, y_pos_icon, fa.BACKWARD_STEP, fa_font[2], imgui.ImVec4(0.30, 0.30, 0.30, 1.00))
			end
			current_x = current_x + button_size.x + gap_between_buttons
			imgui.SetCursorPos(imgui.ImVec2(current_x, y_pos_button))
			if imgui.InvisibleButton('##PlayPauseMini', button_size) then
				set_song_status('PLAY_OR_PAUSE')
			end
			local play_icon = (play.status == 'PLAY') and fa.PAUSE or fa.PLAY
			gui.FaText(current_x + icon_offset_x, y_pos_icon, play_icon, fa_font[2], imgui.ImVec4(0.70, 0.70, 0.70, 1.00))
			current_x = current_x + button_size.x + gap_between_buttons
			imgui.SetCursorPos(imgui.ImVec2(current_x, y_pos_button))
			if play.tab ~= 'RECORD' and play.tab ~= 'RADIO' then
				if imgui.InvisibleButton('##NextTrackMini', button_size) then
					next_track(true)
				end
				gui.FaText(current_x + icon_offset_x, y_pos_icon, fa.FORWARD_STEP, fa_font[2], imgui.ImVec4(0.70, 0.70, 0.70, 1.00))
			else
				gui.FaText(current_x + icon_offset_x, y_pos_icon, fa.FORWARD_STEP, fa_font[2], imgui.ImVec4(0.30, 0.30, 0.30, 1.00))
			end
			current_x = current_x + button_size.x + gap_between_buttons
			local vol_icon
			if play.volume >= 0.7 then
				vol_icon = fa.VOLUME_HIGH
			elseif play.volume >= 0.4 then
				vol_icon = fa.VOLUME
			elseif play.volume >= 0.03 then
				vol_icon = fa.VOLUME_LOW
			else
				vol_icon = fa.VOLUME_SLASH
			end
			imgui.SetCursorPos(imgui.ImVec2(current_x, y_pos_button))
			if imgui.InvisibleButton('##MuteButton', button_size) then
				if play.volume > 0 then
					play.last_volume_before_mute = play.volume
					play.volume = 0
				else
					play.volume = (play.last_volume_before_mute and play.last_volume_before_mute > 0) and play.last_volume_before_mute or 0.5
				end
				volume_song(play.volume)
			end
			gui.FaText(current_x + icon_offset_x, y_pos_icon, vol_icon, fa_font[2], imgui.ImVec4(0.70, 0.70, 0.70, 1.00))
			current_x = current_x + button_size.x
			
			gui.Draw({200, 81}, {slider_width, slider_height}, imgui.ImVec4(0.21, 0.21, 0.21, 1.00), 20, 15)
			gui.Draw({200, 81}, {slider_width * play.volume, slider_height}, cl.def, 20, 15)
			gui.DrawCircle({200 + slider_width * play.volume, 81 + slider_height / 2}, knob_radius, imgui.ImVec4(1, 1, 1, 1))

			imgui.SetCursorPos(imgui.ImVec2(200 - knob_radius, 81 - knob_radius))
			imgui.InvisibleButton('##volume_slider', imgui.ImVec2(slider_width + (knob_radius * 2), slider_height + (knob_radius * 2)))
			
			if imgui.IsItemActive() or (imgui.IsItemHovered() and imgui.IsMouseDown(0)) then
				local mouse_x = imgui.GetMousePos().x - (imgui.GetWindowPos().x + 200)
				local new_volume = math.max(0, math.min(1, mouse_x / slider_width))
				if play.volume ~= new_volume then
					play.volume = new_volume
					volume_song(play.volume)
				end
			end
		end
		imgui.End()
	end
)


win.smart_fast = imgui.OnFrame(
    function() 
        return smartFastState.isActive 
    end,
    function()
        
        if not smartFastState then
            return
        end
        
        
        local left_column_width = 200
        local base_window_width = 750
        local min_column_width = 180
        local column_padding = 10
        local button_padding = 30
        
        
        local actions_with_id = smartFastState.selectedPlayer and smartFastState.actionsWithId or {}
        local actions_without_id = smartFastState.actionsWithoutId or {}
        
        
        local with_id_columns = 1
        if #actions_with_id > 8 then
            with_id_columns = 2
        elseif #actions_with_id > 15 then
            with_id_columns = 3
        end
        
        
        local total_columns = 1 
        
        if #actions_with_id > 0 then
            total_columns = total_columns + with_id_columns
        end
        
        if #actions_without_id > 0 then
            total_columns = total_columns + 1
        end
        
        
        local window_width = left_column_width + (total_columns - 1) * min_column_width + (total_columns * column_padding * 2)
        
        
        local available_width = window_width - left_column_width - (total_columns * column_padding * 2)
        local column_widths = {}
        
        if #actions_with_id > 0 and #actions_without_id > 0 then
            
            if with_id_columns == 1 then
                column_widths.with_id = math.floor(available_width * 0.55)
                column_widths.without_id = available_width - column_widths.with_id
            elseif with_id_columns == 2 then
                column_widths.with_id = math.floor(available_width * 0.7)
                column_widths.without_id = available_width - column_widths.with_id
            else
                column_widths.with_id = math.floor(available_width * 0.75)
                column_widths.without_id = available_width - column_widths.with_id
            end
        elseif #actions_with_id > 0 then
            
            column_widths.with_id = available_width
            column_widths.without_id = 0
        elseif #actions_without_id > 0 then
            
            column_widths.with_id = 0
            column_widths.without_id = available_width
        end
        
        
        if smartFastState.anim and smartFastState.anim.is_opening then
            if smartFastState.anim.alpha < 1.0 then
                smartFastState.anim.alpha = (smartFastState.anim.alpha or 0) + (anim * 5)
                if smartFastState.anim.alpha > 1.0 then
                    smartFastState.anim.alpha = 1.0
                    smartFastState.anim.is_opening = false
                end
            end
        elseif smartFastState.anim and smartFastState.anim.is_closing then
            if smartFastState.anim.alpha > 0.0 then
                smartFastState.anim.alpha = (smartFastState.anim.alpha or 0) - (anim * 5)
                if smartFastState.anim.alpha < 0.0 then
                    smartFastState.anim.alpha = 0.0
                    smartFastState.anim.is_closing = false
                    smartFastState.isActive = false
                    windows.fast[0] = false
                    return
                end
            end
        end
        
        
        if smartFastState.anim and smartFastState.anim.alpha > 0 then
            imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, smartFastState.anim.alpha)
        end
        
        
        local window_height = 500
        
        imgui.SetNextWindowPos(imgui.ImVec2(sx / 2, sy / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(window_width, window_height))
        
        local result = imgui.Begin('Smart Fast Menu', windows.fast, 
            imgui.WindowFlags.NoCollapse + 
            imgui.WindowFlags.NoResize + 
            imgui.WindowFlags.NoTitleBar + 
            imgui.WindowFlags.NoScrollbar + 
            imgui.WindowFlags.NoScrollWithMouse + 
            imgui.WindowFlags.NoSavedSettings)
        
        if not result then
            return
        end
        
        
        gui.Draw({4, 4}, {window_width - 8, window_height - 8}, imgui.ImVec4(cl.main.x, cl.main.y, cl.main.z, 0.9), 12, 15)
        gui.DrawLine({4, 38}, {window_width - 4, 38}, cl.line)
        
        
        local title = "Быстрое меню"
        if smartFastState.selectedPlayer then
            title = string.format("%s [%d] (%.0f м.)", 
                smartFastState.selectedPlayer.nick or "Unknown",
                smartFastState.selectedPlayer.id or 0,
                smartFastState.selectedPlayer.dist or 0)
        end
        imgui.PushFont(bold_font[1])
        local calc = imgui.CalcTextSize(u8(title))
        gui.Text((window_width / 2) - (calc.x / 2), 12, title)
        imgui.PopFont()
        
        
        imgui.SetCursorPos(imgui.ImVec2(11, 11))
        if imgui.InvisibleButton('##close_smart_fast', imgui.ImVec2(20, 20)) or close_win.fast then
            if smartFastState.anim then
                smartFastState.anim.is_closing = true
                smartFastState.anim.is_opening = false
            end
            close_win.fast = false
			targ_id = nil
        end
        
        local circle_color = imgui.ImVec4(0.98, 0.40, 0.38, 1.00)
        if imgui.IsItemHovered() then
            circle_color = imgui.ImVec4(0.98, 0.30, 0.38, 1.00)
        end
        gui.DrawCircle({21, 21}, 7, circle_color)
        
        
        imgui.SetCursorPos(imgui.ImVec2(10, 45))
        local child_result = imgui.BeginChild('##smart_fast_content', imgui.ImVec2(window_width - 20, window_height - 55), false, imgui.WindowFlags.NoScrollWithMouse)
        
        if child_result then
            
            imgui.SetCursorPos(imgui.ImVec2(0, 0))
            local left_child_result = imgui.BeginChild('##players_list', imgui.ImVec2(left_column_width, window_height - 55), true)

            if left_child_result then
                if not smartFastState.selectedPlayer then
                    gui.Text(5, 5, "Игроки рядом:", bold_font[1])
                    gui.DrawLine({5, 30}, {left_column_width - 10, 30}, cl.line)
                    
                    if smartFastState.playersList and #smartFastState.playersList > 0 then
                        local y_pos = 40
                        for i, player in ipairs(smartFastState.playersList) do
                            if player and player.dist <= 10 then
                                
                                if sampIsPlayerConnected(player.id) then
                                    local player_nick = player.nick or "Unknown"
                                    if player_nick == "" then player_nick = "Unknown" end
                                    
                                    local button_x = 5
                                    local button_y = y_pos
                                    local button_w = left_column_width - 20
                                    local button_h = 45
                                    
                                    imgui.SetCursorPos(imgui.ImVec2(button_x, button_y))
                                    local p = imgui.GetCursorScreenPos()
                                    
                                    local clicked = imgui.InvisibleButton('##player_' .. i, imgui.ImVec2(button_w, button_h))
                                    
                                    local bg_color = cl.bg
                                    if imgui.IsItemActive() then
                                        bg_color = cl.def
                                    elseif imgui.IsItemHovered() then
                                        bg_color = cl.bg2
                                    end
                                    
                                    local draw_list = imgui.GetWindowDrawList()
                                    draw_list:AddRectFilled(
                                        imgui.ImVec2(p.x, p.y),
                                        imgui.ImVec2(p.x + button_w, p.y + button_h),
                                        imgui.GetColorU32Vec4(bg_color), 5, 15
                                    )
                                    
                                    if setting.cl == 'White' then
                                        draw_list:AddRect(
                                            imgui.ImVec2(p.x - 1, p.y - 1),
                                            imgui.ImVec2(p.x + button_w + 2, p.y + button_h + 2),
                                            imgui.GetColorU32Vec4(imgui.ImVec4(0.88, 0.88, 0.88, 1.00)), 5, 15
                                        )
                                    end
                                    
                                    
                                    local player_color = sampGetPlayerColor(player.id)
                                    local r = bit.band(player_color, 0xFF)
                                    local g = bit.band(bit.rshift(player_color, 8), 0xFF)
                                    local b = bit.band(bit.rshift(player_color, 16), 0xFF)
                                    local a = bit.band(bit.rshift(player_color, 24), 0xFF)
                                    
                                    
                                    if not player.cached_color then
                                        player.cached_color = {
                                            r = r, g = g, b = b, a = a
                                        }
                                    end
                                    
                                    
                                    local text_color = 0xFF000000
                                    if r < 30 and g < 30 and b < 30 then
                                        text_color = 0xFFFFFFFF 
                                    else
                                        text_color = bit.bor(0xFF000000, bit.lshift(r, 16), bit.lshift(g, 8), b)
                                    end
                                    
                                    
                                    imgui.PushFont(bold_font[1])
                                    draw_list:AddText(
                                        imgui.ImVec2(p.x + 4, p.y + 6),
                                        text_color,
                                        player_nick
                                    )
                                    imgui.PopFont()
                                    
                                    
                                    local info_text = string.format(u8"[%d]  %d м.", player.id, player.dist)
                                    imgui.PushFont(font[2])
                                    draw_list:AddText(
                                        imgui.ImVec2(p.x + 4, p.y + 26),
                                        imgui.GetColorU32Vec4(cl.text),
                                        info_text
                                    )
                                    imgui.PopFont()
                                    
                                    if clicked then
										
										
										local player_color = sampGetPlayerColor(player.id)
										local r = bit.band(player_color, 0xFF)
										local g = bit.band(bit.rshift(player_color, 8), 0xFF)
										local b = bit.band(bit.rshift(player_color, 16), 0xFF)
										
										local text_color = 0xFF000000
										if r < 30 and g < 30 and b < 30 then
											text_color = 0xFFFFFFFF
										else
											text_color = bit.bor(0xFF000000, bit.lshift(r, 16), bit.lshift(g, 8), b)
										end
										
										smartFastState.selectedPlayer = {
											id = player.id,
											nick = player.nick,
											dist = player.dist,
											text_color = text_color  
										}
									end
                                    
                                    y_pos = y_pos + 50
                                end
                            end
                        end
                    else
                        gui.Text(5, 40, "Нет игроков рядом", font[3])
                        gui.Text(5, 60, "Подойдите ближе", font[3])
                    end
                else
                    
                    
                    
                    if gui.Button(u8"< К списку игроков", {5, 5}, {left_column_width - 20, 30}) then
                        smartFastState.selectedPlayer = nil
                    end
                    
                    gui.DrawLine({5, 45}, {left_column_width - 10, 45}, cl.line)
                    
                    
                    local draw_list = imgui.GetWindowDrawList()
                    local p = imgui.GetCursorScreenPos()
                    
                    
                    draw_list:AddRectFilled(
                        imgui.ImVec2(p.x + 5, p.y + 55),
                        imgui.ImVec2(p.x + left_column_width - 15, p.y + 140),
                        imgui.GetColorU32Vec4(cl.bg), 5, 15
                    )
                    
                    
                    if setting.cl == 'White' then
                        draw_list:AddRect(
                            imgui.ImVec2(p.x + 4, p.y + 54),
                            imgui.ImVec2(p.x + left_column_width - 14, p.y + 141),
                            imgui.GetColorU32Vec4(imgui.ImVec4(0.88, 0.88, 0.88, 1.00)), 5, 15
                        )
                    end
                    
                    if smartFastState.selectedPlayer then
						local player_nick = smartFastState.selectedPlayer.nick or "Unknown"
						if player_nick == "" then player_nick = "Unknown" end
						
						
						local draw_list = imgui.GetWindowDrawList()
						local p = imgui.GetCursorScreenPos()
						
						
						draw_list:AddRectFilled(
							imgui.ImVec2(p.x + 5, p.y + 55),
							imgui.ImVec2(p.x + left_column_width - 15, p.y + 140),
							imgui.GetColorU32Vec4(cl.bg), 5, 15
						)
						
						
						imgui.SetCursorPos(imgui.ImVec2(15, 60))
						imgui.Text(u8"Выбран:")
						
						
						imgui.PushFont(bold_font[1])
						if smartFastState.selectedPlayer.text_color then
							draw_list:AddText(
								imgui.ImVec2(p.x + 15, p.y + 80),  
								smartFastState.selectedPlayer.text_color,
								player_nick
							)
						else
							imgui.SetCursorPos(imgui.ImVec2(15, 80))  
							imgui.Text(player_nick)
						end
						imgui.PopFont()
						
						imgui.PushFont(font[2])
						imgui.SetCursorPos(imgui.ImVec2(15, 100))  
						imgui.Text(u8"ID: " .. (smartFastState.selectedPlayer.id or 0))
						
						imgui.SetCursorPos(imgui.ImVec2(15, 120))  
						imgui.Text(u8"Расстояние: " .. (smartFastState.selectedPlayer.dist or 0) .. u8" м.")
						imgui.PopFont()
					end
                end
            end
            imgui.EndChild()
            
            
            local function formatButtonText(text, maxWidth)
                if not text or text == "" then
                    return u8"Без названия"
                end
                
                
                local textWidth = imgui.CalcTextSize(text).x
                if textWidth <= maxWidth - 20 then
                    return text
                end
                
                
                local words = {}
                for word in text:gmatch("%S+") do
                    table.insert(words, word)
                end
                
                local line1 = ""
                local line2 = ""
                local currentWidth = 0
                
                for i, word in ipairs(words) do
                    local wordWidth = imgui.CalcTextSize(word).x
                    local spaceWidth = i > 1 and imgui.CalcTextSize(" ").x or 0
                    
                    if currentWidth + wordWidth + spaceWidth <= maxWidth - 20 then
                        if line1 == "" then
                            line1 = word
                            currentWidth = wordWidth
                        else
                            line1 = line1 .. " " .. word
                            currentWidth = currentWidth + spaceWidth + wordWidth
                        end
                    else
                        
                        local remaining = {}
                        for j = i, #words do
                            table.insert(remaining, words[j])
                        end
                        line2 = table.concat(remaining, " ")
                        
                        
                        local line2Width = imgui.CalcTextSize(line2).x
                        if line2Width > maxWidth - 20 then
                            
                            local truncated = ""
                            currentWidth = 0
                            for j = i, #words do
                                local w = words[j]
                                local wWidth = imgui.CalcTextSize(w).x
                                local spaceW = j > i and imgui.CalcTextSize(" ").x or 0
                                
                                if currentWidth + wWidth + spaceW <= maxWidth - 30 then
                                    if truncated == "" then
                                        truncated = w
                                        currentWidth = wWidth
                                    else
                                        truncated = truncated .. " " .. w
                                        currentWidth = currentWidth + spaceW + wWidth
                                    end
                                else
                                    if truncated == "" then
                                        truncated = w:sub(1, 1) .. "..."
                                    else
                                        truncated = truncated .. "..."
                                    end
                                    break
                                end
                            end
                            line2 = truncated
                        end
                        break
                    end
                end
                
                return line1 .. "\n" .. line2
            end
            
            
            local function CenteredButton(name, text, pos, size)
                local result = false
                local col_stand_imvec4 = cl.bg
                local col_text_imvec4 = cl.text
                
                imgui.SetCursorPos(imgui.ImVec2(pos[1], pos[2]))
                local p = imgui.GetCursorScreenPos()
                
                if imgui.InvisibleButton(name, imgui.ImVec2(size[1], size[2])) then
                    result = true
                end
                
                if imgui.IsItemActive() then
                    col_stand_imvec4 = cl.def
                    col_text_imvec4 = imgui.ImVec4(0.95, 0.95, 0.95, 1.00)
                elseif imgui.IsItemHovered() then
                    col_stand_imvec4 = cl.bg2
                end
                
                local draw_list = imgui.GetWindowDrawList()
                
                draw_list:AddRectFilled(
                    imgui.ImVec2(p.x, p.y),
                    imgui.ImVec2(p.x + size[1], p.y + size[2]),
                    imgui.GetColorU32Vec4(col_stand_imvec4), 5, 15
                )
                
                if setting.cl == 'White' then
                    draw_list:AddRect(
                        imgui.ImVec2(p.x - 1, p.y - 1),
                        imgui.ImVec2(p.x + size[1] + 2, p.y + size[2] + 2),
                        imgui.GetColorU32Vec4(imgui.ImVec4(0.88, 0.88, 0.88, 1.00)), 5, 15
                    )
                end
                
                imgui.PushFont(font[3])
                
                
                local lines = {}
                for line in text:gmatch("[^\n]+") do
                    table.insert(lines, line)
                end
                
                local lineHeight = 18
                local totalHeight = #lines * lineHeight
                local startY = p.y + (size[2] - totalHeight) / 2
                
                for i, line in ipairs(lines) do
                    local textWidth = imgui.CalcTextSize(line).x
                    local textX = p.x + (size[1] - textWidth) / 2
                    local textY = startY + (i - 1) * lineHeight
                    
                    draw_list:AddText(
                        imgui.ImVec2(textX, textY),
                        imgui.GetColorU32Vec4(col_text_imvec4),
                        line
                    )
                end
                
                imgui.PopFont()
                
                return result
            end
            
            
            local current_x = left_column_width + column_padding * 2
            
            
            if smartFastState.selectedPlayer and #actions_with_id > 0 then
                if with_id_columns == 1 then
                    
                    local col_width = column_widths.with_id
                    imgui.SetCursorPos(imgui.ImVec2(current_x, 0))
                    local child_result = imgui.BeginChild('##actions_with_id_1', imgui.ImVec2(col_width, window_height - 55), true)
                    
                    if child_result then
                        local y_pos = 5
                        gui.Text(5, y_pos, "Действия с ID:", bold_font[1])
                        y_pos = y_pos + 30
                        gui.DrawLine({5, y_pos - 5}, {col_width - 15, y_pos - 5}, cl.line)
                        
                        for i, action in ipairs(actions_with_id) do
                            if action then
                                local action_name = action.name
                                if not action_name or action_name:gsub('%s+', '') == '' then
                                    action_name = u8'Без названия'
                                end
                                
                                local display_text = formatButtonText(action_name, col_width - 40)
                                local hasAccess = hasAccessToAction(action)
                                
                                if not hasAccess then
                                    imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, 0.5)
                                end
                                
                                if CenteredButton('##with_id_' .. i, display_text, {5, y_pos}, {col_width - 20, 50}) and hasAccess then
                                    executeFastAction(action, smartFastState.selectedPlayer.id)
                                end
                                
                                if not hasAccess then
                                    imgui.PopStyleVar(1)
                                    if imgui.IsItemHovered() then
                                        imgui.SetTooltip(action_name)
                                    end
                                end
                                
                                y_pos = y_pos + 55
                            end
                        end
                    end
                    imgui.EndChild()
                    current_x = current_x + col_width + column_padding * 2
                    
                elseif with_id_columns == 2 then
                    
                    local col_width = math.floor((column_widths.with_id - column_padding * 2) / 2)
                    
                    
                    imgui.SetCursorPos(imgui.ImVec2(current_x, 0))
                    local child1_result = imgui.BeginChild('##actions_with_id_1', imgui.ImVec2(col_width, window_height - 55), true)
                    
                    if child1_result then
                        local y_pos = 5
                        gui.Text(5, y_pos, "Действия с ID (1/2):", bold_font[1])
                        y_pos = y_pos + 30
                        gui.DrawLine({5, y_pos - 5}, {col_width - 15, y_pos - 5}, cl.line)
                        
                        local half = math.ceil(#actions_with_id / 2)
                        for i = 1, half do
                            local action = actions_with_id[i]
                            if action then
                                local action_name = action.name
                                if not action_name or action_name:gsub('%s+', '') == '' then
                                    action_name = u8'Без названия'
                                end
                                
                                local display_text = formatButtonText(action_name, col_width - 40)
                                local hasAccess = hasAccessToAction(action)
                                
                                if not hasAccess then
                                    imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, 0.5)
                                end
                                
                                if CenteredButton('##with_id_1_' .. i, display_text, {5, y_pos}, {col_width - 20, 50}) and hasAccess then
                                    executeFastAction(action, smartFastState.selectedPlayer.id)
                                end
                                
                                if not hasAccess then
                                    imgui.PopStyleVar(1)
                                    if imgui.IsItemHovered() then
                                        imgui.SetTooltip(u8(action_name))
                                    end
                                end
                                
                                y_pos = y_pos + 55
                            end
                        end
                    end
                    imgui.EndChild()
                    
                    
                    imgui.SetCursorPos(imgui.ImVec2(current_x + col_width + column_padding * 2, 0))
                    local child2_result = imgui.BeginChild('##actions_with_id_2', imgui.ImVec2(col_width, window_height - 55), true)
                    
                    if child2_result then
                        local y_pos = 5
                        gui.Text(5, y_pos, "Действия с ID (2/2):", bold_font[1])
                        y_pos = y_pos + 30
                        gui.DrawLine({5, y_pos - 5}, {col_width - 15, y_pos - 5}, cl.line)
                        
                        local half = math.ceil(#actions_with_id / 2)
                        for i = half + 1, #actions_with_id do
                            local action = actions_with_id[i]
                            if action then
                                local action_name = action.name
                                if not action_name or action_name:gsub('%s+', '') == '' then
                                    action_name = u8'Без названия'
                                end
                                
                                local display_text = formatButtonText(action_name, col_width - 40)
                                local hasAccess = hasAccessToAction(action)
                                
                                if not hasAccess then
                                    imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, 0.5)
                                end
                                
                                if CenteredButton('##with_id_2_' .. i, display_text, {5, y_pos}, {col_width - 20, 50}) and hasAccess then
                                    executeFastAction(action, smartFastState.selectedPlayer.id)
                                end
                                
                                if not hasAccess then
                                    imgui.PopStyleVar(1)
                                    if imgui.IsItemHovered() then
                                        imgui.SetTooltip(u8(action_name))
                                    end
                                end
                                
                                y_pos = y_pos + 55
                            end
                        end
                    end
                    imgui.EndChild()
                    
                    current_x = current_x + col_width * 2 + column_padding * 4
                    
                else
                    
                    local col_width = math.floor((column_widths.with_id - column_padding * 4) / 3)
                    
                    for column = 1, 3 do
                        imgui.SetCursorPos(imgui.ImVec2(current_x, 0))
                        local child_result = imgui.BeginChild('##actions_with_id_' .. column, imgui.ImVec2(col_width, window_height - 55), true)
                        
                        if child_result then
                            local y_pos = 5
                            gui.Text(5, y_pos, string.format("Действия с ID (%d/3):", column), bold_font[1])
                            y_pos = y_pos + 30
                            gui.DrawLine({5, y_pos - 15}, {col_width - 15, y_pos - 15}, cl.line)
                            
                            local start_i = math.floor((column - 1) * #actions_with_id / 3) + 1
                            local end_i = math.floor(column * #actions_with_id / 3)
                            
                            for i = start_i, end_i do
                                local action = actions_with_id[i]
                                if action then
                                    local action_name = action.name
                                    if not action_name or action_name:gsub('%s+', '') == '' then
                                        action_name = u8'Без названия'
                                    end
                                    
                                    local display_text = formatButtonText(action_name, col_width - 40)
                                    local hasAccess = hasAccessToAction(action)
                                    
                                    if not hasAccess then
                                        imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, 0.5)
                                    end
                                    
                                    if CenteredButton('##with_id_' .. column .. '_' .. i, display_text, {5, y_pos}, {col_width - 20, 50}) and hasAccess then
                                        executeFastAction(action, smartFastState.selectedPlayer.id)
                                    end
                                    
                                    if not hasAccess then
                                        imgui.PopStyleVar(1)
                                        if imgui.IsItemHovered() then
                                            imgui.SetTooltip(u8(action_name))
                                        end
                                    end
                                    
                                    y_pos = y_pos + 55
                                end
                            end
                        end
                        imgui.EndChild()
                        
                        current_x = current_x + col_width + column_padding * 2
                    end
                end
            end
            
            
            if #actions_without_id > 0 then
                local col_width = column_widths.without_id
                if col_width < min_column_width then
                    col_width = min_column_width
                    
                    current_x = window_width - col_width - column_padding * 2 - 10
                end
                
                imgui.SetCursorPos(imgui.ImVec2(current_x, 0))
                local child_result = imgui.BeginChild('##actions_without_id', imgui.ImVec2(col_width, window_height - 55), true)
                
                if child_result then
                    local y_pos = 5
                    local title_text = "Действия без ID"
                    if #actions_with_id > 0 then
                        title_text = "Действия без ID"
                    end
                    gui.Text(5, y_pos, title_text, bold_font[1])
                    y_pos = y_pos + 30
                    gui.DrawLine({5, y_pos - 5}, {col_width - 15, y_pos - 5}, cl.line)
                    
                    for i, action in ipairs(actions_without_id) do
                        if action then
                            local action_name = action.name
                            if not action_name or action_name:gsub('%s+', '') == '' then
                                action_name = u8'Без названия'
                            end
                            
                            local display_text = formatButtonText(action_name, col_width - 40)
                            local hasAccess = hasAccessToAction(action)
                            
                            if not hasAccess then
                                imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, 0.5)
                            end
                            
                            if CenteredButton('##no_id_' .. i, display_text, {5, y_pos}, {col_width - 20, 50}) and hasAccess then
                                executeFastAction(action, nil)
                            end
                            
                            if not hasAccess then
                                imgui.PopStyleVar(1)
                                if imgui.IsItemHovered() then
                                    imgui.SetTooltip(u8(action_name))
                                end
                            end
                            
                            y_pos = y_pos + 55
                        end
                    end
                end
                imgui.EndChild()
            end
        end
        
        imgui.EndChild()
        imgui.End()
        
        if smartFastState.anim and smartFastState.anim.alpha > 0 then
            imgui.PopStyleVar(1)
        end
        
    end
)


win.fast = imgui.OnFrame(
	function() 
        if setting.smart_fast_menu then
            return false
        end
        return old_fast_state.isActive and not scene_active 
    end,
	function(fast)
		local size_win = {x = 348, y = 49 + math.max((#setting.fast.one_win * 34), (#setting.fast.two_win * 34))}
		local visible_draw = 0
		if #setting.fast.one_win ~= 0 and #setting.fast.two_win ~= 0 then
 			size_win.x = 691
			visible_draw = 171
		end

		imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, setting.visible_fast / 100)
		imgui.SetNextWindowPos(imgui.ImVec2(sx / 2, sy / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(size_win.x, size_win.y + 20))
		imgui.Begin('Fast win 1', windows.fast, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoSavedSettings)
		local window_pos = imgui.GetCursorScreenPos()
		local mouse_pos_all_screen = imgui.GetMousePos()
		local mouse_pos = mouse_pos_all_screen.x - window_pos.x - 10 - visible_draw
		if mouse_pos <= 0 then
			mouse_pos = 0.01
		elseif mouse_pos >= 331 then
			mouse_pos = 330.99
		end
		
		imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, 1.0)
		
		gui.Draw({10 + visible_draw, 16}, {331, 4}, imgui.ImVec4(0.21, 0.21, 0.21, 1.00), 20, 15)
		imgui.SetCursorPos(imgui.ImVec2(10 + visible_draw, 4))
		imgui.InvisibleButton(u8'##Управление видимостью окна', imgui.ImVec2(331, 26))
		if imgui.IsItemActive() then
			gui.Draw({10 + visible_draw, 16}, {mouse_pos, 4}, cl.def, 20, 15)
			setting.visible_fast = mouse_pos / 3.31
			bool_button_active_music = true
		else
			if bool_button_active_music then
				bool_button_active_music = false
				setting.visible_fast = mouse_pos / 3.31
				save()
				gui.Draw({10 + visible_draw, 16}, {mouse_pos, 4}, cl.def, 20, 15)
			else
				gui.Draw({10 + visible_draw, 16}, {3.31 * setting.visible_fast, 4}, cl.def, 20, 15)
			end
		end
		if imgui.IsItemHovered() then
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1.00, 1.00, 1.00, 1.00))
			gui.Text(118 + visible_draw, 1, 'Прозрачность окна', font[3])
			imgui.PopStyleColor(1)
		end
		imgui.PopStyleVar(1)
		
		gui.Draw({4, 24}, {size_win.x - 4, size_win.y - 4}, cl.main, 12, 15)
		imgui.SetCursorPos(imgui.ImVec2(10, 30))
		if imgui.InvisibleButton(u8'##Закрыть окно БД', imgui.ImVec2(16, 16)) or close_win.fast then
			old_fast_state.isActive = false
			windows.fast[0] = false
			close_win.fast = false
			old_fast_state.id = -1
			old_fast_state.nick = 'No_Name'
			targ_id = nil
		end
		imgui.SetCursorPos(imgui.ImVec2(16, 36))
		local p = imgui.GetCursorScreenPos()
		if imgui.IsItemHovered() then
			imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x - 0.4, p.y - 0.2), 7, imgui.GetColorU32Vec4(imgui.ImVec4(0.98, 0.32, 0.38, 1.00)), 60)
		else
			imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x - 0.4, p.y - 0.2), 7, imgui.GetColorU32Vec4(imgui.ImVec4(0.98, 0.42, 0.38, 1.00)), 60)
		end
		
		local nick_name_fast = old_fast_state.nick .. ' [' .. old_fast_state.id .. ']'
		imgui.PushFont(bold_font[1])
		local calc = imgui.CalcTextSize(nick_name_fast) 
		imgui.PopFont()
		gui.Text(-(calc.x / 2) + ((size_win.x - 8) / 2) + 4, 33, nick_name_fast, bold_font[1])
		gui.DrawLine({4, 62}, {size_win.x - 8, 62}, cl.line)
		
		local pos_x = 9
		if #setting.fast.one_win ~= 0 and #setting.fast.two_win ~= 0 then
			pos_x = 352
		end
		
		if #setting.fast.one_win ~= 0 then
			for i = 1, #setting.fast.one_win do
				local raw_name_fast = setting.fast.one_win[i].name or ''
				local name_fast = raw_name_fast
				if raw_name_fast:gsub('%s+', '') == '' then
					name_fast = u8'??? ???????? [' .. i .. ']'
				end
				local access = false
				for c = 1, #cmd[1] do
					if cmd[1][c].cmd == setting.fast.one_win[i].cmd then
						if cmd[1][c].rank > setting.rank then
							access = true
							break
					end
					end
				end
				local name_fast_button_1 = u8:decode(raw_name_fast)
				if #name_fast_button_1 > 41 then
					name_fast_button_1 = name_fast_button_1:sub(1, 41) .. '...'
				end
				name_fast_button_1 = u8(name_fast_button_1)
				if not access then
					if gui.Button(name_fast_button_1 .. '##fast' .. i, {9, 68 + ((i - 1) * 34)}, {333, 29}) then
						local tr_cmd = false
						local other_cmd = false
						local UID_cmd = 0
						for c = 1, #cmd[1] do
							if cmd[1][c].cmd == setting.fast.one_win[i].cmd then
								tr_cmd = true
								UID_cmd = cmd[1][c].UID
								break 
							end
						end
						if not tr_cmd then
							for c = 1, #setting.command_tabs do
								if setting.command_tabs[c] == setting.fast.one_win[i].cmd and setting.command_tabs[c] ~= '' then
									other_cmd = true
									break 
								end
							end
						end
						if tr_cmd then
							if setting.fast.one_win[i].send then
								if setting.fast.one_win[i].id then
									cmd_start(tostring(old_fast_state.id), tostring(UID_cmd) .. setting.fast.one_win[i].cmd)
								else
									cmd_start('', tostring(UID_cmd) .. setting.fast.one_win[i].cmd)
								end
							else
								if setting.fast.one_win[i].id then
									sampSetChatInputEnabled(true)
									sampSetChatInputText('/' .. setting.fast.one_win[i].cmd .. ' ' .. old_fast_state.id)
								else
									sampSetChatInputEnabled(true)
									sampSetChatInputText('/' .. setting.fast.one_win[i].cmd)
								end
							end
						elseif other_cmd then
							start_other_cmd(setting.fast.one_win[i].cmd, tostring(old_fast_state.id))
						else
							if setting.fast.one_win[i].send then
								if setting.fast.one_win[i].id then
									sampSendChat('/' .. setting.fast.one_win[i].cmd .. ' ' .. old_fast_state.id)
								else
									sampSendChat('/' .. setting.fast.one_win[i].cmd)
								end
							else
								sampSetChatInputEnabled(true)
								sampSetChatInputText('/' .. setting.fast.one_win[i].cmd)
							end
						end
						
						old_fast_state.isActive = false
						windows.fast[0] = false
					end
				else
					gui.Button(name_fast_button_1 .. '##fast' .. i, {9, 68 + ((i - 1) * 34)}, {333, 29}, false)
				end
			end
		end
		if #setting.fast.two_win ~= 0 then
			for i = 1, #setting.fast.two_win do
				local raw_name_fast = setting.fast.two_win[i].name or ''
				local name_fast = raw_name_fast
				if raw_name_fast:gsub('%s+', '') == '' then
					name_fast = u8'??? ???????? [' .. i .. ']'
				end
				local access = false
				for c = 1, #cmd[1] do
					if cmd[1][c].cmd == setting.fast.two_win[i].cmd then
						if cmd[1][c].rank > setting.rank then
							access = true
							break
					end
					end
				end
				local name_fast_button_2 = u8:decode(raw_name_fast)
				if #name_fast_button_2 > 41 then
					name_fast_button_2 = name_fast_button_2:sub(1, 41) .. '...'
				end
				name_fast_button_2 = u8(name_fast_button_2)
				if not access then
					if gui.Button(name_fast_button_2 .. '##fast2' .. i, {pos_x, 68 + ((i - 1) * 34)}, {333, 29}) then
						local tr_cmd = false
						local other_cmd = false
						local UID_cmd = 0
						for c = 1, #cmd[1] do
							if cmd[1][c].cmd == setting.fast.two_win[i].cmd then
								tr_cmd = true
								UID_cmd = cmd[1][c].UID
								break 
							end
						end
						if not tr_cmd then
							for c = 1, #setting.command_tabs do
								if setting.command_tabs[c] == setting.fast.two_win[i].cmd and setting.command_tabs[c] ~= '' then
									other_cmd = true
									break 
								end
							end
						end
						if tr_cmd then
							if setting.fast.two_win[i].send then
								if setting.fast.two_win[i].id then
									cmd_start(tostring(old_fast_state.id), tostring(UID_cmd) .. setting.fast.two_win[i].cmd)
								else
									cmd_start('', tostring(UID_cmd) .. setting.fast.two_win[i].cmd)
								end
							else
								if setting.fast.two_win[i].id then
									sampSetChatInputEnabled(true)
									sampSetChatInputText('/' .. setting.fast.two_win[i].cmd .. ' ' .. old_fast_state.id)
								else
									sampSetChatInputEnabled(true)
									sampSetChatInputText('/' .. setting.fast.two_win[i].cmd)
								end
							end
						elseif other_cmd then
							start_other_cmd(setting.fast.two_win[i].cmd, tostring(old_fast_state.id))
						else
							if setting.fast.two_win[i].send then
								if setting.fast.two_win[i].id then
									sampSendChat('/' .. setting.fast.two_win[i].cmd .. ' ' .. old_fast_state.id)
								else
									sampSendChat('/' .. setting.fast.two_win[i].cmd)
								end
							else
								sampSetChatInputEnabled(true)
								sampSetChatInputText('/' .. setting.fast.two_win[i].cmd)
							end
						end
						
						old_fast_state.isActive = false
						windows.fast[0] = false
					end
				else
					gui.Button(name_fast_button_2 .. '##fast2' .. i, {pos_x, 68 + ((i - 1) * 34)}, {333, 29}, false)
				end
			end
		end
		imgui.End()
		imgui.PopStyleVar(1)
	end
)


win.action = imgui.OnFrame(
	function() return windows.action[0] and not scene_active end,
	function(action)
		action.HideCursor = true
		local size_win = {x = 300, y = 25 + (#dialog_act.info * 24)}
		if dialog_act.enter then
			size_win = {x = 300, y = 39}
		end
		local x_pos = sx - (size_win.x / 2) - 20
		if dialog_act.status then
			if x_act_dialog > x_pos then
				x_act_dialog = x_act_dialog - (anim * 1400)
			elseif x_act_dialog <= x_pos then
				x_act_dialog = x_pos
			end
		else
			if x_act_dialog < (sx + 200) then
				x_act_dialog = x_act_dialog + (anim * 1200)
			else
				windows.action[0] = false
			end
		end
		
		imgui.SetNextWindowPos(imgui.ImVec2(x_act_dialog, sy - (size_win.y / 2) - 20), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(size_win.x, size_win.y))
		imgui.Begin('Action reminder', windows.action,  imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoSavedSettings + imgui.WindowFlags.NoMove)
		gui.Draw({4, 4}, {size_win.x - 4, size_win.y - 4}, imgui.ImVec4(0.10, 0.10, 0.10, 0.70), 12, 15)
		
		if dialog_act.enter then
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.96, 0.96, 0.96, 1.00))
			gui.Text(20, 11, 'Нажмите ' .. setting.enter_key[2] .. ', чтобы продолжить', bold_font[1])
		else 
			if dialog_act.info ~= 0 then
				for i = 1, #dialog_act.info do
					imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.96, 0.96, 0.96, 1.00))
					if i ~= 10 then
						gui.Text(20, 17 + ((i - 1) * 24), 'NUM ' .. i .. ' - ' .. u8:decode(dialog_act.info[i]), bold_font[1])
					else
						gui.Text(20, 17 + ((i - 1) * 24), 'NUM 0 - ' .. u8:decode(dialog_act.info[i]), bold_font[1])
					end
				end
			end
		end
		
		imgui.End()
	end
)

win.stat = imgui.OnFrame(
	function() return windows.stat[0] and not scene_active end,
	function(stat)
		stat.HideCursor = true
		local size_y_stat = 38
		size_y_stat = size_y_stat + (setting.stat_on_screen.current_time and 21 or 0)
		size_y_stat = size_y_stat + (setting.stat_on_screen.current_date and setting.stat_on_screen.current_time and 24 or setting.stat_on_screen.current_date and 8 or 0)
		local num_stat = 0
		size_y_stat = size_y_stat + (setting.stat_on_screen.day and 7 or 0) + (setting.stat_on_screen.afk and 7 or 0) + (setting.stat_on_screen.all and 7 or 0) + (setting.stat_on_screen.ses_day and 7 or 0) + (setting.stat_on_screen.ses_afk and 7 or 0) + (setting.stat_on_screen.ses_all and 7 or 0)
		num_stat = num_stat  + (setting.stat_on_screen.day and 1 or 0) + (setting.stat_on_screen.afk and 1 or 0) + (setting.stat_on_screen.all and 1 or 0) + (setting.stat_on_screen.ses_day and 1 or 0) + (setting.stat_on_screen.ses_afk and 1 or 0) + (setting.stat_on_screen.ses_all and 1 or 0)
		if num_stat > 0 then
			size_y_stat = size_y_stat + ((num_stat - 1) * 13)
			size_y_stat = size_y_stat + (setting.stat_on_screen.current_time and 17 or setting.stat_on_screen.current_date and 17 or 0)
		end
		
		--[[if setting.stat_on_screen.current_time then
			size_y_stat = size_y_stat + 21
		end]]
		local function format_custom_date()
			local weekdays = {'Воскресенье', 'Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота'}
			local months = {'января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'}

			local current_time = os.date('*t')
			local weekday = weekdays[current_time.wday]
			local month = months[current_time.month]
			local day = current_time.day

			return weekday .. ', ' .. day .. ' ' .. month
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
		imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, (setting.stat_on_screen.visible > 15) and setting.stat_on_screen.visible / 100 or 0.15)
		imgui.SetNextWindowPos(imgui.ImVec2(setting.position_stat.x, setting.position_stat.y), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(298, size_y_stat + 8))
		imgui.Begin('Stat Online', windows.stat,  imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoFocusOnAppearing + imgui.WindowFlags.NoBringToFrontOnFocus + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoMove)
		gui.Draw({4, 4}, {290, size_y_stat}, imgui.ImVec4(0.05, 0.05, 0.05, 1.00), 12, 15)
		
		if imgui.IsMouseClicked(0) and change_pos_onstat then
			change_pos_onstat = false 
		end
		
		local pos_pl_stat = 0
		if setting.stat_on_screen.current_time then
			local time_format = os.date('%H:%M:%S')
			imgui.PushFont(bold_font[3])
			local calc_time = imgui.CalcTextSize(time_format)
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1.00, 1.00, 1.00, 1.00))
			gui.Text(149 - (calc_time.x / 2), 16 + pos_pl_stat, time_format, bold_font[3])
			imgui.PopStyleColor(1)
			imgui.PopFont()
			pos_pl_stat = 38
		end
		if setting.stat_on_screen.current_date then
			local time_format = format_custom_date()
			imgui.PushFont(bold_font[1])
			local calc_date = imgui.CalcTextSize(u8(time_format))
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1.00, 1.00, 1.00, 1.00))
			gui.Text(149 - (calc_date.x / 2), 16 + pos_pl_stat, time_format, bold_font[1])
			imgui.PopStyleColor(1)
			imgui.PopFont()
			pos_pl_stat = pos_pl_stat + 26
		end
		if setting.stat_on_screen.day then
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1.00, 1.00, 1.00, 1.00))
			gui.Text(20, 16 + pos_pl_stat, 'Чистый за день: ' .. format_time(setting.stat.cl[1]), font[3])
			imgui.PopStyleColor(1)
			pos_pl_stat = pos_pl_stat + 20
		end
		if setting.stat_on_screen.afk then
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1.00, 1.00, 1.00, 1.00))
			gui.Text(20, 16 + pos_pl_stat, 'АФК за день: ' .. format_time(setting.stat.afk[1]), font[3])
			imgui.PopStyleColor(1)
			pos_pl_stat = pos_pl_stat + 20
		end
		if setting.stat_on_screen.all then
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1.00, 1.00, 1.00, 1.00))
			gui.Text(20, 16 + pos_pl_stat, 'Всего за день: ' .. format_time(setting.stat.cl[1] + setting.stat.afk[1]), font[3])
			imgui.PopStyleColor(1)
			pos_pl_stat = pos_pl_stat + 20
		end
		if setting.stat_on_screen.ses_day then
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1.00, 1.00, 1.00, 1.00))
			gui.Text(20, 16 + pos_pl_stat, 'Чистый за сессию: ' .. format_time(stat_ses.cl), font[3])
			imgui.PopStyleColor(1)
			pos_pl_stat = pos_pl_stat + 20
		end
		if setting.stat_on_screen.ses_afk then
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1.00, 1.00, 1.00, 1.00))
			gui.Text(20, 16 + pos_pl_stat, 'АФК за сессию: ' .. format_time(stat_ses.afk), font[3])
			imgui.PopStyleColor(1)
			pos_pl_stat = pos_pl_stat + 20
		end
		if setting.stat_on_screen.ses_all then
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1.00, 1.00, 1.00, 1.00))
			gui.Text(20, 16 + pos_pl_stat, 'Всего за сессию: ' .. format_time(stat_ses.all), font[3])
			imgui.PopStyleColor(1)
			pos_pl_stat = pos_pl_stat + 20
		end
		
		imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, 1.0)
		imgui.End()
	end
)

function theme()
	imgui.SwitchContext()
	local ImVec4 = imgui.ImVec4
	imgui.GetStyle().WindowPadding = imgui.ImVec2(0, 0)
	imgui.GetStyle().FramePadding = imgui.ImVec2(0, 0)
	imgui.GetStyle().ItemSpacing = imgui.ImVec2(5, 5)
	imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2, 2)
	imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)
	imgui.GetStyle().IndentSpacing = 0
	imgui.GetStyle().ScrollbarSize = 10
	imgui.GetStyle().GrabMinSize = 10
	imgui.GetStyle().WindowBorderSize = 1
	imgui.GetStyle().ChildBorderSize = 1
	imgui.GetStyle().PopupBorderSize = 1
	imgui.GetStyle().FrameBorderSize = 1
	imgui.GetStyle().TabBorderSize = 1
	imgui.GetStyle().WindowRounding = 7 --> Скругление окна
	imgui.GetStyle().ChildRounding = 7
	imgui.GetStyle().FrameRounding = 7
	imgui.GetStyle().PopupRounding = 7
	imgui.GetStyle().ScrollbarRounding = 7
	imgui.GetStyle().GrabRounding = 7
	imgui.GetStyle().TabRounding = 7
 
	imgui.GetStyle().Colors[imgui.Col.Text]				   = cl.text
	imgui.GetStyle().Colors[imgui.Col.TextDisabled]		   = ImVec4(0.50, 0.50, 0.50, 1.00)
	imgui.GetStyle().Colors[imgui.Col.WindowBg]			   = ImVec4(0.00, 0.00, 0.00, 0.00) --> Окно
	imgui.GetStyle().Colors[imgui.Col.ChildBg]				= ImVec4(1.00, 1.00, 1.00, 0.00)
	imgui.GetStyle().Colors[imgui.Col.PopupBg]				= cl.main
	imgui.GetStyle().Colors[imgui.Col.Border]				 = ImVec4(0.00, 0.30, 0.00, 0.00) --> Обводка окна
	imgui.GetStyle().Colors[imgui.Col.BorderShadow]		   = ImVec4(0.00, 0.00, 0.00, 0.00) --> Обводка окна
	imgui.GetStyle().Colors[imgui.Col.FrameBg]				= ImVec4(0.00, 0.00, 0.00, 0.00) --> Инпут
	imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]		 = ImVec4(0.00, 0.00, 0.00, 0.00)
	imgui.GetStyle().Colors[imgui.Col.FrameBgActive]		  = ImVec4(0.00, 0.00, 0.00, 0.00)
	imgui.GetStyle().Colors[imgui.Col.TitleBg]				= ImVec4(0.04, 0.04, 0.04, 1.00)
	imgui.GetStyle().Colors[imgui.Col.TitleBgActive]		  = ImVec4(0.48, 0.16, 0.16, 1.00)
	imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]	   = ImVec4(0.00, 0.00, 0.00, 0.51)
	imgui.GetStyle().Colors[imgui.Col.MenuBarBg]			  = ImVec4(0.14, 0.14, 0.14, 1.00)
	imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]			= ImVec4(0.00, 0.00, 0.00, 0.00) --> Фон скроллбара
	imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]		  = ImVec4(0.31, 0.31, 0.31, 1.00)
	imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
	imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]	= ImVec4(0.51, 0.51, 0.51, 1.00)
	imgui.GetStyle().Colors[imgui.Col.CheckMark]			  = ImVec4(0.98, 0.26, 0.26, 1.00)
	imgui.GetStyle().Colors[imgui.Col.SliderGrab]			 = ImVec4(0.88, 0.26, 0.94, 0.00) --> Слайдер
	imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]	   = ImVec4(0.98, 0.26, 0.96, 0.00) --> Слайдер
	imgui.GetStyle().Colors[imgui.Col.Button]				 = ImVec4(0.98, 0.26, 0.26, 0.40)
	imgui.GetStyle().Colors[imgui.Col.ButtonHovered]		  = ImVec4(0.98, 0.26, 0.26, 1.00)
	imgui.GetStyle().Colors[imgui.Col.ButtonActive]		   = ImVec4(0.98, 0.06, 0.06, 1.00)
	imgui.GetStyle().Colors[imgui.Col.Header]				 = ImVec4(0.98, 0.26, 0.26, 0.31)
	imgui.GetStyle().Colors[imgui.Col.HeaderHovered]		  = ImVec4(0.98, 0.26, 0.26, 0.80)
	imgui.GetStyle().Colors[imgui.Col.HeaderActive]		   = ImVec4(0.98, 0.26, 0.26, 1.00)
	imgui.GetStyle().Colors[imgui.Col.Separator]			  = ImVec4(0.43, 0.43, 0.50, 0.50)
	imgui.GetStyle().Colors[imgui.Col.SeparatorHovered]	   = ImVec4(0.75, 0.10, 0.10, 0.78)
	imgui.GetStyle().Colors[imgui.Col.SeparatorActive]		= ImVec4(0.75, 0.10, 0.10, 1.00)
	imgui.GetStyle().Colors[imgui.Col.ResizeGrip]			 = ImVec4(0.98, 0.26, 0.26, 0.25)
	imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]	  = ImVec4(0.98, 0.26, 0.26, 0.67)
	imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]	   = ImVec4(0.98, 0.26, 0.26, 0.95)
	imgui.GetStyle().Colors[imgui.Col.Tab]					= ImVec4(0.98, 0.26, 0.26, 0.40)
	imgui.GetStyle().Colors[imgui.Col.TabHovered]			 = ImVec4(0.98, 0.26, 0.26, 1.00)
	imgui.GetStyle().Colors[imgui.Col.TabActive]			  = ImVec4(0.98, 0.06, 0.06, 1.00)
	imgui.GetStyle().Colors[imgui.Col.TabUnfocused]		   = ImVec4(0.98, 0.26, 0.26, 1.00)
	imgui.GetStyle().Colors[imgui.Col.TabUnfocusedActive]	 = ImVec4(0.98, 0.26, 0.26, 1.00)
	imgui.GetStyle().Colors[imgui.Col.PlotLines]			  = ImVec4(0.61, 0.61, 0.61, 1.00)
	imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered]	   = ImVec4(1.00, 0.43, 0.35, 1.00)
	imgui.GetStyle().Colors[imgui.Col.PlotHistogram]		  = ImVec4(0.90, 0.70, 0.00, 1.00)
	imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
	imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]		 = ImVec4(0.50, 0.50, 0.50, 0.50)
end

imgui.OnInitialize(function()
	theme()
end)

function change_design(design_bool, bool_theme)
	local def = imgui.ImVec4(setting.color_def[1], setting.color_def[2], setting.color_def[3], 1.00)
	local c_defolt_black = {
		main = imgui.ImVec4(0.10, 0.10, 0.10, 1.00),
		tab = imgui.ImVec4(0.13, 0.13, 0.13, 1.00),
		text = imgui.ImVec4(0.95, 0.95, 0.95, 1.00),
		bg = imgui.ImVec4(0.20, 0.20, 0.20, 1.00),
		bg2 = imgui.ImVec4(0.25, 0.25, 0.25, 1.00),
		line = imgui.ImVec4(0.18, 0.18, 0.18, 1.00),
		def = def,
		circ_im = imgui.ImVec4(0.16, 0.16, 0.16, 1.00)
	}
	local c_defolt_white = {
		main = imgui.ImVec4(0.95, 0.93, 0.92, 1.00),
		tab = imgui.ImVec4(0.90, 0.88, 0.86, 1.00),
		text = imgui.ImVec4(0.10, 0.10, 0.10, 1.00),
		bg = imgui.ImVec4(0.98, 0.98, 0.98, 1.00),
		bg2 = imgui.ImVec4(0.90, 0.90, 0.90, 1.00),
		line = imgui.ImVec4(0.77, 0.77, 0.77, 1.00),
		def = def,
		circ_im = imgui.ImVec4(0.82, 0.82, 0.82, 1.00)
	}
	if design_bool == 'White' and (bool_theme == nil or bool_theme == true) then
		local jc
		if setting.cl ~= 'White' then
			jc = {
				main = {0.10, 0.10, 0.10},
				tab = {0.13, 0.13, 0.13},
				text = {0.95, 0.95, 0.95},
				circ_im = {0.16, 0.16, 0.16}
			}
		else
			jc = {
				main = {0.93, 0.93, 0.93},
				tab = {0.88, 0.88, 0.88},
				text = {0.10, 0.10, 0.10},
				circ_im = {0.82, 0.82, 0.82}
			}
		end
		setting.cl = 'White'
		
		lua_thread.create(function()
			local stop_while = {false, false, false, false, false, false, false, false}
			while true do
				wait(0)
				local anim_bool = (anim * 4)
				
				if jc.main[1] < 0.95 then
					jc.main[1] = jc.main[1] + anim_bool
				else
					stop_while[1] = true
				end
				if jc.main[2] < 0.93 then
					jc.main[2] = jc.main[2] + anim_bool
				else
					stop_while[2] = true
				end
				if jc.main[3] < 0.92 then
					jc.main[3] = jc.main[3] + anim_bool
				else
					stop_while[3] = true
				end
				
				if jc.tab[1] < 0.90 then
					jc.tab[1] = jc.tab[1] + anim_bool
				else
					stop_while[4] = true
				end
				if jc.tab[2] < 0.88 then
					jc.tab[2] = jc.tab[2] + anim_bool
				else
					stop_while[5] = true
				end
				if jc.tab[3] < 0.86 then
					jc.tab[3] = jc.tab[3] + anim_bool
				else
					stop_while[6] = true
				end
				
				if jc.text[1] > 0.10 then
					jc.text[1] = jc.text[1] - anim_bool
					jc.text = {jc.text[1], jc.text[1], jc.text[1]}
				else
					stop_while[7] = true
				end
				
				if jc.circ_im[1] < 0.82 then
					jc.circ_im[1] = jc.circ_im[1] + anim_bool
					jc.circ_im = {jc.circ_im[1], jc.circ_im[1], jc.circ_im[1]}
				else
					stop_while[8] = true
				end
				
				cl = {
					main = imgui.ImVec4(jc.main[1], jc.main[2], jc.main[3], 1.00),
					tab = imgui.ImVec4(jc.tab[1], jc.tab[2], jc.tab[3], 1.00),
					text = imgui.ImVec4(jc.text[1], jc.text[2], jc.text[3], 1.00),
					bg = imgui.ImVec4(0.98, 0.98, 0.98, 1.00),
					bg2 = imgui.ImVec4(0.99, 0.99, 0.99, 1.00),
					line = imgui.ImVec4(0.77, 0.77, 0.77, 1.00),
					def = def,
					circ_im = imgui.ImVec4(jc.circ_im[1], jc.circ_im[2], jc.circ_im[3], 1.00)
				}
				theme()
				if (stop_while[1] and stop_while[2] and stop_while[3] and stop_while[4] and stop_while[5] 
				and stop_while[6] and stop_while[7] and stop_while[8]) or setting.cl == 'Black' then
					cl = c_defolt_white
					theme()
					
					break
				end
			end
		end)
	elseif design_bool == 'Black' and bool_theme == nil then
		setting.cl = 'Black'
		local jc = {
			main = {0.93, 0.93, 0.93},
			tab = {0.88, 0.88, 0.88},
			text = {0.10, 0.10, 0.10},
			circ_im = {0.82, 0.82, 0.82}
		}
		
		lua_thread.create(function()
			local stop_while = {false, false, false, false}
			while true do
				wait(0)
				local anim_bool = (anim * 4)
				
				if jc.main[1] > 0.10 then
					jc.main[1] = jc.main[1] - anim_bool
					jc.main = {jc.main[1], jc.main[1], jc.main[1]}
				else
					stop_while[1] = true
				end
				
				if jc.tab[1] > 0.13 then
					jc.tab[1] = jc.tab[1] - anim_bool
					jc.tab = {jc.tab[1], jc.tab[1], jc.tab[1]}
				else
					stop_while[2] = true
				end
				
				if jc.text[1] < 0.95 then
					jc.text[1] = jc.text[1] + anim_bool
					jc.text = {jc.text[1], jc.text[1], jc.text[1]}
				else
					stop_while[3] = true
				end
				
				if jc.circ_im[1] > 0.16 then
					jc.circ_im[1] = jc.circ_im[1] - anim_bool
					jc.circ_im = {jc.circ_im[1], jc.circ_im[1], jc.circ_im[1]}
				else
					stop_while[4] = true
				end
				
				cl = {
					main = imgui.ImVec4(jc.main[1], jc.main[2], jc.main[3], 1.00),
					tab = imgui.ImVec4(jc.tab[1], jc.tab[2], jc.tab[3], 1.00),
					text = imgui.ImVec4(jc.text[1], jc.text[2], jc.text[3], 1.00),
					bg = imgui.ImVec4(0.20, 0.20, 0.20, 1.00),
					bg2 = imgui.ImVec4(0.25, 0.25, 0.25, 1.00),
					line = imgui.ImVec4(0.18, 0.18, 0.18, 1.00),
					def = def,
					circ_im = imgui.ImVec4(jc.circ_im[1], jc.circ_im[2], jc.circ_im[3], 1.00)
				}
				theme()
				if (stop_while[1] and stop_while[2] and stop_while[3] and stop_while[4]) or setting.cl == 'White' then
					cl = c_defolt_black
					theme()
					
					break
				end
			end
		end)
	elseif bool_theme ~= nil then
		if design_bool == 'White' then
			cl = c_defolt_white
		else
			cl = c_defolt_black
		end
	end
	if bool_theme == nil or bool_theme == true then
		theme()
	end
end

function open_fast_menu_for_id(id)
    openSmartFastMenu(id)
end
--> Акценты
sampRegisterChatCommand('r', function(text_accents_r) 
	if setting.teg_r ~= '' and setting.teg_r ~= ' ' and text_accents_r ~= '' and not setting.accent.func then
		sampSendChat('/r [' .. u8:decode(setting.teg_r)..']: ' .. text_accents_r)
	elseif setting.teg_r == '' and text_accents_r ~= '' and setting.accent.func and setting.accent.r and setting.accent.text ~= '' then
		sampSendChat('/r [' .. u8:decode(setting.accent.text) .. ' акцент]: ' .. text_accents_r)
	elseif setting.teg_r ~= '' and setting.teg_r ~= ' ' and text_accents_r ~= '' and setting.accent.func and setting.accent.r and setting.accent.text ~= '' then
		sampSendChat('/r [' .. u8:decode(setting.teg_r) .. '][' .. u8:decode(setting.accent.text) .. ' акцент]: ' .. text_accents_r)
	else
		sampSendChat('/r ' .. text_accents_r)
	end 
end)

sampRegisterChatCommand('s', function(text_accents_s) 
	if text_accents_s ~= '' and setting.accent.func and setting.accent.s and setting.accent.text ~= '' then
		sampSendChat('/s [' .. u8:decode(setting.accent.text)..' акцент]: ' .. text_accents_s)
	else
		sampSendChat('/s ' .. text_accents_s)
	end 
end)

sampRegisterChatCommand('f', function(text_accents_f) 
	if text_accents_f ~= '' and setting.accent.func and setting.accent.f and setting.accent.text ~= '' then
		sampSendChat('/f [' .. u8:decode(setting.accent.text)..' акцент]: ' .. text_accents_f)
	else
		sampSendChat('/f ' .. text_accents_f)
	end 
end)
sampRegisterChatCommand('fm', function(arg)
    if arg and arg ~= '' then
        openSmartFastMenu(arg)
    else
        openSmartFastMenu()
    end
end)
--> Прочие функции
function start_other_cmd(cmd_func, arguments)
	if cmd_func == setting.cmd_open_win then
		open_main()
	else
		local tab_open = {'cmd', 'shpora', 'dep', 'sob', 'reminder', 'stat', 'music', 'rp_zona', 'actions'}
		local tab_name_open = {u8'Команды', u8'Шпаргалки', u8'Департамент', u8'Собеседование', u8'Напоминания', u8'Статистика онлайна', u8'Музыка', u8'РП зона', u8'Действия'}
		for i = 1, #setting.command_tabs do
			if setting.command_tabs[i] == cmd_func then
				tab = tab_open[i]
				name_tab = tab_name_open[i]
				if not windows.main[0] then
					open_main()
				end
				if i == 4 and arguments:find('(%d+)') and setting.sob_id_arg then
					local arg_id = arguments:match('(%d+)')
					arg_id = tonumber(arg_id)
					if arg_id ~= nil and (setting.sob.min_exp ~= '' or not setting.sob.auto_exp)
					and (setting.sob.min_law ~= '' or not setting.sob.auto_law)
					and (setting.sob.min_narko ~= '' or not setting.sob.auto_narko) then
						if not sampIsPlayerConnected(arg_id) then
							if not setting.cef_notif then
								sampAddChatMessage("[SH] {FFFFFF}Игрок с таким ID не найден, либо это Вы", 0xFF5345)
							else
								cefnotig("{FF5345}[SH] {FFFFFF}Игрок с таким ID не найден, либо это Вы", 3000)
							end
							windows.main[0] = false
							return
						end
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
							id = arg_id,
							nick = sampGetPlayerNickname(arg_id),
							history = {}
						}
					end
				end
			end
		end
	end
end

function filter_word_rus(data)
	if data.EventChar >= 1040 and data.EventChar <= 1103 then
	
		return 0
	elseif data.EventChar == 32 then
	
		return 0
	else
		return true
	end
end

function filter_word_en(data)
	if (data.EventChar >= 97 and data.EventChar <= 122) then
	
		return 0
	else
		return true
	end
end

function filter_word_en_num(data)
	if (data.EventChar >= 65 and data.EventChar <= 90) or
		(data.EventChar >= 97 and data.EventChar <= 122) or
		(data.EventChar >= 48 and data.EventChar <= 57) then
	
		return 0
	else
		return true
	end
end

function filter_word_en_rus_num(data)
	local char_code = data.EventChar
	if (char_code >= 1040 and char_code <= 1103) or
	   (char_code >= 65 and char_code <= 90) or
	   (char_code >= 97 and char_code <= 122) or
	   (char_code == 32) or
	   (char_code >= 48 and char_code <= 57) then 
	   
		return 0
	else
		return true
	end
end

function filter_word_en_rus_num_h(data)
	local char_code = data.EventChar
	if (char_code >= 1040 and char_code <= 1103) or
	   (char_code >= 65 and char_code <= 90) or
	   (char_code >= 97 and char_code <= 122) or
	   (char_code == 32) or
	   (char_code >= 48 and char_code <= 57) or
	   (char_code == 45) then
		return 0
	else
		return true
	end
end

TextCallbackEnRusNumH = ffi.cast('int (*)(ImGuiInputTextCallbackData* data)', filter_word_en_rus_num_h)
TextCallbackRus = ffi.cast('int (*)(ImGuiInputTextCallbackData* data)', filter_word_rus)
TextCallbackEn = ffi.cast('int (*)(ImGuiInputTextCallbackData* data)', filter_word_en)
TextCallbackEnNum = ffi.cast('int (*)(ImGuiInputTextCallbackData* data)', filter_word_en_num)
TextCallbackEnRusNum = ffi.cast('int (*)(ImGuiInputTextCallbackData* data)', filter_word_en_rus_num)

function add_cmd_in_all_cmd()
	local function push_unique(command_name, seen)
		if command_name ~= nil and command_name ~= '' and not seen[command_name] then
			seen[command_name] = true
			table.insert(all_cmd, command_name)
		end
	end

	local seen = {}
	all_cmd = {}
	push_unique('ts', seen)
	push_unique('r', seen)
	push_unique('d', seen)
	push_unique('go', seen)
	push_unique('s', seen)
	push_unique('f', seen)
	if #cmd[1] ~= 0 then
		for i = 1, #cmd[1] do
			push_unique(cmd[1][i].cmd, seen)
		end
	end
	if #setting.shp ~= 0 then
		for i = 1, #setting.shp do
			if setting.shp[i].cmd ~= nil and setting.shp[i].cmd ~= '' then
				push_unique(setting.shp[i].cmd, seen)
			end
		end
	end
	if setting.cmd_open_win ~= '' then
		push_unique(setting.cmd_open_win, seen)
	end
	for i = 1, #setting.command_tabs do
		if setting.command_tabs[i] ~= '' then
			push_unique(setting.command_tabs[i], seen)
		end
	end
end

function round(num, decimals)
	if decimals == nil then decimals = 0 end
	local mult = 10^(decimals)
	return math.floor(num * mult + 0.5) / mult
end

function floor(number)
	return math.floor(number)
end

function compare_array(array1, array2)
	if #array1 ~= #array2 then
		return false
	end
	
	for i, v in ipairs(array1) do
		if type(v) == 'table' then
			if not compare_array(v, array2[i]) then
				return false
			end
		elseif v ~= array2[i] then
			return false
		end
	end
	
	return true
end

function compare_array_disable_order(arr1, arr2)
	if #arr1 ~= #arr2 then
		return false
	end

	local copy_arr1 = {}
	local copy_arr2 = {}
	for i, v in ipairs(arr1) do
		copy_arr1[i] = v
	end
	for i, v in ipairs(arr2) do
		copy_arr2[i] = v
	end

	table.sort(copy_arr1)
	table.sort(copy_arr2)

	for i = 1, #copy_arr1 do
		if copy_arr1[i] ~= copy_arr2[i] then
			return false
		end
	end

	return true
end

function wrapText(inputText, maxLength, maxTotalLength)
	local result = ""
	local count = 0

	if maxTotalLength and #inputText > maxTotalLength then
		inputText = inputText:sub(1, maxTotalLength - 3) .. "..."
	end

	local pos = 1
	while pos <= #inputText do
		local endPos = math.min(pos + maxLength - 1, #inputText)
		result = result .. inputText:sub(pos, endPos)
		if endPos < #inputText then
			result = result .. "\n"
			count = count + 1
		end
		pos = endPos + 1
	end

	return result, count
end

function ch_pos_on_stat()
	pos_new_stat = lua_thread.create(function()
		change_pos_onstat = true
		sampSetCursorMode(4)
		windows.main[0] = false
		if not sampIsChatInputActive() then
			while not sampIsChatInputActive() and change_pos_onstat do
				wait(0)
				local cX, cY = getCursorPos()
				setting.position_stat.x = cX
				setting.position_stat.y = cY
				if isKeyDown(0x01) then
					while isKeyDown(0x01) do wait(0) end
					change_pos_onstat = false
				end
			end
		else
			change_pos_onstat = false
		end
		save()
		sampSetCursorMode(0)
		windows.main[0] = true
		imgui.ShowCursor = true
		change_pos_onstat = false
	end)
end

function swapping(array, index, shift)
	if not array or not index or index < 1 or index > #array then
		print('Некорректные входные данные function swapping()')
		return
	end
	if shift == 0 then
		return
	end
	
	local newIndex = (index + shift - 1) % #array + 1
	local temp = array[index]
	table.remove(array, index)
	table.insert(array, newIndex, temp)
end

function bug_fix_input()
	if fix_bug_input_bool then
		for i = 0, 511 do
			imgui.GetIO().KeysDown[i] = false
		end
		for i = 0, 4 do
			imgui.GetIO().MouseDown[i] = false
		end
		imgui.GetIO().KeyCtrl = false
		imgui.GetIO().KeyShift = false
		imgui.GetIO().KeyAlt = false
		imgui.GetIO().KeySuper = false
		
		fix_bug_input_bool = false
	end
end

function start_sob_cmd(rp_sob_z)
	local rp_sob = {}
	for i = 1, #rp_sob_z do
		table.insert(rp_sob, rp_sob_z[i])
	end
	if thread:status() ~= 'dead' then
		if not setting.cef_notif then
			sampAddChatMessage('[SH] {FFFFFF}У Вас уже запущена отыгровка! Используйте {ED95A8}' .. setting.act_key[2] .. '{FFFFFF}, чтобы остановить её.', 0xFF5345)
		else
			cefnotig('{FF5345}[SH] {FFFFFF}У Вас уже запущена отыгровка! Используйте {ED95A8}' .. setting.act_key[2] .. '{FFFFFF}, чтобы остановить её.', 3000)
		end
		return
	end
	
	if #rp_sob ~= 0 then
		thread = lua_thread.create(function()
			for i = 1, #rp_sob do
				if rp_sob[i]:find('%{min_level_sob%}') then
					rp_sob[i] = rp_sob[i]:gsub('%{min_level_sob%}', setting.sob.min_exp)
				end
				if rp_sob[i]:find('%{min_law_sob%}') then
					rp_sob[i] = rp_sob[i]:gsub('%{min_law_sob%}', setting.sob.min_law)
				end
				if rp_sob[i]:find('%{id_sob%}') then
					rp_sob[i] = rp_sob[i]:gsub('%{id_sob%}', sob_info.id)
				end
				if rp_sob[i]:find('%{myid%}') then
					rp_sob[i] = rp_sob[i]:gsub('%{myid%}', my.id)
				end
				if rp_sob[i]:find('%{mynickrus%}') then
					rp_sob[i] = rp_sob[i]:gsub('%{mynickrus%}', setting.name_rus)
				end
				if rp_sob[i]:find('%{waitwbook%}') then
					if wait_book[2] then
						local dec_key = {}
						for s = 1, #setting.enter_key[1] do
							table.insert(dec_key, dec_to_key(setting.enter_key[1][s]))
						end
						wait(400)
						windows.action[0] = true
						dialog_act.status = true
						dialog_act.enter = true
						if not setting.cef_notif then
							sampAddChatMessage('[SH] {FFFFFF}Нажмите на {23E64A}' .. setting.enter_key[2] .. '{FFFFFF} для продолжения или {FF8FA2}' .. setting.act_key[2] .. '{FFFFFF}, чтобы остановить отыгровку.', 0xFF5345)
						else
							cefnotig('{FF5345}[SH] {FFFFFF}Нажмите на {23E64A}' .. setting.enter_key[2] .. '{FFFFFF} для продолжения или {FF8FA2}' .. setting.act_key[2] .. '{FFFFFF}, чтобы остановить отыгровку.', 4000)
						end
						addOneOffSound(0, 0, 0, 1058)
						while true do wait(0)
							if not sampIsChatInputActive() and not sampIsDialogActive() then
								local bool_return = 0
								for key = 1, #dec_key do
									if isKeyDown(dec_key[key]) then
										bool_return = bool_return + 1
									end
								end
								if bool_return == #dec_key then
									dialog_act.status = false
									dialog_act.enter = false
									break
								end
							end
						end
					end
				else
					sampSendChat(u8:decode(rp_sob[i]))
					wait(2200)
				end
			end
		end)
	end
end

function on_hot_key(id_pr_key)
    if setting.blockl then
        if not setting.cef_notif then
            sampAddChatMessage('[SH]{FFFFFF} Доступ к StateHelper был заблокирован разработчиком.', 0xFF5345)
        else
            cefnotig("{FF5345}[SH]{FFFFFF} Доступ к StateHelper был заблокирован разработчиком.", 3000)
        end
        return
    end
    local pressed_key = tostring(table.concat(id_pr_key, ' '))
    
    if not isGamePaused() and not isPauseMenuActive() and not sampIsDialogActive() and not sampIsChatInputActive() then
        if pressed_key == tostring(table.concat(setting.fast.key, ' ')) and setting.fast.func then
			if targ_id ~= -1 and targ_id ~= nil and sampIsPlayerConnected(targ_id) then
				openSmartFastMenu(targ_id)
			else
				openSmartFastMenu()
			end
			return
		end
        
        if pressed_key == tostring(table.concat(setting.win_key[2], ' ')) and not edit_key then
            open_main()
        end
        
        
        if pressed_key == tostring(table.concat(setting.act_key[1], ' ')) and not edit_key and thread:status() ~= 'dead'
        and not sampIsChatInputActive() and not sampIsDialogActive() and not isGamePaused() then
            thread:terminate()
            dialog_act.status = false
        end
        
        
        if #cmd[1] ~= 0 then
            for j = 1, #cmd[1] do
                if #cmd[1][j].key[2] ~= 0 then
                    if pressed_key == tostring(table.concat(cmd[1][j].key[2], ' ')) and not edit_key then
                        cmd_start('', tostring(cmd[1][j].UID) .. cmd[1][j].cmd)
                    end
                end
            end
        end
        
        
        if #setting.shp ~= 0 then
            for j = 1, #setting.shp do
                if #setting.shp[j].key[2] ~= 0 then
                    if pressed_key == tostring(table.concat(setting.shp[j].key[2], ' ')) and not edit_key then
                        cmd_shpora_open('', tostring(setting.shp[j].UID) .. setting.shp[j].cmd)
                    end
                end
            end
        end
        
        
        if pressed_key == tostring(table.concat(setting.police_settings.siren_key[2], ' ')) and setting.police_settings.siren and not edit_key and not windows.main[0] and not windows.smart_su[0] and anti_spam_gun[3] == 0 then
            if isCharInAnyCar(PLAYER_PED) then
                local vehicle = getCarCharIsUsing(PLAYER_PED)
                local siren_is_currently_on = isCarSirenOn(vehicle)
                switchCarSiren(vehicle, not siren_is_currently_on)
                if not siren_is_currently_on then
                    if setting.police_settings.siren_on_rp and setting.police_settings.siren_on_rp ~= '' and thread:status() == 'dead' then
                        sampSendChat(u8:decode(sex_decode(setting.police_settings.siren_on_rp)))
                    end
                else
                    if setting.police_settings.siren_off_rp and setting.police_settings.siren_off_rp ~= '' and thread:status() == 'dead' then
                        sampSendChat(u8:decode(sex_decode(setting.police_settings.siren_off_rp)))
                    end
                end
                anti_spam_gun[3] = 2
            end
        end
        
        
        local tab_open = {'cmd', 'shpora', 'dep', 'sob', 'reminder', 'stat', 'music', 'rp_zona', 'actions'}
        local tab_name_open = {u8'Команды', u8'Шпаргалки', u8'Департамент', u8'Собеседование', u8'Напоминания', u8'Статистика онлайна', u8'Музыка', u8'РП зона', u8'Действия'}
        for j = 1, #setting.key_tabs do
            if #setting.key_tabs[j][2] ~= 0 then
                if pressed_key == tostring(table.concat(setting.key_tabs[j][2], ' ')) and not edit_key then
                    tab = tab_open[j]
                    name_tab = tab_name_open[j]
                    if not windows.main[0] then
                        if setting.anim_win then
                            anim_func = true
                            windows.main[0] = true
                        else
                            windows.main[0] = true
                        end
                    end
                end
            end
        end
    end
end

function match_interpolation(initial, highest_return, current_match, max_return) --> Математическая интерполяция
	local ratio = current_match / highest_return
	local result = max_return - (ratio * (max_return - 1))
	
	return result
end

function urlencode(str)
   if (str) then
	  str = string.gsub (str, '\n', '\r\n')
	  str = string.gsub (str, '([^%w ])',
		 function (c) return string.format ('%%%02X', string.byte(c)) end)
	  str = string.gsub (str, ' ', '+')
   end
   
   return str
end

convert_color = function(argb)
	local col = imgui.ColorConvertU32ToFloat4(argb)
	
	return imgui.new.float[4](col.z, col.y, col.x, col.w)
end

function explode_U32(u32)
	local a = bit.band(bit.rshift(u32, 24), 0xFF)
	local r = bit.band(bit.rshift(u32, 16), 0xFF)
	local g = bit.band(bit.rshift(u32, 8), 0xFF)
	local b = bit.band(u32, 0xFF)
	
	return a, r, g, b
end

function imgui.ColorConvertFloat4ToARGB(float4)
	local abgr = imgui.ColorConvertFloat4ToU32(float4)
	local a, b, g, r = explode_U32(abgr)
	
	return join_argb(a, r, g, b)
end

function join_argb(a, r, g, b)
	local argb = b
	argb = bit.bor(argb, bit.lshift(g, 8))
	argb = bit.bor(argb, bit.lshift(r, 16))
	argb = bit.bor(argb, bit.lshift(a, 24))
	
	return argb
end

function changeColorAlpha(argb, alpha)
	local _, r, g, b = explode_U32(argb)
	
	return join_argb(alpha, r, g, b)
end

function ARGBtoStringRGB(abgr)
	local a, r, g, b = explode_U32(abgr)
	local argb = join_argb(a, r, g, b)
	local color = ('%x'):format(bit.band(argb, 0xFFFFFF))
	
	return ('{%s%s}'):format(('0'):rep(6 - #color), color)
end

anb = {
	settings = 7,
	cmd = 7,
	shpora = 7,
	dep = 7,
	sob = 7,
	reminder = 7,
	stat = 7,
	music = 7,
	rp_zona = 7,
	actions = 7,
	help = 7
}
function element_order(order)
	local all_size_x = 0
	local calc_el_x = {
		settings = 17,
		cmd = 19,
		shpora = 15,
		dep = 20,
		sob = 21,
		reminder = 15,
		stat = 15,
		music = 17,
		rp_zona = 21,
		actions = 17,
		help = 17
	}
	local name_tabs = {
		settings = u8'Главное',
		cmd = u8'Команды',
		shpora = u8'Шпаргалки',
		dep = u8'Департамент',
		sob = u8'Собеседование',
		reminder = u8'Напоминания',
		stat = u8'Статистика онлайна',
		music = u8'Музыка',
		rp_zona = u8'РП зона',
		actions = u8'Действия',
		help = u8'Поддержка'
	}
	for i = 1, #order do
		all_size_x = all_size_x + calc_el_x[order[i]]
	end
	local dist_el = (840 - all_size_x) / (#order + 1)
	local pos_el = 4
	local name_fa
	for i = 1, #order do
		if order[i] == 'settings' then
			name_fa = fa.GEAR
		elseif order[i] == 'cmd' then
			name_fa = fa.HAMMER
		elseif order[i] == 'shpora' then
			name_fa = fa.BOOK
		elseif order[i] == 'dep' then
			name_fa = fa.SIGNAL
		elseif order[i] == 'sob' then
			name_fa = fa.USER_PLUS
		elseif order[i] == 'reminder' then
			name_fa = fa.BELL
		elseif order[i] == 'stat' then
			name_fa = fa.CHART_SIMPLE
		elseif order[i] == 'music' then
			name_fa = fa.MUSIC
		elseif order[i] == 'rp_zona' then
			name_fa = fa.OBJECT_UNGROUP
		elseif order[i] == 'actions' then
			name_fa = fa.CUBE
		elseif order[i] == 'help' then
			name_fa = fa.BULLHORN
		end
		
		pos_el = pos_el + dist_el
		if i ~= 1 then
			pos_el = pos_el + calc_el_x[order[i]]
		end
		
		local scroll_cursor_pos = gui.GetCursorScroll()
		local sdvig_pos_ord = 0
		if edit_order_tabs then
			local tab_element_bool = false
			imgui.SetCursorPos(imgui.ImVec2(pos_el - 6, 414))
			if imgui.InvisibleButton(u8'##Переместить элемент ' .. i, imgui.ImVec2(29, 25)) then end
			
			if imgui.IsItemClicked() then
				sc_cursor_pos = scroll_cursor_pos
				sc_cr_p_element2[1] = 0
				sc_cr_p_element2[2] = i
				sc_cr_p_element2[3] = i
				sc_cr_p_element2[4] = i
				sc_cr_p_element2[5] = pos_el
			end
			if imgui.IsItemActive() then
				tab_element_bool = true
				bool_item_active2 = true
				sc_cr_pos = {x = sc_cursor_pos.x - scroll_cursor_pos.x, y = sc_cursor_pos.y - scroll_cursor_pos.y}
				sdvig_pos_ord = sc_cr_pos.x
			elseif sc_cr_p_element2[2] == i and bool_item_active2 then
				bool_item_active2 = false
				swapping(setting.tab, i, sc_cr_p_element2[3] - i)
				break
			end
		end
		
		if bool_item_active2 and sc_cr_p_element2[2] ~= i then
			if i > sc_cr_p_element2[2] then
				if (sc_cr_p_element2[5] - sc_cr_pos.x) > pos_el - 6 then
					sdvig_pos_ord = dist_el + calc_el_x[order[i]]
					if (sc_cr_p_element2[5] - sc_cr_pos.x) < pos_el + 58 then
						sc_cr_p_element2[3] = i
					end
				end
			elseif i < sc_cr_p_element2[2] then
				if (sc_cr_p_element2[5] - sc_cr_pos.x) < pos_el + 6 then
					sdvig_pos_ord = -(dist_el + calc_el_x[order[i]])
					if (sc_cr_p_element2[5] - sc_cr_pos.x) > pos_el - 58 then
						sc_cr_p_element2[3] = i
					end
				end
			end
		elseif i == sc_cr_p_element2[2] and bool_item_active2 and (sc_cr_p_element2[5] - sc_cr_pos.x) < pos_el + 58 and (sc_cr_p_element2[5] - sc_cr_pos.x) > pos_el - 58 then
			sc_cr_p_element2[3] = i
		end

		imgui.SetCursorPos(imgui.ImVec2(pos_el - 4 - sdvig_pos_ord, 410))
		imgui.BeginChild(u8'Вкладка'..i, imgui.ImVec2(32, 34), false, imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse + (edit_order_tabs and imgui.WindowFlags.NoMouseInputs or 0))
		imgui.SetCursorPos(imgui.ImVec2(0, 0))
		if imgui.InvisibleButton(u8'##Нажатие кнопки вкладки' .. i, imgui.ImVec2(30, 32)) then
			if order[i] ~= tab and not edit_order_tabs then
				tab = order[i]
				anb[order[i]] = 8
				name_tab = name_tabs[order[i]]
			end
		end
		imgui.PushFont(fa_font[4])
		if setting.cl == 'White' then
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.30, 0.30, 0.30, 1.00))
		else
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.70, 0.70, 0.70, 1.00))
		end
		if tab == order[i] then
			imgui.PushStyleColor(imgui.Col.Text, cl.def)
		end
		imgui.SetCursorPos(imgui.ImVec2(4, anb[order[i]] - 40))
		imgui.Text(name_fa)
		if tab == order[i] then
			imgui.PopStyleColor(1)
		end
		if tab == order[i] and anb[order[i]] == 7 and not edit_order_tabs then
			imgui.PushStyleColor(imgui.Col.Text, cl.def)
		end
		
		imgui.SetCursorPos(imgui.ImVec2(4, anb[order[i]]))
		imgui.Text(name_fa)
		if tab == order[i] and anb[order[i]] == 7 and not edit_order_tabs then
			imgui.PopStyleColor(1)
		end
		imgui.PopStyleColor(1)
		imgui.PopFont()
		
		if anb[order[i]] >= 8 and anb[order[i]] <= 47 then
			anb[order[i]] = anb[order[i]] + (anim * 120)
		else
			anb[order[i]] = 7
		end
		imgui.EndChild()
	end
end

setmetatable(imgui.Scroller, {__call = function(self, id, step, duration, HoveredFlags)
	if not HoveredFlags then
		HoveredFlags = imgui.HoveredFlags.AllowWhenBlockedByActiveItem 
	end
	if (table_move ~= '' or table_move_cmd ~= '') and not hovered_bool_not_child then
		if id == u8'Суть вкладки главное' or id == u8'Папки команд' or id == u8'Шпаргалки' or id == u8'Собеседование' 
		or id == u8'Напоминания' or id == u8'Статистика онлайна' or id == u8'Музыка' or id == u8'Лист найденных треков'
		or id == u8'Лист добавленных треков' or id == u8'РП зона' or id == u8'Действия' or id == u8'Поддержка'
		or id == u8'Редактор отыгровок оружия' or id == u8'Информация об обновлении' or id == u8'Лицензионное соглашение' then 
			HoveredFlags = HoveredFlags + imgui.HoveredFlags.RootAndChildWindows
		end
	end
	if not imgui.Scroller.id_bool_scroll[id] then
		imgui.Scroller.id_bool_scroll[id] = {}
	end
	
	local current_position = imgui.GetScrollY()
	if (imgui.IsWindowHovered(HoveredFlags) and imgui.IsMouseDown(0)) then
		imgui.Scroller.id_bool_scroll[id].start_clock = nil
	end
	
	if imgui.Scroller.id_bool_scroll[id].start_clock then
		if (os.clock() - imgui.Scroller.id_bool_scroll[id].start_clock) * 1000 <= duration then		
			local progress = (os.clock() - imgui.Scroller.id_bool_scroll[id].start_clock) * 1000 / duration			
			local fading_progress = progress * (2 - progress)
			local distance = (imgui.Scroller.id_bool_scroll[id].target_position - imgui.Scroller.id_bool_scroll[id].start_position)
			local new_position = imgui.Scroller.id_bool_scroll[id].start_position + distance * fading_progress
			
			if new_position < 0 then
				new_position = 0
				imgui.Scroller.id_bool_scroll[id].start_clock = nil
				
			elseif new_position > imgui.GetScrollMaxY() then
				new_position = imgui.GetScrollMaxY()
				imgui.Scroller.id_bool_scroll[id].start_clock = nil
			end
			imgui.SetScrollY(math.floor(new_position))
		else
			imgui.Scroller.id_bool_scroll[id].start_clock = nil
			imgui.SetScrollY(imgui.Scroller.id_bool_scroll[id].target_position)
		end
	end
	
	local wheel_delta = imgui.GetIO().MouseWheel
	if wheel_delta ~= 0 and imgui.IsWindowHovered(HoveredFlags) then
		local offset = -wheel_delta * step		
		if not imgui.Scroller.id_bool_scroll[id].start_clock then
			imgui.Scroller.id_bool_scroll[id].start_clock = os.clock()
			imgui.Scroller.id_bool_scroll[id].start_position = current_position
			imgui.Scroller.id_bool_scroll[id].target_position = current_position + offset
		else
			imgui.Scroller.id_bool_scroll[id].start_clock = os.clock()
			imgui.Scroller.id_bool_scroll[id].start_position = current_position
			if imgui.Scroller.id_bool_scroll[id].start_position < imgui.Scroller.id_bool_scroll[id].target_position and offset > 0 then
				imgui.Scroller.id_bool_scroll[id].target_position = imgui.Scroller.id_bool_scroll[id].target_position + offset
			elseif imgui.Scroller.id_bool_scroll[id].start_position > imgui.Scroller.id_bool_scroll[id].target_position and offset < 0 then
				imgui.Scroller.id_bool_scroll[id].target_position = imgui.Scroller.id_bool_scroll[id].target_position + offset
			else
				imgui.Scroller.id_bool_scroll[id].target_position = current_position + offset
			end
		end
	end
end})

function sex(text_man, text_woman)
	if setting.sex == 1 then
		return text_man
	else
		return text_woman
	end
end

function deepcopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[deepcopy(orig_key)] = deepcopy(orig_value)
		end
		setmetatable(copy, deepcopy(getmetatable(orig)))
	else
		copy = orig
	end
	
	return copy
end

function auto_report_fire(text_send, bool_func_enter)
	if thread:status() ~= 'dead' then
		if not setting.cef_notif then
			sampAddChatMessage('[SH] [Доклад] {FFFFFF}У Вас уже запущена отыгровка! Используйте {ED95A8}' .. setting.act_key[2] .. '{FFFFFF}, чтобы остановить её.', 0xFF5345)
		else
			cefnotig('{FF5345}[SH] [Доклад] {FFFFFF}У Вас уже запущена отыгровка! Используйте {ED95A8}' .. setting.act_key[2] .. '{FFFFFF}, чтобы остановить её.', 4000)
		end
		return
	end
	
	thread = lua_thread.create(function()
		if bool_func_enter then
			local dec_key = {}
			for s = 1, #setting.enter_key[1] do
				table.insert(dec_key, dec_to_key(setting.enter_key[1][s]))
			end
			wait(300)
			if not setting.cef_notif then
				sampAddChatMessage('[SH] {FFFFFF}Нажмите на {23E64A}' .. setting.enter_key[2] .. '{FFFFFF} для отправки доклада или {FF8FA2}' .. setting.act_key[2] .. '{FFFFFF}, чтобы отменить отправку.', 0xFF5345)
			else
				cefnotig('{FF5345}[SH] {FFFFFF}Нажмите на {23E64A}' .. setting.enter_key[2] .. '{FFFFFF} для отправки доклада или {FF8FA2}' .. setting.act_key[2] .. '{FFFFFF}, чтобы отменить отправку.', 4000)
			end
			addOneOffSound(0, 0, 0, 1058)
			while true do wait(0)
				if not sampIsChatInputActive() and not sampIsDialogActive() then
					local bool_return = 0
					for key = 1, #dec_key do
						if isKeyDown(dec_key[key]) then
							bool_return = bool_return + 1
						end
					end
					if bool_return == #dec_key then
						dialog_act.status = false
						dialog_act.enter = false
						break
					end
				end
			end
		else
			wait(700)
		end
		
		local function tags_sub(text_sub)
			if text_sub:find('%{mynickrus%}') then
				text_sub = text_sub:gsub('%{mynickrus%}', setting.name_rus)
			end
			if text_sub:find('%{myid%}') then
				text_sub = text_sub:gsub('%{myid%}', tostring(my.id))
			end
			if text_sub:find('%{mynick%}') then
				text_sub = text_sub:gsub('%{mynick%}', my.nick)
			end
			if text_sub:find('%{level%}') then
				text_sub = text_sub:gsub('%{level%}', tostring(level_fire))
			end
			if text_sub:find('%{rank%}') then
				text_sub = text_sub:gsub('%{rank%}', setting.job_title)
			end
			if text_sub:find('%{myrank%}') then
				text_sub = text_sub:gsub('%{myrank%}', setting.job_title)
			end
			if text_sub:find('{sex%[(.-)%]%[(.-)%]}') then
				local gender_male, gender_fem = text_sub:match('{sex%[(.-)%]%[(.-)%]}')
				local pattern_gender = ''
				if setting.sex == 1 then
					pattern_gender = gender_male
				else
					pattern_gender = gender_fem
				end
				
				text_sub = text_sub:gsub('{sex%[(.-)%]%[(.-)%]}', pattern_gender)
			end
			
			return text_sub
		end
		
		local text_fire = u8:decode(text_send)
		sampSendChat(tags_sub(text_fire))
	end)
end

function cmd_shpora_open(argument, cmd_name)
	for i = 1, #setting.shp do
		if tostring(setting.shp[i].UID) .. setting.shp[i].cmd == cmd_name then
			windows.shpora[0] = not windows.shpora[0]
			text_shpora = setting.shp[i].text
		end
	end
end

function cmd_start(argument, cmd_name) --> Запуск команды
	if setting.blockl then
		if not setting.cef_notif then
			sampAddChatMessage('[SH]{FFFFFF} Доступ к StateHelper был заблокирован разработчиком.', 0xFF5345)
		end
		return
	end
	if thread:status() ~= 'dead' then --> Если какая-то команда уже запущена, то эту команду не запускаем
		if not setting.cef_notif then
			sampAddChatMessage('[SH] {FFFFFF}У Вас уже запущена отыгровка! Используйте {ED95A8}' .. setting.act_key[2] .. '{FFFFFF}, чтобы остановить её.', 0xFF5345)
		else
			cefnotig('{FF5345}[SH] {FFFFFF}У Вас уже запущена отыгровка! Используйте {ED95A8}' .. setting.act_key[2] .. '{FFFFFF}, чтобы остановить её.', 3000)
		end
		return
	end
	
	local CMD --> Вся команда
	local ARG = {} --> Для аргументов
	for c = 1, #cmd[1] do --> Ищем какую команду нам запустить
		if tostring(cmd[1][c].UID) .. cmd[1][c].cmd == cmd_name then
			CMD = cmd[1][c]
		end
	end
	if CMD == nil then --> Если команда почему-то не найдена, то информируем пользователя и останавливаем проигровку
		if not setting.cef_notif then
			sampAddChatMessage('[SH] {FFFFFF}ОШИБКА! Команда не найдена... Видимо, файл с командами уничтожен.', 0xFF5345)
		else
			cefnotig("{FF5345}[SH] {FFFFFF}ОШИБКА! Команда не найдена... Видимо, файл с командами уничтожен.", 3000)
		end
		return
	end
	
	if #CMD.arg ~= 0 then --> Если команда с аргументами, то делаем проверку, вписываем аргументы и так далее
		local function invalid_arguments() --> Для случая, если аргументы не ожидаемые
			local tbl_ar = {}
			for ar = 1, #CMD.arg do
				table.insert(tbl_ar, '[' .. u8:decode(CMD.arg[ar].desc) .. ']')
			end
			if not setting.cef_notif then
				sampAddChatMessage('[SH] {FFFFFF}Используйте {a8a8a8}/' .. CMD.cmd .. ' ' .. table.concat(tbl_ar, ' '), 0xFF5345)
			else
				cefnotig('{FF5345}[SH] {FFFFFF}Используйте {a8a8a8}/' .. CMD.cmd .. ' ' .. table.concat(tbl_ar, ' '), 5000)
			end
		end
		
		if argument:gsub('%s+', '') ~= '' then
			for word in argument:gmatch('%S+') do --> Выписываем все полученные аргументы в переменную
				table.insert(ARG, word)
			end
			
			if #ARG > #CMD.arg then --> Если аргументов дали больше, чем их должно быть, то всё лишнее вписываем в последний аргумент
				local bool_args = table.concat(ARG, ' ', #CMD.arg, #ARG)
				ARG[#CMD.arg] = bool_args
				for c = #ARG, #CMD.arg + 1, -1 do
					table.remove(ARG, c)
				end
			end
		end
		
		for num, type_arg in ipairs(CMD.arg) do --> Если аргументы дали не те, какие должны быть, то сообщаем как надо и говорим до свидания
			if type_arg.type == 1 then
				if ARG[num] ~= nil then
					if not ARG[num]:find('(.+)') then invalid_arguments() return end
				else
					invalid_arguments() return
				end
			elseif type_arg.type == 2 then
				if ARG[num] ~= nil then
					if not ARG[num]:find('^(%d+)$') then invalid_arguments() return end
				else
					invalid_arguments() return
				end
			end
		end
	end
	local function escape_pattern(text_esc)
		return text_esc:gsub('([%^%$%(%)%%%.%[%]%*%+%-%?])', '%%%1')
	end

	local model = getNearestVehicleModel()
	local speed = getNearestVehicleSpeed()
	local square = getCurrentMapSquare()

	local function tag_converter(text) --> Преобразовать теги в тексте, если они имеются
		local function escape_pattern(text_esc)
			return text_esc:gsub('([%^%$%(%)%%%.%[%]%*%+%-%?])', '%%%1')
		end
		
		text = u8:decode(text)
		if text:find('%b{}') then
			local week = {'Воскресенье', 'Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота'}
			local month = {'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'}
			local extracted_str = {}
			local stop_send_chat = false
			local money_mode = 'display'
			local trimmed_text = text:gsub('^%s+', '')
			if trimmed_text:sub(1, 1) == '/' then
				money_mode = 'raw'
			end

			local function resolve_price(value)
				if type(sh_money_render) == 'function' then
					return sh_money_render(value, money_mode)
				end
				if money_mode == 'raw' then
					return tostring(value or ''):gsub('%D', '')
				end
				return tostring(value or '')
			end			
			for tag in text:gmatch('%b{}') do
				table.insert(extracted_str, {tag, tag})
			end
			
			for i = 1, #extracted_str do
				local val = extracted_str[i][1]
				if val == '{mynick}' then
					extracted_str[i][2] = my.nick:gsub('_', ' ')
				elseif val == '{mynickrus}' then
					extracted_str[i][2] = u8:decode(setting.name_rus)
				elseif val == '{myid}' then
					extracted_str[i][2] = tostring(my.id)
				elseif val == '{myrank}' then
					extracted_str[i][2] = u8:decode(setting.job_title)
				elseif val == '{time}' then
					extracted_str[i][2] = tostring(os.date('%X'))
				elseif val == '{day}' then
					extracted_str[i][2] = tostring(os.date('%d'))
				elseif val == '{week}' then
					extracted_str[i][2] = week[tonumber(os.date('%w')) + 1]
				elseif val == '{month}' then
					extracted_str[i][2] = month[tonumber(os.date('%m'))]
				elseif val:find('{getplnick%[(%d+)%]}') then
					local num_id = string.match(val, '{getplnick%[(.-)%]}')
					if sampIsPlayerConnected(tonumber(num_id)) then
						extracted_str[i][2] = (sampGetPlayerNickname(tonumber(num_id))):gsub('_', ' ')
					else
						extracted_str[i][2] = 'Уважаемый'
						if not setting.cef_notif then
							sampAddChatMessage('[SH] {FFFFFF}Параметр ' .. val .. ' не обнаружил игрока. Игрок не в сети, либо это Вы.', 0xFF5345)
						else
							cefnotig('{FF5345}[SH] {FFFFFF}Параметр ' .. val .. ' не обнаружил игрока. Игрок не в сети, либо это Вы.', 3000)
						end
					end
				elseif val:find('{getlevel%[(%d+)%]}') then
					local num_id = tonumber(val:match('{getlevel%[(%d+)%]}'))
					if sampIsPlayerConnected(num_id) then
						local score = sampGetPlayerScore(num_id)
						if score == 0 then wait(100) score = sampGetPlayerScore(num_id) end
						extracted_str[i][2] = score
					else
						extracted_str[i][2] = '0'
					end
				elseif val == '{med7}' then
					extracted_str[i][2] = resolve_price(setting.price[1].mc[1])
				elseif val == '{med14}' then
					extracted_str[i][2] = resolve_price(setting.price[1].mc[2])
				elseif val == '{med30}' then
					extracted_str[i][2] = resolve_price(setting.price[1].mc[3])
				elseif val == '{med60}' then
					extracted_str[i][2] = resolve_price(setting.price[1].mc[4])
				elseif val == '{medup7}' then
					extracted_str[i][2] = resolve_price(setting.price[1].mcupd[1])
				elseif val == '{medup14}' then
					extracted_str[i][2] = resolve_price(setting.price[1].mcupd[2])
				elseif val == '{medup30}' then
					extracted_str[i][2] = resolve_price(setting.price[1].mcupd[3])
				elseif val == '{medup60}' then
					extracted_str[i][2] = resolve_price(setting.price[1].mcupd[4])
				elseif val == '{pricenarko}' then
					extracted_str[i][2] = resolve_price(setting.price[1].narko)
				elseif val == '{pricerecept}' then
					extracted_str[i][2] = resolve_price(setting.price[1].rec)
				elseif val == '{priceant}' then
					extracted_str[i][2] = resolve_price(setting.price[1].ant)
				elseif val == '{pricelec}' then
					extracted_str[i][2] = resolve_price(setting.price[1].lec)
				elseif val == '{priceosm}' then
					extracted_str[i][2] = resolve_price(setting.price[1].osm)
				elseif val == '{priceguard}' then
					extracted_str[i][2] = resolve_price(setting.price[1].tatu)
				elseif val =='{priceauto1}' then
					extracted_str[i][2] = resolve_price(setting.price[2].auto[1])
				elseif val == '{priceauto2}' then
					extracted_str[i][2] = resolve_price(setting.price[2].auto[2])
				elseif val == '{priceauto3}' then
					extracted_str[i][2] = resolve_price(setting.price[2].auto[3])
				elseif val == '{pricemoto1}' then
					extracted_str[i][2] = resolve_price(setting.price[2].moto[1])
				elseif val == '{pricemoto2}' then
					extracted_str[i][2] = resolve_price(setting.price[2].moto[2])
				elseif val == '{pricemoto3}' then
					extracted_str[i][2] = resolve_price(setting.price[2].moto[3])
				elseif val == '{pricefly}' then
					extracted_str[i][2] = resolve_price(setting.price[2].fly[1])
				elseif val == '{pricefish1}' then
					extracted_str[i][2] = resolve_price(setting.price[2].fish[1])
				elseif val == '{pricefish2}' then
					extracted_str[i][2] = resolve_price(setting.price[2].fish[2])
				elseif val == '{pricefish3}' then
					extracted_str[i][2] = resolve_price(setting.price[2].fish[3])
				elseif val == '{priceswim1}' then
					extracted_str[i][2] = resolve_price(setting.price[2].swim[1])
				elseif val == '{priceswim2}' then
					extracted_str[i][2] = resolve_price(setting.price[2].swim[2])
				elseif val == '{priceswim3}' then
					extracted_str[i][2] = resolve_price(setting.price[2].swim[3])
				elseif val == '{pricegun1}' then
					extracted_str[i][2] = resolve_price(setting.price[2].gun[1])
				elseif val == '{pricegun2}' then
					extracted_str[i][2] = resolve_price(setting.price[2].gun[2])
				elseif val == '{pricegun3}' then
					extracted_str[i][2] = resolve_price(setting.price[2].gun[3])
				elseif val == '{pricehunt1}' then
					extracted_str[i][2] = resolve_price(setting.price[2].hunt[1])
				elseif val == '{pricehunt2}' then
					extracted_str[i][2] = resolve_price(setting.price[2].hunt[2])
				elseif val == '{pricehunt3}' then
					extracted_str[i][2] = resolve_price(setting.price[2].hunt[3])
				elseif val == '{priceexc1}' then
					extracted_str[i][2] = resolve_price(setting.price[2].exc[1])
				elseif val == '{priceexc2}' then
					extracted_str[i][2] = resolve_price(setting.price[2].exc[2])
				elseif val == '{priceexc3}' then
					extracted_str[i][2] = resolve_price(setting.price[2].exc[3])
				elseif val == '{pricetaxi1}' then
					extracted_str[i][2] = resolve_price(setting.price[2].taxi[1])
				elseif val == '{pricetaxi2}' then
					extracted_str[i][2] = resolve_price(setting.price[2].taxi[2])
				elseif val == '{pricetaxi3}' then
					extracted_str[i][2] = resolve_price(setting.price[2].taxi[3])
				elseif val == '{pricemeh1}' then
					extracted_str[i][2] = resolve_price(setting.price[2].meh[1])
				elseif val == '{pricemeh2}' then
					extracted_str[i][2] = resolve_price(setting.price[2].meh[2])
				elseif val == '{pricemeh3}' then
					extracted_str[i][2] = resolve_price(setting.price[2].meh[3])
				elseif val == '{target}' then
					extracted_str[i][2] = targ_id or -1
				elseif val == '{prtsc}' then
				elseif val:find('{spcar}') then
					extracted_str[i][2] = ''
					lspawncar = true
					sampSendChat('/lmenu')
				elseif val:find('{PhoneApp%[(%d+)%]}') then
					extracted_str[i][2] = ''
					sampSendChat('/phone')
					local app_id = tonumber(string.match(val, '{PhoneApp%[(%d+)%]}'))
					sendCef('launchedApp|'.. app_id)
					sampSendChat('/phone')
				elseif val == '{city}' then
					local x, y, _ = getCharCoordinates(PLAYER_PED)
					extracted_str[i][2] = (x > 900 and y > 800 and 'Лас-Вентурас') or (x < -1300 and 'Сан-Фиерро') or (x > 0 and y < 0 and 'Лос-Сантос') or 'Вне города'
				elseif val == '{veh_model}' then
					extracted_str[i][2] = model
				elseif val == '{veh_speed}' then
					extracted_str[i][2] = speed
				elseif val == '{square}' then
					extracted_str[i][2] = square
				elseif val == '{pursuit_id}' then
					if poltarget then
						extracted_str[i][2] = poltarget
					else
						if not setting.cef_notif then
							sampAddChatMessage('[SH] {FFFFFF}Не удалось получить id человека с погони.', 0xFF5345)
						else
							cefnotig('{FF5345}[SH] {FFFFFF}Не удалось получить id человека с погони.', 3000)
						end
						extracted_str[i][2] = ''
					end
				elseif val:find('{unprison%[(%d+)%]}') then
					unprison = true
					unprison_id = tonumber(val:match('{unprison%[(%d+)%]}'))
					extracted_str[i][2] = '/getjail ' .. unprison_id
				elseif val == '{nearplayer}' then
					local near_pl = getNearestID()
					if near_pl then
						extracted_str[i][2] = tostring(near_pl)
					else
						extracted_str[i][2] = '-1'
						if not setting.cef_notif then
							sampAddChatMessage('[SH] {FFFFFF}Параметр ' .. val .. ' не обнаружил игрока. Игроков рядом нет.', 0xFF5345)
						else
							cefnotig('{FF5345}[SH] {FFFFFF}Параметр ' .. val .. ' не обнаружил игрока. Игроков рядом нет.', 3000)
						end
					end
				elseif val:find('{random%[(%d+)%]%[(%d+)%]}') then
					local min_number, max_number = val:match('{random%[(%d+)%]%[(%d+)%]}')
					local random_number = math.random(tonumber(min_number), tonumber(max_number))
					extracted_str[i][2] = tostring(random_number)
				elseif val:find('{sex%[(.-)%]%[(.-)%]}') then
					local gender_male, gender_fem = val:match('{sex%[(.-)%]%[(.-)%]}')
					if setting.sex == 1 then
						extracted_str[i][2] = gender_male
					else
						extracted_str[i][2] = gender_fem
					end
				elseif val == nil then
					extracted_str[i][2] = ''
				else
					extracted_str[i][2] = val
				end
			end
			
			for t = 1, #extracted_str do
				local pattern = escape_pattern(extracted_str[t][1])
				if text:find(pattern) then
					text = text:gsub(pattern, extracted_str[t][2])
				end
			end

			if text:find('{prtsc}') then
				text = text:gsub('{prtsc}', '')
				print_scr()
			end
			
			if text:find('{dialoglic%[(%d+)%]%[(%d+)%]%[(%d+)%]}') then
				stop_send_chat = true
				num_id_dial, num_id_term, num_id_player = string.match(text, '{dialoglic%[(.-)%]%[(.-)%]%[(.-)%]}')
				if tonumber(num_id_dial) > -1 and tonumber(num_id_dial) < 10 then
					num_give_lic = tonumber(num_id_dial)
				else
					sampAddChatMessage('[SH] {FF5345}[КРИТИЧЕСКАЯ ОШИБКА] {FFFFFF}Параметр {dialoglic} имеет неверное значение.', 0xFF5345)
					return ''
				end
				if tonumber(num_id_term) >= 0 and tonumber(num_id_term) <= 3 then
					num_give_lic_term = tonumber(num_id_term)
				else
					sampAddChatMessage('[SH] {FF5345}[КРИТИЧЕСКАЯ ОШИБКА] {FFFFFF}Параметр {dialoglic} имеет неверное значение.', 0xFF5345)
					return ''
				end
			end
			if stop_send_chat then return u8'/givelicense ' .. num_id_player end
			
			if text:find('{dialoggov%[(%d+)%]%[(%d+)%]}') then
				stop_send_chat = true
				num_id_dial, num_id_player = string.match(text, '{dialoggov%[(.-)%]%[(.-)%]}')
				if tonumber(num_id_dial) > -1 and tonumber(num_id_dial) < 3 then
					num_give_gov = tonumber(num_id_dial)
				else
					sampAddChatMessage('[SH] {FF5345}[КРИТИЧЕСКАЯ ОШИБКА] {FFFFFF}Параметр {dialoggov} имеет неверное значение.', 0xFF5345)
					return ''
				end
			end
			if stop_send_chat then return u8'/givepass ' .. num_id_player end
		end
		
		return u8(text)
	end
	
	local function arg_and_var_and_tag_conv(text) --> Преобразовать аргументы, переменные и теги в тексте		
		if #CMD.var ~= 0 then
			for i_var = 1, #CMD.var do
				local var_format = '{' .. CMD.var[i_var].name .. '}'
				if text:find(var_format) then
					local text_conv = tag_converter(CMD.var[i_var].value)
					text = text:gsub(escape_pattern(var_format), text_conv)
				end
			end
		end
		if #CMD.arg ~= 0 then
			for i_arg = 1, #CMD.arg do
				local arg_format = '{' .. CMD.arg[i_arg].name .. '}'
				if text:find(arg_format) then
					text = text:gsub(escape_pattern(arg_format), u8(ARG[i_arg]))
				end
			end
		end
		text = tag_converter(text)
		
		return text
	end
	
	local delay = CMD.delay * 1000
	local dialogs = {}
	local if_active = 0
	local else_active = 0
	local dec_key = {}
	for s = 1, #setting.enter_key[1] do
		table.insert(dec_key, dec_to_key(setting.enter_key[1][s]))
	end
	thread = lua_thread.create(function() --> Функция отыгровки
		for i, v in ipairs(CMD.act) do
			if if_active == 0 and else_active == 0 then
				if v[1] == 'SEND' then
					if i ~= 1 then
						if CMD.act[i - 1][1] == 'SEND' or CMD.act[i - 1][1] == 'SEND_ME' then
							wait(delay)
						else
							wait(delay)
						end
					end
					if CMD.send_end_mes or i ~= #CMD.act then
						sampSendChat(u8:decode(arg_and_var_and_tag_conv(v[2])))
					else
						sampSetChatInputEnabled(true)
						sampSetChatInputText(u8:decode(arg_and_var_and_tag_conv(v[2])))
					end
				elseif v[1] == 'SEND_CMD' then
				if i ~= 1 then
					if CMD.act[i - 1][1] == 'SEND' or CMD.act[i - 1][1] == 'SEND_ME' or CMD.act[i - 1][1] == 'SEND_CMD' then
						wait(delay)
					else
						wait(delay)
					end
				end
				local cmd_to_send = u8:decode(arg_and_var_and_tag_conv(v[2]))
				table.insert(command_queue, cmd_to_send)
				if v[3] == true then
					return
				end
				elseif v[1] == 'OPEN_INPUT' then
					sampSetChatInputEnabled(true)
					sampSetChatInputText(u8:decode(arg_and_var_and_tag_conv(v[2])))
					wait(400)
					windows.action[0] = true
					dialog_act.status = true
					dialog_act.enter = true
					if not setting.cef_notif then
						sampAddChatMessage('[SH] {FFFFFF}Нажмите на {23E64A}' .. setting.enter_key[2] .. '{FFFFFF} для продолжения или {FF8FA2}' .. setting.act_key[2] .. '{FFFFFF}, чтобы остановить отыгровку.', 0xFF5345)
					else
						cefnotig('{FF5345}[SH] {FFFFFF}Нажмите на {23E64A}' .. setting.enter_key[2] .. '{FFFFFF} для продолжения или {FF8FA2}' .. setting.act_key[2] .. '{FFFFFF}, чтобы остановить отыгровку.', 3000)
					end
					addOneOffSound(0, 0, 0, 1058)
					while true do wait(0)
						if not sampIsChatInputActive() and not sampIsDialogActive() then
							local bool_return = 0
							for key = 1, #dec_key do
								if isKeyDown(dec_key[key]) then
									bool_return = bool_return + 1
								end
							end
							if bool_return == #dec_key then
								dialog_act.status = false
								dialog_act.enter = false
								break
							end
						end
					end
				elseif v[1] == 'WAIT_ENTER' then
					wait(400)
					windows.action[0] = true
					dialog_act.status = true
					dialog_act.enter = true
					if not setting.cef_notif then
						sampAddChatMessage('[SH] {FFFFFF}Нажмите на {23E64A}' .. setting.enter_key[2] .. '{FFFFFF} для продолжения или {FF8FA2}' .. setting.act_key[2] .. '{FFFFFF}, чтобы остановить отыгровку.', 0xFF5345)
					else
						cefnotig('{FF5345}[SH] {FFFFFF}Нажмите на {23E64A}' .. setting.enter_key[2] .. '{FFFFFF} для продолжения или {FF8FA2}' .. setting.act_key[2] .. '{FFFFFF}, чтобы остановить отыгровку.', 3500)
					end
					addOneOffSound(0, 0, 0, 1058)
					while true do wait(0)
						if not sampIsChatInputActive() and not sampIsDialogActive() then
							local bool_return = 0
							for key = 1, #dec_key do
								if isKeyDown(dec_key[key]) then
									bool_return = bool_return + 1
								end
							end
							if bool_return == #dec_key then
								dialog_act.status = false
								dialog_act.enter = false
								break
							end
						end
					end
				elseif v[1] == 'SEND_ME' then
					wait(400)
					sampAddChatMessage('[SH] {FFFFFF}' .. u8:decode(arg_and_var_and_tag_conv(v[2])), 0xFF5345)
				elseif v[1] == 'DELAY' then
					delay = v[2] * 1000
				elseif v[1] == 'NEW_VAR' then
					bool_cmd_var = false
					if #CMD.var ~= 0 then
						for var = 1, #CMD.var do
							if CMD.var[var].name == v[2] then
								CMD.var[var].value = v[3]
								bool_cmd_var = true
							end
						end
					end
					if not bool_cmd_var then
						table.insert(CMD.var, {name = v[2], value = v[3]})
					end
				elseif v[1] == 'DIALOG' then
					windows.action[0] = true
					dialog_act.status = true
					dialog_act.info = v[3]
					dialog_act.enter = false
					while true do wait(0)
						if not sampIsChatInputActive() and not sampIsDialogActive() then
							if #v[3] ~= 0 then
								local bool_VK = {VK_1, VK_2, VK_3, VK_4, VK_5, VK_6, VK_7, VK_8, VK_9, VK_0}
								local bool_NUMPAD = {VK_NUMPAD1, VK_NUMPAD2, VK_NUMPAD3, VK_NUMPAD4, VK_NUMPAD5, VK_NUMPAD6, VK_NUMPAD7, VK_NUMPAD8, VK_NUMPAD9, VK_NUMPAD10}
								local return_bool = false
								for d = 1, #v[3] do
									if isKeyJustPressed(bool_VK[d]) or isKeyJustPressed(bool_NUMPAD[d]) then
										table.insert(dialogs, {v[2], d})
										return_bool = true
										break
									end
								end
								if return_bool then
									dialog_act.status = false
									dialog_act.enter = false
									break 
								end
							end
						end
					end
				elseif v[1] == 'IF' then
					local bool_active = false
					
					if v[2] == 2 then
						if #dialogs ~= 0 then
							for dg = 1, #dialogs do
								if tostring(dialogs[dg][1]) == tostring(v[3][1]) and tostring(dialogs[dg][2]) == tostring(v[3][2]) then
									bool_active = true
								end
							end
						end
					elseif v[2] == 3 then
						if #CMD.arg ~= 0 then
							for ar = 1, #CMD.arg do
								local arg_1 = u8:decode(arg_and_var_and_tag_conv(tostring(ARG[ar])))
								local arg_2 = u8:decode(arg_and_var_and_tag_conv(tostring(v[3][2])))
								if tostring(CMD.arg[ar].name) == tostring(v[3][1]) then
									if v[5] == 1 and arg_1 == arg_2 then
										bool_active = true
									elseif v[5] == 6 and arg_1 ~= arg_2 then
										bool_active = true
									elseif v[5] > 1 then
										arg_1 = tonumber(arg_1)
										arg_2 = tonumber(arg_2)
										
										if arg_1 and arg_2 then
											if v[5] == 2 and arg_1 > arg_2 then
												bool_active = true
											elseif v[5] == 3 and arg_1 >= arg_2 then
												bool_active = true
											elseif v[5] == 4 and arg_1 < arg_2 then
												bool_active = true
											elseif v[5] == 5 and arg_1 <= arg_2 then
												bool_active = true
											end
										end
									end
								end
							end
						end
					elseif v[2] == 4 then
						if #CMD.var ~= 0 then
							for vr = 1, #CMD.var do
								local var_1 = u8:decode(arg_and_var_and_tag_conv(tostring(CMD.var[vr].value)))
								local var_2 = u8:decode(arg_and_var_and_tag_conv(tostring(v[3][2])))
								if tostring(CMD.var[vr].name) == tostring(v[3][1]) then
									if v[5] == 1 and var_1 == var_2 then
										bool_active = true
									elseif v[5] == 6 and var_1 ~= var_2 then
										bool_active = true
									elseif v[5] > 1 then
										var_1 = tonumber(var_1)
										var_2 = tonumber(var_2)
										if var_1 and var_2 then
											if v[5] == 2 and var_1 > var_2 then
												bool_active = true
											elseif v[5] == 3 and var_1 >= var_2 then
												bool_active = true
											elseif v[5] == 4 and var_1 < var_2 then
												bool_active = true
											elseif v[5] == 5 and var_1 <= var_2 then
												bool_active = true
											end
										end
									end
								end
							end
						end
					end
					
					if bool_active == false then
						if_active = 1
					end
				elseif v[1] == 'ELSE' then
					if_active = 1
				elseif v[1] == 'STOP' then
					return
				elseif v[1] == 'SEND_DIALOG' then
					if i ~= 1 then
						wait(delay)
					end
					if sampIsDialogActive() then
						local id, _, _, _, _, _ = sampGetCurrentDialogId()
						sampSendDialogResponse(id, 1, -1, u8:decode(arg_and_var_and_tag_conv(v[2])))
						mem.setint32(sampGetDialogInfoPtr()+40, bool and 1 or 0, true)
						sampToggleCursor(bool)
					else
						if not setting.cef_notif then
							sampAddChatMessage('[SH] {FFFFFF}Ошибка: Диалоговое окно не открыто.', 0xFF5345)
						else
							cefnotig('{FF5345}[SH] {FFFFFF}Ошибка: Диалоговое окно не открыто.', 3000)
						end
					end
				elseif v[1] == 'SELECT_DIALOG_ROW' then
					if i ~= 1 then
						wait(delay)
					end
					if sampIsDialogActive() then
						local id, _, _, _, _, _ = sampGetCurrentDialogId()
						local row = tonumber(arg_and_var_and_tag_conv(v[2]))
						if row then
							sampSendDialogResponse(id, 1, row -1, '')
							mem.setint32(sampGetDialogInfoPtr()+40, bool and 1 or 0, true)
							sampToggleCursor(bool)
						else
							if not setting.cef_notif then
								sampAddChatMessage('[SH] {FFFFFF}Ошибка: Неверный номер рядка для выбора в диалоге.', 0xFF5345)
							else
								cefnotig('{FF5345}[SH] {FFFFFF}Ошибка: Неверный номер рядка для выбора в диалоге.', 3000)
							end
						end
					else
						if not setting.cef_notif then
							sampAddChatMessage('[SH] {FFFFFF}Ошибка: Диалоговое окно не открыто.', 0xFF5345)
						else
							cefnotig('{FF5345}[SH] {FFFFFF}Ошибка: Диалоговое окно не открыто.', 3000)
						end
					end
				end
			else
				if v[1] == 'IF' then
					if_active = if_active + 1
				elseif v[1] == 'ELSE' then
					if if_active == 1 then 
						if_active = 0
					end
				elseif v[1] == 'END' then
					if if_active > 0 then
						if_active = if_active - 1
					end
				end
			end
		end
	end)
end

function getNearestID()
	local chars = getAllChars()
	local mx, my, mz = getCharCoordinates(PLAYER_PED)
	local nearId, dist = nil, 10000
	for i,v in ipairs(chars) do
		if doesCharExist(v) and v ~= PLAYER_PED then
			local vx, vy, vz = getCharCoordinates(v)
			local cDist = getDistanceBetweenCoords3d(mx, my, mz, vx, vy, vz)
			local r, id = sampGetPlayerIdByCharHandle(v)
			if r and cDist < dist then
				dist = cDist
				nearId = id
			end
		end
	end
	return nearId
end

function sex_decode(text_ret)
	local function escape_pattern(text_esc)
		return text_esc:gsub('([%^%$%(%)%%%.%[%]%*%+%-%?])', '%%%1')
	end
	text_ret = u8:decode(text_ret)
	local extracted_str = {}
	for tag in text_ret:gmatch('%b{}') do
		table.insert(extracted_str, {tag, tag})
	end
	
	if text_ret:find('{sex%[(.-)%]%[(.-)%]}') and #extracted_str ~= 0 then
		for i = 1, #extracted_str do
			local gender_male, gender_fem = text_ret:match('{sex%[(.-)%]%[(.-)%]}')
			if setting.sex == 1 then
				extracted_str[i][2] = gender_male
			else
				extracted_str[i][2] = gender_fem
			end
			
			for t = 1, #extracted_str do
				local pattern = escape_pattern(extracted_str[t][1])
				if text_ret:find(pattern) then
					text_ret = text_ret:gsub(pattern, extracted_str[t][2])
				end
			end
		end
	end
	
	return u8(text_ret)
end

--> Мемберс
members = {}
cloth = false
lastDialogWasActive = 0
dont_show_me_members = false
script_cursor = false
fontes = renderCreateFont('Trebuchet MS', setting.mb.size, setting.mb.flag)
members_wait = {
	members = false,
	next_page = {
		bool = false,
		i = 0
	}
}
org = {
	name = 'Организация',
	online = 0,
	afk = 0
}

--> Вантед
wanted_players = {}
emp_wanted_players = {}
wanted_update = false
wanted_wait = {
	checking = false,
	page = 0,
	timeout = 0
}
wanted_info = {
	name = 'Разыскиваемые',
	online = 0,
}
col_wanted = {}
fonts_wanted = nil

function render_wanted()
	local X, Y = setting.police_settings.wanted_list.pos.x, setting.police_settings.wanted_list.pos.y
	local title = string.format('%s | В розыске: %s', wanted_info.name, wanted_info.online)
	local col_title = changeColorAlpha(setting.police_settings.wanted_list.color.title, (setting.police_settings.wanted_list.vis * 2))

	if setting.police_settings.wanted_list.invers then
		renderFontDrawClickableText(script_cursor, fontes_wanted, title, X, Y - setting.police_settings.wanted_list.dist - 5, col_title, col_title, 4, false)
	else
		renderFontDrawClickableText(script_cursor, fontes_wanted, title, X, Y - setting.police_settings.wanted_list.dist - 5, col_title, col_title, 3, false)
	end

	if #wanted_players > 0 then
		for i, wanted in ipairs(wanted_players) do
			if not (setting.police_settings.wanted_list.interior and wanted.dist == 'в интерьере') then
				local color = changeColorAlpha(setting.police_settings.wanted_list.color.default, (setting.police_settings.wanted_list.vis * 2))
				local out_string
				if setting.police_settings.wanted_list.hide_distance then
					out_string = string.format('%s [%s] (%s ур.)', wanted.nick, wanted.id, wanted.level)
				else
					out_string = string.format('%s [%s] (%s ур.) - %s', wanted.nick, wanted.id, wanted.level, wanted.dist)
				end

				if setting.police_settings.wanted_list.invers then
					renderFontDrawClickableText(script_cursor, fontes_wanted, out_string, X, Y, color, color, 4, true)
				else
					renderFontDrawClickableText(script_cursor, fontes_wanted, out_string, X, Y, color, color, 3, true)
				end
				Y = Y + setting.police_settings.wanted_list.dist
			end
		end
	else
		local col_non = changeColorAlpha(setting.police_settings.wanted_list.color.default, (setting.police_settings.wanted_list.vis * 2))
		local text
		if wanted_wait.page == 0 then
			if wait_mb > 0 then
				text = 'Обновится через ' .. wait_mb .. ' сек.'
			else
				text = 'Обновление списка...'
			end
		else
			text = 'Нет никого в розыске'
		end
		if setting.police_settings.wanted_list.invers then
			renderFontDrawClickableText(script_cursor, fontes_wanted, text, X, Y, col_non, col_non,  4, false)
		else
			renderFontDrawClickableText(script_cursor, fontes_wanted, text, X, Y, col_non, col_non,  3, false)
		end
	end
end

function wanted_check()
	if not wanted_wait.checking then return end
	wanted_wait.page = wanted_wait.page + 1
	if wanted_wait.page <= 6 then
		lua_thread.create(function()
			wait(1100)
			while thread:status() ~= 'dead' do
				wait(500)
			end
			if wanted_wait.checking then
				while sampIsDialogActive() do
					wait(100)
				end
				if wanted_wait.checking then
					sampSendChat('/wanted ' .. wanted_wait.page)
					wanted_wait.timeout = os.clock() + 5
				end
			end
		end)
	else
		wanted_update = true
		wanted_wait.checking = false
	end
end

function render_members()
	local X, Y = setting.mb.pos.x, setting.mb.pos.y
	local title = string.format('%s | Онлайн: %s%s', org.name, org.online, (setting.mb.afk and (' (%s в АФК)'):format(org.afk) or ''))
	local col_title = changeColorAlpha(setting.mb.color.title, (setting.mb.vis * 2))
	if setting.mb.invers then
		if renderFontDrawClickableText(script_cursor, fontes, title, X, Y - setting.mb.dist - 5, col_title, col_title, 4, false) then
			sampSendChat('/members')
		end
	else
		if renderFontDrawClickableText(script_cursor, fontes, title, X, Y - setting.mb.dist - 5, col_title, col_title, 3, false) then
			sampSendChat('/members')
		end
	end
	if org.name == 'Гражданин' then
		local col_non = changeColorAlpha(setting.mb.color.default, (setting.mb.vis * 2))
		if setting.mb.invers then
			renderFontDrawClickableText(script_cursor, fontes, 'Вы не состоите в организации', X, Y, col_non, col_non,  4, false)
		else
			renderFontDrawClickableText(script_cursor, fontes, 'Вы не состоите в организации', X, Y, col_non, col_non,  3, false)
		end
	elseif #members > 0 then
		for i, member in ipairs(members) do
			if i <= tonumber(org.online) then
				if setting.rank_members[tonumber(member.rank.count)] then
					local color = changeColorAlpha(setting.mb.form and (member.uniform and setting.mb.color.work or setting.mb.color.default) or setting.mb.color.default, (setting.mb.vis * 2))
					local rank = setting.mb.rank and string.format('[%s]', member.rank.count) or nil
					local nick = member.nick .. (setting.mb.id and string.format('(%s)', member.id) or '')
					local afk = setting.mb.afk and member.afk and member.afk > 0 and string.format(' (AFK: %s)', member.afk) or ''
					local warns = setting.mb.warn and string.format(' (W: %s)', member.warns) or ''
					local out_string
					if setting.mb.invers then
						out_string = ('%s%s%s%s'):format(rank and rank .. ' ' or '', nick, afk, warns)
						renderFontDrawClickableText(script_cursor, fontes, out_string, X, Y, color, color, 4, true)
					else
						out_string = ('%s%s%s%s'):format(rank and rank .. ' ' or '', nick, afk, warns)
						renderFontDrawClickableText(script_cursor, fontes, out_string, X, Y, color, color, 3, true)
					end
					Y = Y + setting.mb.dist
				end
			end
		end
	else
		local col_non = changeColorAlpha(setting.mb.color.default, (setting.mb.vis * 2))
		if setting.mb.invers then
			renderFontDrawClickableText(script_cursor, fontes, 'Мемберс обновится через ' .. wait_mb .. ' сек.', X, Y, col_non, col_non,  4, false)
		else
			renderFontDrawClickableText(script_cursor, fontes, 'Мемберс обновится через ' .. wait_mb .. ' сек.', X, Y, col_non, col_non,  3, false)
		end
	end
end

function isCursorAvailable()
	return (not sampIsChatInputActive() and not sampIsDialogActive() and not sampIsScoreboardOpen())
end

function renderFontDrawClickableText(active, font, text, posX, posY, color, color_hovered, align, b_symbol)
	local cursorX, cursorY = getCursorPos()
	local lenght = renderGetFontDrawTextLength(font, text)
	local height = renderGetFontDrawHeight(font)
	local symb_len = renderGetFontDrawTextLength(font, '>')
	local hovered = false
	local result = false
	b_symbol = b_symbol == nil and false or b_symbol
	align = align or 1

	if align == 2 then
		posX = posX - (lenght / 2)
	elseif align == 3 then
		posX = posX - lenght
	end

	if active and cursorX > posX and cursorY > posY and cursorX < posX + lenght and cursorY < posY + height then
		hovered = true
		if isKeyJustPressed(0x01) then
			result = true 
		end
	end

	local anim = math.floor(math.sin(os.clock() * 10) * 3 + 5)
 	if hovered and b_symbol and (align == 2 or align == 1) then
		renderFontDrawText(font, '>', posX - symb_len - anim, posY, 0x90FFFFFF)
	end 
	renderFontDrawText(font, text, posX, posY, hovered and color_hovered or color)
	if hovered and b_symbol and (align == 2 or align == 3) then
		renderFontDrawText(font, '<', posX + lenght + anim, posY, 0x90FFFFFF)
	end 

	return result
end

function changePosition()
	if setting.mb.func then
		pos_new_memb = lua_thread.create(function()
			local backup = {
				['x'] = setting.mb.pos.x,
				['y'] = setting.mb.pos.y
			}
			local ChangePos = true
			sampSetCursorMode(4)
			windows.main[0] = false
			if not setting.cef_notif then
				sampAddChatMessage('[SH]{FFFFFF} Нажмите {FF6060}ЛКМ{FFFFFF}, чтобы применить или {FF6060}ESC{FFFFFF} для отмены.', 0xFF5345)
			else
				cefnotig('{FF5345}[SH]{FFFFFF} Нажмите {FF6060}ЛКМ{FFFFFF}, чтобы применить или {FF6060}ESC{FFFFFF} для отмены.', 3000)
			end
			if not sampIsChatInputActive() then
				while not sampIsChatInputActive() and ChangePos do
					wait(0)
					local cX, cY = getCursorPos()
					setting.mb.pos.x = cX
					setting.mb.pos.y = cY
					if isKeyDown(0x01) then
						while isKeyDown(0x01) do wait(0) end
						ChangePos = false
						save()
						if not setting.cef_notif then
							sampAddChatMessage('[SH]{FFFFFF} Позиция сохранена.', 0xFF5345)
						else
							cefnotig('[SH]{FFFFFF} Позиция сохранена.', 3000)
						end
					elseif isKeyJustPressed(VK_ESCAPE) then
						ChangePos = false
						setting.mb.pos.x = backup['x']
						setting.mb.pos.y = backup['y']
						if not setting.cef_notif then
							sampAddChatMessage('[SH]{FFFFFF} Вы отменили изменение позиции.', 0xFF5345)
						else
							cefnotig('{FF5345}[SH]{FFFFFF} Вы отменили изменение позиции.', 3000)
						end
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

function update_lists()
	while true do
		wait(1000)
		if not windows.main[0] and sampIsLocalPlayerSpawned() and not sampIsDialogActive() and wait_mb == 0 and not isGamePaused() and not isPauseMenuActive() then
			local check_started = false
			if setting.mb.func and not members_wait.members then
				members_wait.members = true
				sampSendChat('/members')
				check_started = true
			elseif not setting.mb.func and setting.police_settings.wanted_list.func and (setting.org >= 11 and setting.org <= 15) and not wanted_wait.checking then
				wanted_wait.checking = true
				wanted_wait.page = 1
				emp_wanted_players = {}
				sampSendChat('/wanted 1')
				wanted_wait.timeout = os.clock() + 5
				check_started = true
			end
			if check_started then
				wait_mb = 27
			elseif (members_wait.members or wanted_wait.checking) then
				wait_mb = 5 
			end
		end
	end
end

function check_all_wanted_pages() 
	if wanted_wait.checking then return end
		wanted_wait.checking = true
		lua_thread.create(function()
		temp_wanted_players = {} 
		for page = 1, 6 do
			while windows.main[0] do
				wait(200)
			end
			if not wanted_wait.checking then break end
			wanted_wait.dialog_opened = false
			sampSendChat('/wanted ' .. page)
			local timeout = os.clock() + 1.5 
			while os.clock() < timeout and not wanted_wait.dialog_opened do
				wait(0)
			end
			wait(700)
		end

		wanted_update = true
		wanted_wait.checking = false
	end)
end

function EXPORTS.sendRequest()
	if not sampIsDialogActive() and found_our then
		members_wait.members = true
		sampSendChat('/members')
		
		return true
	end
	
	return false
end

function getAfkCount()
	local count = 0
	for _, v in ipairs(members) do
		if v.afk > 0 then
			count = count + 1
		end
	end
	
	return count
end

function print_scr()
	setVirtualKeyDown(VK_F8, true)
	wait(25)
	setVirtualKeyDown(VK_F8, false)
end

function print_scr_time()
	lua_thread.create(function()
		sampSendChat('/time')
		wait(1500)
		setVirtualKeyDown(VK_F8, true)
		wait(25)
		setVirtualKeyDown(VK_F8, false)
	end)
end

function go_medic_or_fire()
	if setting.org <= 4 then
		sampSendChat('/godeath ' .. id_player_go)
	else
		sampSendChat('/fires')
	end
end

function asyncHttpRequest(method, url, args, resolve, reject)
	return require('StateHelper.core.network').sh_core_network_async_http_request(method, url, args, resolve, reject)
end

local function last_color(text, pos)
	local before = text:sub(1, math.max((pos or 1) - 1, 0))
	local last = before:match(".*({%x%x%x%x%x%x})")
	return last
end

function hook.onServerMessage(color_mes, mes)
	local mes_col = (bit.tohex(bit.rshift(color_mes, 8), 6))
	
	if trackingState.isTracking and trackingState.targetId then
		if mes:find("Игрок находится в каком%-то здании") or mes:find("в интерьере") or mes:find("в здании") then
			if not setting.cef_notif then
				sampAddChatMessage("[SH]{FF5345} Игрок " .. trackingState.targetId .. " зашел в здание. Отслеживание остановлено.", 0xFF5345)
			else
				cefnotig("{FF5345}[SH] Игрок " .. trackingState.targetId .. " зашел в здание. Отслеживание остановлено.", 3000)
			end
			trackingState.isTracking = false
			trackingState.targetId = nil
			if trackingState.thread and trackingState.thread:status() ~= 'dead' then
				trackingState.thread:terminate()
			end
			return false
		end
	end
	
	if mes:find("Местоположение .-%[%d+%] отмечено на карте красным маркером!") then
		return false
	end

	if mes:find('%[Ошибка%] {FFFFFF}Вы не полицейский!') and wanted_wait.checking then
		if not setting.cef_notif then
			sampAddChatMessage('[SH] {FFFFFF}Вы не полицейский, функция wanted на экране выключена.', 0xFF5345)
		else
			cefnotig('{FF5345}[SH] {FFFFFF}Вы не полицейский, функция wanted на экране выключена.', 3500)
		end
		setting.police_settings.wanted_list.func = false
		save()
		return false
	end

	if mes:find('%[Ошибка%] {ffffff}Вы не состоите во фракции') and setting.mb.func then
		if not setting.cef_notif then
			sampAddChatMessage('[SH] {FFFFFF}Вы не состоите в организации, мемберс на экране выключен.', 0xFF5345)
		else
			cefnotig('{FF5345}[SH] {FFFFFF}Вы не состоите в организации, мемберс на экране выключен.', 3500)
		end
		setting.mb.func = false
		save()
		return false
	end
	
	if mes:find('%[Ошибка%] {FFFFFF}Не флуди!') and wanted_wait.checking then
		lua_thread.create(function()
			wait(1500)
			if wanted_wait.checking then
				sampSendChat('/wanted ' .. wanted_wait.page)
				wanted_wait.timeout = os.clock() + 5
			end
		end)
		return false
	end

	if mes:find('%[Ошибка%] {ffffff}Игроков с таким уровнем розыска нету!') and wanted_wait.checking then
		wanted_wait.timeout = 0
		wanted_check()
		return false
	end

	if setting.police_settings.ten_code and (setting.org >= 11 and setting.org <= 15) and next(tenCodes) then
		for pattern, addon in pairs(tenCodes) do
			local s, e = mes:find(pattern, 1, true)
			if s then
				local next_ch = mes:sub(e+1, e+1)
				if next_ch == "" or next_ch:match("[%s%p]") or next_ch == "{" then
					local mes_col = "{" .. bit.tohex(bit.rshift(color_mes, 8), 6) .. "}"
					local restore_hex = last_color(mes, s)
					if not restore_hex then
						restore_hex = mes_col
					end
					local insert = " {FFFF00}(" .. addon .. ")" .. restore_hex
					local new_text = mes:sub(1, e) .. insert .. mes:sub(e + 1)
					return { color_mes, new_text }
				end
			end
		end
	end

	if setting.put_mes[2] and setting.hide_chat then
		if mes:find('Объявление:') or mes:find('Отредактировал сотрудник') then
			return false
		end
	end
	if mes:find('У игрока уже есть Трудовая книжка!') and run_sob then
		wait_book = {20, true}
	end
	
	if setting.put_mes[3] and setting.hide_chat then
		if mes:find('News LS') or mes:find('News SF') or mes:find('News LV') then
			return false
		end
		if mes:find('Гость') or mes:find('Репортёр') then
			if mes_col == '9acd32' then
				return false
			end
		end
	end

	if mes:find('Преследование за (.-) было приостановлено, причина:') and setting.org >= 11 and setting.org <= 15 then
		poltarget = nil
	end

	if mes:find('Вы успешно начали погоню за игроком') and setting.org >= 11 and setting.org <= 15 then
		local id = mes:match("Вы успешно начали погоню за игроком .- %[ID: (%d+)%]")
		if id then
			poltarget = tonumber(id)
		end
	end

	if mes:find('Вы не можете продавать лицензии на такой срок') then
		num_give_lic = -1
		if not setting.cef_notif then
			sampAddChatMessage('[SH] {FFFFFF}Ваш ранг не позволяет выдать эту лицензию!', 0xFF5345)
		else
			cefnotig('{FF5345}[SH] {FFFFFF}Ваш ранг не позволяет выдать эту лицензию!', 3000)
		end
		return false
	end
	
	if setting.put_mes[1] and setting.hide_chat then
		if mes:find('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~') or mes:find('- Основные команды сервера: /menu /help /gps /settings') 
		or mes:find('Пригласи друга и получи бонус в размере') or mes:find('- Донат и получение дополнительных средств arizona-rp.com/donate') 
		or mes:find('Подробнее об обновлениях сервера') or mes:find('(Личный кабинет/Донат)') or mes:find('С помощью телефона можно заказать') 
		or mes:find('В нашем магазине ты можешь') or mes:find('их на желаемый тобой {FFFFFF}бизнес') or mes:find('Игроки со статусом (.+)имеют больше возможностей') 
		or mes:find('можно приобрести редкие {FFFFFF}автомобили, аксессуары, воздушные') or mes:find('предметы, которые выделят тебя из толпы! Наш сайт:') 
		or mes:find('Вы можете купить складское помещение') or mes:find('Таким образом вы можете сберечь своё имущество, даже если вас забанят.') 
		or mes:find('Этот тип недвижимости будет навсегда закреплен за вами и за него не нужно платить.') or mes:find('{ffffff}Уважаемые жители штата, открыта продажа билетов на рейс:') 
		or mes:find('{ffffff}Подробнее: {FF6666}/help — Перелёты в город Vice City.') or mes:find('{ffffff}Внимание! На сервере Vice City действует акция Х3 PayDay.') 
		or mes:find('%[Подсказка%] Игроки владеющие (.+) домами могут бесплатно раз в день получать') or mes:find('%[Подсказка%] Игроки владеющие (.+) домами могут получать (.+) Ларца Олигарха')
		or mes:find('Игроки со статусом (.+)имеют большие возможности') or mes:find('{9ACD32}%[Подсказка%]{FFFFFF} Негде жить?') or mes:find('{9ACD32}%[Подсказка%]{FFFFFF} Проживая в отеле')
		or mes:find('{9ACD32}%[Подсказка%]{FFFFFF} Подробнее') or mes:find('%[Информация%] Продавай и покупай автомобильные номера') 
		or mes:find('Администрация сервера в поиске новых спонсоров для проведения') or mes:find('Именно Вы можете стать тем самым спонсором, благодаря которому будет проведено') 
		or mes:find('Спонсировать серверные мероприятия можно с помощью команды') or mes:find('С уважением, Администрация сервера')
		or mes:find('На сервере Vice City действует акция') or mes:find('Центр обмена имуществ') or mes:find('Проводи безопасный обмен имуществом с другими игроками')
		or mes:find('%[Рыбалка%] Игрок (.+) занял(.+)место по количеству выловленной рыбы') or mes:find('Вы можете улучшить свои характеристики на поле битвы')
		or mes:find('Списанный бронежилет на 4 часа даст вашему персонажу') or mes:find('Найти склад можно(.+)Склад списанных бронежилетов') then 
			return false
		end
	end
	
	if mes:find(' испытал удачу при открытии ') or mes:find('%[Удача%] Игрок') or mes:find('Удача улыбнулась игроку') and setting.put_mes[4] and setting.hide_chat then
		return false
	end

	if mes:find('[Сбор средств](.+)организац') and setting.put_mes[5] and setting.hide_chat then
		return false
	end
	if run_sob then
		if mes:find(my.nick .. '%[' .. my.id .. '%]') or mes:find(sob_info.nick .. '%[' .. sob_info.id .. '%]') then
			local log_message = mes
			if setting.sob.use_original_color then
				log_message = '{' .. mes_col .. '}' .. mes
			else
				if setting.cl ~= 'Black' then
					log_message = log_message:gsub('%{B7AFAF%}', '%{464d4f%}'):gsub('%{FFFFFF%}', '%{464d4f%}')
				end
			end
			local message_buffer = imgui.new.char[120](log_message)
			table.insert(sob_info.history, ffi.string(message_buffer))
			if #sob_info.history > 30 then
				table.remove(sob_info.history, 1)
			end
		end
	end

	if (mes:find('Robert_Poloskyn(.+) shbl'..my.id) and s_na == 'Winslow') or (mes:find('Alberto_Kane(.+) shbl'..my.id) and s_na == 'Phoenix') or (mes:find('Ilya_Kustov(.+) shbl'..my.id) and s_na == 'Phoenix') then
		if setting.blockl then
			setting.blockl = false
			if not setting.cef_notif then
				sampAddChatMessage('[SH]{FFFFFF} Доступ к StateHelper был разблокирован.', 0x23E64A)
			else
				cefnotig('{23E64A}[SH]{FFFFFF} Доступ к StateHelper был разблокирован.', 3000)
			end
		else
			cefnotig('{FF5345}[SH]{FFFFFF} Доступ к StateHelper был заблокирован разработчиком.', 3000)
			setting.blockl = true
			sampShowDialog(2001, 'Уведомление', 'Вам был заблокирован доступ к StateHelper.', 'Закрыть', '', 0)
			lua_thread.create(function()
				local rever = 0
				repeat wait(200)
					addOneOffSound(0, 0, 0, 1057)
					rever = rever + 1
				until rever > 10
			end)
		end
		save()
		return false
	end

	if mes:find('%[Информация%] {ffffff}Вы заполнили все пункты, для подтверждения распишитесь нажав кнопку {90EE90}"Заполнить"') and setting.police_settings.auto_inves then
		sampSendClickTextdraw(2131)
		return false
	end

	if mes:find('Robert_Poloskyn(.+) sh'..my.id) and s_na == 'Winslow' then	
		local rever = 0
		sampShowDialog(2001, 'Подтверждение', 'Это сообщение говорит о том, что к Вам обращается официальный\n				 разработчик-фиксер скрипта State Helper - {2b8200}Robert_Poloskyn', 'Закрыть', '', 0)
		sampAddChatMessage('[SH] Это сообщение подтверждает, что к Вам обращается разработчик-фиксер State Helper - {39e3be}Robert_Poloskyn.', 0xFF5345)
		lua_thread.create(function()
			repeat wait(200)
				addOneOffSound(0, 0, 0, 1057)
				rever = rever + 1
			until rever > 10
		end)
		return false
	end

	if mes:find('AIberto_Kane(.+):(.+)пук ' .. my.id) or mes:find('Alberto_Kane(.+):(.+)пук ' .. my.id) or mes:find('Ilya_Kustov(.+):(.+)пук ' .. my.id) then
		local id_il = mes:match('%[(.-)%]')
		sampSendChat('/showcarskill ' .. id_il)
		ret_check = 3
		
		return false
	end
	
	if setting.color_nick then
		if mes:find('говорит:') and mes_col == 'ffffff' and setting.replace_ic then
			local playerId = mes:match('%d+')
			if playerId then
				local playerColor = sampGetPlayerColor(playerId)
				sampAddChatMessage(mes, playerColor)
				return false
			end
		elseif mes:find('кричит:') and mes_col == 'f0e68c' and setting.replace_s then
		local playerId = mes:match('%d+')
		if playerId then
			local playerColor = sampGetPlayerColor(playerId)
			local mes = mes:gsub("кричит:", "кричит:{F0E68C}")
			sampAddChatMessage(mes, playerColor)
			return false
		end
		elseif mes:find('говорит шепотом:') and mes_col == '94b0c1' and setting.replace_c then
			local playerId = mes:match('%d+')
			if playerId then
				local playerColor = sampGetPlayerColor(playerId)
				sampAddChatMessage(mes, playerColor)
				return false
			end
		elseif mes:match('%(%(.+%[%d+%]: {B7AFAF}.+%)%)$') and mes_col == 'ffffff' and setting.replace_b then
			local nickname, id, text = mes:match('%(%(%s*(.-)%[(%d+)%]: {B7AFAF}(.-)%)%)$')
			if nickname and id and text then
				local playerId = tonumber(id)
				local playerColor = sampGetPlayerColor(playerId)
				local cleanText = text:gsub("{B7AFAF}", "")
				local formatted = string.format('{%06X}(( %s[%s]: {B7AFAF}%s{%06X}))',
					bit.band(playerColor, 0xFFFFFF), nickname, id, cleanText, bit.band(playerColor, 0xFFFFFF))
				sampAddChatMessage(formatted, playerColor)
				return false
			end
		end
	end
	
	if mes:find('Купите лотерейный билет и получите возможность выиграть') or mes:find('Купить лотерейные билеты можно в уличных киосках')
	and setting.put_mes[7] and setting.hide_chat then
		return false
	end

	if mes:find('Гос%.Новости') and mes_col == '045fb4' and setting.put_mes[8] and setting.hide_chat then
		return false
	end

	if setting.put_mes[6] and setting.hide_chat then
		if mes:find('%[Информация%]{FFFFFF} Игрок .+ приобрел ') then
			return false
		end

		if mes:find('^[^%a].+_%w+%[%d+%]%:') and mes_col == '4184e4' then
			local nick = mes:match("(%w+_%w+)") or "Игрок"
			return false
		end
	end

	if mes:find('%[D%] ') and mes_col == '3399ff' and setting.put_mes[9] and setting.hide_chat then
		return false
	end

	if mes:find('%[R%] ') and mes_col == '2db043' and setting.put_mes[10] and setting.hide_chat then
		return false
	end
	
	if mes:find('На сервере есть инвентарь, используйте клавишу Y для работы с ним') then
		close_serv = false
		cssInjected = false
		local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
		my = {id = myid, nick = sampGetPlayerNickname(myid)}
		injNotif()
	end
	
	if setting.show_dialog_auto then
		if mes:find('%[Новое предложение%]{ffffff} Вам поступило предложение от игрока(.+)%. Используйте команду%: %/offer или клавишу X') then
			sampSendChat('/offer')
		end
	end
	
	if setting.godeath.func then
		if mes:find('Очевидец сообщает о пострадавшем человеке(.+)') and mes_col == 'ff5350' then
			text_godeath = mes
			
			return false
		end
		
		if mes:find('%[Происшествие%](.+)В штате произошел пожар') and setting.org == 9 then
			if setting.fire.sound then
				addOneOffSound(0, 0, 0, 1057)
			end
			
			if setting.fire.auto_cmd_fires and not fire_active then
				sampSendChat('/fires')
			end
		end
		
		if setting.report_fire.arrival.func and setting.org == 9 and mes:find('Информация(.+)Вы прибыли на место пожара') then
			fire_active = true
			auto_report_fire(setting.report_fire.arrival.text, setting.report_fire.arrival.ask)
		end
		
		if fire_active and setting.report_fire.foci.func and setting.org == 9 and mes:find('Информация(.+)Все очаги возгорания ликвидированы') then
			auto_report_fire(setting.report_fire.foci.text, setting.report_fire.foci.ask)
		end
		
		if fire_active and setting.report_fire.stretcher.func and setting.org == 9 and mes:find('Информация(.+)Отнесите пострадавшего в палатку') then
			auto_report_fire(setting.report_fire.stretcher.text, setting.report_fire.stretcher.ask)
		end
		
		if fire_active and setting.report_fire.salvation.func and setting.org == 9 and mes:find('Информация(.+)Отлично%! Вы спасли пострадавшего') then
			auto_report_fire(setting.report_fire.salvation.text, setting.report_fire.salvation.ask)
		end
		
		if fire_active and setting.report_fire.extinguishing.func and setting.org == 9 and mes:find('забрать вознаграждение можно на базе организации') then
			auto_report_fire(setting.report_fire.extinguishing.text, setting.report_fire.extinguishing.ask)
			fire_active = false
		end
		
	end
	
	if mes:find('Чтобы принять вызов, введите(.+)godeath(.+)') and mes_col == 'ff5350' and setting.godeath.func then
		local id_pl_godeath = mes:match('godeath%s-(%d+)')
		local area, location = '[ОШИБКА ЧТЕНИЯ]', '[ОШИБКА ЧТЕНИЯ]'
		local my_pos_int_or_around = getActiveInterior()
		local coord_area = ''
		local text_cmd = ''
		area, location = text_godeath:match('районе%s+(.-)%s*%((.-)%)')
		id_player_go = id_pl_godeath
		
		
		if setting.godeath.cmd_go then
			text_cmd = ' /go или'
		end
		if setting.godeath.meter then
			coord_area = measurement_coordinates(area, my_pos_int_or_around, location)
		end
		
		local c = imgui.ImVec4(setting.godeath.color_godeath[1], setting.godeath.color_godeath[2], setting.godeath.color_godeath[3], 1.00)
		local argb = imgui.ColorConvertFloat4ToARGB(c)
		local col_mes_godeath = '0x'.. (ARGBtoStringRGB(imgui.ColorConvertFloat4ToARGB(c))):gsub('[%{%}]', '')
		if not actions_set.remove_mes and not actions_set.remove_rp then
			if not setting.cef_notif then
				sampAddChatMessage('Поступил вызов в районе ' .. area .. ' ('.. location .. ')' .. coord_area .. '. Введите' .. text_cmd .. ' /godeath ' .. id_pl_godeath, col_mes_godeath)
			else
				cefnotig('Поступил вызов в районе ' .. area .. ' ('.. location .. ')' .. coord_area .. '. Введите' .. text_cmd .. ' /godeath ' .. id_pl_godeath, 3000)
			end
		end
		
		if setting.godeath.sound then
			addOneOffSound(0, 0, 0, 1057)
		end
		
		if setting.godeath.two_text then
			return false
		end
	end
	
	if (mes:find('отчет по навыку вождения') or mes:find('Не флуди')) and ret_check > 0 then
		return false
	end
	
	if ret_check > 0 then
		ret_check = ret_check - 1
	end
	
	if mes:find('%[Ошибка%] {FFFFFF}Не флуди!') and setting.replace_not_flood then
		local pointer = sampGetInputInfoPtr()
		local pointer = getStructElement(pointer, 0x8, 4)
		local pos_chat_x = getStructElement(pointer, 0x8, 4)
		local pos_chat_y = getStructElement(pointer, 0xC, 4)
		if replace_not_flood[1] == 0 then
			replace_not_flood = {9, pos_chat_x, pos_chat_y, 0, 1}
		else
			replace_not_flood = {9, pos_chat_x, pos_chat_y, replace_not_flood[4], replace_not_flood[5] + 1}
		end
		
		return false
	end
	
	if mes:find('Игрок AIberto_Kane(.+)показал отчет по своему навыку вождения') or mes:find('Игрок Alberto_Kane(.+)показал отчет по своему навыку вождения') and mes_col == '6495ed' then
		local rever = 0
		sampShowDialog(2001, 'Подтверждение', 'Это сообщение говорит о том, что к Вам обращается официальный\n				 разработчик скрипта State Helper - {2b8200}Alberto_Kane', 'Закрыть', '', 0)
		sampAddChatMessage('[SH] Это сообщение подтверждает, что к Вам обращается разработчик State Helper - {39e3be}Alberto_Kane.', 0xFF5345)
		lua_thread.create(function()
			repeat wait(200)
				addOneOffSound(0, 0, 0, 1057)
				rever = rever + 1
			until rever > 10
		end)
		return false
	end
	
	if mes:find('Игрок Ilya_Kustov(.+)показал отчет по своему навыку вождения') and mes_col == '6495ed' then
		local rever = 0
		sampShowDialog(2001, 'Подтверждение', 'Это сообщение говорит о том, что к Вам обращается официальный\n				 QA-инженер скрипта State Helper - {2b8200}Ilya_Kustov', 'Закрыть', '', 0)
		sampAddChatMessage('[SH] Это сообщение подтверждает, что к Вам обращается QA-инженер State Helper - {39e3be}Ilya_Kustov.', 0xFF5345)
		lua_thread.create(function()
			repeat wait(200)
				addOneOffSound(0, 0, 0, 1057)
				rever = rever + 1
				until rever > 10
		end)
		return false
	end
	
	if actions_set.remove_mes and not actions_set.remove_rp and not mes:find('(.+)%[(.+)%] говорит:(.+)') and mes_col ~= 'ff99ff' and mes_col ~= '4682b4' 
	and not mes:find('(.+)%- сказал%(а%)(.+)%[(.+)%]') and not mes:find('(.+)%[(.+)%](.+)Неудачно') 
	and not mes:find('(.+)%[(.+)%](.+)Удачно') then
		return false
	elseif actions_set.remove_rp and not mes:find(my.nick..'%[(.+)%] говорит:(.+)') and not mes:find('(.+)%- сказал%(а%) '..my.nick..'%[(.+)%]') 
	and not mes:find(my.nick..'%[(.+)%](.+)Неудачно') and not mes:find(my.nick..'%[(.+)%](.+)Удачно') then
		if not mes:find(my.nick..'%[(.+)%]') and mes_col ~= 'ff99ff' then
			if not mes:find(my.nick..'%[(.+)%]') and mes_col ~= '4682b4' then
				return false
			end
		end
	end
	
	if mes:find('%[Диспетчер%] (.+)' .. my.nick .. ' принял вызов пациента(.+)') and mes_col == 'ff5350' and setting.godeath.func and setting.godeath.auto_send then
		sampAddChatMessage(mes, '0x' .. mes_col)
		sampSendChat('/r Принял'.. sex('', 'а') ..  ' вызов от пострадавшего. Немедленно выдвигаюсь для оказания помощи.')
	end
	
	if mes:find('Администратор ((%w+)_(%w+)):(.+)спавн') or mes:find('Администратор (%w+)_(%w+):(.+)Спавн') then
		if setting.notice.car and not error_spawn then
			lua_thread.create(function()
				error_spawn = true
				local stop_signal = 0
				repeat wait(200)
					addOneOffSound(0, 0, 0, 1057)
					stop_signal = stop_signal + 1
				until stop_signal > 17
				wait(62000)
				error_spawn = false
			end)
		end
	end
	
	if mes:find('^%[D%](.+)%[(%d+)%]:') and tab == 'dep' and windows.main[0] then
		local bool_t = imgui.new.char[110](mes)
		table.insert(dep_history, ffi.string(bool_t))
		if ffi.string(bool_t) ~= mes then
			local icran = ffi.string(bool_t):gsub('%[', '%%['):gsub('%]', '%%]'):gsub('%.', '%%.'):gsub('%-', '%%-'):gsub('%+', '%%+'):gsub('%?', '%%?'):gsub('%$', '%%$'):gsub('%*', '%%*'):gsub('%(', '%%('):gsub('%)', '%%)')
			local soc_new_char = mes:gsub(icran, '')
			bool_t = imgui.new.char[110](soc_new_char)
			table.insert(dep_history, ffi.string(bool_t))
		end
	end
	
	if setting.notice.dep and setting.dep.my_tag ~= '' then
		local call_org = false
		if mes:find('%[D%](.+)'..u8:decode(setting.dep.my_tag)..'(.+)связь') and not mes:find(my.nick .. '%[' .. my.id) then
			call_org = true
		end
		if mes:find('%[D%](.+)'..u8:decode(setting.dep.my_tag_en)..'(.+)связь') and setting.dep.my_tag_en ~= '' and not mes:find(my.nick .. '%[' .. my.id) then
			call_org = true
		end
		if mes:find('%[D%](.+)'..u8:decode(setting.dep.my_tag_en2)..'(.+)связь') and setting.dep.my_tag_en2 ~= '' and not mes:find(my.nick .. '%[' .. my.id) then
			call_org = true
		end
		if mes:find('%[D%](.+)'..u8:decode(setting.dep.my_tag_en3)..'(.+)связь') and setting.dep.my_tag_en3 ~= '' and not mes:find(my.nick .. '%[' .. my.id) then
			call_org = true
		end
		
		if call_org then
			local comparison = mes:match('%[(%d+)%]')
			comparison = tonumber(comparison)
			lua_thread.create(function()
				wait(15)
				EXPORTS.sendRequest()
				wait(200)
				local found_our = false
				for i, member in ipairs(members) do
					if tonumber(member.id) == comparison then
						found_our = true
						break
					end
				end
				if not found_our then
					if not setting.cef_notif then
						sampAddChatMessage('[SH]{e3a220} Вашу организацию вызывают в рации департамента!', 0xFF5345)
						sampAddChatMessage('[SH]{e3a220} Вашу организацию вызывают в рации департамента!', 0xFF5345)
					else
						cefnotig("{FF5345}[SH]{e3a220} Вашу организацию вызывают в рации департамента!", 3000)
					end
					local stop_signal = 0
					repeat wait(200) 
						addOneOffSound(0, 0, 0, 1057)
						stop_signal = stop_signal + 1
					until stop_signal > 17
				end
			end)
		end
	end
end

ips = {
	Phoenix = {'185.169.134.3:7777', 'phoenix.arizona-rp.com:7777'},
	Tucson = {'185.169.134.4:7777', 'tucson.arizona-rp.com:7777'},
	Scottdale = {'185.169.134.43:7777', 'scottdale.arizona-rp.com:7777'},
	Winslow = {'185.169.134.173:7777', 'winslow.arizona-rp.com:7777'},
	Brainburg = {'185.169.134.45:7777', 'brainburg.arizona-rp.com:7777'},
	BumbleBee = {'80.66.82.87:7777', 'bumblebee.arizona-rp.com:7777'},
	CasaGrande = {'80.66.82.188:7777', 'casagrande.arizona-rp.com:7777'},
	Chandler = {'185.169.134.44:7777', 'chandler.arizona-rp.com:7777'},
	Christmas = {'80.66.82.54:7777', 'christmas.arizona-rp.com:7777'},
	Faraway = {'80.66.82.82:7777', 'faraway.arizona-rp.com:7777'},
	Gilbert = {'80.66.82.191:7777', 'gilbert.arizona-rp.com:7777'},
	Glendale = {'185.169.134.171:7777', 'glendale.arizona-rp.com:7777'},
	Holiday = {'80.66.82.132:7777', 'holiday.arizona-rp.com:7777'},
	Kingman = {'185.169.134.172:7777', 'kingman.arizona-rp.com:7777'},
	Mesa = {'185.169.134.59:7777', 'mesa.arizona-rp.com:7777'},
	Page = {'80.66.82.168:7777', 'page.arizona-rp.com:7777'},
	Payson = {'185.169.134.174:7777', 'payson.arizona-rp.com:7777'},
	Prescott = {'185.169.134.166:7777', 'prescott.arizona-rp.com:7777'},
	QueenCreek = {'80.66.82.200:7777', 'queencreek.arizona-rp.com:7777'},
	RedRock = {'185.169.134.61:7777', 'redrock.arizona-rp.com:7777'},
	SaintRose = {'185.169.134.5:7777', 'saintrose.arizona-rp.com:7777'},
	Sedona = {'80.66.82.144:7777', 'sedona.arizona-rp.com:7777'},
	ShowLow = {'80.66.82.190:7777', 'showlow.arizona-rp.com:7777'},
	SunCity = {'80.66.82.159:7777', 'suncity.arizona-rp.com:7777'},
	Surprise = {'185.169.134.109:7777', 'surprise.arizona-rp.com:7777'},
	Wednesday = {'80.66.82.128:7777', 'wednesday.arizona-rp.com:7777'},
	Yava = {'80.66.82.113:7777', 'yava.arizona-rp.com:7777'},
	Yuma = {'185.169.134.107:7777', 'yuma.arizona-rp.com:7777'},
	Love = {'80.66.82.33:7777', 'love.arizona-rp.com:7777'},
	Mirage = {'80.66.82.39:7777', 'mirage.arizona-rp.com:7777'},
	Drake = {'drake.arizona-rp.com:7777', '80.66.82.22:7777'},
	VC = {'80.66.82.147:7777', 'vicecity.arizona-rp.com:7777'},
	Space = {'80.66.82.199:7777', 'space.arizona-rp.com:7777'}
}

function closeDialog(a, b)
	lua_thread.create(function()
		wait(5)
		sampSendDialogResponse(a, b)
	end)
end

function hook.onShowDialog(id, style, title, but_1, but_2, text)

	if id == 1780 and wanted_wait.checking then
		wanted_wait.timeout = 0
		for line in text:gmatch('[^\r\n]+') do
			local nick, player_id, wanted_level, distance = string.match(line, '{FFFFFF}(.-)%({21FF11}(%d+){FFFFFF}%)%s+(%d+)%s+уровень%s+%[%s*(.-)%s*%]')
			if nick then
				table.insert(emp_wanted_players, { nick = nick, id = player_id, level = wanted_level, dist = distance })
				closeDialog(1780, 0)
			end
		end
		wanted_check()
		return false
	end

	if id == 0 and unprison then
		if text:find("Тюремные наказания") then
			if (s_na == 'Chandler' or s_na == 'RedRock' or s_na == 'Gilbert' or s_na == 'ShowLow' or s_na == 'CasaGrande' or s_na == 'SunCity' or s_na == 'Holiday' or s_na == 'Christmas' or s_na == 'Scottdale') then
				local values = {}
				for value in text:gmatch("{5CDC59}(%d+)") do
					table.insert(values, value)
				end
				if #values > 0 then
					local total_sum = 0
					if setting.price[3] then
						total_sum = total_sum + ((tonumber(values[1]) or 0) * (sh_money_parse(setting.price[3].box) or 0))
						total_sum = total_sum + ((tonumber(values[2]) or 0) * (sh_money_parse(setting.price[3].eat) or 0))
						total_sum = total_sum + ((tonumber(values[3]) or 0) * (sh_money_parse(setting.price[3].cloth) or 0))
						total_sum = total_sum + ((tonumber(values[4]) or 0) * (sh_money_parse(setting.price[3].trash) or 0))
						total_sum = total_sum + ((tonumber(values[5]) or 0) * (sh_money_parse(setting.price[3].min) or 0))
						if unprison_id then
							local raw_total_sum = sh_money_raw(math.floor(total_sum))
							sampAddChatMessage("/unpunish " .. unprison_id .. " " .. raw_total_sum, -1	)
							sampSendChat("/unpunish " .. unprison_id .. " " .. raw_total_sum)
							unprison_id = nil
						end
					end
				end
			elseif (s_na == 'Tucson') then
				sampSendChat("/unpunish " .. unprison_id .. " " .. '2500000')
				unprison = false
			elseif (s_na == 'Mesa') then
				sampSendChat("/unpunish " .. unprison_id .. " " .. '2000000')
				unprison = false
			elseif (s_na == 'Page') then
				sampSendChat("/unpunish " .. unprison_id .. " " .. '10000000')
				unprison = false
			elseif (s_na == 'Sedona') then
				sampSendChat("/unpunish " .. unprison_id .. " " .. '15000000')
				unprison = false
			end
		end	
	end

	if id == 1214 then
		if lspawncar then
			sampSendDialogResponse(1214, 1, 3, -1)
			lsclose = true
			lspawncar = false
			return false
		elseif lsclose then
			sampCloseCurrentDialogWithButton(0)
			lsclose = false
			return false
		end
	end
	if id == 235 then
		local text_org, rank_org = text:match('Должность: {B83434}(.-)%((%d+)%)')
		if text_org and rank_org then
			setting.job_title = u8(text_org)
			setting.rank = tonumber(rank_org)
			save()
		else
			if text:find('Должность: {B83434}Судья') then
				setting.job_title = u8('Судья')
				setting.rank = 10
				save()
			end
		end
	
		if close_stats then 
			closeDialog(235, 0)
			close_stats = false
			return false
		end
	end

	if (id == 26950 or id == 26951) and setting.police_settings.auto_inves then
		local extracted_text = text:match("{90EE90}([^%{]*)")
		if extracted_text then
			extracted_text = extracted_text:gsub("^%s+", ""):gsub("%s+$", "")
			sampSendDialogResponse(id, 1, 0, extracted_text)
		end
		return false
	end

	if title == "{BFBBBA}Активные предложения" and setting.show_dialog_auto and doc_numb then
		local g = 0
		for line in text:gmatch('[^\r\n]+') do
			if line:find('медицинскую') or line:find('паспорт') or line:find('лицензии') or line:find('трудовой') then
				sampSendDialogResponse(id, 1, g, -1)
				g = g + 1
				doc_numb = false
				return false
			end
		end
	end

	if id == 27341 then
		for line in text:gmatch('[^\r\n]+') do 
			if line:find('медицинскую') or line:find('паспорт') or line:find('лицензии') or line:find('трудовой') then
				if setting.show_dialog_auto or setting.auto_cmd_doc then
					sampSendDialogResponse(id, 1, 2, -1)
					confirm_action_dialog = true
					return false
				end
			end
		end
	end
	
	if title == "{BFBBBA}Активные предложения" and not doc_numb then
		for line in text:gmatch('[^\r\n]+') do
			if line:find('медицинскую') or line:find('паспорт') or line:find('лицензии') or line:find('трудовой') then
				if setting.show_dialog_auto then
					doc_numb = true
					sampSendDialogResponse(id, 1, 2, nil)
					return false
				end
			end
		end
	end
	
	if id == 2015 and members_wait.members and setting.mb.func then
		local status, err = pcall(function()
			local ip, port = sampGetCurrentServerAddress()
			local server = ip..':'..port
			if server == '80.66.82.147:7777' then return false end
			local count = 0
			members_wait.next_page.bool = false
			if title:find('{FFFFFF}(.+)%(В сети: (%d+)%)') then
				org.name, org.online = title:match('{FFFFFF}(.+)%(В сети: (%d+)%)')
			else
				org.name = 'Больница VC'
				org.online = title:match('%(В сети: (%d+)%)')
			end
			for line in text:gmatch('[^\r\n]+') do
				count = count + 1
				if not line:find('Ник') and not line:find('страница') then
					local color, nick, id, prefix, rank_name, rank_id, color_nil, warns, afk, muted, quests
					if line:find('%(Вы%)') then
						color, nick, id, prefix, rank_name, rank_id, color_nil, warns, idk, afk, muted, quests = 
							string.match(line, '{(%x+)}(.-)%((%d+)%)%{(%x+)}%(Вы%)\t(.-)%((%d+)%)\t{(%x+)}(%d+) %[(%d+)] / (%d+)%s*(.-)\t(%d+)')
					elseif line:find('%(%d+ дней%)') then
						color, nick, id, rank_name, rank_id, color, days, color_nil, warns, idk, afk, muted, quests = 
						string.match(line, '{(%x+)}(.-)%((%d+)%)\t(.-)%((%d+)%) {(%x+)}%((.-)%)\t{(%x+)}(%d+) %[(%d+)] / (%d+)%s*(.-)\t(%d+)')

					else
						color, nick, id, rank_name, rank_id, color_nil, warns, idk, afk, muted, quests = 
							string.match(line, '{(%x+)}(.-)%((%d+)%)\t(.-)%((%d+)%)\t{(%x+)}(%d+) %[(%d+)] / (%d+)%s*(.-)\t(%d+)')
					end
					local uniform = (color == '90EE90')
					if not setting.mb_tags then
						nick = nick:match('([A-Za-z]+_[A-Za-z]+)$')
					end
					if muted and muted ~= "" then
						muted = muted:match('^/%s*(.*)') or muted
						nick = nick .. " (" .. muted .. ") "
					end
					members[#members + 1] = {
						nick = tostring(nick),
						id = id,
						rank = {
							count = tonumber(rank_id),
						},
						afk = tonumber(afk),
						warns = tonumber(warns),
						rank_name = rank_name,
						uniform = uniform
					}
				end
				if line:match('Следующая страница') then
					members_wait.next_page.bool = true
					members_wait.next_page.i = count - 2
				end
			end
			if members_wait.next_page.bool then
				sampSendDialogResponse(id, 1, members_wait.next_page.i, _)
				members_wait.next_page.bool = false
				members_wait.next_page.i = 0
			else
				while #members > tonumber(org.online) do
					table.remove(members, 1)
				end
				sampSendDialogResponse(id, 0, _, _)
				org.afk = getAfkCount()
				members_wait.members = false
				if setting.police_settings.wanted_list.func and (setting.org >= 11 and setting.org <= 15) and not wanted_wait.checking then
					lua_thread.create(function()
						wait(1100)
						wanted_wait.checking = true
						wanted_wait.page = 1
						emp_wanted_players = {}
						sampSendChat('/wanted 1')
						wanted_wait.timeout = os.clock() + 5
					end)
				end
			end
		end)
		
		if not status then
			if not setting.cef_notif then
				sampAddChatMessage(string.format('[SH]{FFFFFF} В Мемберс на экране случилась ошибка. Функция отключена.'), 0xFF5345)
			else
				cefnotig('{FF5345}[SH]{FFFFFF} В Мемберс на экране случилась ошибка. Функция отключена.', 3000)
			end
			setting.mb.func = false
		end
		
		return false
	elseif members_wait.members and id ~= 2015 then
		dont_show_me_members = true
		members_wait.members = false
		members_wait.next_page.bool = false
		members_wait.next_page.i = 0
		while #members > tonumber(org.online) do 
			table.remove(members, 1) 
		end 
	elseif dont_show_me_members and id == 2015 then
		dont_show_me_members = false
		lua_thread.create(function()
			wait(0)
			sampSendDialogResponse(id, 0, nil, nil)
		end)
		
		return false
	end
	
	if id == 25637 and run_sob then
		sampSendDialogResponse(25637, 1, 0, -1)
		return false
	end
	if id == 25229 and run_sob then
		if text:find('Состоит в ЧС') then
			sob_info.blacklist = 0
			for line in text:gmatch('[^\n]+') do
				if line:match('{FFFFFF}Состоит в ЧС{FF6200}') then
					local bool_sob_info = line:match('{FFFFFF}Состоит в ЧС{FF6200}(.+)')
					table.insert(sob_info.bl_info, bool_sob_info)
				end
			end
		else
			sob_info.blacklist = 1
		end
		if setting.sob.close_doc then
			return false
		end
	end
	if id == 26035 and nickname_dialog and time_dialog_nickname < 4 then
		nickname_dialog = false
		nickname_dialog2 = true
		time_dialog_nickname = 20
		sampSendDialogResponse(26035, 1, 8, -1)
		
		return false
	end
	if id == 26035 and nickname_dialog4 then
		nickname_dialog4 = false
		return false
	end
	if id == 26036 and nickname_dialog3 then 
		nickname_dialog3 = false
		nickname_dialog4 = true
		if text:find('Отображение никнеймов	{CCCCCC}{B83434}%[ выключено %]') then
			sampAddChatMessage('[SH]{FFFFFF} Вы отключили показ никнеймов.', 0xFF5345)
		elseif text:find('Отображение никнеймов	{CCCCCC}{9ACD32}%[ включено %]') then
			sampAddChatMessage('[SH]{FFFFFF} Вы включили показ никнеймов.', 0xFF5345)
		end
		return false
	end
	if id == 26036 and nickname_dialog2 then
		nickname_dialog2 = false
		nickname_dialog3 = true
		sampSendDialogResponse(26036, 1, 5, -1)
		sampSendDialogResponse(26036, 0, 2, -1)
		return false
	end
	if title == "{BFBBBA}{73B461}Продажа лицензии" and num_give_lic > -1 then
		sampSendDialogResponse(id, 1, num_give_lic, nil) 
		return false
	end
	if title == "{BFBBBA}{73B461}Выбор срока лицензий" and num_give_lic > -1 then
		sampSendDialogResponse(id, 1, num_give_lic_term, nil)
		num_give_lic = -1
		return false
	end
	if id == 3501 and num_give_gov > -1 then
		sampSendDialogResponse(3501, 1, num_give_gov, nil)
		num_give_gov = -1
		return false
	end
	
	if title:find('Список происшествий') and setting.godeath.func then
		dialog_fire = {
			id = id,
			text = {}
		}
		
		for line in text:gmatch('[^\r\n]+') do
			if not line:find('Ранг') then
				table.insert(dialog_fire.text, line)
			end
		end
		
		if setting.fire.auto_select_fires then
			reply_from_choice_fires_dialog(0)
			
			sampSendDialogResponse(id, 1, 0, nil)
			return false
		end
	end
end

function reply_from_choice_fires_dialog(list_id)
	level_fire = 1
	local text_dialog = dialog_fire.text[list_id + 1]
	if text_dialog:find('В данный момент все спокойно') then
		return false
	end
	local function count_stars(text_star)
		local count = 0
		if text_star ~= nil and text_star ~= '' then
			for _ in string.gmatch(text_star, '%*') do
				count = count + 1
			end
			
			return count
		else
			return 1
		end
	end
	
	local function tags_sub(text_sub)
		if text_sub:find('%{mynickrus%}') then
			text_sub = text_sub:gsub('%{mynickrus%}', setting.name_rus)
		end
		if text_sub:find('%{myid%}') then
			text_sub = text_sub:gsub('%{myid%}', tostring(my.id))
		end
		if text_sub:find('%{mynick%}') then
			text_sub = text_sub:gsub('%{mynick%}', my.nick)
		end
		if text_sub:find('%{level%}') then
			text_sub = text_sub:gsub('%{level%}', tostring(level_fire))
		end
		if text_sub:find('%{rank%}') then
			text_sub = text_sub:gsub('%{rank%}', setting.job_title)
		end
		if text_sub:find('%{myrank%}') then
			text_sub = text_sub:gsub('%{myrank%}', setting.job_title)
		end
		
		return text_sub
	end
	
	if text_dialog ~= '' then
		level_fire = count_stars(text_dialog)
	end
	local text_fire = u8:decode(setting.text_fires)
	
	if setting.fire.auto_send and thread:status() == 'dead' then
		thread = lua_thread.create(function()
		wait(600)
			sampSendChat(tags_sub(text_fire))
		end)
	end
end

function process_string(input_text)
	local cleaned = input_text:gsub('[^%d]', '')
	local number = tonumber(cleaned)
	
	return number
end

function split_text_message(input, max_length)
	if #input <= max_length then
		return false, input 
	end
	
	local result = {}
	local currentLine = ''
	
	for word in input:gmatch('%S+') do
		if #currentLine + #word + 1 <= max_length then
			currentLine = currentLine == '' and word or (currentLine .. ' ' .. word)
		else
			table.insert(result, currentLine .. ' ...')
			currentLine = '... ' .. word
		end
	end
	
	table.insert(result, currentLine)
	
	return true, result
end
function hook.onSendDialogResponse(id, button_id, list_id, input)
	if id == dialog_fire.id and button_id == 1 and setting.godeath.func then
		reply_from_choice_fires_dialog(list_id)
	end
end

function hook.onSendChat(message)
	local message_end = ''
	
	if setting.accent.func then
		if message == ')' or message == '(' or message ==  '))' or message == '((' or message == 'xD' or message == ':D' or message == ':d' or message == 'XD' or message == ':)' or message == ':(' then return {message} end
		
		if setting.accent.text ~= '' then
			message_end = '[' .. u8:decode(setting.accent.text) .. ' акцент]: ' .. message
		end
	end
	
	if setting.chat_corrector and message:sub(1,1) ~= '/' then
		local text_correct = (message_end == '') and message or message_end
		local corrected_text = correct_chat(text_correct)
		if corrected_text ~= text_correct then
			sampSendChat(corrected_text)
			return false
		end
	end
	if setting.wrap_text_chat.func then
		local char_num = process_string(setting.wrap_text_chat.num_char)
		
		if char_num then
			local exceeded, result = split_text_message(message, char_num)
			
			if exceeded then
				lua_thread.create(function()
					for i = 2, #result do
						wait(2200)
						sampSendChat(result[i])
					end
				end)
				message_end = result[1]
			end
		end
	end
	
	if message_end ~= '' then
		return {message_end}
	end
end

function extractCommandArgument(text)
	local command, argument = text:match('^/(%S+)%s+(.*)$')
	return argument
end

function hook.onSendCommand(cmd)
	local message_array = {}
	local message_end = ''
	if cmd:find('/r ') then
		if setting.auto_cmd_r ~= '' and setting.auto_cmd_r ~= ' ' then
			table.insert(message_array, u8:decode(setting.auto_cmd_r))
		end
	end
	if cmd:find('/time') then
		if setting.auto_cmd_time ~= '' and setting.auto_cmd_time ~= ' ' then
			table.insert(message_array, u8:decode(setting.auto_cmd_time))
		end
	end
		
	if setting.chat_corrector then
		local command_ch = {r=true, s=true, c=true, b=true, rb=true, vr=true, fam=true}
		local command, argument = cmd:match('/(%S+)%s*(.*)')

		if command and command_ch[command] and argument ~= '' then
			local corrected_arg = correct_chat(argument)
			if corrected_arg ~= argument then
				message_end = '/' .. command .. ' ' .. corrected_arg
			end
		end
	end

	if setting.auto_edit then
		if cmd:find('/do (.+)') or cmd:find('/me (.+)') or cmd:find('/todo (.+)') then
			local result_cmd = cmd:gsub('^([\\/])(.*)', function(first_slash, rest)
				return first_slash .. rest:gsub('[\\/]', '')
			end)
			message_end = check_and_correct(result_cmd)
		end
	end
	
	if setting.wrap_text_chat.func then
		local char_num = process_string(setting.wrap_text_chat.num_char)
		
		if char_num then
			local exceeded, result
			if message_end == '' then
				exceeded, result = split_text_message(cmd, char_num)
			else
				exceeded, result = split_text_message(message_end, char_num)
			end
			
			if exceeded then
				local command, argument = result[1]:match('^/(%S+)%s+(.*)$')
				for i = 2, #result do
					table.insert(message_array, '/' .. command .. ' ' .. result[i])
				end
				
				message_end = result[1]
			end
		end
	end
	
	if #message_array ~= 0 then
		lua_thread.create(function()
			for i = 1, #message_array do
				wait(2000)
				sampSendChat(message_array[i])
			end
		end)
	end
	
	if message_end ~= '' then
		return {message_end}
	end
end

--> Из верхнего регистра в нижний
function to_lowercase(str)
	return (str:gsub('[А-ЯЁ]', function(c)
		if c == 'Ё' then
			return 'ё'
		else
			return string.char(c:byte() + 32)
		end
	end))
end

function check_and_correct(variable)
	local function to_upper(char)
		local map = {
			['а']='А', ['б']='Б', ['в']='В', ['г']='Г', ['д']='Д', ['е']='Е', ['ё']='Ё', ['ж']='Ж', ['з']='З', ['и']='И',
			['й']='Й', ['к']='К', ['л']='Л', ['м']='М', ['н']='Н', ['о']='О', ['п']='П', ['р']='Р', ['с']='С', ['т']='Т',
			['у']='У', ['ф']='Ф', ['х']='Х', ['ц']='Ц', ['ч']='Ч', ['ш']='Ш', ['щ']='Щ', ['ъ']='Ъ', ['ы']='Ы', ['ь']='Ь',
			['э']='Э', ['ю']='Ю', ['я']='Я'
		}
		return map[char] or char:upper()
	end

	local function to_lower(char)
		local map = {
			['А']='а', ['Б']='б', ['В']='в', ['Г']='г', ['Д']='д', ['Е']='е', ['Ё']='ё', ['Ж']='ж', ['З']='з', ['И']='и',
			['Й']='й', ['К']='к', ['Л']='л', ['М']='м', ['Н']='н', ['О']='о', ['П']='п', ['Р']='р', ['С']='с', ['Т']='т',
			['У']='у', ['Ф']='ф', ['Х']='х', ['Ц']='ц', ['Ч']='ч', ['Ш']='ш', ['Щ']='щ', ['Ъ']='ъ', ['Ы']='ы', ['Ь']='ь',
			['Э']='э', ['Ю']='ю', ['Я']='я'
		}
		
		return map[char] or char:lower()
	end
	if type(variable) ~= 'string' then
		return variable
	end
	
	if variable:match('^/do (.+)%/') then
		variable = string.sub(variable, 1, -2)
	end
	
	if variable:match('^/me (.+)') then
		local text = variable:sub(5)
		text = text:gsub('^.', to_lower)
		text = text:gsub('%.$', '')
		
		return '/me ' .. text
	elseif variable:match('^/do (.+)') then
		local text = variable:sub(5)
		text = text:gsub('^.', to_upper)
		if not text:find('%.$') and not text:find('[!?]$') then
			text = text .. '.'
		end
		
		return '/do ' .. text
	 elseif variable:match('^/todo (.+)%*(.+)') then
		local text = variable:sub(7)
		text = text:gsub('^.', to_upper)
		local text2 = text:gsub('(.+)*', '')
		text2 = text2:gsub('^.', to_lower)
		text = text:gsub('%*(.+)', '')
		
		return '/todo ' .. text .. '*' .. text2
	end

	return variable
end


function onWindowMessage(msg, wparam, lparam)
    if wparam == 0x1B and not isPauseMenuActive() then
        if off_scene or scene_active then
            consumeWindowMessage(true, false)
            windows.main[0] = true
            off_scene = false
        elseif not isPlayerControlLocked() then
            if smartFastState.isActive then
                consumeWindowMessage(true, false)
                if smartFastState.anim then
                    smartFastState.anim.is_closing = true
                    smartFastState.anim.is_opening = false
                end
                smartFastState.selectedPlayer = nil
                targ_id = nil
            end
            if old_fast_state.isActive then
                consumeWindowMessage(true, false)
                old_fast_state.isActive = false
                windows.fast[0] = false
                old_fast_state.id = -1
                old_fast_state.nick = 'No_Name'
                targ_id = nil
            end
            if windows.smart_su[0] then
                consumeWindowMessage(true, false)
                smartSuState.anim.is_closing = true
                smartSuState.anim.is_opening = false
            end
            if windows.smart_ticket[0] then
                consumeWindowMessage(true, false)
                smartTicketState.anim.is_closing = true
                smartTicketState.anim.is_opening = false
            end
			if windows.smart_punish[0] then
                consumeWindowMessage(true, false)
                smartPunishState.anim.is_closing = true
                smartPunishState.anim.is_opening = false
            end
            if windows.shpora[0] then
                consumeWindowMessage(true, false)
                windows.shpora[0] = false
            elseif windows.main[0] then
                consumeWindowMessage(true, false)
                close_win.main = true
            end
        end
    end
end

function draw_wrapped_text(text, x, y, wrap_width, line_spacing) --> Перенос текста по его длине в пикселях (текст, позиция, длина x, интервал y)
	local words = {}
	for word in text:gmatch('%S+') do
		table.insert(words, word)
	end
	
	local currentLine = ''
	local currentY = y
	
	for _, word in ipairs(words) do
		local nextLine = currentLine .. (currentLine ~= '' and ' ' or '') .. word
		local textWidth = imgui.CalcTextSize(nextLine).x
		if textWidth > wrap_width then
			imgui.SetCursorPos(imgui.ImVec2(x, currentY))
			imgui.Text(currentLine)
			currentLine = word
			currentY = currentY + line_spacing
		else
			currentLine = nextLine
		end
	end
	
	if currentLine ~= '' then
		imgui.SetCursorPos(imgui.ImVec2(x, currentY))
		imgui.Text(currentLine)
	end
	
	return currentY
end

function imgui.TextColoredRGB(string, max_float)
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local u8 = require 'encoding'.UTF8

	local function color_imvec4(color)
		if color:upper():sub(1, 6) == 'SSSSSS' then return imgui.ImVec4(colors[clr.Text].x, colors[clr.Text].y, colors[clr.Text].z, tonumber(color:sub(7, 8), 16) and tonumber(color:sub(7, 8), 16)/255 or colors[clr.Text].w) end
		local color = type(color) == 'number' and ('%X'):format(color):upper() or color:upper()
		local rgb = {}
		for i = 1, #color/2 do rgb[#rgb+1] = tonumber(color:sub(2*i-1, 2*i), 16) end
		return imgui.ImVec4(rgb[1]/255, rgb[2]/255, rgb[3]/255, rgb[4] and rgb[4]/255 or colors[clr.Text].w)
	end

	local function render_text(string)
		for w in string:gmatch('[^\r\n]+') do
			local text, color = {}, {}
			local render_text = 1
			local m = 1
			if w:sub(1, 8) == '[center]' then
				render_text = 2
				w = w:sub(9)
			elseif w:sub(1, 7) == '[right]' then
				render_text = 3
				w = w:sub(8)
			end
			w = w:gsub('{(......)}', '{%1FF}')
			while w:find('{........}') do
				local n, k = w:find('{........}')
				if tonumber(w:sub(n+1, k-1), 16) or (w:sub(n+1, k-3):upper() == 'SSSSSS' and tonumber(w:sub(k-2, k-1), 16) or w:sub(k-2, k-1):upper() == 'SS') then
					text[#text], text[#text+1] = w:sub(m, n-1), w:sub(k+1, #w)
					color[#color+1] = color_imvec4(w:sub(n+1, k-1))
					w = w:sub(1, n-1)..w:sub(k+1, #w)
					m = n
				else w = w:sub(1, n-1)..w:sub(n, k-3)..'}'..w:sub(k+1, #w) end
			end
			local length = imgui.CalcTextSize(u8(w))
			if render_text == 2 then
				imgui.NewLine()
				imgui.SameLine(max_float / 2 - ( length.x / 2 ))
			elseif render_text == 3 then
				imgui.NewLine()
				imgui.SameLine(max_float - length.x - 5 )
			end
			if text[0] then
				for i, k in pairs(text) do
					imgui.TextColored(color[i] or colors[clr.Text], u8(k))
					imgui.SameLine(nil, 0)
				end
				imgui.NewLine()
			else 
				imgui.Text(u8(w))
			end
		end
	end
	render_text(string)
end

--> Фукция анимации с использованием математической линейной интерполяции
function animate(start_x, start_y, x_end, y_end, target_x, target_y, duration, ease_factor)
	local elapsed_time = 0
	local current_x, current_y = start_x, start_y
	local delta_x, delta_y = x_end - start_x, y_end - start_y
	
	return function()
		if elapsed_time < duration then
			elapsed_time = elapsed_time + anim
			local t = math.min(elapsed_time / duration, 1)
			local easedT = 1 - (1 - t) ^ ease_factor
			
			current_x = start_x + delta_x * easedT
			current_y = start_y + delta_y * easedT
			
			_G[target_x] = current_x
			_G[target_y] = current_y
			
			return current_x, current_y
		else
			_G[target_x] = x_end
			_G[target_y] = y_end
			
			return x_end, y_end
		end
	end
end

ANIMATE = {
	[1] = animate(0, 0, 42, 42, an[27], an[27], 1, 4),
	[2] = animate(42, 42, 0, 0, an[27], an[27], 1, 4),
	[3] = animate(0, 0, 0, 0, an[28], an[28], 1, 4),
	[4] = animate(806, 806, 806, 806, an[28], an[28], 1, 4)
}

function time()
	local function get_weekday(year, month, day)
		local weekday = tonumber(os.date('%w', os.time{year = year, month = month, day = day}))
		if weekday == 0 then
			weekday = 7
		end
		return weekday
	end
	
	local function parse_date(date_str)
		local day, month, year = date_str:match('(%d%d)%.(%d%d)%.(%d%d)')
		return os.time({ day = tonumber(day), month = tonumber(month), year = 2000 + tonumber(year), hour = 0, min = 0, sec = 0 })
	end
	
	local function shift_table(tbl)
		for i = #tbl, 2, -1 do
			tbl[i] = tbl[i - 1]
		end
		tbl[1] = 0
		return tbl
	end

	local function is_recurring(reminder)
		if not reminder or not reminder.repeats then return false end
		for _, repeats_today in ipairs(reminder.repeats) do
			if repeats_today then
				return true
			end
		end
		return false
	end

	while true do
		wait(1000)
		local today_date_parsed = parse_date(os.date('%d.%m.%y'))
		local yesterday_date_parsed = parse_date(setting.stat.today)
		time_save = time_save + 1
		if time_save > 40 then
			time_save = 0
			save()
		end

		if search_for_new_version > 0 then
			search_for_new_version = search_for_new_version - 1
		end
		
		if wait_book[1] > 0 then
			wait_book[1] = wait_book[1] - 1
			if wait_book[1] == 0 then
				wait_book[2] = false
			end
		end
		
		if wait_mb > 0 then
			wait_mb = wait_mb - 1
		end

		if wanted_wait.checking and wanted_wait.timeout ~= 0 and os.clock() > wanted_wait.timeout then
		
			wanted_wait.checking = false
			wanted_wait.timeout = 0
			wanted_wait.page = 0
		end

		if developer_mode > 0 then
			developer_mode = developer_mode - 1
		end
		
		if timer_send > 0 then
			timer_send = timer_send - 1
		elseif confirm_action_dialog then
			if setting.show_dialog_auto then
				sampSendDialogResponse(27337, 1, 5, nil)
			end
			if setting.auto_cmd_doc and thread:status() == 'dead' then
				send_chat_rp = true
			end
			confirm_action_dialog = false
		end

		if anti_spam_gun[3] > 0 then
			anti_spam_gun[3] = anti_spam_gun[3] - 1
		end
		
		if update_request > 0 then
			if update_request == 1 then
				error_update = true
			end
			update_request = update_request -1
		end
		
		if update_scr_check > 0 then
			update_scr_check = update_scr_check - 1
		end
		
		if close_stats and not isGamePaused() and not isPauseMenuActive() then
			sampSendChat('/stats')
		end
		
		if replace_not_flood[1] > 0 then
			replace_not_flood[1] = replace_not_flood[1] - 1
		end
		
		if isGamePaused() or isPauseMenuActive() then
			if setting.kick_afk.func and setting.kick_afk.time_kick ~= '' and tonumber(setting.kick_afk.time_kick) > 0 then
				if not is_afk then
					is_afk = true
					afk_start_time = os.clock()
				end
				local afk_duration_seconds = os.clock() - afk_start_time
				local afk_limit_seconds = tonumber(setting.kick_afk.time_kick) * 60
				if afk_duration_seconds >= afk_limit_seconds then
					if setting.kick_afk.mode == 2 then
						if not close_serv then
							close_connect()
							close_serv = true
							track_time = false
						end
					else
						shell32.ShellExecuteA(nil, "open", "mshta.exe", 'vbscript:CreateObject("WScript.Shell").Popup("StateHelper: Игра была закрыта из-за превышения лимита AFK.",0,"StateHelper",0)(window.close)', nil, 0)
						wait(1000)
						shell32.ShellExecuteA(nil, "open", "taskkill.exe", "/F /IM gta_sa.exe", nil, 0)
					end
				end
			end
		else
			if is_afk then
				is_afk = false
				afk_start_time = 0
			end
		end
		
		if sampGetGamestate() == 3 then
			if #setting.reminder > 0 then
				local current_date_full = os.date('%d.%m.%Y.%H.%M')
				local h_min_date = os.date('%H:%M')
				local current_day_of_year = os.date('%j')
				local current_weekday = os.date('*t').wday
				local today_week = (current_weekday == 1 and 7 or current_weekday - 1)

				for i = #setting.reminder, 1, -1 do
					local reminder = setting.reminder[i]
					local date_reminder_full = string.format('%02d.%02d.%d.%02d.%02d', reminder.day, reminder.mon, reminder.year, reminder.hour, reminder.min)
					
					local one_time = not is_recurring(reminder)

					if one_time and date_reminder_full == current_date_full then
						text_reminder = reminder.text
						windows.reminder[0] = true
						if reminder.sound then
							lua_thread.create(function()
								local stop_signal = 0
								repeat wait(200) 
									addOneOffSound(0, 0, 0, 1057)
									stop_signal = stop_signal + 1
								until stop_signal > 17
							end)
						end
						table.remove(setting.reminder, i)
						save()
					elseif not one_time then
						local h_min_reminder = string.format('%02d:%02d', reminder.hour, reminder.min)
						if h_min_date == h_min_reminder and reminder.repeats[today_week] then
							if reminder.last_triggered_day ~= current_day_of_year then
								reminder.last_triggered_day = current_day_of_year
								text_reminder = reminder.text
								windows.reminder[0] = true
								if reminder.sound then
									lua_thread.create(function()
										local stop_signal = 0
										repeat wait(200) 
											addOneOffSound(0, 0, 0, 1057)
											stop_signal = stop_signal + 1
										until stop_signal > 17
									end)
								end
								save()
							end
						end
					end
				end
			end
		end
		
		if yesterday_date_parsed < today_date_parsed then
			setting.stat.cl = shift_table(setting.stat.cl)
			setting.stat.afk = shift_table(setting.stat.afk)
			setting.stat.day = shift_table(setting.stat.day)
			setting.stat.date_week = shift_table(setting.stat.date_week)
			setting.stat.date_week[1] = os.date('%d.%m.%y')
			setting.stat.today = os.date('%d.%m.%y')
			for i = 1, #setting.reminder do
				setting.reminder[i].last_triggered_day = nil
			end
			save()
		end
		
		if track_time then
			if isGamePaused() or isPauseMenuActive() then
				setting.stat.afk[1] = setting.stat.afk[1] + 1
				setting.stat.day[1] = setting.stat.day[1] + 1
				setting.stat.all = setting.stat.all + 1
				stat_ses.afk = stat_ses.afk + 1
				stat_ses.all = stat_ses.all + 1
			else
				setting.stat.cl[1] = setting.stat.cl[1] + 1
				setting.stat.day[1] = setting.stat.day[1] + 1
				setting.stat.all = setting.stat.all + 1
				stat_ses.cl = stat_ses.cl + 1
				stat_ses.all = stat_ses.all + 1
			end
		end

		if time_dialog_nickname < 6 then
			time_dialog_nickname = time_dialog_nickname + 1
		elseif time_dialog_nickname >= 6 and time_dialog_nickname <= 10 then
			nickname_dialog = false
		end
		
		if new_version ~= '0' then
			update_scr_check = 10000
		end
	end
end

function mini_player_position()
	lua_thread.create(function()
		is_mini_player_pos = true
		local backup_pos = {
			x = setting.mini_player_pos and setting.mini_player_pos.x or sx / 2,
			y = setting.mini_player_pos and setting.mini_player_pos.y or sy - 60
		}
		local original_player_state = windows.player[0]
		windows.player[0] = true
		windows.main[0] = false
		sampSetCursorMode(4)
		if not setting.cef_notif then
			sampAddChatMessage('[SH]{FFFFFF} Нажмите {FF6060}ЛКМ{FFFFFF}, чтобы применить или {FF6060}ESC{FFFFFF} для отмены.', 0xFF5345)
		else
			cefnotig('{FF5345}[SH]{FFFFFF} Нажмите {FF6060}ЛКМ{FFFFFF}, чтобы применить или {FF6060}ESC{FFFFFF} для отмены.', 3000)
		end
		while true do
			wait(0)
			local cX, cY = getCursorPos()
			if not setting.mini_player_pos then
				setting.mini_player_pos = {}
			end
			setting.mini_player_pos.x = cX
			setting.mini_player_pos.y = cY

			if isKeyJustPressed(VK_LBUTTON) then
				save()
				if not setting.cef_notif then
					sampAddChatMessage('[SH]{FFFFFF} Позиция мини-плеера сохранена.', 0xFF5345)
				else
					cefnotig('{FF5345}[SH]{FFFFFF} Позиция мини-плеера сохранена.', 3000)
				end
				break
			elseif isKeyJustPressed(VK_ESCAPE) then
				setting.mini_player_pos = backup_pos
				if not setting.cef_notif then
					sampAddChatMessage('[SH]{FFFFFF} Изменение позиции отменено.', 0xFF5345)
				else
					cefnotig('{FF5345}[SH]{FFFFFF} Изменение позиции отменено.', 3000)
				end
				break
			end
		end
		sampSetCursorMode(0)
		windows.main[0] = true
		windows.player[0] = original_player_state
		if play.status == 'NULL' then
			windows.player[0] = false
		end
		is_mini_player_pos = false
	end)
end

function connetion()
	if sampGetGamestate() == 1 or sampGetGamestate() == 2 or sampGetGamestate() == 4 or sampGetGamestate() == 5 then
		if track_time then
			track_time = false
			sampAddChatMessage(string.format('[SH]{FFFFFF} Отсчёт времени остановлен до момента подключения к серверу.'), 0xFF5345)
		end
	elseif sampGetGamestate() == 3 and sampIsLocalPlayerSpawned() and not track_time then
		track_time = true
	end
end

function close_connect()
	raknetEmulPacketReceiveBitStream(PACKET_DISCONNECTION_NOTIFICATION, raknetNewBitStream())
	raknetDeleteBitStream(raknetNewBitStream())
	track_time = false
	sampAddChatMessage(string.format('[SH]{FFFFFF} Вы отключены от сервера. Отсчёт времени остановлен.'), 0xFF5345)
end

function removeDecimalPart(value)
	local dotPosition = string.find(value, '%.')
	if not dotPosition then
		return value
	end
	
	return string.sub(value, 1, dotPosition - 1)
end

--> Сцена
script_cursor_sc = false
speed = 0.25
function scene_work()
	if scene_active then
		setVirtualKeyDown(0x79, true)
		cam_hack()
	end
	local X, Y = scene.x, scene.y
	for i, sc in ipairs(scene.rp) do
		local color = changeColorAlpha(sc.color, scene.vis * 2.55)
		local text_end = u8:decode(sc.text1)
		
		if sc.var == 2 then
			text_end = '{FFFFFF}' .. u8:decode(sc.nick) .. ' говорит: ' .. u8:decode(sc.text1)
		elseif sc.var == 3 then
			text_end = '{FF99FF}' .. u8:decode(sc.nick) .. ' ' .. u8:decode(sc.text1)
		elseif sc.var == 4 then
			text_end = '{4682b4}' .. u8:decode(sc.text1) .. ' | ' .. u8:decode(sc.nick)
		elseif sc.var == 5 then
			text_end = '{FFFFFF}' .. u8:decode(sc.text1) .. ' - сказал(а) ' .. u8:decode(sc.nick) .. ', {FF99FF}' .. u8:decode(sc.text2)
		elseif sc.var == 6 then
			text_end = '{73B461}[Тел]:{FFFFFF} ' .. u8:decode(sc.nick) .. ' - ' .. u8:decode(sc.text1)
		end
		
		if scene.invers then
			renderFontDrawClickableText(script_cursor_sc, font_sc, text_end, X, Y, color, color, 3, true)
		else
			renderFontDrawClickableText(script_cursor_sc, font_sc, text_end, X, Y, color, color, 4, true)
		end
		Y = Y + scene.dist
	end
	if scene_active then
		if isKeyDown(0x01) or isKeyJustPressed(VK_ESCAPE) then
			if ui_state then
				evalanon("document.body.style.display = 'block'")
				ui_state = false
			end
			off_scene = true
			setVirtualKeyDown(0x79, false)
			scene_active = false
			sampSetCursorMode(0)
			windows.main[0] = true
			imgui.ShowCursor = true
			displayRadar(true)
			displayHud(true)
			radarHud = 0
			angPlZ = angZ * -1.0
			lockPlayerControl(false)
			restoreCameraJumpcut()
			setCameraBehindPlayer()
		end
	end
end

function scene_edit()
	scene_edit_pos = true
	setVirtualKeyDown(0x79, true)
	pos_sc = lua_thread.create(function()
		local backup = {
			['x'] = scene.x,
			['y'] = scene.y
		}
		local pos_sc_edit = true
		sampSetCursorMode(4)
		windows.main[0] = false
		if not sampIsChatInputActive() then
			while not sampIsChatInputActive() and pos_sc_edit do
				wait(0)
				local cX, cY = getCursorPos()
				scene.x = cX
				scene.y = cY
				if isKeyDown(0x01) then
					while isKeyDown(0x01) or isKeyDown(0x0D) do wait(0) end
					pos_sc_edit = false
				elseif isKeyJustPressed(VK_ESCAPE) then
					pos_sc_edit = false
					scene.x = backup['x']
					scene.y = backup['y']
				end
			end
		end
		sampSetCursorMode(0)
		setVirtualKeyDown(0x79, false)
		scene_edit_pos = false
		windows.main[0] = true
		imgui.ShowCursor = true
		pos_sc_edit = false
	end)
end

--> Кам-Хак
function cam_hack()
	if not sampIsChatInputActive() and not isSampfuncsConsoleActive() then
		if not ui_state then
			evalanon("document.body.style.display = 'none'")
			ui_state = true
		end
		offMouX, offMouY = getPcMouseMovement()
		angZ = (angZ + offMouX/4.0) % 360.0
		angY = math.min(89.0, math.max(-89.0, angY + offMouY/4.0))
		radZ, radY = math.rad(angZ), math.rad(angY)
		sinZ, cosZ = math.sin(radZ), math.cos(radZ)
		sinY, cosY = math.sin(radY), math.cos(radY)
		sinZ, cosZ, sinY = sinZ * cosY, cosZ * cosY, sinY * 1.0
		poiX, poiY, poiZ = posX + sinZ, posY + cosZ, posZ + sinY
		pointCameraAtPoint(poiX, poiY, poiZ, 2)
		curZ = angZ + 180.0
		curY = angY * -1.0
		radZ = math.rad(curZ)
		radY = math.rad(curY)
		sinZ = math.sin(radZ)
		cosZ = math.cos(radZ)
		sinY = math.sin(radY)
		cosY = math.cos(radY)
		sinZ = sinZ * cosY
		cosZ = cosZ * cosY
		sinZ = sinZ * 10.0
		cosZ = cosZ * 10.0
		sinY = sinY * 10.0
		posPlX = posX + sinZ
		posPlY = posY + cosZ
		posPlZ = posZ + sinY
		angPlZ = angZ * -1.0
		radZ, radY = math.rad(angZ), math.rad(angY)
		sinZ, cosZ = math.sin(radZ), math.cos(radZ)
		sinY, cosY = math.sin(radY), math.cos(radY)
		sinZ, cosZ, sinY = sinZ * cosY, cosZ * cosY, sinY * 1.0
		poiX, poiY, poiZ = posX + sinZ, posY + cosZ, posZ + sinY
		pointCameraAtPoint(poiX, poiY, poiZ, 2)

		if isKeyDown(VK_W) then
			radZ = math.rad(angZ)
			radY = math.rad(angY)
			sinZ = math.sin(radZ)
			cosZ = math.cos(radZ)
			sinY = math.sin(radY)
			cosY = math.cos(radY)
			sinZ = sinZ * cosY
			cosZ = cosZ * cosY
			sinZ = sinZ * speed
			cosZ = cosZ * speed
			sinY = sinY * speed
			posX = posX + sinZ
			posY = posY + cosZ
			posZ = posZ + sinY
			setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
		end
		radZ, radY = math.rad(angZ), math.rad(angY)
		sinZ, cosZ = math.sin(radZ), math.cos(radZ)
		sinY, cosY = math.sin(radY), math.cos(radY)
		sinZ, cosZ, sinY = sinZ * cosY, cosZ * cosY, sinY * 1.0
		poiX, poiY, poiZ = posX + sinZ, posY + cosZ, posZ + sinY
		pointCameraAtPoint(poiX, poiY, poiZ, 2)

		if isKeyDown(VK_S) then
			curZ = angZ + 180.0
			curY = angY * -1.0
			radZ = math.rad(curZ)
			radY = math.rad(curY)
			sinZ = math.sin(radZ)
			cosZ = math.cos(radZ)
			sinY = math.sin(radY)
			cosY = math.cos(radY)
			sinZ = sinZ * cosY
			cosZ = cosZ * cosY
			sinZ = sinZ * speed
			cosZ = cosZ * speed
			sinY = sinY * speed
			posX = posX + sinZ
			posY = posY + cosZ
			posZ = posZ + sinY
			setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
		end
		radZ, radY = math.rad(angZ), math.rad(angY)
		sinZ, cosZ = math.sin(radZ), math.cos(radZ)
		sinY, cosY = math.sin(radY), math.cos(radY)
		sinZ, cosZ, sinY = sinZ * cosY, cosZ * cosY, sinY * 1.0
		poiX, poiY, poiZ = posX + sinZ, posY + cosZ, posZ + sinY
		pointCameraAtPoint(poiX, poiY, poiZ, 2)

		if isKeyDown(VK_A) then
			curZ = angZ - 90.0
			radZ = math.rad(curZ)
			radY = math.rad(angY)
			sinZ = math.sin(radZ)
			cosZ = math.cos(radZ)
			sinZ = sinZ * speed
			cosZ = cosZ * speed
			posX = posX + sinZ
			posY = posY + cosZ
			setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
		end
		radZ, radY = math.rad(angZ), math.rad(angY)
		sinZ, cosZ = math.sin(radZ), math.cos(radZ)
		sinY, cosY = math.sin(radY), math.cos(radY)
		sinZ, cosZ, sinY = sinZ * cosY, cosZ * cosY, sinY * 1.0
		poiX, poiY, poiZ = posX + sinZ, posY + cosZ, posZ + sinY
		pointCameraAtPoint(poiX, poiY, poiZ, 2)

		if isKeyDown(VK_D) then
			curZ = angZ + 90.0
			radZ = math.rad(curZ)
			radY = math.rad(angY)
			sinZ = math.sin(radZ)
			cosZ = math.cos(radZ)
			sinZ = sinZ * speed
			cosZ = cosZ * speed
			posX = posX + sinZ
			posY = posY + cosZ
			setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
		end
		radZ, radY = math.rad(angZ), math.rad(angY)
		sinZ, cosZ = math.sin(radZ), math.cos(radZ)
		sinY, cosY = math.sin(radY), math.cos(radY)
		sinZ, cosZ, sinY = sinZ * cosY, cosZ * cosY, sinY * 1.0
		poiX, poiY, poiZ = posX + sinZ, posY + cosZ, posZ + sinY
		pointCameraAtPoint(poiX, poiY, poiZ, 2)

		if isKeyDown(VK_SHIFT) then
			posZ = posZ + speed
			setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
		end
		radZ, radY = math.rad(angZ), math.rad(angY)
		sinZ, cosZ = math.sin(radZ), math.cos(radZ)
		sinY, cosY = math.sin(radY), math.cos(radY)
		sinZ, cosZ, sinY = sinZ * cosY, cosZ * cosY, sinY * 1.0
		poiX, poiY, poiZ = posX + sinZ, posY + cosZ, posZ + sinY
		pointCameraAtPoint(poiX, poiY, poiZ, 2)

		if isKeyDown(VK_CONTROL) then
			posZ = posZ - speed
			setFixedCameraPosition(posX, posY, posZ, 0.0, 0.0, 0.0)
		end
		radZ, radY = math.rad(angZ), math.rad(angY)
		sinZ, cosZ = math.sin(radZ), math.cos(radZ)
		sinY, cosY = math.sin(radY), math.cos(radY)
		sinZ, cosZ, sinY = sinZ * cosY, cosZ * cosY, sinY * 1.0
		poiX, poiY, poiZ = posX + sinZ, posY + cosZ, posZ + sinY
		pointCameraAtPoint(poiX, poiY, poiZ, 2)

		if isKeyDown(VK_F10) then
			displayRadar(false)
			displayHud(false)
		else
			displayRadar(true)
			displayHud(true)
		end
	end
end

function hook.onSendAimSync()
	if camhack_active then
		return false
	end
end

function onScriptTerminate(script, quit)
	if script == thisScript() and not quit and camhack_active then
		displayRadar(true)
		displayHud(true)
		lockPlayerControl(false)
		restoreCameraJumpcut()
		setCameraBehindPlayer()
	end
end

function getTargetServerCoordinates()
	local pos_cord = {x = 0.0, y = 0.0, z = 0.0}
	local target_server = false
	for id = 0, 31 do
		local object_truct = 0xC7F168 + id * 56
		local object_truct_pos = {
			x = representIntAsFloat(readMemory(object_truct + 0, 4, false)),
			y = representIntAsFloat(readMemory(object_truct + 4, 4, false)),
			z = representIntAsFloat(readMemory(object_truct + 8, 4, false))
		}
		if object_truct_pos.x ~= 0.0 or object_truct_pos.y ~= 0.0 or object_truct_pos.z ~= 0.0 then
			pos_cord = {
				x = object_truct_pos.x,
				y = object_truct_pos.y,
				z = object_truct_pos.z
			}
			target_server = true
		end
	end
	
	return target_server, pos_cord.x, pos_cord.y, pos_cord.z
end

function measurement_coordinates(text_area, bool_int_or_around, location_city)
	local areas_and_coordinates = {
		{'Rodeo', {x = 379, y = -1449, z = 20}},
		{'Marina', {x = 771, y = -1585, z = 20}},
		{'Vinewood', {x = 799, y = -1154, z = 20}},
		{'Market', {x = 1191, y = -1406, z = 12}},
		{'Conference', {x = 1170, y = -1741, z = 20}},
		{'Verona Beach', {x = 830, y = -1860, z = 20}},
		{'Maria', {x = 415, y = -1852, z = 20}},
		{'Temple', {x = 1163, y = -1050, z = 20}},
		{'Mulholland', {x = 1177, y = -818, z = 68}},
		{'Verdant Bluffs', {x = 1221, y = -2084, z = 64}},
		{'Pershing', {x = 1477, y = -1649, z = 20}},
		{'Commerce', {x = 1603, y = -1481, z = 27}},
		{'Downtown Los', {x = 1617, y = -1265, z = 20}},
		{'Mulholland Intersection', {x = 1659, y = -947, z = 20}},
		{'International', {x = 1875, y = -2416, z = 20}},
		{'El Corona', {x = 1839, y = -1991, z = 20}},
		{'Little Mexico', {x = 1713, y = -1705, z = 20}},
		{'Idlewood', {x = 1923, y = -1571, z = 20}},
		{'Glen Park', {x = 1965, y = -1202, z = 20}},
		{'Jefferson', {x = 2205, y = -1395, z = 20}},
		{'Las Colinas', {x = 2429, y = -1059, z = 20}},
		{'Los Flores', {x = 2723, y = -1269, z = 20}},
		{'East Los', {x = 2524, y = -1533, z = 20}},
		{'Ganton', {x = 2412, y = -1729, z = 20}},
		{'Willowfield', {x = 2412, y = -1911, z = 20}},
		{'Ocean Docks', {x = 2776, y = -2530, z = 20}},
		{'Playa del Seville', {x = 2860, y = -1945, z = 20}},
		{'East Beach', {x = 2902, y = -1420, z = 20}},
		{'Northstar Rock', {x = 2112, y = -500, z = 20}},
		{'Palomino Creek', {x = 2510, y = -115, z = 20}},
		{'Hankypanky Point', {x = 2594, y = 183, z = 20}},
		{'Frederick Bridge', {x = 2762, y = 459, z = 20}},
		{'Montgomery Intersection', {x = 1722, y = 323, z = 20}},
		{'The Mako Span', {x = 1722, y = 505, z = 20}},
		{'Montgomery', {x = 1232, y = 407, z = 20}},
		{'Fern Ridge', {x = 817, y = 101, z = 20}},
		{'Hilltop Farm', {x = 1027, y = -257, z = 20}},
		{'Hampton Barns', {x = 649, y = 290, z = 20}},
		{'Blueberry', {x = 369, y = -192, z = 20}},
		{'Dillimore', {x = 660, y = -673, z = 20}},
		{'Richman', {x = 471, y = -954, z = 20}},
		{'Blueberry Acres', {x = -186, y = 180, z = 20}},
		{'The Panopticon', {x = -658, y = -53, z = 20}},
		{'Martin Bridge',  {x = -166, y = 363, z = 20}},
		{'Fallow Bridge', {x = 491, y = 500, z = 20}},
		{'Mount Chiliad', {x = -2608, y = -1514, z = 20}},
		{'Shady Creeks', {x = -1684, y = -1864, z = 20}},
		{'Shady Cabin', {x = -1642, y = -2284, z = 20}},
		{'Angel Pine', {x = -1880, y = -2494, z = 20}},
		{'Back o Beyond',  {x = -705, y = -2286, z = 20}},
		{'Leafy Hollow', {x = -1021, y = -1649, z = 20}},
		{'Flint Range', {x = -462, y = -1502, z = 20}},
		{'Flint Intersection', {x = -98, y = -1364, z = 20}},
		{'Beacon Hill', {x = -434, y = -1084, z = 20}},
		{'Flint County', {x = -434, y = -1084, z = 20}},
		{'The Farm', {x = -1180, y = -1028, z = 20}},
		{'Fallen Tree', {x = -560, y = -441, z = 20}},
		{'Easter Bay Chemicals', {x = -980, y = -539, z = 20}},
		{'Easter Tunnel', {x = -1452, y = -795, z = 20}},
		{'Easter Bay Airport', {x = -1340, y = -221, z = 20}},
		{'Foster Valley', {x = -1868, y = -978, z = 20}},
		{'Missionary Hill', {x = -2636, y = -624, z = 85}},
		{'Avispa Country Club', {x = -2678, y = -235, z = 20}},
		{'Ocean Flats', {x = -2748, y = 44, z = 20}},
		{'Hashbury', {x = -2482, y = 30, z = 20}},
		{'Doherty', {x = -2090, y = 72, z = 34}},
		{'Garcia', {x = -2244, y = 170, z = 20}},
		{'City Hall', {x = -2692, y = 380, z = 20}},
		{'Queens', {x = -2482, y = 422, z = 20}},
		{'King', {x = -2230, y = 436, z = 20}},
		{'Santa Flora', {x = -2594, y = 590, z = 20}},
		{'China Town', {x = -2314, y = 604, z = 20}},
		{'Downtown', {x = -1870, y = 674, z = 20}},
		{'Easter Basin', {x = -1520, y = 394, z = 20}},
		{'Palisades', {x = -2794, y = 758, z = 20}},
		{'Juniper Hill', {x = -2510, y = 758, z = 20}},
		{'Financial', {x = -1922, y = 884, z = 20}},
		{'Esplanade East', {x = -1698, y = 1323, z = 20}},
		{'Esplanade North', {x = -2076, y = 1351, z = 20}},
		{'Calton Neights', {x = -2230, y = 1085, z = 20}},
		{'Paradiso', {x = -2636, y = 1043, z = 20}},
		{'Juniper Hollow', {x = -2510, y = 1197, z = 20}},
		{'Kincaid Bridge', {x = -1208, y = 791, z = 20}},
		{'Garver', {x = -1236, y = 973, z = 20}},
		{'Gant Bridge', {x = -2664, y = 1816, z = 20}},
		{'Battery Point', {x = -2804, y = 1312, z = 20}},
		{'Bayside Marina', {x = -2354, y = 2328, z = 20}},
		{'Bayside Tunnel', {x = -1906, y = 2651, z = 20}},
		{'Bayside', {x = -2634, y = 2622, z = 20}}, 
		{'El Quebrados', {x = -1430, y = 2818, z = 20}},
		{'Aldea Malvada', {x = -1206, y = 2510, z = 20}},
		{'Valle Ocultado', {x = -835, y = 2746, z = 20}},
		{'Arco del', {x = -779, y = 2340, z = 20}},
		{'Las Barrancas', {x = -681, y = 1499, z = 20}},
		{'Sherman Dam', {x = -709, y = 2031, z = 20}},
		{'Las Brujas', {x = -459, y = 2269, z = 20}},
		{'El Castillo', {x = -249, y = 2423, z = 20}},
		{'Las Payasadas', {x = -179, y = 2818, z = 20}},
		{'Verdant Meadows', {x = 170, y = 2357, z = 20}},
		{'Regular Tom', {x = -319, y = 1881, z = 20}},
		{'Big Ear', {x = -221, y = 1545, z = 20}},
		{'Probe Inn', {x = 2, y = 1349, z = 20}},
		{'Green Palms', {x = 198, y = 1531, z = 20}},
		{'Octane Springs', {x = 520, y = 1503, z = 20}},
		{'Fort Carson', {x = -11, y = 971, z = 20}},
		{'Hunter Quarry', {x = 800, y = 816, z = 20}},
		{'Rockshore East', {x = 2781, y = 746, z = 20}}, 
		{'Rockshore West', {x = 2277, y = 704, z = 20}},
		{'Last Dime Motel', {x = 1913, y = 704, z = 20}},
		{'Randolph Ind', {x = 1689, y = 732, z = 20}},
		{'Blackfield Chapel', {x = 1409, y = 760, z = 20}},
		{'Thruway South', {x = 1801, y = 844, z = 20}},
		{'Blackfield Intersection', {x = 1231, y = 930, z = 20}},
		{'Greenglass College', {x = 1091, y = 1070, z = 20}},
		{'LVA Freight', {x = 1595, y = 1028, z = 20}},
		{'Four Dragons', {x = 1917, y = 1025, z = 20}},
		{'Come%-A%-Lot', {x = 2253, y = 1053, z = 20}},
		{'Linden Side', {x = 2895, y = 1049, z = 20}},
		{'Linden Station', {x = 2804, y = 1273, z = 9}},
		{'Camel\'s Toe', {x = 2300, y = 1273, z = 20}},
		{'Thruway East', {x = 2706, y = 1469, z = 12}},
		{'Pink Swan', {x = 1936, y = 1175, z = 20}},
		{'The Strip', {x = 2048, y = 1259, z = 20}},
		{'High Roller', {x = 1908, y = 1357, z = 20}},
		{'Pirates', {x = 1922, y = 1595, z = 20}},
		{'Las Venturas Airport', {x = 1558, y = 1539, z = 20}},
		{'LVA Airport', {x = 1558, y = 1539, z = 20}},
		{'Blackfield', {x = 1109, y = 1552, z = 20}},
		{'Royale Casino', {x = 2188, y = 1515, z = 20}},
		{'Caligula', {x = 2202, y = 1655, z = 20}},
		{'Pilgrim', {x = 2524, y = 1571, z = 6}},
		{'Sobell Rail', {x = 2888, y = 1795, z = 20}},
		{'Creek', {x = 2916, y = 2249, z = 20}},
		{'Ring Master', {x = 2258, y = 1815, z = 20}},
		{'Starfish Casino', {x = 2342, y = 1955, z = 20}},
		{'Old Venturas Strip', {x = 2384, y = 2179, z = 20}},
		{'Roca Escalante', {x = 2412, y = 2319, z = 9}},
		{'The Emerald Isle', {x = 2118, y = 2361, z = 22}},
		{'Thruway North', {x = 2216, y = 2586, z = 5}},
		{'Spiny Bed', {x = 2258, y = 2740, z = 9}},
		{'Kacc', {x = 2622, y = 2754, z = 22}},
		{'Redsands East', {x = 1928, y = 2107, z = 20}},
		{'The Visage', {x = 1928, y = 1883, z = 20}},
		{'Harry Gold', {x = 1788, y = 1785, z = 20}},
		{'Redsands West', {x = 1452, y = 2093, z = 20}},
		{'Whitewood', {x = 990, y = 2163, z = 9}},
		{'Pilson Intersection', {x = 1200, y = 2415, z = 20}},
		{'Yellow Bell', {x = 1223, y = 2783, z = 20}},
		{'Prickle Pine', {x = 1573, y = 2671, z = 20}}
	}
	
	local city_and_coordinates = {
		{'Tierra Robada', {x = -1488, y = 2219, z = 20}},
		{'San Fierro', {x = -2320, y = 246, z = 20}},
		{'Whetstone', {x = -2215, y = -1854, z = 20}},
		{'Flint County', {x = -574, y = -2638, z = 20}},
		{'Los Santos', {x = 1490, y = -1531, z = 12}},
		{'Red County', {x = 865, y = -438, z = 20}},
		{'Bone County', {x = 67, y = 795, z = 20}},
		{'Las Venturas', {x = 1945, y = 1838, z = 20}}
	}
	
	local coord_area_end
	local x_player, y_player, z_player = getCharCoordinates(PLAYER_PED)
	local distance_to_city = 0
	local org_all_position = {{x = 1178, y = -1323, z = 14}, {x = 1642, y = 1834, z = 11}, {x = -2667, y = 581, z = 14}, {x = 2034, y = -1406, z = 17}}
	for i = 1, #areas_and_coordinates do
		if (text_area):find(areas_and_coordinates[i][1]) then
			coord_area_end = areas_and_coordinates[i][2]
			break
		end
	end
	if text_area == 'неизвестном' then
		for i = 1, #city_and_coordinates do
			if (location_city):find(city_and_coordinates[i][1]) then
				coord_area_end = city_and_coordinates[i][2]
				break
			end
		end
	end
	
	if coord_area_end then
		if bool_int_or_around == 0 then
			distance_to_city = getDistanceBetweenCoords3d(coord_area_end.x, coord_area_end.y, coord_area_end.z, x_player, y_player, z_player)
			
			return ' ['.. tostring(removeDecimalPart(distance_to_city)) ..' м. от Вас]'
		else
			if setting.org == 1 then
				x_player, y_player, z_player = org_all_position[1].x, org_all_position[1].y, org_all_position[1].z
			elseif	setting.org == 2 then
				x_player, y_player, z_player = org_all_position[2].x, org_all_position[2].y, org_all_position[2].z
			elseif	setting.org == 3 then
				x_player, y_player, z_player = org_all_position[3].x, org_all_position[3].y, org_all_position[3].z
			elseif	setting.org == 4 then
				x_player, y_player, z_player = org_all_position[4].x, org_all_position[4].y, org_all_position[4].z
			end
			
			distance_to_city = getDistanceBetweenCoords3d(coord_area_end.x, coord_area_end.y, coord_area_end.z, x_player, y_player, z_player)
			
			return ' ['.. tostring(removeDecimalPart(distance_to_city)) ..' м. от Вашей больницы]'
		end
	else
		return ' [Ошибка получения расстояния]'
	end

	return ' [Ошибка получения расстояния]'
end

--> Тайм худ и координаты
function getStrByState(keyState)
	if keyState == 0 then
		return '{ffeeaa}Выкл{ffffff}'
	end
	return '{53E03D}Вкл{ffffff}'
end

function getStrByState2(keyState)
	if keyState == 0 then
		return ''
	end
	return '{F55353}Caps{ffffff}'
end

function time_hud_func_and_distance_point()
	local text_dist_user_point = ''
	local text_dist_server_point = ''
	local my_int = getActiveInterior()
	local bool_result_server, pos_X_s, pos_Y_s, pos_Z_s = getTargetServerCoordinates()
	local distance_end_serv = -2
	local bias = 0
	
	if setting.time_hud then
		local success = ffi.C.GetKeyboardLayoutNameA(KeyboardLayoutName)
		local errorCode = ffi.C.GetLocaleInfoA(tonumber(ffi.string(KeyboardLayoutName), 16), 0x00000002, LocalInfo, BuffSize)
		local localName = ffi.string(LocalInfo)
		local capsState = ffi.C.GetKeyState(20)
		local function lang()
			local str = string.match(localName, '([^%(]*)')
			if str:find('Русский') then
				return 'Ru'
			elseif str:find('Английский') then
				return 'En'
			end
		end
		local text = string.format('%s | {ffeeaa}%s{ffffff} %s', os.date('%d ')..month[tonumber(os.date('%m'))]..os.date(' - %H:%M:%S'), lang(), getStrByState2(capsState))
		bias = renderGetFontDrawTextLength(fontPD, text) + 10
		renderFontDrawText(fontPD, text, 20, sy-25, 0xFFFFFFFF)
	end
	
	if setting.display_map_distance.server and my_int == 0 then
		if bool_result_server then
			local x_player, y_player, z_player = getCharCoordinates(PLAYER_PED)
			distance_end_serv = getDistanceBetweenCoords3d(pos_X_s, pos_Y_s, pos_Z_s, x_player, y_player, z_player)
			text_dist_server_point = tostring(removeDecimalPart(distance_end_serv)..' м. до серв. метки')
			renderFontDrawText(font_metka, text_dist_server_point, 20 + bias, sy - 20, 0xFFFFFFFF)
		end
	end
	
	if setting.display_map_distance.user and my_int == 0 then
		local bool_result, pos_X, pos_Y, pos_Z = getTargetBlipCoordinates()
		if bool_result then
			local x_player, y_player, z_player = getCharCoordinates(PLAYER_PED)
			local distance_end = getDistanceBetweenCoords3d(pos_X, pos_Y, pos_Z, x_player, y_player, z_player)
			text_dist_user_point = tostring(removeDecimalPart(distance_end)..' м. до вашей метки')
			local y_bias = 0
			if setting.display_map_distance.server and my_int == 0 and bool_result_server then
				y_bias = -18
			end
			if bool_result_server then
				if math.abs(distance_end_serv - distance_end) > 3 then
					renderFontDrawText(font_metka, text_dist_user_point, 20 + bias, sy - 20 + y_bias, 0xFFFFFFFF)
				end
			else
				renderFontDrawText(font_metka, text_dist_user_point, 20 + bias, sy - 20 + y_bias, 0xFFFFFFFF)
			end
		end
	end
end

--> Проверка обновлений
function update_check()
	return require('StateHelper.bootstrap.updater').sh_core_update_check()
end

--> Скачивание обновления
function update_download()
	return require('StateHelper.bootstrap.updater').sh_core_update_download()
end

function send_smart_ticket_commands(commands)
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

function update_error()
	return require('StateHelper.bootstrap.updater').sh_core_update_error()
end

function apply_settings(name_file, description_file, array_arg) --> ???????? ???????? ??? ???????? ????? ????????
	return require('StateHelper.core.storage').sh_core_storage_apply_settings(dir, name_file, description_file, array_arg, decodeJson, encodeJson, setting)
end

local function convertToUTF8(value) --> ????????? ??????? ? u8
	return require('StateHelper.core.moonloader_env').sh_core_table_convert_utf8(value, u8)
end

function dec_to_key(dec_value) --> Преобразовать DEC клавиши в строковую константу
	local vkeys_dec = {
		VK_LBUTTON = 1,
		VK_RBUTTON = 2,
		VK_CANCEL = 3,
		VK_MBUTTON = 4,
		VK_XBUTTON1 = 5,
		VK_XBUTTON2 = 6,
		VK_BACK = 8,
		VK_TAB = 9,
		VK_CLEAR = 12,
		VK_RETURN = 13,
		VK_SHIFT = 16,
		VK_CONTROL = 17,
		VK_MENU = 18,
		VK_PAUSE = 19,
		VK_CAPITAL = 20,
		VK_KANA = 21,
		VK_HANGUL = 21,
		VK_JUNJA = 23,
		VK_FINAL = 24,
		VK_HANJA = 25,
		VK_KANJI = 25,
		VK_ESCAPE = 27,
		VK_CONVERT = 28,
		VK_NONCONVERT = 29,
		VK_ACCEPT = 30,
		VK_MODECHANGE = 31,
		VK_SPACE = 32,
		VK_PRIOR = 33,
		VK_NEXT = 34,
		VK_END = 35,
		VK_HOME = 36,
		VK_LEFT = 37,
		VK_UP = 38,
		VK_RIGHT = 39,
		VK_DOWN = 40,
		VK_SELECT = 41,
		VK_PRINT = 42,
		VK_EXECUTE = 43,
		VK_SNAPSHOT = 44,
		VK_INSERT = 45,
		VK_DELETE = 46,
		VK_HELP = 47,
		VK_0 = 48,
		VK_1 = 49,
		VK_2 = 50,
		VK_3 = 51,
		VK_4 = 52,
		VK_5 = 53,
		VK_6 = 54,
		VK_7 = 55,
		VK_8 = 56,
		VK_9 = 57,
		VK_A = 65,
		VK_B = 66,
		VK_C = 67,
		VK_D = 68,
		VK_E = 69,
		VK_F = 70,
		VK_G = 71,
		VK_H = 72,
		VK_I = 73,
		VK_J = 74,
		VK_K = 75,
		VK_L = 76,
		VK_M = 77,
		VK_N = 78,
		VK_O = 79,
		VK_P = 80,
		VK_Q = 81,
		VK_R = 82,
		VK_S = 83,
		VK_T = 84,
		VK_U = 85,
		VK_V = 86,
		VK_W = 87,
		VK_X = 88,
		VK_Y = 89,
		VK_Z = 90,
		VK_LWIN = 91,
		VK_RWIN = 92,
		VK_APPS = 93,
		VK_SLEEP = 95,
		VK_NUMPAD0 = 96,
		VK_NUMPAD1 = 97,
		VK_NUMPAD2 = 98,
		VK_NUMPAD3 = 99,
		VK_NUMPAD4 = 100,
		VK_NUMPAD5 = 101,
		VK_NUMPAD6 = 102,
		VK_NUMPAD7 = 103,
		VK_NUMPAD8 = 104,
		VK_NUMPAD9 = 105,
		VK_MULTIPLY = 106,
		VK_ADD = 107,
		VK_SEPARATOR = 108,
		VK_SUBTRACT = 109,
		VK_DECIMAL = 110,
		VK_DIVIDE = 111,
		VK_F1 = 112,
		VK_F2 = 113,
		VK_F3 = 114,
		VK_F4 = 115,
		VK_F5 = 116,
		VK_F6 = 117,
		VK_F7 = 118,
		VK_F8 = 119,
		VK_F9 = 120,
		VK_F10 = 121,
		VK_F11 = 122,
		VK_F12 = 123,
		VK_F13 = 124,
		VK_F14 = 125,
		VK_F15 = 126,
		VK_F16 = 127,
		VK_F17 = 128,
		VK_F18 = 129,
		VK_F19 = 130,
		VK_F20 = 131,
		VK_F21 = 132,
		VK_F22 = 133,
		VK_F23 = 134,
		VK_F24 = 135,
		VK_NUMLOCK = 144,
		VK_SCROLL = 145,
		VK_LSHIFT = 160,
		VK_RSHIFT = 161,
		VK_LCONTROL = 162,
		VK_RCONTROL = 163,
		VK_LMENU = 164,
		VK_RMENU = 165,
		VK_BROWSER_BACK = 166,
		VK_BROWSER_FORWARD = 167,
		VK_BROWSER_REFRESH = 168,
		VK_BROWSER_STOP = 169,
		VK_BROWSER_SEARCH = 170,
		VK_BROWSER_FAVORITES = 171,
		VK_BROWSER_HOME = 172,
		VK_VOLUME_MUTE = 173,
		VK_VOLUME_DOWN = 174,
		VK_VOLUME_UP = 175,
		VK_MEDIA_NEXT_TRACK = 176,
		VK_MEDIA_PREV_TRACK = 177,
		VK_MEDIA_STOP = 178,
		VK_MEDIA_PLAY_PAUSE = 179,
		VK_LAUNCH_MAIL = 180,
		VK_LAUNCH_MEDIA_SELECT = 181,
		VK_LAUNCH_APP1 = 182,
		VK_LAUNCH_APP2 = 183,
		VK_OEM_1 = 186,
		VK_OEM_PLUS = 187,
		VK_OEM_COMMA = 188,
		VK_OEM_MINUS = 189,
		VK_OEM_PERIOD = 190,
		VK_OEM_2 = 191,
		VK_OEM_3 = 192,
		VK_OEM_4 = 219,
		VK_OEM_5 = 220,
		VK_OEM_6 = 221,
		VK_OEM_7 = 222,
		VK_OEM_8 = 223,
		VK_OEM_102 = 226,
		VK_PROCESSKEY = 229,
		VK_PACKET = 231,
		VK_ATTN = 246,
		VK_CRSEL = 247,
		VK_EXSEL = 248,
		VK_EREOF = 249,
		VK_PLAY = 250,
		VK_ZOOM = 251,
		VK_NONAME = 252,
		VK_PA1 = 253,
		VK_OEM_CLEAR = 254
	}
	
	for key, value in pairs(vkeys_dec) do
		if value == dec_value then
			return _G[key] or key
		end
	end
	
	return nil
end

--> ??? ????????? ??????? ? JSON ???????, ?????????????? ? Lua.

--> ????????? ??? ???? ???????????
