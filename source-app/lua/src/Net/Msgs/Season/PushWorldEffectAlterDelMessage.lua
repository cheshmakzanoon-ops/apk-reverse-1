local PushWorldEffectAlterDelMessage = BaseClass("PushWorldEffectAlterDelMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushWorldEffectAlterDelMessage:OnCreate()
  base.OnCreate(self)
end

function PushWorldEffectAlterDelMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode == nil then
    DataCenter.AllianceSkillManager:RemoveEffectAlter(t.uuid)
  end
end

return PushWorldEffectAlterDelMessage
