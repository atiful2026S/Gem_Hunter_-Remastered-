local Background = require("background")

local Player = require("objects/player")
local Gem = require("objects/gem")
local Star = require("objects/enemies/star")
local Circle = require("objects/enemies/circle")

local Square = require("objects/enemies/square")
local activeSquares = {} -- This will hold all your clones
local spawnTimer = 0

local Pentagon = require("objects/enemies/pentagon")
local GameEngine = {}

G_hitboxes = false

G_level = 0

-------------------------------------------------------------------------------------------------
-- BASE #########################################################################################
-------------------------------------------------------------------------------------------------

function GameEngine:load()
    G_level_handler()
end

function GameEngine:update(dt)
    Player:update(dt)
    Star:update(dt)
    Circle:update(dt)

    -- Square Logic:
    ---------------------------------------------------------------------------
    if G_level > 3 then -- Only spawn if level is 3 or higher
        spawnTimer = spawnTimer + dt
        if spawnTimer > 0.6 then -- Adjust this number for spawn frequency
            local newSquare = Square.new() -- Create a new clone
            table.insert(activeSquares, newSquare)
            spawnTimer = 0
        end
    end

    -- 2. Update all active squares and remove them if they go off-screen
    for i = #activeSquares, 1, -1 do
        local s = activeSquares[i]
        s:update(dt)

        -- Check for collision with player
        if G_check_collision(Player, s) then
            Player:reset()
            Player:set_respawn_timer(0.6)
        end

        -- Clean up squares that are no longer active (off-screen)
        if not s.active then
            table.remove(activeSquares, i)
        end
    end
    ---------------------------------------------------------------------------

    Pentagon:update(dt)

    G_player_damage()
    G_collect_gem()
end

function GameEngine:draw()
    Background:draw()
    
    Gem:draw()
    Star:draw()
    Circle:draw()
    
    -- Draw all the square clones
    for _, s in ipairs(activeSquares) do
        s:draw()
    end

    Pentagon:draw()
    
    Player:draw()
end

-------------------------------------------------------------------------------------------------
-- FUNCTIONS ####################################################################################
-------------------------------------------------------------------------------------------------

function G_check_collision(a, b)
    if (a.active == true and b.active == true) then
    local a_hw, a_hh = a.w / 2, a.h / 2
    local b_hw, b_hh = b.w / 2, b.h / 2

    return (a.x - a_hw) < (b.x + b_hw) and
           (a.x + a_hw) > (b.x - b_hw) and
           (a.y - a_hh) < (b.y + b_hh) and
           (a.y + a_hh) > (b.y - b_hh)
    end
end

function G_level_handler()
    if (G_level >= 7) then
        G_level = 0
    end
    G_level = G_level + 1
    Background:set_sprite()
    Gem:set_sprite()
    Player:reset()
    if G_level == 1 then
        Star.active = true
    elseif G_level == 2 then
        Circle.active = true
    elseif G_level == 5 then
        Pentagon.active = true
        Pentagon.x = love.math.random(50, 1870)
        Pentagon.y = love.math.random(50, 1030)
    end
end

function G_collect_gem()
    if G_check_collision(Player, Gem) then
        G_level_handler()
    end
end

function G_player_damage()
    if G_check_collision(Player, Star) 
    or G_check_collision(Player, Circle) 
    or G_check_collision(Player, Pentagon) 
    then
        Player:reset()
        Player:set_respawn_timer(0.6)
    end
end

-------------------------------------------------------------------------------------------------
-- User Interface

function G_dev_stats()
    
    local dev_stats = {
        love.graphics.newText(love.graphics.getFont(), "X: " .. Player.x),
        love.graphics.newText(love.graphics.getFont(), "Y: " .. Player.y),
        love.graphics.newText(love.graphics.getFont(), "Boost: " .. Player:get_boost_amount()),
        love.graphics.newText(love.graphics.getFont(), "Level: " .. G_level),
        love.graphics.newText(love.graphics.getFont(), "Global Timer: " .. _G.TIMER),
        love.graphics.newText(love.graphics.getFont(), "Player active: " .. tostring(Player.active)),
        love.graphics.newText(love.graphics.getFont(), "Respawn timer: " .. Player:get_respawn_timer()),
        love.graphics.newText(love.graphics.getFont(), "Screen Width: " .. _G.SCREEN_WIDTH),
        love.graphics.newText(love.graphics.getFont(), "Screen Height: " .. _G.SCREEN_HEIGHT),
        love.graphics.newText(love.graphics.getFont(), "Game Width: " .. _G.GAME_WIDTH),
        love.graphics.newText(love.graphics.getFont(), "Game Height: " .. _G.GAME_HEIGHT),
        love.graphics.newText(love.graphics.getFont(), "Offset X: " .. _G.OFFSET_X),
        love.graphics.newText(love.graphics.getFont(), "Offset Y: " .. _G.OFFSET_Y),
    }

    -- Go through each item in the dev_stats table and draw it on the screen, going down by 20 pixels for each item
    for i, stat in ipairs(dev_stats) do
        love.graphics.draw(stat, 10, 10 + (i - 1) * 20)
    end
end

-------------------------------------------------------------------------------------------------

return GameEngine