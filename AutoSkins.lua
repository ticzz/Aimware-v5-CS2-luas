--[[This Lua script automatically enables or disables skins in CS2.
    Activated by using the "autoskins" checkbox, the script will disable skins
    when a match ends and enable skins again when the first round of a new match starts.
    This should fix the crashes of Aimware caused by the Skinchanger on new map load. ;P]]

local ref = gui.Reference("Visuals", "Skins (Beta)")
local group = gui.Groupbox(ref, "AutoDisable/-Enable Skins", 16, 400, 325, 80)
local autoskinsCheckbox = gui.Checkbox(group, "auto.skins.enable", "", true)
gui.Text(group, "Created by ticzz | aka KriZz87")
gui.Text(group, "https://github.com/ticzz/Aimware-v5-CS2-luas")

-- Only register the event listeners once
local registeredListeners = false
local function disableSkins()
	gui.SetValue("esp.skins.enabled", false)
end

local function enableSkins()
	gui.SetValue("esp.skins.enabled", true)
end

local function handleMatchStart()
	disableSkins()
end

local function handleRoundStart()
	enableSkins()
end

local function handleGameEvent(event)
	if not registeredListeners then
		client.AllowListener("begin_new_match")
		client.AllowListener("round_announce_match_start")
		client.AllowListener("cs_win_panel_match")
		registeredListeners = true
	end

	local autoskinsEnabled = autoskinsCheckbox:GetValue()
	if autoskinsEnabled then
		if event:GetName() == "round_announce_match_start" then
			handleRoundStart()
		elseif event:GetName() == "cs_win_panel_match" then
			handleMatchStart()
		end
	end
end

callbacks.Register("FireGameEvent", handleGameEvent)

callbacks.Register("Unload", function()
	UnloadScript(GetScriptName())
end)

print("♥♥♥ " .. GetScriptName() .. " loaded without Errors ♥♥♥♥♥♥")
