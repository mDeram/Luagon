
--little comment with the email (after)
function CollideContact(pCoord, pX, pY, pVx, pVy, pLastVx, pLastVy, polygon)
  
  local i, j, object, collider, segment, angleA, angleB, angle, aX, aY, bX, bY
  
  -- ! Faire ça pour object avec pX ou pY + - 1 (en fonction de lastvx, vy
  object = copyTable(pCoord, pX, pY+2)
  collider = copyTable(polygon.coord, polygon.x, polygon.y)
  segment = false
  aX, aY, bX, bY = pX-pLastVx, pY-pLastVy, pX, pY
  angleA = math.angle(aX, aY,  bX, bY)
  
  
  local aX, aY, bX, bY
  for i = 1, #object do
    for j = 1, #collider-2, 2 do
      if collider[j] > collider[j+2] then 
        aX = collider[j+2]
        bX = collider[j]
      else 
        aX = collider[j]
        bX = collider[j+2]
      end
      if collider[j+1] > collider[j+3] then 
        aY = collider[j+3]
        bY = collider[j+1]
      else 
        aY = collider[j+1]
        bY = collider[j+3]
      end
      
      if object[i] > aX and object[i] < bX and object[i+1] > aY and object[i+1] < bY then
        segment = true
        print("ok")
        break
      end
    end
  end
  
  if not segment then
    for i = 1, #collider do
      for j = 1, #object-2, 2 do
        if object[j] > object[j+2] then 
          aX = object[j+2]
          bX = object[j]
        else 
          aX = object[j]
          bX = object[j+2]
        end
        if object[j+1] > object[j+3] then 
          aY = object[j+3]
          bY = object[j+1]
        else 
          aY = object[j+1]
          bY = object[j+3]
        end
        if collider[i] > aX and collider[i] < bX and collider[i+1] > aY and collider[i+1] < bY then
          print("ok2")
          segment = true
          break
        end
      end
    end
  end
  
  if not segment then
    error("no collision with segment")
  end
  
  angleB = math.angle(aX, aY,  bX, bY)
  
  angle = angleA - angleB
  print(angle)
  
  
  --application de vx, vy
  
  
  --return -, -, false
  
end

function Collide(pCoord, pX, pY, pVx, pVy)
  
  local value, polygon
  local prevVx = 0
  local prevVy = 0
  
    if math.abs(pVx) > 1 or math.abs(pVy) > 1 then
      
      local bigger
      if math.abs(pVx) > math.abs(pVy) then bigger = pVx else bigger = pVy end
      
      local f
      for f = 1, math.abs(bigger) do
        
        local newVx, newVy
        if bigger == pVx then
          newVy = f*(pVy/math.abs(pVx))
          if pVx < 0 then newVx = -f else newVx = f end
        else
          newVx = f*(pVx/math.abs(pVy))
          if pVy < 0 then newVy = -f else newVy = f end
        end
        
        
        value, polygon = CollideEffect(pCoord, pX, pY, newVx, newVy)
        if value == -1 then
          return prevVx, prevVy, true, polygon
        end
        prevVx = newVx
        prevVy = newVy
        
      end
    end
    
    
    value, polygon = CollideEffect(pCoord, pX, pY, pVx, pVy)
    
    if value == -1 then
      return prevVx, prevVy, true, polygon
    elseif value == 0 then
      return pVx, pVy, false
    end
  
end


function CollideEffect(pCoord, pX, pY, pVx, pVy)
  local objectLength = #pCoord

  local object = copyTable(pCoord, pX + pVx, pY + pVy)
  
  local j
  for j = 1, #platforms do
    platform = platforms[j]
    local length = #platform.coord
  
  
    local collider = copyTable(platform.coord, platform.x, platform.y)
    
    if CollidePolygon(objectLength, length, object, collider) == -1 then
      return -1, platform
    end
    if CollidePolygon(length, objectLength, collider, object) == -1 then
      return -1, platform
    end
    
  end
  return 0
end


function CollidePolygon(pCLength, pELength, pC, pE)
  local i
  for i = 1, pCLength, 2 do
    
    local result = true
    local segment = {}
    
    --Pour chaque points de la platforme
    local sign = (pE[pELength - 1] - pC[i])*(pE[2] - pC[i+1]) - (pE[pELength] - pC[i+1])*(pE[1] - pC[i])
    
    local a
    for a = 1, pELength-2, 2 do
      local calc
      if a ~= pELength - 1 then
        calc = (pE[a] - pC[i])*(pE[a+3] - pC[i+1]) - (pE[a+1] - pC[i+1])*(pE[a+2] - pC[i])
      end
      --if not ((calc >= 0 and sign >= 0) or (calc <= 0 and sign <= 0)) then à gauche ou à droite
      if not (calc >= 0 and sign >= 0)then
        result = false
      end
    end
    
    if result then
      return -1
    end
  end
end


function copyTable(pTable, addX, addY)
  local table = {}
  local i
  for i = 1, #pTable, 2 do
    table[i] = pTable[i] + addX
    table[i+1] = pTable[i+1] + addY
  end
  return table
end