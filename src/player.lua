player = {}
anim8 = require 'libraries/anim8'

function player.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    player.x = 400
    player.y = 200
    player.speed = 500
    player.spriteRight = love.graphics.newImage('sprites/agentRight.png')
    player.spriteLeft = love.graphics.newImage('sprites/agentLeft.png')

    facingRight = true
    facingLeft = false

    bullets = {}
    bullets.sprite = love.graphics.newImage('sprites/bullet.png')
end

function player.update(dt)
    playerMovement(dt)
    destroyBullet(dt)
end

function player.draw()
    if facingRight == true then
        love.graphics.draw(player.spriteRight, player.x, player.y, nil, 4, nil, 16, 16)
    end

    if facingLeft == true then
        love.graphics.draw(player.spriteLeft, player.x, player.y, nil, 4, nil, 16, 16)
    end

    for i, b in ipairs(bullets) do
        love.graphics.draw(bullets.sprite, b.x, b.y, nil, 2)
        
        if bullet.direction == 1 then
            b.x = b.x + 5
        else
            b.x = b.x - 5
        end
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        spawnBullet()
    end
end

-- Player functions
function playerMovement(dt)
    isMoving = false;
    local vX = 0
    local vY = 0

    if love.keyboard.isDown("d") then
        vX = player.speed

        isMoving = true
        facingRight = true
        facingLeft = false
    end

    if love.keyboard.isDown("a") then
        vX = player.speed * -1

        isMoving = true
        facingRight = false
        facingLeft = true
    end

    player.collider:setLinearVelocity(vX, vY)
    player.x = player.collider:getX()
    player.y = player.collider:getY()
end

function spawnBullet()
    bullet = {}
    if facingRight == true then
        bullet.x = player.x + 100
        bullet.y = 1350
    else
        bullet.x = player.x
        bullet.y = 1350
    end

    bullet.speed = 50

    if facingRight == true then
        bullet.direction = 1
    else
        bullet.direction = 2
    end

    table.insert(bullets, bullet)
end

function destroyBullet(dt)
    for i = #bullets, 1, -1 do
        local b = bullets[i]
        if b.x < 0 or b.y < 0 or b.x > love.graphics.getWidth() or b.y > love.graphics.getHeight() then
            table.remove(bullets, i)
        end
    end
end