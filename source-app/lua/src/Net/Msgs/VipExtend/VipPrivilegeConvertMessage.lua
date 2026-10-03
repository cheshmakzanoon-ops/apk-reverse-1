local VipPrivilegeConvertMessage = BaseClass("VipPrivilegeConvertMessage", SFSBaseMessage)
local base = SFSBaseMessage

function VipPrivilegeConvertMessage:OnCreate(param)
  base.OnCreate(self)
end

function VipPrivilegeConvertMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    UIUtil.ShowTipsId(120120)
    EventManager:GetInstance():Broadcast(EventId.VipExtendCityPrivilegeConvert)
    DataCenter.VipExtendManager:LoadInitialHistory()
  end
end

return VipPrivilegeConvertMessage
