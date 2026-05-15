_G.VERSION = "Development Build 1.1.6"

-- FONT: https://www.dafont.com/blocked.font?

local moonshine = require 'moonshine'
local GameEngine = require("game_engine")

PAUSE_MENU = love.graphics.newImage("resources/assets/pause_menu.png")
RESET_BUTTON = { x = 960, y = 670, sprite = love.graphics.newImage("resources/assets/reset_button.png") }

local show_dev_stats = false

_G.TIMER = 0
_G.PAUSED = false

-- Math Functions
function math.dist(x1, y1, x2, y2) return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2) ^ 0.5 end

function love.load()
    SHADER = moonshine(moonshine.effects.scanlines).chain(moonshine.effects.crt).chain(moonshine.effects.glow)
    SHADER.scanlines.opacity = 0.4
    SHADER.glow.min_luma = 0.2

    love.mouse.setVisible(PAUSED)
    _G.SEED = math.randomseed(os.time())

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
    if not PAUSED then
        _G.TIMER = _G.TIMER + dt
        GameEngine:update(dt)
    end
end

function love.keypressed(key)
    if key == "." then
        show_dev_stats = not show_dev_stats
    end
    if key == "f11" then
        _G.FULLSCREEN = not _G.FULLSCREEN
        love.window.setFullscreen(_G.FULLSCREEN)
    end
    if key == "return" then
        love.event.quit()
    end
    if key == "escape" then
        _G.PAUSED = not _G.PAUSED
        love.mouse.setVisible(PAUSED)
        love.mouse.setPosition(960, 540)
    end
    if key == "q" then
        G_level_handler()
    end
    if key == "r" then
        GameEngine:reset()
        PAUSED = false
    end

    -- Show hitboxes
    if key == "h" and G_hitboxes == false then
        G_hitboxes = true
    elseif key == "h" and G_hitboxes == true then
        G_hitboxes = false
    end
end

function love.mousereleased(x, y, button)
    if (PAUSED and button == 1) then
        if (x > RESET_BUTTON.x - RESET_BUTTON.sprite:getWidth() / 2 and x < RESET_BUTTON.x + RESET_BUTTON.sprite:getWidth() / 2 and y > RESET_BUTTON.y - RESET_BUTTON.sprite:getHeight() / 2 and y < RESET_BUTTON.y + RESET_BUTTON.sprite:getHeight() / 2) then
            GameEngine:reset()
            PAUSED = false
        end
    end
    love.mouse.setVisible(PAUSED)
end

function love.draw()
    SHADER(function()
        love.graphics.push()
        love.graphics.translate(_G.OFFSET_X, _G.OFFSET_Y)
        love.graphics.scale(_G.SCALE)
        GameEngine:draw()
        if PAUSED then
            love.graphics.draw(PAUSE_MENU)
            love.graphics.draw(RESET_BUTTON.sprite, RESET_BUTTON.x, RESET_BUTTON.y, 0, 1, 1,
                RESET_BUTTON.sprite:getWidth() / 2, RESET_BUTTON.sprite:getHeight() / 2)
        end
        if not show_dev_stats then love.graphics.draw(love.graphics.newText(love.graphics.getFont(), "Ver: " .. VERSION)) end
        love.graphics.pop()

        if (show_dev_stats) then
            G_dev_stats()
        end
    end)
end