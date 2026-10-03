local PushActivityClockUpdateMessage = BaseClass("PushActivityClockUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushActivityClockUpdateMessage:OnCreate()
  base.OnCreate(self)
end

function PushActivityClockUpdateMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWActivityAlarmClockManager:UpdateData(message)
  end
end

return PushActivityClockUpdateMessage
