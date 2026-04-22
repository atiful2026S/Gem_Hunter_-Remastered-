local Player = {
    active = true,
    x = 100,
    y = 540,
    w = 38,
    h = 38,
    scale = 1,
    speed = 400,
    angle = 0,
    size = 12,
    target_angle = -math.pi / 2,
    sprite = love.graphics.newImage("resources/assets/objects/player.png"),
}

local respawn_timer = 0

local trail = {}
local max_trail = 20
local trail_color = {1, 1, 1}
local boost_amount = 70
local boost_depletion_rate = 50
local boost_cooldown = 30

-------------------------------------------------------------------------------------------------
-- BASE #########################################################################################
-------------------------------------------------------------------------------------------------

function Player:update(dt)
    Player:respawn(dt)
    Player:movement(dt)
    Player:boost(dt)
end

function Player:draw()
    Player:vfx()
    Player:boost_bar()
    Player:damage_flash()
    
    love.graphics.draw(self.sprite, self.x, self.y, self.angle, self.scale, self.scale, self.sprite:getWidth() / 2, self.sprite:getHeight() / 2)
    

    if G_hitboxes == true then
        love.graphics.rectangle("line", self.x - self.w/2, self.y - self.h/2, self.w, self.h)
    end
end

-------------------------------------------------------------------------------------------------
-- FUNCTIONS ####################################################################################
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
-- Getters and Setters

function Player:reset()
    self.x = 100
    self.y = 540
    self.angle = 0
    boost_amount = 70
end

function Player:get_boost_amount()
    return boost_amount
end

function Player:set_respawn_timer(amount)
    respawn_timer = amount
end

function Player:get_respawn_timer()
    return respawn_timer
end

-------------------------------------------------------------------------------------------------
-- Movement

function Player:movement(dt)
    local dx, dy = 0, 0

    if love.keyboard.isDown("w") then dy = dy - 1 end
    if love.keyboard.isDown("s") then dy = dy + 1 end
    if love.keyboard.isDown("a") then dx = dx - 1 end
    if love.keyboard.isDown("d") then dx = dx + 1 end

    table.insert(trail, 1, {x = Player.x, y = Player.y})

    -- Remove old positions
    if #trail > max_trail then
        table.remove(trail)
    end

    -- 2. Move if there is input
    if dx ~= 0 or dy ~= 0 then
        -- Normalize to fix diagonal speed
        local length = math.sqrt(dx*dx + dy*dy)
        dx, dy = dx / length, dy / length

        local GAME_W = 1920
        local GAME_H = 1080

        -- Update Position with boundary checks
        self.x = math.max(self.sprite:getWidth() / 2, math.min(GAME_W - self.sprite:getWidth() / 2, self.x + dx * self.speed * dt))
        self.y = math.max(self.sprite:getHeight() / 2, math.min(GAME_H - self.sprite:getHeight() / 2, self.y + dy * self.speed * dt))

        -- 3. Smooth Rotation
        local targetAngle = math.atan2(dy, dx)

        -- This helper function ensures we rotate the "short way" around the circle
        local angleDiff = (targetAngle - self.angle + math.pi) % (2 * math.pi) - math.pi
        local rotationSpeed = 10 -- Adjust for snappiness
        self.angle = self.angle + angleDiff * rotationSpeed * dt
    end
    love.graphics.rotate(self.angle)
end

function Player:boost(dt)
    if love.keyboard.isDown("space") and boost_amount > 0 and respawn_timer == 0 then
        if boost_amount < 1 then
            boost_amount = -boost_cooldown -- Cooldown if fully depleted
        end
        if boost_amount > 50 then
            boost_amount = 50
        end
        boost_amount = math.max(-boost_cooldown, boost_amount - boost_depletion_rate * dt)
        self.speed = 800 -- Boost speed when space is held
        trail_color = {1, 0.5, 0} -- Change trail color to orange when boosting
    else
        boost_amount = math.min(70, boost_amount + 10 * dt)
        self.speed = 400 -- Normal speed
        trail_color = {1, 1, 1} -- Change trail color to white when not boosting
    end
end

function Player:respawn(dt)
    if (respawn_timer > 0) then
        Player.active = false
        respawn_timer = respawn_timer - dt
    else
        Player.active = true
        respawn_timer = 0
    end
end
-------------------------------------------------------------------------------------------------
-- Visual

function Player:damage_flash()
    if (respawn_timer > 0 and respawn_timer % 0.2 < 0.1) then
        self.sprite = love.graphics.newImage("resources/assets/objects/player_damaged.png")
        trail_color = {1, 0, 0}
    else
        self.sprite = love.graphics.newImage("resources/assets/objects/player.png")
    end
end

function Player:boost_bar()
    local bar_width = 50
    local bar_height = 10
    local bar_alpha = 1

    if boost_amount > 65 then
        bar_alpha = 1 - (boost_amount - 65) / 5 -- Fade out during after full
    end
    -- Draw background
    --love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.setColor(0, 0, 0, bar_alpha)
    love.graphics.rectangle("fill", self.x - 29, self.y + 25, bar_width + 10, bar_height + 10)

    love.graphics.setColor(0.4, 0.2, 0, bar_alpha)
    love.graphics.rectangle("fill", self.x - 24, self.y + 30, bar_width, bar_height)

    -- Draw boost amount
    local boost_width = 0
    if boost_amount > 0 then boost_width = (boost_amount / 50) * bar_width end -- Prevent bar visual from going under 0
    if boost_amount > 50 then boost_width = 50 end -- Prevent bar visual from going over 50
    love.graphics.setColor(1, 0.5, 0, bar_alpha)
    love.graphics.rectangle("fill", self.x - 24, self.y + 30, boost_width, bar_height)

    -- Reset color
    love.graphics.setColor(1, 1, 1, 1)
end

function Player:vfx()
    for i, pos in ipairs(trail) do
        local alpha = 1 - (i / #trail) -- Fade based on age
        if (respawn_timer ~= 0) then 
            alpha = 0.1
        end
        local size = Player.size * (1 - (i / #trail)) -- Shrink based on age
        love.graphics.setColor(trail_color[1], trail_color[2], trail_color[3], alpha)
        love.graphics.circle("fill", pos.x, pos.y, size)
    end
    -- Reset color after drawing the trail
    love.graphics.setColor(1, 1, 1, 1)
end

-------------------------------------------------------------------------------------------------

return Player