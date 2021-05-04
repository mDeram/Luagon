local relative_path = string.gsub((...), "/.+$", "/");

world = {}
CollideLib = {}
CollideLib.Type = require(relative_path.."type")
CollideLib.Tool = require(relative_path.."tool")
CollideLib.Interpreter = require(relative_path.."interpreter")


function world:update(dt)
    if hero.vx ~= 0 or hero.vy ~= 0 then
        CollideLib.Collide(hero, hero.coord, hero.x, hero.y, hero.vx, hero.vy, dt)
    end
end

function CollideLib.Collide(pTable, pCoord, pX, pY, pVx, pVy, dt)

    local deltaVx, deltaVy, prevVx, prevVy = 0, 0, 0, 0
    if pVx ~= 0 then deltaVx = pVx*60*dt end
    if pVy ~= 0 then deltaVy = pVy*60*dt end

    if math.abs(deltaVx) > 1 or math.abs(deltaVy) > 1 then

        local bigger
        if math.abs(deltaVx) > math.abs(deltaVy) then bigger = deltaVx else bigger = deltaVy end

        local f
        for f = 1, math.abs(bigger) do

            local newVx, newVy
            if bigger == deltaVx then
                newVy = f*(deltaVy/math.abs(deltaVx))
                if deltaVx < 0 then newVx = -f else newVx = f end
            else
                newVx = f*(deltaVx/math.abs(deltaVy))
                if deltaVy < 0 then newVy = -f else newVy = f end
            end

            if CollideLib.Effect(pCoord, pX, pY, newVx, newVy, false) then
                CollideLib.Contact(pTable, pCoord, pX, pY, newVx, newVy)
                --pTable.x = pTable.x + prevVx
                --pTable.y = pTable.y + prevVy
                pTable.x = pTable.x + pTable.vx
                pTable.y = pTable.y + pTable.vy
                return "ok"
            end
            prevVx = newVx
            prevVy = newVy
        end
    end


    if CollideLib.Effect(pCoord, pX, pY, deltaVx, deltaVy, false) then
        CollideLib.Contact(pTable, pCoord, pX, pY, deltaVx, deltaVy)
        pTable.x = pTable.x + pTable.vx
        pTable.y = pTable.y + pTable.vy
        return "ok"
    else
        pTable.x = pTable.x + deltaVx
        pTable.y = pTable.y + deltaVy
        return "ok"
    end

    print("New message: From Collide in luagon.lua \"Something that should not happen just happened, sorry\"")

end

function CollideLib.Contact(pTable, pCoord, pX, pY, pContactVx, pContactVy)

    local result, heroContact, polygonContact = CollideLib.Effect(pCoord, pX, pY, pContactVx, pContactVy, true)

    if result then
        pTable.vx = 0
        pTable.vy = 0
    end

end


function CollideLib.Effect(pCoord, pX, pY, pVx, pVy, pComplete)

    local toReturn = false
    local polygonContact = {}
    local heroContact = {}

    local objectLength = #pCoord
    local object = CollideLib.Tool.PosRelativeToAbsolute(pX + pVx, pY + pVy, pCoord)

    local j
    for j = 1, #platforms do
        platform = platforms[j]
        local length = #platform.coord

        local collider = CollideLib.Tool.PosRelativeToAbsolute(platform.x, platform.y, platform.coord)

        --collide sprite coord
        if CollideLib.Interpreter.PolygonPoint(objectLength, length, object, collider) then
            if pComplete then
                toReturn = true
                heroContact[#heroContact+1] = platform
            else
                return true
            end
        end

        --collide platform coord
        if CollideLib.Interpreter.PolygonPoint(length, objectLength, collider, object) then
            if pComplete then
                toReturn = true
                polygonContact[#polygonContact+1] = platform
            else
                return true
            end
        end

    end

    return toReturn, heroContact, polygonContact

end

return world
