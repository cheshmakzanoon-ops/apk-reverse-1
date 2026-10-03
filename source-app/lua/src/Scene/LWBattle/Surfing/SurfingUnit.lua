local base = require("Scene.LWBattle.UnitBase")
local SurfingUnit = BaseClass("SurfingUnit", base)

function SurfingUnit:Init(logic, localPos)
  base.Init(self, logic)
  self.guid = logic:AllotUnitGuid()
end

return SurfingUnit
