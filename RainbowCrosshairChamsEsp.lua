local ref = gui.Reference("Visuals", "Other", "Effects")

-- Create necessary components
gui.Text(ref, "Enable Rainbow Colors")
local crosshairEnabled = gui.Checkbox(ref, "crosshairEnabled", "Enable Crosshair", false)
local chamsEnabled = gui.Checkbox(ref, "chamsEnabled", "Enable Chams", false)
local espEnabled = gui.Checkbox(ref, "espEnabled", "Enable ESP", false)

local crosshairFrequency = gui.Slider(ref, "crosshairFreq", "Crosshair Frequency", 0.75, 0, 50, 0.05)
local chamsFrequency = gui.Slider(ref, "chamsFreq", "Chams Frequency", 0.75, 0, 50, 0.05)
local espFrequency = gui.Slider(ref, "espFreq", "ESP Frequency", 0.75, 0, 50, 0.05)

-- Function to handle updating colors
local updateColors = function()
	local enabled = crosshairEnabled:GetValue() or chamsEnabled:GetValue() or espEnabled:GetValue()

	if enabled then
		if crosshairEnabled:GetValue() then
			local freq = crosshairFrequency:GetValue()
			local r = math.floor(math.sin(globals.RealTime() * freq + 0) * 127 + 128)
			local g = math.floor(math.sin(globals.RealTime() * freq + 2) * 127 + 128)
			local b = math.floor(math.sin(globals.RealTime() * freq + 4) * 127 + 128)
			client.Command("cl_crosshaircolor 5", true)
			client.Command("cl_crosshaircolor_r " .. r, true)
			client.Command("cl_crosshaircolor_g " .. g, true)
			client.Command("cl_crosshaircolor_b " .. b, true)
		end

		if chamsEnabled:GetValue() then
			local freq = chamsFrequency:GetValue()
			local r = math.floor(math.sin(globals.RealTime() * freq + 0) * 127 + 128)
			local g = math.floor(math.sin(globals.RealTime() * freq + 2) * 127 + 128)
			local b = math.floor(math.sin(globals.RealTime() * freq + 4) * 127 + 128)
			gui.SetValue("esp.chams.enemy.visible.clr", r, g, b, 255, true)
			gui.SetValue("esp.chams.enemy.occluded.clr", r, g, b, 255, true)
			gui.SetValue("esp.chams.friendly.visible.clr", r, g, b, 255, true)
			gui.SetValue("esp.chams.friendly.occluded.clr", r, g, b, 255, true)
			gui.SetValue("esp.chams.local.occluded.clr", r, g, b, 255, true)
			gui.SetValue("esp.chams.local.visible.clr", r, g, b, 255, true)
			gui.SetValue("esp.chams.localweapon.visible.clr", r, g, b, 255, true)
			gui.SetValue("esp.chams.localweapon.occluded.clr", r, g, b, 255, true)
			gui.SetValue("esp.chams.localarms.visible.clr", r, g, b, 255, true)
			gui.SetValue("esp.chams.localarms.occluded.clr", r, g, b, 255, true)
			gui.SetValue("esp.chams.weapon.visible.clr", r, g, b, 255, true)
			gui.SetValue("esp.chams.weapon.occluded.clr", r, g, b, 255, true)
		end

		if espEnabled:GetValue() then
			local freq = espFrequency:GetValue()
			local r = math.floor(math.sin(globals.RealTime() * freq + 0) * 127 + 128)
			local g = math.floor(math.sin(globals.RealTime() * freq + 2) * 127 + 128)
			local b = math.floor(math.sin(globals.RealTime() * freq + 4) * 127 + 128)
			gui.SetValue("esp.overlay.enemy.skeleton.clr1", r, g, b, 255, true)
			gui.SetValue("esp.overlay.enemy.ammo.clr1", r, g, b, 255, true)
			gui.SetValue("esp.overlay.enemy.ammo.clr2", r, g, b, 255, true)
			gui.SetValue("esp.overlay.enemy.weapon.clr1", r, g, b, 255, true)
			gui.SetValue("esp.overlay.weapon.box.clr1", r, g, b, 255, true)
			gui.SetValue("esp.overlay.enemy.box.clr1", r, g, b, 255, true)
			gui.SetValue("esp.overlay.enemy.health.healthbar.healthclr1", r, g, b, 255, true)
			gui.SetValue("esp.overlay.enemy.health.healthbar.healthclr2", r, g, b, 255, true)
			gui.SetValue("esp.other.crosshair.clr", r, g, b, 255, true)
			gui.SetValue("esp.other.recoilcrosshair.clr", r, g, b, 255, true)
			gui.SetValue("esp.overlay.enemy.skeleton.clr1", r, g, b, 255, true)
		end
	end
end

-- Function to handle resetting values
local resetValues = function()
	crosshairEnabled:SetValue(false)
	chamsEnabled:SetValue(false)
	espEnabled:SetValue(false)
end

-- Register callbacks
callbacks.Register("Draw", updateColors)
callbacks.Register("Unload", resetValues)
