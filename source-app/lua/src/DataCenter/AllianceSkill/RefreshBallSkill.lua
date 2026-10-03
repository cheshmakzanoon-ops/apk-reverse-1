local AllianceBaseSkill = require("DataCenter.AllianceSkill.AllianceBaseSkill")
local base = AllianceBaseSkill
local RefreshBallSkill = BaseClass("RefreshBallSkill", base)

function RefreshBallSkill:LodChange()
  if self.theLod > 2 then
    self:ReleaseSkillEff()
  end
end

function RefreshBallSkill:DoPlayEffect(effect)
  if effect.Tags == "start" then
    self:PlaySkillEffBySelfPoint(effect.Path, effect.Duration, nil, false, false, nil, effect)
  else
    base.DoPlayEffect(self, effect)
  end
end

return RefreshBallSkill
