--Inspired by zack´s [https://aimware.net/forum/user-36169.html] "always esp on dead.lua" [https://aimware.net/forum/thread/86414]

--Main usage is for Legit Gameplay

--Turns Visuals on when dead 		(to get infos for teammates (but attention is recommended because as a legit player you shouldnt know toooo much ;P ))
--Turns Visuals off when alive 		(exept the Visuals for Chams of visible Enemys will stay on)
--Turns Visuals on per OnHold	 	(when alive but you need/want some extra infos for easier clutches. Then just tap your wh_key from time to time :D )

-- DeadESP (This version only works with the default Chams provided by Aimware.net atm)

local x, y = draw.GetScreenSize()
local visual_refs = gui.Reference("VISUALS")
local deadesp_tab = gui.Tab(visual_refs, "deadesp.tab", "DeadESP")
local deadesp_group = gui.Groupbox(deadesp_tab, "DeadESP")
local deadesp_master = gui.Checkbox(deadesp_group, "deadesp_master", "DeadESP Master", 0)
local hold_or_toggle = gui.Combobox(deadesp_group, "deadesp_hold_or_toggle", "DeadESP Hold or Toggle", "Hold", "Toggle")
local deadesp_wallhack_key = gui.Keybox(deadesp_group, "deadesp_wallhackkey", "DeadESP Holdkey", false) -- Box to set a hold-key to enable enemy.occluded chams aka Wallhack
local deadesp_chams_on_tggl =
	gui.Combobox(deadesp_group, "deadesp_chams.ontggl", "DeadESP Chams on hold", "Off", "Flat") --, "Color", "Metallic", "Glow" ) -- Change WallhackChams Mode onthefly
local deadesp_chams_while_spec =
	gui.Combobox(deadesp_group, "deadesp_chams.while.spec", "DeadESP Chams while Spectating", "Off", "Flat") --, "Color", "Metallic", "Glow" ) -- Change WallhackChams Mode onthefly
local wh_chams_indicators_clr =
	gui.ColorPicker(deadesp_group, "deadesp_indicator.color", "WH ChamsActive Text Color", 0, 0, 0, 255)
local xposi = gui.Slider(deadesp_group, "deadesp_xposi", "X Position", 15, 0, x)
local yposi = gui.Slider(deadesp_group, "deadesp_yposi", "Y Position", y / 2, 0, y)
deadesp_wallhack_key:SetDescription("Turn on Chams thru Wallz while alive")
deadesp_wallhack_key:SetDescription("")
deadesp_chams_on_tggl:SetDescription("Chams used for OnHold Wallhack")
deadesp_chams_while_spec:SetDescription("Chams used for Wallhack when spectaiting")
xposi:SetDescription("Sets X Screenposition for the Indicator")
yposi:SetDescription("Sets Y Screenposition for the Indicator")
gui.Text(deadesp_group, "Created by ticzz | aka KriZz87")
gui.Text(deadesp_group, "https://github.com/ticzz/Aimware-v5-luas/blob/master/DeadESP.lua")
local color = draw.Color
local text = draw.TextShadow
local font = draw.CreateFont("Arial", 14, 100)
local toggle = false

