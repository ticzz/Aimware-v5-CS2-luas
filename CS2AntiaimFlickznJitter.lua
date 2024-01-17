-- Configuration Advanced-AA
local USER_NAME = cheat.GetUserName()
local LOCAL_WATERMARK = draw.CreateFont("Verdana", 13, 900)
local SIZE_X, SIZE_Y = draw.GetScreenSize()
local VERTICAL, HORIZONTAL = 30, 70
local FONT_INDICATOR = draw.CreateFont("Tahoma", 15, 1300)

-- Components
local REFERENCE = gui.Window("aawindow", "Advanced AntiAim", 10, 10, 1280, 640)
--local TAB = gui.Tab(REFERENCE, "Advanced-AA", "Pitch & Yaw Jitter")
local WELCOME_BOX = gui.Groupbox(REFERENCE, "Welcome to Advanced-AntiAim, " .. USER_NAME .. "!", 10, 10, 1260, 640)
local MASTER_CHECKBOX = gui.Checkbox(WELCOME_BOX, "master_enable", "Master Enable", false)

local PITCH_JITTER_CONTROL_BOX = gui.Groupbox(WELCOME_BOX, "Pitch Jitter Control", 10, 30, 400, 100)
local PITCH_JITTER_ENABLE_CHECKBOX =
	gui.Checkbox(PITCH_JITTER_CONTROL_BOX, "pitch_jitter_enable", "Enable Pitch Jitter", false)
local PITCH_JITTER_SPEED_SLIDER =
	gui.Slider(PITCH_JITTER_CONTROL_BOX, "pitch_jitter_speed", "Pitch Jitter Speed (Ticks)", 1, 1, 32)
local pitchState = false
local lastPitchChange = 0

local YAW_JITTER_CONTROL_BOX = gui.Groupbox(WELCOME_BOX, "Yaw Jitter Control", 10, 170, 400, 300)
local YAW_JITTER_ENABLE_CHECKBOX = gui.Checkbox(YAW_JITTER_CONTROL_BOX, "yaw_jitter_enable", "Yaw Jitter Enable", false)
local YAW_JITTER_LEFT_SLIDER = gui.Slider(YAW_JITTER_CONTROL_BOX, "yaw_jitter_left", "Yaw Jitter Left", 45, 0, 90)
local YAW_JITTER_RIGHT_SLIDER = gui.Slider(YAW_JITTER_CONTROL_BOX, "yaw_jitter_right", "Yaw Jitter Right", 45, 0, 90)
local YAW_JITTER_BACKWARD_CHECKBOX =
	gui.Checkbox(YAW_JITTER_CONTROL_BOX, "yaw_jitter_backward", "Yaw Jitter Backward", false)
local YAW_JITTER_SPEED_SLIDER =
	gui.Slider(YAW_JITTER_CONTROL_BOX, "yaw_jitter_speed", "Yaw Jitter Speed (Ticks)", 1, 1, 32)

local RANDOM_YAW_CONTROL_BOX = gui.Groupbox(WELCOME_BOX, "Random Yaw Control", 420, 30, 400, 300)
local RANDOM_YAW_ENABLE_CHECKBOX = gui.Checkbox(RANDOM_YAW_CONTROL_BOX, "random_yaw_enable", "Random Yaw Enable", false)
local RANDOM_YAW_MIN_SLIDER = gui.Slider(RANDOM_YAW_CONTROL_BOX, "random_yaw_min", "Random Yaw Range", 90, 0, 180)
local RANDOM_YAW_BACKWARD_CHECKBOX =
	gui.Checkbox(RANDOM_YAW_CONTROL_BOX, "random_yaw_backward", "Random Yaw Backward", false)
local RANDOM_YAW_SPEED_SLIDER =
	gui.Slider(RANDOM_YAW_CONTROL_BOX, "random_yaw_speed", "Random Yaw Speed (Ticks)", 1, 1, 32)
local jitterDirection = true
local lastJitterChange = 0

