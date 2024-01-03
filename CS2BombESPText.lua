local ref = gui.Reference("Visuals", "Local", "Camera")
local chk = gui.Checkbox(ref, "enablebombesptext", "BoooooooombESP", false)
local function DrawESP(builder)
	if not entities.GetLocalPlayer() or not chk then
		return
	end

	local players = entities.FindByClass("C_CSPlayerPawn")

	for i, player in ipairs(players) do
		print(player)
	end

	local c4bomb = builder:GetEntity():GetPropEntity("m_iPlayerC4")

	if c4bomb then
		builder:Color(255, 0, 0, 255)
	else
		builder:Color(0, 255, 0, 255)
	end

	builder:AddTextBottom("BOMB")
end

callbacks.Register("DrawESP", DrawESP)
