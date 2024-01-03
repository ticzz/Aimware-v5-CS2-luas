local script_browser = gui.Reference("Settings", "Lua Scripts", "Browse", "")
-- Adjust positions for Aimware menu layout
script_browser:SetPosY(50)
script_browser:SetHeight(385)
local search_box = gui.Editbox(gui.Reference("Settings", "Lua Scripts", "Browse"), "search", "Search scripts")
search_box:SetPosY(-10)
search_box:SetWidth(280)

-- Cache filtered list
local filtered_scripts = {}

-- Initialize files table
local files = { lua = {}, folder = {} }

local function GetScripts(path)
	local ok, err = pcall(function()
		if path:gmatch(".*%.lua$") then
			table.insert(files.lua, path)
		elseif path:gmatch(".*/%...*%.lua$") then
			table.insert(files.folder, path)
		end
	end)

	if not ok then
		print("Error getting scripts: " .. err)
	end
end

-- Cache lowercase script names
local lowercase_scriptsandfolder = {}

local function Refresh()
	local status, err = pcall(file.Enumerate, GetScripts(path))

	-- Populate scripts
	files.lua = {}
	files.folder = {}

	if not status then
		print("Error enumerating files: " .. err)
		return
	end
	-- Cache lowercase
	lowercase_scriptsandfolder = {}
	for _, script in ipairs(files.lua) do
		table.insert(lowercase_scriptsandfolder, script:lower())
	end
	for _, folder in ipairs(files.folder) do
		table.insert(lowercase_scriptsandfolder, folder:lower())
	end
end

local function FilterScripts()
	filtered_scripts = {}

	local search_text = search_box:GetValue():lower()

	-- Make search case insensitive
	search_text = search_text:lower()

	for i, script in ipairs(files.lua) do
		if lowercase_scriptsandfolder[i]:find(search_text) then
			table.insert(filtered_scripts, script)
		end
	end

	-- Keep folders
	for i, folder in ipairs(files.folder) do
		if lowercase_scriptsandfolder[i]:find(search_text) then
			table.insert(filtered_scripts, folder)
		end
	end
end

local function UpdateScriptBrowser()
	Refresh()
	FilterScripts()
	script_browser:SetOptions(unpack(filtered_scripts))
end

-- Use custom callback (assuming gui.Custom exists and works as intended)
local Apply_search =
	gui.Custom(gui.Reference("Settings", "Lua Scripts"), "lua.search", 0, 0, 0, 0, UpdateScriptBrowser(), nil, nil)

local ui_refresh_lua = gui.Button(gui.Reference("Settings", "Lua Scripts", "Other"), "Refresh List", Refresh)
ui_refresh_lua:SetPosY(42)
ui_refresh_lua:SetWidth(123)
ui_refresh_lua:SetPosX(0)
ui_refresh_lua:SetHeight(28)

-- Other UI setup

-- Error handling
callbacks.Register("Unload", function()
	pcall(function()
		-- Reset positions
		script_browser:SetPosY(0)
		script_browser:SetHeight(430)
	end)
end)

print("Script browser loaded")
