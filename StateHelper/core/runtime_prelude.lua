--[[
Open with encoding: CP1251
StateHelper/core/runtime_prelude.lua
]]


local ffi = require 'ffi'
ffi.cdef [[
	typedef int BOOL;
	typedef unsigned long HANDLE;
	typedef HANDLE HWND;
	typedef const char* LPCSTR;
	typedef unsigned UINT;
	
	void* __stdcall ShellExecuteA(void* hwnd, const char* op, const char* file, const char* params, const char* dir, int show_cmd);
	uint32_t __stdcall CoInitializeEx(void*, uint32_t);
	
	BOOL ShowWindow(HWND hWnd, int  nCmdShow);
	HWND GetActiveWindow();
	
	
	int MessageBoxA(
	  HWND   hWnd,
	  LPCSTR lpText,
	  LPCSTR lpCaption,
	  UINT   uType
	);
	
	short GetKeyState(int nVirtKey);
	bool GetKeyboardLayoutNameA(char* pwszKLID);
	int GetLocaleInfoA(int Locale, int LCType, char* lpLCData, int cchData);
]]
local text_error_lib = {
	[1] = [[
			  Внимание!
	Не обнаружены некоторые важные файлы для работы скрипта.
	В следствии чего, скрипт не может работать.
	Список необнаруженных файлов:
	%s

	Для решения проблемы:
	1. Закройте игру.
	2. Сохраните копию скрипта на рабочий стол.
	3. Зайдите во вкладку "Моды" в лаунчере Аризоны.
	4. Найдите во вкладке "Моды" установщик "Moonloader" и нажмите кнопку "Установить".
	5. После завершения установки перетащите копию скрипта с рабочего стола обратно
	в папку "Moonloader" и запустите игру. Проблема исчезнет.

	Игра была свёрнута, поэтому можете продолжить играть.
	]],

	[2] = {
		'imgui.lua',
		'samp/events.lua',
		'rkeys.lua',
		'fAwesome5.lua',
		'crc32ffi.lua',
		'bitex.lua',
		'MoonImGui.dll',
		'matrix3x3.lua',
		'encoding.lua',
		'vkeys.lua',
		'effil.lua',
		'bass.lua',
		'fAwesome6.lua',
	},
	[3] = {}
}

if not doesFileExist(getGameDirectory() .. '/SAMPFUNCS.asi') then
	ffi.C.ShowWindow(ffi.C.GetActiveWindow(), 6)
	ffi.C.MessageBoxA(0, text_error_lib[1], 'StateHelper', 0x00000030 + 0x00010000)
end

for i,v in ipairs(text_error_lib[2]) do
	if not doesFileExist(getWorkingDirectory() .. '/lib/' .. v) then
		table.insert(text_error_lib[3], v)
	end
end

if #text_error_lib[3] > 0 then
	ffi.C.ShowWindow(ffi.C.GetActiveWindow(), 6)
	ffi.C.MessageBoxA(0, text_error_lib[1]:format(table.concat(text_error_lib[3], '\n\t\t')), 'StateHelper', 0x00000030 + 0x00010000)
end
text_error_lib = nil

require 'lib.sampfuncs'
require 'lib.moonloader'
local json = require('cjson')
local mem = require 'memory'
local encoding = require 'encoding' encoding.default = 'CP1251'
local raw_u8 = encoding.UTF8
local function sh_safe_locale_text(value)
    if value == nil then
        return ''
    end
    if type(value) == 'string' then
        return value
    end
    return tostring(value)
end
local u8 = setmetatable({}, {
    __call = function(_, value)
        local ok, converted = pcall(function()
            return raw_u8(sh_safe_locale_text(value))
        end)
        return ok and converted or sh_safe_locale_text(value)
    end,
    __index = function(_, key)
        if key == 'decode' then
            return function(_, value)
                local ok, converted = pcall(function()
                    return raw_u8:decode(sh_safe_locale_text(value))
                end)
                return ok and converted or sh_safe_locale_text(value)
            end
        end
        return raw_u8[key]
    end
})
local iconv = require 'iconv'
local u1251 = iconv.new('CP1251', 'UTF-8')
local vkeys = require 'vkeys'
local rkeys = require 'rkeys'
local effil = require 'effil'
local bass = require 'bass'
local imgui = require 'mimgui'
local new = imgui.new
local fa = require('fAwesome6')
local lfs = require('lfs')
local dlstatus = require('moonloader').download_status

local shell32 = ffi.load 'Shell32'
local ole32 = ffi.load 'Ole32'
ole32.CoInitializeEx(nil, 6)
local hook = require 'lib.samp.events'
vkeys.key_names[vkeys.VK_RBUTTON] = u8'ПКМ'
vkeys.key_names[vkeys.VK_LBUTTON] = u8'ЛКМ'
vkeys.key_names[vkeys.VK_XBUTTON1] = 'XBut1'
vkeys.key_names[vkeys.VK_XBUTTON2] = 'XBut2'
vkeys.key_names[vkeys.VK_NUMPAD1] = 'Num 1'
vkeys.key_names[vkeys.VK_NUMPAD2] = 'Num 2'
vkeys.key_names[vkeys.VK_NUMPAD3] = 'Num 3'
vkeys.key_names[vkeys.VK_NUMPAD4] = 'Num 4'
vkeys.key_names[vkeys.VK_NUMPAD5] = 'Num 5'
vkeys.key_names[vkeys.VK_NUMPAD6] = 'Num 6'
vkeys.key_names[vkeys.VK_NUMPAD7] = 'Num 7'
vkeys.key_names[vkeys.VK_NUMPAD8] = 'Num 8'
vkeys.key_names[vkeys.VK_NUMPAD9] = 'Num 9'
vkeys.key_names[vkeys.VK_MULTIPLY] = 'Num *'
vkeys.key_names[vkeys.VK_ADD] = 'Num +'
vkeys.key_names[vkeys.VK_SEPARATOR] = 'Separator'
vkeys.key_names[vkeys.VK_SUBTRACT] = 'Num -'
vkeys.key_names[vkeys.VK_DECIMAL] = 'Num .Del'
vkeys.key_names[vkeys.VK_DIVIDE] = 'Num /'
vkeys.key_names[vkeys.VK_LEFT] = 'Ar.Left'
vkeys.key_names[vkeys.VK_UP] = 'Ar.Up'
vkeys.key_names[vkeys.VK_RIGHT] = 'Ar.Right'
vkeys.key_names[vkeys.VK_DOWN] = 'Ar.Down'


--> Файловая система
local dir = getWorkingDirectory()
local sx, sy = getScreenResolution()
local scr = thisScript()
local function sh_legacy_normalize_path(path)
    return tostring(path or ''):gsub('\\', '/')
end
local sh_legacy_data_root = sh_legacy_normalize_path((type(sh_data_root_path) == 'function' and sh_data_root_path(dir)) or (dir .. '/StateHelper'))
local function sh_legacy_data_path(...)
    if type(sh_data_path) == 'function' then
        return sh_legacy_normalize_path(sh_data_path(dir, ...))
    end

    local parts = { ... }
    local result = sh_legacy_data_root
    for _, part in ipairs(parts) do
        result = result .. '/' .. tostring(part)
    end
    return result
end
local sh_fonts_dir = sh_legacy_data_path('Шрифты')
local sh_images_dir = sh_legacy_data_path('Изображения')
local sh_tsr_dir = sh_legacy_data_path('TSR')
local sh_roleplay_dir = sh_legacy_data_path('Ролевая')
font = renderCreateFont('Trebuchet MS', 14, 5)
fontPD = renderCreateFont('Trebuchet MS', 12, 5)
font_flood = renderCreateFont('Trebuchet MS', 10, 5)
font_metka = renderCreateFont('Trebuchet MS', 9, 5)

--> Проверка существование папки и её создание
if not doesDirectoryExist(sh_legacy_data_root .. '/') then
	print('{F54A4A}Ошибка. Отсутствует папка State Helper. {82E28C}Создание папки для скрипта...')
	createDirectory(sh_legacy_data_root .. '/')
end

--> Скачивание шрифтов
inst_suc_font = {false, false}
image_version_init = false
function download_font()
	local link_meduim_font = sh_project_remote_data_url('assets/fonts/SFProText-Medium.ttf')
	local link_bold_font = sh_project_remote_data_url('assets/fonts/SFProText-Bold.ttf')
	if not doesDirectoryExist(sh_fonts_dir .. '/') then
		print('{F54A4A}Ошибка. Отсутствует папка для шрифтов. {82E28C}Создание папки для шрифтов...')
		createDirectory(sh_fonts_dir .. '/')
	end
	if not doesFileExist(sh_legacy_data_path('Шрифты', 'SF600.ttf')) or not doesFileExist(sh_legacy_data_path('Шрифты', 'SF800.ttf')) then
		download_id = downloadUrlToFile(link_meduim_font, sh_legacy_data_path('Шрифты', 'SF600.ttf'), function(id, status, p1, p2)
			if status == dlstatus.STATUS_ENDDOWNLOADDATA then
				inst_suc_font[1] = true
			end
		end)
		download_id = downloadUrlToFile(link_bold_font, sh_legacy_data_path('Шрифты', 'SF800.ttf'), function(id, status, p1, p2)
			if status == dlstatus.STATUS_ENDDOWNLOADDATA then
				inst_suc_font[2] = true
			end
		end)
	else
		inst_suc_font = {true, true}
	end
end
download_font()

if not doesFileExist(sh_legacy_data_path('Изображения', 'logo update.png')) then
	download_id = downloadUrlToFile(sh_project_remote_data_url('assets/images/logo update.png'), sh_legacy_data_path('Изображения', 'logo update.png'), function(id, status, p1, p2)
		if status == dlstatus.STATUS_ENDDOWNLOADDATA then
			image_version_init = true
		end
	end)
else
	image_version_init = true
end
	
--> Регистрация основных функций
function create_folder(name_folder, description_folder) --> создает папку для данных скрипта, если ее нет
	return require('StateHelper.core.moonloader_env').sh_core_fs_ensure_statehelper_dir(dir, name_folder, description_folder)
end

--> Окна mimgui
local win = {}
local windows = {
	main = new.bool(false),
	fast = new.bool(false),
	action = new.bool(false),
	shpora = new.bool(false),
	reminder = new.bool(false),
	player = new.bool(false),
	stat = new.bool(false),
	smart_su = new.bool(false),
	smart_ticket = new.bool(false),
	smart_punish = new.bool(false)
}

function open_main()
	if setting.blockl then
		if not setting.cef_notif then
			sampAddChatMessage('[SH]{FFFFFF} Доступ к StateHelper был заблокирован разработчиком.', 0xFF5345)
		else
			cefnotig('{FF5345}[SH]{FFFFFF} Доступ к StateHelper был заблокирован разработчиком.', 3000)
		end
		return
	end
	if inst_suc_font[1] and inst_suc_font[2] then
		windows.main[0] = not windows.main[0]
		if windows.main[0] then
			if sampIsLocalPlayerSpawned() then
				local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
				my = {id = myid, nick = sampGetPlayerNickname(myid)}
			else
				if not setting.cef_notif then
					sampAddChatMessage('[SH]{FFFFFF} Дождитесь спавна персонажа перед использованием.', 0xFF5345)
				else
					cefnotig('{FF5345}[SH]{FFFFFF} Дождитесь спавна персонажа перед использованием.', 3000)
				end
				windows.main[0] = false
				return
			end
			sx, sy = getScreenResolution()
			fix_bug_input_bool = true
			if setting.anim_win then
				anim_func = true
			else
				win_x = sx / 2
			end
		else
			if setting.anim_win then
				close_win_anim = true
				windows.main[0] = true
			end
		end
	else
		sampAddChatMessage('[SH]{FFFFFF} Не удалось обнаружить шрифты. Попробуйте снова через несколько секунд...', 0xFF5345)
		sampAddChatMessage('[SH]{FFFFFF} Если проблема не решилась, напишите разработчику ВК: vk.com/marseloy', 0xFF5345)
	end
end
sampRegisterChatCommand('sh', function()
	open_main()
end)

sampRegisterChatCommand("afind", function(arg)
    toggleTracking(arg)
end)

function deep_copy(orig, copies) --> рекурсивно копирует таблицу с учетом циклических ссылок
	return require('StateHelper.core.moonloader_env').sh_core_table_deep_copy(orig, copies)
end

--> Несохраняемая информация
local smartSuState = {
	isActive = windows.smart_su,
	targetId = new.int(0),
	searchQuery = '',
	reasons = {},
	chapterStates = {},
	selectedArticle = nil,
	showPenaltySelector = new.bool(false),
	anim = {
		win_x = new.float(sx + 400),
		win_y = new.float(sy / 2),
		is_opening = false,
		is_closing = false
	}
}
local smartTicketState = {
	isActive = windows.smart_ticket,
	targetId = new.int(0),
	searchQuery = '',
	reasons = {},
	chapterStates = {},
	selectedArticle = nil,
	showPenaltySelector = new.bool(false),
	anim = {
		win_x = new.float(sx + 400),
		win_y = new.float(sy / 2),
		is_opening = false,
		is_closing = false
	}
}

local smartPunishState = {
    isActive = windows.smart_punish,
    targetId = new.int(0),
    searchQuery = '',
    reasons = {},
    chapterStates = {},
    selectedArticle = nil,
    selectedValue = nil,
    isIncrease = true,
    anim = {
        win_x = new.float(sx + 400),
        win_y = new.float(sy / 2),
        is_opening = false,
        is_closing = false
    }
}

local smartFastState = {
    isActive = false,
    selectedPlayer = nil,
    playersList = {},
    actionsWithoutId = {},
    actionsWithId = {},
    lastUpdate = 0,
    visible = 100,
    need_recenter = false,
    anim = {
        alpha = 0.0,
        is_opening = false,
        is_closing = false
    }
}

local smartFastActions = {
    withId = {},
    withoutId = {}
}

local old_fast_state = {
    isActive = false,
    nick = 'Nick_Name',
    id = 0
}

local poltarget = nil
local afk_start_time = 0
local is_afk = false
local doc_numb = false
local unprison_id = nil
local BuffSize = 32
local KeyboardLayoutName = ffi.new('char[?]', BuffSize)
local LocalInfo = ffi.new('char[?]', BuffSize)
local month = {'Января', 'Февраля', 'Марта', 'Апреля', 'Мая', 'Июня', 'Июля', 'Августа', 'Сентября', 'Октября', 'Ноября', 'Декабря'}
math.randomseed(os.time())

cssInjected = false
unprison = false
ui_state = false
isCefScript = false
first_start = 0
anim_clock = os.clock()
anim = 0
an = {[1] = 4, [2] = 0.001, [3] = 0, [4] = 187, [5] = {0, 420, 0, 0, 0}, [6] = {0.00, 1}, [7] = {0.00, 0.00, 0.00}, [8] = {0.00, 0.00, 0.00, 0.00, 0.00, 0.00},
	[9] = {0, 0, 0, 0}, [10] = {0.00, 0}, [11] = {0, 0}, [12] = {0, 0, false}, [13] = 0, [14] = {0, 0, 0}, [15] = 0, [16] = 0, [17] = {0.00, 0.00, 0.00}, [18] = {0.00, 0.00, 0.00, 0.00, 0.00, 0.00},
	[19] = {0.00, 0.00}, [20] = {0.00, 0.00, 0.00}, [21] = {0, 0, 0}, [22] = {0, 0, 0, 0, 0}, [23] = 0, [24] = {0, 0, 0, 0, 0}, [25] = {0, 0},
	[26] = 0, [27] = 0, [28] = 0, [29] = 0, [30] = {0, 0}}
