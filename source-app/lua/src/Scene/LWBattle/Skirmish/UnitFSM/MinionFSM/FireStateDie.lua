local FireStateDie = BaseClass("FireStateDie")

function FireStateDie:__init(unit)
  self.unit = unit
  self.animLength = self.unit:GetAnimLength(MemberAnim.Dead)
  self.animLength = self.animLength > 0 and self.animLength or 2
end

function FireStateDie:__delete()
  self.unit = nil
end

function FireStateDie:OnEnter()
  self.unit:RewindAndPlaySimpleAnim(MemberAnim.Dead)
  self.unit.transform:SetParent(nil)
  self.timer = self.animLength
end

function FireStateDie:OnExit()
end

function FireStateDie:OnUpdate()
  if self.timer >= 0 then
    self.timer = self.timer - Time.deltaTime
    if self.timer < 0 then
      self.unit:ShowOrHide(false)
    end
  end
end

return FireStateDie
