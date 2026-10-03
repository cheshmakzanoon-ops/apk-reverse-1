local ZoneMobilizationClaimDefendRewardMessage = BaseClass("ZoneMobilizationClaimDefendRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ZoneMobilizationClaimDefendRewardMessage:OnCreate(index)
  base.OnCreate(self)
  self.sfsObj:PutInt("index", index)
end

function ZoneMobilizationClaimDefendRewardMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.RewardManager:AddRewardsAndRes(message)
    DataCenter.RewardManager:ShowCommonReward(message)
    DataCenter.LWZoneMobilizationManager:UpdateZoneMobilizationDefendRewardData(message)
  end
end

return ZoneMobilizationClaimDefendRewardMessage
