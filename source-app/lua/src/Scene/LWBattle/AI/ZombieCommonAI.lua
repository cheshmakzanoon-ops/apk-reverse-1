local ZombieCommonAI = BaseClass("ZombieCommonAI")

function ZombieCommonAI:Init(unit)
  self.unit = unit
end

function ZombieCommonAI:__delete()
  self.unit = nil
end

function ZombieCommonAI:GetTarget(skill, preTarget)
  if skill:IsNormalAttack() then
    local tauntTarget = self.unit:GetTauntTarget()
    if tauntTarget then
      return tauntTarget
    end
  end
  local ret = preTarget
  if nil == ret then
    ret = skill:SearchTargetIgnoreRange()
  end
  return ret
end

function ZombieCommonAI:GetTargetTauntFirst(skill)
  local target = skill:SearchTargetIgnoreRange(nil, nil, true)
  if target ~= nil then
    return target
  end
  return self:GetTarget(skill)
end

return ZombieCommonAI
