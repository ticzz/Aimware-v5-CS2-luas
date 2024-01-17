local ref = gui.Reference("Visuals", "Overlay", "Enemy")
local chk = gui.Checkbox(ref, "enablebombesptext", "BoooooooombESP", false)
local function OnDrawESP(builder)
	if not entities.GetLocalPlayer() or not chk then
		return
	end
	local players = entities.FindByClass("C_CSPlayerPawn")
	local ent = builder:GetEntity()
	for i = 1, #players do
		local player = players[i]
		print(player)
	end
	local c4bomb = ent:GetPropEntity("m_iPlayerC4")
	if not c4bomb then
		return
	else
		builder:Color(255, 0, 0, 255)
		builder:AddTextBottom("BOMBer")	
	end
end
callbacks.Register("DrawESP", OnDrawESP)
--***********************************************--
print("" .. GetScriptName() .. " loaded without Errors")
