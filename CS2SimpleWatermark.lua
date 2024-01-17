local font = draw.CreateFont("Tahoma", 14)
local ref = gui.Reference("Misc", "Enhancement", "Appearance")
local watermarktextColor = gui.ColorPicker(ref, "watermark_color", "Watermark Color", 204, 96, 112, 255)
local size_x, size_y = draw.GetScreenSize()
local cheatname = "aimware.net Beta"
local user_name = cheat.GetUserName()
local seperator = " | "
local fps = "fps"

local count = 0
local last = globals.RealTime()

local frame_rate = 0.0
local get_abs_fps = function()
	frame_rate = 0.9 * frame_rate + (1.0 - 0.9) * globals.AbsoluteFrameTime()
	return math.floor((1.0 / frame_rate) + 0.5)
end

local watermarktext = cheatname .. seperator .. user_name

local function draw_logo()
	draw.SetFont(font)
	draw.Color(110, 110, 110, 255)
	draw.FilledRect(5, 5, 245, 35)
	draw.Color(255, 255, 255, 255)
	draw.FilledRect(10, 10, 240, 30)
	draw.Color(watermarktextColor:GetValue())
	draw.Text(15, 15, watermarktext)

	local fps = get_abs_fps()

	if fps < 30 then
		draw.Color(150, 0, 0, 255)
	elseif fps < 60 then
		draw.Color(150, 150, 0, 255)
	else
		draw.Color(0, 150, 0, 255)
	end

	draw.Text(143, 15, watermarktext .. seperator .. "  fps" .. get_abs_fps())
end

callbacks.Register("Draw", draw_logo)

--***********************************************--

print("♥♥♥ " .. GetScriptName() .. " loaded without Errors ♥♥♥")
