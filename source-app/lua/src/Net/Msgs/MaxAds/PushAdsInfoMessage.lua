local PushAdsInfoMessage = BaseClass("PushAdsInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAdsInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushAdsInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.MaxAdManager:OnReceiveAdsInfo(t)
    DataCenter.MaxAdManager:InitSdk(t)
  end
end

return PushAdsInfoMessage
