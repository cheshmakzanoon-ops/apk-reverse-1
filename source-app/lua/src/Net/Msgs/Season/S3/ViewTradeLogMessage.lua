local ViewTradeLogMessage = BaseClass("ViewTradeLogMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ViewTradeLogMessage:OnCreate(type, serverId, tradeId)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type)
  self.sfsObj:PutInt("serverId", serverId)
  self.sfsObj:PutInt("tradeId", tradeId)
end

function ViewTradeLogMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.WorldAllianceCityDataManager:GetTradeStationRecordData(t)
  end
end

return ViewTradeLogMessage