stop_anim = {false}
tab = 'settings'
name_tab = u8'Главное'
tab_settings = 1
bool_go_stat_set = false
track_time = true
lspawncar = false
carcers = false
is_mini_player_pos = false
close_win = {main = false, fast = false}
imgui.Scroller = {
	id_bool_scroll = {}
}
id_bool_scroll = {}
table_move = ''
table_move_cmd = ''
close_stats = true
hovered_bool_not_child = false
bool_tazer = false
send_chat_rp = false
num_win_fast = 1
bool_edit_fast = false
sc_cursor_pos = {0, 0}
sc_cr_pos = {0, 0}
sc_cr_pos2 = {0, 0}
sc_cr_p_element = {0, 0, 0, 0, 0}
sc_cr_p_element2 = {0, 0, 0, 0, 0}
sdv_bool_fast = 0
bool_item_active = false
bool_item_active2 = false
fast_key = {}
act_key = {}
enter_key = {}
win_key = {}
all_keys = {{72}, {13}}
current_key = {'', {}}
key_pres = {}
fast_nick = 'Nick_Name'
fast_id = 0
TEST = 1
num_of_the_selected_org = 1
text_godeath = ''
id_player_go = '0'
my = {id = 0, nick = 'Nick_Name'}
error_spawn = false
close_serv = false
cur_cmd = ''
edit_cmd = false
all_cmd = {'sh', 'ts', 'r', 'd', 'go', 's', 'f'}
new_cmd = ''
edit_order_tabs = false
int_cmd = {
	folder = 1,
	group = {true, true, true}
}
edit_tab_cmd = false
edit_tab_shpora = false
bl_cmd = nil
main_or_json = 1
number_i_cmd = 0
type_cmd = 0
edit_name_folder = false
focus_input_bool = false
scroll_input_bool = false
edit_all_cmd = false
table_select_cmd = {}
cmd_memory = ''
error_save_cmd = 0
key_bool_cur = {}
dialog_act = {status = false, info = {}, options = {}, enter = false}
x_act_dialog = sx + 200
dep_text = ''
dep_history = {}
dep_var = 0
fix_bug_input_bool = false
shpora_bool = {}
num_shpora = 0
all_icon_shpora = {fa.HOUSE, fa.STAR, fa.USER, fa.MUSIC, fa.GIFT, fa.BOOK, fa.KEY, fa.GLOBE, fa.CODE, fa.COMPASS, fa.LAYER_GROUP, fa.USERS, fa.HEART, fa.CAR, fa.CALENDAR, fa.PLAY, fa.FLAG, fa.BRAIN, fa.ROBOT, fa.WRENCH, fa.INFO, fa.CLOCK, fa.FLOPPY_DISK, fa.CHART_SIMPLE, fa.SHOP, fa.LINK, fa.DATABASE, fa.TAGS, fa.POWER_OFF, fa.HAMMER, fa.SCROLL, fa.CLONE, fa.DICE, fa.USER_NURSE, fa.HOSPITAL, fa.WHEELCHAIR, fa.TRUCK_MEDICAL, fa.TEMPERATURE_LOW, fa.SYRINGE, fa.HEART_PULSE, fa.BOOK_MEDICAL, fa.BAN, fa.PLUS, fa.NOTES_MEDICAL, fa.IMAGE, fa.FILE, fa.TRASH, fa.INBOX, fa.FOLDER, fa.FOLDER_OPEN, fa.COMMENTS, fa.SLIDERS, fa.WIFI, fa.VOLUME_HIGH, fa.UP_DOWN_LEFT_RIGHT, fa.TERMINAL, fa.SUPERSCRIPT}
text_shpora = ''
cmd_memory_shpora = ''
id_sobes = ''
bool_sob_rp_scroll = false
run_sob = false
sob_info = {}
text_sob_chat = ''
support_text = ''
new_reminder = false
new_rem = {}
last_mouse_pos = {0, 0}
last_child_y = {0, 0}
child_clicked = {false, false}
start_child = {true, true}
del_rem = 0
text_reminder = ''
stat_ses = {
	cl = 0,
	afk = 0,
	all = 0
}
tab_music = 1
mus = {
	search = ''
}
image_no_label = nil
bool_button_active_music = false
bool_button_active_volume = false
image_record = {}
image_radio = {}
new_scene = false
scene = {}
num_scene = 0
scene_active = false
scene_edit_pos = false
change_pos_onstat = false
camhack_active = false
off_scene = false
actions_set = {
	remove_mes = false,
	remove_rp = false
}
nickname_dialog = false
nickname_dialog2 = false
nickname_dialog3 = false
nickname_dialog4 = false
time_dialog_nickname = 20
ret_check = 0
replace_not_flood = {0, 0, 0, 0, 1}
popup_open_tags = false
anim_func = false
win_x = sx + 4000
win_y = sy / 2
close_win_anim = false
insert_tag_popup = {[1] = 0, [2] = '', [3] = false}
gun_bool = {}
gun_orig = {
	[1] = {
		i_gun = 3,
		name_gun = 'Дубинка',
		take = true,
		put = true,
		take_rp = u8'/me снял{sex[][а]} дубинку с поясного держателя',
		put_rp = u8'/me убрал{sex[][а]} дубинку на пояс'
	},
	[2] = {
		i_gun = 22,
		name_gun = 'Pistol',
		take = true,
		put = true,
		take_rp = u8'/me выхватил{sex[][а]} пистолет "Pistol", после чего снял{sex[][а]} его с предохранителя',
		put_rp = u8'/me убрал{sex[][а]} пистолет в кобуру'
	},
	[3] = {
		i_gun = 23,
		name_gun = 'Тайзер',
		take = true,
		put = true,
		take_rp = u8'/me быстро достал{sex[][а]} тайзер из кобуры',
		put_rp = u8'/me спрятал{sex[][а]} тайзер в кобуру'
	},
	[4] = {
		i_gun = 24,
		name_gun = 'Desert Eagle',
		take = true,
		put = true,
		take_rp = u8'/me извлек{sex[][ла]} "Desert Eagle" из кобуры',
		put_rp = u8'/me убрал{sex[][а]} "Desert Eagle" обратно в кобуру'
	},
	[5] = {
		i_gun = 25,
		name_gun = 'Дробовик',
		take = true,
		put = true,
		take_rp = u8'/me снял{sex[][а]} дробовик со спины',
		put_rp = u8'/me положил{sex[][а]} дробовик за спину'
	},
	[6] = {
		i_gun = 26,
		name_gun = 'Обрез',
		take = true,
		put = true,
		take_rp = u8'/me достал{sex[][а]} обрез из пальто',
		put_rp = u8'/me спрятал{sex[][а]} обрез под пальто'
	},
	[7] = {
		i_gun = 27,
		name_gun = 'Скорострельный дробовик',
		take = true,
		put = true,
		take_rp = u8'/me снял{sex[][а]} с плеча скорострельный дробовик',
		put_rp = u8'/me повесил{sex[][а]} скорострельный дробовик на плечо'
	},
	[8] = {
		i_gun = 28,
		name_gun = 'UZI',
		take = true,
		put = true,
		take_rp = u8'/me ловко вытащил{sex[][а]} UZI из сумки',
		put_rp = u8'/me убрал{sex[][а]} UZI в сумку'
	},
	[9] = {
		i_gun = 29,
		name_gun = 'MP5',
		take = true,
		put = true,
		take_rp = u8'/me эффектно собрал{sex[][а]} автомат MP5',
		put_rp = u8'/me повесил{sex[][а]} MP5 за спину'
	},
	[10] = {
		i_gun = 30,
		name_gun = 'AK-47',
		take = true,
		put = true,
		take_rp = u8'/me снял{sex[][а]} автомат "AK-47" со спины',
		put_rp = u8'/me поставил{sex[][а]} "AK-47" на предохранитель и убрал{sex[][а]} его за спину'
	},
	[11] = {
		i_gun = 31,
		name_gun = 'M4',
		take = true,
		put = true,
		take_rp = u8'/me быстро и уверенно снял{sex[][а]} "M4" с плеча',
		put_rp = u8'/me убрал{sex[][а]} "M4", повесив его на плечо'
	},
	[12] = {
		i_gun = 33,
		name_gun = 'Винтовка',
		take = true,
		put = true,
		take_rp = u8'/me снял{sex[][а]} винтовку с плеча',
		put_rp = u8'/me повесила{sex[][а]} винтовку на плечо'
	},
	[13] = {
		i_gun = 34,
		name_gun = 'Снайперская винтовка',
		take = true,
		put = true,
		take_rp = u8'/me достал{sex[][а]} снайперскую винтовку',
		put_rp = u8'/me поместил{sex[][а]} снайперскую винтовку за спину'
	},
	[14] = {
		i_gun = 71,
		name_gun = 'Desert Eagle Steel',
		take = true,
		put = true,
		take_rp = u8'/me извлек{sex[][ла]} "Desert Eagle Steel" из кобуры',
		put_rp = u8'/me убрал{sex[][а]} "Desert Eagle Steel" обратно в кобуру'
	},
	[15] = {
		i_gun = 72,
		name_gun = 'Desert Eagle Gold',
		take = true,
		put = true,
		take_rp = u8'/me извлек{sex[][ла]} "Desert Eagle Gold" из кобуры',
		put_rp = u8'/me убрал{sex[][а]} "Desert Eagle Gold" обратно в кобуру'
	},
	[16] = {
		i_gun = 73,
		name_gun = 'Glock',
		take = true,
		put = true,
		take_rp = u8'/me выхватил{sex[][а]} пистолет "Glock", после чего снял{sex[][а]} его с предохранителя',
		put_rp = u8'/me убрал{sex[][а]} пистолет "Glock" в кобуру'
	},
	[17] = {
		i_gun = 74,
		name_gun = 'Desert Eagle Flame',
		take = true,
		put = true,
		take_rp = u8'/me извлек{sex[][ла]} "Desert Eagle Flame" из кобуры',
		put_rp = u8'/me убрал{sex[][а]} "Desert Eagle Flame" обратно в кобуру'
	},
	[18] = {
		i_gun = 75,
		name_gun = 'Colt Python',
		take = true,
		put = true,
		take_rp = u8'/me выхватил{sex[][а]} пистолет "Colt Python", после чего снял{sex[][а]} его с предохранителя',
		put_rp = u8'/me убрал{sex[][а]} пистолет "Colt Python" в кобуру'
	},
	[19] = {
		i_gun = 76,
		name_gun = 'Colt Python Silver',
		take = true,
		put = true,
		take_rp = u8'/me выхватил{sex[][а]} пистолет "Colt Python Silver", после чего снял{sex[][а]} его с предохранителя',
		put_rp = u8'/me убрал{sex[][а]} пистолет "Colt Python Silver" в кобуру'
	},
	[20] = {
		i_gun = 77,
		name_gun = 'AK-47 Roses',
		take = true,
		put = true,
		take_rp = u8'/me снял{sex[][а]} автомат "AK-47 Roses" со спины',
		put_rp = u8'/me убрал{sex[][а]} автомат "AK-47 Roses" за спину'
	},
	[21] = {
		i_gun = 78,
		name_gun = 'AK-47 Gold',
		take = true,
		put = true,
		take_rp = u8'/me снял{sex[][а]} автомат "AK-47 Gold" со спины',
		put_rp = u8'/me убрал{sex[][а]} автомат "AK-47 Gold" за спину'
	},
	[22] = {
		i_gun = 79,
		name_gun = 'M249 Graffiti',
		take = true,
		put = true,
		take_rp = u8'/me снял{sex[][а]} пулемёт "M249 Graffiti" со спины',
		put_rp = u8'/me убрал{sex[][а]} пулемёт "M249 Graffiti" за спину'
	},
	[23] = {
		i_gun = 80,
		name_gun = 'Золотая Сайга',
		take = true,
		put = true,
		take_rp = u8'/me снял{sex[][а]} автомат "Золотая Сайга" со спины',
		put_rp = u8'/me убрал{sex[][а]} автомат "Золотая Сайга" за спину'
	},
	[24] = {
		i_gun = 81,
		name_gun = 'Standart',
		take = true,
		put = true,
		take_rp = u8'/me достал{sex[][а]} пистолет-пулемёт "Standart" из кобуры',
		put_rp = u8'/me убрал{sex[][а]} пистолет-пулемёт "Standart" в кобуру'
	},
	[25] = {
		i_gun = 82,
		name_gun = 'M249',
		take = true,
		put = true,
		take_rp = u8'/me снял{sex[][а]} пулемет "M249" со спины',
		put_rp = u8'/me убрал{sex[][а]} пулемет "M249" за спину'
	},
	[26] = {
		i_gun = 83,
		name_gun = 'Skorp',
		take = true,
		put = true,
		take_rp = u8'/me достал{sex[][а]} пистолет-пулемёт "Skorp" с кобуры',
		put_rp = u8'/me убрал{sex[][а]} пистолет-пулемёт "Skorp" в кобуру'
	},
	[27] = {
		i_gun = 84,
		name_gun = 'AKS-74',
		take = true,
		put = true,
		take_rp = u8'/me снял{sex[][а]} камуфляжный автомат "AKS-74" со спины',
		put_rp = u8'/me убрал{sex[][а]} камуфляжный автомат "AKS-74" за спину'
	},
	[28] = {
		i_gun = 85,
		name_gun = 'AK-47',
		take = true,
		put = true,
		take_rp = u8'/me снял{sex[][а]} камуфляжный автомат "AK-47" со спины',
		put_rp = u8'/me убрал{sex[][а]} камуфляжный автомат "AK-47" за спину'
	},
	[29] = {
		i_gun = 86,
		name_gun = 'Rebecca',
		take = true,
		put = true,
		take_rp = u8'/me снял{sex[][а]} дробовик "Rebecca" со спины',
		put_rp = u8'/me убрал{sex[][а]} дробовик "Rebecca" за спину'
	},
	[30] = {
		i_gun = 92,
		name_gun = 'McMillian TAC-50',
		take = true,
		put = true,
		take_rp = u8'/me достал{sex[][а]} снайперскую винтовку "McMillian TAC-50"',
		put_rp = u8'/me убрал{sex[][а]} снайперскую винтовку "McMillian TAC-50" за спину'
	},
	[31] = {
		i_gun = 42,
		name_gun = 'Огнетушитель',
		take = true,
		put = true,
		take_rp = u8'/me достал{sex[][а]} огнетушитель',
		put_rp = u8'/me убрал{sex[][а]} огнетушитель за спину'
	},
	[32] = {
		i_gun = 93,
		name_gun = 'Оглушающий пистолет',
		take = true,
		put = true,
		take_rp = u8'/me достал{sex[][а]} оглушающий пистолет из кобуры',
		put_rp = u8'/me убрал{sex[][а]} спрятал оглушающий пистолет в кобуру'
	}
}
anti_spam_gun = {-1, false, 0}
update_request = 0
up_child_sub = 0
cmd_del_i = 0
num_give_gov = -1
num_give_lic = -1
num_give_lic_term = 0
time_save = 1
timer_send = 0
wait_mb = 12
delay_act_def = 2.5
wait_book = {0, false}
script_reset = 0
return_mes_dep = ''
shp_edit_all = {false, {}}
new_version = '0'
search_for_new_version = 0
dialog_fire = {
	id = 27255,
	text = {}
}
tail_rotation_angle = 0
rotation_speed = 90
update_info = {}
function sh_repo_raw_url(relative_path)
    local clean_path = sh_safe_locale_text(relative_path):gsub('\\', '/'):gsub('^/+', '')
    clean_path = clean_path:gsub(' ', '%%20')
    return 'https://raw.githubusercontent.com/metsuwuki/State-Helper/main/' .. clean_path
end

function sh_project_raw_url(relative_path)
    return sh_repo_raw_url('StateHelper/' .. sh_safe_locale_text(relative_path))
end

local function sh_runtime_get_remote_data_root()
	local configured_root = rawget(_G, 'SH_REMOTE_DATA_ROOT')
	if type(configured_root) == 'string' and configured_root ~= '' then
		return configured_root
	end

	return 'Arizona_data/remote'
end

function sh_project_remote_data_url(relative_path)
    return sh_project_raw_url(sh_runtime_get_remote_data_root() .. '/' .. sh_safe_locale_text(relative_path))
end

