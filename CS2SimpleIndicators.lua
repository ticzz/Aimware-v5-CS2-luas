local logFile = file.Open("error.txt", "a")
local font = draw.CreateFont("Tahoma", 14, 400)
local font2 = draw.CreateFont("Tahoma", 12, 400)
local color = draw.Color
local text = draw.TextShadow
local w, h = draw.GetScreenSize()
local half_h = h / 2
local tab = gui.Reference("Visuals")
local ragebot_accuracy_weapon = gui.Reference("Ragebot", "Accuracy", "Automate")
local gb =gui.Tab(tab,"indicatortab", "Indicators")
local ref= gui.Groupbox(gb, "Indicators")
local activateAll = gui.Checkbox(ref, "activateAll", "Activate All Indicators", false)
local autofire_check = gui.Checkbox(ref, "autofire.ind", "AutoFire Indicator", false)
local fov_check = gui.Checkbox(ref, "fov.ind", "FOV Indicator", false)
local hc_check = gui.Checkbox(ref, "hc.ind", "HC Indicator", false)
local mindmg_check = gui.Checkbox(ref, "mindmg.ind", "MinDmg Indicator", false)
local backtrack_check = gui.Checkbox(ref, "backtrack.ind", "Backtrack Indicator", false)
local quickpeek_check = gui.Checkbox(ref, "quickpeek.ind", "Quickpeek Indicator", false)
local antiaim_check = gui.Checkbox(ref, "antiaim.ind", "AntiAim Indicator", false)
local x_offset = gui.Slider(ref, "w_offset.ind.offset", "Indicators W", 10, 0, w)
local y_offset = gui.Slider(ref, "h_offset.ind.offset", "Indicators H", 240, 0, h)
local on_clr = gui.ColorPicker(ref, "ind.on.color", "Indicators ON Color", 78, 193, 89, 255)
local off_clr = gui.ColorPicker(ref, "ind.off.color", "Indicators OFF Color", 225, 25, 25, 255)
local value_clr = gui.ColorPicker(ref, "ind.value.color", "Indicators Value Color", 30, 170, 200, 255)
local function menu_weapon(var)
	local wp = string.match(var, '"(.+)"')
	local wp = string.lower(wp)
	if wp == "heavy pistol" then
		return "hpistol"
	elseif wp == "auto sniper" then
		return "asniper"
	elseif wp == "submachine gun" then
		return "smg"
	elseif wp == "awp" then
		return "sniper"
	elseif wp == "ssg08" then
		return "scout"
	elseif wp == "light machine gun" then
		return "lmg"
	else
		return "shared"
	end
