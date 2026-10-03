local GetTradeDetailMessage = BaseClass("GetTradeDetailMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetTradeDetailMessage:OnCreate(tradeId, serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
  self.sfsObj:PutInt("tradeId", tradeId)
  self.sfsObj:PutInt("previewAssistance", 10)
end

function GetTradeDetailMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonTradeShopDataManager:HandleTradeInfo(t, true)
  end
end

return GetTradeDetailMessage
