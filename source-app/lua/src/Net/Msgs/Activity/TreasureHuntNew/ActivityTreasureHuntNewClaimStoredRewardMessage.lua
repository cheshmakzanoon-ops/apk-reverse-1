local ActivityTreasureHuntNewClaimStoredRewardMessage = BaseClass("ActivityTreasureHuntNewClaimStoredRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ActivityTreasureHuntNewClaimStoredRewardMessage:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("aid", activityId)
end

function ActivityTreasureHuntNewClaimStoredRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActivityTreasureHuntNewManager:OnRequestClaimStoredReward(t)
  end
end

return ActivityTreasureHuntNewClaimStoredRewardMessage
