--[[
Open with encoding: CP1251
StateHelper/features/dep/dep_core.lua
]]

function hall.dep()
	local color_ItemActive = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
	local color_ItemHovered = imgui.ImVec4(0.24, 0.24, 0.24, 1.00)
	if setting.cl == 'White' then
		color_ItemActive = imgui.ImVec4(0.78, 0.78, 0.78, 1.00)
		color_ItemHovered = imgui.ImVec4(0.83, 0.83, 0.83, 1.00)
	end
	
	imgui.SetCursorPos(imgui.ImVec2(4, 39))
	imgui.BeginChild(u8'Департамент', imgui.ImVec2(840, 369), false, imgui.WindowFlags.NoScrollWithMouse)
	gui.DrawBox({16, 16}, {808, 75}, cl.tab, cl.line, 7, 15)
	gui.Text(26, 26, 'Формат обращения в рации департамента', font[3])
	
	gui.DrawLine({16, 53}, {824, 53}, cl.line)
	
	if setting.adress_format_dep == 1 or setting.adress_format_dep == 2 or setting.adress_format_dep == 5 then
		gui.Text(26, 64, 'Ваш тег', font[3])
		local bool_dep_my_tag = setting.my_tag_dep
		setting.my_tag_dep = gui.InputText({93, 66}, 200, setting.my_tag_dep, u8'Мой тег в рацию', 230, u8'Введите Ваш тег в рацию')
		if setting.my_tag_dep ~= bool_dep_my_tag then
			save()
			update_text_dep()
		end
		gui.Text(453, 64, 'Тег к обращаемому', font[3])
		local bool_dep_alien_tag = setting.alien_tag_dep
		setting.alien_tag_dep = gui.InputText({598, 66}, 200, setting.alien_tag_dep, u8'Тег к обращаемому', 230, u8'Введите тег к обращаемому')
		if setting.alien_tag_dep ~= bool_dep_alien_tag then
			save()
			update_text_dep()
		end
	elseif setting.adress_format_dep == 3 then
		gui.Text(26, 64, 'Тег к обращаемому', font[3])
		local bool_dep_alien_tag = setting.alien_tag_dep
		setting.alien_tag_dep = gui.InputText({171, 66}, 200, setting.alien_tag_dep, u8'Тег к обращаемому', 230, u8'Введите тег к обращаемому')
		if setting.alien_tag_dep ~= bool_dep_alien_tag then
			save()
			update_text_dep()
		end
	elseif setting.adress_format_dep == 4 then
		gui.Text(26, 64, 'Ваш тег', font[3])
		local bool_dep_my_tag = setting.my_tag_dep
		setting.my_tag_dep = gui.InputText({93, 66}, 140, setting.my_tag_dep, u8'Мой тег в рацию', 230, u8'Введите Ваш тег')
		if setting.my_tag_dep ~= bool_dep_my_tag then
			save()
			update_text_dep()
		end
		gui.Text(275, 64, 'Волна', font[3])
		local bool_dep_wave_tag	= setting.wave_tag_dep
		setting.wave_tag_dep = gui.InputText({331, 66}, 139, setting.wave_tag_dep, u8'Волна в рацию', 230, u8'Введите частоту')
		if setting.wave_tag_dep ~= bool_dep_wave_tag then
			save()
			update_text_dep()
		end
		gui.Text(513, 64, 'Тег к обращаемому', font[3])
		local bool_dep_alien_tag = setting.alien_tag_dep
		setting.alien_tag_dep = gui.InputText({658, 66}, 140, setting.alien_tag_dep, u8'Тег к обращаемому', 230, u8'Тег к обращаемому')
		if setting.alien_tag_dep ~= bool_dep_alien_tag then
			save()
			update_text_dep()
		end
	end
	
	gui.Text(363, 105, 'Локальный чат', bold_font[1])
	gui.DrawBox({16, 130}, {808, 223}, cl.tab, cl.line, 7, 15)
	gui.DrawLine({16, 311}, {824, 311}, cl.line)
	
	imgui.PushStyleColor(imgui.Col.Text, cl.def)
	imgui.PushFont(fa_font[4])
	imgui.SetCursorPos(imgui.ImVec2(26, 324))
	imgui.Text(fa.CHEVRON_LEFT)
	imgui.SetCursorPos(imgui.ImVec2(54, 324))
	imgui.Text(fa.CHEVRON_RIGHT)
	imgui.PopStyleColor(1)
	imgui.PopFont()
	if dep_var > 0 then
		if dep_var == 1 then
			gui.Text(42, 324, tostring(dep_var), bold_font[1])
		elseif dep_var ~= 10 then
			gui.Text(41, 324, tostring(dep_var), bold_font[1])
		else
			gui.Text(37, 324, tostring(dep_var), bold_font[1])
		end
		local bool_dep_blanks = setting.blanks_dep[dep_var]
		setting.blanks_dep[dep_var] = gui.InputText({81, 326}, 601, setting.blanks_dep[dep_var], u8'Текст заготовки в департаменте', 230, u8'Введите заготовленный текст')
		if setting.blanks_dep[dep_var] ~= bool_dep_blanks then
			save()
		end
		if gui.Button(u8'Добавить', {708, 319}, {100, 27}) then
			dep_text = dep_text .. setting.blanks_dep[dep_var]
			dep_var = 0
		end
	else
		gui.Text(42, 324, '-', bold_font[1])
		if return_mes_dep == '' then
			dep_text, ret_bool = gui.InputText({81, 326}, 601, dep_text, u8'Текст в департамент', 230, u8'Введите текст')
		else
			dep_text, ret_bool = gui.InputText({81, 326}, 581, dep_text, u8'Текст в департамент', 230, u8'Введите текст')
			imgui.PushFont(fa_font[4])
			imgui.PushStyleColor(imgui.Col.Text, cl.def)
			imgui.SetCursorPos(imgui.ImVec2(682, 324))
			imgui.Text(fa.ROTATE_LEFT)
			imgui.PopFont()
			imgui.PopStyleColor(1)
			if imgui.IsItemHovered() then
				imgui.PushFont(font[3])
				imgui.SetTooltip(u8'Вставить предыдущий отправленный текст')
				imgui.PopFont()
			end
			imgui.SetCursorPos(imgui.ImVec2(679, 321))
			if imgui.InvisibleButton(u8'##вернуть прошлый текст', imgui.ImVec2(22, 23)) then
				dep_text = return_mes_dep
			end
			
		end
		if gui.Button(u8'Отправить', {708, 319}, {100, 27}) or ret_bool then
			sampSendChat(u8:decode(dep_text))
			return_mes_dep = dep_text
			update_text_dep()
		end
	end
	
	imgui.SetCursorPos(imgui.ImVec2(22, 322))
	if imgui.InvisibleButton(u8'##Вернуть предыдущий вариант заготовки', imgui.ImVec2(20, 24)) then
		if dep_var > 0 then
			dep_var = dep_var - 1
		end
	end
	imgui.SetCursorPos(imgui.ImVec2(50, 322))
	if imgui.InvisibleButton(u8'##Следующий вариант заготовки', imgui.ImVec2(20, 24)) then
		if dep_var < 10 then
			dep_var = dep_var + 1
		end
	end
	
	imgui.SetCursorPos(imgui.ImVec2(16, 130))
	imgui.BeginChild(u8'Чат департамента', imgui.ImVec2(808, 181), false, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse)
	imgui.SetScrollY(imgui.GetScrollMaxY())
	
	if #dep_history > 30 then
		for i = 1, #dep_history - 20 do
			table.remove(dep_history, 1)
		end
	end
	if #dep_history ~= 0 then
		start_index = math.max(#dep_history - 19, 1)
		for i = start_index, #dep_history do
			imgui.PushFont(font[3])
			imgui.SetCursorPos(imgui.ImVec2(10, 10 + ((i - 1) * 20)))
			if setting.cl == 'Black' then
				imgui.TextColored(imgui.ImVec4(0.16, 0.65, 0.99, 1.00), u8(dep_history[i]))
			else
				imgui.TextColored(imgui.ImVec4(0.00, 0.35, 0.58, 1.00), dep_history[i])
			end
			imgui.PopFont()
		end
	end
	imgui.Dummy(imgui.ImVec2(0, 8))
	imgui.EndChild()
	
	local bool_adress_format = setting.adress_format_dep
	setting.adress_format_dep = gui.ListTableMove({789, 26}, {u8'[ЛСМЦ] - [ЛСПД]:', u8'[ЛСМЦ] to [ЛСПД]:', u8'к ЛСПД,', u8'[Больница ЛС] - [100,3] - [Полиция ЛС]:', u8'[Больница ЛС] з.к. [ФБР]:'}, setting.adress_format_dep, 'Select Adress Format Departament')
	if setting.adress_format_dep ~= bool_adress_format then
		save()
		update_text_dep()
	end
		
	imgui.EndChild()
end

