local PushUpdateTradeShopGoodsInfoMessage = BaseClass("PushUpdateTradeShopGoodsInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushUpdateTradeShopGoodsInfoMessage:OnCreate()
  base.OnCreate(self)
end

function PushUpdateTradeShopGoodsInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonTradeShopDataManager:HandlePushUpdateTradeShopGoodsInfo(t)
  end
end

return PushUpdateTradeShopGoodsInfoMessage
