local PushAllianceBossS0ChangeMessage = BaseClass("PushAllianceBossS0ChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAllianceBossS0ChangeMessage:OnCreate()
  base.OnCreate(self)
end

function PushAllianceBossS0ChangeMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errorCode = message.errorCode
  if errorCode ~= nil then
    UIUtil.ShowTipsId(errorCode)
    return
  end
  DataCenter.S0AllianceBossDataManager:ReqActMainMessage()
  if DataCenter.S0AllianceBossDataManager.appointMark then
    DataCenter.S0AllianceBossDataManager:MarkAppointChanged(false)
    EventManager:GetInstance():Broadcast(EventId.OnS0AllianceBossAppointSuccess, message)
  end
end

return PushAllianceBossS0ChangeMessage
