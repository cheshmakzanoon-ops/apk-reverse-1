local PushCrossThroneWinnerPopupMessage = BaseClass("PushCrossThroneWinnerPopupMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushCrossThroneWinnerPopupMessage:OnCreate()
  base.OnCreate(self)
end

function PushCrossThroneWinnerPopupMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.GovernmentManager:OnPushCrossThroneWinnerPopup(t)
end

return PushCrossThroneWinnerPopupMessage
