local MemberUpStateUltimate = BaseClass("MemberUpStateUltimate")

function MemberUpStateUltimate:__init(unit)
  self.unit = unit
  self.target = nil
  self.isBuffSkill = nil
end

function MemberUpStateUltimate:__delete()
  self.unit = nil
  self.target = nil
  self.nextSkill = nil
end

function MemberUpStateUltimate:OnEnter()
  self.isFiring = false
  self.nextSkill = self.unit.skillManager:PrepareCastUltimate()
  self.isBuffSkill = self.nextSkill:IsBuffSkill()
  if self.isBuffSkill then
    self.unit.skillManager:ActiveCast(self.nextSkill, self.nextSkill:SearchTarget())
    if self.unit.unitType and self.unit.unitType == UnitType.TacticalWeapon then
      EventManager:GetInstance():Broadcast(EventId.OnPVETacticalWeaponCastSkill, self.nextSkill)
    end
  end
  if self.unit.unitType == nil or self.unit.unitType ~= UnitType.TacticalWeapon then
    local ultimateRingEffect = "Assets/_Art_LastWar/Effect/Prefab/UI/Common/Eff_world_hero_guangquan.prefab"
    local duration = self.unit:GetUltimateTimeStopDuration()
    self.unit.battleMgr:ShowEffectObj(ultimateRingEffect, nil, nil, duration, self.unit.transform)
  end
  if self.unit and not IsNull(self.unit.gameObject) then
    self.unit.gameObject.transform:DOScale(Vector3.New(1.25, 1.25, 1.25), 0.25):SetLoops(2, CS.DG.Tweening.LoopType.Yoyo)
  end
end

function MemberUpStateUltimate:OnExit()
  self.target = nil
  self.nextSkill = nil
end

function MemberUpStateUltimate:CheckDirection()
  if self.unit == self.target then
    return true
  end
  return PveUtil.CheckCannonLookAt(self.unit, self.target:GetPosition())
end

function MemberUpStateUltimate:OnUpdate()
  local curSkill = self.unit.skillManager:GetCastingSkill()
  if self.isBuffSkill then
    if curSkill then
    else
      EventManager:GetInstance():Broadcast(EventId.UltimateCastFinish, self.nextSkill.meta.id)
      self.unit.upFsm:ChangeState(AttackState.AutoAttack)
    end
  elseif not self.isFiring and not curSkill then
    if not self.target or self.target:GetCurBlood() <= 0 then
      self.target = self.nextSkill:SearchTargetPriorRange()
    elseif self:CheckDirection() then
      local targetPos = self.nextSkill:LegalizeTarget(self.target)
      self.unit.skillManager:ActiveCast(self.nextSkill, targetPos)
      self.isFiring = true
      if self.unit.unitType and self.unit.unitType == UnitType.TacticalWeapon then
        EventManager:GetInstance():Broadcast(EventId.OnPVETacticalWeaponCastSkill, self.nextSkill)
      end
    end
  elseif self.isFiring and curSkill then
    if self.target and self.target:GetCurBlood() > 0 then
      self:CheckDirection()
    else
      self.target = self.nextSkill:SearchTargetPriorRange()
    end
  else
    EventManager:GetInstance():Broadcast(EventId.UltimateCastFinish, self.nextSkill.meta.id)
    self.unit.upFsm:ChangeState(AttackState.AutoAttack)
  end
end

return MemberUpStateUltimate
