local GhostParkourGuideRewardMessage = BaseClass("GhostParkourGuideRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GhostParkourGuideRewardMessage:OnCreate()
  base.OnCreate(self)
end

function GhostParkourGuideRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
  else
    DataCenter.LWGhostParkourDataManager:SetGuideReward()
    local rewards = t.reward
    if rewards then
      DataCenter.RewardManager:AddRewardsAndRes({reward = rewards})
    end
  end
end

return GhostParkourGuideRewardMessage
