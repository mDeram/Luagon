function Collide(pTable, pObject)
  
  local result = true
  local length = #pTable.pos
  
  local collider = {}
  local i
  for i = 1, length/2 do
    collider[1+2*(i-1)] = pTable.pos[1+2*(i-1)] + pTable.x
    collider[i*2] = pTable.pos[i*2] + pTable.y
  end
  
  local sign = (collider[length - 1] - pObject.x)*(collider[2] - pObject.y) - (collider[length] - pObject.y)*(collider[1] - pObject.x)
  
  local i
  for i = 1, length/2 - 1 do
    local calc = (collider[1+2*(i-1)] - pObject.x)*(collider[2+2*i] - pObject.y) - (collider[2*i] - pObject.y)*(collider[1+2*i] - pObject.x)
    if not ((calc >= 0 and sign >= 0) or (calc < 0 and sign < 0)) then
      result = false
      break
    end
  end  
  
  return result
  
end