callbacks.Register("Draw", "DeadESP", function()
	draw.SetFont(font)

	local player = entities.GetLocalPlayer()

	if not player or not deadesp_master or not deadesp_wallhack_key:GetValue() then
		return
	end

	local cache_default_type_of_vis_chams = gui.GetValue("esp.chams.enemy.visible")

	if hold_or_toggle == "0" then
		--- Alive, holding down the wh-key
		if
			player:IsAlive() == true
			and (deadesp_wallhack_key:GetValue() ~= nil or false)
			and input.IsButtonDown(deadesp_wallhack_key:GetValue())
		then
			gui.SetValue("esp.chams.enemy.occluded", deadesp_chams_on_tggl:GetValue())
			color(wh_chams_indicators_clr:GetValue())
			text(xposi:GetValue(), yposi:GetValue(), "OnHold Chams")

		--- Alive, onHoldkey unpressed
		elseif
			player:IsAlive() == true
			and (deadesp_wallhack_key:GetValue() ~= nil or false)
			and not input.IsButtonDown(deadesp_wallhack_key:GetValue())
		then
			gui.SetValue("esp.chams.enemy.occluded", off)
			gui.SetValue("esp.chams.enemy.visible", cache_default_type_of_vis_chams)
			--gui.SetValue("esp.chams.enemy.overlay", off)
			gui.SetValue("esp.chams.enemyattachments.occluded", off)
			gui.SetValue("esp.chams.enemyattachments.visible", off)
			--gui.SetValue("esp.chams.enemyattachments.overlay", off)
			gui.SetValue("esp.chams.friendlyattachments.occluded", off)
			gui.SetValue("esp.chams.friendlyattachments.visible", off)
			--gui.SetValue("esp.chams.friendlyattachments.overlay", off)
			gui.SetValue("esp.overlay.enemy.box", false)
			gui.SetValue("esp.overlay.enemy.flags.hasdefuser", false)
			gui.SetValue("esp.overlay.enemy.flags.hasc4", false)
			gui.SetValue("esp.overlay.enemy.flags.reloading", false)
			gui.SetValue("esp.overlay.enemy.flags.scoped", false)
			gui.SetValue("esp.overlay.enemy.health.healthnum", false)
			gui.SetValue("esp.overlay.enemy.health.healthbar", false)
			gui.SetValue("esp.overlay.enemy.name", false)
			gui.SetValue("esp.overlay.enemy.weapon", false)
			gui.SetValue("esp.overlay.weapon.ammo", false)
			gui.SetValue("esp.overlay.enemy.barrel", false)
			gui.SetValue("esp.overlay.enemy.armor", false)

		-- Dead and spectating
		elseif player:IsAlive() == false then
			gui.SetValue("esp.chams.enemy.occluded", deadesp_chams_while_spec)
			gui.SetValue("esp.chams.enemy.visible", "2")
			--gui.SetValue("esp.chams.enemy.overlay", "1")
			gui.SetValue("esp.chams.enemyattachments.occluded", off)
			gui.SetValue("esp.chams.enemyattachments.visible", off)
			--gui.SetValue("esp.chams.enemyattachments.overlay", off)
			gui.SetValue("esp.chams.friendlyattachments.occluded", off)
			gui.SetValue("esp.chams.friendlyattachments.visible", off)
			--gui.SetValue("esp.chams.friendlyattachments.overlay", off)
			gui.SetValue("esp.overlay.enemy.box", false)
			gui.SetValue("esp.overlay.enemy.flags.hasdefuser", true)
			gui.SetValue("esp.overlay.enemy.flags.hasc4", true)
			gui.SetValue("esp.overlay.enemy.flags.reloading", false)
			gui.SetValue("esp.overlay.enemy.flags.scoped", false)
			gui.SetValue("esp.overlay.enemy.health.healthnum", "1")
			gui.SetValue("esp.overlay.enemy.health.healthbar", false)
			gui.SetValue("esp.overlay.enemy.name", true)
			gui.SetValue("esp.overlay.enemy.weapon", "1")
			gui.SetValue("esp.overlay.weapon.ammo", true)
			gui.SetValue("esp.overlay.enemy.barrel", false)
			gui.SetValue("esp.overlay.enemy.armor", "1")
		end
	elseif hold_or_toggle == "1" then
		if input.IsButtonPressed(deadesp_wallhack_key:GetValue()) then
			toggle = not toggle
		end

		--- Alive, toggle on
		if player:IsAlive() == true and (deadesp_wallhack_key:GetValue() ~= nil or false) and toggle then
			gui.SetValue("esp.chams.enemy.occluded", deadesp_chams_on_tggl:GetValue())
			color(wh_chams_indicators_clr:GetValue())
			text(xposi:GetValue(), yposi:GetValue(), "WH Chams On")

			--- Alive, Toggle off
		elseif player:IsAlive() == true and (deadesp_wallhack_key:GetValue() ~= nil or false) and not toggle then
			gui.SetValue("esp.chams.enemy.occluded", off)
			gui.SetValue("esp.chams.enemy.visible", cache_default_type_of_vis_chams)
			--gui.SetValue("esp.chams.enemy.overlay", off)
			gui.SetValue("esp.chams.enemyattachments.occluded", off)
			gui.SetValue("esp.chams.enemyattachments.visible", off)
			--gui.SetValue("esp.chams.enemyattachments.overlay", off)
			gui.SetValue("esp.chams.friendlyattachments.occluded", off)
			gui.SetValue("esp.chams.friendlyattachments.visible", off)
			--gui.SetValue("esp.chams.friendlyattachments.overlay", off)
			gui.SetValue("esp.overlay.enemy.box", false)
			gui.SetValue("esp.overlay.enemy.flags.hasdefuser", false)
			gui.SetValue("esp.overlay.enemy.flags.hasc4", false)
			gui.SetValue("esp.overlay.enemy.flags.reloading", false)
			gui.SetValue("esp.overlay.enemy.flags.scoped", false)
			gui.SetValue("esp.overlay.enemy.health.healthnum", false)
			gui.SetValue("esp.overlay.enemy.health.healthbar", false)
			gui.SetValue("esp.overlay.enemy.name", false)
			gui.SetValue("esp.overlay.enemy.weapon", false)
			gui.SetValue("esp.overlay.weapon.ammo", false)
			gui.SetValue("esp.overlay.enemy.barrel", false)
			gui.SetValue("esp.overlay.enemy.armor", false)

		-- dead and spectating someone
		elseif player:IsAlive() == false then
			gui.SetValue("esp.chams.enemy.occluded", deadesp_chams_while_spec)
			gui.SetValue("esp.chams.enemy.visible", "2")
			--gui.SetValue("esp.chams.enemy.overlay", "1")
			gui.SetValue("esp.chams.enemyattachments.occluded", off)
			gui.SetValue("esp.chams.enemyattachments.visible", off)
			--gui.SetValue("esp.chams.enemyattachments.overlay", off)
			gui.SetValue("esp.chams.friendlyattachments.occluded", off)
			gui.SetValue("esp.chams.friendlyattachments.visible", off)
			--gui.SetValue("esp.chams.friendlyattachments.overlay", off)
			gui.SetValue("esp.overlay.enemy.box", false)
			gui.SetValue("esp.overlay.enemy.flags.hasdefuser", true)
			gui.SetValue("esp.overlay.enemy.flags.hasc4", true)
			gui.SetValue("esp.overlay.enemy.flags.reloading", false)
			gui.SetValue("esp.overlay.enemy.flags.scoped", false)
			gui.SetValue("esp.overlay.enemy.health.healthnum", "1")
			gui.SetValue("esp.overlay.enemy.health.healthbar", false)
			gui.SetValue("esp.overlay.enemy.name", true)
			gui.SetValue("esp.overlay.enemy.weapon", "1")
			gui.SetValue("esp.overlay.weapon.ammo", true)
			gui.SetValue("esp.overlay.enemy.barrel", false)
			gui.SetValue("esp.overlay.enemy.armor", "1")
		end
	end
end)

--***********************************************--

print("♥♥♥ " .. GetScriptName() .. " loaded without Errors ♥♥♥")
