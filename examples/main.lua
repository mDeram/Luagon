io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end
function math.angle(x1,y1, x2,y2) return math.atan2(y2-y1, x2-x1) end

require("src/luagon")

gravity = 0.3

platforms = {}

hero = {}

keys = {
    up    = 'w',
    down  = 'r',
    left  = 'a',
    right = 's'
}

function love.load()
    love.window.setMode(1200, 700)
    love.window.setTitle("Luagon")

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
    hero.center = {
        x = hero.width/2,
        y = hero.height/2
    }
    hero.debug = {}
    hero.debug.x = 0
    hero.debug.y = 0
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
    --replace with friction
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
    hero.vy = hero.vy + gravity*dt*60
    --[[
    if not CollideLib.Effect(hero.coord, hero.x, hero.y, 0, 1) then
    hero.vy = hero.vy + gravity*dt*60
    else
    hero.vy = 0
    end]]

    world:update(dt)



    --Debug draw
    hero.debug.x = hero.x + hero.vx*10 + hero.width/2
    hero.debug.y = hero.y + hero.vy*10 + hero.height/2

    hero.finalCoord = CollideLib.Tool.PosRelativeToAbsolute(hero.x, hero.y, hero.coord)

    for n = 1, #platforms do
        local platform = platforms[n]
        platform.finalCoord = CollideLib.Tool.PosRelativeToAbsolute(platform.x, platform.y, platform.coord)
    end

end


function love.draw()

    love.graphics.setBackgroundColor(1, 1, 1)
    love.graphics.setColor(0, 0, 0)

    love.graphics.polygon("line", hero.finalCoord)
    for n = 1, #platforms do
        love.graphics.polygon("line", platforms[n].finalCoord)
    end
    if point ~= nil then
        love.graphics.setColor(255, 0, 0)
        love.graphics.circle("fill", point.x, point.y, 5)
    end
    if pAx ~= nil then
        love.graphics.setColor(0, 0, 255)
        love.graphics.line(pAx, pAy, pBx, pBy)
    end

    love.graphics.setColor(0, 1, 0)
    love.graphics.line(hero.center.x + hero.x, hero.center.y + hero.y, hero.debug.x, hero.debug.y)


    love.graphics.setColor(0, 0, 0)
    love.graphics.print("fps: "..love.timer.getFPS(), 0, 0)
    love.graphics.print("vy: "..math.floor(hero.vy), 0, 12)

end

function hero:move(dt)

    local x, y = love.mouse.getPosition()

    --[[ Just having fun with the broken physics
    self.speed = 8

    --self.vx = self.speed*math.cos(math.angle(self.center.x + self.x, self.center.y + self.y, x, y))
    --self.vy = self.speed*math.sin(math.angle(self.center.x + self.x, self.center.y + self.y, x, y))

    self.vx = self.speed*math.cos(math.angle(600, 350, x, y))
    self.vy = self.speed*math.sin(math.angle(600, 350, x, y))
    ]]

    if love.keyboard.isDown(keys.right) then
        self.vx = self.speed
    end
    if love.keyboard.isDown(keys.left) then
        self.vx = -self.speed
    end
    if love.keyboard.isDown(keys.down) then
        self.vy = self.vy + self.jumpHeight/100
    end

    if love.keyboard.isDown("space") or love.keyboard.isDown(keys.up) then
        if not jumpPressed then
            self.vy = -self.jumpHeight
            jumpPressed = false
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
