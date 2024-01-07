local files = { lua = {} }
local ui_lua = gui.Reference("Settings", "Lua Scripts", "Browse", "")
ui_lua:SetPosY(50)
ui_lua:SetHeight(386)

local ui_search_lua = gui.Editbox(gui.Reference("Settings", "Lua Scripts", "Browse"), "search", "Search scripts")
ui_search_lua:SetPosY(-10)
ui_search_lua:SetWidth(280)

local function GetFiles(f)
	if f:match(".*lua$") then --or f:match(".*/$*lua$") then
		table.insert(files.lua, f)
	end
end

local function Refresh()
	files.lua = {}
	file.Enumerate(GetFiles)
end

Refresh()

local ui_refresh_lua = gui.Button(gui.Reference("Settings", "Lua Scripts", "Other"), "Refresh List", Refresh)
ui_refresh_lua:SetPosY(42)
ui_refresh_lua:SetWidth(123)
ui_refresh_lua:SetPosX(0)
ui_refresh_lua:SetHeight(28)

local function ApplyLuaSearch()
	local temp = { lua = {} }
	temp.lua = {}
	local searchPattern = ui_search_lua:GetValue():lower()

	for _, lua in ipairs(files.lua) do
		if lua:lower():match(searchPattern .. string.format(".*lua$")) ~= nil then
			table.insert(temp.lua, lua)
		end
	end

	ui_lua:SetOptions(unpack(temp.lua))
end

local lua_search =
	gui.Custom(gui.Reference("Settings", "Lua Scripts"), "lua.search", 0, 0, 0, 0, ApplyLuaSearch, nil, nil)

callbacks.Register("Unload", function()
	ui_lua:SetPosY(0)
	ui_lua:SetHeight(432)
end)

--***********************************************--
-- Info about success or failure of loading the script
--***********************************************--
local name = GetScriptName()
print("♥♥♥ " .. name .. " loaded without Errors ♥♥♥")
