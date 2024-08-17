local function get_weapon_class(weapon_id)
	if weapon_id == 11 or weapon_id == 38 then
		return "asniper"
	elseif weapon_id == 1 or weapon_id == 64 then
		return "hpistol"
	elseif weapon_id == 14 or weapon_id == 28 then
		return "lmg"
	elseif weapon_id == 2 or weapon_id == 3 or weapon_id == 4 or weapon_id == 30 or weapon_id == 32 or weapon_id == 36 or weapon_id == 61 or weapon_id == 63 then
		return "pistol"
	elseif weapon_id == 7 or weapon_id == 8 or weapon_id == 10 or weapon_id == 13 or weapon_id == 16 or weapon_id == 39 or weapon_id == 60 then
		return "rifle"
	elseif weapon_id == 40 then
		return "scout"
	elseif weapon_id == 17 or weapon_id == 19 or weapon_id == 23 or weapon_id == 24 or weapon_id == 26 or weapon_id == 33 or weapon_id == 34 then
		return "smg"
	elseif weapon_id == 25 or weapon_id == 27 or weapon_id == 29 or weapon_id == 35 then
		return "shotgun"
	elseif weapon_id == 9 then
		return "sniper"
	elseif weapon_id == 31 then
		return "zeus"
	elseif weapon_id == 37 then
		return "SHIELD"
	elseif weapon_id == 85 then
		return "Bumpmine"
	end
	return "shared"
end

callbacks.Register("Draw", function()
	local local_player = entities.GetLocalPlayer()
	if not local_player or not local_player:IsAlive() then
		gui.SetValue("misc.strafe.enable", true)
		return
	end

	if local_player ~= nil then
		local weapon_id = local_player:GetWeaponID()
		local weapon_group = get_weapon_class(weapon_id)
		if weapon_group == "scout" then
			gui.SetValue("misc.strafe.enable", false)
		else
			gui.SetValue("misc.strafe.enable", true)
		end
	end
end)

print("♥♥♥ " .. GetScriptName() .. " loaded without Errors ♥♥♥")
