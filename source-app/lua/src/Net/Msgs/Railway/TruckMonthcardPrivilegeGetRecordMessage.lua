local TruckMonthcardPrivilegeGetRecordMessage = BaseClass("TruckMonthcardPrivilegeGetRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage

function TruckMonthcardPrivilegeGetRecordMessage:OnCreate(param)
  base.OnCreate(self)
end

function TruckMonthcardPrivilegeGetRecordMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.RefreshTruckInsuranceHistoryPage, t.data)
  end
end

return TruckMonthcardPrivilegeGetRecordMessage
