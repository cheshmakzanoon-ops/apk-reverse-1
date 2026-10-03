local BuildingDigGameReceiveHammerMessage = BaseClass("BuildingDigGameReceiveHammerMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function BuildingDigGameReceiveHammerMessage:OnCreate(buildingUuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("buildingUuid", buildingUuid)
end

function BuildingDigGameReceiveHammerMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local reward = t.reward
    local str
    local playAnim = false
    if reward and reward[1].value and reward[1].value.rewardAdd ~= 0 then
      str = Localization:GetString("treasure_map_special_level_08", reward[1].value.rewardAdd)
      DataCenter.RewardManager:AddRewardsAndRes(t)
      DataCenter.RewardManager:ShowCommonReward(t, nil, nil, nil, nil, nil, nil, str)
      playAnim = true
    end
    DataCenter.BuildingDigTreasureManager:OnGetFreeHammer(playAnim)
  end
end

return BuildingDigGameReceiveHammerMessage
