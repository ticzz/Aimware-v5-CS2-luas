local effects = gui.Reference("Visuals", "Other", "Effects")
local nightmode = gui.Slider(effects, "visuals.brightness.amount", "Brightness adjustment", 1.0, 0.0, 4.0, 0.01)
nightmode:SetDescription("Modify exposure values.")
local amount = 0
local alive = false

local function handle_update()
    local C_PostProcessingVolume = entities.FindByClass("C_PostProcessingVolume");

    if #C_PostProcessingVolume <= 0 or amount == nil then
        return
    end

    for i, v in pairs(C_PostProcessingVolume) do
        v:SetPropBool(true, "m_bExposureControl")
        v:SetPropFloat(amount, "m_flMinExposure")
        v:SetPropFloat(amount, "m_flMaxExposure")
    end
end

-- reset on unload
callbacks.Register("Unload", function()
    amount = 1
    handle_update()
end)

callbacks.Register("Draw", function()
    -- callbacks are fucked, also resets on death
    state = entities.GetLocalPlayer():IsAlive()
    if state ~= alive then
        handle_update()
        alive = state
    end

    -- update dat ho
    if amount ~= nightmode:GetValue() then
        amount = nightmode:GetValue()
        handle_update()
    end
end)

