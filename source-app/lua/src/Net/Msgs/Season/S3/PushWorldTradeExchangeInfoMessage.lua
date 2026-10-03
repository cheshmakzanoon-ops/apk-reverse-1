local PushWorldTradeExchangeInfoMessage = BaseClass("PushWorldTradeExchangeInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushWorldTradeExchangeInfoMessage:OnCreate()
  base.OnCreate(self)
end

function PushWorldTradeExchangeInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonTradeShopDataManager:HandleWorldTradeExchangeInfo(t)
  end
end

return PushWorldTradeExchangeInfoMessage
