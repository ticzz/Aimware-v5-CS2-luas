--[[This Lua script automatically enable or disable skins in CS2.
	Activated by using the "AutoDisable/-Enable Skins" checkbox, the script will disable skins
	when a match ends and enable skins again when first round of new match starts.
	This should fix the crashes of Aimware caused by the Skinchanger on new map load..]]

local ref = gui.Reference("Visuals", "Skins (Beta)")
local group = gui.Groupbox(ref, "AutoDisable/-Enable Skins", 16, 400, 325, 80)
local enable = gui.Checkbox(group, "auto.skins.enable", "", 1)
gui.Text(group, "Created by ticzz | aka KriZz87")
gui.Text(group, "https://github.com/ticzz/Aimware-v5-lua")

local function disable_skins()
	gui.SetValue("esp.skins.enabled", false)
end
local function enable_skins()
	gui.SetValue("esp.skins.enabled", true)
end
local function handle_cs_win_panel_match(e)
	disable_skins()
end
local function handle_round_announce_match_start(e)
	enable_skins()
end

disable_skins()

local function on_event(e)
	if not enable:GetValue() then
		return
	end
	
	gui.SetValue("esp.skins.enabled", false)

	if e:GetName() == "round_announce_match_start" then
		handle_round_announce_match_start(e)
	elseif e:GetName() == "cs_win_panel_match" then
		handle_cs_win_panel_match(e)
	end
end

client.AllowListener("round_announce_match_start")
client.AllowListener("cs_win_panel_match")
callbacks.Register("FireGameEvent", on_event)


--***********************************************--

print("♥♥♥ " .. GetScriptName() .. " loaded without Errors ♥♥♥♥♥♥")
