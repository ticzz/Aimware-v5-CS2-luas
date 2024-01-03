-- Create a configurations menu
local menuRef = gui.Reference("Visuals", "Local", "Helper")
local colorPicker = gui.ColorPicker(menuRef, "aimbot_fov_color", "FOV Circle Color", 255, 0, 0, 150)
local enableCheckbox = gui.Checkbox(menuRef, "aimbot_fov_enable", "Enable FOV Circle", false)

-- Cache frequently accessed values
local localPlayer = entities.GetLocalPlayer()
local rbotMaster = gui.GetValue("rbot.master")
local lbotMaster = gui.GetValue("lbot.master")
local rbotFov = gui.GetValue("rbot.aim.target.fov")
local minFOV
local maxFOV
local GetScriptName

-- Get the middle of the Games Display
local screenCenterX, screenCenterY = draw.GetScreenSize()
screenCenterX = screenCenterX / 2
screenCenterY = screenCenterY / 2

-- Master function state to enable or disable
local function enableState()
	if not enableCheckbox:GetValue() or not localPlayer:IsAlive() then
		return false
	end
end

-- Get the weapon type
local function getWeaponType()
	local activeWeapon = entities.GetLocalPlayer():GetPropEntity("m_hActiveWeapon")
	return activeWeapon:GetWeaponType()
end

-- Get the circle radius
local function getCircleRadius()
	if not enableState() then
		return
	end
	if rbotMaster then
		return rbotFov * 10
	elseif lbotMaster then
		local weaponType = getWeaponType()
		if lbotMaster and weaponType then
			minFOV = gui.GetValue("lbot.weapon." .. weaponType .. ".target.minfov")
			maxFOV = gui.GetValue("lbot.weapon." .. weaponType .. ".target.maxfov")
			return (minFOV + maxFOV) / 2 * 10
		end
	end
	return 0
end

local circleColor
local circleRadius

-- Draw the circle
local function drawFOVCircle()
	if not enableState() then
		return
	end

	circleColor = colorPicker:GetValue()
	circleRadius = getCircleRadius()

	draw.Color(circleColor.r, circleColor.g, circleColor.b, circleColor.a)
	draw.OutlinedCircle(screenCenterX, screenCenterY, circleRadius)
end

callbacks.Register("Draw", drawFOVCircle)

local name = GetScriptName()

-- Print a message to the console
print("♥♥♥ " .. name .. " loaded without Errors ♥♥♥")
