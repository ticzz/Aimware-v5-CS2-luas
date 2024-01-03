-- Created by ArtzHarvest - https://aimware.net/forum/user/484354

callbacks.Register("Draw", function()
    local lp = entities.GetLocalPlayer()
    if not lp:IsAlive() then return end

    client.Command("cl_crosshaircolor 5", true);

    local maxColorValue = 255
    local speed = 1

    local counter = 1
    if counter <= maxColorValue then
        local r = math.floor(math.sin(globals.RealTime() * speed) * 127 + 128)
        local g = math.floor(math.sin(globals.RealTime() * speed + 2) * 127 + 128)
        local b = math.floor(math.sin(globals.RealTime() * speed + 4) * 127 + 128)

		client.Command("cl_crosshaircolor_g "..g..";cl_crosshaircolor_r "..r..";cl_crosshaircolor_b "..b, true);

        counter = counter + 1
    end
    if counter == maxColorValue then
        counter = 1
    end
end)
