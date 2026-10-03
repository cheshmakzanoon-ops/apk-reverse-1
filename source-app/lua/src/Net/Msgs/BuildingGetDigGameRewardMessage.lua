local BuildingGetDigGameRewardMessage = BaseClass("BuildingGetDigGameRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BuildingGetDigGameRewardMessage:OnCreate(buildingUuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("buildingUuid", buildingUuid)
end

function BuildingGetDigGameRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local tRewardData = t.mapBoxList
    if tRewardData ~= nil then
      DataCenter.BuildingDigTreasureManager:UpdateRewardData(tRewardData)
    else
      DataCenter.BuildingDigTreasureManager:PassAllLevel()
    end
    DataCenter.RewardManager:AddRewardsAndRes(t)
    DataCenter.RewardManager:ShowCommonReward(t)
  end
end

return BuildingGetDigGameRewardMessage
