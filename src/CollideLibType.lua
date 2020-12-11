local Type = {}

function Type.AABBPoint(x1, y1,  x2, y2,  x3, y3)
  
  if x3 > x1 and x3 < x2 and y3 > y1 and y3 < y2 then
    return true
  else
    return false
  end
  
end


function Type.PolygonPoint(pELength, pC, pE, i)
  
  local calc = (pE[pELength-1] - pC[i])*(pE[2] - pC[i+1]) - (pE[pELength] - pC[i+1])*(pE[1] - pC[i])
  if calc < 0 then 
    return false
  end
  
  local a
  for a = 1, pELength-2, 2 do
    local calc
    calc = (pE[a] - pC[i])*(pE[a+3] - pC[i+1]) - (pE[a+1] - pC[i+1])*(pE[a+2] - pC[i])
    if calc < 0 then
      return false
    end
  end
  
  return true
  
end


return Type