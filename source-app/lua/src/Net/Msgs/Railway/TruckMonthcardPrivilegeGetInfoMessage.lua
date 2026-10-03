local TruckMonthcardPrivilegeGetInfoMessage = BaseClass("TruckMonthcardPrivilegeGetInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function TruckMonthcardPrivilegeGetInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function TruckMonthcardPrivilegeGetInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.MonthCardNewManager:UpdateMonthCardPrivilege(t)
    EventManager:GetInstance():Broadcast(EventId.RefreshTruckInsuranceRefundPage)
  end
end

return TruckMonthcardPrivilegeGetInfoMessage
