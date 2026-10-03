local ParkourActivityGuideRewardMessage = BaseClass("ParkourActivityGuideRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ParkourActivityGuideRewardMessage:OnCreate(param)
  base.OnCreate(self)
end

function ParkourActivityGuideRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
  else
    DataCenter.LWSurfingDataManager:SetGuideReward()
    local rewards = t.reward
    if rewards then
      DataCenter.RewardManager:AddRewardsAndRes({reward = rewards})
    end
  end
end

return ParkourActivityGuideRewardMessage
