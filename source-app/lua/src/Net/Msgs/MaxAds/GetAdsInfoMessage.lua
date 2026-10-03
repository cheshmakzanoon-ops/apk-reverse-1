local GetAdsInfoMessage = BaseClass("GetAdsInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetAdsInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function GetAdsInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.MaxAdManager:OnReceiveAdsInfo(t)
    DataCenter.MaxAdManager:InitSdk(t)
  end
end

return GetAdsInfoMessage
