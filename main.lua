local Display = require("Display")
local GameEngine = require("GameEngine")

function love.load()
    -- love.window.setMode(1280, 720, {resizable = true})
    Display:init()
    GameEngine:load()
end

function love.update(dt)
    GameEngine:update(dt)
end

function love.resize(w, h)
    Display:resize(w, h)
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
    Display:start()
        GameEngine:draw()
    Display:stop()
end