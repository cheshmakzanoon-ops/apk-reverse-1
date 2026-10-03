local PushActivityClockChangeMessage = BaseClass("PushActivityClockChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushActivityClockChangeMessage:OnCreate()
  base.OnCreate(self)
end

function PushActivityClockChangeMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWActivityAlarmClockManager:TrySendGetActivityAlarmClockDataMsg()
  end
end

return PushActivityClockChangeMessage
