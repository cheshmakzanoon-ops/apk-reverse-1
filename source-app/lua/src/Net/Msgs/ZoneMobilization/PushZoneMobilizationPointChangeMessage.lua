local PushZoneMobilizationPointChangeMessage = BaseClass("PushZoneMobilizationPointChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushZoneMobilizationPointChangeMessage:OnCreate()
  base.OnCreate(self)
end

function PushZoneMobilizationPointChangeMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ZoneMobilizationCtrlManager:OnZoneMobilizationPutFinished(message.action)
  end
end

return PushZoneMobilizationPointChangeMessage