raw_upd_info_url = raw_upd_info_url or sh_project_raw_url('update_info.json')
raw_upd_url = raw_upd_url or sh_repo_raw_url('StateHelper.lua')
update_scr_check = 30
error_update = false
script_ac = {reset = 0, del = 0}
fire_active = false
level_fire = 1
confirm_action_dialog = false
popup_open_tags_call = false
server = ''
s_na = ''
search_cmd = ''
developer_mode = 0
dev_mode = false
windir = os.getenv('windir')
status_sc = 0
UID_SH_SUPPORT = {}
signcheck = false
command_queue = {}
localVehicleVersion = '1'
local tenCodes = {}
vehicleNames = {}
--> Функция отслеживания игрока по ID
local trackingState = {
    isTracking = false,
    targetId = nil,
    updateInterval = 2000, 
    thread = nil
}
--> Главные настройки
setting = {
	mini_player_pos = { x = sx / 2, y = sy - 60 },
	first_start = true,
	prinfo = false,
	cl = 'Black',
	color_def = {0.00, 0.48, 1.00},
	color_def_num = 1,
	hi_mes = true,
	anim_win = true,
	cef_notif = true,
	win_key = {'', {}},
	window_alpha = 1.0,
	cmd_open_win = '',
	tab = {'settings', 'cmd', 'shpora', 'dep', 'sob', 'reminder', 'stat', 'music', 'rp_zona', 'actions', 'help'},
	auto_update = true,
	name_rus = '',
	sex = 1,
	org = 5,
	job_title = u8'Не определено',
	rank = 10,
	put_mes = {false, false, false, false, false, false, false, false, false, false, false, false, false, false},
	auto_cmd_doc = false,
	auto_close_doc = true,
	auto_cmd_tazer = true,
	auto_cmd_time = '',
	auto_cmd_r = '',
	teg_r = '',
	time = '',
	weather = '',
	watherlock = false,
	price = {
		{
			lec = '10000',
			narko = '100000',
			osm = '200000',
			rec = '20000',
			tatu = '100000',
			ant = '20000',
			mc = {'10000', '20000', '40000', '60000'},
			mcupd = {'20000', '40000', '60000', '80000'}
		},
		{
			auto = {'100000', '160000', '210000'},
			moto = {'150000', '200000', '240000'},
			fly = {'500000', '0', '0'},
			fish = {'200000', '250000', '290000'},
			swim = {'200000', '250000', '290000'},
			gun = {'240000', '330000', '405000'},
			hunt = {'230000', '330000', '390000'},
			exc = {'230000', '330000', '390000'},
			taxi = {'500000', '750000', '1000000'},
			meh = {'500000', '750000', '1000000'}
		},
		{
			box = '0',
			eat = '0',
			cloth = '0',
			trash = '0',
			min = '0',
			task1 = '0',
			task2 ='0',
			task3 ='0',
			task4 ='0',
			task5 ='0',
			task6 = '0'
		}
	},
	fast = {
		func = false,
		one_win = {},
		two_win = {},
		key = {2, 69},
		key_name = u8'ПКМ + E',
		use_smart_menu = true
	},
	mb = {
		func = false, 
		dialog = false, 
		invers = false, 
		form = false, 
		rank = false, 
		id = false, 
		afk = false, 
		warn = false, 
		size = 12, 
		flag = 5, 
		dist = 21, 
		vis = 70, 
		color = {title = 0xFFFF8585, default = 0xFFFFFFFF, work = 0xFFFF8C00},
		pos = {x = sx - 30, y = sy / 3}
	},
	godeath = {
		func = false,
		cmd_go = false,
		meter = true,
		two_text = false,
		auto_send = false,
		sound = false,
		color = 0,
		color_godeath = {1.00, 0.33, 0.31}
	},
	notice = {car = false, dep = false},
	dep = {my_tag = '', my_tag_en = '', my_tag_en2 = '', my_tag_en3 = ''},
	accent = {func = false, text = '', r = false, f = false, d = false, s = false},
	speed_door = false,
	show_dialog_auto = false,
	anti_alarm_but = false,
	dep_off = false,
	ts = false,
	time_hud = false,
	display_map_distance = {user = false, server = false},
	but_control = 1,
	kick_afk = {func = false, mode = 1, time_kick = '10'},
	act_key = {{34}, u8'Page Down'},
	enter_key = {{13}, u8'Enter'},
	adress_format_dep = 1,
	my_tag_dep = '',
	wave_tag_dep = '',
	alien_tag_dep = '',
	blanks_dep = {u8'На связи.', u8'На связь.', u8'Конец связи.', u8'Прошу прощения, рация упала...', u8'Вы и Ваш состав свободны для проверки?', u8'', u8'', u8'', u8'', u8''},
	shp = {},
	sob = {
		min_exp = '3',
		min_law = '35',
		min_narko = '999',
		auto_exp = true,
		auto_law = true,
		auto_narko = true,
		auto_org = true,
		auto_med = true,
		auto_blacklist = true,
		auto_ticket = true,
		auto_car = true,
		auto_gun = false,
		auto_warn = true,
		chat = true,
		close_doc = true,
		hide_doc = true,
		use_original_color = true,
		rp_q = {
			{name = u8'Попросить документы', rp = {u8'Для трудоустройства необходимо предоставить следующий пакет документов:', u8'Паспорт, медицинскую карту и лицензии.', u8'/n Отыгрывая, с использованием команд /me, /do, /todo'}},
			{name = u8'Рассказать о себе', rp = {u8'Хорошо, расскажите немного о себе.'}},
			{name = u8'Почему Вы выбрали нас', rp = {u8'Хорошо, скажите, почему Вы выбрали именно нас?'}},
			{name = u8'Вас убивали?', rp = {u8'Хорошо, давайте проверим Вашу психику.', u8'Скажите, Вас когда-нибудь убивали?'}},
			{name = u8'Где Вы находитесь?', rp = {u8'Хорошо, скажите, где Вы сейчас находитесь?'}},
			{name = u8'Название купюр', rp = {u8'Отлично, скажите, как называются купюры, которыми Вы расплачиваетесь?'}},
			{name = u8'Рация дискорд', rp = {u8'Хорошо, скажите, имеется ли у Вас спец. рация Discord?'}}
		},
		rp_fit = {
			{name = u8'Принять игрока', rp = {u8'Отлично, Вы приняты к нам на работу!', u8'/do В кармане находятся ключи от шкафчиков.', u8'/me засунув руку в карман, вытаскивает ключи и передаёт человеку напротив', u8'/givewbook {id_sob} 1000', u8'{waitwbook}', u8'/invite {id_sob}'}},
			{name = u8'НонРП ник', rp = {u8'Извините, но Вы нам не подходите. У Вас опечатка в паспорте.', u8'/n нонРП ник. С таким ником нельзя. Введи /settings --> Сменить NonRP ник.'}},
			{name = u8'Низкий левел', rp = {u8'Извините, но Вы нам не подходите. Ваш возраст проживания в штате слишком мал.', u8'Минимальный возраст проживания в годах должен быть не менее, чем {min_level_sob}'}},
			{name = u8'Проблемы с законом', rp = {u8'Извините, но Вы нам не подходите. У Вас проблемы с законом.', u8'/n Требуется минимум {min_law_sob} законопослушности.'}},
			{name = u8'Уже состоит во фракции', rp = {u8'Извините, но Вы нам не подходите.', u8'На данный момент Вы уже работаете в другой организации.', u8'Если хотите к нам, то для начала Вам необходимо уволиться оттуда.'}},
			{name = u8'Имеет наркозависимость', rp = {u8'Извините, но Вы нам не подходите. У Вас имеется зависимость от укропа.', u8'Вы можете излечиться, попросив об этом врача любой больницы.'}},
			{name = u8'Проблемы с псих. здоровьем', rp = {u8'Извините, но Вы нам не подходите. У Вас проблемы с псих. здоровьем.', u8'Попробуйте получить новую медицинскую карту в любой больнице.'}},
			{name = u8'Состоит в чёрном списке', rp = {u8'Извините, но Вы нам не подходите. Вы состоите в чёрном списке организации.'}},
			{name = u8'Нет паспорта', rp = {u8'Для трудоустройства необходимо предоставить паспорт.', u8'Получить его можно в мерии г. Лос-Сантос.', u8'Без него, к сожалению, продолжить мы не сможем. Приходите после его получения.'}},
			{name = u8'Нет мед. карты', rp = {u8'Для трудоустройства необходима мед. карта с пометкой "Полностью здоров".', u8'Получить её можно в любой больнице.', u8'Без неё, к сожалению, продолжить мы не сможем.'}},
			{name = u8'Нет лицензий', rp = {u8'Для трудоустройства необходима лицензия на управление автомобилем.', u8'Получить её можно в Центре Лицензирования', u8'Без неё, к сожалению, продолжить мы не сможем. Приходите после её получения.'}},
			{name = u8'Повестка', rp = {u8'Извините, но я смогу Вас трудоустроить, так как у Вас на руках имеется повестка.', u8'Для трудоустройства необходимо иметь военный билет, либо не иметь повестки.', u8'Приходите после получения военного билета.'}}
		}
	},
	reminder = {},
	stat = {
		cl = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		afk = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		day = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		all = 0,
		today = os.date('%d.%m.%y'),
		date_week = {os.date('%d.%m.%y'), '', '', '', '', '', '', '', '', ''}
	},
	tracks = {},
	mini_player = true,
	scene = {},
	visible_fast = 100,
	replace_not_flood = true,
	color_nick = false,
	hide_chat = false,
	replace_ic = true,
	replace_s = true,
	replace_c = true,
	replace_b = true,
	chat_corrector = false,
	auto_edit = false,
	command_tabs = {'', '', '', '', '', '', '', '', '', '', '', '', '', '', ''},
	key_tabs = {{'', {}}, {'', {}}, {'', {}}, {'', {}}, {'', {}}, {'', {}}, {'', {}}, {'', {}}, {'', {}}, {'', {}}, {'', {}}, {'', {}}, {'', {}}, {'', {}}, {'', {}}},
	gun_func = false,
	gun = deep_copy(gun_orig),
	stat_on_screen = {
		func = false,
		dialog = true,
		current_time = true,
		current_date = true,
		day = true,
		afk = true,
		all = true,
		ses_day = false,
		ses_afk = false,
		ses_all = false,
		stop_timer = false,
		visible = 60
	},
	position_stat = {x = sx - 160, y = sy / 2 - 50},
	first_start_fast = true,
	fire = {
		auto_send = false,
		sound = false,
		auto_cmd_fires = false,
		auto_select_fires = false
	},
	sob_id_arg = true,
	show_logs = true,
	text_fires = u8'/r Докладываю: выезжаю на пожар {level} степени возгорания.',
	button_close = 1,
	report_fire = {
		arrival = {
			func = false,
			ask = false,
			text = u8'/r Докладываю: прибыл на пожар {level} степени возгорания.'
		},
		foci = {
			func = false,
			ask = false,
			text = u8'/r Докладываю: все очаги пожара {level} степени возгорания ликвидированы.'
		},
		stretcher = {
			func = false,
			ask = false,
			text = u8'/r Докладываю: немедленно отношу пострадавшего в палатку.'
		},
		salvation = {
			func = false,
			ask = false,
			text = u8'/r Докладываю: пострадавшему в пожаре была успешно оказана помощь.'
		},
		extinguishing = {
			func = false,
			ask = false,
			text = u8'/r Докладываю: пожар {level} степени возгорания полностью устранён!'
		}
	},
	mb_tags = false,
	sob_moto_lic = false,
	blockl = false,
	time_offset = 0,
	close_button = true,
	police_settings = {
		smart_su = true,
		smart_su_radio_req = false,
		smart_ticket = true,
		smart_ticket_trade = false,
		siren = true,
		siren_key = {'C', {67}},
		siren_on_rp = u8'/me протянул{sex[][а]} руку к панели и включил{sex[][а]} сирену',
		siren_off_rp = u8'/me нажал{sex[][а]} кнопку на панели и отключил{sex[][а]} сирену',
		ten_code = true,
		auto_z = false,
		auto_inves = false,
		ghetto_notify = false,
		cmd_patrol = 'patrol',
		wanted_list = {
			func = false, 
			dialog = false, 
			invers = false, 
			interior = false, 
			size = 12, 
			flag = 5, 
			dist = 21, 
			vis = 70, 
			color = {title = 0xFFFF8585, default = 0xFFFFFFFF, work = 0xFFFF8C00},
			pos = {x = sx - 30, y = sy / 3}
		}
	},
	tsr_settings = {
		smart_punish = false
	},
	playlist = {},
	new_mc = true,
	smart_fast_menu = true,
	wrap_text_chat = {
		func = false,
		num_char = '82'
	},
	rank_members = {true, true, true, true, true, true, true, true, true, true, true},
	smart_punish_enabled = true
}

--> Отладка кода: значение элементов массив с рекурсивным вызовом для вложенных таблиц
--[[local function inspectTable(tbl)
	for k, v in pairs(tbl) do
		print("Key:", k, "Value:", tostring(v), "Type:", type(v))
		if type(v) == "table" then
			inspectTable(v)
		end
	end
end

inspectTable(setting)]]

cmd = {
	[1] = {},
	[2] = {
		{'Все команды', false, {}},
		{'Избранные', false, {}},
		{'Основные', false, {}},
		{'Фракционные', false, {}},
		{'Для руководства', false, {}},
		{'Лекции', false, {}},
		{'Разное', false, {}}
	}
}

local original_os_date = os.date
os.date = function(format, time)
	local adjusted_time = (time or os.time()) + (setting.time_offset * 3600)
	return original_os_date(format, adjusted_time)
end

function save()
	require('StateHelper.core.storage').sh_core_storage_save_settings(dir, setting, encodeJson)
end

function save_cmd()
	require('StateHelper.core.storage').sh_core_storage_save_commands(dir, setting, cmd, lfs, encodeJson)
end

function download_image()
	if not doesDirectoryExist(sh_images_dir .. '/') then
		print('{F54A4A}Ошибка. Отсутствует папка для изображений. {82E28C}Создание папки для изображений...')
		createDirectory(sh_images_dir .. '/')
	end
	if not doesFileExist(sh_legacy_data_path('Изображения', 'No label.png')) then
		download_id = downloadUrlToFile(sh_project_remote_data_url('assets/images/No label.png'), sh_legacy_data_path('Изображения', 'No label.png'), function(id, status, p1, p2)
			if status == dlstatus.STATUS_ENDDOWNLOADDATA then 
				--image_no_label = imgui.CreateTextureFromFile(sh_legacy_data_path('Изображения', 'No label.png'))
			end
		end)
	end
	
	local function download_record_label(url_label_record, name_label, i_rec)
		if not doesFileExist(sh_legacy_data_path('Изображения', name_label .. '.png')) then
			download_id = downloadUrlToFile(url_label_record, sh_legacy_data_path('Изображения', name_label .. '.png'), function(id, status, p1, p2)
				if status == dlstatus.STATUS_ENDDOWNLOADDATA then 
					--image_record[i_rec] = imgui.CreateTextureFromFile(sh_legacy_data_path('Изображения', name_label .. '.png'))
				end
			end)
		end
	end
	
	local function download_radio_label(url_label_radio, name_label, i_radio)
		if not doesFileExist(sh_legacy_data_path('Изображения', name_label .. '.png')) then
			download_id = downloadUrlToFile(url_label_radio, sh_legacy_data_path('Изображения', name_label .. '.png'), function(id, status, p1, p2)
				if status == dlstatus.STATUS_ENDDOWNLOADDATA then 
					--image_radio[i_radio] = imgui.CreateTextureFromFile(sh_legacy_data_path('Изображения', name_label .. '.png'))
				end
			end)
		end
	end
	
	
	download_radio_label(sh_project_remote_data_url('assets/images/Europa Plus.png'), 'Europa Plus', 1)
	download_radio_label(sh_project_remote_data_url('assets/images/DFM.png'), 'DFM', 2)
	download_radio_label(sh_project_remote_data_url('assets/images/Chanson.png'), 'Chanson', 3)
	download_radio_label(sh_project_remote_data_url('assets/images/Dacha.png'), 'Dacha', 4)
	download_radio_label(sh_project_remote_data_url('assets/images/Road.png'), 'Road', 5)
	download_radio_label(sh_project_remote_data_url('assets/images/Mayak.png'), 'Mayak', 6)
	download_radio_label(sh_project_remote_data_url('assets/images/Nashe.png'), 'Nashe', 7)
	download_radio_label(sh_project_remote_data_url('assets/images/LoFi Hip-Hop.png'), 'LoFi Hip-Hop', 8)
	download_radio_label(sh_project_remote_data_url('assets/images/Maximum.png'), 'Maximum', 9)
	download_radio_label(sh_project_remote_data_url('assets/images/90s Eurodance.png'), '90s Eurodance', 10)
	
end
download_image()

--> Обработка шрифтов
local font = {}
local bold_font = {}
local fa_font = {}
imgui.OnInitialize(function()
	imgui.GetIO().IniFilename = nil
	local config = imgui.ImFontConfig()
	local glyph_ranges = imgui.GetIO().Fonts:GetGlyphRangesCyrillic()
	config.MergeMode = true
	config.PixelSnapH = true
	imgui.GetIO().Fonts:AddFontFromFileTTF(u8(sh_legacy_data_path('Шрифты', 'SF600.ttf')), 16.0, nil, glyph_ranges)
	
	font[1] = imgui.GetIO().Fonts:AddFontFromFileTTF(u8(sh_legacy_data_path('Шрифты', 'SF600.ttf')), 10.0, nil, glyph_ranges)
	font[2] = imgui.GetIO().Fonts:AddFontFromFileTTF(u8(sh_legacy_data_path('Шрифты', 'SF600.ttf')), 13.0, nil, glyph_ranges)
	font[3] = imgui.GetIO().Fonts:AddFontFromFileTTF(u8(sh_legacy_data_path('Шрифты', 'SF600.ttf')), 15.0, nil, glyph_ranges)
	
	bold_font[1] = imgui.GetIO().Fonts:AddFontFromFileTTF(u8(sh_legacy_data_path('Шрифты', 'SF800.ttf')), 17.0, nil, glyph_ranges)
	bold_font[2] = imgui.GetIO().Fonts:AddFontFromFileTTF(u8(sh_legacy_data_path('Шрифты', 'SF800.ttf')), 65.0, nil, glyph_ranges)
	bold_font[3] = imgui.GetIO().Fonts:AddFontFromFileTTF(u8(sh_legacy_data_path('Шрифты', 'SF800.ttf')), 35.0, nil, glyph_ranges)
	
	iconRanges = imgui.new.ImWchar[3](fa.min_range, fa.max_range, 0)
	fa_font[1] = imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(fa.get_font_data_base85('solid'), 8, nil, iconRanges)
	fa_font[2] = imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(fa.get_font_data_base85('solid'), 13, nil, iconRanges)
	fa_font[3] = imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(fa.get_font_data_base85('solid'), 15, nil, iconRanges)
	fa_font[4] = imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(fa.get_font_data_base85('solid'), 17, nil, iconRanges)
	fa_font[5] = imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(fa.get_font_data_base85('solid'), 21, nil, iconRanges)
	fa_font[6] = imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(fa.get_font_data_base85('solid'), 35, nil, iconRanges)
	
	if image_version_init then
		image_logo_update = imgui.CreateTextureFromFile(sh_legacy_data_path('Изображения', 'logo update.png'))
	end
	if image_no_label == nil then
		image_no_label = imgui.CreateTextureFromFile(sh_legacy_data_path('Изображения', 'No label.png'))
	end
	if #image_record == 0 then
		image_record = {}
	end
	if #image_radio == 0 then
		image_radio = {
			[1] = imgui.CreateTextureFromFile(sh_legacy_data_path('Изображения', 'Europa Plus.png')),
			[2] = imgui.CreateTextureFromFile(sh_legacy_data_path('Изображения', 'DFM.png')),
			[3] = imgui.CreateTextureFromFile(sh_legacy_data_path('Изображения', 'Chanson.png')),
			[4] = imgui.CreateTextureFromFile(sh_legacy_data_path('Изображения', 'Dacha.png')),
			[5] = imgui.CreateTextureFromFile(sh_legacy_data_path('Изображения', 'Road.png')),
			[6] = imgui.CreateTextureFromFile(sh_legacy_data_path('Изображения', 'Mayak.png')),
			[7] = imgui.CreateTextureFromFile(sh_legacy_data_path('Изображения', 'Nashe.png')),
			[8] = imgui.CreateTextureFromFile(sh_legacy_data_path('Изображения', 'LoFi Hip-Hop.png')),
			[9] = imgui.CreateTextureFromFile(sh_legacy_data_path('Изображения', 'Maximum.png')),
			[10] = imgui.CreateTextureFromFile(sh_legacy_data_path('Изображения', '90s Eurodance.png'))
		}
	end
end)

function CefDialog()
	local document_opened = false
	addEventHandler('onReceivePacket', function(id, bs)
		if id == 220 then
			raknetBitStreamIgnoreBits(bs, 8)
			if raknetBitStreamReadInt8(bs) == 17 then
				raknetBitStreamIgnoreBits(bs, 32)
				local length = raknetBitStreamReadInt16(bs)
				local encoded = raknetBitStreamReadInt8(bs)
				if length > 0 then
					local text = (encoded ~= 0) and raknetBitStreamDecodeString(bs, length + encoded) or raknetBitStreamReadString(bs, length)
					local event, body = text:match("window%.executeEvent%('(.+)',%s*`%[(.+)%]`%);")

					if run_sob then
						if setting.sob.hide_doc and setting.sob.close_doc and not isCefScript then
							sendJav(cef_script)
							isCefScript = true
						end
						if event == 'event.documents.inititalizeData' then
							local data = json.decode(body)
							local document_type = data['type']

							if document_type == 1 then 		--> Паспорт
								if data['name'] ~= sob_info.nick then
									if setting.sob.hide_doc and setting.sob.close_doc then
										if not setting.cef_notif then
											sampAddChatMessage('[SH]{FFFFFF} Нельзя просматривать чужие документы при включенной функции \'Скрывать документы\'', 0xFF5345)
										else
											cefnotig('{FF5345}[SH]{FFFFFF} Нельзя просматривать чужие документы при включенной функции \'Скрывать документы\'', 4000)
										end
										sendCef('documents.close')
										sendJav("if(typeof window.cleanupCefHider === 'function') { window.cleanupCefHider(); }")
										isCefScript = false
									end
									sendJav("if(typeof window.cleanupCefHider === 'function') { window.cleanupCefHider(); }")
									isCefScript = false
									return
								end
								sob_info.valid = true
								local sex = data['sex']
								local birthday = data['birthday']
								local zakono = tonumber(tostring(data['zakono']):match("%d+")) or -2
								local level = tonumber(tostring(data['level']):match("%d+")) or -2
								local agenda = tostring(data['agenda'] or "Нет")
								local charity_info = data['charity']
								if agenda:find("Имеется", 1, true) then
									sob_info.ticket = 1
								else
									sob_info.ticket = 2
								end
								if charity_info ~= 'Нет' then
									sob_info.warn = 0
								else
									sob_info.warn = 1
								end
								sob_info.law = zakono
								sob_info.exp = level
							if setting.sob.close_doc then
								lua_thread.create(function()
									wait(200)
									sendCef('documents.changePage|2')
								end)
							end
							elseif sob_info.valid then
								if document_type == 2 then 		--> Лицензии
									local licenses = data['info']

									sob_info.car = 2
									sob_info.moto = 2
									sob_info.gun = 2

									for _, v in pairs(licenses) do
										local license = v['license']
										local date_text = v['date_text'] or ""
										local is_active = (date_text:find("Действует", 1, true) or date_text:find("Бессрочная", 1, true)) and 1 or 2

										if license == "car" then
											sob_info.car = is_active
										elseif license == "bike" then
											sob_info.moto = is_active
										elseif license == "gun" then
											sob_info.gun = is_active
										end
									end
									if setting.sob.close_doc then
										lua_thread.create(function()
											wait(200)
											sendCef('documents.changePage|4')
										end)
									end
								elseif document_type == 4 then 		--> Мед.карта
									local zavisimost = tonumber(data['zavisimost']) or 0
									local state = data['state'] or ""
									 local sub_text = (data['demorgan'] and data['demorgan']['sub_text']) or ""

									local med_status_m = {
										["Полностью здоров"] = 1,
										["Псих. отклонени"] = 2,
										["Псих. нездоров"] = 3,
										["Не определён"] = 4
									}

									local med_status = 4
									local found_status = false
									for key, value in pairs(med_status_m) do
										if state:find(key, 1, true) then
											med_status = value
											found_status = true
											break
										end
									end
									
									if sub_text == "Обновите мед. карту" then
										sob_info.org = 2
									else
										sob_info.org = 1
									end

									if not found_status then
										med_status = 5
										sob_info.org = 3
									end

									sob_info.narko = zavisimost
									sob_info.med = med_status
									if setting.sob.close_doc then
										lua_thread.create(function()
											wait(200)
											sendCef('documents.changePage|8')
										end)
									end
								elseif document_type == 8 then			--> Военный билет
									local have_army_ticket = tostring(data['have_army_ticket'] or 1)

									if have_army_ticket:find("Есть", 1, true) then
										sob_info.bilet = 0
									elseif have_army_ticket:find("Нет", 1, true) then
										sob_info.bilet = 1
									else
										sob_info.bilet = 1
									end
									if setting.sob.close_doc then
										lua_thread.create(function()
											sendCef('documents.close')
											wait(1000)
											sendJav("if(typeof window.cleanupCefHider === 'function') { window.cleanupCefHider(); }")
											sendCef('documents.close')
											isCefScript = false
										end)
									end
								end

							end
						end
						if event == 'event.employment.updateData' then --> Трудовая книжка
							local data = json.decode(body)
							local member = data['member']
							if member == 0 then						   --> Проверка на оргу, потом поменяю :)
								sob_info.warn = 1
							else
								sob_info.warn = 0
							end
							if setting.sob.close_doc then
								sendCef('loadInfo')
								sendCef('selectMenuItem|4')
								sendCef('exit')
							end
						end
					end

					if event == 'event.documents.inititalizeData' then
						local data = json.decode(body)
						if data['name'] ~= my.nick and data['type'] == 1 then
							document_opened = true
							if setting.auto_close_doc then
								lua_thread.create(function()
									wait(0)
									sampSendChat("/me взял".. sex('', 'а') .. " документ с рук человека, затем начал".. sex('', 'а') .. " его осматривать")
								end)
							end
						end
					end

					if event == 'event.arizonahud.updateGeoPositionVisibility' and body == "false" then --> Отыгровка после закрытия паспорта
						if document_opened and setting.auto_close_doc then
							if run_sob then
								lua_thread.create(function()
									wait(1000)
									sampSendChat('/me осмотрел'.. sex('', 'а') .. ' документ, затем закрыл'.. sex('', 'а') .. ' его и вернул'.. sex('', 'а') .. ' человеку')
								end)
							else
								lua_thread.create(function()
									wait(100)
									sampSendChat('/me осмотрел'.. sex('', 'а') .. ' документ, затем закрыл'.. sex('', 'а') .. ' его и вернул'.. sex('', 'а') .. ' человеку')
								end)
							end
							document_opened = false
						end
					end
				end
			end
		end
	end)
