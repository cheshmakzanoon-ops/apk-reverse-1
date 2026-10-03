local AllianceBossS0DonateRecordMessage = BaseClass("AllianceBossS0DonateRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceBossS0DonateRecordMessage:OnCreate()
  base.OnCreate(self)
end

function AllianceBossS0DonateRecordMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errorCode = message.errorCode
  if errorCode ~= nil then
    UIUtil.ShowTipsId(errorCode)
    return
  end
  EventManager:GetInstance():Broadcast(EventId.OnS0AllianceBossDonateRecordGot, message)
end

return AllianceBossS0DonateRecordMessage
