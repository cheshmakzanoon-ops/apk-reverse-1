local ZoneMobilizationClaimChallengeRewardMessage = BaseClass("ZoneMobilizationClaimChallengeRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ZoneMobilizationClaimChallengeRewardMessage:OnCreate(index)
  base.OnCreate(self)
  self.sfsObj:PutInt("index", index)
end

function ZoneMobilizationClaimChallengeRewardMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.RewardManager:AddRewardsAndRes(message)
    DataCenter.RewardManager:ShowCommonReward(message)
    DataCenter.LWZoneMobilizationManager:UpdateZoneMobilizationAttackRewardData(message)
  end
end

return ZoneMobilizationClaimChallengeRewardMessage
