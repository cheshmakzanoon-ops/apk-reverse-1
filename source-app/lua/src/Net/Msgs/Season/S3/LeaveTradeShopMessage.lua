local GetTradeShopGoodsInfoMessage = BaseClass("GetTradeShopGoodsInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetTradeShopGoodsInfoMessage:OnCreate(tradeId, serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
  self.sfsObj:PutInt("worldId", LuaEntry.Player:GetCurWorldId())
  self.sfsObj:PutInt("tradeId", tradeId)
end

function GetTradeShopGoodsInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  end
end

return GetTradeShopGoodsInfoMessage
