local Pentagon = {
    active = false,
    x = 1200,
    y = 540,
    w = 210 * 0.6,
    h = 202 * 0.6,
    scale = 0.6,
    rotation = -math.rad(45),
    rotation_speed = 4,
    speed = 800,
    sprite = love.graphics.newImage("Assets/Entities/Pentagon.png"),
}

local timer = 0

-------------------------------------------------------------------------------------------------
-- BASE #########################################################################################
-------------------------------------------------------------------------------------------------

function Pentagon:update(dt)
    if (G_level < 1) then
        return
    end
    self:movement(dt)
end

function Pentagon:draw()
    if (G_level < 1) then
        return
    end
    love.graphics.draw(self.sprite, self.x, self.y, self.rotation, self.scale, self.scale, self.sprite:getWidth() / 2, self.sprite:getHeight() / 2)

    if G_hitboxes == true then
        love.graphics.rectangle("line", self.x - self.w/2, self.y - self.h/2, self.w, self.h)
    end
end

-------------------------------------------------------------------------------------------------
-- FUNCTIONS ####################################################################################
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
-- Appear

function Pentagon:movement(dt)
    timer = timer + dt
    if (timer > 0.5) then
        Pentagon.scale = 0.7
    end
    if (timer > 1) then
        Pentagon.scale = 0.8
    end
    if (timer > 1.5) then
        Pentagon.scale = 0.9
    end
    if (timer > 4) then
        Pentagon.scale = 0.6
        self.x = love.math.random(50, 1870)
        self.y = love.math.random(50, 1030)
        timer = 0
    end
end

-------------------------------------------------------------------------------------------------

return Pentagon