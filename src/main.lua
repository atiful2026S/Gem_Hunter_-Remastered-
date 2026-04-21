local push = require "lib/push" -- Handles resolution
local GameEngine = require("GameEngine")

local gameWidth, gameHeight = 1920, 1080
local windowWidth, windowHeight = love.window.getDesktopDimensions()
push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false, resizable = true})


function love.load()
    GameEngine:load()
end

function love.update(dt)
    GameEngine:update(dt)
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
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
    push:start()
        GameEngine:draw()
    push:finish()
end