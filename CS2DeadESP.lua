--[[
DeadESP Script for Aimware
Author: ticzz | aka KriZz87
GitHub: https://github.com/ticzz/Aimware-v5-CS2-luas

Description:
This script enables extra ESP visuals for dead players to help teammates,
while disabling most extras for alive players to hide cheats.
It also allows briefly enabling extras while alive via a toggle hotkey.

Inspired by zack's [https://aimware.net/forum/user-36169.html] "always esp on dead.lua"
]]

local esp_tab = gui.Tab(gui.Reference("VISUALS"), "deadesp.tab", "DeadESP")
local gui_group = gui.Groupbox(esp_tab, "DeadESP", 10, 10, 300, 0)

local enabled = gui.Checkbox(gui_group, "enable", "Enable DeadESP", false)
local key_mode = gui.Combobox(gui_group, "keymode", "Key Mode", "Hold", "Toggle")
local toggle_key = gui.Keybox(gui_group, "togglekey", "Toggle Key", 0)
local chams_type = gui.Combobox(gui_group, "chamsTypes", "Chams Type", "Off", "Flat")
local indicator_color = gui.ColorPicker(gui_group, "indicator.color", "Indicator Color", 0, 0, 0, 255)
local indicator_x = gui.Slider(gui_group, "Indicator X Position", 15, 0, draw.GetScreenSize())
local indicator_y = gui.Slider(gui_group, "Indicator Y Position", draw.GetScreenSize() / 2, 0, draw.GetScreenSize())

gui.Text(gui_group, "Created by ticzz | aka KriZz87")
gui.Text(gui_group, "https://github.com/ticzz/Aimware-v5-CS2-luas")
key_mode:SetDescription(key_mode, "Switch between onhold key and perm toggle key modes")
toggle_key:SetDescription(toggle_key, "Key to turn on Chams through walls while alive")
chams_type:SetDescription(chams_type, "Chams used for on-key wallhack and while dead")
indicator_color:SetDescription(indicator_color, "Sets the color of the indicator")
indicator_x:SetDescription(indicator_x, "Sets the X position for the indicator")
indicator_y:SetDescription(indicator_y, "Sets the Y position for the indicator")

local font = draw.AddFont("Verdana", 13, 800)
local is_alive = false
local is_toggled = false

local function EnableExtraESP()
	gui.SetValue("esp.chams.enemy.occluded", 1)
	gui.SetValue("esp.chams.enemy.visible", 1)
	gui.SetValue("esp.chams.enemyattachments.occluded", 0)
	gui.SetValue("esp.chams.enemyattachments.visible", 0)
	gui.SetValue("esp.chams.friendlyattachments.occluded", 0)
	gui.SetValue("esp.chams.friendlyattachments.visible", 0)
	gui.SetValue("esp.overlay.enemy.box", false)
	gui.SetValue("esp.overlay.enemy.flags.hasdefuser", true)
	gui.SetValue("esp.overlay.enemy.flags.hasc4", true)
	gui.SetValue("esp.overlay.enemy.flags.reloading", false)
	gui.SetValue("esp.overlay.enemy.flags.scoped", false)
	gui.SetValue("esp.overlay.enemy.health.healthnum", true)
	gui.SetValue("esp.overlay.enemy.health.healthbar", true)
	gui.SetValue("esp.overlay.enemy.weapon", true)
	gui.SetValue("esp.overlay.weapon.ammo", true)
	gui.SetValue("esp.overlay.enemy.barrel", false)
	gui.SetValue("esp.overlay.enemy.armor", true)
end

local function DisableExtraESP()
	gui.SetValue("esp.chams.enemy.visible", chams_type:GetValue())
	gui.SetValue("esp.chams.enemy.occluded", 0)
	gui.SetValue("esp.chams.enemyattachments.occluded", 0)
	gui.SetValue("esp.chams.enemyattachments.visible", 0)
	gui.SetValue("esp.chams.friendlyattachments.occluded", 0)
	gui.SetValue("esp.chams.friendlyattachments.visible", 0)
	gui.SetValue("esp.overlay.enemy.box", false)
	gui.SetValue("esp.overlay.enemy.flags.hasdefuser", false)
	gui.SetValue("esp.overlay.enemy.flags.hasc4", false)
	gui.SetValue("esp.overlay.enemy.flags.reloading", false)
	gui.SetValue("esp.overlay.enemy.flags.scoped", false)
	gui.SetValue("esp.overlay.enemy.health.healthnum", false)
	gui.SetValue("esp.overlay.enemy.health.healthbar", false)
	gui.SetValue("esp.overlay.enemy.weapon", false)
	gui.SetValue("esp.overlay.weapon.ammo", false)
	gui.SetValue("esp.overlay.enemy.barrel", false)
	gui.SetValue("esp.overlay.enemy.armor", false)
end

local function EnableOnHoldESP()
	gui.SetValue("esp.chams.enemy.occluded", 1)
end

local function UpdateESP()
	draw.SetFont(font)

	local local_player = entities.GetLocalPlayer()
	if not local_player or not enabled:GetValue() then
		return
	end

	if not toggle_key:GetValue() then
		return
	end

	is_alive = local_player:IsAlive()

	if is_alive then
		DisableExtraESP()

		if key_mode:GetValue() == 0 then -- Hold mode
			if input.IsButtonDown(toggle_key:GetValue()) then
				EnableOnHoldESP()
				draw.Color(indicator_color:GetValue())
				draw.TextShadow(indicator_x:GetValue(), indicator_y:GetValue(), "OnHold Chams")
			else
				DisableExtraESP()
			end
		else -- Toggle mode
			if input.IsButtonPressed(toggle_key:GetValue()) then
				is_toggled = not is_toggled
			end

			if is_toggled then
				EnableOnHoldESP()
				draw.Color(indicator_color:GetValue())
				draw.TextShadow(indicator_x:GetValue(), indicator_y:GetValue(), "WH Chams On")
			else
				DisableExtraESP()
			end
		end
	else
		EnableExtraESP()
	end
end

callbacks.Register("Draw", UpdateESP)



--***********************************************--

local gui_name = gui.GetScriptName()
print("♥♥♥ " .. gui_name .. " loaded without errors ♥♥♥")
