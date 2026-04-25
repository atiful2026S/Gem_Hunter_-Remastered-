local MiniTriangle = {}
MiniTriangle.__index = MiniTriangle

-- Load the image once outside the creator function for performance
local triangleSprite = love.graphics.newImage("resources/assets/objects/triangle.png")

function MiniTriangle.new(rotation)
    local instance = setmetatable({}, MiniTriangle)
    instance.active = true
    instance.x = 960
    instance.y = 540
    instance.w = 192 * 0.2
    instance.h = 170 * 0.2
    instance.scale = 0.2
    instance.rotation = math.rad(rotation)
    instance.speed = 600
    instance.sprite = triangleSprite
    instance.distance = 0
    return instance
end

function MiniTriangle:update(dt)
    self.distance = self.distance + self.speed * dt
    self.rotation = self.rotation + math.rad(60) * dt
    self.x = 960 + (math.cos(self.rotation) * self.distance)
    self.y = 540 + (math.sin(self.rotation) * self.distance)

    -- Deactivate if it goes off screen so we can remove it
    if self.x < 0 or self.x > 1920 or self.y < 0 or self.y > 1080 then
        self.active = false
    end
end

function MiniTriangle:draw()
    love.graphics.draw(self.sprite, self.x, self.y, self.rotation, self.scale, self.scale, self.sprite:getWidth() / 2, self.sprite:getHeight() / 2)

    if G_hitboxes then
        love.graphics.rectangle("line", self.x - self.w/2, self.y - self.h/2, self.w, self.h)
    end
end

return MiniTriangle