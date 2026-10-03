local AllianceBossS0GainLastTimeInfoMessage = BaseClass("AllianceBossS0GainLastTimeInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceBossS0GainLastTimeInfoMessage:OnCreate()
  base.OnCreate(self)
end

function AllianceBossS0GainLastTimeInfoMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errorCode = message.errorCode
  if errorCode ~= nil then
    UIUtil.ShowTipsId(errorCode)
    return
  end
  EventManager:GetInstance():Broadcast(EventId.OnS0AllianceBossLastChooseTime, message)
end

return AllianceBossS0GainLastTimeInfoMessage
