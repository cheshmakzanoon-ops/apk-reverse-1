local PushSkillElectricHurtEffectMessage = BaseClass("PushSkillElectricHurtEffectMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushSkillElectricHurtEffectMessage:OnCreate()
  base.OnCreate(self)
end

function PushSkillElectricHurtEffectMessage:HandleMessage(t)
  base.HandleMessage(self, t)
end

return PushSkillElectricHurtEffectMessage
