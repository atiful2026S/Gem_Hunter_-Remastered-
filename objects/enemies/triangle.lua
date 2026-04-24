local Triangle = {
    active = false,
    x = 960,
    y = -180,
    w = 192 * 0.4,
    h = 170 * 0.4,
    scale = 0.4,
    rotation = 0,
    rotation_speed = 4,
    speed = 600,
    sprite = love.graphics.newImage("resources/assets/objects/triangle.png"),
}

-------------------------------------------------------------------------------------------------
-- BASE #########################################################################################
-------------------------------------------------------------------------------------------------

function Triangle:update(dt)
    if (G_level < 1) then
        return
    end
    self:movement(dt)
end

function Triangle:draw()
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

function Triangle:movement(dt)
    if (self.y < 1260) then
        self.y = self.y + self.speed * dt
    else
         self.y = -180
    end
end

-------------------------------------------------------------------------------------------------

return Triangle