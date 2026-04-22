--[[
Open with encoding: UTF-8
StateHelper/features/commands/default_command_loader.lua
]]

cmd_defoult = {
	all = {},
	hospital = {},
	driving_school = {},
	government = {},
	army = {},
	fire_department = {},
	jail = {},
	police = {},
	smi = {}
}

cmd_default = cmd_defoult

function add_cmd_defoult()
	cmd_defoult.all = {}
	cmd_defoult.hospital = {}
	cmd_defoult.driving_school = {}
	cmd_defoult.government = {}
	cmd_defoult.army = {}
	cmd_defoult.fire_department = {}
	cmd_defoult.jail = {}
	cmd_defoult.police = {}
	cmd_defoult.smi = {}

	local command_sources
	local active_project = type(SH_ACTIVE_PROJECT) == 'string' and SH_ACTIVE_PROJECT or 'Arizona'

	if active_project == 'Rodina' then
		command_sources = {
			{ key = 'all',            module_name = 'StateHelper.Rodina_factions.common.commands' },
			{ key = 'hospital',       module_name = 'StateHelper.Rodina_factions.hospital.commands' },
			{ key = 'driving_school', module_name = 'StateHelper.Rodina_factions.license_center.commands' },
			{ key = 'government',     module_name = 'StateHelper.Rodina_factions.government.commands' },
			{ key = 'army',           module_name = 'StateHelper.Rodina_factions.army.commands' },
			{ key = 'jail',           module_name = 'StateHelper.Rodina_factions.jail.commands' },
			{ key = 'police',         module_name = 'StateHelper.Rodina_factions.police.commands' },
			{ key = 'smi',            module_name = 'StateHelper.Rodina_factions.smi.commands' },
		}
	else
		command_sources = {
			{ key = 'all', module_name = 'StateHelper.Arizona_factions.common.commands' },
			{ key = 'hospital', module_name = 'StateHelper.Arizona_factions.hospital.commands' },
			{ key = 'driving_school', module_name = 'StateHelper.Arizona_factions.driving_school.commands' },
			{ key = 'government', module_name = 'StateHelper.Arizona_factions.government.commands' },
			{ key = 'army', module_name = 'StateHelper.Arizona_factions.army.commands' },
			{ key = 'fire_department', module_name = 'StateHelper.Arizona_factions.fire_department.commands' },
			{ key = 'jail', module_name = 'StateHelper.Arizona_factions.jail.commands' },
			{ key = 'police', module_name = 'StateHelper.Arizona_factions.police.commands' },
			{ key = 'smi', module_name = 'StateHelper.Arizona_factions.smi.commands' },
		}
	end

	for _, source in ipairs(command_sources) do
		local ok, source_commands = pcall(require, source.module_name)
		if ok and type(source_commands) == 'table' then
			local source_meta = source_commands
			local command_list = source_commands.commands
			if type(command_list) ~= 'table' then
				command_list = source_commands
				source_meta = {}
			end

			local should_convert_utf8 = source_meta.encoding ~= 'utf8'
			local loaded_count = 0
			for i = 1, #command_list do
				local res, set = pcall(decodeJson, command_list[i])
				if res and type(set) == 'table' then
					if should_convert_utf8 then
						set = convertToUTF8(set)
					end
					set.__sh_managed = true
					set.__sh_set_key = source.key
					set.__sh_source_module = source.module_name
					set.__sh_project = active_project
					table.insert(cmd_defoult[source.key], set)
					cmd_defoult[source.key][#cmd_defoult[source.key]].UID = math.random(20, 95000000)
					loaded_count = loaded_count + 1
				end
			end
			print(string.format(
				'[StateHelper] Loaded %d default commands from %s (%s)',
				loaded_count,
				source.module_name,
				source.key
			))
		else
			print(string.format('[StateHelper] Failed to load commands from %s: %s', source.module_name, tostring(source_commands)))
		end
	end

	local res, set = pcall(decodeJson, medcard_phoenix)
	if res and type(set) == 'table' then
		mc_phoenix = convertToUTF8(set)
		mc_phoenix.UID = math.random(20, 95000000)
	end
end

add_cmd_defoult()
