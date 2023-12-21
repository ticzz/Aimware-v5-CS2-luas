local ref = gui.Reference("Visuals", "Other", "Effects")
local rainbowthemecb = gui.Checkbox(ref, "rainbowtheme", "GUI Theme Colors Changer", false)
local rainbowhud = gui.Checkbox(ref, "rgbhud", "Hud Colors Changer", false)
local rainbowhudinterval = gui.Slider(ref, "rainbowhud.interval", "Rainbow Hud Interval", 1, 0, 5, 0.05)
local saturation = 0.5 -- range: [0.00, 1.00] | lower is less saturated

-- Rainbow Hud by stacky
local color = 1
local time = globals.CurTime()
local orig = client.GetConVar("cl_hud_color")

callbacks.Register("Draw", "rgbhud", function()
	if rainbowhud:GetValue() then
		client.Command("cl_hud_color " .. color, true)
		if globals.CurTime() - rainbowhudinterval:GetValue() >= time then
			color = color + 1
			time = globals.CurTime()
		end
		if color > 9 then
			color = 1
		end
	end
end)

local function hsvToRgb(h, s, v)
	local r, g, b

	local i = math.floor(h * 6)
	local f = h * 6 - i
	local p = v * (1 - s)
	local q = v * (1 - f * s)
	local t = v * (1 - (1 - f) * s)

	i = i % 6

	if i == 0 then
		r, g, b = v, t, p
	elseif i == 1 then
		r, g, b = q, v, p
	elseif i == 2 then
		r, g, b = p, v, t
	elseif i == 3 then
		r, g, b = p, q, v
	elseif i == 4 then
		r, g, b = t, p, v
	elseif i == 5 then
		r, g, b = v, p, q
	end

	return r, g, b
end

local function rainbowtheme()
	local R, G, B = hsvToRgb((globals.RealTime() * frequency) % 1, saturation, 1)
	gui.SetValue("theme.footer.bg", math.floor(R), math.floor(G), math.floor(B), 255)
	gui.SetValue("theme.footer.text", math.floor(R), math.floor(G), math.floor(B), 25)
	gui.SetValue("theme.header.bg", math.floor(R), math.floor(G), math.floor(B), 25)
	gui.SetValue("theme.header.line", math.floor(R), math.floor(G), math.floor(B), 25)
	gui.SetValue("theme.header.text", math.floor(R), math.floor(G), math.floor(B), 25)
	gui.SetValue("theme.nav.active", math.floor(R), math.floor(G), math.floor(B), 255)
	gui.SetValue("theme.nav.bg", math.floor(R), math.floor(G), math.floor(B), 65)
	gui.SetValue("theme.nav.shadow", math.floor(R), math.floor(G), math.floor(B), 180)
	gui.SetValue("theme.nav.text", math.floor(R), math.floor(G), math.floor(B), 255)
	gui.SetValue("theme.tablist.shadow", math.floor(R), math.floor(G), math.floor(B), 32)
	gui.SetValue("theme.tablist.tabactivebg", math.floor(R), math.floor(G), math.floor(B), 255)
	gui.SetValue("theme.tablist.tabdecorator", math.floor(R), math.floor(G), math.floor(B), 255)
	gui.SetValue("theme.tablist.text", math.floor(R), math.floor(G), math.floor(B), 25)
	gui.SetValue("theme.tablist.text2", math.floor(R), math.floor(G), math.floor(B), 25)
	gui.SetValue("theme.ui2.border", math.floor(R), math.floor(G), math.floor(B), 25)
	gui.SetValue("theme.ui2.lowpoly1", math.floor(R), math.floor(G), math.floor(B), 255)
	gui.SetValue("theme.ui2.lowpoly2", math.floor(R), math.floor(G), math.floor(B), 105)
end
callbacks.Register("Draw", "rainbowvisuals", function()
	if rainbowthemecb == true then
		rainbowtheme()
	end
end)

callbacks.Register("Unload", function()
	client.Command("cl_hud_color " .. orig, true)
	UnloadScript(GetScriptName())
end)
