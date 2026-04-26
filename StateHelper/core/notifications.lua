--[[
Open with encoding: UTF-8
StateHelper/core/notifications.lua
]]

local notifications = {}

local function safe_text(value)
    if value == nil then
        return ''
    end
    if type(value) == 'string' then
        return value
    end
    return tostring(value)
end

local function is_utf8_continuation(byte_value)
    return byte_value and byte_value >= 0x80 and byte_value <= 0xBF
end

local function is_valid_utf8(text)
    local index = 1
    local length = #text

    while index <= length do
        local first = text:byte(index)
        if first < 0x80 then
            index = index + 1
        elseif first >= 0xC2 and first <= 0xDF then
            if not is_utf8_continuation(text:byte(index + 1)) then
                return false
            end
            index = index + 2
        elseif first == 0xE0 then
            local second, third = text:byte(index + 1), text:byte(index + 2)
            if not (second and second >= 0xA0 and second <= 0xBF and is_utf8_continuation(third)) then
                return false
            end
            index = index + 3
        elseif first >= 0xE1 and first <= 0xEC then
            if not (is_utf8_continuation(text:byte(index + 1)) and is_utf8_continuation(text:byte(index + 2))) then
                return false
            end
            index = index + 3
        elseif first == 0xED then
            local second, third = text:byte(index + 1), text:byte(index + 2)
            if not (second and second >= 0x80 and second <= 0x9F and is_utf8_continuation(third)) then
                return false
            end
            index = index + 3
        elseif first >= 0xEE and first <= 0xEF then
            if not (is_utf8_continuation(text:byte(index + 1)) and is_utf8_continuation(text:byte(index + 2))) then
                return false
            end
            index = index + 3
        elseif first == 0xF0 then
            local second, third, fourth = text:byte(index + 1), text:byte(index + 2), text:byte(index + 3)
            if not (second and second >= 0x90 and second <= 0xBF and is_utf8_continuation(third) and is_utf8_continuation(fourth)) then
                return false
            end
            index = index + 4
        elseif first >= 0xF1 and first <= 0xF3 then
            if not (is_utf8_continuation(text:byte(index + 1)) and is_utf8_continuation(text:byte(index + 2)) and is_utf8_continuation(text:byte(index + 3))) then
                return false
            end
            index = index + 4
        elseif first == 0xF4 then
            local second, third, fourth = text:byte(index + 1), text:byte(index + 2), text:byte(index + 3)
            if not (second and second >= 0x80 and second <= 0x8F and is_utf8_continuation(third) and is_utf8_continuation(fourth)) then
                return false
            end
            index = index + 4
        else
            return false
        end
    end

    return true
end

local function to_cef_text(value)
    local text = safe_text(value)
    if text == '' then
        return text
    end

    local ok, encoding = pcall(require, 'encoding')
    if ok and encoding and encoding.UTF8 then
        if is_valid_utf8(text) then
            local decoded_ok, decoded = pcall(function()
                return encoding.UTF8:decode(text)
            end)
            if decoded_ok and type(decoded) == 'string' then
                return decoded
            end
        end
    end

    return text
end

local function escape_html(value)
    return safe_text(value)
        :gsub('&', '&amp;')
        :gsub('<', '&lt;')
        :gsub('>', '&gt;')
        :gsub('"', '&quot;')
        :gsub("'", '&#39;')
end

local function escape_js_template(value)
    return safe_text(value)
        :gsub('\\', '\\\\')
        :gsub('`', '\\`')
        :gsub('%$', '\\$')
        :gsub('\r', '\\r')
        :gsub('\n', '\\n')
end

function notifications.create(ctx)
    local obj = {}

    function obj:info(message)
        ctx.logger:info(message)
    end

    function obj:warn(message)
        ctx.logger:warn(message)
    end

    return obj
end

function notifications.sh_ui_notif_inject_css(is_injected)
    if is_injected then
        return true
    end

    require('StateHelper.core.cef').sh_core_cef_eval_anon("let s=document.createElement('style');s.innerHTML='@keyframes cefNotifySlideIn{from{transform:translate(-50%,150%);opacity:0}to{transform:translate(-50%,0);opacity:1}}@keyframes cefNotifySlideOut{from{transform:translate(-50%,0);opacity:1}to{transform:translate(-50%,150%);opacity:0}}@keyframes cefNotifyFadeOut{from{opacity:1}to{opacity:0}}@keyframes cefNotifyProgress{from{transform:scaleX(1)}to{transform:scaleX(0)}}';document.head.appendChild(s);")
    return true
end

function notifications.sh_ui_notif_show(samp_text, duration_ms)
    duration_ms = math.max(tonumber(duration_ms) or 0, 5200)

    local text_html = "<span style='color:#f2f2f2;'>" .. escape_html(to_cef_text(samp_text)) .. "</span>"
    text_html = text_html:gsub("{(%x%x%x%x%x%x)}", "</span><span style='color:#%1;'>")
    text_html = escape_js_template(text_html)
    local bg_color = "rgba(26, 26, 26, 0.9)"
    local element_id = 'cefNotify_' .. math.random(1000, 9999)
    local js_code = string.format(
        [[
        let oldNotifies = document.querySelectorAll('.cefNotifyInstance');
        oldNotifies.forEach(oldEl => {
            let computedStyle = window.getComputedStyle(oldEl);
            let currentAnimation = computedStyle.animationName || computedStyle.webkitAnimationName;
            if (currentAnimation !== 'cefNotifySlideOut') {
                oldEl.style.animation = `cefNotifyFadeOut %dms ease-in forwards`;
                setTimeout(() => { if(oldEl) oldEl.remove(); }, %d);
            }
        });
        let el=document.createElement('div');el.id='%s';
        el.classList.add('cefNotifyInstance');
        el.innerHTML=`<div style="font-family:Arial,sans-serif;font-size:16px;font-weight:bold;color:#f2f2f2;text-align:center;padding-bottom:8px">StateHelper</div><hr style="border:none;height:1px;background-color:#2e2e2e;margin:0 0 8px 0"><div style="font-family:Arial,sans-serif;font-size:20px;color:#f2f2f2">%s</div><div style="margin-top:12px;height:3px;background:rgba(255,255,255,0.12);border-radius:999px;overflow:hidden"><div style="height:100%%;width:100%%;background:linear-gradient(90deg,#ff8a5b 0%%,#ffd45b 100%%);transform-origin:right center;animation:cefNotifyProgress %dms linear forwards"></div></div>`;
        el.style.cssText=`position:fixed;bottom:10%%;left:50%%;transform:translate(-50%%,0);background:%s;padding:12px 24px 10px 24px;border-radius:7px;border:1px solid #2e2e2e;box-shadow:0 4px 12px rgba(0,0,0,0.3);z-index:99999;pointer-events:none;animation:cefNotifySlideIn %dms ease-out forwards`;
        document.body.appendChild(el);
        setTimeout(()=>{let c=document.getElementById('%s');if(c)c.style.animation=`cefNotifySlideOut %dms ease-in forwards`},%d);
        setTimeout(()=>{let c=document.getElementById('%s');if(c)c.remove()},%d);
        ]],
        300, 300,
        element_id, text_html, duration_ms - 450, bg_color, 400, element_id, 400, duration_ms - 400, element_id, duration_ms
    )

    require('StateHelper.core.cef').sh_core_cef_eval_anon(js_code)
end

return notifications