local SPIN_CONTROL_BOX = gui.Groupbox(WELCOME_BOX, "Spin Control", 420, 255, 400, 100)
local SPIN_ENABLE_CHECKBOX = gui.Checkbox(SPIN_CONTROL_BOX, "spin_enable", "Enable Spin Control", false)
local SPIN_SPEED_SLIDER = gui.Slider(SPIN_CONTROL_BOX, "spin_speed", "Spin Speed", 16, 1, 64)
local lastSpinChange = 0
local currentYaw = 0

local ffpkeybind = gui.Groupbox(WELCOME_BOX, "FakeFlick Pitch", 830, 30, 400, 300)
ffpkeybind:SetDescription("Toggle/hold key")

-- #####  FAKE FLICK PITCH CHECKBOXES #####
local fake_flick_pitch = gui.Checkbox(ffpkeybind, "fake_flick_pitch", "Fake Flick Pitch", false)
local flick_period_pitch = gui.Slider(ffpkeybind, "flick_period_pitch", "Flick Period Pitch", 2, 1, 128)
local invert_pitch = gui.Checkbox(ffpkeybind, "invert_pitch", "Invert Pitch", false)

local ffykeybind = gui.Groupbox(WELCOME_BOX, "FakeFlick Yaw & Manual", 830, 210, 400, 300)
ffykeybind:SetDescription("Toggle/hold key")
local manual_right = gui.Checkbox(ffykeybind, "manual_right", "Manual Right AA", false)
local manual_left = gui.Checkbox(ffykeybind, "manual_left", "Manual Left AA", false)
local default_yaw = gui.Slider(ffykeybind, "default_yaw", "Default Yaw", 0, -180, 180)

-- ##### FAKE FLICK YAW CHECKBOXES  #####
local fake_flick_yaw = gui.Checkbox(ffykeybind, "fake_flick", "Fake Flick Yaw", false)
local flick_period_yaw = gui.Slider(ffykeybind, "flick_period", "Flick Period Yaw", 64, 1, 128)
local invert_yaw = gui.Checkbox(ffykeybind, "invert_flick", "Invert Flick Yaw", false)
-- ##### MANUAL ANTI-AIM FUNCTIONALITY WITH USER-ADJUSTABLE FAKE FLICK PITCH #####
local last_fake_flick_tick = 0

-- Functions
local function HandlePitchJitter()
	if MASTER_CHECKBOX:GetValue() and PITCH_JITTER_ENABLE_CHECKBOX:GetValue() then
		local currentTime = globals.TickCount()
		if currentTime - lastPitchChange > PITCH_JITTER_SPEED_SLIDER:GetValue() then
			local pitchValue = pitchState and 1 or 2
			gui.SetValue("rbot.antiaim.advanced.pitch", pitchValue)
			pitchState = not pitchState
			lastPitchChange = currentTime
		end
	end
end

local function HandleYawJitter()
	if MASTER_CHECKBOX:GetValue() and YAW_JITTER_ENABLE_CHECKBOX:GetValue() then
		local currentTime = globals.TickCount()
		if currentTime - lastJitterChange > YAW_JITTER_SPEED_SLIDER:GetValue() then
			local leftValue = YAW_JITTER_BACKWARD_CHECKBOX:GetValue() and -(180 - YAW_JITTER_LEFT_SLIDER:GetValue())
				or -YAW_JITTER_LEFT_SLIDER:GetValue()
			local rightValue = YAW_JITTER_BACKWARD_CHECKBOX:GetValue() and (180 - YAW_JITTER_RIGHT_SLIDER:GetValue())
				or YAW_JITTER_RIGHT_SLIDER:GetValue()
			local yawValue = jitterDirection and rightValue or leftValue
			gui.SetValue("rbot.antiaim.base", yawValue)
			jitterDirection = not jitterDirection
			lastJitterChange = currentTime
		end
	end
end

local function HandleRandomYaw()
	if MASTER_CHECKBOX:GetValue() and RANDOM_YAW_ENABLE_CHECKBOX:GetValue() then
		local currentTime = globals.TickCount()
		if currentTime - lastJitterChange > RANDOM_YAW_SPEED_SLIDER:GetValue() then
			local yawRange = RANDOM_YAW_MIN_SLIDER:GetValue()
			local yawMin, yawMax
			if RANDOM_YAW_BACKWARD_CHECKBOX:GetValue() then
				yawMin = 180 - yawRange
				yawMax = 180 + yawRange
			else
				yawMin = -yawRange
				yawMax = yawRange
			end
			local randomYaw = math.random(yawMin, yawMax)
			if randomYaw > 180 then
				randomYaw = randomYaw - 360
			elseif randomYaw < -179 then
				randomYaw = randomYaw + 360
			end
			gui.SetValue("rbot.antiaim.base", randomYaw)
			lastJitterChange = currentTime
		end
	end
