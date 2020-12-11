world = {}
CollideLib = {}
CollideLib.Type = require("CollideLibType")
CollideLib.Tool = require("CollideLibTool")
CollideLib.Interpreter = require("CollideLibInterpreter")


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
        pTable.x = pTable.x + prevVx
        pTable.y = pTable.y + prevVy
        return "ok"
      end
      prevVx = newVx
      prevVy = newVy
    end
  end
  
  
  if CollideLib.Effect(pCoord, pX, pY, deltaVx, deltaVy, false) then
    CollideLib.Contact(pTable, pCoord, pX, pY, deltaVx, deltaVy)
    pTable.x = pTable.x + prevVx
    pTable.y = pTable.y + prevVy
    return "ok"
  else
    pTable.x = pTable.x + deltaVx
    pTable.y = pTable.y + deltaVy
    return "ok"
  end
  print("oui")
end

function CollideLib.Contact(pTable, pCoord, pX, pY, pContactVx, pContactVy)
  --[[
  Calcule de vx et vy avec le calcule d'angle et la friction et les polygones en contacte
  
    Récupération de tout les polygones en contact
    Calcule de l'angle
    Calcule de vx et vy
    Ajout de la variable "friction" au héro (il l'utilise que si elle ne vaut pas nil, sinon il prend sa valeur stoqué par défaut)
  ]]
  local result, heroContact, polygonContact = CollideLib.Effect(pCoord, pX, pY, pContactVx, pContactVy, true)

  if result then
    
    --To avoid bug
    if not (#heroContact >= 1 and #polygonContact >= 1) then
      
      
      local cLength, eLength, c, e
      
      if #heroContact < 1 then --Regarde uniquement pour les segment du sprite
        eLength = #pCoord
        e = CollideLib.Tool.CopyTable(pCoord, pX + pContactVx, pY + pContactVy)
        
        cLength = #polygonContact[1].coord
        c = CollideLib.Tool.CopyTable(polygonContact[1].coord, polygonContact[1].x, polygonContact[1].y)
      elseif #polygonContact < 1 then --Regarde uniquement pour les segment du polygon
        cLength = #pCoord
        c = CollideLib.Tool.CopyTable(pCoord, pX + pContactVx, pY + pContactVy)
        
        eLength = #heroContact[1].coord
        e = CollideLib.Tool.CopyTable(heroContact[1].coord, heroContact[1].x, heroContact[1].y)
      end
      
      
      
      --Recherche du point en contact
      
      local i
      for i = 1, cLength, 2 do
        
        local result = true
        
        local calc = (e[eLength - 1] - c[i])*(e[2] - c[i+1]) - (e[eLength] - c[i+1])*(e[1] - c[i])
        if calc < 0 then
          result = false
        end
      
        local a
        for a = 1, eLength-2, 2 do
          local calc
          calc = (e[a] - c[i])*(e[a+3] - c[i+1]) - (e[a+1] - c[i+1])*(e[a+2] - c[i])
          if calc < 0 then
            result = false
          end
        end
        
        if result then
          point = {}
          point.x = c[i]
          point.y = c[i+1]
          break
        end
        
      end
      
      --AABB :
      
      --Coordonné segment
      local result, A, B, C, D = CollideLib.Interpreter.AABBPoint(e[eLength-1], e[eLength], e[1], e[2], point.x, point.y)
      if result then
        pAx, pAy, pBx, pBy = A, B, C, D
      end
      
      local i
      for i = 1, eLength-2, 2 do
        --Coordonné segment
        local result, A, B, C, D = CollideLib.Interpreter.AABBPoint(e[i], e[i+1], e[i+2], e[i+3], point.x, point.y)
        if result then
          pAx, pAy, pBx, pBy = A, B, C, D
        end
        
      end
      
      pCx = pX
      pCy = pY
      pDx = pX + pTable.vx
      pDy = pY + pTable.vy
      
      local result = CollideLib.Tool.CornerStraight(pAx, pAy, pBx, pBy, pCx, pCy, pDx, pDy)
      if result == math.pi/2 then
        pTable.vx = 0
        pTable.vy = 0
      elseif result < math.pi/2 then
        pTable.vx = math.cos(math.pi/2-result)*pTable.vx
        --pTable.vy = math.sin(math.pi/2-result)*pTable.vy
        pTable.vy = 0
      elseif result > math.pi/2 then
        pTable.vx = -math.cos(-math.pi/2-result)*pTable.vx
        --pTable.vy = math.sin(-math.pi/2-result)*pTable.vy
        pTable.vy = 0
      end
      
      --print(pTable.vx)
      --print(pTable.vy)
    else
      print("Double contact")
    end
    
  end
  
end


function CollideLib.Effect(pCoord, pX, pY, pVx, pVy, pComplete)
  
  local toReturn = false
  local polygonContact = {}
  local heroContact = {}
  
  local objectLength = #pCoord
  local object = CollideLib.Tool.CopyTable(pCoord, pX + pVx, pY + pVy)
  
  local j
  for j = 1, #platforms do
    platform = platforms[j]
    local length = #platform.coord
  
    local collider = CollideLib.Tool.CopyTable(platform.coord, platform.x, platform.y)
    
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