local Interpreter = {}


function Interpreter.AABBPoint(boxX1, boxY1,  boxX2, boxY2, x1, y1)
  
  local aX, aY, bX, bY
  local collide = 1
  
  if boxX1 == boxX2 then --vertical
    collide = 2
  elseif boxY1 == boxY2 then --horizontal
    collide = 3
  end
  
  if collide ~= 2 then
    if boxX1 < boxX2 then
      aX = boxX1
      bX = boxX2
    else
      aX = boxX2
      bX = boxX1
    end
  end
  
  if collide ~= 3 then
    if boxY1 < boxY2 then
      aY = boxY1
      bY = boxY2
    else
      aY = boxY2
      bY = boxY1
    end
  end
  
  if collide == 1 then
    
    if CollideLib.Type.AABBPoint(aX, aY, bX, bY, x1, y1) then
      return true, boxX1, boxY1,  boxX2, boxY2
    else
      return false
    end
    
  elseif collide == 2 then -- vertical
    
    if CollideLib.Tool.EqualityRounded(x1, boxX1, 1) then
      if y1 > aY and y1 < bY then
        return true, boxX1, boxY1,  boxX2, boxY2
      end
    else
      return false
    end
    
  elseif collide == 3 then --horizontal
    
    if CollideLib.Tool.EqualityRounded(y1, boxY1, 1) then
      if x1 > aX and x1 < bX then
        return true, boxX1, boxY1,  boxX2, boxY2
      end
    else
      return false
    end
  end
  
end



function Interpreter.PolygonPoint(pCLength, pELength, pC, pE)
  local i
  for i = 1, pCLength, 2 do
    if CollideLib.Type.PolygonPoint(pELength, pC, pE, i) then
      return true
    end
  end
end



return Interpreter