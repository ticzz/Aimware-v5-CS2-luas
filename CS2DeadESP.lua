--Inspired by zack´s [https://aimware.net/forum/user-36169.html] "always esp on dead.lua"
-- Main usage is for Legit Gameplay
-- Enable extra ESP visuals for dead players to help teammates
-- Disable most extras for alive players to hide cheats
-- Allow briefly enabling extras while alive via a toggle hotkey

-- Menu creation
local x, y = draw.GetScreenSize()
local vis_ref = gui.Reference("VISUALS")
local esp_tab = gui.Tab(vis_ref, "deadesp.tab", "DeadESP")
local espGroup = gui.Groupbox(esp_tab, "DeadESP", 10, 10, 300, 0)

-- Configurable options
local enableMaster = gui.Checkbox(espGroup, "enablemaster", "Enable DeadESP", false)
local keyMode = gui.Combobox(espGroup, "espkeymode", "keyMode", "Hold", "Toggle")
local holdKey = gui.Keybox(espGroup, "espkey", "ESP Key", 0)
local chamsOptions = gui.Combobox(espGroup, "chamsOptions", "Type of Chams", "Off", "Flat")
local indicators_clr = gui.ColorPicker(espGroup, "indicator.color", "WH Indicator Color", 0, 0, 0, 255)
local xposi = gui.Slider(espGroup, "deadesp_xposi", "X Position", 15, 0, x)
local yposi = gui.Slider(espGroup, "deadesp_yposi", "Y Position", y / 2, 0, y)

-- Option Tips
gui.Text(espGroup, "Created by ticzz | aka KriZz87")
gui.Text(espGroup, "https://github.com/ticzz/Aimware-v5-CS2-luas")
holdKey:SetDescription("Key to turn on Chams thru Wallz while alive")
chamsOptions:SetDescription("Chams used for onKey Wallhack and while dead")
xposi:SetDescription("Sets position X  for the Indicator")
yposi:SetDescription("Sets position Y for the Indicator")
local color = draw.Color
local text = draw.TextShadow
local font = draw.CreateFont("Verdana", 13, 800)

-- Internal state
local isAlive = false
local toggle = false

-- Enable extra ESP visuals when dead
local function EnableExtraESP()
	-- Force enable enemy chams behind walls
	gui.SetValue("esp.chams.enemy.occluded", 1)
	-- Enable other extras
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

-- Disable most extras when alive
local function DisableExtraESP()
	-- Restore visible chams only
	gui.SetValue("esp.chams.enemy.visible", chamsOptions:GetValue())
	-- Disable other extras
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

-- Enable OnHold extra ESP visuals by onHold-/Togglekey
local function OnHoldExtraESP()
	gui.SetValue("esp.chams.enemy.occluded", 1)
end

-- Main logic
local function UpdateESPForState()
	draw.SetFont(font)

	-- Exit if not enabled
	local lp = entities.GetLocalPlayer()
	if not lp or not enableMaster:GetValue() then
		return
	end

	-- Set ESP based on alive/dead state
	if isAlive then
		-- Alive logic - reduce ESP
		DisableExtraESP()

		-- Allow brief ESP on hold key
		if holdKey:GetValue() ~= 0 and keyMode:GetValue() == 0 then
			if input.IsButtonDown(holdKey:GetValue()) then
				OnHoldExtraESP()
				color(indicators_clr:GetValue())
				text(xposi:GetValue(), yposi:GetValue(), "OnHold Chams")
			else
				DisableExtraESP()
			end
		elseif holdKey:GetValue() ~= 0 and keyMode:GetValue() == 1 then
			if input.IsButtonPressed(holdKey:GetValue()) then
				if not toggle then
					toggle = true
				else
					toggle = false
				end
			elseif toggle then
				OnHoldExtraESP()
				color(indicators_clr:GetValue())
				text(xposi:GetValue(), yposi:GetValue(), "WH Chams On")
			else
				DisableExtraESP()
			end
		end
	else
		-- Dead logic - enable extras
		EnableExtraESP()
	end
end

-- Main loop
local function OnDraw()
	if not entities.GetLocalPlayer() then
		return
	end
	-- Get current player state
	isAlive = entities.GetLocalPlayer():IsAlive()

	-- Update ESP based on state
	UpdateESPForState()
end

-- Register callbacks
callbacks.Register("Draw", OnDraw)

--***********************************************--
print("♥♥♥ " .. GetScriptName() .. " loaded without Errors ♥♥♥")
