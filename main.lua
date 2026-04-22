local GameEngine = require("game_engine")
local Background = require("background")

_G.TIMER = 0

function love.load()
    _G.SCREEN_WIDTH = love.graphics.getWidth()
    _G.SCREEN_HEIGHT = love.graphics.getHeight()
    -- Design resolution
    _G.GAME_WIDTH = 1920
    _G.GAME_HEIGHT = 1080
    
    -- Calculate scale to fit screen height
    _G.SCALE = _G.SCREEN_HEIGHT / _G.GAME_HEIGHT
    
    -- Calculate centering offsets
    _G.OFFSET_X = (_G.SCREEN_WIDTH - (_G.GAME_WIDTH * _G.SCALE)) / 2
    _G.OFFSET_Y = (_G.SCREEN_HEIGHT - (_G.GAME_HEIGHT * _G.SCALE)) / 2

    GameEngine:load()
end

function love.resize(w, h)
    -- Update our global screen dimension variables
    _G.SCREEN_WIDTH = w
    _G.SCREEN_HEIGHT = h

    -- Recalculate scale (fitting to height in your case)
    _G.SCALE = _G.SCREEN_HEIGHT / _G.GAME_HEIGHT
    
    -- Recalculate centering offsets
    _G.OFFSET_X = (_G.SCREEN_WIDTH - (_G.GAME_WIDTH * _G.SCALE)) / 2
    _G.OFFSET_Y = (_G.SCREEN_HEIGHT - (_G.GAME_HEIGHT * _G.SCALE)) / 2
end

function love.update(dt)
    _G.TIMER = _G.TIMER + dt
    GameEngine:update(dt)
end

function love.keypressed(key)
    if key == "f11" then
        _G.FULLSCREEN = not _G.FULLSCREEN
        love.window.setFullscreen(_G.FULLSCREEN)
    end
    if key == "escape" then
        love.event.quit()
    end
    if key == "q" then
        G_level_handler()
    end

    -- Show hitboxes
    if key == "h" and G_hitboxes == false then 
        G_hitboxes = true
    elseif key == "h" and G_hitboxes == true then
        G_hitboxes = false
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
    love.graphics.translate(_G.OFFSET_X, _G.OFFSET_Y)
    love.graphics.scale(_G.SCALE)
        GameEngine:draw() -- Don't call Background:draw() inside here anymore
    love.graphics.pop()
end