local BerserkBossRewardMessage = BaseClass("BerserkBossRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BerserkBossRewardMessage:OnCreate(bossUuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", bossUuid)
end

function BerserkBossRewardMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local reward = message.reward
    if reward ~= nil then
      DataCenter.RewardManager:AddRewardsAndRes(message)
      DataCenter.RewardManager:ShowCommonReward(message)
    end
  end
end

return BerserkBossRewardMessage
