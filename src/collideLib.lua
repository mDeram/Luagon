function Collide(pCoord, pX, pY, pVx, pVy)
  
  local value
  local prevVx = 0
  local prevVy = 0

  if math.abs(pVx) >= 1 or math.abs(pVy) >= 1 then
    
    if math.abs(pVx) > math.abs(pVy) then
      
      local f
      for f = 1, math.abs(pVx) do
        local newVx
        if pVx < 0 then
          newVx = -f
        else
          newVx = f
        end
        local newVy = f*(pVy/math.abs(pVx))
        value = CollideEffect(pCoord, pX, pY, newVx, newVy)
        if value == -1 then
          return prevVx, prevVy
        end
        prevVx = newVx
        prevVy = newVy
      end
      
    else
      
      local f
      for f = 1, math.abs(pVy) do
        local newVx = f*(pVx/math.abs(pVy))
        local newVy
        if pVy < 0 then
          newVy = -f
        else
          newVy = f
        end
        value = CollideEffect(pCoord, pX, pY, newVx, newVy)
        if value == -1 then
          return prevVx, prevVy
        end
        prevVx = newVx
        prevVy = newVy
      end
      
    end
    
  end
  
  value = CollideEffect(pCoord, pX, pY, pVx, pVy)
  
  if value == -1 then
    return prevVx, prevVy
  elseif value == 0 then
    return pVx, pVy
  end
  
end




function CollideEffect(pCoord, pX, pY, pVx, pVy)
  
  local objectLength = #pCoord

  local object = {}
  local i
  for i = 1, objectLength, 2 do
    object[i] = pCoord[i] + pX + pVx
    object[i+1] = pCoord[i+1] + pY + pVy
  end
  
  
  local j
  for j = 1, #platforms do
    
    platform = platforms[j]

    local length = #platform.coord
  
    local collider = {}
    local a
    for a = 1, length, 2 do
      collider[a] = platform.coord[a] + platform.x
      collider[a+1] = platform.coord[a+1] + platform.y
    end
    
    local i
    for i = 1, objectLength, 2 do
      
      local result = true
    
      --Pour chaque points du hero
      local sign = (collider[length - 1] - object[i])*(collider[2] - object[i+1]) - (collider[length] - object[i+1])*(collider[1] - object[i])
      
      local a
      for a = 1, length-2, 2 do
        local calc
        if a ~= length - 1 then
          calc = (collider[a] - object[i])*(collider[a+3] - object[i+1]) - (collider[a+1] - object[i+1])*(collider[a+2] - object[i])
        end
        if not ((calc >= 0 and sign >= 0) or (calc < 0 and sign < 0)) then
          result = false
        end
      end
      
      if result then
        return -1
      end
    end
    
    
    local i
    for i = 1, length, 2 do
      
      local result = true
      
      --Pour chaque points de la platforme
      local sign = (object[objectLength - 1] - collider[i])*(object[2] - collider[i+1]) - (object[objectLength] - collider[i+1])*(object[1] - collider[i])
      local a
      for a = 1, objectLength-2, 2 do
        local calc
        if a ~= objectLength - 1 then
          calc = (object[a] - collider[i])*(object[a+3] - collider[i+1]) - (object[a+1] - collider[i+1])*(object[a+2] - collider[i])
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
  
  return 0
  
end