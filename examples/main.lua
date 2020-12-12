io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end
function math.angle(x1,y1, x2,y2) return math.atan2(y2-y1, x2-x1) end

require("src/luagon")

gravity = 0.3

platforms = {}

hero = {}

keys = {
  up = 'w',
  down = 'r',
  left = 'a',
  right = 's'
}

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
  hero.coord = {15, 0,  30, 15,  25, 35,  15, 40,  5, 35,  0, 15}
  hero.width = 30
  hero.height = 40
  hero.finalCoord = {}
  
  --local pos = {0, 0,  200, 0,  200, 40,  0, 40}
  local pos = {0, 0,  200, 0,  220, 20,  200, 40,  0, 40,  -20, 20}
  AddPlatform(0, 500, pos)
  AddPlatform(300, 500, pos)
  AddPlatform(100, 600, pos)
  AddPlatform(400, 600, pos)
  AddPlatform(250, 580, pos)
  AddPlatform(500, 220, pos)
  local pos = {0, 0,  200, 0,  200, 32,  0, 32}
  AddPlatform(300, 320, pos)
  AddPlatform(600, 320, pos)
  AddPlatform(450, 410, pos)
  local pos = {0, 0,  200, 0,  200, 1,  0, 1}
  AddPlatform(400, 180, pos)
  local pos = {0, 0,  1, 0,  1, 200,  0, 200}
  AddPlatform(500, 80, pos)
  
end


function love.update(dt)
  
  hero:move(dt)
  world:update(dt)
  
  
  slowDown = 0.02
  if hero.vx ~= 0 then
    if hero.vx > slowDown then
      hero.vx = hero.vx - slowDown 
    end
    if hero.vx < -slowDown then
      hero.vx = hero.vx + slowDown
    end
    if math.abs(hero.vx) <= slowDown then
      hero.vx = 0
    end
  end
  
  
  
  if not CollideLib.Effect(hero.coord, hero.x, hero.y, 0, 1) then
    hero.vy = hero.vy + gravity*dt*60
  else
    hero.vy = 0
  end
  
  --hero.vy = hero.vy + gravity
  
  
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
  --Fin de draw
  
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
  if point ~= nil then
    love.graphics.setColor(255, 0, 0)
    love.graphics.circle("fill", point.x, point.y, 5)
  end
  if pAx ~= nil then
    love.graphics.setColor(0, 0, 255)
    love.graphics.line(pAx, pAy, pBx, pBy)
  end
  
  A = hero.x + hero.width/2
  B = hero.y + hero.height/2
  C = hero.x + hero.vx*10 + hero.width/2
  D = hero.y + hero.vy*10 + hero.height/2
  love.graphics.setColor(0, 255, 0)
  love.graphics.line(A, B, C, D)
  
  
  love.graphics.setColor(0, 0, 0)
  love.graphics.print(love.timer.getFPS(), 0, 0)
  love.graphics.print(math.floor(hero.vy), 0, 10)
  
end

function hero:move(dt)
  
  if love.keyboard.isDown(keys.right) and not love.keyboard.isDown(keys.left) then
    
    if not CollideLib.Effect(self.coord, self.x, self.y, 1, 0) then
      self.vx = self.speed
    else
      self.vx = 0
    end
    --self.vx = self.speed
  end
  if love.keyboard.isDown(keys.left) and not love.keyboard.isDown(keys.right) then
    if not CollideLib.Effect(self.coord, self.x, self.y, -1, 0) then
      self.vx = -self.speed
    else
      self.vx = 0
    end
    --hero.vx = -hero.speed
  end
  if love.keyboard.isDown(keys.left) and love.keyboard.isDown(keys.right) then
    self.vx = 0
  end
  if love.keyboard.isDown(keys.down) then
    self.vx = 0
  end
  
  if love.keyboard.isDown("space") or love.keyboard.isDown(keys.up) then
    if not jumpPressed then
      self.vy = -self.jumpHeight
      jumpPressed = true
    end
  else
    jumpPressed = false
  end
  
end


function AddPlatform(pX, pY, pCoord)
  
  local platform = {
    x = pX,
    y = pY,
    coord = pCoord,
    finalCoord = {}
  }
  
  table.insert(platforms, platform)
  
end
