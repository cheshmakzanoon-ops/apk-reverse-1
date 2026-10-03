local AllianceBaseSkillTarget = require("DataCenter.AllianceSkill.AllianceBaseSkillTarget")
local base = AllianceBaseSkillTarget
local TeslaCoilSkillAlertEff = BaseClass("TeslaCoilSkillAlertEff", base)

function TeslaCoilSkillAlertEff:Init()
  self.info = CS.SceneManager.World:GetPointInfo(self.data.pointId)
  if not IsNull(self.info) then
    self.fireTime = toInt(self.info.aosEndTime) - 1000
    self:CacAttackEffectTimes()
  end
end

function TeslaCoilSkillAlertEff:Clear()
  if self.delay1 then
    self.delay1:Stop()
    self.delay1 = nil
  end
end

function TeslaCoilSkillAlertEff:OnTickSec(theWorld)
  if not self:TickAoi(theWorld) then
    return
  end
end

function TeslaCoilSkillAlertEff:LodChange()
  if self.NameText and not IsNull(self.NameLabel) then
    if self.theLod > 4 then
      self.NameLabel.transform:Set_localScale(0, 0, 0)
    else
      self.NameLabel.transform:Set_localScale(0.5, 0.5, 0.5)
    end
  end
  if self.theLod > 2 then
    self:ReleaseSkillEff()
  end
end

function TeslaCoilSkillAlertEff:CacAttackEffectTimes()
  self.attackTimes = {}
  if self.skillConfig then
    local now = UITimeManager:GetInstance():GetServerTime()
    local attackInv = self.skillConfig.skill_para8 * 1000
    local duration = now - self.info.aosStartTime
    if duration < 1000 then
      self:PlayAttackEffect()
    end
    local attackCount = duration / attackInv
    local nextAttackTime = math.ceil(attackCount) * attackInv
    local nextToPlayAttack = self.info.aosStartTime + nextAttackTime
    while nextToPlayAttack < self.fireTime do
      table.insert(self.attackTimes, nextToPlayAttack - 500)
      nextToPlayAttack = nextToPlayAttack + attackInv
    end
  end
  if table.count(self.attackTimes) > 0 then
    for index, v in ipairs(self.attackTimes) do
      self:SetTimeAction("attack" .. index, v, BindCallback(self, self.PlayAttackEffect))
    end
  end
end

function TeslaCoilSkillAlertEff:PlayAttackEffect()
  if self.theLod ~= nil and self.theLod > 2 then
    return
  end
  local xuliEffect = self.unityConfig:GetSkillEffectByTags("xuli")
  if xuliEffect then
    self:PlaySkillEff(self.info.mainIndex, xuliEffect.Path, xuliEffect.Duration, nil, true, false, nil, xuliEffect)
  end
  local circleEffect = self.unityConfig:GetSkillEffectByTags("circle")
  if circleEffect then
    self.delay1 = TimerManager:GetInstance():DelayInvoke(function()
      self:PlaySkillEff(self.info.mainIndex, circleEffect.Path, circleEffect.Duration, nil, true, false, function(go)
        local bao_zha_scale = self.data.radius / 10 + 0.1
        if not IsNull(go) then
          go.transform:GetChild(0):Set_localScale(bao_zha_scale, bao_zha_scale, bao_zha_scale)
        end
      end, circleEffect)
    end, 0.2)
  end
end

function TeslaCoilSkillAlertEff:NeedDisplayMode()
  return true
end

return TeslaCoilSkillAlertEff
