-- CS2AutoSkins.lua - Lua code for automatically enabling/disabling skins in Aimware based on server and player status

function requireModule(name)
	package = package or {}
	package.loaded = package.loaded or {}
	function lib_return(value)
		package.loaded[name] = value or true
	end
	if not package.loaded[name] then
		RunScript(name .. ".lua")
	end
	lib_return = nil
	return package.loaded[name] or nil
end

-- Load the module 'isInGameIsConnectedGetMapName' using the 'requireModule' function
local isInGameIsConnectedMapName = requireModule("libraries/isInGameIsConnectedGetMapName")
-- Check if the module 'isInGameIsConnectedGetMapName' has been loaded successfully
if isInGameIsConnectedMapName then
	print("The library has been loaded.")
else
	print("Failed to load the library.")
end

-- Create a groupbox and GUI elements within it using the GUI library
local visualsGroup = gui.Reference("Visuals", "Skins (Beta)")
local group = gui.Groupbox(visualsGroup, "AutoDis-ReenableSkins", 16, 380, 325, 80)
local autoskinchangerswitch = gui.Checkbox(group, "auto.skinchanger.switch", "", true)
gui.Text(group, "Erstellt von ticzz | aka KriZz87")
gui.Text(group, "https://github.com/ticzz/Aimware-v5-CS2-luas")

-- Define variables related to the local player, map, and script name
local localPlayer = entities.GetLocalPlayer()
local localPlayerIndex = client.GetLocalPlayerIndex()
local localPlayerName = localPlayerIndex and client.GetPlayerNameByIndex(localPlayerIndex)

-- Define a function to check if the player is in-game
local function isInGame()
	if not native_IsConnected() then
		return false
	end
	return native_IsInGame()
end

-- Define a function to check if the player is connected
local function isConnected()
	if not native_IsConnected() then
		return false
	end
	return native_IsConnected()
end

--Define a function to get the name of the map
local function getMapName()
	if not localPlayer:IsAlive() then
		return
	end
	if not native_GetLevelNameShort() then
		return false
	end
	return native_GetLevelNameShort() --engine.GetMapName()
end

-- This function handles the value change of the autoskinchangerswitch checkbox
local function handleAutoskinsValueChanged()
	if not autoskinchangerswitch then -- Check if Autoskins value is true
		return
	else
		--local mapname = getMapName()
		if getMapName() and isInGame() and isConnected() then -- Check if map load has finished
			state = true
			--print("Ist es ein Flugzeug oder ein Komet? Nein, es ist " .. (localPlayerName or "")) -- Display console text
		else
			state = false
			--print("Niemand ist hier anscheinend") -- Display console text
		end
		gui.SetValue("esp.skins.enabled", state) -- Update GUI value
	end
end
-- Register the 'handleAutoskinsValueChanged' function to be called every frame
callbacks.Register("Draw", handleAutoskinsValueChanged)

local function Indicator()
	if gui.GetValue("esp.skins.enabled") then
		draw.Color(255, 0, 0, 255)
		draw.TextShadow(15, 1065, "Skins enabled")
	else
		draw.Color(0, 255, 0, 255)
		draw.TextShadow(15, 1065, "Skins disabled")
	end
end

-- Register the 'Indicator' function to be called every frame
callbacks.Register("Draw", Indicator)

-- Register a callback function to be called when the script is unloaded
callbacks.Register("Unload", function()
	if group then
		group:Remove() -- Remove the GUI elements
	end
	--UnloadScript(scriptName) -- Unload the script
end)


print("♥♥♥ " .. scriptName .. " loaded without Errors ♥♥♥")
