local ActivityTreasureHuntNewClaimBigRewardMessage = BaseClass("ActivityTreasureHuntNewClaimBigRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ActivityTreasureHuntNewClaimBigRewardMessage:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("aid", activityId)
end

function ActivityTreasureHuntNewClaimBigRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActivityTreasureHuntNewManager:OnRequestClaimBigReward(t)
  end
end

return ActivityTreasureHuntNewClaimBigRewardMessage
