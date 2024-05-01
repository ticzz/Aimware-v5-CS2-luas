-- Thanks to Gladiator and 2878713023 with help to fix some issues
-- Original [https://aimware.net/forum/thread/157762] was made for CS:GO by Verieth [https://aimware.net/forum/user/283534]

-- Just a fixed Version of Verieth´s Animated Damage Indicator to work in CS2 by ticZz

local lua_ref = gui.Reference("Visuals", "World", "Extra")
local lua_enable_damage_marker = gui.Checkbox(lua_ref, "damage_indicator_checkbox", "Enable Damage Indicators", true)
local lua_defoult_color = gui.ColorPicker(lua_ref, "defoult_color", "Default Shot Color", 170, 166, 255, 255)
local lua_lethal_color = gui.ColorPicker(lua_ref, "lethal_color", "Lethal Shot Color", 255, 40, 40, 255)
local lua_damage_speed = gui.Slider(lua_ref, "damage_speed", "Animation Speed", 3, 1, 15)
local lua_damage_time = gui.Slider(lua_ref, "damage_time", "Time of Visibility", 250, 50, 800, 10)
local damage_font = draw.CreateFont("Verdana", 18, 1200)

local particles = { {} }
local shot_particle = {}
callbacks.Register("FireGameEvent", function(ctx)
	if not entities:GetLocalPlayer() or not entities:GetLocalPlayer():IsAlive() then
		return
	end
	if not lua_enable_damage_marker:GetValue() then
		lua_defoult_color:SetInvisible(true)
		lua_lethal_color:SetInvisible(true)
		lua_damage_speed:SetInvisible(true)
		lua_damage_time:SetInvisible(true)
	else
		lua_defoult_color:SetInvisible(false)
		lua_lethal_color:SetInvisible(false)
		lua_damage_speed:SetInvisible(false)
		lua_damage_time:SetInvisible(false)
	end

	local math_random_1 = math.random(1, 10)
	local math_random_2 = math.random(1, 10)
	local math_random_3 = math.random(1, 10)
	if ctx then
		if ctx:GetName() == "player_hurt" then
			local pVictimController = entities.GetByIndex(ctx:GetInt("userid") + 1)
			local pAttackerController = entities.GetByIndex(ctx:GetInt("attacker") + 1)
			local pVictimPawn = pVictimController:GetPropEntity("m_hPawn")
			local pAttackerPawn = pAttackerController:GetPropEntity("m_hPawn")
			local user_index = pVictimPawn:GetIndex()
			local attacker_index = pAttackerPawn:GetIndex()
			local localplayer_index = entities:GetLocalPlayer():GetIndex()
			if attacker_index == localplayer_index and user_index ~= localplayer_index then
				local HitGroup = ctx:GetInt("hitgroup")
				pos = pVictimPawn:GetHitboxPosition(HitGroup)
				if pos == nil then
					pos = pVictimPawn:GetAbsOrigin()
					pos.z = pos.z + 50
				end
				pos.x = pos.x - 2 + (math_random_1 * 3)
				pos.y = pos.y - 2 + (math_random_2 * 3)
				pos.z = pos.z - 4 + (math_random_3 * 1)

				shot_particle = {}

				table.insert(shot_particle, pos.x)
				table.insert(shot_particle, pos.y)
				table.insert(shot_particle, pos.z)

				time = globals.TickCount() + lua_damage_time:GetValue()
				table.insert(shot_particle, time)

				health = ctx:GetInt("health")
				table.insert(shot_particle, health)

				damage = ctx:GetInt("dmg_health")
				table.insert(shot_particle, damage)

				pos_hitmarker = pVictimPawn:GetHitboxPosition(ctx:GetInt("hitgroup"))
				if pos_hitmarker == nil then
					pos_hitmarker = pVictimPawn:GetAbsOrigin()
					pos_hitmarker.z = pos_hitmarker.z + 50
				end
				table.insert(shot_particle, pos_hitmarker.x)
				table.insert(shot_particle, pos_hitmarker.y)
				table.insert(shot_particle, pos_hitmarker.z)

				table.insert(particles, shot_particle)
			end
		end
	end
end)

function animation()
	if not entities:GetLocalPlayer() or not entities:GetLocalPlayer():IsAlive() then
		return
	end
	for i = 1, #particles, 1 do
		if particles[i][1] ~= nil then
			local delta_time = particles[i][4] - globals.TickCount()
			if delta_time > 0 then
				particles[i][3] = particles[i][3] + (lua_damage_speed:GetValue() / 10)
			end
		end
	end
end
callbacks.Register("CreateMove", animation)

function render_damage()
	if not entities:GetLocalPlayer() or not entities:GetLocalPlayer():IsAlive() then
		particles = {}
		timer = 0
	end
	for i = 1, #particles, 1 do
		if particles[i][1] ~= nil and particles[i][2] ~= nil and particles[i][3] ~= nil then
			position_x, position_y = client.WorldToScreen(Vector3(particles[i][1], particles[i][2], particles[i][3]))
			local timer = particles[i][4] - globals.TickCount()
			health_remaining = particles[i][5]

			if timer > 255 then
				timer = 255
			end
			if timer > 0 then
				if lua_enable_damage_marker:GetValue() and position_x ~= nil and position_y ~= nil then
					if health_remaining > 0 then
						lua_damage_color_r, lua_damage_color_g, lua_damage_color_b = lua_defoult_color:GetValue()
					end
					if health_remaining <= 0 then
						lua_damage_color_r, lua_damage_color_g, lua_damage_color_b = lua_lethal_color:GetValue()
					end
					draw.SetFont(damage_font)
					draw.Color(0, 0, 0, timer)
					draw.Text(position_x, position_y + 1 - 75, "-" .. particles[i][6])
					draw.Text(position_x, position_y - 1 - 75, "-" .. particles[i][6])
					draw.Text(position_x + 1, position_y - 75, "-" .. particles[i][6])
					draw.Text(position_x - 1, position_y - 75, "-" .. particles[i][6])
					draw.Color(lua_damage_color_r, lua_damage_color_g, lua_damage_color_b, timer)
					draw.Text(position_x, position_y - 75, "-" .. particles[i][6])
				end
			end
		end
	end
end
callbacks.Register("Draw", render_damage)

--***********************************************--

local name = GetScriptName()
print("♥♥♥ " .. name .. " loaded without Errors ♥♥♥")
