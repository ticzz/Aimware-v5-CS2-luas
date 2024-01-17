local lua_ref = gui.Reference("Visuals", "Other", "Effects")

local Screen_Weight, Screen_Height = draw.GetScreenSize()

local lua_enable_fov_circle = gui.Checkbox(lua_ref, "enable_fov_circle", "Enable Fov Circle", true)
local lua_enable_fov_circle_deadzone = gui.Checkbox(lua_ref, "enable_fov_circle", "Show DeadZone", true)
local lua_fov_circle_color = gui.ColorPicker(lua_enable_fov_circle, "fov_circle_color", "Circle Color", 255, 255, 255)
local lua_fov_deadzone_color =
	gui.ColorPicker(lua_enable_fov_circle_deadzone, "fov_circle_color", "Circle Color", 255, 0, 0)
local lua_enable_fov_circle_rage = gui.Checkbox(lua_ref, "enable_fov_circle", "Show Rage", true)
local lua_fov_rage_color = gui.ColorPicker(lua_enable_fov_circle, "fov_circle_color", "Cirle Color", 120, 120, 255)

local target = nil
function current_target()
	if not entities:GetLocalPlayer() or not entities:GetLocalPlayer():IsAlive() then
		return
	end
	local nearest = math.huge
	for k, v in pairs(entities.FindByClass("C_CSPlayerPawn")) do
		if
			v:GetIndex() ~= entities.GetLocalPlayer():GetIndex()
			and v:GetTeamNumber() ~= entities.GetLocalPlayer():GetTeamNumber()
			and v:IsAlive()
		then
			local screen_position_target_x, screen_position_target_y = client.WorldToScreen(v:GetAbsOrigin())
			if screen_position_target_x ~= nil and screen_position_target_y ~= nil then
				local distance_from_center = math.sqrt(
					(
						((Screen_Weight * Screen_Weight) - (screen_position_target_x * screen_position_target_x))
						+ ((Screen_Height * Screen_Height) - (screen_position_target_y * screen_position_target_y))
					)
				)
				if distance_from_center < nearest then
					target = v
					nearest = distance_from_center
				end
			end
		end
	end
end
callbacks.Register("Draw", current_target)

local distance = 0
local function target_distance()
	if not entities:GetLocalPlayer() or not entities:GetLocalPlayer():IsAlive() then
		return
	end
	if target ~= nil then
		target_origin = target:GetAbsOrigin()
		local_origin = entities:GetLocalPlayer():GetAbsOrigin()
		distance = (
			vector.Distance(
				{ local_origin.x, local_origin.y, local_origin.z },
				{ target_origin.x, target_origin.y, target_origin.z }
			)
		)
	end
end
callbacks.Register("Draw", target_distance)

function Get_Weapon()
	if not entities:GetLocalPlayer() or not entities:GetLocalPlayer():IsAlive() then
		return
	end
	local localplayer = entities:GetLocalPlayer()
	local localplayerweapon = localplayer:GetWeaponID()
	if
		localplayerweapon == 2
		or localplayerweapon == 3
		or localplayerweapon == 4
		or localplayerweapon == 30
		or localplayerweapon == 32
		or localplayerweapon == 36
		or localplayerweapon == 61
		or localplayerweapon == 63
	then
		weaponclass = "pistol"
	elseif localplayerweapon == 9 then
		weaponclass = "sniper"
	elseif localplayerweapon == 40 then
		weaponclass = "scout"
	elseif localplayerweapon == 1 then
		weaponclass = "hpistol"
	elseif
		localplayerweapon == 17
		or localplayerweapon == 19
		or localplayerweapon == 23
		or localplayerweapon == 24
		or localplayerweapon == 26
		or localplayerweapon == 33
		or localplayerweapon == 34
	then
		weaponclass = "smg"
	elseif
		localplayerweapon == 7
		or localplayerweapon == 8
		or localplayerweapon == 10
		or localplayerweapon == 13
		or localplayerweapon == 16
		or localplayerweapon == 39
		or localplayerweapon == 61
	then
		weaponclass = "rifle"
	elseif localplayerweapon == 25 or localplayerweapon == 27 or localplayerweapon == 29 or localplayerweapon == 35 then
		weaponclass = "shotgun"
	elseif localplayerweapon == 38 or localplayerweapon == 11 then
		weaponclass = "asniper"
	elseif localplayerweapon == 28 or localplayerweapon == 14 then
		weaponclass = "lmg"
	elseif
		localplayerweapon == 42
		or localplayerweapon == 505
		or localplayerweapon == 506
		or localplayerweapon == 507
		or localplayerweapon == 508
		or localplayerweapon == 509
		or localplayerweapon == 510
		or localplayerweapon == 511
		or localplayerweapon == 512
		or localplayerweapon == 513
		or localplayerweapon == 514
		or localplayerweapon == 515
		or localplayerweapon == 516
		or localplayerweapon == 517
		or localplayerweapon == 518
		or localplayerweapon == 519
		or localplayerweapon == 520
		or localplayerweapon == 521
		or localplayerweapon == 522
		or localplayerweapon == 523
		or localplayerweapon == 524
	then
		weaponclass = "knife"
	elseif localplayerweapon == 31 then
		weaponclass = "zeus"
	elseif
		localplayerweapon == 43
		or localplayerweapon == 44
		or localplayerweapon == 45
		or localplayerweapon == 46
		or localplayerweapon == 47
		or localplayerweapon == 48
	then
		weaponclass = "nade"
	else
		weaponclass = "shared"
	end
end
callbacks.Register("Draw", Get_Weapon)

function draw_circle()
	if not entities:GetLocalPlayer() or not entities:GetLocalPlayer():IsAlive() then
		return
	end
	if weaponclass ~= "knife" and weaponclass ~= "nade" then
		if target ~= nil then
			if lua_enable_fov_circle:GetValue() then
				draw.Color(lua_fov_circle_color:GetValue())
				draw.OutlinedCircle(
					Screen_Weight / 2,
					Screen_Height / 2,
					(25 * gui.GetValue("lbot.weapon.target." .. weaponclass .. ".maxfov") * (500 / distance))
				)
			end
			if lua_enable_fov_circle_deadzone:GetValue() then
				draw.Color(lua_fov_deadzone_color:GetValue())
				draw.OutlinedCircle(
					Screen_Weight / 2,
					Screen_Height / 2,
					(25 * gui.GetValue("lbot.weapon.target." .. weaponclass .. ".minfov") * (500 / distance))
				)
			end
			if lua_enable_fov_circle_rage:GetValue() then
				draw.Color(lua_fov_rage_color:GetValue())
				draw.OutlinedCircle(Screen_Weight / 2, Screen_Height / 2, (13 * gui.GetValue("rbot.aim.target.fov")))
			end
		end
	end
end
callbacks.Register("Draw", draw_circle)

--***********************************************--

print("♥♥♥ " .. GetScriptName() .. " loaded without Errors ♥♥♥")
