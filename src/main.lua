io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

require("collideLib")

Hero = {}
gravity = 0.3

platforms = {}

hero = {}

function love.load()
  love.window.setMode(1200, 700)
  
  jumpPressed = false
  hero.x = 100
  hero.y = 200
  hero.vx = 0
  hero.vy = 0
  hero.jumpHeight = 6
  hero.speed = 2
  --hero.coord = {0, 0,  20, 0,  20, 35,  0, 35}
  hero.coord = {10, 0,  25, 15,  20, 35,  10, 40,  0, 35,  -5, 15}
  hero.finalCoord = {}
  
  --local pos = {0, 0,  200, 0,  200, 40,  0, 40}
  local pos = {0, 0,  200, 0,  220, 20,  200, 40,  0, 40,  -20, 20}
  AddPlatform(0, 400, pos)
  AddPlatform(300, 400, pos)
  AddPlatform(100, 500, pos)
  AddPlatform(400, 500, pos)
  AddPlatform(250, 480, pos)
  local pos = {0, 0,  200, 0,  200, 1,  0, 1}
  AddPlatform(400, 200, pos)
  
end


function love.update(dt)
  
  Hero.move(dt)
  
  --Pour le draw
  local i
  for i = 1, #hero.coord do
    if i % 2 == 0 then
      hero.finalCoord[i] = hero.coord[i] + hero.y
    else
      hero.finalCoord[i] = hero.coord[i] + hero.x
    end
  end
  
  
  for n = #platforms, 1, -1 do
    local platform = platforms[n]
    
    local i
    for i = 1, #platform.coord do
      if i % 2 == 0 then
        platform.finalCoord[i] = platform.coord[i] + platform.y
      else
        platform.finalCoord[i] = platform.coord[i] + platform.x
      end
    end
  end
  
  --local i
  --for i = 1, 1001 do 
  if math.abs(hero.vx) > 0 or math.abs(hero.vy) > 0 then
    hero.vx, hero.vy = Collide(hero.coord, hero.x, hero.y, hero.vx, hero.vy)
  end
  
  
  hero.x = hero.x + hero.vx
  hero.y = hero.y + hero.vy
  
  
  slowDown = 0.02
  if hero.vx ~= 0 then
    if hero.vx > slowDown then
      hero.vx = hero.vx - slowDown*60*dt 
    end
    if hero.vx < -slowDown then
      hero.vx = hero.vx + slowDown*60*dt
    end
    if math.abs(hero.vx) <= slowDown then
      hero.vx = 0
    end
  end
  
  if not CollideBottom(hero.coord, hero.x, hero.y) then
    hero.vy = hero.vy + gravity*60*dt
  else
    hero.vy = 0
  end

end


function love.draw()
  
  love.graphics.setColor(255, 255, 255)
  love.graphics.setBackgroundColor(255, 255, 255)
  love.graphics.setColor(0, 0, 0)
  love.graphics.polygon("line", hero.finalCoord)
  for n = #platforms, 1, -1 do
    local platform = platforms[n]
    love.graphics.polygon("line", platform.finalCoord)
  end
  love.graphics.print(love.timer.getFPS(), 0, 0)
  love.graphics.print(math.floor(hero.vy), 0, 10)
  
end


function Hero.move(dt)
  
  if love.keyboard.isDown("right") and not love.keyboard.isDown("left") then
    hero.vx = hero.speed*60*dt
  end
  if love.keyboard.isDown("left") and not love.keyboard.isDown("right") then
    hero.vx = -hero.speed*60*dt
  end
  if love.keyboard.isDown("left") and love.keyboard.isDown("right") then
    hero.vx = 0
  end
  if love.keyboard.isDown("down") then
    hero.vx = 0
  end
  
  if love.keyboard.isDown("space") or love.keyboard.isDown("up") then
    if not jumpPressed then
      hero.vy = -hero.jumpHeight*60*dt
      jumpPressed = true
    end
  else
    jumpPressed = false
  end
  
end


function AddPlatform(pX, pY, pCoord)
  
  local platform = {}
  
  platform.x = pX
  platform.y = pY
  platform.coord = pCoord
  platform.finalCoord = {}
  
  table.insert(platforms, platform)
  
end