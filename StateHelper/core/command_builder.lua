--[[
Open with encoding: UTF-8
StateHelper/core/command_builder.lua

Small constructor-style helper for creating command JSON payloads.
]]

local command_builder = {}

local function sh_core_command_builder_ensure_array(value)
    return type(value) == 'table' and value or {}
end

function command_builder.action_send(text)
    return { 'SEND', text }
end

function command_builder.action_wait_enter()
    return { 'WAIT_ENTER' }
end

function command_builder.action_stop()
    return { 'STOP' }
end

function command_builder.action_dialog(name, options)
    return { 'DIALOG', name, sh_core_command_builder_ensure_array(options) }
end

function command_builder.arg_text(name, desc)
    return {
        name = name,
        desc = desc or name,
        type = 1,
    }
end

function command_builder.arg_number(name, desc)
    return {
        name = name,
        desc = desc or name,
        type = 2,
    }
end

function command_builder.build(definition)
    local payload = {
        folder = definition.folder or 1,
        var = definition.var or {},
        rank = definition.rank or 1,
        act = definition.act or {},
        desc = definition.desc or '',
        id_element = definition.id_element or 1,
        delay = definition.delay or 1.2,
        send_end_mes = definition.send_end_mes ~= false,
        cmd = definition.cmd or '',
        key = definition.key or { '', {} },
        arg = definition.arg or {},
    }

    return assert(encodeJson(payload))
end

function command_builder.build_many(definitions)
    local result = {}
    for _, definition in ipairs(definitions or {}) do
        result[#result + 1] = command_builder.build(definition)
    end
    return result
end

return command_builder
