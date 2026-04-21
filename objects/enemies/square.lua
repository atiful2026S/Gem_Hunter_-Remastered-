local Square = {}
Square.__index = Square

-- Load the image once outside the creator function for performance
local playerSprite = love.graphics.newImage("resources/assets/objects/player.png")

function Square.new(startY)
    local instance = setmetatable({}, Square)
    instance.active = true
    instance.x = 1920 + 50 -- Start slightly off-screen to the right
    instance.y = startY or love.math.random(50, 1030)
    instance.w = 38
    instance.h = 38
    instance.scale = 1
    instance.speed = love.math.random(400, 800) -- Variation in speed
    instance.sprite = playerSprite
    return instance
end

function Square:update(dt)
    -- Move left
    self.x = self.x - self.speed * dt
    
    -- Deactivate if it goes off screen so we can remove it
    if self.x < -self.w then
        self.active = false
    end
end

function Square:draw()
    love.graphics.draw(self.sprite, self.x, self.y, 0, self.scale, self.scale, 
        self.sprite:getWidth() / 2, self.sprite:getHeight() / 2)

    if G_hitboxes then
        love.graphics.rectangle("line", self.x - self.w/2, self.y - self.h/2, self.w, self.h)
    end
end

return Square