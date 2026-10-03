local SeasonDesertShopExchangeMessage = BaseClass("SeasonDesertShopExchangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonDesertShopExchangeMessage:OnCreate(activityId, configId, num)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", toInt(activityId))
  self.sfsObj:PutInt("configId", toInt(configId))
  self.sfsObj:PutInt("num", toInt(num))
end

function SeasonDesertShopExchangeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local data = DataCenter.ActivityListDataManager:GetActivityDataById(t.activityId)
    local msg = {}
    msg.reward = {}
    local rewardData = {}
    rewardData.type = RewardType.GOODS
    rewardData.value = {}
    rewardData.value.itemId = t.itemId
    rewardData.value.rewardAdd = t.itemAddNum
    rewardData.value.refreshTime = t.refreshTime or 0
    table.insert(msg.reward, rewardData)
    DataCenter.RewardManager:ShowCommonReward(msg)
    if data then
      data:SetShopExchangeRecord(t.configId, t.count, t.refreshTime)
      EventManager:GetInstance():Broadcast(EventId.BuyDesertShopItemSuccess)
    end
  end
end

return SeasonDesertShopExchangeMessage
