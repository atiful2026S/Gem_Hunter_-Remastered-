local deathParticles = {}

-- A table to hold active particle systems so multiple things can die at once
local activeSystems = {}
local particleTexture = nil

function deathParticles.load()
    -- Create a simple 2x2 white square texture dynamically
    local imageData = love.image.newImageData(2, 2)
    imageData:mapPixel(function(x, y, r, g, b, a) return 1, 1, 1, 1 end)
    particleTexture = love.graphics.newImage(imageData)
end

function deathParticles.trigger(x, y)
    -- 1. Create a new particle system instance for this death event
    -- (Max 32 particles per explosion)
    local ps = love.graphics.newParticleSystem(particleTexture, 16)

    -- 2. Configure the explosion behavior
    ps:setParticleLifetime(0.4, 0.8) -- Particles last between 0.4 and 0.8 seconds
    ps:setEmissionArea("none")       -- Emit exactly from the center point
    -- 1. Give them a strong initial push outward
    ps:setSpeed(200, 400)            -- High initial velocity

    -- 2. Make that push go in a full 360-degree circle
    ps:setDirection(0)
    ps:setSpread(math.pi * 2) -- Full circle

    -- 3. Apply a moderate friction so they slow down beautifully
    ps:setLinearDamping(5) -- Don't set this too high (keep it between 2 and 5)
    ps:setSizes(10, 5, 0) -- Start normal size, shrink, fade to 0

    -- Color gradient: Start bright red/orange, fade to dark gray/transparent
    ps:setColors(
        1, 0.3, 0, 1,    -- Bright Orange/Red
        0.8, 0.1, 0, 1,  -- Darker Red
        0.2, 0.2, 0.2, 0 -- Fade to transparent gray
    )

    -- 3. Burst out all particles instantly
    ps:setPosition(x, y)
    ps:emit(24) -- Number of particles in the burst

    -- Keep track of it
    table.insert(activeSystems, ps)
end

function deathParticles.update(dt)
    -- Update active systems and clear them out when they are done
    for i = #activeSystems, 1, -1 do
        local ps = activeSystems[i]
        ps:update(dt)

        -- If the particles are gone, remove the system from memory
        if ps:getCount() == 0 then
            table.remove(activeSystems, i)
        end
    end
end

function deathParticles.draw()
    -- Set blend mode to additive for a "glowing" fire/spark effect
    local oldBlendMode = love.graphics.getBlendMode()
    love.graphics.setBlendMode("add")

    for _, ps in ipairs(activeSystems) do
        love.graphics.draw(ps)
    end

    love.graphics.setBlendMode(oldBlendMode)
end

return deathParticles
