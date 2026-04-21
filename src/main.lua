local GameEngine = require("GameEngine")
local Background = require("Scripts/Background")

function love.load()
    SCREEN_WIDTH = love.graphics.getWidth()
    SCREEN_HEIGHT = love.graphics.getHeight()

    -- Design resolution
    gameWidth = 1920
    gameHeight = 1080
    
    -- Calculate scale to fit screen height
    scale = SCREEN_HEIGHT / gameHeight
    
    -- Calculate centering offsets
    offsetX = (SCREEN_WIDTH - (gameWidth * scale)) / 2
    offsetY = (SCREEN_HEIGHT - (gameHeight * scale)) / 2
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
    -- 1. Draw background stretched to the actual window size first
    local bg = Background:get_sprite()
    local sx = SCREEN_WIDTH / bg:getWidth()
    local sy = SCREEN_HEIGHT / bg:getHeight()
    love.graphics.draw(bg, 0, 0, 0, sx, sy)

    -- 2. Draw the rest of the game scaled/centered
    love.graphics.push()
    love.graphics.translate(offsetX, offsetY)
    love.graphics.scale(scale)
        GameEngine:draw() -- Don't call Background:draw() inside here anymore
    love.graphics.pop()
end