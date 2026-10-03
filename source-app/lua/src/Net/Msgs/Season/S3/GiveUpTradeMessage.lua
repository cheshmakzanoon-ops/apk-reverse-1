local GiveUpTradeMessage = BaseClass("GiveUpTradeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GiveUpTradeMessage:OnCreate(serverId, tradeId)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
  self.sfsObj:PutInt("tradeId", tradeId)
end

function GiveUpTradeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

return GiveUpTradeMessage
