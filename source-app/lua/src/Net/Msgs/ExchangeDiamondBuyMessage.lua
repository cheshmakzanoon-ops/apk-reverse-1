local ExchangeDiamondBuyMessage = BaseClass("ExchangeDiamondBuyMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ExchangeDiamondBuyMessage:OnCreate(exchangeId)
  base.OnCreate(self)
  self.sfsObj:PutInt("exchangeId", exchangeId)
end

function ExchangeDiamondBuyMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.RewardManager:AddRewardsAndRes(t)
    DataCenter.RewardManager:ShowCommonReward(t)
    if t.remainGold ~= nil then
      LuaEntry.Player.gold = t.remainGold
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
  end
end

return ExchangeDiamondBuyMessage
