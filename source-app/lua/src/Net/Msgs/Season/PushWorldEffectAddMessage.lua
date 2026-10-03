local PushWorldEffectAddMessage = BaseClass("PushWorldEffectAddMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushWorldEffectAddMessage:OnCreate()
  base.OnCreate(self)
end

function PushWorldEffectAddMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t and t.uuid and SceneUtils.GetIsInWorld() then
    DataCenter.AllianceSkillManager:CreateWarEffect(nil, t)
  end
end

return PushWorldEffectAddMessage
