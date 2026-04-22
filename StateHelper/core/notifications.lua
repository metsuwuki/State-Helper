--[[
Open with encoding: UTF-8
StateHelper/core/notifications.lua
]]

local notifications = {}

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

    local text_html = "<span style='color:#f2f2f2;'>" .. samp_text .. "</span>"
    text_html = text_html:gsub("{(%x%x%x%x%x%x)}", "</span><span style='color:#%1;'>")
    text_html = text_html:gsub("`", "\\`")
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
