local DigTreasureGameGetTimeLimitRewardMessage = BaseClass("DigTreasureGameGetTimeLimitRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DigTreasureGameGetTimeLimitRewardMessage:OnCreate(uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

function DigTreasureGameGetTimeLimitRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.RewardManager:AddRewardsAndRes(t)
    DataCenter.RewardManager:ShowCommonReward(t)
    DataCenter.DigTreasureManager:ClearTimeLimitMapInfo()
    EventManager:GetInstance():Broadcast(EventId.DigTreasureUpdateMapData)
  end
end

return DigTreasureGameGetTimeLimitRewardMessage