end

function sendCef(str)
	require('StateHelper.core.cef').sh_core_cef_send(str)
end

function sendJav(code)
	require('StateHelper.core.cef').sh_core_cef_eval_js(code)
end

function evalcef(code, encoded)
	require('StateHelper.core.cef').sh_core_cef_eval(code, encoded)
end

function evalanon(code) require('StateHelper.core.cef').sh_core_cef_eval_anon(code) end

function injNotif()
	cssInjected = require('StateHelper.core.notifications').sh_ui_notif_inject_css(cssInjected)
end

function cefnotig(samp_text, duration_ms)
	require('StateHelper.core.notifications').sh_ui_notif_show(samp_text, duration_ms)
end
 
cef_script = [[
	(function() {
		function addCssRule(selector, property, value) {
			const style = document.createElement('style');
			style.textContent = selector + ' { ' + property + ': ' + value + ' !important; }';
			document.head.appendChild(style);
			style.setAttribute('data-cef-hider-style', 'true');
		}
		addCssRule('.documents__content.documents__content--pasport', 'display', 'none');
		addCssRule('.documents__navigation', 'display', 'none');
		const pasportContent = document.querySelector('.documents__content.documents__content--pasport');
		if (pasportContent) pasportContent.style.display = 'none';
		const navigation = document.querySelector('.documents__navigation');
		if (navigation) navigation.style.display = 'none';
		const observer = new MutationObserver(mutationsList => {
			for (const mutation of mutationsList) {
				if (mutation.type === 'childList' || mutation.type === 'subtree' || mutation.type === 'attributes') {
					const pasportContent = document.querySelector('.documents__content.documents__content--pasport');
					if (pasportContent && pasportContent.style.display !== 'none') {
						pasportContent.style.display = 'none';
					}
					const navigation = document.querySelector('.documents__navigation');
					if (navigation && navigation.style.display !== 'none') {
						navigation.style.display = 'none';
					}
				}
			}
		});
		observer.observe(document.body, { childList: true, subtree: true, attributes: true });
		window.cleanupCefHider = function() {
			if (observer) observer.disconnect();
			const styles = document.querySelectorAll('style[data-cef-hider-style="true"]');
			styles.forEach(style => {
				style.remove();
			});
			const pasportContentToUnHide = document.querySelector('.documents__content.documents__content--pasport');
			if (pasportContentToUnHide) {
				pasportContentToUnHide.style.display = '';
			}
			const navigationToUnHide = document.querySelector('.documents__navigation');
			if (navigationToUnHide) {
				navigationToUnHide.style.display = '';
			}
		};
	})();
]]


function getNearbyPlayers()
    
    local players = {}
    
    
    if not sampIsLocalPlayerSpawned() then
        return players
    end
    
    
    local myX, myY, myZ = getCharCoordinates(PLAYER_PED)
    if not myX or not myY or not myZ then
        return players
    end
    
    
    
    local chars = getAllChars()
    
    local count = 0
    
    for i, char in ipairs(chars) do
        
        if char ~= PLAYER_PED then
            
            local success, playerId = sampGetPlayerIdByCharHandle(char)
            
            
            if success and type(playerId) == "number" and playerId >= 0 and playerId <= 1000 then
                
                local x, y, z = getCharCoordinates(char)
                
                if x and y and z then
                    local dist = getDistanceBetweenCoords3d(myX, myY, myZ, x, y, z)
                    
                    
                    if dist < 200.0 then
                        count = count + 1
                        
                        
                        local nick = sampGetPlayerNickname(playerId)
                        if nick then
                            nick = nick:gsub('_', ' ')
                        else
                            nick = "Unknown"
                        end
                        
                        
                        local playerColor = sampGetPlayerColor(playerId)
                        
                        local a = bit.band(bit.rshift(playerColor, 24), 0xFF)
                        local b = bit.band(bit.rshift(playerColor, 16), 0xFF)
                        local g = bit.band(bit.rshift(playerColor, 8), 0xFF)
                        local r = bit.band(playerColor, 0xFF)
                        
                        local colorVec = imgui.ImVec4(r/255, g/255, b/255, a/255)
                        
                        table.insert(players, {
                            id = playerId,
                            nick = nick,
                            dist = math.floor(dist),
                            color = colorVec  
                        })
                        
                    end
                end
            end
        end
    end
    
    
    
    if #players > 0 then
        table.sort(players, function(a, b)
            return a.dist < b.dist
        end)
    end
    
    return players
end

function safeGetCoordinates(func)
    local success, result = pcall(func)
    if success then
        return result
    end
    return 0, 0, 0
end


function hasAccessToAction(action)
    if not action or not action.cmd then return false end
    
    
    if #cmd[1] > 0 then
        for c = 1, #cmd[1] do
            if cmd[1][c] and cmd[1][c].cmd == action.cmd then
                if cmd[1][c].rank and cmd[1][c].rank > setting.rank then
                    return false
                end
            end
        end
    end
    
    return true
end

local function normalizeFastAction(action, index, default_id)
    local fallback_index = tonumber(index) or 1

    if type(action) ~= 'table' then
        action = {}
    end

    if type(action.name) ~= 'string' then
        action.name = u8'Действие ' .. fallback_index
    end

    if type(action.cmd) ~= 'string' then
        action.cmd = ''
    end

    if type(action.send) ~= 'boolean' then
        action.send = true
    end

    if type(action.id) ~= 'boolean' then
        action.id = default_id and true or false
    end

    return action
end

function syncFastActions()
    smartFastActions.withId = {}
    smartFastActions.withoutId = {}
    
    if setting.fast.one_win and type(setting.fast.one_win) == 'table' then
        for index, action in ipairs(setting.fast.one_win) do
            action = normalizeFastAction(action, index, true)
            setting.fast.one_win[index] = action
            action.id = true
            table.insert(smartFastActions.withId, action)
        end
    end
    
    if setting.fast.two_win and type(setting.fast.two_win) == 'table' then
        for index, action in ipairs(setting.fast.two_win) do
            action = normalizeFastAction(action, index, false)
            setting.fast.two_win[index] = action
            action.id = false
            table.insert(smartFastActions.withoutId, action)
        end
    end
end

function autoFixFastActionsIdFlags()
    if not setting.fast then return 0 end
    
    local fixed_count = 0
    
    local function commandNeedsId(cmd_name)
        local found_cmd = nil
        for _, cmd_obj in ipairs(cmd[1]) do
            if cmd_obj.cmd == cmd_name then
                found_cmd = cmd_obj
                break
            end
        end
        
        if not found_cmd then
            return nil
        end
        
        if found_cmd.arg and #found_cmd.arg > 0 then
            local first_arg = found_cmd.arg[1]
            if first_arg then
                local desc = first_arg.desc or ""
                local name = first_arg.name or ""
                
                if desc:find('id игрока') or desc:find('ID игрока') or
                   desc:find('ник игрока') or desc:find('id игрока') or
                   name == 'id' or name == 'playerid' then
                    return true
                end
            end
        end
        
        if found_cmd.act then
            for _, action in ipairs(found_cmd.act) do
                if action[1] == 'SEND' or action[1] == 'SEND_CMD' or 
                   action[1] == 'OPEN_INPUT' or action[1] == 'SEND_ME' or
                   action[1] == 'SEND_DIALOG' then
                    if action[2] and type(action[2]) == 'string' then
                        if action[2]:find('{arg1}') or action[2]:find('{id}') then
                            return nil
                        end
                    end
                end
            end
        end
        
        return false
    end
    
    if setting.fast.one_win and #setting.fast.one_win > 0 then
        for i = #setting.fast.one_win, 1, -1 do
            local action = setting.fast.one_win[i]
            if action and action.cmd then
                local needs_id = commandNeedsId(action.cmd)
                if needs_id == false then
                    action.id = false
                    table.insert(setting.fast.two_win, action)
                    table.remove(setting.fast.one_win, i)
                    fixed_count = fixed_count + 1
                end
            end
        end
    end
    
    if setting.fast.two_win and #setting.fast.two_win > 0 then
        for i = #setting.fast.two_win, 1, -1 do
            local action = setting.fast.two_win[i]
            if action and action.cmd then
                local needs_id = commandNeedsId(action.cmd)
                if needs_id == true then
                    action.id = true
                    table.insert(setting.fast.one_win, action)
                    table.remove(setting.fast.two_win, i)
                    fixed_count = fixed_count + 1
                end
            end
        end
    end
    
    if fixed_count > 0 then
        syncFastActions()
        save()
        if not setting.cef_notif then
            sampAddChatMessage(string.format('[SH]{23E64A} Исправлено: %d команд обновлено.', fixed_count), 0x23E64A)
        else
            cefnotig(string.format('{23E64A}[SH] Исправлено: %d команд обновлено.', fixed_count), 3000)
        end
    end
    
    return fixed_count
end

function splitActionsByType()
    if setting.smart_fast_menu then
        return smartFastActions.withoutId, smartFastActions.withId
    else
        local withoutId = {}
        local withId = {}
        
        if setting.fast.one_win and type(setting.fast.one_win) == 'table' then
            for i, action in ipairs(setting.fast.one_win) do
                if action and type(action) == 'table' then
                    action.id = true
                    table.insert(withId, action)
                end
            end
        end
        
        if setting.fast.two_win and type(setting.fast.two_win) == 'table' then
            for i, action in ipairs(setting.fast.two_win) do
                if action and type(action) == 'table' then
                    action.id = false
                    table.insert(withoutId, action)
                end
            end
        end
        
        return withoutId, withId
    end
end

function debugCommandInfo(cmd_name)
    local found_cmd = nil
    for _, cmd_obj in ipairs(cmd[1]) do
        if cmd_obj.cmd == cmd_name then
            found_cmd = cmd_obj
            break
        end
    end
    
    if not found_cmd then
        if not setting.cef_notif then
            sampAddChatMessage('[SH]{FF5345} Команда "' .. cmd_name .. '" не найдена', 0xFF5345)
        else
            cefnotig('{FF5345}[SH] Команда "' .. cmd_name .. '" не найдена', 3000)
        end
        return
    end
    
    local has_args = found_cmd.arg and #found_cmd.arg > 0
    local args_info = {}
    if has_args then
        for _, arg in ipairs(found_cmd.arg) do
            table.insert(args_info, string.format("%s (%s)", arg.name, arg.type == 1 and "число" or "текст"))
        end
    end
    
    if not setting.cef_notif then
        sampAddChatMessage(string.format('[SH] Команда "%s": аргументы=%s', cmd_name, has_args and table.concat(args_info, ", ") or "нет"), 0xFFA500)
    else
        cefnotig(string.format('{FFA500}[SH] Команда "%s": аргументы=%s', cmd_name, has_args and table.concat(args_info, ", ") or "нет"), 3000)
    end
end


function syncFromSmartToOld()
    if setting.smart_fast_menu then
        local oldOneWin = {}
        local oldTwoWin = {}
        local hasWithId = false
        local hasWithoutId = false
        
        if #smartFastActions.withId > 0 then
            hasWithId = true
            oldOneWin = deep_copy(smartFastActions.withId)
        end
        
        if #smartFastActions.withoutId > 0 then
            hasWithoutId = true
            oldTwoWin = deep_copy(smartFastActions.withoutId)
        end
        
        if hasWithId and hasWithoutId then
            setting.fast.one_win = oldOneWin
            setting.fast.two_win = oldTwoWin
        elseif hasWithId then
            setting.fast.one_win = oldOneWin
            setting.fast.two_win = {}
        elseif hasWithoutId then
            setting.fast.one_win = oldTwoWin
            setting.fast.two_win = {}
        else
            setting.fast.one_win = {}
            setting.fast.two_win = {}
        end
    end
end

function executeFastAction(action, targetId)
    
    if not action then 
        return 
    end
    
    
    if not hasAccessToAction(action) then
        if not setting.cef_notif then
            sampAddChatMessage('[SH]{FFFFFF} У вас недостаточно прав для этого действия.', 0xFF5345)
        else
            cefnotig('{FF5345}[SH]{FFFFFF} У вас недостаточно прав для этого действия.', 2000)
        end
        return
    end
    
    
    local foundCmd = false
    local cmdUID = 0
    if #cmd[1] > 0 then
        for c = 1, #cmd[1] do
            if cmd[1][c] and cmd[1][c].cmd == action.cmd then
                foundCmd = true
                cmdUID = cmd[1][c].UID or 0
                break
            end
        end
    end
    
    
    local isTab = false
    if #setting.command_tabs > 0 then
        for c = 1, #setting.command_tabs do
            if setting.command_tabs[c] == action.cmd then
                isTab = true
                break
            end
        end
    end
    
        --tostring(action.cmd), tostring(foundCmd), tostring(isTab), tostring(targetId)))
    
    if foundCmd then
        if action.send then
            if targetId and action.id then
                cmd_start(tostring(targetId), tostring(cmdUID) .. action.cmd)
            else
                cmd_start('', tostring(cmdUID) .. action.cmd)
            end
        else
            sampSetChatInputEnabled(true)
            if targetId and action.id then
                sampSetChatInputText('/' .. action.cmd .. ' ' .. targetId)
            else
                sampSetChatInputText('/' .. action.cmd)
            end
        end
    elseif isTab then
        start_other_cmd(action.cmd, targetId and tostring(targetId) or '')
    else
        if action.send then
            if targetId and action.id then
                sampSendChat('/' .. action.cmd .. ' ' .. targetId)
            else
                sampSendChat('/' .. action.cmd)
            end
        else
            sampSetChatInputEnabled(true)
            sampSetChatInputText('/' .. action.cmd)
        end
    end
    
    
    smartFastState.isActive = false
    windows.fast[0] = false
end


function smart_punish_func(arg)
    local id = tonumber(arg)
    if id == nil or not sampIsPlayerConnected(id) then
        if not setting.cef_notif then
            sampAddChatMessage('[SH]{FFFFFF} ' .. 'Используйте {a8a8a8}/punish [id игрока]', 0xFF5345)
        else
            cefnotig('{FF5345}[SH]{FFFFFF} ' .. 'Используйте {a8a8a8}/punish [id игрока]', 2000)
        end
        return
    end
    
    if setting.org ~= 10 then
        if not setting.cef_notif then
            sampAddChatMessage('[SH]{FFFFFF} ' .. 'Вы не работаете в тюрьме строгого режима.', 0xFF5345)
        else
            cefnotig('{FF5345}[SH]{FFFFFF} ' .. 'Вы не работаете в тюрьме строгого режима.', 2000)
        end
        return
    end
    
    local tsr_dir = sh_tsr_dir .. '/'
    if not doesDirectoryExist(tsr_dir) then
        createDirectory(tsr_dir)
    end
    
    local auto_punish_dir = tsr_dir .. 'AutoPunish/'
    if not doesDirectoryExist(auto_punish_dir) then
        createDirectory(auto_punish_dir)
    end
    
    load_punish_reasons()
    
    smartPunishState.targetId[0] = id
    smartPunishState.isIncrease = true
    smartPunishState.chapterStates = {}
    smartPunishState.searchQuery = ''
    windows.smart_punish[0] = true
    smartPunishState.anim.is_opening = true
    smartPunishState.anim.is_closing = false
end


function send_smart_punish_commands(commands)
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


function test_punish_func(arg)
	local id = tonumber(arg)
	if id == nil or not sampIsPlayerConnected(id) then
		if not setting.cef_notif then
			sampAddChatMessage('[SH]{FFFFFF} Используйте {a8a8a8}/testpunish [id игрока]', 0xFF5345)
		else
			cefnotig('{FF5345}[SH]{FFFFFF} Используйте {a8a8a8}/testpunish [id игрока]', 2000)
		end
		return
	end
	
	load_punish_reasons()
	
	smartPunishState.targetId[0] = id
	smartPunishState.isIncrease = true
	smartPunishState.chapterStates = {}
	smartPunishState.searchQuery = ''
	windows.smart_punish[0] = true
	smartPunishState.anim.is_opening = true
	smartPunishState.anim.is_closing = false
end



