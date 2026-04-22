local GameEngine = require("game_engine")

local show_dev_stats = false

_G.TIMER = 0

function love.load()
    _G.SCREEN_WIDTH = love.graphics.getWidth()
    _G.SCREEN_HEIGHT = love.graphics.getHeight()
    -- Design resolution
    _G.GAME_WIDTH = 1920
    _G.GAME_HEIGHT = 1080
    
    -- Determine whether width or height is the limiting factor
    local scaleX = _G.SCREEN_WIDTH / _G.GAME_WIDTH
    local scaleY = _G.SCREEN_HEIGHT / _G.GAME_HEIGHT
    
    -- Use the smaller scale to ensure the whole image fits
    _G.SCALE = math.min(scaleX, scaleY)
    
    -- Calculate centering offsets
    _G.OFFSET_X = (_G.SCREEN_WIDTH - (_G.GAME_WIDTH * _G.SCALE)) / 2
    _G.OFFSET_Y = (_G.SCREEN_HEIGHT - (_G.GAME_HEIGHT * _G.SCALE)) / 2

    GameEngine:load()
end

function love.resize(w, h)
    -- Update our global screen dimension variables
    _G.SCREEN_WIDTH = w
    _G.SCREEN_HEIGHT = h

    -- Determine whether width or height is the limiting factor
    local scaleX = _G.SCREEN_WIDTH / _G.GAME_WIDTH
    local scaleY = _G.SCREEN_HEIGHT / _G.GAME_HEIGHT
    
    -- Use the smaller scale to ensure the whole image fits
    _G.SCALE = math.min(scaleX, scaleY)
    
    -- Recalculate centering offsets
    _G.OFFSET_X = (_G.SCREEN_WIDTH - (_G.GAME_WIDTH * _G.SCALE)) / 2
    _G.OFFSET_Y = (_G.SCREEN_HEIGHT - (_G.GAME_HEIGHT * _G.SCALE)) / 2
end

function love.update(dt)
    _G.TIMER = _G.TIMER + dt
    GameEngine:update(dt)
end

function love.keypressed(key)
    if key == "." then
        show_dev_stats = not show_dev_stats
    end
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
    love.graphics.push()
    love.graphics.translate(_G.OFFSET_X, _G.OFFSET_Y)
    love.graphics.scale(_G.SCALE)
        GameEngine:draw()
    love.graphics.pop()

    if (show_dev_stats) then
        G_dev_stats()
    end
end