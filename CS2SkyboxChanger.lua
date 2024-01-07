--[[ 
		Download for the skyboxes used in script				--> https://mega.nz/file/yLQxFIJC#eVdoc9Fwx_BPcJxt6vBNi0PQ0Sc9tunXesdTM_vt2tI
		
		Open Skybox.rar and drag skybox folder into		 		--> steamapps\common\Counter-Strike Global Offensive\csgo\materials\
		
		so that the final path looks like this					--> steamapps\common\Counter-Strike Global Offensive\csgo\materials\skybox\
		
		then copy the .vmt and .vtf files into the skybox folder and add them to the Script.. 
		aaaand... if u dont know how to add new boxes just look at the other examples, its very easy to understand how it works
	
		
		PS: if u want more/other skyboxes u can go to			 --> https://gamebanana.com/mods/cats/653
]]
--

local skyref = gui.Reference("Visuals", "World", "Camera")

local listbox = gui.Combobox(skyref, "skybox_list", "Skybox", options)

local skyboxes = {
	"Default",
	"amethyst",
	"dreamyocean",
	"greenscreen",
	"sky_csgo_night02",
	"sky_csgo_night05",
	"projektd",
	"sky_otherworld",
	"sky_091",
	"galaxy",
	"space_1",
	"space_3",
	"space_4",
	"space_5",
	"space_6",
	"space_7",
	"space_8",
	"space_9",
	"space_10",
	"space_13",
	"sky_descent",
	"******",
}

local skyboxesMenu = {
	"Default",
	"Amethyst",
	"Dreamy Ocean",
	"Greenscreen",
	"Night 2",
	"Night 5",
	"pAnime",
	"Other World",
	"Sky091",
	"Galaxy",
	"Space 1",
	"Space 3",
	"Space 4",
	"Space 5",
	"Space 6",
	"Space 7",
	"Space 8",
	"Space 9",
	"Space 10",
	"Space 13",
	"Decent",
	"Decent2",
}

options = listbox:SetOptions(unpack(skyboxesMenu))
local set = client.Command -- client.SetConVar
local last = listbox:GetValue()

local function SkyBox()
	if last ~= listbox:GetValue() then
		set("sv_skyname " .. skyboxes[listbox:GetValue() + 1], true)
		last = listbox:GetValue()
	end
end
callbacks.Register("Draw", SkyBox)

callbacks.Register("Unload", "Skybox", function()
	listbox:SetOptions("Default")
end)

--***********************************************--
print("♥♥♥ " .. GetScriptName() .. " loaded without Errors ♥♥♥")
