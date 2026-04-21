local GameEngine = require("GameEngine")
local Background = require("Scripts/Background")

function love.load()
    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()
    
    -- Design resolution
    gameWidth = 1920
    gameHeight = 1080
    
    -- Calculate scale to fit screen height
    scale = screenHeight / gameHeight
    
    -- Calculate centering offsets
    offsetX = (screenWidth - (gameWidth * scale)) / 2
    offsetY = (screenHeight - (gameHeight * scale)) / 2
    GameEngine:load()
end

function love.update(dt)
    GameEngine:update(dt)
end

function love.keypressed(key)
    if key == "f11" then
        FULLSCREEN = not FULLSCREEN
        love.window.setFullscreen(FULLSCREEN)
    end
    if key == "escape" then
        love.event.quit()
    end
    if key == "q" then
        G_level_handler()
    end

    -- Show hitboxes
    if key == "h" and G_hitboxes == false then 
        G_hitboxes = true;
    elseif key == "h" and G_hitboxes == true then
        G_hitboxes = false;
    end
end

function love.draw()
    love.graphics.push()
    love.graphics.translate(offsetX, offsetY)
    love.graphics.scale(scale)
        GameEngine:draw()
    love.graphics.pop()
end