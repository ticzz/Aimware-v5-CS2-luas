local iLastTick = 0

callbacks.Register("Draw", function()
	if globals.TickCount() > iLastTick then
		local playerList = entities.FindByClass("C_CSPlayerPawn")
		for i = 1, #playerList do
			if playerList[i]:GetPropEntity("m_hObserverTarget"):GetIndex() == entities.GetLocalPlayer():GetIndex() then
				gui.SetValue("misc.showspec", true)
				return
			end
		end
		gui.SetValue("misc.showspec", false)
	end
	iLastTick = globals.TickCount()
end)
