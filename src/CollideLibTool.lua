local Tool = {}

function Tool.CopyTable(pTable, addX, addY)
  local table = {}
  local i
  for i = 1, #pTable, 2 do
    table[i] = pTable[i] + addX
    table[i+1] = pTable[i+1] + addY
  end
  return table
end

function Tool.EqualityRounded(pNumber1, pNumber2, pRounded)
  if pNumber1 == pNumber2 then return true end
  local r = math.abs(pRounded)
  if pNumber1 - r < pNumber2 and pNumber1 + r > pNumber2 then return true end
  return false
end

function Tool.CornerStraight(x1, y1,  x2, y2,  x3, y3,  x4, y4)
  local resultA = math.angle(x1, y1, x2, y2)
  local resultB = math.angle(x3, y3, x4, y4)
  return math.abs((resultB - resultA)%math.pi)
end

return Tool