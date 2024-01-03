--[==[
	This script was made by Good_Evening (https://aimware.net/forum/user/455340)
	ForumThread: https://aimware.net/forum/thread/174929
]==]

local _DEBUG = false

local font = draw.CreateFont("Arial", 12, 100)

local g_stBombRadius = {
	--map_showbombradius
	["( 0, 0, 0 ),( 0, 0, 0 )"] = 1750, -- Game's Default Value
	["( -440, -2150, -168 ),( -2048, 256, -151 )"] = 2275, -- Mirage
	["( -2136, 662, 506 ),( -1104, 64, 108 )"] = 2275, -- Overpass
	["( -293.5, -621, 11791.5 ),( -2248, 797.5, 11758 )"] = 1750, -- Vertigo
	["( -1392, 844, 68 ),( 886.5, 62, 144 )"] = 2275, -- Ancient
	["( 1976, 462, 180 ),( 351.99997, 2768, 173 )"] = 2170, -- Inferno
	["( 688, -719.99994, -368 ),( 592, -1008, -748 )"] = 2275, -- Nuke
	["( 1237.4761, 1953.5, -181.5 ),( -1040, 694, -2 )"] = 1575, -- Anubis
	["( 1112, 2480, 144 ),( -1536, 2680, 48 )"] = 1750, -- Dust 2
}

local function GetBombRadius()
	local iBombRadius = 1750 -- Game's Default Value
	local sFormat = "%s,%s"

	local aC_CSPlayerResource = entities.FindByClass("C_CSPlayerResource")

	if type(aC_CSPlayerResource) ~= "table" then
		return
	end

	if #aC_CSPlayerResource <= 0 then
		return
	end

	for _, ent in pairs(aC_CSPlayerResource) do
		local sIdentifier =
			sFormat:format(ent:GetPropVector("m_bombsiteCenterA") or "", ent:GetPropVector("m_bombsiteCenterB") or "")

		local v = g_stBombRadius[sIdentifier]
		if not v and _DEBUG then
			print(('["%s"]'):format(sIdentifier))
		end

		iBombRadius = math.max(iBombRadius, v or 0)
	end

	return iBombRadius
end

local g_iTickCount = 0
local g_iLastTickCount = 0

local g_iLocalHealth = 0
local g_iLocalArmor = 0
local g_vLocalViewOrigin = Vector3(0, 0, 0)

local g_iBombRadius = 1750

local function OnTick()
	local pLocalPlayer = entities.GetLocalPlayer()
	if not pLocalPlayer then
		return
	end

	g_iLocalHealth = pLocalPlayer:GetPropInt("m_iHealth") or 0
	g_iLocalArmor = pLocalPlayer:GetPropInt("m_ArmorValue") or 0
	g_vLocalViewOrigin = pLocalPlayer:GetAbsOrigin()
		+ (pLocalPlayer:GetPropVector("m_vecViewOffset") or Vector3(0, 0, 62))

	g_iBombRadius = GetBombRadius()
end

callbacks.Register("Draw", function()
	g_iTickCount = globals.TickCount()

	if g_iTickCount ~= g_iLastTickCount then
		g_iLastTickCount = g_iTickCount
		OnTick()
	end
end)

callbacks.Register("DrawESP", function(ctx)
	local pEnt = ctx:GetEntity()

	if not pEnt or g_iLocalHealth <= 0 then
		return
	end

	if pEnt:GetClass() ~= "C_PlantedC4" then
		return
	end

	if not pEnt:GetPropBool("m_bBombTicking") then
		return
	end

	local fDistance = (pEnt:GetAbsOrigin() - g_vLocalViewOrigin):Length()

	local fDamage = (g_iBombRadius / 3.5) * math.exp(fDistance ^ 2 / (-2 * (g_iBombRadius / 3) ^ 2))

	if g_iLocalArmor > 0 then
		fDamage = (fDamage / 4 > g_iLocalArmor) and (fDamage - g_iLocalArmor * 2) or (fDamage / 2)
	end

	fDamage = math.floor(fDamage + 0.75)

	if fDamage >= g_iLocalHealth then
		ctx:Color(255, 55, 55, 255)
		draw.SetFont(font)
		ctx:AddTextBottom("LETHAL")

		return
	end

	local v = math.floor(255 - 200 * math.max(fDamage / g_iLocalHealth, 0))

	ctx:Color(255, v, v, 255)
	ctx:AddTextBottom(("-%0.0fHP"):format(fDamage))
end)

print("Bombdamage loaded")
