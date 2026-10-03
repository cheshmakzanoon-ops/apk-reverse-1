local FreeBuildingFixCityHeroMessage = BaseClass("FreeBuildingFixCityHeroMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FreeBuildingFixCityHeroMessage:OnCreate(buildUuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", buildUuid)
end

function FreeBuildingFixCityHeroMessage:HandleMessage(message)
  base.HandleMessage(message)
  if message.reward then
    DataCenter.RewardManager:AddRewardsAndRes(message)
    DataCenter.RewardManager:ShowCommonReward(message)
  end
end

return FreeBuildingFixCityHeroMessage
