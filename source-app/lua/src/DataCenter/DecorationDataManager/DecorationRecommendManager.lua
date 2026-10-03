local DecorationRecommendManager = BaseClass("DecorationRecommendManager")

function DecorationRecommendManager:__init()
  self.recommendOpen = true
  self.recommendData = nil
end

function DecorationRecommendManager:__delete()
  self.recommendOpen = nil
  self.recommendData = nil
end

function DecorationRecommendManager:IsFunctionOn()
  local function IsSeasonTimeValid(config)
    local seasonNum = SeasonUtil.GetSeason()
    
    if seasonNum > config.seasonNum then
      return true
    elseif seasonNum < config.seasonNum then
      return false
    end
    return config.seasonDay <= SeasonUtil.GetSeasonDayByOpenServerZero()
  end
  
  local seasonTimeConfigStr = LuaEntry.DataConfig:TryGetStr("decoration_recommend_open", "k2", "")
  local isSeasonTimeValid = true
  if not string.IsNullOrEmpty(seasonTimeConfigStr) then
    local strSplit = string.split(seasonTimeConfigStr, ";")
    if #strSplit == 2 then
      local config = {
        seasonNum = tonumber(strSplit[1]) or 0,
        seasonDay = tonumber(strSplit[2]) or 0
      }
      isSeasonTimeValid = IsSeasonTimeValid(config)
    end
  end
  if not isSeasonTimeValid then
    return false
  end
  local needURDecorationCount = LuaEntry.DataConfig:TryGetNum("decoration_recommend_open", "k1", 0)
  local haveURDecorationCount = DataCenter.BuildManager:GetDecorationTypeCountByQuality(5)
  if needURDecorationCount > haveURDecorationCount then
    return false
  end
  return true
end

function DecorationRecommendManager:InitSwitch(message)
  if message == nil then
    return
  end
  if message.decorationSuggestSwitchRes ~= nil then
    self.recommendOpen = message.decorationSuggestSwitchRes
  end
end

function DecorationRecommendManager:GetIsOn()
  return self.recommendOpen
end

function DecorationRecommendManager:SendOpenMessage(isOpen)
  if self.recommendOpen == isOpen then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.UserDecorationSuggestSwitch, isOpen)
end

function DecorationRecommendManager:OnSetOpenMessageCallback(message)
  if message == nil then
    return
  end
  if message.decorationSuggestSwitchRes ~= nil then
    self.recommendOpen = message.decorationSuggestSwitchRes
  end
  EventManager:GetInstance():Broadcast(EventId.DecorationBookRecommendOpenChanged)
end

function DecorationRecommendManager:TryUpdateRecommendData()
  if self.recommendData ~= nil then
    return
  end
  if not self:IsFunctionOn() or not self:GetIsOn() then
    return
  end
  self.recommendData = {}
  local allDecorate = DataCenter.BuildManager:GetAllDecoratorBuildingData()
  for buildBaseId, list in pairs(allDecorate) do
    local buildData = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(buildBaseId, true)
    if buildData ~= nil then
      local desTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildBaseId)
      local lvTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level)
      if lvTemplate ~= nil and desTemplate ~= nil then
        local isMax = buildData.level >= desTemplate.max_level
        if not isMax then
          local recommendOrder = lvTemplate.decoration_recommend_order or 0
          if 0 < recommendOrder then
            local isRecommend = self.recommendData.order == nil or recommendOrder <= self.recommendData.order
            if isRecommend then
              if self.recommendData.baseIdList == nil or self.recommendData.order ~= recommendOrder then
                self.recommendData.baseIdList = {}
              end
              self.recommendData.order = recommendOrder
              table.insert(self.recommendData.baseIdList, buildBaseId)
            end
          end
        end
      end
    end
  end
  if not table.IsNullOrEmpty(self.recommendData.baseIdList) then
    table.sort(self.recommendData.baseIdList, function(baseIdA, baseIdB)
      local needDecoNumA = self:GetNeedCommonItemNumToNextLevel(baseIdA)
      local needDecoNumB = self:GetNeedCommonItemNumToNextLevel(baseIdB)
      if needDecoNumA ~= needDecoNumB then
        return needDecoNumA < needDecoNumB
      end
      return baseIdA < baseIdB
    end)
  end
end

function DecorationRecommendManager:GetNeedCommonItemNumToNextLevel(buildBaseId)
  local buildData = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(buildBaseId, true)
  if buildData ~= nil then
    local lvTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level)
    local oneLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildBaseId, 1)
    if lvTemplate ~= nil and oneLevelTemplate ~= nil then
      local progressGroupId = lvTemplate.decoGroupUpgradeBaseId
      local isExistAdvanceUpgrade = 0 < progressGroupId
      if isExistAdvanceUpgrade then
        local curUpgradeProgress = buildData.prodStatus or 0
        local curProgressInfo = DataCenter.DecorationUpgradeTemplateManager:GetLvAndStageInfoByProgress(progressGroupId, buildData.level, curUpgradeProgress)
        if curProgressInfo then
          local curGroupId = curProgressInfo.group
          local curLevel = curProgressInfo.level
          local needProgressToNextLevel = BuildingUtils.GetRemainProgressToNextLevel(curGroupId, curLevel, curUpgradeProgress)
          local needDecoNumToNextLevel = needProgressToNextLevel * curProgressInfo.cost_item
          return needDecoNumToNextLevel * oneLevelTemplate.convert_decorator_num
        end
      else
        local upLevelScarceInfos = BuildingUtils.GetDecorateUpLevelBuilds(buildData)
        local nextLvNeedDecoNum = 0
        if upLevelScarceInfos and 0 < table.count(upLevelScarceInfos) then
          local lastData = upLevelScarceInfos[#upLevelScarceInfos]
          nextLvNeedDecoNum = lastData.needScore or 0
        end
        return nextLvNeedDecoNum * oneLevelTemplate.convert_decorator_num
      end
    end
  end
  return 0
end

function DecorationRecommendManager:GetRecommendBuildBaseId()
  self:TryUpdateRecommendData()
  if self.recommendData ~= nil and self.recommendData.baseIdList then
    return self.recommendData.baseIdList[1]
  end
end

function DecorationRecommendManager:SetCacheDataDirty()
  self.recommendData = nil
end

return DecorationRecommendManager
