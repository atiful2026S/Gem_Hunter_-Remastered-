local Square = {}
Square.__index = Square

-- Load the image once outside the creator function for performance
local playerSprite = love.graphics.newImage("resources/assets/objects/square.png")

function Square.new(startY)
    local instance = setmetatable({}, Square)
    instance.active = true
    instance.x = 1920 + 50 -- Start slightly off-screen to the right
    instance.y = startY or love.math.random(40, 1040)
    instance.w = 38
    instance.h = 38
    instance.scale = 1
    instance.speed = love.math.random(400, 800) -- Variation in speed
    instance.sprite = playerSprite
    instance.trail = {}
    instance.max_trail = 20
    instance.trail_color = {1, 0, 0.435}
    return instance
end

function Square:update(dt)
    -- Move left
    self.x = self.x - self.speed * dt
    table.insert(self.trail, 1, {x = self.x, y = self.y})

    if #self.trail > self.max_trail then
        table.remove(self.trail)
    end
    
    -- Deactivate if it goes off screen so we can remove it
    if self.x < -self.w then
        self.active = false
    end
end

function Square:draw()
    self:vfx()
    love.graphics.draw(self.sprite, self.x, self.y, 0, self.scale, self.scale, self.sprite:getWidth() / 2, self.sprite:getHeight() / 2)

    if G_hitboxes then
        love.graphics.rectangle("line", self.x - self.w/2, self.y - self.h/2, self.w, self.h)
    end
end

function Square:vfx()
    for i, pos in ipairs(self.trail) do
        local alpha = 0.5 - (i / #self.trail) -- Fade based on age
        local size = 15 * (1 - (i / #self.trail)) -- Shrink based on age
        love.graphics.setColor(self.trail_color[1], self.trail_color[2], self.trail_color[3], alpha)
        love.graphics.circle("fill", pos.x, pos.y, size)
    end
    -- Reset color after drawing the trail
    love.graphics.setColor(1, 1, 1, 1)
end

return Square