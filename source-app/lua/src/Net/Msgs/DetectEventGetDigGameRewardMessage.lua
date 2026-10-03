local DetectEventGetDigGameRewardMessage = BaseClass("DetectEventGetDigGameRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DetectEventGetDigGameRewardMessage:OnCreate(eventUuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("eventUuid", eventUuid)
end

function DetectEventGetDigGameRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.eventInfo then
      DataCenter.DetectDigTreasureManager:OnGetReward(t.eventInfo.uuid)
    end
    DataCenter.RewardManager:AddRewardsAndRes(t)
    DataCenter.RewardManager:ShowCommonReward(t)
  end
end

return DetectEventGetDigGameRewardMessage
