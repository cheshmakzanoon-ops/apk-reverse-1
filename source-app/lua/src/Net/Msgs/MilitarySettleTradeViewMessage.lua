local MilitarySettleTradeViewMessage = BaseClass("MilitarySettleTradeViewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function MilitarySettleTradeViewMessage:OnCreate(param)
  base.OnCreate(self)
end

function MilitarySettleTradeViewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    DataCenter.SeasonMilitaryManager:ClearTrendSettlementCache()
  else
    DataCenter.SeasonMilitaryManager:OnTrendSettlementCallback(t)
  end
end

return MilitarySettleTradeViewMessage
