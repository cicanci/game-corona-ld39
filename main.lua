-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

display.setStatusBar(display.HiddenStatusBar)

local physics = require "physics"
physics.start()
physics.setGravity(0, 0)

local movementX = 0
local movementY = 0
local speed = 4
local lastMovement = -speed

local bulletSpeed = 100
local bulletCounter = 0
local bulletRate = 5

local farBackground = display.newGroup()
local nearBackground = display.newGroup()
local foreground = display.newGroup()

-- Background
local background = display.newRect(0, 0, display.contentWidth, display.contentHeight)
background.anchorX = 0
background.anchorY = 0
background:setFillColor(24/255, 39/255, 51/255)
farBackground:insert(background)

-- Player
local player = display.newImage("content/player.png")
player.x = display.contentWidth * 0.5
player.y = display.contentHeight * 0.5
foreground:insert(player)

-- Monster
local monster = display.newImage("content/monster.png")
monster.x = (display.contentWidth * 0.5) - 100
monster.y = display.contentHeight * 0.5
monster.gravityScale = 0
physics.addBody(monster)
foreground:insert(monster)

-- Local collision handling
local function onLocalCollision(self, event)
  print(event.target)        --the first object in the collision
  print(event.other)         --the second object in the collision
  print(event.selfElement)   --the element (number) of the first object which was hit in the collision
  print(event.otherElement)  --the element (number) of the second object which was hit in the collision
end
monster.collision = onLocalCollision
monster:addEventListener("collision")

local function playerShoot()
  if (bulletCounter < bulletRate) then
    bulletCounter = bulletCounter + 1
    return
  end
  bulletCounter = 0

  local bullet = display.newImage("content/bullet.png")
  bullet.type = "bullet"
  if (lastMovement > 0) then
    bullet.x = player.x + 40
  else
    bullet.x = player.x - 40
  end
  if (movementY > 0) then
    bullet.y = player.y - 4
  else
    bullet.y = player.y - 10
  end
  nearBackground:insert(bullet)

  physics.addBody(bullet, "dynamic")
  bullet.gravityScale = 0
  bullet.isBullet = true
  bullet:setLinearVelocity(lastMovement * bulletSpeed, 0)
end

local function playerAction(event)
  if (movementX ~= 0) then
    player.x = player.x + movementX
  end
  if (movementY ~= 0) then
    player.y = player.y + movementY
  end

  playerShoot()
end
Runtime:addEventListener("enterFrame", playerAction)

local function onTouchScreen(event)
  if ((event.phase == "began") or (event.phase == "moved")) then
    if (event.x > display.contentCenterX) then
      movementX = speed
      player.xScale = -1
    else
      movementX = -speed
      player.xScale = 1
    end
    if (event.y > display.contentCenterY) then
      movementY = speed
    else
      movementY = -speed
    end
    lastMovement = movementX
  else --ended or cancelled
    movementX = 0
    movementY = 0
  end
end
Runtime:addEventListener("touch", onTouchScreen)
