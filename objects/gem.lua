local Gem = {
    active = true,
    x = 1500,
    y = 540,
    w = 445 * 0.3,
    h = 335 * 0.3,
    scale = 0.3,
    sprite = love.graphics.newImage("resources/assets/objects/gems/red_gem.png")
}

-------------------------------------------------------------------------------------------------
-- BASE #########################################################################################
-------------------------------------------------------------------------------------------------

function Gem:draw()
    love.graphics.draw(self.sprite, self.x, self.y, 0, self.scale, self.scale, self.sprite:getWidth() / 2, self.sprite:getHeight() / 2)

    if G_hitboxes == true then
        love.graphics.rectangle("line", self.x - self.w/2, self.y - self.h/2, self.w, self.h)
    end
end

-------------------------------------------------------------------------------------------------
-- FUNCTIONS ####################################################################################
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
-- Visual

function Gem:set_sprite()
    if G_level == 1 then
        self.sprite = love.graphics.newImage("resources/assets/objects/gems/red_gem.png")
    elseif G_level == 2 then
        self.sprite = love.graphics.newImage("resources/assets/objects/gems/blue_gem.png")
    elseif G_level == 3 then
        self.sprite = love.graphics.newImage("resources/assets/objects/gems/green_gem.png")
    elseif G_level == 4 then
        self.sprite = love.graphics.newImage("resources/assets/objects/gems/purple_gem.png")
    elseif G_level == 5 then
        self.sprite = love.graphics.newImage("resources/assets/objects/gems/yellow_gem.png")
    elseif G_level == 6 then
        self.sprite = love.graphics.newImage("resources/assets/objects/gems/teal_gem.png")
    else
        self.sprite = love.graphics.newImage("resources/assets/objects/gems/white_gem.png") -- Default gem for levels beyond 6
    end
end

-------------------------------------------------------------------------------------------------

return Gem