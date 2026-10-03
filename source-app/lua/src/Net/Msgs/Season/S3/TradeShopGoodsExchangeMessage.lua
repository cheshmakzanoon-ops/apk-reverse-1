local TradeShopGoodsExchangeMessage = BaseClass("TradeShopGoodsExchangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function TradeShopGoodsExchangeMessage:OnCreate(tradeId, configId, num, serverId, shopType)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
  self.sfsObj:PutInt("worldId", LuaEntry.Player:GetCurWorldId())
  self.sfsObj:PutInt("tradeId", tradeId)
  self.sfsObj:PutInt("configId", configId)
  self.sfsObj:PutInt("num", num)
  self.sfsObj:PutInt("shopType", shopType or DataCenter.SeasonTradeShopDataManager:GetShopType())
end

function TradeShopGoodsExchangeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if errorCode == "season_s3_activity_1000072_desc47" then
      EventManager:GetInstance():Broadcast(EventId.UpdateTradeShopGoodsInfo)
    end
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonTradeShopDataManager:HandleTradeShopGoodsExchange(t)
  end
end

return TradeShopGoodsExchangeMessage
