local Pentagon = {
    active = false,
    x = 1200,
    y = 540,
    w = 210 * 0.6,
    h = 202 * 0.6,
    scale = 0.6,
    rotation = 0,
    rotation_speed = 4,
    speed = 800,
    sprite = love.graphics.newImage("resources/assets/objects/pentagon.png"),
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

local function change_scale(scale)
    Pentagon.scale = Pentagon.scale + scale
    Pentagon.w = Pentagon.w + (210 * scale)
    Pentagon.h = Pentagon.h + (202 * scale)
end

function Pentagon:movement(dt)

    if (timer < 1.4) then
        timer = timer + dt

        if (timer % 0.5 < 0.1) then
            change_scale(0.03)
        end
    end

end

-------------------------------------------------------------------------------------------------

return Pentagon