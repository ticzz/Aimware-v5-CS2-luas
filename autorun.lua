local font = draw.CreateFont("Bahnschrift", 20)
local frames = 0
local fadeout = 0
local fadein = 0
local function drawFadingText()
    if frames < 5.5 then
        frames = frames + globals.AbsoluteFrameTime()
        if frames > 5 then
            fadeout = ((frames - 5) * 510)
        end
        if frames > 0.1 and frames < 0.25 then
            fadein = (frames - 0.1) * 4500
        end
        fadein = math.max(0, math.min(650, fadein))
        fadeout = math.max(0, math.min(255, fadeout))
        if frames >= 0.25 then
            fadein = 634
        end
        local screenWidth, screenHeight = draw.GetScreenSize()
        local textWidth = draw.GetTextSize("Aimware.net injected") -- Get width of entire text string
        local textX = (screenWidth - textWidth) / 2 -- Center the text
        -- Draw the background
        draw.Color(15, 15, 15, 200 - fadeout)
        draw.FilledRect(textX - 650 - 5 + fadein, screenHeight / 2 - 15, textX + textWidth + 650 - fadein, screenHeight / 2 + 15)
        draw.Color(239, 150, 255, 200 - fadeout)
        draw.FilledRect(textX - 650 - 5 + fadein, screenHeight / 2 + 15, textX + textWidth + 650 - fadein, screenHeight / 2 + 16)
        draw.SetFont(font)
        draw.Color(225, 50, 50, 255 - fadeout)
        -- Calculate the starting position for each word
        local aimwareTextWidth = draw.GetTextSize("Aimware")
        local dotNetTextWidth = draw.GetTextSize(".net")
        local injectedTextWidth = draw.GetTextSize("injected")
        -- Draw each word with its own color
        draw.TextShadow(textX - 650 + fadein, screenHeight / 2 - 8, "Aimware")
        draw.Color(225, 225, 225, 255 - fadeout)
        draw.TextShadow(textX + aimwareTextWidth + 2 - 650 + fadein, screenHeight / 2 - 8, ".net")
        draw.Color(0, 225, 0, 255 - fadeout)
        draw.TextShadow(textX + aimwareTextWidth + dotNetTextWidth + 4 - 650 + fadein, screenHeight / 2 - 8, "injected")
    end
end
callbacks.Register("Draw", drawFadingText)
