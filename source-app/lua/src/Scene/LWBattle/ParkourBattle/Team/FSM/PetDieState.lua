local PetDieState = BaseClass("PetDieState")

function PetDieState:__init(unit)
  self.unit = unit
  self.animLength = self.unit:GetAnimLength("dead")
  self.animLength = self.animLength > 0 and self.animLength or 0.01
end

function PetDieState:__delete()
  self.unit = nil
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

function PetDieState:OnEnter()
  if self.unit.ClearBornTween then
    self.unit:ClearBornTween()
  end
  self.unit:RewindAndPlaySimpleAnim("dead")
  if self.unit.HideHpBar then
    self.unit:HideHpBar()
  end
  self.unit.transform:SetParent(nil)
  if self.unit.team then
    self.unit.team:RemoveMemberWithoutUnit(self.unit)
  end
  self.unit.logic:OnMemberDeath(self.unit)
  self.timer = TimerManager:DelayInvoke(function()
    self.unit.logic:RemoveUnit(self.unit.guid)
  end, self.animLength)
end

function PetDieState:OnExit()
end

function PetDieState:OnUpdate()
end

return PetDieState
