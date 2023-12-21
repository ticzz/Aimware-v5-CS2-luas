--Inspired by zack´s [https://aimware.net/forum/user-36169.html] "always esp on dead.lua"
-- Main usage is for Legit Gameplay
-- Enable extra ESP visuals for dead players to help teammates
-- Disable most extras for alive players to hide cheats
-- Allow briefly enabling extras while alive via a toggle hotkey

-- Config table
local config = {
	enabled = false,
	keyMode = "Hold",
	holdKey = 0,
	chams = "Off",
	indicatorColor = { 255, 255, 255, 255 },
	indicatorPos = { x = 100, y = 100 },
}

-- Constants
local font = draw.CreateFont("Arial", 12, 100)
local screenSizeX, screenSizeY = draw.GetScreenSize()

-- Menu references
local menuTab, menuGroup
local guiElements = {}

-- Create menu
local function createMenu()
	-- Validate menu doesn't exist already
	if menuTab then
		return
	end
	-- Menu tab
	menuTab = gui.Tab(gui.Reference("VISUALS"), "deadesp.tab", "DeadESP")

	-- Menu group
	menuGroup = gui.Groupbox(menuTab, "DeadESP", 10, 10, 300, 0)

	-- Config elements
	guiElements.enabled = gui.Checkbox(menuGroup, "enabled", "Enable DeadESP", config.enabled)
	guiElements.keyMode = gui.Combobox(menuGroup, "keymode", "Key Mode", "Hold", "Toggle")
	guiElements.holdKey = gui.Keybox(menuGroup, "holdkey", "ESP Key", config.holdKey)
	guiElements.chams = gui.Combobox(menuGroup, "chams", "Chams Type", "Off", "Flat", config.chams)
	guiElements.indicatorColor =
		gui.ColorPicker(menuGroup, "indicatorColor", "Indicator Color", unpack(config.indicatorColor))
	guiElements.indicatorPosX =
		gui.Slider(menuGroup, "indicatorPosX", "Indicator X", config.indicatorPos.x, 0, screenSizeX)
	guiElements.indicatorPosY =
		gui.Slider(menuGroup, "indicatorPosY", "Indicator Y", config.indicatorPos.y, 0, screenSizeY)
end

-- Update config from menu
local function updateConfig()
	-- Add print to debug
	print("Config at start of updateConfig:", config)
	config.enabled = guiElements.enabled:GetValue()
	config.keyMode = guiElements.keyMode:GetValue()
	config.holdKey = guiElements.holdKey:GetValue()
	config.chams = guiElements.chams:GetValue()
	config.indicatorColor = guiElements.indicatorColor:GetValue()
	config.indicatorPos.x = guiElements.indicatorPosX:GetValue()
	config.indicatorPos.y = guiElements.indicatorPosY:GetValue()
	-- Print again
	print("Config at end of updateConfig:", config)
end

-- Draw indicator text
local function drawIndicator(text)
	if config.enabled then
		draw.SetFont(font)
		draw.Color(config.indicatorColor)
		draw.TextShadow(config.indicatorPos.x, config.indicatorPos.y, text)
	end
end

-- Disable extra ESP when alive
local function disableExtraESP()
	-- Only enable visible chams
	gui.SetValue("esp.chams.enemy.visible", config.chams:GetValue())

	-- Disable other extras
	gui.SetValue("esp.chams.enemy.occluded", 0)
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
end

-- Enable extra ESP features when dead
local function enableExtraESP()
	-- Force enable enemy chams
	gui.SetValue("esp.chams.enemy.occluded", 1)

	-- Enable other ESP options
	gui.SetValue("esp.chams.enemy.visible", config.chams:GetValue())
	gui.SetValue("esp.overlay.enemy.box", false)
	gui.SetValue("esp.overlay.enemy.flags.hasdefuser", true)
	gui.SetValue("esp.overlay.enemy.flags.hasc4", true)
	gui.SetValue("esp.overlay.enemy.flags.reloading", false)
	gui.SetValue("esp.overlay.enemy.flags.scoped", false)
	gui.SetValue("esp.overlay.enemy.health.healthnum", true)
	gui.SetValue("esp.overlay.enemy.health.healthbar", true)
	gui.SetValue("esp.overlay.enemy.name", true)
	gui.SetValue("esp.overlay.enemy.weapon", true)
	gui.SetValue("esp.overlay.weapon.ammo", true)
	gui.SetValue("esp.overlay.enemy.barrel", false)
	gui.SetValue("esp.overlay.enemy.armor", true)
end

local function OnHoldExtraESP()
	gui.SetValue("esp.chams.enemy.occluded", 1)
end

-- Internal State
local isESPActive = false
local wasPlayerAlive = true
local isToggled = false

-- Main logic
local function onDraw()
	-- Wrap everything in pcall
	local status, err = pcall(function()
		-- Get player state
		-- Validate
		if not entities.GetLocalPlayer() then
			return
		end

		if not config.enabled then
			return
		end

		-- Update config from menu
		updateConfig()

		-- Update ESP based on state
		if isAlive ~= wasPlayerAlive then
			wasPlayerAlive = isAlive
			isESPActive = false
		end

		if not isAlive then
			-- Dead logic
			enableExtraESP()
		else
			-- Alive logic
			disableExtraESP()
			isESPActive = false
			-- Allow brief ESP on hold key
			local keyMode = config.keyMode:GetValue()
			local holdKey = config.holdKey:GetValue()
			local holdKeyDown = input.IsButtonDown(holdKey)
			local holdKeyToggled = input.IsButtonPressed(holdKey)
			if keyMode == 0 and holdKeyDown then
				-- Hold mode
				OnHoldExtraESP()
				isESPActive = true
				if isESPActive then
					drawIndicator("OnHold")
				end
			elseif keyMode == 1 and holdKeyToggled then
				-- Toggle mode
				isToggled = not isToggled
				if isToggled then
					OnHoldExtraESP()
					isESPActive = true
				else
					disableExtraESP()
				end
			end
		end
		-- Draw indicator if active
		if isESPActive then
			drawIndicator(keyMode == 1 and "Enabled" or "OnHold")
		end
	end)

	-- Handle errors
	if not status then
		logFile = file.Open("error.txt", "a")
		logFile:Write(err .. "\n")
		logFile:Close()
		return
	end
end

-- Initialize
createMenu()

-- Register callback
callbacks.Register("Draw", onDraw)

-- Cleanup on unload
callbacks.Register("Unload", function()
	-- Close log file
	if logFile then
		logFile:Close()
	end
	-- Clean up menu tabs
	if menuTab then
		menuTab:Remove()
	end
	-- Clean up menu references
	if menuGroup then
		menuGroup:Remove()
	end
end)

--***********************************************--
print("♥♥♥ " .. GetScriptName() .. " loaded without Errors ♥♥♥")
