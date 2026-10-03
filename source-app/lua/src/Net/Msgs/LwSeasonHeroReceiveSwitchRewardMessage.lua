local LwSeasonHeroReceiveSwitchRewardMessage = BaseClass("LwSeasonHeroReceiveSwitchRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function LwSeasonHeroReceiveSwitchRewardMessage:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

function LwSeasonHeroReceiveSwitchRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.activityInfo then
      DataCenter.ActExchangeHeroDataManager:UpdateData(t.activityInfo)
    end
    if t.goods ~= nil then
      local tempMsg = {}
      tempMsg.reward = {}
      local tempReward = {
        type = RewardType.GOODS,
        value = {
          itemId = t.goods.itemId,
          count = t.goods.count
        }
      }
      table.insert(tempMsg.reward, tempReward)
      DataCenter.RewardManager:ShowCommonReward(tempMsg)
      DataCenter.ItemData:UpdateOneItem(t.goods)
    end
    EventManager:GetInstance():Broadcast(EventId.ExchangeHeroReceiveRewardSuccess)
  end
end

return LwSeasonHeroReceiveSwitchRewardMessage
