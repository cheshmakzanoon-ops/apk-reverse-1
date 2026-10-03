local PushWorldEffectAlterAddMessage = BaseClass("PushWorldEffectAlterAddMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushWorldEffectAlterAddMessage:OnCreate()
  base.OnCreate(self)
end

function PushWorldEffectAlterAddMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode == nil then
    DataCenter.AllianceSkillManager:AddEffectAlter(t)
  end
end

return PushWorldEffectAlterAddMessage
