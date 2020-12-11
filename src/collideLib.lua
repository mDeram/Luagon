function Collide(pCoord, pX, pY, pVx, pVy, pLastVx, pLastVy, pStop)
  
  local value
  local prevVx = 0
  local prevVy = 0
  
  --if pStop then
    --Vérification anti blocage
    --Utilisation de last vx et last vy
    
  --else
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
        
        value = CollideEffect(pCoord, pX, pY, newVx, newVy)
        if value == -1 then
          return prevVx, prevVy, true
        end
        prevVx = newVx
        prevVy = newVy
        
      end
      
    end
    
    value = CollideEffect(pCoord, pX, pY, pVx, pVy)
    
    if value == -1 then
      return prevVx, prevVy, true
    elseif value == 0 then
      return pVx, pVy, false
    end
  --end
  
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
      return -1
    end
    if CollidePolygon(length, objectLength, collider, object) == -1 then
      return -1
    end
    
  end
  return 0
end


function CollidePolygon(pCLength, pELength, pC, pE)
  local i
  for i = 1, pCLength, 2 do
    
    local result = true
    
    --Pour chaque points de la platforme
    local sign = (pE[pELength - 1] - pC[i])*(pE[2] - pC[i+1]) - (pE[pELength] - pC[i+1])*(pE[1] - pC[i])
    
    local a
    for a = 1, pELength-2, 2 do
      local calc
      if a ~= pELength - 1 then
        calc = (pE[a] - pC[i])*(pE[a+3] - pC[i+1]) - (pE[a+1] - pC[i+1])*(pE[a+2] - pC[i])
      end
      if not ((calc >= 0 and sign >= 0) or (calc < 0 and sign < 0)) then
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