function openSmartFastMenu(targetId)
    if not setting then
        return
    end
    
    if not setting.fast then
        return
    end
    
    if not setting.fast.func then
        if not setting.cef_notif then
            sampAddChatMessage('[SH]{FFFFFF} Быстрое меню отключено в настройках.', 0xFF5345)
        else
            cefnotig('{FF5345}[SH]{FFFFFF} Быстрое меню отключено в настройках.', 3000)
        end
        return
    end
    
    if setting.smart_fast_menu then
        syncFastActions()
        
        local withoutId, withId = splitActionsByType()
        smartFastState.actionsWithoutId = withoutId
        smartFastState.actionsWithId = withId
        
        local success, result = pcall(function()
            return getNearbyPlayers()
        end)
        
        if success then
            smartFastState.playersList = result or {}
        else
            smartFastState.playersList = {}
        end
        
        smartFastState.selectedPlayer = nil
        local selectedId = nil
        
        if targetId and tonumber(targetId) then
            selectedId = tonumber(targetId)
        elseif targ_id ~= -1 and targ_id ~= nil and sampIsPlayerConnected(targ_id) then
            local is_near = false
            for _, player in ipairs(smartFastState.playersList) do
                if player.id == targ_id then
                    is_near = true
                    break
                end
            end
            if is_near then
                selectedId = targ_id
            else
                targ_id = nil
            end
        end
        
        if selectedId then
            for _, player in ipairs(smartFastState.playersList) do
                if player.id == selectedId then
                    local player_color = sampGetPlayerColor(selectedId)
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
                    break
                end
            end
            
            if not smartFastState.selectedPlayer and targetId then
                if not setting.cef_notif then
                    sampAddChatMessage('[SH]{FFFFFF} Игрок с ID ' .. selectedId .. ' не найден рядом.', 0xFF5345)
                else
                    cefnotig('{FF5345}[SH]{FFFFFF} Игрок с ID ' .. selectedId .. ' не найден рядом.', 3000)
                end
                targ_id = nil
            end
        end
        
        smartFastState.visible = setting.visible_fast or 100
        smartFastState.isActive = true
        smartFastState.anim.is_opening = true
        smartFastState.anim.is_closing = false
        smartFastState.anim.alpha = 0.0
		
        
        imgui.ShowCursor = true
        windows.fast[0] = true
    else
        local id = targetId and tonumber(targetId)
        
        if id == nil then
            if targ_id ~= -1 and targ_id ~= nil and sampIsPlayerConnected(targ_id) then
                id = targ_id
            else
                old_fast_state.nick = 'No_Name'
                old_fast_state.id = -1
                old_fast_state.isActive = true
                windows.fast[0] = true
                imgui.ShowCursor = true
                return
            end
        end
        
        if not sampIsPlayerConnected(id) then
            if not setting.cef_notif then
                sampAddChatMessage('[SH]{FFFFFF} Игрок с ID ' .. id .. ' не найден.', 0xFF5345)
            else
                cefnotig('{FF5345}[SH]{FFFFFF} Игрок с ID ' .. id .. ' не найден.', 3000)
            end
            targ_id = nil
            return
        end
        
        if id == my.id then
            if not setting.cef_notif then
                sampAddChatMessage('[SH]{FFFFFF} Нельзя открыть быстрое меню на самого себя.', 0xFF5345)
            else
                cefnotig('{FF5345}[SH]{FFFFFF} Нельзя открыть быстрое меню на самого себя.', 3000)
            end
            targ_id = nil
            return
        end
        
        old_fast_state.nick = sampGetPlayerNickname(id)
        old_fast_state.id = id
        old_fast_state.isActive = true
        windows.fast[0] = true
        imgui.ShowCursor = true
    end
end



function main()
	repeat wait(300) until isSampAvailable()
	reset_state()
	injNotif()
	create_folder('Police', 'для полиции')

	local tencode_loading = false
	local function loadTenCodes()
		if tencode_loading then return end
		local tencode_path = sh_legacy_data_path('Police', 'tencode.json')
		local tencode_url = sh_project_remote_data_url('tencode.json')
		if doesFileExist(tencode_path) then
			local file = io.open(tencode_path, 'r')
			if file then
				local data = file:read('*a')
				file:close()
				local success, all_codes = pcall(decodeJson, u1251:iconv(data))
				if success and type(all_codes) == 'table' then
					tenCodes = all_codes[s_na] or all_codes["default"] or {}
				else
					os.remove(tencode_path)
					tencode_loading = true
					local ok = pcall(downloadUrlToFile, tencode_url, tencode_path, function(id, status)
						tencode_loading = false
						if status == dlstatus.STATUS_ENDDOWNLOADDATA then loadTenCodes() end
					end)
					if not ok then tencode_loading = false end
				end
			end
		else
			tencode_loading = true
			local ok = pcall(downloadUrlToFile, tencode_url, tencode_path, function(id, status)
				tencode_loading = false
				if status == dlstatus.STATUS_ENDDOWNLOADDATA then loadTenCodes() end
			end)
			if not ok then tencode_loading = false end
		end
	end

	local tencode_path = sh_legacy_data_path('Police', 'tencode.json')
	if not doesFileExist(tencode_path) then
		downloadUrlToFile(sh_project_remote_data_url('tencode.json'), tencode_path, function(id, status)
			if status == dlstatus.STATUS_ENDDOWNLOADDATA then
				lua_thread.create(function()
					wait(1500)
					loadTenCodes()
				end)
			end
		end)
	else
		loadTenCodes()
	end

	checkVehicleData()
	thread = lua_thread.create(function() return end)
	pos_new_memb = lua_thread.create(function() return end)
	
	setting = apply_settings('Настройки.json', 'настроек', setting)
	syncFastActions()
	autoFixFastActionsIdFlags()
	local settingsUpdated = false
	
	if setting.police_settings == nil or type(setting.police_settings) ~= 'table' then
		setting.police_settings = { wanted_list = nil }
		settingsUpdated = true
	end
	if setting.police_settings.wanted_list == nil or type(setting.police_settings.wanted_list) ~= 'table' then
		setting.police_settings.wanted_list = { func = false, dialog = false, invers = false, interior = false, size = 12, flag = 5, dist = 21, vis = 70, color = {title = 0xFFFF8585, default = 0xFFFFFFFF, work = 0xFFFF8C00}, pos = {x = sx - 30, y = sy / 3} }
		settingsUpdated = true
	end

	local existingGunIds = {}
	for _, weapon in ipairs(setting.gun) do
		existingGunIds[weapon.i_gun] = true
	end
	for _, defaultWeapon in ipairs(gun_orig) do
		if not existingGunIds[defaultWeapon.i_gun] then
			table.insert(setting.gun, deep_copy(defaultWeapon))
			settingsUpdated = true
		end
	end

	if settingsUpdated then
		save()
	end

	reload_punish_cmd()

	local old_cmds_file = sh_legacy_data_path('Настройки.json')
	local base_dir = sh_roleplay_dir .. '/'

	if doesFileExist(old_cmds_file) then	
		sampAddChatMessage('[SH]{FFFFFF} Обнаружен старый файл отыгровок. Начинаем перенос в новую структуру...', 0xFF5345)
		lua_thread.create(function()
			wait(100)
			local f_old = io.open(old_cmds_file, 'r')
			if f_old then
				local old_data = f_old:read('*a')
				f_old:close()
				
				local res, old_cmd_table = pcall(decodeJson, old_data)
				if res and type(old_cmd_table) == 'table' then
					cmd = old_cmd_table
					save_cmd()
					os.remove(old_cmds_file)
					sampAddChatMessage('[SH]{FFFFFF} Перенос успешно завершен! Скрипт перезагрузится для применения изменений.', 0xFF5345)
					wait(1500)
					scr:reload()
				else
					sampAddChatMessage('[SH]{FFFFFF} Ошибка при чтении старого файла отыгровок. Перенос отменен.', 0xFF5345)
					create_folder('Отыгровки', 'отыгровок')
				end
			end
		end)
	else
		if doesDirectoryExist(base_dir) then
			local cat_file_path = base_dir .. 'categories.json'
			if doesFileExist(cat_file_path) then
				local f_cat = io.open(cat_file_path, 'r')
				if f_cat then
					local cat_data = f_cat:read('*a')
					f_cat:close()
					local res, cat_tbl = pcall(decodeJson, cat_data)
					if res and type(cat_tbl) == 'table' then
						cmd[2] = cat_tbl
					end
				end
			end

			cmd[1] = {}
			for folder_index, folder_data in ipairs(cmd[2]) do
				local folder_name = folder_data[1]
				local folder_path = base_dir .. folder_name .. '/'
				if doesDirectoryExist(folder_path) then
					for file in lfs.dir(folder_path) do
						if file:match('%.json$') then
							local file_path = folder_path .. file
							local f_cmd = io.open(file_path, 'r')
							if f_cmd then
								local cmd_data = f_cmd:read('*a')
								f_cmd:close()
								local res, cmd_obj = pcall(decodeJson, cmd_data)
								if res and type(cmd_obj) == 'table' then
									table.insert(cmd[1], cmd_obj)
								else
									if not setting.cef_notif then
										sampAddChatMessage('[SH]{FFFFFF} Ошибка чтения файла отыгровки: ' .. file, 0xFF5345)
									else
										cefnotig('{FF5345}[SH]{FFFFFF} Ошибка чтения файла отыгровки: ' .. file, 4000)
									end
								end
							end
						end
					end
				end
			end
		else
			create_folder('Отыгровки', 'отыгровок')
		end
	end
	
	local myid = nil
	repeat
		wait(100)
		if sampIsLocalPlayerSpawned() then
			local success, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
			if success and id then
				myid = id
			end
		end
	until myid

	my = {id = myid, nick = sampGetPlayerNickname(myid)}
	
	lua_thread.create(update_lists)
	lua_thread.create(time)
	create_folder('Шрифты', 'шрифтов')
	if #setting.fast.key ~= 0 then
		table.insert(all_keys, setting.fast.key)
		rkeys.registerHotKey(setting.fast.key, 3, true, function() on_hot_key(setting.fast.key) end)
	end
	table.insert(all_keys, setting.act_key[1])
	table.insert(all_keys, setting.enter_key[1])
	rkeys.registerHotKey(setting.act_key[1], 3, true, function() on_hot_key(setting.act_key[1]) end)
	rkeys.registerHotKey({72}, 1, false, function() on_hot_key({72}) end)
	if #setting.win_key[2] ~= 0 then
		rkeys.registerHotKey(setting.win_key[2], 3, true, function() on_hot_key(setting.win_key[2]) end)
		table.insert(all_keys, setting.win_key[2])
	end
	CefDialog()
	local ip, port = sampGetCurrentServerAddress()
	server = ip .. ':' .. port
	for server_name, ip_list in pairs(ips) do
		for _, ip_address in ipairs(ip_list) do
			if ip_address == server then
				s_na = server_name
				break
			end
		end
		if s_na ~= '' then
			break
		end
	end
	if #cmd[1] ~= 0 then
		local bool_uid_save = false
		for i = 1, #cmd[1] do
			if cmd[1][i].UID == nil then
				cmd[1][i].UID = math.random(20, 95000000)
				bool_uid_save = true
			end
			
			for h, v in ipairs(cmd[1][i].act) do
				if v[1] == 'IF' then
					if v[5] == nil then
						v[5] = 1
					end
				end
			end

			if cmd[1][i].cmd ~= '' then
				sampRegisterChatCommand(cmd[1][i].cmd, function(arg) cmd_start(arg, tostring(cmd[1][i].UID) .. cmd[1][i].cmd) end)
				
				if cmd[1][i].cmd == 'licdig' then
					for u = 1, #cmd[1][i].act do
						if cmd[1][i].act[u][1] == 'DIALOG' then
							if cmd[1][i].act[u][2] == '' then
								cmd[1][i].act[u][2] = '1'
								bool_uid_save = true
							end
						end
					end
				end
				
				if s_na == 'Phoenix' and cmd[1][i].cmd == 'mc' and setting.new_mc then 
					setting.new_mc = false
					cmd[1][i] = mc_phoenix
					bool_uid_save = true
				elseif setting.first_start then 
					setting.new_mc = false
				end
			end
			
			if #cmd[1][i].key[2] ~= 0 then
				rkeys.registerHotKey(cmd[1][i].key[2], 3, true, function() on_hot_key(cmd[1][i].key[2]) end)
				table.insert(all_keys, cmd[1][i].key[2])
			end
		end
		if bool_uid_save then
			save_cmd()
		end
	end
	if #setting.shp ~= 0 then
		for i = 1, #setting.shp do
			local shp_to_reg = setting.shp[i]
			sampRegisterChatCommand(shp_to_reg.cmd, function(arg) cmd_shpora_open(arg, tostring(shp_to_reg.UID) .. shp_to_reg.cmd) end)
			if #shp_to_reg.key[2] ~= 0 then
				rkeys.registerHotKey(shp_to_reg.key[2], 3, true, function() on_hot_key(shp_to_reg.key[2]) end)
				table.insert(all_keys, shp_to_reg.key[2])
			end
		end
	end
	for i = 1, #setting.key_tabs do
		if #setting.key_tabs[i][2] ~= 0 then
			rkeys.registerHotKey(setting.key_tabs[i][2], 3, true, function() on_hot_key(setting.key_tabs[i][2]) end)
			table.insert(all_keys, setting.key_tabs[i][2])
		end
	end
	if setting.police_settings.siren and #setting.police_settings.siren_key[2] ~= 0 then
		rkeys.registerHotKey(setting.police_settings.siren_key[2], 3, true, function() on_hot_key(setting.police_settings.siren_key[2]) end)
		table.insert(all_keys, setting.police_settings.siren_key[2])
	end
	if setting.police_settings.smart_su and (setting.org >= 11 and setting.org <= 15) then
		sampRegisterChatCommand('su', smart_su_func)
		download_wanted_reasons()
	end
	if setting.police_settings.smart_ticket and (setting.org >= 11 and setting.org <= 15) then
		sampRegisterChatCommand('ticket', smart_ticket_func)
		download_ticket_reasons()
	end
	if setting.tsr_settings.smart_punish and setting.org == 10 then
		sampRegisterChatCommand('punish', smart_punish_func)
		download_punish_reasons()
	end
	if setting.cl == 'White' then
		change_design('White', false)
	else
		change_design('Black', false)
	end
	sampRegisterChatCommand("st", function(param) 
		processCommand(param, "time") 
	end)
	
	sampRegisterChatCommand("sw", function(param)
		processCommand(param, "weather")
	end)
	if setting.godeath.func and setting.godeath.cmd_go then
		sampRegisterChatCommand('go', function()
			go_medic_or_fire()
		end)
	end
	
	if setting.dep_off then
		sampRegisterChatCommand('d', function()
			if not setting.cef_notif then
				sampAddChatMessage('[SH]{FFFFFF} Вы отключили команду /d Ънастройках.', 0xFF5345)
			else
				cefnotig('{FF5345}[SH]{FFFFFF} Вы отключили команду /d Ънастройках.', 3000)
			end
		end)
	end
	
	if setting.accent.d and not setting.dep_off then
		sampRegisterChatCommand('d', function(text_accents_d) 
			if text_accents_d ~= '' and setting.accent.func and setting.accent.d and setting.accent.text ~= '' then
				sampSendChat('/d ['..u8:decode(setting.accent.text)..' акцент]: '..text_accents_d)
			else
				sampSendChat('/d '..text_accents_d)
			end 
		end)
	end
	
	if setting.ts then
		sampRegisterChatCommand('ts', print_scr_time)
	end
	
	if setting.cmd_open_win ~= '' then
		sampRegisterChatCommand(setting.cmd_open_win, function(arg)
			start_other_cmd(setting.cmd_open_win, arg)
		end)
	end
	
	for i = 1, #setting.command_tabs do
		if setting.command_tabs[i] ~= '' then
			sampRegisterChatCommand(setting.command_tabs[i], function(arg)
				start_other_cmd(setting.command_tabs[i], arg)
			end)
		end
	end
	
	
	col_mb = {
		title = convert_color(setting.mb.color.title),
		default = convert_color(setting.mb.color.default),
		work = convert_color(setting.mb.color.work)
	}
	fontes = renderCreateFont('Trebuchet MS', setting.mb.size, setting.mb.flag)
	col_wanted = {
		title = convert_color(setting.police_settings.wanted_list.color.title),
		default = convert_color(setting.police_settings.wanted_list.color.default)
	}
	fontes_wanted = renderCreateFont('Trebuchet MS', setting.police_settings.wanted_list.size, setting.police_settings.wanted_list.flag)
	if setting.mb.func then
		members_wait.members = true
		sampSendChat('/members')
	end
	update_text_dep()
	add_cmd_in_all_cmd()
	
	if setting.hi_mes then
		if not setting.cef_notif then
			sampAddChatMessage(string.format('[SH]{FFFFFF} %s, для активации главного меню, отправьте в чат {a8a8a8}/sh', my.nick:gsub('_',' ')), 0xFF5345)
		else
			cefnotig('{FF5345}[SH]{FFFFFF} ' .. my.nick:gsub('_',' ') .. ', для активации главного меню, отправьте в чат {a8a8a8}/sh', 4000)
		end
	end
	
	if setting.first_start then
		update_scr_check = 5
		search_for_new_version = 30
	end
	
	if setting.button_close == 2 then
		an[28] = 806
	end
	
	while true do wait(0)

		ghetto_notify_func()

		if not setting.blockl then
			if wanted_update then
				local new_wanted_list = {}
				local existing_ids = {}
				for _, player in ipairs(emp_wanted_players) do
					if player.id and not existing_ids[player.id] then
						table.insert(new_wanted_list, player)
						existing_ids[player.id] = true
					end
				end
				
				table.sort(new_wanted_list, function(a, b)
					return tonumber(a.level) > tonumber(b.level)
				end)
				
				wanted_players = new_wanted_list
				wanted_info.online = #new_wanted_list
				wanted_update = false
			end
			if #command_queue > 0 then
				local cmd_to_run = table.remove(command_queue, 1)
				if cmd_to_run then
					sampProcessChatInput(cmd_to_run)
				end
			end
			connetion()
			updateTime()
			local current_time = os.clock()
			anim = current_time - anim_clock
			anim_clock = current_time
			
			if sampIsDialogActive() then
				lastDialogWasActive = os.clock()
			end
			
			res_targ, ped_tar = getCharPlayerIsTargeting(PLAYER_HANDLE)
			if res_targ then
				_, targ_id = sampGetPlayerIdByCharHandle(ped_tar)
			end
			
			if setting.auto_tazer then
				local num_weap = getCurrentCharWeapon(playerPed)
				if num_weap == 3 and not bool_tazer then 
					sampSendChat('/me сняв дубинку с пояса, взял' .. sex('', 'а') .. ' её в правую руку')
					bool_tazer = true
				elseif num_weap ~= 3 and bool_tazer then
					sampSendChat('/me повесил' .. sex('', 'а') .. ' дубинку на пояс')
					bool_tazer = false
				end
			end
			
			if send_chat_rp then
				if not setting.auto_close_doc then
					local texts_rp_all = {
						'/me взял' .. sex('', 'а') .. ' документ с рук человека напротив, внимательно его изучил' .. sex('', 'а') .. ', после чего вернул' .. sex('', 'а') .. ' обратно',
						'/me внимательно рассмотрел' .. sex('', 'а') .. ' документ, который был передан ' .. sex('ему', 'ей') .. ' с рук человека напротив',
						'/me взял' .. sex('', 'а') .. ' документ с рук человека и осмотрел' .. sex('', 'а') .. ' его с пристальным вниманием',
						'/me взял' .. sex('', 'а') .. ' документ с рук собеседника и провел' .. sex('', 'а') .. ' по нему взглядом для ознакомления с его содержимым',
						'/me взял' .. sex('', 'а') .. ' документ и тщательно изучил' .. sex('', 'а') .. ' его, после чего вернул' .. sex('', 'а') .. ' обратно'
					}
					local random_index = math.random(1, #texts_rp_all)
					local text_rp = texts_rp_all[random_index]
					sampSendChat(text_rp)
					send_chat_rp = false
				end
			end
			
			if isKeyJustPressed(VK_Q) then
				TEST = TEST + 1
			end
			
			if not scene_active then
				if setting.mb.func and not isGamePaused() and ((setting.mb.dialog and not sampIsDialogActive() and not sampIsCursorActive() and not sampIsChatInputActive() and not isSampfuncsConsoleActive()) or not setting.mb.dialog) then
					render_members()
				elseif setting.mb.func and pos_new_memb:status() ~= 'dead' then
					render_members()
				end
				if setting.police_settings.wanted_list.func and (setting.org >= 11 and setting.org <= 15) and not isGamePaused() and ((setting.police_settings.wanted_list.dialog and not sampIsDialogActive() and not sampIsCursorActive() and not sampIsChatInputActive() and not isSampfuncsConsoleActive()) or not setting.police_settings.wanted_list.dialog) then
					render_wanted()
				end
			end
			
			if setting.time_hud or setting.display_map_distance.user or setting.display_map_distance.server then
				if not isPauseMenuActive() and not isGamePaused() and not scene_active then
					time_hud_func_and_distance_point()
				end
			end
			
			if setting.replace_not_flood then
				if replace_not_flood[1] > 0 and not isGamePaused() then
					if replace_not_flood[1] > 3 and replace_not_flood[4] < 255 then
						replace_not_flood[4] = replace_not_flood[4] + (500 * anim)
						if replace_not_flood[4] > 255 then replace_not_flood[4] = 255 end
					elseif replace_not_flood[1] <= 3 and replace_not_flood[4] > 0 then
						replace_not_flood[4] = replace_not_flood[4] - (500 * anim)
						if replace_not_flood[4] < 0 then replace_not_flood[4] = 0 end
					end
					
					if not sampIsChatInputActive() then
						if replace_not_flood[5] == 1 then
							renderFontDrawText(font_flood, 'Не флуди!', replace_not_flood[2], replace_not_flood[3] - 7, join_argb(replace_not_flood[4], 255, 64, 64))
						else
							renderFontDrawText(font_flood, 'Не флуди! X' .. replace_not_flood[5], replace_not_flood[2], replace_not_flood[3] - 7, join_argb(replace_not_flood[4], 255, 64, 64))
						end
					end
				end
			end
			
			if not isGamePaused() and play.status ~= 'NULL' then
				control_song_when_finished()
			elseif isGamePaused() and play.status == 'PLAY' then
				if get_status_potok_song() == 1 then
					bass.BASS_ChannelPause(play.stream)
				end
			end
			
			if not is_mini_player_pos then
				if play.status ~= 'NULL' and setting.mini_player then
					windows.player[0] = true
				else
					windows.player[0] = false
				end
			end
			
			if play.tab ~= 'RECORD' and play.tab ~= 'RADIO' and play.status ~= 'NULL' and get_status_potok_song() == 1 then
				play.pos_time = time_song_position(play.len_time)
			end
			
			if not isGamePaused() then
				if scene_active or scene_edit_pos or (new_scene and scene.preview) then
					scene_work()
				end
			end
			
			if setting.stat_on_screen.func then
				windows.stat[0] = true
			else
				windows.stat[0] = false
			end
			
			if setting.gun_func then
				local gun_ped = getCurrentCharWeapon(playerPed)
				
				for i = 1, #setting.gun do
					if anti_spam_gun[1] ~= -1 and anti_spam_gun[1] ~= gun_ped and anti_spam_gun[1] ~= setting.gun[i].i_gun and anti_spam_gun[3] == 0 then
						for m = 1, #setting.gun do
							if setting.gun[m].put and setting.gun[m].i_gun == anti_spam_gun[1] then
								sampSendChat(u8:decode(sex_decode(setting.gun[m].put_rp)))
								break
							end
						end
						anti_spam_gun[1] = -1
						anti_spam_gun[3] = 2
					elseif anti_spam_gun[1] == -1 and gun_ped == setting.gun[i].i_gun and anti_spam_gun[3] == 0 then
						if setting.gun[i].take then
							sampSendChat(u8:decode(sex_decode(setting.gun[i].take_rp)))
						end
						anti_spam_gun[1] = gun_ped
						anti_spam_gun[3] = 2
					end
				end
			else
				anti_spam_gun[1] = -1
			end
			
			if update_scr_check == 0 then
				update_check()
				update_scr_check = 7000
			end
			
			if developer_mode > 8 then
				developer_mode = 0
				if not dev_mode then
					if not setting.cef_notif then
						sampAddChatMessage('[SH] Активирован режим отладки кода.', 0xFF5345)
					else
						cefnotig('{FF5345}[SH] Активирован режим отладки кода.', 3000)
					end
					dev_mode = true
					open_main()
				else
					if not setting.cef_notif then
						sampAddChatMessage('[SH] Отключён режим отладки кода.', 0xFF5345)
					else
						cefnotig('{FF5345}[SH] Отключён режим отладки кода.', 3000)
					end
					dev_mode = false
				end
			end
		end
		if not setting or not setting.fast then
			sampAddChatMessage('[SH] Критическая ошибка настроек', 0xFF5345)
			return
		end
	end
end

--> Кастомные элементы
local gui = {}
function gui.Draw(pos_draw, size_imvec2, col_draw_imvec4, radius_draw, flag_draw)
	imgui.SetCursorPos(imgui.ImVec2(0, 0))
	local p = imgui.GetCursorScreenPos()
	imgui.GetWindowDrawList():AddRectFilled(imgui.ImVec2(p.x + pos_draw[1], p.y + pos_draw[2]), imgui.ImVec2(p.x + size_imvec2[1] + pos_draw[1], p.y + size_imvec2[2] + pos_draw[2]), imgui.GetColorU32Vec4(col_draw_imvec4), radius_draw, flag_draw)
end

function gui.DrawBox(pos_draw, size_imvec2, col_draw_imvec4, col_draw_imvec4_emp, radius_draw, flag_draw)
	imgui.SetCursorPos(imgui.ImVec2(0, 0))
	local p = imgui.GetCursorScreenPos()
	imgui.GetWindowDrawList():AddRectFilled(imgui.ImVec2(p.x + pos_draw[1], p.y + pos_draw[2]), imgui.ImVec2(p.x + size_imvec2[1] + pos_draw[1], p.y + size_imvec2[2] + pos_draw[2]), imgui.GetColorU32Vec4(col_draw_imvec4), 0, flag_draw)
	
	pos_draw[1], pos_draw[2] = pos_draw[1] - 1.5, pos_draw[2] - 1.5
	size_imvec2[1], size_imvec2[2] = size_imvec2[1] + 3, size_imvec2[2] + 3
	imgui.GetWindowDrawList():AddRect(imgui.ImVec2(p.x + pos_draw[1], p.y + pos_draw[2]), imgui.ImVec2(p.x + size_imvec2[1] + pos_draw[1], p.y + size_imvec2[2] + pos_draw[2]), imgui.GetColorU32Vec4(col_draw_imvec4_emp), radius_draw - 3, flag_draw, 1.5)
end

function gui.DrawEmp(pos_draw, size_imvec2, col_draw_imvec4, radius_draw, flag_draw, thickness_emp)
	imgui.SetCursorPos(imgui.ImVec2(0, 0))
	local p = imgui.GetCursorScreenPos()
	imgui.GetWindowDrawList():AddRect(imgui.ImVec2(p.x + pos_draw[1], p.y + pos_draw[2]), imgui.ImVec2(p.x + size_imvec2[1] + pos_draw[1], p.y + size_imvec2[2] + pos_draw[2]), imgui.GetColorU32Vec4(col_draw_imvec4), radius_draw, flag_draw, thickness_emp)
end

function gui.DrawCircle(pos_draw, radius_draw, col_draw_imvec4)
	imgui.SetCursorPos(imgui.ImVec2(0, 0))
	local p = imgui.GetCursorScreenPos()
	imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x + pos_draw[1], p.y + pos_draw[2]), radius_draw, imgui.GetColorU32Vec4(col_draw_imvec4), 60)
