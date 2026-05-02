local Circle = {
    active = false,
    x = 1200,
    y = 540,
    w = 222 * 0.6,
    h = 222 * 0.6,
    scale = 0.6,
    rotation = -math.rad(45),
    rotation_speed = 4,
    speed = 800,
    sprite = love.graphics.newImage("resources/assets/objects/circle.png"),
}

-------------------------------------------------------------------------------------------------
-- BASE #########################################################################################
-------------------------------------------------------------------------------------------------

function Circle:reset()
    self.active = false
    self.x = 1200
    self.y = 540
    self.rotation = -math.rad(45)
end

function Circle:update(dt)
    if (G_level < 2) then
        return
    end
    self:movement(dt)
end

function Circle:draw()
    if (G_level < 2) then
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

function Circle:movement(dt)
    -- Horizontal Boundaries
    if (self.x > 1920 - self.w/2) then 
        self.rotation = math.rad(180) - self.rotation
        self.x = 1920 - self.w/2 -- Snap to edge
    elseif (self.x < 0 + self.w/2) then 
        self.rotation = math.rad(180) - self.rotation
        self.x = 0 + self.w/2 -- Snap to edge
    end

    -- Vertical Boundaries
    if (self.y < 0 + self.w/2) then
        self.rotation = -self.rotation
        self.y = 0 + self.w/2 -- Snap to edge
    elseif (self.y > 1080 - self.w/2) then
        self.rotation = -self.rotation
        self.y = 1080 - self.w/2 -- Snap to edge
    end

    local x_change = math.cos(self.rotation) * self.speed * dt
    local y_change = math.sin(self.rotation) * self.speed * dt

    self.x = self.x + x_change
    self.y = self.y + y_change
end

-------------------------------------------------------------------------------------------------

return Circle