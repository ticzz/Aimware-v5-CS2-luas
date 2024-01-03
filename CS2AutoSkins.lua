-- CS2AutoSkins.lua - Lua code for automatically enabling/disabling skins in Aimware based on server and player status

-- Define myRequire function to load modules
local loadedModules = {}
local function myRequire(moduleName)
	-- Check if module is already loaded
	local module = loadedModules[moduleName]
	if module then
		return module
	end

	-- Execute the module file
	local success, executeError = pcall(loadstring(moduleName .. ".lua"))
	if success then
		loadedModules[moduleName] = moduleFunc()
		return loadedModules[moduleName]
	else
		print(executeError)
	end
end

-- Define function to handle errors
local function logError(error)
	print(string.format("[GetScriptName() %s] %s: ", tostring(error)))
	print("Error: " .. err)
	local logFile, fileError = file.Open("error.txt", "a")
	if logFile then
		logFile:Write(err .. "\n")
		logFile:Close()
	else
		error(fileError)
	end
end
local ffi_output_game_console = loadstring(file.Read("libraries/ffi_output_game_console.lua"))()
-- Load the module
local ok, result = pcall(function()
	return myRequire("libraries/ffi_output_game_console")
end)
if not ok then
	logError("Bad results")
	return
end

-- Define function to output text to the console
local function outputConsoleText(text)
	if ffi_output_game_console then
		ffi_output_game_console.console_printf(255, 0, 0, "aimware: \0")
		ffi_output_game_console.console_printf(255, 255, 255, text)
	end
end

outputConsoleText("Hello")

--[[]
-- Load different 2nd module
local ok, result = pcall(function()
	return myRequire("libraries/isInGameIsConnectedGetMapName")
end)
if not ok then
	logError(result)
	return
end
local isInGameIsConnectedMapName = result
--]]

-- Create GUI elements
local visualsGroup = gui.Reference("Visuals", "Skins (Beta)")
local group = gui.Groupbox(visualsGroup, "AutoDis-ReenableSkins", 16, 380, 325, 80)
local autoskinchangerswitch = gui.Checkbox(group, "auto.skinchanger.switch", "", false)
gui.Text(group, "Erstellt von ticzz | aka KriZz87")
gui.Text(group, "https://github.com/ticzz/Aimware-v5-CS2-luas")

-- Get local player info
local localPlayer = entities.GetLocalPlayer()
local localPlayerIndex = client.GetLocalPlayerIndex()
local localPlayerName = localPlayerIndex and client.GetPlayerNameByIndex(localPlayerIndex)

-- Get script info
local scriptName = GetScriptName()

-- Get server IP
local serverip = engine.GetServerIP()

-- Define function to handle autoskins value change
local function handleAutoskinsValueChanged()
	if not autoskinchangerswitch then
		return
	end
	if localPlayer and serverip and localPlayer:IsAlive() then
		state = true
		outputConsoleText("Ist es ein Flugzeug oder ein Komet? Nein, es ist " .. (localPlayerName or ""))
	else
		state = false
		outputConsoleText("Niemand ist hier anscheinend")
	end
	gui.SetValue("esp.skins.enabled", state)
end

-- Register callback and print success message
callbacks.Register("Draw", handleAutoskinsValueChanged)

print("♥♥♥ " .. scriptName .. " loaded without Errors ♥♥♥")