end

function gui.DrawCircleEmp(pos_draw, radius_draw, col_draw_imvec4, thickness)
	imgui.SetCursorPos(imgui.ImVec2(0, 0))
	local p = imgui.GetCursorScreenPos()
	imgui.GetWindowDrawList():AddCircle(imgui.ImVec2(p.x + pos_draw[1], p.y + pos_draw[2]), radius_draw, imgui.GetColorU32Vec4(col_draw_imvec4), 60, thickness)
end

function gui.DrawLine(pos_draw_A, pos_draw_B, col_draw_imvec4, thickness_line)
	imgui.SetCursorPos(imgui.ImVec2(0, 0))
	local p = imgui.GetCursorScreenPos()
	imgui.GetWindowDrawList():AddLine(imgui.ImVec2(p.x + pos_draw_A[1], p.y + pos_draw_A[2]), imgui.ImVec2(p.x + pos_draw_B[1], p.y + pos_draw_B[2]), imgui.GetColorU32Vec4(col_draw_imvec4), (thickness_line or nil))
end

function new_draw(pos_draw_y, size_draw_y)
	gui.DrawBox({16, pos_draw_y}, {586, size_draw_y}, cl.tab, cl.line, 7, 15)
end

function gui.Text(pos_text_x, pos_text_y, text_gui, font_text_gui)
	if font_text_gui then
		imgui.PushFont(font_text_gui)
	end
	imgui.SetCursorPos(imgui.ImVec2(pos_text_x, pos_text_y))
	imgui.Text(u8(text_gui))
	if font_text_gui then
		imgui.PopFont()
	end
end

function gui.FaText(pos_text_x, pos_text_y, fa_text_gui, font_text_gui, fa_style_color)
	if fa_style_color then
		imgui.PushStyleColor(imgui.Col.Text, fa_style_color)
	end
	if font_text_gui then
		imgui.PushFont(font_text_gui)
	end
	imgui.SetCursorPos(imgui.ImVec2(pos_text_x, pos_text_y))
	imgui.Text(fa_text_gui)
	if font_text_gui then
		imgui.PopFont()
	end
	if fa_style_color then
		imgui.PopStyleColor(1)
	end
end

function gui.TextInfo(pos_textinfo, text_info)
	imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50, 0.50, 0.50, 0.70))
	for i = 1, #text_info do
		gui.Text(pos_textinfo[1], pos_textinfo[2] + ((i - 1) * 14), text_info[i], font[2])
	end
	imgui.PopStyleColor(1)
end

function gui.TextGradient(string, speed, visible)
	local function transfusion(speed_f, visible_text, pl_rgb)
		local r = math.floor(math.sin((os.clock() + pl_rgb) * speed_f) * 127 + 128) / 255
		local g = math.floor(math.sin((os.clock() + pl_rgb) * speed_f + 2) * 127 + 128) / 255
		local b = math.floor(math.sin((os.clock() + pl_rgb) * speed_f + 4) * 127 + 128) / 255
		
		return imgui.ImVec4(r, g, b, (visible_text or 1))
	end
	
	local function render_text(string)
		for w in string:gmatch('[^\r\n]+') do
			for i = 1, #w do
				local char = u8(w:sub(i, i))
				local color = transfusion(speed, visible, (0.15 * i))
				imgui.TextColored(color, char)
				imgui.SameLine(nil, 0)
			end
			imgui.NewLine()
		end
	end
	
	render_text(string)
end

function gui.Button(text_button, pos_draw, size_imvec2, activity_button)
	local bool_button = false
	local col_stand_imvec4 = cl.bg
	local col_text_imvec4 = cl.text
	
	if activity_button ~= nil then
		col_stand_imvec4 = imgui.ImVec4(0.50, 0.50, 0.50, 0.50)
		if setting.cl == 'White' then
			col_text_imvec4 = imgui.ImVec4(0.98, 0.98, 0.98, 0.50)
		else
			col_text_imvec4 = imgui.ImVec4(0.60, 0.60, 0.60, 0.50)
		end
	end
	imgui.SetCursorPos(imgui.ImVec2(pos_draw[1], pos_draw[2]))
	if imgui.InvisibleButton(text_button, imgui.ImVec2(size_imvec2[1], size_imvec2[2])) then
		bool_button = true
	end
	if imgui.IsItemActive() and activity_button == nil then
		col_stand_imvec4 = cl.def
		col_text_imvec4 = imgui.ImVec4(0.95, 0.95, 0.95, 1.00)
	end
	imgui.PushStyleColor(imgui.Col.Text, col_text_imvec4)
	imgui.PushFont(font[3])
	imgui.SetCursorPos(imgui.ImVec2(0, 0))
	local p = imgui.GetCursorScreenPos()
	imgui.GetWindowDrawList():AddRectFilled(imgui.ImVec2(p.x + pos_draw[1], p.y + pos_draw[2]), imgui.ImVec2(p.x + size_imvec2[1] + pos_draw[1], p.y + size_imvec2[2] + pos_draw[2]), imgui.GetColorU32Vec4(col_stand_imvec4), 5, 15)
	if setting.cl == 'White' then
		imgui.GetWindowDrawList():AddRect(imgui.ImVec2(p.x + (pos_draw[1] - 1), p.y + (pos_draw[2] - 1)), imgui.ImVec2(p.x + (size_imvec2[1] + 2) + (pos_draw[1] - 1), p.y + (size_imvec2[2] + 2) + (pos_draw[2] - 1)), imgui.GetColorU32Vec4(imgui.ImVec4(0.88, 0.88, 0.88, 1.00)), 5, 15)
	end
	if text_button:find('##') then
		text_button = text_button:gsub('##(.+)', '')
	end
	local calc = imgui.CalcTextSize(text_button)
	imgui.SetCursorPos(imgui.ImVec2((pos_draw[1] - (calc.x / 2)) + (size_imvec2[1] / 2), (pos_draw[2] - (calc.y / 2)) + (size_imvec2[2] / 2)))
	
	imgui.Text(text_button)
	imgui.PopStyleColor(1)
	imgui.PopFont()
	
	return bool_button
end

function gui.InputText(pos_draw, size_input, arg_text, name_input, buf_size_input, text_about, filter_buf, flag_input)
	if type(buf_size_input) ~= 'number' or buf_size_input < 1 then
		buf_size_input = 1
	end
	local safe_arg_text = sh_safe_locale_text(arg_text)
	local safe_name_input = sh_safe_locale_text(name_input)
	local arg_text_buf = imgui.new.char[buf_size_input](safe_arg_text)
	local col_stand_imvec4 = cl.bg
	local ret_true = false
	local input_flags = flag_input or imgui.InputTextFlags.EnterReturnsTrue
	if filter_buf == nil then filter_buf = '' end
	if filter_buf:find('money') then
		-- Compact money format is handled later by the currency parser.
	elseif filter_buf:find('num') then
		input_flags = input_flags + imgui.InputTextFlags.CharsDecimal
	elseif filter_buf:find('rus') or filter_buf:find('en') or filter_buf:find('ernh') or filter_buf:find('ern') or filter_buf:find('esp') then
		input_flags = input_flags + imgui.InputTextFlags.CallbackCharFilter
	end
	
	gui.Draw({pos_draw[1] - 3, pos_draw[2] - 5}, {size_input + 10, 23}, col_stand_imvec4, 0, 15)
	gui.DrawEmp({pos_draw[1] - 5, pos_draw[2] - 7}, {size_input + 14, 27}, cl.def, 3, 15, 2)

	imgui.PushFont(font[3])
	imgui.SetCursorPos(imgui.ImVec2(pos_draw[1], pos_draw[2] - 2))
	imgui.PushItemWidth(size_input)
	
	if filter_buf:find('rus') then
		ret_true = imgui.InputText('##inp' .. safe_name_input, arg_text_buf, ffi.sizeof(arg_text_buf), input_flags, TextCallbackRus)
	elseif filter_buf:find('en') then
		ret_true = imgui.InputText('##inp' .. safe_name_input, arg_text_buf, ffi.sizeof(arg_text_buf), input_flags, TextCallbackEn)
	elseif filter_buf:find('ernh') then
		ret_true = imgui.InputText('##inp' .. safe_name_input, arg_text_buf, ffi.sizeof(arg_text_buf), input_flags, TextCallbackEnRusNumH)
	elseif filter_buf:find('ern') then
		ret_true = imgui.InputText('##inp' .. safe_name_input, arg_text_buf, ffi.sizeof(arg_text_buf), input_flags, TextCallbackEnRusNum)
	elseif filter_buf:find('esp') then
		ret_true = imgui.InputText('##inp' .. safe_name_input, arg_text_buf, ffi.sizeof(arg_text_buf), input_flags, TextCallbackEnNum)
	else
		ret_true = imgui.InputText('##inp' .. safe_name_input, arg_text_buf, ffi.sizeof(arg_text_buf), input_flags)
	end
	
	if text_about ~= nil and (ffi.string(arg_text_buf) == '' and not imgui.IsItemActive()) then
		imgui.SetCursorPos(imgui.ImVec2(pos_draw[1] + 3, pos_draw[2] - 2))
		imgui.TextColored(imgui.ImVec4(0.50, 0.50, 0.50, 0.50), text_about)
	end
	imgui.PopFont()
	
	return ffi.string(arg_text_buf), ret_true
end

function gui.InputFalse(text_input, pos_x, pos_y, size_input)
	local function truncate_text_to_fit(text, max_width)
		local truncated_text = text
		local text_size = imgui.CalcTextSize(text)
		
		if text_size.x > max_width then
			for i = 1, #text do
				local partial_text = text:sub(1, i)
				local partial_width = imgui.CalcTextSize(partial_text).x

				if partial_width > max_width then
					truncated_text = text:sub(1, i - 1)
					
					break
				end
			end
		end

		return truncated_text
	end
	
	gui.Draw({pos_x - 3, pos_y - 5}, {size_input + 10, 23}, (setting.cl == 'Black' and cl.bg) or imgui.ImVec4(0.80, 0.80, 0.80, 0.80) , 3, 15)
	imgui.SetCursorPos(imgui.ImVec2(pos_x, pos_y - 2))
	imgui.PushFont(font[3])
	local display_text = truncate_text_to_fit(text_input, size_input)
	imgui.Text(display_text)
	imgui.PopFont()
end

