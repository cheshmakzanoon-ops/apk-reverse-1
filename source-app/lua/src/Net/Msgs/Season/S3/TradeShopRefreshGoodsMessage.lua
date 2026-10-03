local TradeShopRefreshGoodsMessage = BaseClass("TradeShopRefreshGoodsMessage", SFSBaseMessage)
local base = SFSBaseMessage

function TradeShopRefreshGoodsMessage:OnCreate(tradeId, shopType)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", LuaEntry.Player:GetCurServerId())
  self.sfsObj:PutInt("worldId", LuaEntry.Player:GetCurWorldId())
  self.sfsObj:PutInt("tradeId", tradeId)
  self.sfsObj:PutInt("shopType", shopType or DataCenter.SeasonTradeShopDataManager:GetShopType())
end

function TradeShopRefreshGoodsMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonTradeShopDataManager:HandleTradeShopRefreshGoods(t)
  end
end

return TradeShopRefreshGoodsMessage
