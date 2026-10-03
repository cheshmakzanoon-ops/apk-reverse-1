local PushWorldEffectDelMessage = BaseClass("PushWorldEffectDelMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushWorldEffectDelMessage:OnCreate()
  base.OnCreate(self)
end

function PushWorldEffectDelMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t and t.uuid then
    DataCenter.AllianceSkillManager:RemoveWarEffect(nil, t)
  end
end

return PushWorldEffectDelMessage