function gui.ListTable(pos_draw, size_imvec2, arg_table, arg_num, name_table)
	local col_stand_imvec4 = cl.bg

	imgui.SetCursorPos(imgui.ImVec2(0, 0))
	local p = imgui.GetCursorScreenPos()
	imgui.GetWindowDrawList():AddRectFilled(imgui.ImVec2(p.x + pos_draw[1], p.y + pos_draw[2]), imgui.ImVec2(p.x + size_imvec2[1] + pos_draw[1], p.y + size_imvec2[2] + pos_draw[2]), imgui.GetColorU32Vec4(col_stand_imvec4), 2, 15)
	imgui.GetWindowDrawList():AddRect(imgui.ImVec2(p.x + (pos_draw[1] - 2), p.y + (pos_draw[2] - 2)), imgui.ImVec2(p.x + (size_imvec2[1] + 4) + (pos_draw[1] - 2), p.y + (size_imvec2[2] + 4) + (pos_draw[2] - 2)), imgui.GetColorU32Vec4(cl.def), 5, 15, 2)
	
	imgui.PushFont(font[3])
	if #arg_table ~= 0 and arg_num then
		for i = 1, #arg_table do
			local mi = i - 1
			if i == arg_num then
				imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.95, 0.95, 0.95, 1.00))
				local pos_y_dr = {pos_draw[1] - 1, (pos_draw[2] - 1) + (mi * 31)}
				imgui.GetWindowDrawList():AddRectFilled(imgui.ImVec2(p.x + pos_y_dr[1], p.y + pos_y_dr[2]), imgui.ImVec2(p.x + size_imvec2[1] + 2 + pos_y_dr[1], p.y + 31 + pos_y_dr[2]), imgui.GetColorU32Vec4(cl.def))
				imgui.SetCursorPos(imgui.ImVec2(pos_draw[1] + 10, pos_draw[2] + 6 + (mi * 31)))
				imgui.Text(arg_table[i])
				imgui.PopStyleColor(1)
			else
				imgui.SetCursorPos(imgui.ImVec2(pos_draw[1] + 10, pos_draw[2] + 6 + (mi * 31)))
				imgui.Text(arg_table[i])
			end
			imgui.SetCursorPos(imgui.ImVec2(pos_draw[1] - 1, (pos_draw[2] - 1) + (mi * 31)))
			if imgui.InvisibleButton(name_table .. i, imgui.ImVec2(size_imvec2[1] + 2, 31)) then
				arg_num = i
			end
		end
	end
	imgui.PopFont()
	
	return arg_num
end

function gui.LT_First_Start(pos_draw, size_imvec2, arg_table, arg_num, name_table)
	local col_stand_imvec4 = cl.bg

	imgui.SetCursorPos(imgui.ImVec2(0, 0))
	local p = imgui.GetCursorScreenPos()
	imgui.GetWindowDrawList():AddRectFilled(imgui.ImVec2(p.x + pos_draw[1], p.y + pos_draw[2]), imgui.ImVec2(p.x + size_imvec2[1] + pos_draw[1], p.y + size_imvec2[2] + pos_draw[2]), imgui.GetColorU32Vec4(col_stand_imvec4), 2, 15)
	imgui.GetWindowDrawList():AddRect(imgui.ImVec2(p.x + (pos_draw[1] - 2), p.y + (pos_draw[2] - 2)), imgui.ImVec2(p.x + (size_imvec2[1] + 4) + (pos_draw[1] - 2), p.y + (size_imvec2[2] + 4) + (pos_draw[2] - 2)), imgui.GetColorU32Vec4(cl.def), 5, 15, 2)
	
	local y_LT = 25
	imgui.PushFont(font[3])
	if #arg_table ~= 0 and arg_num then
		for i = 1, #arg_table do
			local mi = i - 1
			if i == arg_num then
				imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.95, 0.95, 0.95, 1.00))
				local pos_y_dr = {pos_draw[1] - 1, (pos_draw[2] - 1) + (mi * y_LT)}
				imgui.GetWindowDrawList():AddRectFilled(imgui.ImVec2(p.x + pos_y_dr[1], p.y + pos_y_dr[2]), imgui.ImVec2(p.x + size_imvec2[1] + 2 + pos_y_dr[1], p.y + y_LT + pos_y_dr[2]), imgui.GetColorU32Vec4(cl.def))
				imgui.SetCursorPos(imgui.ImVec2(pos_draw[1] + 10, pos_draw[2] + 4 + (mi * y_LT)))
				imgui.Text(arg_table[i])
				imgui.PopStyleColor(1)
			else
				imgui.SetCursorPos(imgui.ImVec2(pos_draw[1] + 10, pos_draw[2] + 4 + (mi * y_LT)))
				imgui.Text(arg_table[i])
			end
			imgui.SetCursorPos(imgui.ImVec2(pos_draw[1] - 1, (pos_draw[2] - 1) + (mi * y_LT)))
			if imgui.InvisibleButton(name_table .. i, imgui.ImVec2(size_imvec2[1] + 2, y_LT)) then
				arg_num = i
			end
		end
	end
	imgui.PopFont()
	
	return arg_num
end

