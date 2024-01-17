--[[Inspired by zack┬┤s [https://aimware.net/forum/user-36169.html] "always esp on dead.lua"
-- Main usage is for Legit Gameplay
-- Enable extra ESP visuals for dead players to help teammates
-- Disable most extras for alive players to hide cheats
-- Allow briefly enabling extras while alive via a toggle hotkey

]]

-- Config table
local config = {
	enabled = false,
	keyMode = 0,
	holdKey = 0,
	chams = "Off",
	indicatorColor = { 255, 255, 255, 255 },
	indicatorPos = { x = 100, y = 100 },

	variablestoUse = {
		"esp.chams.enemy.occluded",
		"esp.overlay.enemy.box",
		"esp.overlay.enemy.name",
		"esp.overlay.enemy.health.healthbar",
		"esp.overlay.enemy.health.healthnum",
		"esp.overlay.enemy.weapon",
		"esp.overlay.weapon.ammo",
		"esp.overlay.enemy.flags.hasc4",
		"esp.overlay.enemy.flags.hasdefuser",
		"esp.overlay.enemy.flags.reloading",
		"esp.overlay.enemy.flags.scoped",
		"esp.overlay.enemy.armor",
	},
}

-- Constants
local font = draw.CreateFont("Arial", 12, 100)
local screenSizeX, screenSizeY = draw.GetScreenSize()

-- Menu references
local menuTab, menuGroup
local guiElements = {}

-- Create menu
local function createMenu()
	-- Menu tab
	menuTab = gui.Tab(gui.Reference("VISUALS"), "deadesp.tab", "DeadESP")

	-- Menu group
	menuGroup = gui.Groupbox(menuTab, "DeadESP", 10, 10, 300, 0)

	-- Config elements
	guiElements.enabled = gui.Checkbox(menuGroup, "enabled", "Enable DeadESP", config.enabled)
	guiElements.keyMode = gui.Combobox(menuGroup, "keymode", "Key Mode", "Hold", "Toggle", config.keyMode)
	guiElements.holdKey = gui.Keybox(menuGroup, "holdkey", "ESP Key", config.holdKey)
	guiElements.chams = gui.Combobox(menuGroup, "chams", "Chams Type", "Off", "Flat", config.chams)
	guiElements.espoptionstoUse =
		gui.Multibox(menuGroup, "espoptionstoUse", "Enabled ESP", unpack(config.variablestoUse))
	guiElements.indicatorColor =
		gui.ColorPicker(menuGroup, "indicatorColor", "Indicator Color", unpack(config.indicatorColor))
	guiElements.indicatorPosX =
		gui.Slider(menuGroup, "indicatorPosX", "Indicator X", config.indicatorPos.x, 0, screenSizeX)
	guiElements.indicatorPosY =
		gui.Slider(menuGroup, "indicatorPosY", "Indicator Y", config.indicatorPos.y, 0, screenSizeY)

	guiElements = {
		enemy_chams = gui.Checkbox(menuGroup, "enemy_chams", "EnemyChams visible", false),
		enemy_box = gui.Checkbox(menuGroup, "enemy_box", "Box", false),
		enemy_name = gui.Checkbox(menuGroup, "enemy_name", "Name", false),
		enemy_healthbar = gui.Checkbox(menuGroup, "enemy_healthbar", "Healthbar", false),
		enemy_healthnum = gui.Checkbox(menuGroup, "enemy_healthnum", "Healthnumber", false),
		enemy_weapon = gui.Checkbox(menuGroup, "enemy_weapon", "Weapon", false),
		enemy_ammo = gui.Checkbox(menuGroup, "enemy_ammo", "Ammo", false),
		enemy_hasc4 = gui.Checkbox(menuGroup, "enemy_hasc4", "HasC4", false),
		enemy_hasdefuser = gui.Checkbox(menuGroup, "enemy_hasdefuser", "HasDefuser", false),
		enemy_reload = gui.Checkbox(menuGroup, "enemy_reload", "Reloading", false),
		enemy_scoped = gui.Checkbox(menuGroup, "enemy_scoped", "Scoped", false),
		enemy_armor = gui.Checkbox(menuGroup, "enemy_armor", "Armor", false),
	}
end

createMenu()

-- Update config from menu
local function updateConfig()
	-- Add print to debug
	--print("Config at start of updateConfig:", config)
	if guiElements.enabled:GetValue() ~= config.enabled then
		config.enabled = guiElements.enabled:GetValue()
	end
	if guiElements.keyMode:GetValue() ~= config.keyMode then
		config.keyMode = guiElements.keyMode:GetValue()
	end
	if guiElements.holdKey:GetValue() ~= config.holdKey then
		config.holdKey = guiElements.holdKey:GetValue()
	end
	if guiElements.chams:GetValue() ~= config.chams then
		config.chams = guiElements.chams:GetValue()
	end
	if guiElements.indicatorColor:GetValue() ~= config.indicatorColor then
		config.indicatorColor = guiElements.indicatorColor:GetValue()
	end
	if guiElements.indicatorPos.x:GetValue() ~= config.indicatorPos.x then
		config.indicatorPos.x = guiElements.indicatorPosX:GetValue()
	end
	if guiElements.indicatorPos.y:GetValue() ~= config.indicatorPos.y then
		config.indicatorPos.y = guiElements.indicatorPosY:GetValue()
	end
	if guiElements.espoptionstoUse:GetValue() ~= config.variablestoUse then
		config.variablestoUse = {}
		for i, option in ipairs(guiElements.espoptionstoUse) do
			config.variablestoUse[i] = option:GetValue()
		end
	end
	-- Print again
	--print("Config at end of updateConfig:", config)
end

-- Draw indicator text
local function drawIndicator(text)
	if config.enabled then
		draw.SetFont(font)
		draw.Color(unpack(config.indicatorColor))
		draw.TextShadow(config.indicatorPos.x, config.indicatorPos.y, text)
	end
end

-- Disable extra ESP when alive
local function disableExtraESP()
	-- Only enable visible chams
	gui.SetValue("esp.chams.enemy.visible", config.chams:GetValue())

	-- Disable enemy occluded chams
	gui.SetValue("esp.chams.enemy.occluded", 0)

	-- Disable options enabled by enableExtraESP
	for i = 1, #espoptionstoUse[i] do
		local option = espoptionstoUse[i]:GetValue()
		if espoptionstoUse[i]:GetValue(option) then
			gui.SetValue(option, false)
		end
	end
end

local function enableExtraESP()
	-- Force enable enemy chams
	gui.SetValue("esp.chams.enemy.occluded", 1)

	-- Enable options selected in enabledEspOptions
	for i = 1, #espoptionstoUse[i] do
		local option = espoptionstoUse[i]:GetValue()
		if espoptionstoUse[i]:GetValue(option) then
			gui.SetValue(option, true)
		end
	end
end

local function OnHoldExtraESP()
	gui.SetValue("esp.chams.enemy.occluded", 1)
end

-- Internal State
local isESPActive = false
local wasPlayerAlive = false
local isToggled = false
local isAlive = entities.GetLocalPlayer():IsAlive()
-- Main logic
local function onDraw()
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
				if isESPActive then
					drawIndicator("Enabled")
				end
			else
				disableExtraESP()
			end
		end
	end
	-- Draw indicator if active
	if isESPActive then
		drawIndicator("Enabled")
	end
end

callbacks.Register("Draw", onDraw)

-- Cleanup on unload
callbacks.Register("Unload", function()
	-- Close log file
	--[[if logFile then
		logFile:Close()
	end]]
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
print("" .. GetScriptName() .. " loaded without Errors")
