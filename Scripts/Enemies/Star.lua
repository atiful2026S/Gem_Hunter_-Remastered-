local Star = {
    active = false,
    x = 1200,
    y = 540,
    w = 296 * 0.6,
    h = 298 * 0.6,
    scale = 0.6,
    rotation = 0,
    rotation_speed = 4,
    speed = 600,
    sprite = love.graphics.newImage("Assets/Entities/Star.png"),
}

-------------------------------------------------------------------------------------------------
-- BASE #########################################################################################
-------------------------------------------------------------------------------------------------

function Star:update(dt)
    if (G_level < 1) then
        return
    end
    self:movement(dt)
end

function Star:draw()
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
-- Movement

function Star:movement(dt)
    if (self.y < 1260) then
        self.y = self.y + self.speed * dt
    else
         self.y = -180
    end

    self.rotation = self.rotation + dt * self.rotation_speed
end

-------------------------------------------------------------------------------------------------

return Star