local PowerUpTaskRewardMessage = BaseClass("PowerUpTaskRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PowerUpTaskRewardMessage:OnCreate(activityId, taskId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutUtfString("taskId", taskId)
end

function PowerUpTaskRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.reward ~= nil then
    DataCenter.RewardManager:AddRewards(t.reward)
    DataCenter.RewardManager:ShowCommonReward(t)
    if t.type == EnumActivity.LeadingQuestV2.Type then
      DataCenter.LWLeadingQuestV2Manager:OnGetOneTaskReward(t)
    end
  end
end

return PowerUpTaskRewardMessage
