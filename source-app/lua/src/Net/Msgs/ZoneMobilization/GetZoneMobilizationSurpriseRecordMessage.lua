local GetZoneMobilizationSurpriseRecordMessage = BaseClass("GetZoneMobilizationSurpriseRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetZoneMobilizationSurpriseRecordMessage:OnCreate()
  base.OnCreate(self)
end

function GetZoneMobilizationSurpriseRecordMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.OnZoneMobilizationRecordGot, message)
  end
end

return GetZoneMobilizationSurpriseRecordMessage
