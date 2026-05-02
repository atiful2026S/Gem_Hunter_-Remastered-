local Background = require("background")

local Player = require("objects.player")
local Gem = require("objects.gem")
local Star = require("objects.enemies.star")
local Circle = require("objects.enemies.circle")

local Square = require("objects.enemies.square")
local activeSquares = {} -- This will hold all clones
local spawnTimer = 0

local Pentagon = require("objects.enemies.pentagon")
local Line = require("objects.enemies.line")

local Triangle = require("objects.enemies.triangle")
local MiniTriangle = require("objects.enemies.mini_triangle")
local activeMiniTriangles = {} -- This will hold all clones
local maxMiniTriangles = 10 -- How many mini triangles explode out?

local GameEngine = {}

G_hitboxes = false

G_level = 0

-------------------------------------------------------------------------------------------------
-- BASE #########################################################################################
-------------------------------------------------------------------------------------------------

function GameEngine:reset()
    Gem:reset()
    Player:reset()
    Star:reset()
    Circle:reset()
    Line:reset()
    Pentagon:reset()
    Triangle:reset()

    -- Remove all squares
    for i = #activeSquares, 1, -1 do
        table.remove(activeSquares, i)
    end

    -- Remove all mini triangles
    for i = #activeMiniTriangles, 1, -1 do
        table.remove(activeMiniTriangles, i)
    end

    G_level = 0
    G_level_handler()
end

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
    end
    ---------------------------------------------------------------------------

    Pentagon:update(dt)
    Line:update(dt)
    Triangle:update(dt)

    -- Mini Triangle Logic:
    ---------------------------------------------------------------------------
    if (G_level > 5) then
        function Triangle:explode()
            local newMiniTriangle
            for i = 1, maxMiniTriangles do
                if (#activeMiniTriangles < maxMiniTriangles) then --Prevent multiple triangles from spawning due to timer inconsistency 
                newMiniTriangle = MiniTriangle.new(i * (360 / maxMiniTriangles)) -- Create a new clone
                table.insert(activeMiniTriangles, newMiniTriangle)
                end
            end
        end

        for i = #activeMiniTriangles, 1, -1 do
            local t = activeMiniTriangles[i]
            t:update(dt)

            if G_check_collision(Player, t) then
                Player:reset()
                Player:set_respawn_timer(0.6)
            end

            if not t.active then
                table.remove(activeMiniTriangles, i)
            end
        end
    end
    ---------------------------------------------------------------------------

    G_player_damage()
    G_collect_gem()
end

function GameEngine:draw()
    Background:draw()

    Gem:draw()
    Star:draw()
    Circle:draw()

    -- Draw all the square clones
    if (G_level > 3) then
        for _, s in ipairs(activeSquares) do
            s:draw()
        end
    end

    -- Draw all the mini triangles
    if (G_level > 5) then
        for _, t in ipairs(activeMiniTriangles) do
            t:draw()
        end
    end

    Pentagon:draw()
    Line:draw()
    Triangle:draw()

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
        G_level = -1
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
    elseif G_level == 0 then
        Gem.x = -100
        Gem.y = 0
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
    or G_check_collision(Player, Line)
    or G_check_collision(Player, Triangle)
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
        love.graphics.newText(love.graphics.getFont(), "Triangle Timer " .. Triangle:get_timer()),
        love.graphics.newText(love.graphics.getFont(), "Triangle inverted? " .. tostring(Triangle:get_inverted())),
        love.graphics.newText(love.graphics.getFont(), "Triangle Y " .. Triangle.y),
        love.graphics.newText(love.graphics.getFont(), "Paused: " .. tostring(_G.PAUSED)),
    }

    -- Go through each item in the dev_stats table and draw it on the screen, going down by 20 pixels for each item
    for i, stat in ipairs(dev_stats) do
        love.graphics.draw(stat, (_G.OFFSET_X + 10), (_G.OFFSET_Y + 10) + (i - 1) * 20)
    end
end

-------------------------------------------------------------------------------------------------

return GameEngine