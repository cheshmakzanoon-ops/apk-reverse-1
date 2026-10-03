local BuildingDigGameOpenBlockMessage = BaseClass("BuildingDigGameOpenBlockMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BuildingDigGameOpenBlockMessage:OnCreate(buildingUuid, pos)
  base.OnCreate(self)
  self.sfsObj:PutLong("buildingUuid", buildingUuid)
  self.sfsObj:PutInt("pos", pos)
end

function BuildingDigGameOpenBlockMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local nBuildingUuid = t.buildingUuid
    local tBuildingData = DataCenter.BuildManager:GetBuildingDataByUuid(nBuildingUuid)
    if not tBuildingData or not tBuildingData.buildingDigGame then
      return
    end
    local tMapData = tBuildingData.buildingDigGame.gameInfo
    if not tMapData or tMapData.uuid ~= t.uuid then
      return
    end
    local brickInfo = {
      pos = t.pos,
      blockInfo = t.openBlockInfo
    }
    tMapData.brickDic[t.pos] = brickInfo
    if t.openBlockInfo then
      local blockInfo = DataCenter.DiggingDataManager:GetBlock(t.openBlockInfo.bid, tMapData.blockInfo)
      local levelConfig = DataCenter.DiggingDataTemplateManager:GetConfigData(tMapData.mapConfigId)
      local config = DataCenter.DiggingDataTemplateManager:GetConfigDataBlock(t.openBlockInfo.bid)
      if levelConfig and config then
        local get = DataCenter.DiggingDataManager:CheckBlockGet(t.openBlockInfo.pos, tMapData.brickDic, levelConfig.num_width, config.size_width, config.size_height)
        t.openBlockInfo.get = get
        if blockInfo then
          blockInfo.get = get
        else
          table.insert(tMapData.blockInfo, t.openBlockInfo)
        end
      end
    end
    local bCanGetReward = false
    if t.rewardState then
      if tMapData.rewardState ~= t.rewardState and t.rewardState == DigRewardState.CanGet then
        bCanGetReward = true
      end
      tMapData.rewardState = t.rewardState
      local tRewardData = DataCenter.BuildingDigTreasureManager:GetRewardData()
      for i, v in ipairs(tRewardData) do
        if v.mapConfigId == t.mapConfigId then
          if v.rewardState ~= t.rewardState then
            v.rewardState = t.rewardState
            EventManager:GetInstance():Broadcast(EventId.DigTreasureUpdateRewardData)
          end
          break
        end
      end
    end
    DataCenter.BuildingDigTreasureManager:OnOpenBrick(t)
    if t.newGameInfo then
      tBuildingData.buildingDigGame.gameInfo = DataCenter.BuildingDigTreasureManager:InitMapData(t.newGameInfo)
      EventManager:GetInstance():Broadcast(EventId.DigTreasureUpdateMapData)
    end
    if bCanGetReward then
      EventManager:GetInstance():Broadcast(EventId.DigTreasureCanGetReward)
    end
  end
end

return BuildingDigGameOpenBlockMessage
