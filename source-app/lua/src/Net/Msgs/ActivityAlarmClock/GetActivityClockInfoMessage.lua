local GetActivityClockInfoMessage = BaseClass("GetActivityClockInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetActivityClockInfoMessage:OnCreate()
  base.OnCreate(self)
end

function GetActivityClockInfoMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWActivityAlarmClockManager:InitData(message)
  end
end

return GetActivityClockInfoMessage
