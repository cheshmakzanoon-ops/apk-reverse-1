local VisitorReceiveRewardMessage = BaseClass("VisitorReceiveRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function VisitorReceiveRewardMessage:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

function VisitorReceiveRewardMessage:HandleMessage(message)
  base.HandleMessage(self, t)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if message.reward then
      DataCenter.RewardManager:ShowGiftReward(message)
      DataCenter.RewardManager:AddRewardsAndRes(message)
    end
    if message.activityId then
      DataCenter.ActivityVisitorManager:SetActivityVisitorReceivedState(message.activityId, message.nextResetTime)
    end
  end
end

return VisitorReceiveRewardMessage
