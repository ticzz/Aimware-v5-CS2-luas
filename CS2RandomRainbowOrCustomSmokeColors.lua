-- Original "Custom Smoke Colour" by Clark --> https://aimware.net/forum/user/115569
-- (Original was without rainbow effect)
local ref = gui.Reference("Visuals", "Other", "Effects")
local enable = gui.Checkbox(ref, "smoke.enabled", "Change Smoke Colour", false)
local colour = gui.ColorPicker(enable, "smoke.colour", "Smoke Colour", 0, 255, 0, 255)
local rainbow = gui.Checkbox(ref, "smoke.rainbow", "Rainbow Smoke", false)
local smokefrequency = gui.Slider(ref, "smoke.freq", "Set the frequency of Changer", 0.75, 0, 100, 0.05)
smokefrequency:SetDescription("default = 0.75 -- range: [0, 100) | lower is slower")

local r, g, b = 0, 0, 0
local tick = 0

callbacks.Register("Draw", function()
	if not enable:GetValue() then
		return
	end

	local smokes = entities.FindByClass("C_SmokeGrenadeProjectile")

	if rainbow:GetValue() then
		tick = tick + 1
		local smokefreq = smokefrequency:GetValue() -- you can adjust this value to change the speed of the rainbow
		r = math.floor(math.sin(tick * smokefreq + 0) * 127 + 128)
		g = math.floor(math.sin(tick * smokefreq + 2) * 127 + 128)
		b = math.floor(math.sin(tick * smokefreq + 4) * 127 + 128)
	else
		r, g, b = colour:GetValue()
	end

	for i = 1, #smokes do
		local smoke = smokes[i]
		local bDidSmokeEffect = smoke:GetPropBool("m_bDidSmokeEffect")

		if bDidSmokeEffect == false then
			smoke:SetPropVector(Vector3(r, g, b), "m_vSmokeColor")
		end
	end
end)
