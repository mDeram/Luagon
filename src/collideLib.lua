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
          value = CollideEffect(pCoord, pX, pY, newVx, prevVy)
          if value == -1 then
            value = CollideEffect(pCoord, pX, pY, prevVx, newVx)
            if value == - 1 then
              return prevVx, prevVy
            else
              local g
              for g = newVx, math.abs(pVx) do
                newVy = prevVy
                if pVx < 0 then
                  newVx = -g
                else
                  newVx = g
                end
                
                value = CollideEffect(pCoord, pX, pY, newVx, newVy)
                if value == -1 then
                  return prevVx, prevVy
                end
                prevVx = newVx
                prevVy = newVy
              end
            end
          else
            local g
            for g = newVy, math.abs(pVy) do
              print("a")
              newVx = prevVx
              if pVy < 0 then
                newVy = -g
              else
                newVy = g
              end
              value = CollideEffect(pCoord, pX, pY, newVx, newVy)
              if value == -1 then
                return prevVx, prevVy
              end
              prevVx = newVx
              prevVy = newVy
            end
          end
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
          value = CollideEffect(pCoord, pX, pY, prevVx, newVy)
          if value == -1 then
            value = CollideEffect(pCoord, pX, pY, newVx, prevVx)
            if value == - 1 then
              return prevVx, prevVy
            else
              local g
              for g = newVx, math.abs(pVx) do
                newVy = prevVy
                if pVx < 0 then
                  newVx = -g
                else
                  newVx = g
                end
                
                value = CollideEffect(pCoord, pX, pY, newVx, newVy)
                if value == -1 then
                  return prevVx, prevVy
                end
                prevVx = newVx
                prevVy = newVy
              end
            end
          else
            local g
            for g = newVy, math.abs(pVy) do
              print("b")
              newVx = prevVx
              if pVy < 0 then
                newVy = -g
              else
                newVy = g
              end
              value = CollideEffect(pCoord, pX, pY, newVx, newVy)
              if value == -1 then
                return prevVx, prevVy
              end
              prevVx = newVx
              prevVy = newVy
            end
          end
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
  for i = 1, objectLength/2 do
    object[2*i-1] = pCoord[2*i-1] + pX + pVx
    object[i*2] = pCoord[i*2] + pY + pVy
  end
  
  
  local j
  for j = 1, #platforms do
    
    platform = platforms[j]

    local length = #platform.coord
  
    local collider = {}
    local a
    for a = 1, length/2 do
      collider[2*a-1] = platform.coord[2*a-1] + platform.x
      collider[a*2] = platform.coord[a*2] + platform.y
    end
    
    local i
    for i = 1, objectLength/2 do
      
      local result = true
    
      --Pour chaque points du hero
      local sign = (collider[length - 1] - object[2*i-1])*(collider[2] - object[2*i]) - (collider[length] - object[2*i])*(collider[1] - object[2*i-1])
      
      local a
      for a = 1, length/2 - 1 do
        local calc = (collider[2*a-1] - object[2*i-1])*(collider[2+2*a] - object[2*i]) - (collider[2*a] - object[2*i])*(collider[1+2*a] - object[2*i-1])
        if not ((calc >= 0 and sign >= 0) or (calc < 0 and sign < 0)) then
          result = false
        end
      end
      
      if result then
        return -1
      end
    end
    
    
    local i
    for i = 1, length/2 do
      
      local result = true
      
      --Pour chaque points de la platforme
      local sign = (object[objectLength - 1] - collider[2*i-1])*(object[2] - collider[2*i]) - (object[objectLength] - collider[2*i])*(object[1] - collider[2*i-1])
      
      local a
      for a = 1, objectLength/2 - 1 do
        local calc = (object[2*a-1] - collider[2*i-1])*(object[2+2*a] - collider[2*i]) - (object[2*a] - collider[2*i])*(object[1+2*a] - collider[2*i-1])
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




function CollideBottom(pCoord, pX, pY)
  
  local objectLength = #pCoord

  local object = {}
  local i
  for i = 1, objectLength/2 do
    object[2*i-1] = pCoord[2*i-1] + pX
    object[i*2] = pCoord[i*2] + pY + 1
  end
  
  
  local j
  for j = 1, #platforms do
    
    platform = platforms[j]

    local length = #platform.coord
  
    local collider = {}
    local a
    for a = 1, length/2 do
      collider[2*a-1] = platform.coord[2*a-1] + platform.x
      collider[a*2] = platform.coord[a*2] + platform.y
    end
    
    local i
    for i = 1, objectLength/2 do
      
      local result = true
    
      --Pour chaque points du hero
      local sign = (collider[length - 1] - object[2*i-1])*(collider[2] - object[2*i]) - (collider[length] - object[2*i])*(collider[1] - object[2*i-1])
      
      local a
      for a = 1, length/2 - 1 do
        local calc = (collider[2*a-1] - object[2*i-1])*(collider[2+2*a] - object[2*i]) - (collider[2*a] - object[2*i])*(collider[1+2*a] - object[2*i-1])
        if not ((calc >= 0 and sign >= 0) or (calc < 0 and sign < 0)) then
          result = false
        end
      end
      
      if result then
        return true
      end
    end
    
    
    local i
    for i = 1, length/2 do
      
      local result = true
      
      --Pour chaque points de la platforme
      local sign = (object[objectLength - 1] - collider[2*i-1])*(object[2] - collider[2*i]) - (object[objectLength] - collider[2*i])*(object[1] - collider[2*i-1])
      
      local a
      for a = 1, objectLength/2 - 1 do
        local calc = (object[2*a-1] - collider[2*i-1])*(object[2+2*a] - collider[2*i]) - (object[2*a] - collider[2*i])*(object[1+2*a] - collider[2*i-1])
        if not ((calc >= 0 and sign >= 0) or (calc < 0 and sign < 0)) then
          result = false
        end
      end
      
      if result then
        return true
      end
    end
  end
  
  return false
  
end