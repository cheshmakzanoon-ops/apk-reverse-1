local AllianceBaseSkill = require("DataCenter.AllianceSkill.AllianceBaseSkill")
local base = AllianceBaseSkill
local ReinforcementSkill = BaseClass("ReinforcementSkill", AllianceBaseSkill)

function ReinforcementSkill:LodChange(lod)
  self.theLod = toInt(lod)
  if self.theLod > 2 then
    self:ReleaseSkillEff()
  end
end

return ReinforcementSkill
