-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

display.setStatusBar(display.HiddenStatusBar)

local group = display.newGroup()

local player = display.newImage("content/player.png")
player.x = display.contentWidth * 0.5
player.y = display.contentHeight * 0.5
group:insert(player)

local movement = 0
local speed = 10

local function movePlayer(event)
  player.x = player.x + movement
end
Runtime:addEventListener("enterFrame", movePlayer)

local function onTouchScreen(event)
  if (event.phase == "began") then
    if (event.x > display.contentCenterX) then
      movement = speed
      player.xScale = -1
    else
      movement = -speed
      player.xScale = 1
    end
  elseif (event.phase == "ended") then
    movement = 0
  end
end
Runtime:addEventListener("touch", onTouchScreen)
