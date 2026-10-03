local AllianceBaseSkill = require("DataCenter.AllianceSkill.AllianceBaseSkill")
local base = AllianceBaseSkill
local TeslaCoilSkill = BaseClass("TeslaCoilSkill", base)

function TeslaCoilSkill:Init()
  self.fireTime = self.aosEndTime
  self:SetTimeAction("updateObject", self.aosEndTime + 500, BindCallback(self, self.DoUpdateObject))
end

function TeslaCoilSkill:Clear()
  if CS.SceneManager.World and self.loopVfx then
    self:ReleaseSkillEffById(self.loopVfx)
    self.loopVfx = nil
  end
end

function TeslaCoilSkill:DoPlayEffect(effect)
  if effect.Tags == "end" then
    if self.loopVfx then
      self:ReleaseSkillEffById(self.loopVfx)
      self.loopVfx = nil
    end
    return self:PlaySkillEffBySelfPoint(effect.Path, effect.Duration, nil, true, true, nil, effect)
  elseif effect.Tags == "loop" then
    self.loopVfx = self:PlaySkillEffBySelfPoint(effect.Path, effect.Duration, self.effectGo or nil, false, false, nil, effect)
    return self.loopVfx
  else
    return base.DoPlayEffect(self, effect)
  end
end

function TeslaCoilSkill:NeedDisplayMode()
  return true
end

return TeslaCoilSkill
