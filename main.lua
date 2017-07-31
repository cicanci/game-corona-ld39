-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

display.setStatusBar(display.HiddenStatusBar)

local physics = require "physics"
physics.start();
--physics.setGravity(0, 9.8)

local movementX = 0
local movementY = 0
local speed = 2
local bulletSpeed = 200

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

local function playerShoot()
  local bullet = display.newImage("content/bullet.png")
  if (movementX > 0) then
    bullet.x = player.x + 40
  else
    bullet.x = player.x - 40
  end
  if (movementY > 0) then
    bullet.y = player.y - 4
  else
    bullet.y = player.y - 12
  end
  nearBackground:insert(bullet)

  physics.addBody(bullet, "dynamic")
  bullet.gravityScale = 0
  bullet.isBullet = true
  bullet:setLinearVelocity(movementX * bulletSpeed, 0)
end

local function playerAction(event)
  if (movementX ~= 0) then
    player.x = player.x + movementX
  end
  if (movementY ~= 0) then
    player.y = player.y + movementY
  end
end
Runtime:addEventListener("enterFrame", playerAction)

local function onTouchScreen(event)
  if (event.phase == "began") then
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
    playerShoot()
  elseif (event.phase == "ended") then
    movementX = 0
    movementY = 0
  end
end
Runtime:addEventListener("touch", onTouchScreen)
