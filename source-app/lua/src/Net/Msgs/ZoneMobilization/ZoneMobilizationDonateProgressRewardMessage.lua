local ZoneMobilizationDonateProgressRewardMessage = BaseClass("ZoneMobilizationDonateProgressRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ZoneMobilizationDonateProgressRewardMessage:OnCreate()
  base.OnCreate(self)
end

function ZoneMobilizationDonateProgressRewardMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.RewardManager:AddRewardsAndRes(message)
    DataCenter.RewardManager:ShowCommonReward(message)
    DataCenter.LWZoneMobilizationManager:HandleUpdateDonatedProgressRewardData(message)
  end
end

return ZoneMobilizationDonateProgressRewardMessage
