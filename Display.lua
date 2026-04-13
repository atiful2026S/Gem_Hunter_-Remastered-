local Display = {
    targetW = 1920,
    targetH = 1080,
    canvas = nil,
    scale = 1,
    ox = 0,
    oy = 0
}

function Display:init()
    self.canvas = love.graphics.newCanvas(self.targetW, self.targetH)
    self:resize(love.graphics.getDimensions())
end

function Display:resize(w, h)
    self.scale = math.min(w / self.targetW, h / self.targetH)
    self.ox = (w - self.targetW * self.scale) / 2
    self.oy = (h - self.targetH * self.scale) / 2
end

function Display:start()
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()
end

function Display:stop()
    love.graphics.setCanvas()
    love.graphics.draw(self.canvas, self.ox, self.oy, 0, self.scale, self.scale)
end

return Display