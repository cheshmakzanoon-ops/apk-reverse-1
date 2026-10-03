local PushMonthCardCardPrivilegeMessage = BaseClass("PushMonthCardCardPrivilegeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushMonthCardCardPrivilegeMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushMonthCardCardPrivilegeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.MonthCardNewManager:UpdateMonthCardPrivilege(t)
    EventManager:GetInstance():Broadcast(EventId.RefreshTruckInsuranceRefundPage)
  end
end

return PushMonthCardCardPrivilegeMessage