end


	callbacks.Register("Draw", "SimpleIndicators", function()
	local lp = entities.GetLocalPlayer()
	if not lp then
		return
	end
	local wid = lp:GetWeaponID()
	local weapon_ref = menu_weapon(ragebot_accuracy_weapon:GetValue())
	local quickpeek = gui.GetValue("rbot.accuracy.walkbot.peek")
	local quickpeekkey = gui.GetValue("rbot.accuracy.walkbot.peekkey")
	local fov = gui.GetValue("rbot.aim.target.fov")
	local aa_base = gui.GetValue("rbot.antiaim.base")
	local aa_base_rot = gui.GetValue("rbot.antiaim.base.rotation")
	draw.SetFont(font)
	if autofire_check:GetValue() then
		if gui.GetValue("rbot.master") == true then
			color(on_clr:GetValue())
			text(10 + x_offset:GetValue(), half_h - 40 + y_offset:GetValue(), "AutoFire")
		else
			color(off_clr:GetValue())
			text(10 + x_offset:GetValue(), half_h - 40 + y_offset:GetValue(), "AutoFire")
		end
	end
	if fov_check:GetValue() then
		if fov:GetValue() then
			color(on_clr:GetValue())
			text(10 + x_offset:GetValue(), half_h - 25 + y_offset:GetValue(), "FOV: ")
			color(value_clr:GetValue())
			text(82 + x_offset:GetValue(), half_h - 25 + y_offset:GetValue(), "" .. fov)
		else
			color(on_clr:GetValue())
			text(10 + x_offset:GetValue(), half_h - 25 + y_offset:GetValue(), "FOV: ")
			color(value_clr:GetValue())
			text(82 + x_offset:GetValue(), half_h - 25 + y_offset:GetValue(), "no ragefov")
		end
	end
	if hc_check:GetValue() then
		if not wid then
			return
		end
		if
			wid == 41
			or wid == 42
			or wid == 74
			or wid == 41
			or wid == 43
			or wid == 44
			or wid == 45
			or wid == 46
			or wid == 47
			or wid == 48
			or wid == 49
			or wid == 57
			or wid == 59
			or wid == 500
			or wid == 503
			or wid == 505
			or wid == 506
			or wid == 507
			or wid == 508
			or wid == 509
			or wid == 512
			or wid == 514
			or wid == 515
			or wid == 516
			or wid == 517
			or wid == 518
			or wid == 519
			or wid == 520
			or wid == 521
			or wid == 522
			or wid == 523
			or wid == 525
		then
			color(124, 176, 34, 255)
			text(10 + x_offset:GetValue(), half_h - 10 + y_offset:GetValue(), "HC %: ")
			color(value_clr:GetValue())
			text(82 + x_offset:GetValue(), half_h - 10 + y_offset:GetValue(), "N/A")
		else
			local hc = gui.GetValue("rbot.hitscan.accuracy." .. weapon_ref .. ".hitchance")
			color(124, 176, 34, 255)
			text(10 + x_offset:GetValue(), half_h - 10 + y_offset:GetValue(), "HC %: ")
			color(value_clr:GetValue())
			text(82 + x_offset:GetValue(), half_h - 10 + y_offset:GetValue(), "" .. hc)
		end
	end
	if mindmg_check:GetValue() then
		if not wid then
			return
		end
		if
			wid == 41
			or wid == 42
			or wid == 74
			or wid == 41
			or wid == 43
			or wid == 44
			or wid == 45
			or wid == 46
			or wid == 47
			or wid == 48
			or wid == 49
			or wid == 57
			or wid == 59
			or wid == 500
			or wid == 503
			or wid == 505
			or wid == 506
			or wid == 507
			or wid == 508
			or wid == 509
			or wid == 512
			or wid == 514
			or wid == 515
			or wid == 516
			or wid == 517
			or wid == 518
			or wid == 519
			or wid == 520
			or wid == 521
			or wid == 522
			or wid == 523
			or wid == 525
		then
			color(124, 176, 34, 255)
			text(10 + x_offset:GetValue(), half_h + 5 + y_offset:GetValue(), "MinDMG: ")
			color(value_clr:GetValue())
			text(82 + x_offset:GetValue(), half_h + 5 + y_offset:GetValue(), "N/A")
		else
			local mindmg = gui.GetValue("rbot.hitscan.accuracy." .. weapon_ref .. ".mindamage")
			color(124, 176, 34, 255)
			text(10 + x_offset:GetValue(), half_h + 5 + y_offset:GetValue(), "MinDMG: ")
			color(value_clr:GetValue())
			text(82 + x_offset:GetValue(), half_h + 5 + y_offset:GetValue(), "" .. mindmg)
			draw.SetFont(font2)
			text(10 + x_offset:GetValue(), half_h + 20 + y_offset:GetValue(), "Weapon: ")
			text(82 + x_offset:GetValue(), half_h + 20 + y_offset:GetValue(), "" .. weapon_ref)
		end
	end
	draw.SetFont(font)
	color(0, 0, 0, 255)
	text(10 + x_offset:GetValue(), half_h + 25 + y_offset:GetValue(), "-------------------")
	if backtrack_check:GetValue() then
		if gui.GetValue("rbot.aim.posadj.backtrack") == true then
			color(on_clr:GetValue())
			text(10 + x_offset:GetValue(), half_h + 35 + y_offset:GetValue(), "Backtrack")
		else
			color(off_clr:GetValue())
			text(10 + x_offset:GetValue(), half_h + 35 + y_offset:GetValue(), "Backtrack")
		end
	end

	if quickpeek_check:GetValue() then
		if quickpeek then
			if quickpeekkey ~= 0 and input.IsButtonDown(quickpeekkey) == true then
				color(on_clr:GetValue())
				text(10 + x_offset:GetValue(), half_h + 125 + y_offset:GetValue(), "Quickpeek/IT")
			else
				color(off_clr:GetValue())
				text(10 + x_offset:GetValue(), half_h + 125 + y_offset:GetValue(), "Quickpeek/IT")
			end
		end
	end
	color(0, 0, 0, 255)
	text(10 + x_offset:GetValue(), half_h + 135 + y_offset:GetValue(), "-------------------")
	if antiaim_check:GetValue() then
		if gui.GetValue("rbot.master") ~= true then
			color(off_clr:GetValue())
			text(10 + x_offset:GetValue(), half_h + 145 + y_offset:GetValue(), "AntiAim: ")
			color(value_clr:GetValue())
			text(82 + x_offset:GetValue(), half_h + 145 + y_offset:GetValue(), "Off")
			color(on_clr:GetValue())
			text(10 + x_offset:GetValue(), half_h + 160 + y_offset:GetValue(), "Rotation: ")
			color(value_clr:GetValue())
			text(82 + x_offset:GetValue(), half_h + 160 + y_offset:GetValue(), "Off")
		else
			color(on_clr:GetValue())
			text(10 + x_offset:GetValue(), half_h + 145 + y_offset:GetValue(), "AntiAim: ")
			color(value_clr:GetValue())
			text(82 + x_offset:GetValue(), half_h + 145 + y_offset:GetValue(), "" .. aa_base)
			color(on_clr:GetValue())
			text(10 + x_offset:GetValue(), half_h + 160 + y_offset:GetValue(), "Rotation: ")
			color(value_clr:GetValue())
			text(82 + x_offset:GetValue(), half_h + 160 + y_offset:GetValue(), "" .. aa_base_rot)
		end
	end
end)



callbacks.Register("Draw", function()
	if activateAll:GetValue() then
		gui.SetValue("esp.indicatortab.autofire.ind", true)
		gui.SetValue("esp.indicatortab.fov.ind", true)
		gui.SetValue("esp.indicatortab.hc.ind", true)
		gui.SetValue("esp.indicatortab.mindmg.ind", true)
		gui.SetValue("esp.indicatortab.backtrack.ind", true)
		gui.SetValue("esp.indicatortab.quickpeek.ind", true)
		gui.SetValue("esp.indicatortab.antiaim.ind", true)
	else
		return
	end
end)

--***********************************************--
-- Info about success or failure of loading the script
--***********************************************--

print("♥♥♥ " .. GetScriptName() .. " loaded without Errors ♥♥♥")