end

local function HandleSpinControl()
	if MASTER_CHECKBOX:GetValue() and SPIN_ENABLE_CHECKBOX:GetValue() then
		local currentTime = globals.TickCount()
		if currentTime - lastSpinChange > SPIN_SPEED_SLIDER:GetValue() then
			currentYaw = (currentYaw + 10) % 360
			if currentYaw > 180 then
				currentYaw = currentYaw - 360
			end
			gui.SetValue("rbot.antiaim.base", currentYaw)
			lastSpinChange = currentTime
		end
	end
end

-- ##### MANUAL ANTI-AIM FUNCTIONALITY WITH USER-ADJUSTABLE FAKE FLICK PITCH #####
local function manual_aa_pitch_func()
	if MASTER_CHECKBOX:GetValue() then
		-- Pitch
		local pitch_value = 1

		-- Fake Flick Pitch 로직
		local g_vars_tick = globals.TickCount()
		local period_pitch = flick_period_pitch:GetValue()

		if fake_flick_pitch:GetValue() then
			if g_vars_tick % period_pitch < 1 then
				-- 주기일 때 피치를 1 또는 2로 설정
				local pitch = invert_pitch:GetValue() and 1 or 2
				if last_fake_flick_tick ~= g_vars_tick then
					gui.SetValue("rbot.antiaim.advanced.pitch", pitch)
					last_fake_flick_tick = g_vars_tick
				end
			else
				-- 주기가 아닐 때 피치를 1 또는 2로 설정 (invert 적용)
				local pitch = invert_pitch:GetValue() and 2 or 1
				if last_fake_flick_tick ~= g_vars_tick then
					gui.SetValue("rbot.antiaim.advanced.pitch", pitch)
					last_fake_flick_tick = g_vars_tick
				end
			end
		else
			-- Fake Flick
			last_fake_flick_tick = 0
		end
	end
end
local yaw_value
--##### MANUAL ANTI-AIM FUNCTIONALITY WITH USER-ADJUSTABLE FAKE FLICK YAW #####
local function manual_aa_yaw_func()
	if MASTER_CHECKBOX:GetValue() and fake_flick_yaw:GetValue() then
		local current_right_value = manual_right:GetValue()
		local current_left_value = manual_left:GetValue()

		if current_right_value then
			manual_left:SetValue(false)
			local yaw_value = -90
			gui.SetValue("rbot.antiaim.base", yaw_value)
		elseif current_left_value then
			manual_right:SetValue(false)
			local yaw_value = 90
			gui.SetValue("rbot.antiaim.base", yaw_value)
		else
			local yaw_value = default_yaw:GetValue()
			gui.SetValue("rbot.antiaim.base", yaw_value)
		end

		--  Fake Flick Yaw
		local g_vars_tick = globals.TickCount()
		local period = flick_period_yaw:GetValue()
		if invert_yaw:GetValue() and g_vars_tick % period < 1 then
			local flick_angle = yaw_value:GetValue() and -90 or 90
			gui.SetValue("rbot.antiaim.base", flick_angle)
		end
	end
end

-- Watermark
local function watermark()
	draw.SetFont(LOCAL_WATERMARK)
	draw.Color(255, 5, 5, 255)
	draw.Text(10, SIZE_Y - 60, "Advanced-AntiAim")
end

-- Register callbacks
callbacks.Register("Draw", HandlePitchJitter)
callbacks.Register("Draw", HandleYawJitter)
callbacks.Register("Draw", HandleRandomYaw)
callbacks.Register("Draw", HandleSpinControl)
callbacks.Register("Draw", manual_aa_pitch_func)
callbacks.Register("Draw", manual_aa_yaw_func)
callbacks.Register("Draw", watermark)
