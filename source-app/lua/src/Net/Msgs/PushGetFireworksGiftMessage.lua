local PushGetFireworksGiftMessage = BaseClass("PushGetFireworksGiftMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushGetFireworksGiftMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushGetFireworksGiftMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWFireworkGiftManager:OnGetFireworksGift(t)
  end
end

return PushGetFireworksGiftMessage
