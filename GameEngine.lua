local Player = require("Scripts/Player")
local Background = require("Scripts/Background")
local Gem = require("Scripts/Gem")
local Star = require("Scripts/Enemies/Star")
local Circle = require("Scripts/Enemies/Circle")
local GameEngine = {
}

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

    G_player_damage()
    G_collect_gem()
end

function GameEngine:draw()
    Background:draw()
    G_UI()
    
    Gem:draw()
    Star:draw()
    Circle:draw()
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
    end
end

function G_collect_gem()
    if G_check_collision(Player, Gem) then
        G_level_handler()
    end
end

function G_player_damage()
    if G_check_collision(Player, Star) 
    or G_check_collision(Player, Circle) then
        Player:reset()
    end
end

-------------------------------------------------------------------------------------------------
-- User Interface

function G_UI()
    
    local dev_stats = {
        love.graphics.newText(love.graphics.getFont(), "X: " .. Player.x),
        love.graphics.newText(love.graphics.getFont(), "Y: " .. Player.y),
        love.graphics.newText(love.graphics.getFont(), "Boost: " .. Player:get_boost_amount()),
        love.graphics.newText(love.graphics.getFont(), "Level: " .. G_level),
    }

    -- Go through each item in the dev_stats table and draw it on the screen, going down by 20 pixels for each item
    for i, stat in ipairs(dev_stats) do
        love.graphics.draw(stat, 10, 10 + (i - 1) * 20)
    end
end

-------------------------------------------------------------------------------------------------

return GameEngine