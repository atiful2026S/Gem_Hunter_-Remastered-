local Line = {
    active = false,
    x = 400,
    y = 540,
    w = 16 * 3,
    h = 360 * 3,
    scale_x = 0,
    scale_y = 3,
    speed = 800,
    sprite = love.graphics.newImage("resources/assets/objects/line.png"),
}

local timer = 0
local alpha = 0

function Line:get_timer()
    return timer
end

-------------------------------------------------------------------------------------------------
-- BASE #########################################################################################
-------------------------------------------------------------------------------------------------

function Line:reset()
    timer = 0
    alpha = 0
    self.active = false
    self.x = 400
    self.y = 540
    self.scale_x = 0
end

function Line:update(dt)
    if (G_level < 3) then
        return
    end
    self:movement(dt)
end

function Line:draw()
    if (G_level < 3) then
        return
    end
    love.graphics.setColor(1, 1, 1, alpha)
    love.graphics.draw(self.sprite, self.x, self.y, 0, self.scale_x, self.scale_y, self.sprite:getWidth() / 2, self.sprite:getHeight() / 2)
    love.graphics.setColor(1, 1, 1, 1)

    if G_hitboxes == true then
        love.graphics.rectangle("line", self.x - self.w/2, self.y - self.h/2, self.w, self.h)
    end
end

-------------------------------------------------------------------------------------------------
-- FUNCTIONS ####################################################################################
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
-- Appear

function Line:movement(dt)
    if (timer < 2) then
        timer = timer + dt
        if (timer < 1) then
            self.scale_x = self.scale_x + (3 * dt)
            alpha = alpha + 0.01
        end
        if (timer > 1 and timer < 1.5) then
            self.active = true
            alpha = 1
            if (timer % 0.2 < 0.1) then
                self.x = self.x + 0.5
            else
                self.x = self.x - 0.5
            end
        end
        if (timer > 1.5) then
            self.x = -100
        end
        if (timer > 2) then
            self.active = false
            self.x = love.math.random(400, 1000)
            self.scale_x = 0
            timer = 0
            alpha = 0
        end

    end
end

-------------------------------------------------------------------------------------------------

return Line