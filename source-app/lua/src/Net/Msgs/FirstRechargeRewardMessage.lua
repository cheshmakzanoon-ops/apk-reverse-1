local FirstRechargeRewardMessage = BaseClass("FirstRechargeRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FirstRechargeRewardMessage:OnCreate(param)
  base.OnCreate(self)
end

function FirstRechargeRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.reward ~= nil then
      DataCenter.RewardManager:AddRewards(t.reward)
      DataCenter.RewardManager:ShowCommonReward(t)
    end
    DataCenter.FirstPayManager:UpdateBuildExpData(t)
  end
end

return FirstRechargeRewardMessage
