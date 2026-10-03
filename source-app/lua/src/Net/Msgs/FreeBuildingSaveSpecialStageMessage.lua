local FreeBuildingSaveSpecialStageMessage = BaseClass("FreeBuildingSaveSpecialStageMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function FreeBuildingSaveSpecialStageMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", param.uuid)
  self.sfsObj:PutInt("stageId", param.stageId)
end

function FreeBuildingSaveSpecialStageMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errorCode = message.errorCode
  if errorCode then
    local errorStr = Localization:GetString(errorCode)
    if errorStr then
      UIUtil.ShowTips(errorStr)
    end
    return
  end
  if DataCenter.StageFeatureBuildingManager.StageFeatureId then
    local find = false
    local template = DataCenter.StageFeatureBuildingManager:GetStageFeatureBuildingTemplate(DataCenter.StageFeatureBuildingManager.StageFeatureId)
    for _, value in ipairs(template.stages) do
      if message.stageId == value then
        find = true
      end
    end
    if find then
      local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(DataCenter.StageFeatureBuildingManager.MysteryEnteredBuilding)
      if buildingData then
        if buildingData.specialStagePassedIds == nil then
          buildingData.specialStagePassedIds = {}
        end
        if not table.indexof(buildingData.specialStagePassedIds, message.stageId) then
          table.insert(buildingData.specialStagePassedIds, message.stageId)
        end
      end
      local reward = message.reward
      if reward and 0 < #reward then
        DataCenter.StageFeatureBuildingManager.reward = reward
        DataCenter.RewardManager:AddRewardsAndRes(message)
        EventManager:GetInstance():Broadcast(EventId.ParkourMysteryTreasureBattleReward, reward)
        local logic = DataCenter.LWBattleManager.logic
        if logic and logic.GetPVEType and logic:GetPVEType() == PVEType.LastStand then
          DataCenter.StageFeatureBuildingManager.rewardShow = message
        end
      end
    end
  end
end

return FreeBuildingSaveSpecialStageMessage
