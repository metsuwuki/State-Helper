--[[
Open with encoding: UTF-8
StateHelper/Rodina_factions/smi/data.lua

Canonical SMI command definitions for the Rodina project.
]]

local command_builder = require('StateHelper.core.command_builder')

local smi_data = {}

local function send(text)
    return command_builder.action_send(text)
end

local function wait_enter()
    return command_builder.action_wait_enter()
end

local function id_arg(name, desc)
    return command_builder.arg_number(name or 'arg1', desc or 'id игрока')
end

local function number_arg(name, desc)
    return command_builder.arg_number(name, desc)
end

local function text_arg(name, desc)
    return command_builder.arg_text(name, desc)
end

function smi_data.get_command_specs()
    return {
        {
            folder = 4,
            cmd = 'inv',
            desc = 'Принятие игрока в организацию',
            id_element = 501,
            rank = 5,
            delay = 1.2,
            arg = {
                id_arg('arg1', 'id игрока'),
            },
            act = {
                send('/do В кармане формы есть связка с ключами от раздевалки.'),
                send('/me достаёт из кармана один ключ из связки ключей от раздевалки'),
                send('/todo Возьмите, это ключ от нашей раздевалки.*передавая ключ человеку напротив'),
                send('/invite {arg1}'),
                send('/r Новый сотрудник принят в организацию.'),
            },
        },
        {
            folder = 4,
            cmd = 'frp',
            desc = 'Выдать /fractionrp сотруднику',
            id_element = 502,
            rank = 1,
            delay = 1.2,
            arg = {
                id_arg('arg1', 'id игрока'),
            },
            act = {
                send('/fractionrp {arg1}'),
            },
        },
        {
            folder = 4,
            cmd = 'gr',
            desc = 'Повышение или понижение сотрудника',
            id_element = 503,
            rank = 7,
            delay = 1.2,
            arg = {
                id_arg('arg1', 'id игрока'),
                number_arg('arg2', 'ранг'),
            },
            act = {
                send('/me достаёт из кармана телефон и заходит в служебную базу данных'),
                send('/me изменяет информацию о сотруднике в служебной базе данных'),
                send('/me выходит из базы данных и убирает телефон обратно в карман'),
                send('/giverank {arg1} {arg2}'),
                send('/r Сотрудник получил новую должность.'),
            },
        },
        {
            folder = 4,
            cmd = 'cjob',
            desc = 'Посмотреть успешность сотрудника',
            id_element = 504,
            rank = 4,
            delay = 1.2,
            arg = {
                id_arg('arg1', 'id игрока'),
            },
            act = {
                send('/checkjobprogress {arg1}'),
            },
        },
        {
            folder = 4,
            cmd = 'fmutes',
            desc = 'Выдать мут сотруднику',
            id_element = 505,
            rank = 5,
            delay = 1.2,
            arg = {
                id_arg('arg1', 'id игрока'),
            },
            act = {
                send('/fmutes {arg1} Н.П.Р.'),
                send('/r Сотрудник лишён права использовать рацию на 10 минут.'),
            },
        },
        {
            folder = 4,
            cmd = 'funmute',
            desc = 'Снять мут сотруднику',
            id_element = 506,
            rank = 5,
            delay = 1.2,
            arg = {
                id_arg('arg1', 'id игрока'),
            },
            act = {
                send('/funmute {arg1}'),
                send('/r Сотрудник теперь может пользоваться рацией.'),
            },
        },
        {
            folder = 4,
            cmd = 'block',
            desc = 'Забрать доступ к редакции',
            id_element = 507,
            rank = 8,
            delay = 1.2,
            arg = {
                id_arg('arg1', 'id игрока'),
                text_arg('arg2', 'причина'),
            },
            act = {
                send('/me открывает базу данных редакции и вносит изменения'),
                send('/blockredak {arg1} {arg2}'),
                send('/r Сотруднику ограничен доступ к редакции.'),
            },
        },
        {
            folder = 4,
            cmd = 'unblock',
            desc = 'Вернуть доступ к редакции',
            id_element = 508,
            rank = 8,
            delay = 1.2,
            arg = {
                id_arg('arg1', 'id игрока'),
            },
            act = {
                send('/me открывает базу данных редакции и снимает ограничение'),
                send('/unblockredak {arg1}'),
                send('/r Сотруднику возвращён доступ к редакции.'),
            },
        },
        {
            folder = 4,
            cmd = 'vig',
            desc = 'Выдать выговор сотруднику',
            id_element = 509,
            rank = 8,
            delay = 1.2,
            arg = {
                id_arg('arg1', 'id игрока'),
                text_arg('arg2', 'причина'),
            },
            act = {
                send('/me достаёт служебный телефон и заходит в базу данных'),
                send('/fwarn {arg1} {arg2}'),
                send('/r Сотруднику выдан выговор. Причина: {arg2}'),
            },
        },
        {
            folder = 4,
            cmd = 'unvig',
            desc = 'Снять выговор с сотрудника',
            id_element = 510,
            rank = 8,
            delay = 1.2,
            arg = {
                id_arg('arg1', 'id игрока'),
            },
            act = {
                send('/me достаёт служебный телефон и заходит в базу данных'),
                send('/unfwarn {arg1}'),
                send('/r Сотруднику снят выговор.'),
            },
        },
        {
            folder = 4,
            cmd = 'unv',
            desc = 'Уволить игрока из организации',
            id_element = 511,
            rank = 8,
            delay = 1.2,
            arg = {
                id_arg('arg1', 'id игрока'),
                text_arg('arg2', 'причина'),
            },
            act = {
                send('/me открывает базу данных сотрудников и вносит изменения'),
                send('/uninvite {arg1} {arg2}'),
                send('/r Сотрудник был уволен. Причина: {arg2}'),
            },
        },
        {
            folder = 4,
            cmd = 'point',
            desc = 'Отправить метку сотрудникам',
            id_element = 512,
            rank = 3,
            delay = 1.2,
            arg = {},
            act = {
                send('/r Срочно выдвигайтесь ко мне, отправляю вам координаты...'),
                send('/point'),
            },
        },
        {
            folder = 4,
            cmd = 'govka',
            desc = 'Собеседование по гос. волне',
            id_element = 513,
            rank = 4,
            delay = 1.3,
            arg = {},
            act = {
                send('/d [СМИ] - [Всем]: Занимаю государственную волну, просьба не перебивать!'),
                send('/gov [СМИ]: Доброго времени суток, уважаемые жители штата!'),
                send('/gov [СМИ]: Сейчас проходит собеседование в нашу организацию.'),
                send('/gov [СМИ]: Для вступления нужны документы, жильё и присутствие в холле редакции.'),
                send('/d [СМИ] - [Всем]: Освобождаю государственную волну, спасибо что не перебивали.'),
            },
        },
        {
            folder = 1,
            cmd = 'smihello',
            desc = 'Начало собеседования для СМИ',
            id_element = 514,
            rank = 1,
            delay = 1.2,
            arg = {
                id_arg('arg1', 'id игрока'),
            },
            act = {
                send('Здравствуйте, вы на собеседование?'),
                send('Я {myrank} {mynickrus}.'),
                send('Предоставьте, пожалуйста, паспорт, медкарту и лицензии.'),
            },
        },
        {
            folder = 1,
            cmd = 'sobstart',
            desc = 'Быстрое начало собеседования',
            id_element = 515,
            rank = 1,
            delay = 1.2,
            arg = {
                id_arg('arg1', 'id игрока'),
            },
            act = {
                send('Здравствуйте, вы на собеседование?'),
                send('Хорошо, предоставьте все ваши документы для проверки.'),
                send('/n Используйте /showpass [ID], /showmc [ID], /showlic [ID].'),
            },
        },
        {
            folder = 1,
            cmd = 'liveint',
            desc = 'Эфир: интервью начало',
            id_element = 516,
            rank = 1,
            delay = 1.2,
            arg = {},
            act = {
                send('/d [СМИ]: Занимаю эфирную волну.'),
                send('/news [Интервью]: Здравствуйте, уважаемые радиослушатели!'),
                send('/news [Интервью]: У микрофона - {mynickrus}.'),
                send('/news [Интервью]: Сегодня у нас в гостях особый гость...'),
            },
        },
        {
            folder = 1,
            cmd = 'liveend',
            desc = 'Эфир: интервью конец',
            id_element = 517,
            rank = 1,
            delay = 1.2,
            arg = {},
            act = {
                send('/news [Интервью]: Наш эфир подходит к концу.'),
                send('/news [Интервью]: С вами был {mynickrus}. До скорых встреч!'),
                send('/d [СМИ]: Освобождаю эфирную волну.'),
            },
        },
        {
            folder = 1,
            cmd = 'weatherday',
            desc = 'Эфир: дневной прогноз погоды',
            id_element = 518,
            rank = 1,
            delay = 1.2,
            arg = {},
            act = {
                send('/d [СМИ]: Занимаю новостную волну.'),
                send('/news Добрый день, дорогие радиослушатели!'),
                send('/news У микрофона {myrank} - {mynickrus}.'),
                send('/news Сейчас самое время узнать, какая погода ждёт нас днём.'),
                send('/news На этом наш дневной прогноз завершается. До скорых встреч!'),
                send('/d [СМИ]: Освобождаю новостную волну!'),
            },
        },
        {
            folder = 1,
            cmd = 'weatherstorm',
            desc = 'Эфир: вечерний штормовой прогноз',
            id_element = 519,
            rank = 1,
            delay = 1.2,
            arg = {},
            act = {
                send('/d [СМИ]: Занимаю новостную волну.'),
                send('/news Добрый вечер, дорогие радиослушатели!'),
                send('/news В ближайшее время ожидается ухудшение погоды и сильный ветер.'),
                send('/news Просим вас по возможности оставаться дома и соблюдать осторожность на дорогах.'),
                send('/news На этом экстренный прогноз погоды завершён. Берегите себя!'),
                send('/d [СМИ]: Освобождаю новостную волну!'),
            },
        },
        {
            folder = 1,
            cmd = 'quizmath',
            desc = 'Эфир: викторина Математика',
            id_element = 520,
            rank = 1,
            delay = 1.2,
            arg = {},
            act = {
                send('/d [СМИ]: Занимаю эфирную волну.'),
                send('/news [Викторина]: Добрый день, уважаемые радиослушатели!'),
                send('/news [Викторина]: Сегодня мы проведём викторину - Математика.'),
                send('/news [Викторина]: Первый пример: 3 + 3 * 3.'),
                wait_enter(),
                send('/news [Викторина]: Верный ответ - 12.'),
                send('/news [Викторина]: Следующий пример: 66 - 44 + 1.'),
                wait_enter(),
                send('/news [Викторина]: Правильный ответ - 23.'),
                send('/news [Викторина]: На этом наша викторина окончена, спасибо всем вам за участие!'),
                send('/d [СМИ]: Освобождаю эфирную волну!'),
            },
        },
        {
            folder = 1,
            cmd = 'quizcap',
            desc = 'Эфир: викторина Столицы',
            id_element = 521,
            rank = 1,
            delay = 1.2,
            arg = {},
            act = {
                send('/d [СМИ]: Занимаю эфирную волну.'),
                send('/news [Викторина]: Добрый день, уважаемые радиослушатели!'),
                send('/news [Викторина]: Сегодня мы проведём викторину - Столицы.'),
                send('/news [Викторина]: Первый вопрос: столица Южной Кореи?'),
                wait_enter(),
                send('/news [Викторина]: Правильный ответ - Сеул.'),
                send('/news [Викторина]: Следующий вопрос: столица Вьетнама?'),
                wait_enter(),
                send('/news [Викторина]: Правильный ответ - Ханой.'),
                send('/news [Викторина]: Спасибо всем за участие, до новых встреч в эфире!'),
                send('/d [СМИ]: Освобождаю эфирную волну!'),
            },
        },
    }
end

return smi_data
