local Triangle = {
    active = false,
    x = 960,
    y = -180,
    w = 192 * 0.4,
    h = 170 * 0.4,
    scale = 0.4,
    rotation = math.rad(180),
    rotation_speed = 4,
    speed = 4, -- This speed is multiplied by however close we are to the center.
    sprite = love.graphics.newImage("resources/assets/objects/triangle.png"),
}

local timer = 0
local red = 0

-------------------------------------------------------------------------------------------------
-- BASE #########################################################################################
-------------------------------------------------------------------------------------------------

function Triangle:update(dt)
    if (G_level < 6) then
        return
    end
    self:movement(dt)
end

function Triangle:draw()
    if (G_level < 6) then
        return
    end
    love.graphics.setColor(1, 0 - red, 0.435 - red, 0.5)
    if (timer > 1.2 and timer < 2) then
        love.graphics.circle("fill", self.x, self.y - 10, (timer * 11 + 10))
    end
    love.graphics.setColor(1, 1 - red, 1 - red)
    love.graphics.draw(self.sprite, self.x, self.y, self.rotation, self.scale, self.scale, self.sprite:getWidth() / 2, self.sprite:getHeight() / 2)
    love.graphics.setColor(1, 1, 1, 1)
    

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
    if (timer < 3) then
        timer = timer + dt

        if (timer < 1.4) then
           self.y = self.y + (self.speed * math.dist(0, self.y, 0, 540)) * dt
        end
        if (timer > 1.2 and timer < 2) then
            red = red + 0.01
            self.x = self.x + math.random(-1, 1)
            self.y = self.y + math.random(-1, 1)
        end
        if (timer > 2) then
            self.y = -180
        end
        if (timer > 2 and timer < 2.01) then
            triangle_explode()
        end
         if (timer > 3) then
            timer = 0
            red = 0
        end


    end

end
-------------------------------------------------------------------------------------------------

return Triangle