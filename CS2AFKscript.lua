local status, err = pcall(function()
	local calibri = draw.CreateFont("Calibri bold", 29, 600)
	local screen_size_x, screen_size_y = draw.GetScreenSize() -- screen
	local ctx = screen_size_x / 2
	local cty = screen_size_y / 2
	local commandExecuted = false
	local resetCommandExecuted = true
	local ref = gui.Reference("Misc", "Enhancement", "Appearance")
	local afkmaster = gui.Checkbox(ref, "afkmaster", "AFK", false)
	local afkbind = gui.Keybox(ref, "afkbind", "AFK key", 0)
	local shouldtalk = gui.Checkbox(ref, "shouldtalk", "Say in Chat", false)
	local indicator = gui.Checkbox(ref, "indicator", "Indicator", false)
	local color = gui.ColorPicker(indicator, "color", "Indicator Color", 255, 255, 255, 255)
	local sayExecuted = false
	local printExecuted = true

	local function afkgo()
		if afkbind:GetValue() and input.IsButtonPressed(afkbind:GetValue()) then
			afkmaster:SetValue(true)
		else
			afkmaster:SetValue(false)
		end

		if afkmaster:GetValue() and not commandExecuted then
			client.Command("+duck;+forward;+left", true)
			commandExecuted = true
			resetCommandExecuted = false
		elseif not afkmaster:GetValue() and not resetCommandExecuted then
			client.Command("-forward;-duck;-left", true)
			resetCommandExecuted = true
			commandExecuted = false
		end
	end

	local function shouldittalk()
		if shouldtalk:GetValue() and afkmaster:GetValue() and not sayExecuted then
			client.Command("say_team Afk!", true)
			sayExecuted = true
		elseif afkmaster:GetValue() == false and shouldtalk:GetValue() == true and sayExecuted then
			sayExecuted = false
		end

		if shouldtalk:GetValue() and not afkmaster:GetValue() and not printExecuted then
			client.Command("say_team Back!", true)
			printExecuted = true
		elseif afkmaster:GetValue() and printExecuted then
			printExecuted = false
		end
	end

	local function on_paint()
		local r, g, b, a = color:GetValue()
		if indicator:GetValue() then
			if afkmaster:GetValue() then
				draw.SetFont(calibri)
				draw.Color(r, g, b, a)
				draw.Text(ctx, cty, "AFK")
			end
		end
	end

	callbacks.Register("CreateMove", afkgo)
	callbacks.Register("CreateMove", shouldittalk)
	callbacks.Register("Draw", on_paint)

	-- Handle errors
	if not status then
		print("Error " .. err)
		logFile = file.Open("error.txt", "a")
		logFile:Write(err .. "\n")
		logFile:Close()
		return
	end
end)
