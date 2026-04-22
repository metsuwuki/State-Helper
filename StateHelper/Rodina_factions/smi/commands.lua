--[[
Open with encoding: UTF-8
StateHelper/Rodina_factions/smi/commands.lua
]]

local command_builder = require('StateHelper.core.command_builder')
local smi_data = require('StateHelper.Rodina_factions.smi.data')

local commands = command_builder.build_many(smi_data.get_command_specs())
rawset(_G, 'medcard_phoenix', '{}')
rawset(_G, 'mc_phoenix', rawget(_G, 'mc_phoenix') or {})

return commands
