local Background = {
    sprite = love.graphics.newImage("Assets/Backgrounds/red_bg.png")
}

-------------------------------------------------------------------------------------------------
-- BASE #########################################################################################
-------------------------------------------------------------------------------------------------

function Background:draw()
    love.graphics.draw(self.sprite, 0, 0)
end

-------------------------------------------------------------------------------------------------
-- FUNCTIONS ####################################################################################
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
-- Visual

function Background:set_sprite()
    if G_level == -1 then
        self.sprite = love.graphics.newImage("Assets/Backgrounds/game_over_bg.png")
    elseif G_level == 0 then
        self.sprite = love.graphics.newImage("Assets/Backgrounds/game_win_bg.png")
    elseif G_level == 1 then
        self.sprite = love.graphics.newImage("Assets/Backgrounds/red_bg.png")
    elseif G_level == 2 then
        self.sprite = love.graphics.newImage("Assets/Backgrounds/blue_bg.png")
    elseif G_level == 3 then
        self.sprite = love.graphics.newImage("Assets/Backgrounds/green_bg.png")
    elseif G_level == 4 then
        self.sprite = love.graphics.newImage("Assets/Backgrounds/purple_bg.png")
    elseif G_level == 5 then
        self.sprite = love.graphics.newImage("Assets/Backgrounds/yellow_bg.png")
    elseif G_level == 6 then
        self.sprite = love.graphics.newImage("Assets/Backgrounds/teal_bg.png")
    else
        self.sprite = love.graphics.newImage("Assets/Backgrounds/white_bg.png") -- Default background for levels beyond 6
    end
end

-------------------------------------------------------------------------------------------------

return Background