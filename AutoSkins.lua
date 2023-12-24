local group = gui.Groupbox(gui.Reference("Visuals", "Skins (Beta)"),"AutoDis-ReenableSkins																								Enable Autoskins", 16, 380, 325, 80)
local autoskinsCheckbox = gui.Checkbox(group, "auto.skins.enable", "", true)
gui.Text(group, "Created by ticzz | aka KriZz87")
gui.Text(group, "https://github.com/ticzz/Aimware-v5-CS2-luas")
local localPlayer = entities.GetLocalPlayer()
local mapname = engine.GetMapName()
local maploadfinished = mapname and localPlayer:isAlive()

local function nomaploaded()
	gui.SetValue("esp.skins.enabled", false)
end

local function maploaded()
	gui.SetValue("esp.skins.enabled", true)
end

local function handleGameStateDetection()
	if not localPlayer then
		return
	end
	if autoskinsCheckbox then
		if not maploadfinished then
			
			nomaploaded()
		else
			
			maploaded()
		end
	end
end

callbacks.Register("Draw", handleGameStateDetection)

callbacks.Register("Unload", function()
	if group:GetValue() then
		group:Remove()
	end
	UnloadScript(GetScriptName())
end)

print("♥♥♥ " .. GetScriptName() .. " loaded without Errors ♥♥♥")
