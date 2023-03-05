function love.load()
    require 'src/player'
    sti = require 'libraries/sti'
    wf = require 'libraries/windfield'
    camera = require 'libraries/camera'

    player.load()

    gameMap = sti('maps/gameMap.lua')
    world = wf.newWorld(0, 100000)
    cam = camera()

    -- Player collider
    player.collider = world:newRectangleCollider(400, 1350, 70, 55)
    player.collider:setFixedRotation(true)

    -- Ground colliders
    grounds = {}
    if gameMap.layers["GroundRC"] then
        for i, obj in pairs(gameMap.layers["GroundRC"].objects) do
            ground = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            ground:setType('static')
            table.insert(grounds, ground)
        end
    end
end

function love.update(dt)
    player.update(dt)
    cam:lookAt(player.x, player.y)
    world:update(dt)
end

function love.draw()
    cam:attach()
        gameMap:drawLayer(gameMap.layers["Ground"])
        player.draw()
        world:draw()
    cam:detach()
end