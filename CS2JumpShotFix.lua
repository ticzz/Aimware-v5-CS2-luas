------------weapon_hegrenade  weapon_incgrenade  weapon_molotov

local weaponIDs = {
	pistol = { 2, 3, 4, 30, 32, 36, 61, 63 },
	sniper = { 9 },
	scout = { 40 },
	hpistol = { 1 },
	smg = { 17, 19, 23, 24, 26, 33, 34 },
	rifle = { 7, 8, 10, 13, 16, 39, 61 },
	shotgun = { 25, 27, 29, 35 },
	asniper = { 38, 11 },
	lmg = { 28, 14 },
	knife = {
		42,
		505,
		506,
		507,
		508,
		509,
		510,
		511,
		512,
		513,
		514,
		515,
		516,
		517,
		518,
		519,
		520,
		521,
		522,
		523,
		524,
	},
	zeus = { 31 },
	nade = { 43, 44, 45, 46, 47, 48 },
}

local function get_current_weapon()
	if not entities:GetLocalPlayer() or not entities:GetLocalPlayer():IsAlive() then
		return
	end

	local localPlayer = entities:GetLocalPlayer()
	local weaponID = localPlayer:GetWeaponID()

	for weaponClass, ids in pairs(weaponIDs) do
		for _, id in ipairs(ids) do
			if id == weaponID then
				return weaponClass
			end
		end
	end

	return "shared"
end


local function jump_scout_fix()
	local lp = entities.GetLocalPlayer()
	if lp and lp:IsAlive() then
		local vel = math.sqrt(
			lp:GetPropFloat("localdata", "m_vecVelocity[0]") ^ 2 + lp:GetPropFloat("localdata", "m_vecVelocity[1]") ^ 2)
		local weaponid == get_current_weapon()
		if not weaponid or weaponid ~= 40 then return end
		if weaponid == 40 then
			if vel > 25 then
				gui.SetValue("misc.strafe.enable", true)
			else
				gui.SetValue("misc.strafe.enable", false)
			end
		else
			gui.SetValue("misc.strafe.enable", true)
		end
	else
		gui.SetValue("misc.strafe.enable", true)
	end
end
callbacks.Register("Draw", jump_scout_fix)

--***********************************************--

print("♥♥♥ " .. GetScriptName() .. " loaded without Errors ♥♥♥")
