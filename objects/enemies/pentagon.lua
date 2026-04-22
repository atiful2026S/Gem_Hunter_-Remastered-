local Pentagon = {
    active = false,
    x = -100,
    y = 0,
    w = 210 * 0.6,
    h = 202 * 0.6,
    scale = 0.6,
    rotation = love.math.random(math.rad(0), math.rad(360)),
    rotation_speed = 4,
    speed = 800,
    sprite = love.graphics.newImage("resources/assets/objects/pentagon.png"),
}

local timer = 0
local alpha = 0

-------------------------------------------------------------------------------------------------
-- BASE #########################################################################################
-------------------------------------------------------------------------------------------------

function Pentagon:update(dt)
    if (G_level < 5) then
        return
    end
    self:movement(dt)
end

function Pentagon:draw()
    if (G_level < 5) then
        return
    end
    love.graphics.setColor(1, 1, 1, alpha)
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
-- Appear

local function change_scale(scale)
    Pentagon.scale = Pentagon.scale + scale
    Pentagon.w = Pentagon.w + (210 * scale)
    Pentagon.h = Pentagon.h + (202 * scale)
end

function Pentagon:movement(dt)

    if (timer < 4) then
        timer = timer + dt

        if (timer < 1.4) then
            self.active = false
            if (timer % 0.5 < 0.1) then
                change_scale(0.04)
            end
            if (timer % 0.25 < 0.1) then
                alpha = 0.5
            else
                alpha = 0.75
            end
        end
        if (timer > 1.4 and timer < 3) then
            self.active = true
            alpha = 1
        end
        if (timer > 3 and timer < 3.2) then
            change_scale(-0.1)
            self.rotation = self.rotation - math.rad(10)
        end
        if (timer > 3.2) then
            self.x = -100
            self.rotation = love.math.random(math.rad(0), math.rad(360))
        end
        if (timer > 4) then
            self.x = love.math.random(100, 1820)
            self.y = love.math.random(50, 1030)
            self.scale = 0.6
            self.w = 210 * 0.6
            self.h = 210 * 0.6
            timer = 0
        end

    end

end

-------------------------------------------------------------------------------------------------

return Pentagon