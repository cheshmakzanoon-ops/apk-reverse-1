local SkillBase = BaseClass("SkillBase")

function SkillBase:__init()
  self.m_callback = nil
end

function SkillBase:DoAttack(actionItem, callback)
  self.m_actionItem = actionItem
  self.m_callback = callback
end

function SkillBase:DoNext(isSpecialSkill)
  if PveActorMgr:GetInstance():IsStopPlay() then
    if self.m_atkModelObj ~= nil then
      self.m_atkModelObj:PlayStopFire()
    end
    self:DoCallback()
    return
  end
  local time = 2.5
  if isSpecialSkill then
    time = 1
  end
  local speed = PveActorMgr:GetInstance():GetSpeed()
  TimerManager:GetInstance():DelayInvoke(function()
    if self.m_atkModelObj ~= nil then
      self.m_atkModelObj:PlayStopFire()
    end
    self:DoCallback()
  end, time * speed)
end

function SkillBase:DoCallback()
  if self.m_callback ~= nil then
    self.m_callback()
  end
end

return SkillBase
