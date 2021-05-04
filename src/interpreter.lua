local Interpreter = {}

function Interpreter.PolygonPoint(pCLength, pELength, pC, pE)
    for i = 1, pCLength, 2 do
        if CollideLib.Type.PolygonPoint(pELength, pC, pE, i) then
            return true
        end
    end
end

return Interpreter
