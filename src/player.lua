player = {}
anim8 = require 'libraries/anim8'
camera = require("libraries/camera")
cam = camera()

function player.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    player.x = 400
    player.y = 200
    player.speed = 500
    player.sprite = love.graphics.newImage('sprites/agentRight.png')
    --player.spriteLeft = love.graphics.newImage('sprites/agentLeft.png')

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
        love.graphics.draw(player.sprite, player.x, player.y, nil, 4, nil, 16, 16)
    end

    if facingLeft == true then
        love.graphics.draw(player.sprite, player.x, player.y, nil, -4, 4, 16, 16)
    end

    for i, b in ipairs(bullets) do
        if b.direction == 1 then
            love.graphics.draw(bullets.sprite, b.x, b.y, nil, 2)
        else
            love.graphics.draw(bullets.sprite, b.x, b.y, nil, -2, 2)
        end
        
        b.x = b.x + b.vx/10
        
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

    if love.keyboard.isDown("space") then
        player.collider:applyForce(0, -1000000)
    end

    player.collider:setLinearVelocity(vX, vY)
    player.x = player.collider:getX()
    player.y = player.collider:getY()
end

function spawnBullet()
    bullet = {}
    local pw, ph = player.sprite:getWidth(), player.sprite:getHeight()
    if facingRight == true then
        bullet.x = player.x + pw / 2
        bullet.y = player.y - ph
    else
        bullet.x = player.x - pw / 2
        bullet.y = player.y - ph
    end

    bullet.speed = 50
    
    if facingRight then bullet.vx = bullet.speed else bullet.vx = -bullet.speed end
    bullet.vy = 0

    bullet.w = bullets.sprite:getWidth()
    bullet.h = bullets.sprite:getHeight()

    if facingRight then
        bullet.direction = 1
    else
        bullet.direction = 2
    end

    table.insert(bullets, bullet)
end

function destroyBullet(dt)
    for i = #bullets, 1, -1 do
        local b = bullets[i]
        local gx, gy = cam:worldCoords(0, 0)
        local gw, gh = cam:worldCoords(love.graphics.getWidth(), love.graphics.getHeight())
        if b.x < gx-b.w or b.y < gy-b.h or b.x > gw+b.w or b.y > gh+b.h then
            table.remove(bullets, i)
            print(gx, gy, gw, gh)
            print(b.w, b.h)
        end
    end
end