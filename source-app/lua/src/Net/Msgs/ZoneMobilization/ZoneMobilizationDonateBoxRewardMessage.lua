local ZoneMobilizationDonateBoxRewardMessage = BaseClass("ZoneMobilizationDonateBoxRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ZoneMobilizationDonateBoxRewardMessage:OnCreate(boxType)
  base.OnCreate(self)
  self.sfsObj:PutInt("boxType", boxType)
end

function ZoneMobilizationDonateBoxRewardMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.RewardManager:AddRewardsAndRes(message)
    DataCenter.RewardManager:ShowCommonReward(message)
    DataCenter.LWZoneMobilizationManager:UpdateZoneMobilizationDonatedBoxData(message)
  end
end

return ZoneMobilizationDonateBoxRewardMessage
