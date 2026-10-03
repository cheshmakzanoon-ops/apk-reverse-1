local BountyHunterBuyShopItemMessage = BaseClass("BountyHunterBuyShopItemMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BountyHunterBuyShopItemMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", param.activityId)
  self.sfsObj:PutUtfString("shopId", param.shopId)
  self.sfsObj:PutInt("num", param.num)
end

function BountyHunterBuyShopItemMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.BountyHunterActDataManager:OnExchangeShopBuySuccess(t)
  end
end

return BountyHunterBuyShopItemMessage
