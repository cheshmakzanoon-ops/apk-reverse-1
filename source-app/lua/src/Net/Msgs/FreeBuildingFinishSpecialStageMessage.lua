local FreeBuildingFinishSpecialStageMessage = BaseClass("FreeBuildingFinishSpecialStageMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FreeBuildingFinishSpecialStageMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", param)
  local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(param)
  DataCenter.StageFeatureBuildingManager.MysteryRewardPointId = buildingData.pointId
end

function FreeBuildingFinishSpecialStageMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errorCode = message.errorCode
  if errorCode then
    local errorStr = Localization:GetString(errorCode)
    if errorStr then
      UIUtil.ShowTips(errorStr)
    end
    return
  end
  local reward = message.reward
  if reward and 0 < #reward then
    DataCenter.StageFeatureBuildingManager.reward = reward
    DataCenter.RewardManager:AddRewardsAndRes(message)
    EventManager:GetInstance():Broadcast(EventId.ParkourMysteryTreasureBattleReward, reward)
  end
end

return FreeBuildingFinishSpecialStageMessage
