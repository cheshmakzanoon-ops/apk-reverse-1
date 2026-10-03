local PushWorldEffObjUpdateMessage = BaseClass("PushWorldEffObjUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushWorldEffObjUpdateMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushWorldEffObjUpdateMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t and t.uuid then
    DataCenter.AllianceSkillManager:RefreshOneWarEffect(t)
  end
end

return PushWorldEffObjUpdateMessage
