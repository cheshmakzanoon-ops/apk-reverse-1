local AllianceStarCeremonyQuestRewardMessage = BaseClass("AllianceStarCeremonyQuestRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceStarCeremonyQuestRewardMessage:OnCreate(param)
  base.OnCreate(self)
end

function AllianceStarCeremonyQuestRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local rewards = t.rewardInfo
    if rewards then
      DataCenter.RewardManager:AddRewards(rewards)
      DataCenter.RewardManager:ShowCommonReward({reward = rewards})
    end
  end
end

return AllianceStarCeremonyQuestRewardMessage
