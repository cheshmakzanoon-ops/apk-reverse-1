local BountyHunterEventShopBuyMessage = BaseClass("BountyHunterEventShopBuyMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BountyHunterEventShopBuyMessage:OnCreate(activityId, configId, uuid)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("confId", configId)
  self.sfsObj:PutLong("uuid", uuid)
end

function BountyHunterEventShopBuyMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local reward = t.reward
    if reward and 0 < #reward then
      DataCenter.RewardManager:AddRewards(reward)
      DataCenter.RewardManager:ShowCommonReward(t)
    end
    if t.gold ~= nil then
      LuaEntry.Player.gold = t.gold
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
  end
end

return BountyHunterEventShopBuyMessage
