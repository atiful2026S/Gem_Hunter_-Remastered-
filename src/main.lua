local GameEngine = require("GameEngine")
local Background = require("Scripts/Background")

WIDTH, HEIGHT = love.window.getDesktopDimensions(1)

function love.load()
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
    GameEngine:draw()
end