function gui.ListTableHorizontal(pos_draw, arg_table, arg_num, name_table)
	local col_stand_imvec4 = cl.bg
	
	imgui.SetCursorPos(imgui.ImVec2(pos_draw[1], pos_draw[2]))
	local p = imgui.GetCursorScreenPos()
	imgui.GetWindowDrawList():AddRectFilled(imgui.ImVec2(p.x, p.y), imgui.ImVec2(p.x + (#arg_table * 120), p.y + 23), imgui.GetColorU32Vec4(col_stand_imvec4), 0, 15)
	imgui.GetWindowDrawList():AddRect(imgui.ImVec2(p.x - 2, p.y - 2), imgui.ImVec2(p.x + ((#arg_table * 120) + 4) - 2, p.y + 25), imgui.GetColorU32Vec4(cl.def), 3, 15, 2)
	
	imgui.PushFont(font[3])
	if #arg_table ~= 0 and arg_num then
		for i = 1, #arg_table do
			local mi = i - 1
			local calc = imgui.CalcTextSize(arg_table[i])
			if i == arg_num then
				imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.95, 0.95, 0.95, 1.00))
				imgui.SetCursorPos(imgui.ImVec2((pos_draw[1] - 1) + (mi * 120), pos_draw[2] - 1))
				local p = imgui.GetCursorScreenPos()
				imgui.GetWindowDrawList():AddRectFilled(imgui.ImVec2(p.x, p.y), imgui.ImVec2(p.x + 120 + 2, p.y + 25), imgui.GetColorU32Vec4(cl.def))
				imgui.SetCursorPos(imgui.ImVec2((pos_draw[1] + (60 - calc.x / 2)) + (mi * 120), pos_draw[2] + 4))
				imgui.Text(arg_table[i])
				imgui.PopStyleColor(1)
			else
				imgui.SetCursorPos(imgui.ImVec2((pos_draw[1] + (60 - calc.x / 2)) + (mi * 120), pos_draw[2] + 4))
				imgui.Text(arg_table[i])
			end
			imgui.SetCursorPos(imgui.ImVec2(pos_draw[1] + (mi * 120), pos_draw[2] - 1))
			if imgui.InvisibleButton(name_table .. i, imgui.ImVec2(120, 25)) then
				arg_num = i
			end
		end
	end
	imgui.PopFont()
	
	return arg_num
end

function gui.ListTableMove(pos_draw, arg_table, arg_num, name_table)
	local col_stand_imvec4 = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
	imgui.PushFont(font[3])
	local calc = imgui.CalcTextSize(arg_table[arg_num])
	
	if table_move ~= name_table then
		imgui.SetCursorPos(imgui.ImVec2(pos_draw[1] - 5 - calc.x, pos_draw[2] - 5))
		if imgui.InvisibleButton('##ListTableMove ' .. name_table, imgui.ImVec2(calc.x + 30, 26)) then
			table_move = name_table
		end
		if imgui.IsItemActive() then
			col_stand_imvec4 = cl.def
		elseif imgui.IsItemHovered() then
			col_stand_imvec4 = cl.bg
		end
		imgui.SetCursorPos(imgui.ImVec2(pos_draw[1] - 5 - calc.x, pos_draw[2] - 5))
		local p = imgui.GetCursorScreenPos()
		imgui.GetWindowDrawList():AddRectFilled(imgui.ImVec2(p.x, p.y), imgui.ImVec2(p.x + calc.x + 30, p.y + 26), imgui.GetColorU32Vec4(col_stand_imvec4), 7, 15)
		if setting.cl == 'White' then
			imgui.GetWindowDrawList():AddRect(imgui.ImVec2(p.x - 1, p.y - 1), imgui.ImVec2(p.x + calc.x + 32, p.y + 28), imgui.GetColorU32Vec4(imgui.ImVec4(0.88, 0.88, 0.88, 1.00)), 7, 15)
		end
	end
	
	imgui.SetCursorPos(imgui.ImVec2(pos_draw[1] - calc.x, pos_draw[2]))
	imgui.Text(arg_table[arg_num])
	
	imgui.SetCursorPos(imgui.ImVec2(pos_draw[1] + 5, pos_draw[2]))
	local p = imgui.GetCursorScreenPos()
	imgui.GetWindowDrawList():AddRectFilled(imgui.ImVec2(p.x, p.y), imgui.ImVec2(p.x + 14, p.y + 17), imgui.GetColorU32Vec4(imgui.ImVec4(0.50, 0.50, 0.50, 0.70)), 2, 15)
	
	imgui.PushFont(fa_font[2])
	imgui.SetCursorPos(imgui.ImVec2(pos_draw[1] + 8, pos_draw[2] + 1))
	imgui.Text(fa.SORT_UP)
	imgui.SetCursorPos(imgui.ImVec2(pos_draw[1] + 8, pos_draw[2] + 2))
	imgui.Text(fa.SORT_DOWN)
	imgui.PopFont()
	
	if table_move == name_table then
		local calc_very = 0
		for s = 1, #arg_table do
			local calc_bool = imgui.CalcTextSize(arg_table[s])
			if calc_bool.x > calc_very then
				calc_very = calc_bool.x
			end
		end
		calc_very = calc_very - calc.x
		
		imgui.SetCursorPos(imgui.ImVec2(pos_draw[1] - calc_very - 25 - calc.x, pos_draw[2] - 10))
		imgui.BeginChild(u8'Окно выбора листа'.. name_table, imgui.ImVec2(calc_very + calc.x + 39, 2 + (#arg_table * 27)), false, imgui.WindowFlags.NoMove + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse)
		
		imgui.SetCursorPos(imgui.ImVec2(0, 0))
		local p = imgui.GetCursorScreenPos()
		imgui.GetWindowDrawList():AddRectFilled(imgui.ImVec2(p.x, p.y), imgui.ImVec2(p.x + calc_very + calc.x + 39, p.y + 2 + (#arg_table * 27)), imgui.GetColorU32Vec4(cl.bg), 7, 15)
		
		for m = 1, #arg_table do
			local col_stand_imvec4_2 = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
			imgui.SetCursorPos(imgui.ImVec2(0, 1 + (m - 1) * 27))
			if imgui.InvisibleButton('##ListTableMoveSelect ' .. name_table .. m, imgui.ImVec2(calc_very + calc.x + 39, 27)) then
				table_move = ''
				arg_num = m
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
			imgui.GetWindowDrawList():AddRectFilled(imgui.ImVec2(p.x, p.y), imgui.ImVec2(p.x + calc_very + calc.x + 37, p.y + 27), imgui.GetColorU32Vec4(col_stand_imvec4_2), flag[1], flag[2])
			
			imgui.SetCursorPos(imgui.ImVec2(25, 6 + ((m - 1) * 27)))
			imgui.Text(arg_table[m])
			
			if m == arg_num then
				imgui.PushFont(fa_font[2])
				imgui.SetCursorPos(imgui.ImVec2(7, 6 + ((m - 1) * 27)))
				imgui.Text(fa.CHECK)
				imgui.PopFont()
			end
		end
		imgui.SetCursorPos(imgui.ImVec2(0, 0))
		local p = imgui.GetCursorScreenPos()
		imgui.GetWindowDrawList():AddRect(imgui.ImVec2(p.x, p.y), imgui.ImVec2(p.x + calc_very + calc.x + 39, p.y + 2 + (#arg_table * 27)), imgui.GetColorU32Vec4(cl.def), 7, 15)
		imgui.EndChild()
		
		if imgui.IsMouseReleased(0) and not imgui.IsItemHovered() then
			table_move = ''
		end
	end
	
	imgui.PopFont()
	
	return arg_num
end

function gui.Counter(pos_draw, arg_text, arg_num, arg_min, arg_max, name_counter)
	local col_stand_imvec4 = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
	imgui.PushFont(font[3])
	local calc = imgui.CalcTextSize(arg_text)
	imgui.SetCursorPos(imgui.ImVec2(pos_draw[1] - 5 - calc.x, pos_draw[2]))
	imgui.Text(arg_text)
	imgui.PopFont()
	
	imgui.SetCursorPos(imgui.ImVec2(pos_draw[1], pos_draw[2] - 3))
	if imgui.InvisibleButton(u8'##1' .. name_counter, imgui.ImVec2(14, 10)) then
		if arg_num < arg_max then
			arg_num = arg_num + 1
		end
	end
	if imgui.IsItemActive() and arg_num < arg_max then
		gui.Draw({pos_draw[1], pos_draw[2] - 3}, {14, 10}, cl.def, 2, 15)
	elseif arg_num < arg_max then
		gui.Draw({pos_draw[1], pos_draw[2] - 3}, {14, 10}, imgui.ImVec4(0.50, 0.50, 0.50, 0.70), 2, 15)
	else
		gui.Draw({pos_draw[1], pos_draw[2] - 3}, {14, 10}, imgui.ImVec4(0.50, 0.50, 0.50, 0.50), 2, 15)
	end
	imgui.SetCursorPos(imgui.ImVec2(pos_draw[1], pos_draw[2] + 10))
	if imgui.InvisibleButton(u8'##2' .. name_counter, imgui.ImVec2(14, 10)) then
		if arg_num > arg_min then
			arg_num = arg_num - 1
		end
	end
	if imgui.IsItemActive() and arg_num > arg_min then
		gui.Draw({pos_draw[1], pos_draw[2] + 10}, {14, 10}, cl.def, 2, 15)
	elseif arg_num > arg_min then
		gui.Draw({pos_draw[1], pos_draw[2] + 10}, {14, 10}, imgui.ImVec4(0.50, 0.50, 0.50, 0.70), 2, 15)
	else
		gui.Draw({pos_draw[1], pos_draw[2] + 10}, {14, 10}, imgui.ImVec4(0.50, 0.50, 0.50, 0.50), 2, 15)
	end
	
	imgui.PushFont(fa_font[2])
	imgui.SetCursorPos(imgui.ImVec2(pos_draw[1] + 3, pos_draw[2] - 2))
	if arg_num >= arg_max then
		imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
	end
	imgui.Text(fa.SORT_UP)
	if arg_num >= arg_max then
		imgui.PopStyleColor(1)
	end
	imgui.SetCursorPos(imgui.ImVec2(pos_draw[1] + 3, pos_draw[2] + 5))
	if arg_num <= arg_min then
		imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
	end
	imgui.Text(fa.SORT_DOWN)
	if arg_num <= arg_min then
		imgui.PopStyleColor(1)
	end
	imgui.PopFont()
	
	return arg_num
end

function gui.Switch(namebut, bool, disable)
	local rBool = false
	if LastActiveTime == nil then
		LastActiveTime = {}
	end
	if LastActive == nil then
		LastActive = {}
	end
	local function ImSaturate(f)
		return f < 0.06 and 0.06 or (f > 1.0 and 1.0 or f)
	end
	local p = imgui.GetCursorScreenPos()
	local draw_list = imgui.GetWindowDrawList()
	local height = imgui.GetTextLineHeightWithSpacing() * 1.35
	local width = height * 1.20
	local radius = height * 0.30
	local ANIM_SPEED = 0.09
	local butPos = imgui.GetCursorPos()
	
	local switch_active = true
	if disable ~= nil and disable == true then
		switch_active = false
	end

	if imgui.InvisibleButton(namebut, imgui.ImVec2(width, height)) and switch_active then
		bool = not bool
		rBool = true
		LastActiveTime[tostring(namebut)] = os.clock()
		LastActive[tostring(namebut)] = true
	end
	imgui.SetCursorPos(imgui.ImVec2(butPos.x + width + 3, butPos.y + 3.8))
	imgui.Text( namebut:gsub('##.+', ''))
	
	local t = bool and 1.0 or 0.06
	if LastActive[tostring(namebut)] then
		local time = os.clock() - LastActiveTime[tostring(namebut)]
		if time <= ANIM_SPEED then
			local t_anim = ImSaturate(time / ANIM_SPEED)
			t = bool and t_anim or 1.0 - t_anim
		else
			LastActive[tostring(namebut)] = false
		end
	end

	local col_neitral = 0xFF606060
	local col_static = 0xFFFFFFFF
	if setting.cl == 'White' then
		col_neitral = 0xFFD4CFCF
	end

	local current_color_bg = bool and imgui.ColorConvertFloat4ToU32(cl.def) or col_neitral
	local current_color_circle = col_static
	
	if not switch_active then
		current_color_bg = imgui.ColorConvertFloat4ToU32(imgui.ImVec4(0.50, 0.50, 0.50, 0.50))
		current_color_circle = imgui.ColorConvertFloat4ToU32(imgui.ImVec4(0.70, 0.70, 0.70, 0.50))
	end

	draw_list:AddRectFilled(imgui.ImVec2(p.x, p.y + (height / 6)), imgui.ImVec2(p.x + width - 1.0, p.y + (height - (height / 6))), current_color_bg, 10.0)
	draw_list:AddCircleFilled(imgui.ImVec2(p.x + radius + t * (width - radius * 2.3) + 0.6, p.y + 5 + radius), radius - 0.75, current_color_circle, 60)

	return rBool, bool
end

function gui.SwitchFalse(bool)
	local rBool = false
	local namebut = '##button_false_no_name'
	if LastActiveTime == nil then
		LastActiveTime = {}
	end
	if LastActive == nil then
		LastActive = {}
	end
	local function ImSaturate(f)
		return f < 0.06 and 0.06 or (f > 1.0 and 1.0 or f)
	end
	local p = imgui.GetCursorScreenPos()
	local draw_list = imgui.GetWindowDrawList()
	local height = imgui.GetTextLineHeightWithSpacing() * 1.35
	local width = height * 1.20
	local radius = height * 0.30
	local ANIM_SPEED = 0.09
	local butPos = imgui.GetCursorPos()
	imgui.SetCursorPos(imgui.ImVec2(butPos.x + width + 3, butPos.y + 3.8))
	imgui.Text(namebut:gsub('##.+', ''))
	local t = bool and 1.0 or 0.06
	if LastActive[tostring(namebut)] then
		local time = os.clock() - LastActiveTime[tostring(namebut)]
		if time <= ANIM_SPEED then
			local t_anim = ImSaturate(time / ANIM_SPEED)
			t = bool and t_anim or 1.0 - t_anim
		else
			LastActive[tostring(namebut)] = false
		end
	end
	local col_neitral = 0x80666666
	local col_static = 0x80999999
	if setting.cl == 'White' then
		col_neitral =  0x80666666 
		col_static = 0xCCD8D8D8
	end
	local col = bool and imgui.ColorConvertFloat4ToU32(cl.bg) or col_neitral
	draw_list:AddRectFilled(imgui.ImVec2(p.x, p.y + (height / 6)), imgui.ImVec2(p.x + width - 1.0, p.y + (height - (height / 6))), col, 10.0)
	draw_list:AddCircleFilled(imgui.ImVec2(p.x + radius + t * (width - radius * 2.3) + 0.6, p.y + 5 + radius), radius - 0.75, col_static, 60)
end

function gui.GetCursorScroll()
	local cursor_pos = imgui.GetMousePos()
	local screen_pos = imgui.GetWindowPos()
	local scroll_pos = {x = imgui.GetScrollX(), y = imgui.GetScrollY()}
	local end_pos = {x = (cursor_pos.x - screen_pos.x) + scroll_pos.x, y = (cursor_pos.y - screen_pos.y) + scroll_pos.y}
	
	return end_pos
end

function gui.SliderBar(slider_text, slider_arg, slider_min, slider_max, slider_width, slider_pos, saving_it)
	local arg_buf_format = imgui.new.float(slider_arg)
	if arg_buf_format[0] == 'nil' then
		arg_buf_format[0] = ''
	end
	
	imgui.SetCursorPos(imgui.ImVec2(slider_pos[1] + 5, slider_pos[2] + 9))

	local p = imgui.GetCursorScreenPos()
	imgui.SetCursorPos(imgui.ImVec2(slider_pos[1], slider_pos[2]))
	imgui.PushItemWidth(slider_width)
	imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
	imgui.PushStyleColor(imgui.Col.SliderGrab, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
	imgui.PushStyleColor(imgui.Col.SliderGrabActive, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
	imgui.SliderFloat(u8'##'..slider_text, arg_buf_format, slider_min, slider_max, u8'')
	imgui.PopStyleColor(3)

	local track_color = (setting.cl == 'White' and imgui.ImVec4(0.85, 0.85, 0.85, 1.00)) or imgui.ImVec4(0.21, 0.21, 0.21, 1.00)
	local knob_color = (setting.cl == 'White' and cl.def) or imgui.ImVec4(0.90, 0.90, 0.90, 1.00)

	local track_width = slider_width - 15
	local value_range = slider_max - slider_min
	if value_range == 0 then value_range = 1 end
	local value_ratio = (arg_buf_format[0] - slider_min) / value_range
	local filled_width = track_width * value_ratio

	imgui.GetWindowDrawList():AddRectFilled(imgui.ImVec2(p.x, p.y), imgui.ImVec2(p.x + track_width, p.y + 5), imgui.GetColorU32Vec4(track_color), 10, 15)
	imgui.GetWindowDrawList():AddRectFilled(imgui.ImVec2(p.x, p.y), imgui.ImVec2(p.x + filled_width, p.y + 5), imgui.GetColorU32Vec4(cl.def), 10, 15)
	imgui.GetWindowDrawList():AddCircleFilled(imgui.ImVec2(p.x + filled_width, p.y + 2.5), 9, imgui.GetColorU32Vec4(knob_color), 60)
	imgui.SameLine()

	if not slider_text:find('##') then
		imgui.PushFont(font[1])
		imgui.Text(slider_text)
		imgui.PopFont()
	end
	
	return arg_buf_format[0]
end

function gui.SliderCircle(name_slider, cur_pos, radius, angle, color, thickness, segments, max_val, arg_znach)
	imgui.SetCursorPos(imgui.ImVec2(cur_pos[1], cur_pos[2]))
	local cur = imgui.GetCursorScreenPos()
	local dl = imgui.GetWindowDrawList()
	local up_center = 15.04
	
	radius, angle, color, thickness, segments = radius or 25, angle or 360, color or 0xFFFFFFFF, thickness or 1, segments or 16
	
	--> Фон полукруга
	dl:PathArcTo(cur + imgui.ImVec2(radius, radius), radius, up_center, up_center + math.rad(angle), segments)
	dl:PathStroke(color, false, thickness)
	dl:PathClear()
	
	--> Заполненная шкала
	local max_value = arg_znach / (max_val / 140)
	local result_road = math.rad(1.8 * (max_value))
	dl:PathArcTo(cur + imgui.ImVec2(radius, radius), radius, up_center, up_center + result_road, segments)
	dl:PathStroke(imgui.GetColorU32Vec4(imgui.ImVec4(0.30, 0.85, 0.38, 1.00)), false, thickness)
	dl:PathClear()
	
	local max_value_2 = max_val / (max_val / 140)
	local result_road_2 = math.rad(1.8 * (max_value_2 + 3))
	local knobAngle_2 = up_center + result_road_2
	local knobX_2 = cur.x + radius + radius * math.cos(knobAngle_2)
	local knobY_2 = cur.y + radius + radius * math.sin(knobAngle_2)
	if max_val == arg_znach then
		dl:AddCircleFilled({knobX_2, knobY_2}, 6, imgui.GetColorU32Vec4(imgui.ImVec4(0.30, 0.85, 0.38, 1.00)), 20)
	else
		dl:AddCircleFilled({knobX_2, knobY_2}, 6, color, 20)
	end
	
	--> Ручка шкалы
	local knobAngle = up_center + result_road
	local knobX = cur.x + radius + radius * math.cos(knobAngle)
	local knobY = cur.y + radius + radius * math.sin(knobAngle)
	dl:AddCircleFilled({knobX, knobY}, 6, imgui.GetColorU32Vec4(imgui.ImVec4(0.30, 0.85, 0.38, 1.00)), 20)
	
	local knobAngle_3 = up_center + math.rad(0)
	local knobX_3 = cur.x + radius + radius * math.cos(knobAngle_3)
	local knobY_3 = cur.y + radius + radius * math.sin(knobAngle_3)
	if result_road == math.rad(0) then
		dl:AddCircleFilled({knobX_3, knobY_3}, 6, color, 20)
	else
		dl:AddCircleFilled({knobX_3, knobY_3}, 6, imgui.GetColorU32Vec4(imgui.ImVec4(0.30, 0.85, 0.38, 1.00)), 20)
	end

	imgui.PushFont(bold_font[2])
	local calc = imgui.CalcTextSize(tostring(floor(arg_znach)))
	imgui.PopFont()
	gui.Text(-(calc.x / 2) + 70 + cur_pos[1], cur_pos[2] + 30, tostring(floor(arg_znach)), bold_font[2])
end

tracks = {}

function release_music_cover_texture()
	if play and play.image_label ~= nil and play.image_label ~= image_no_label then
		pcall(function()
			imgui.ReleaseTexture(play.image_label)
		end)
	end
	if play then
		play.image_label = nil
	end
end

random_tracks = {}
site_link = 'rus.hitmotop.com'
play = {
	i = 0,
	info = {},
	len_time = 0,
	pos_time = 0,
	status = 'NULL',
	stream = nil,
	volume = 0.5,
	status_image = 0,
	image_label = nil,
	tab = '',
	shuffle = false,
	repeat_track = 0
}

function find_track_link(search_text, page) --> Поиск песни в интернете
	local tracks_repsone = {
		link = {},
		artist = {},
		name = {},
		time = {},
		image = {}
	}
	local page_ssl = ''
	local all_page_num = 1
	local page_table = {'1'}
	current_page = page
	local function remove_duplicates(array)
		local seen = {}
		local result = {}

		for _, value in ipairs(array) do
			if not seen[value] then
				table.insert(result, value)
				seen[value] = true
			end
		end

		return result
	end
	if page == 2 then
		page_ssl = '/start/48'
	elseif page == 3 then
		page_ssl = '/start/96'
	elseif page == 4 then
		page_ssl = '/start/144'
	end
	
	asyncHttpRequest('GET', 'https://' .. site_link .. '/search' .. page_ssl .. '?q=' .. urlencode(mus.search), nil,
		function(response)
			if page == 1 then
				for link in string.gmatch(u8:decode(response.text), '/search/start/48') do
					table.insert(page_table, '48')
				end
				for link in string.gmatch(u8:decode(response.text), '/search/start/96') do
					table.insert(page_table, '96')
				end
				for link in string.gmatch(u8:decode(response.text), '/search/start/144') do
					table.insert(page_table, '144')
				end
				local new_arr = remove_duplicates(page_table)
				qua_page = #new_arr
			end
			for link in string.gmatch(u8:decode(response.text), 'По вашему запросу ничего не найдено') do
				tracks_repsone.link[1] = 'Ошибка404'
				tracks_repsone.artist[1] = 'Ошибка404'
			end
			for link in string.gmatch(u8:decode(response.text), 'href="(.-)" class=') do
				if link:find('https://' .. site_link .. '/get/music/') then
					track = link:match('(.+).mp3')
					table.insert(tracks_repsone.link, track .. '.mp3')
				end
			end
			for link in string.gmatch(u8:decode(response.text), '"track%_%_title"%>(.-)%</div') do
				local nametrack = link:match('(.+)')
				nametrack = nametrack and nametrack:gsub('^%s*(.-)%s*$', '%1') or 'Неизвестно'
				table.insert(tracks_repsone.name, nametrack)
			end

			for link in string.gmatch(u8:decode(response.text), '"track%_%_desc"%>(.-)%</div') do
				local artist = link:match('(.+)')
				artist = artist and artist:gsub('^%s*(.-)%s*$', '%1') or 'Неизвестно'
				table.insert(tracks_repsone.artist, artist)
			end
			for link in string.gmatch(u8:decode(response.text), '"track%_%_fulltime"%>(.-)%</div') do
				if link:find('(.+)') then
					table.insert(tracks_repsone.time, link:match('(.+)'))
				end
			end
			for link in string.gmatch(u8:decode(response.text), '"track%_%_img" style="background%-image: url%(\'(.-)\'%)%;"%>%</div%>') do
				if link:find('(.+)') then
					table.insert(tracks_repsone.image, link:match('(.+)'))
				end
			end
			
			local track_list = {}
			local count = math.max(#tracks_repsone.link, #tracks_repsone.artist, #tracks_repsone.name, #tracks_repsone.time, #tracks_repsone.image)

			for i = 1, count do
				track_list[i] = {
					link = tracks_repsone.link[i] or '',
					artist = tracks_repsone.artist[i] or '',
					name = tracks_repsone.name[i] or '',
					time = tracks_repsone.time[i] or '',
					image = tracks_repsone.image[i] or ''
				}
			end
			
			tracks = track_list
		end,
		function(err)
		print(err)
	end)
end

function play_song(table_track, loop_track, num_i, song_tab) --> Включить песню
	if song_tab ~= 'RECORD' and song_tab ~= 'RADIO' then
		play.i = num_i
		play.info = table_track
		play.time = 0
		play.status = 'PLAY'
		play.len_time = get_track_length(play.info.time)
		play.tab = song_tab
		
		if get_status_potok_song() ~= 0 then
			bass.BASS_ChannelStop(play.stream)
		end
		
		if not loop_track then
			play.stream = bass.BASS_StreamCreateURL(play.info.link, 0, BASS_STREAM_AUTOFREE, nil, nil)
			bass.BASS_ChannelPlay(play.stream, false)
		else
			play.stream = bass.BASS_StreamCreateURL(play.info.link, 0, BASS_SAMPLE_LOOP, nil, nil)
			bass.BASS_ChannelPlay(play.stream, false)
		end
		bass.BASS_ChannelSetAttribute(play.stream, BASS_ATTRIB_VOL, play.volume)
		
		local cover_link = tostring(play.info.image or '')
		if cover_link ~= '' and not cover_link:find('no%-cover%-150') then
			download_id = downloadUrlToFile(cover_link, sh_legacy_data_path('Изображения', 'Label.png'), function(id, status, p1, p2)
				if status == dlstatus.STATUS_ENDDOWNLOADDATA then
					play.status_image = play.i
					release_music_cover_texture()
					play.image_label = imgui.CreateTextureFromFile(sh_legacy_data_path('Изображения', 'Label.png'))
				end
			end)
		else
			play.status_image = play.i
			release_music_cover_texture()
			play.image_label = image_no_label
		end
	else
		play.i = num_i
		play.info = {}
		play.time = 0
		play.status = 'PLAY'
		play.len_time = 0
		play.tab = song_tab
		
		if get_status_potok_song() ~= 0 then
			bass.BASS_ChannelStop(play.stream)
		end
		
		play.stream = bass.BASS_StreamCreateURL(table_track, 0, BASS_SAMPLE_LOOP, nil, nil)
		bass.BASS_ChannelPlay(play.stream, false)
		bass.BASS_ChannelSetAttribute(play.stream, BASS_ATTRIB_VOL, play.volume)
		
		release_music_cover_texture()
		play.image_label = image_no_label
	end
end

function get_status_potok_song() --> Получить статус потока
	if play.stream ~= nil then
		return tonumber(bass.BASS_ChannelIsActive(play.stream))
	else
		return 0
	end
	
	--[[
	[0] - Ничего не воспроизводится
	[1] - Играет
	[2] - Блок
	[3] - Пауза
	--]]
end

function rewind_song(time_position) --> Перемотка трека на указанную позицию (позиция трека в секундах)
	if play.status ~= 'NULL' and get_status_potok_song() ~= 0 then
		local length = bass.BASS_ChannelGetLength(play.stream, BASS_POS_BYTE)
		length = tostring(length)
		length = length:gsub('(%D+)', '')
		length = tonumber(length)
		bass.BASS_ChannelSetPosition(play.stream, ((length / play.len_time) * time_position) - 100, BASS_POS_BYTE)
	end
end

function time_song_position(song_length) --> Получить позицию трека в секундах
	local posByte = bass.BASS_ChannelGetPosition(play.stream, BASS_POS_BYTE)
	posByte = tostring(posByte)
	posByte = posByte:gsub('(%D+)', '')
	posByte = tonumber(posByte)
	local length = bass.BASS_ChannelGetLength(play.stream, BASS_POS_BYTE)
	length = tostring(length)
	length = length:gsub('(%D+)', '')
	length = tonumber(length)
	local postrack = posByte / (length / song_length)
	
	return postrack
end

function get_track_length(track_length) --> Получить длину трека в секундах
	local minutes, seconds = track_length:match('^(%d+):(%d+)$')
	
	if minutes and seconds then
		minutes = tonumber(minutes)
		seconds = tonumber(seconds)
		
		return minutes * 60 + seconds
	else
		return 999
	end
end

function set_song_status(action_music) --> Остановить/Пауза/Продолжить
	if play.stream ~= nil and get_status_potok_song() ~= 0 then
		if action_music == 'PLAY_OR_PAUSE' then
			if play.status == 'PLAY' then
				play.status = 'PAUSE'
				bass.BASS_ChannelPause(play.stream)
			elseif play.status == 'PAUSE' then
				play.status = 'PLAY'
				bass.BASS_ChannelPlay(play.stream, false)
			end
		elseif action_music == 'STOP' then
			bass.BASS_ChannelStop(play.stream)
			play = {
				i = 0,
				info = {},
				len_time = 0,
				pos_time = 0,
				status = 'NULL',
				stream = nil,
				volume = play.volume,
				status_image = 0,
				image_label = nil,
				tab = '',
				shuffle = play.shuffle,
				repeat_track = play.repeat_track
			}
			windows.player[0] = false
		elseif action_music == 'PLAY' then
			play.status = 'PAUSE'
			bass.BASS_ChannelPause(play.stream)
		end
	end
end

function volume_song(volume_music) --> Установить громкость песни
	if play.stream ~= nil and get_status_potok_song() ~= 0 then
		bass.BASS_ChannelSetAttribute(play.stream, BASS_ATTRIB_VOL, volume_music)
	end
end

function back_track() --> Переключить песню назад
	if play.tab == 'SEARCH' and #tracks > 0 then
		for i = 1, #tracks do
			if tracks[i].link == play.info.link then
				if i ~= 1 then
					play_song(tracks[i - 1], play.repeat_track == 2, i - 1, 'SEARCH')
					break
				else
					play_song(tracks[#tracks], play.repeat_track == 2, #tracks, 'SEARCH')
					break
				end
			end
		end
	elseif play.tab == 'ADD' and #setting.tracks > 0 then
		for i = 1, #setting.tracks do
			if setting.tracks[i].link == play.info.link then
				if i ~= 1 then
					play_song(setting.tracks[i - 1], play.repeat_track == 2, i - 1, 'ADD')
					break
				else
					play_song(setting.tracks[#setting.tracks], play.repeat_track == 2, #setting.tracks, 'ADD')
					break
				end
			end
		end
	end
end

function next_track(repeat_param) --> Переключить песню вперёд
	if play.tab == 'SEARCH' and #tracks > 0 then
		for i = 1, #tracks do
			if tracks[i].link == play.info.link then
				if i ~= #tracks then
					play_song(tracks[i + 1], play.repeat_track == 2, i + 1, 'SEARCH')
					break
				elseif repeat_param then
					play_song(tracks[1], play.repeat_track == 2, 1, 'SEARCH')
					break
				end
			end
		end
	elseif play.tab == 'ADD' and #setting.tracks > 0 then
		for i = 1, #setting.tracks do
			if setting.tracks[i].link == play.info.link then
				if i ~= #setting.tracks then
					play_song(setting.tracks[i + 1], play.repeat_track == 2, i + 1, 'ADD')
					break
				elseif repeat_param then
					play_song(setting.tracks[1], play.repeat_track == 2, 1, 'ADD')
					break
				end
			end
		end
	end
end

function reload_punish_cmd()
    sampUnregisterChatCommand('punish')
    if setting.tsr_settings.smart_punish then
        sampRegisterChatCommand('punish', smart_punish_func)
        if download_punish_reasons then download_punish_reasons() end
    end
end

function shuffle_tracks(all_num) --> Рандомное перемешивание треков
	for i = 1, all_num do
		table.insert(random_tracks, i)
	end
	
	for i = #random_tracks, 2, -1 do
		local j = math.random(i)
		random_tracks[i], random_tracks[j] = random_tracks[j], random_tracks[i]
	end
end

function control_song_when_finished() --> Что делать с песней по её завершению
	if get_status_potok_song() == 3 and play.status == 'PLAY' then
		set_song_status('PLAY')
	elseif get_status_potok_song() == 0 and play.status == 'PLAY' then
		if play.repeat_track == 2 then
			play_song(play.info, play.repeat_track == 2, play.i, play.tab)
		else
			next_track(play.repeat_track == 1)
		end
	end
end

--> Отображение окон
img_step = {imgui.new.int(42)}
img_duration = {imgui.new.int(350)}
local smi_spoiler = new.bool(false)
local hospital_spoiler = new.bool(false)
local army_spoiler = new.bool(false)
local police_spoiler = new.bool(false)
local hall = {}


