local FlowerTrainCheerBoxBatchMessage = BaseClass("FlowerTrainCheerBoxBatchMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FlowerTrainCheerBoxBatchMessage:OnCreate(param)
  base.OnCreate(self)
end

function FlowerTrainCheerBoxBatchMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.reward ~= nil then
    local rewardList = DataCenter.RewardManager:ReturnRewardParamForMessage(t.reward)
    EventManager:GetInstance():Broadcast(EventId.OnClaimCollectRewardSucc, rewardList)
    DataCenter.RewardManager:AddRewards(t.reward)
  end
end

return FlowerTrainCheerBoxBatchMessage
