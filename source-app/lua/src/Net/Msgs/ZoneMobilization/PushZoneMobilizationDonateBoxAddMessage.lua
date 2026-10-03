local PushZoneMobilizationDonateBoxAddMessage = BaseClass("PushZoneMobilizationDonateBoxAddMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushZoneMobilizationDonateBoxAddMessage:OnCreate()
  base.OnCreate(self)
end

function PushZoneMobilizationDonateBoxAddMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWZoneMobilizationManager:UpdateDonateRedPoint()
  end
end

return PushZoneMobilizationDonateBoxAddMessage
