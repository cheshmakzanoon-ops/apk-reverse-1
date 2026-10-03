local DetectEventTaskRetryEndMessage = BaseClass("DetectEventTaskRetryEndMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DetectEventTaskRetryEndMessage:OnCreate(uuid, eventType, progress, configId)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("eventType", eventType)
  self.sfsObj:PutInt("progress", progress)
  self.sfsObj:PutInt("stageId", tonumber(configId))
end

function DetectEventTaskRetryEndMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.rewardInfo then
    t.reward = t.rewardInfo
    DataCenter.RewardManager:AddRewards(t.reward)
    DataCenter.RewardManager:ShowCommonReward(t)
  end
end

return DetectEventTaskRetryEndMessage
