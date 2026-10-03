local DetectEventGetSuppliesSearchRewardMessage = BaseClass("DetectEventGetSuppliesSearchRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DetectEventGetSuppliesSearchRewardMessage:OnCreate(uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("eventUuid", uuid)
end

function DetectEventGetSuppliesSearchRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.RewardManager:AddRewardsAndRes(t)
    DataCenter.RewardManager:ShowCommonReward(t)
  end
end

return DetectEventGetSuppliesSearchRewardMessage
