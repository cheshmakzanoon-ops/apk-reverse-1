local DetectEventInfo = BaseClass("DetectEventInfo")
local DiggingMapData = require("DataCenter.DiggingGame.DiggingMapData")

function DetectEventInfo:__init()
  self.uuid = ""
  self.eventId = 0
  self.pointId = 0
  self.state = 0
  self.startTime = 0
  self.endTime = 0
  self.rewardList = {}
  self.helpInfo = nil
  self.completeByHelper = nil
  self.cost = 0
  self.template = nil
  self.isFrozen = false
end

function DetectEventInfo:__delete()
  self.uuid = nil
  self.eventId = nil
  self.pointId = nil
  self.state = nil
  self.startTime = nil
  self.endTime = nil
  self.rewardList = nil
  self.helpInfo = nil
  self.completeByHelper = nil
  self.cost = nil
  self.template = nil
  self.isFrozen = nil
  self.busReward = nil
  self.busList = nil
  self.marchUuid = nil
  self.curPoint = nil
  self.skyBattleStage = nil
end

function DetectEventInfo:ParseData(message)
  if message == nil then
    return
  end
  if message.uuid ~= nil then
    self.uuid = message.uuid
  end
  if message.eventId ~= nil then
    self.eventId = message.eventId
  end
  if message.pointId ~= nil then
    self.pointId = message.pointId
  end
  if message.state ~= nil and self.state ~= message.state then
    self.state = message.state
    EventManager:GetInstance():Broadcast(EventId.GF_detect_event_state_changed, message)
  end
  if message.startTime ~= nil then
    self.startTime = message.startTime
  end
  if message.endTime ~= nil then
    self.endTime = message.endTime
  end
  if message.cost ~= nil then
    self.cost = message.cost
  end
  if message.helpInfo ~= nil then
    self.helpInfo = {}
    self.helpInfo.uid = message.helpInfo.targetUid
    self.helpInfo.pic = message.helpInfo.headPic
    self.helpInfo.picVer = message.helpInfo.headPicVer
    self.helpInfo.headSkinId = message.helpInfo.headSkinId
    self.helpInfo.headSkinET = message.helpInfo.headSkinET
    self.helpInfo.name = message.helpInfo.name
    self.helpInfo.abbr = message.helpInfo.abbr
    self.helpInfo.bUid = message.helpInfo.bUid
  end
  self:ParseRewardData(message)
  if message.completeByHelper ~= nil then
    self.completeByHelper = {}
    self.completeByHelper.uid = message.completeByHelper.uid
    self.completeByHelper.pic = message.completeByHelper.headPic
    self.completeByHelper.picVer = message.completeByHelper.headPicVer
    self.completeByHelper.headSkinId = message.completeByHelper.headSkinId
    self.completeByHelper.headSkinET = message.completeByHelper.headSkinET
    self.completeByHelper.name = message.completeByHelper.name
    self.completeByHelper.abbr = message.completeByHelper.abbr
  end
  local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(self.eventId)
  if template then
    self.template = template
  end
  if message.isFrozen then
    self.isFrozen = true
  else
    self.isFrozen = false
  end
  if message.caveInfo then
    self.cavePath = message.caveInfo.pathArr
    self.caveInfo = message.caveInfo
  end
  self.marchUuid = message.marchUuid
  self.curPoint = message.curPoint
  if message.busList then
    self.busList = message.busList
  end
  if message.busReward then
    self.busReward = message.busReward
  end
  self:ParseRewardData(message)
  if message.digGameInfo then
    local data = DiggingMapData.New()
    data:UpdateData(message.digGameInfo)
    self.digGameInfo = data
  end
  if message.lastStandFeature then
    self.lastStandStageId = message.lastStandFeature.stageId
  end
  if message.suppliesSearchInfo then
    self.suppliesSearchInfo = message.suppliesSearchInfo
  end
  if message.skyBattleStage then
    self.skyBattleStage = message.skyBattleStage
  end
end

function DetectEventInfo:ParseRewardData(message)
  self.rewardList = {}
  if message.reward ~= nil then
    self.rewardList = DataCenter.RewardManager:ReturnRewardParamForView(message.reward)
    if self.rewardList and #self.rewardList > 1 then
      for k, v in pairs(self.rewardList) do
        if v.rewardType == RewardType.WOOD then
          table.remove(self.rewardList, k)
          table.insert(self.rewardList, 1, v)
          break
        end
      end
      for k, v in pairs(self.rewardList) do
        if v.rewardType == RewardType.METAL then
          table.remove(self.rewardList, k)
          table.insert(self.rewardList, 1, v)
          break
        end
      end
      for k, v in pairs(self.rewardList) do
        if v.rewardType == RewardType.FOOD then
          table.remove(self.rewardList, k)
          table.insert(self.rewardList, 1, v)
          break
        end
      end
      for k, v in pairs(self.rewardList) do
        if v.rewardType == RewardType.GOLD then
          table.remove(self.rewardList, k)
          table.insert(self.rewardList, 1, v)
          break
        end
      end
    end
  end
  if message.pveReward ~= nil then
    local pveReward = DataCenter.RewardManager:ReturnRewardParamForView(message.pveReward)
    if pveReward ~= nil then
      for k, v in pairs(self.rewardList) do
        table.insert(pveReward, v)
      end
    end
    self.rewardList = pveReward
  end
  local probRewardList = self:CheckActivityDrop()
  if table.IsNullOrEmpty(self.rewardList) then
    self.rewardList = probRewardList
  else
    table.insertto(self.rewardList, probRewardList)
  end
  self.originalData = message
end

function DetectEventInfo:OnDeclareWar()
  if self.template.type == DetectEventType.ScoutDeclareCity then
    local data = DataCenter.AllianceDeclareWarManager:GetSelfDeclareWarData()
    if data and data.content then
      local config = DataCenter.AllianceCityTemplateManager:GetTemplate(data.content)
      self.pointId = config:GetPointId()
      return true
    else
      self.pointId = 0
      return false
    end
  end
end

function DetectEventInfo:OnSetMainWorldPointId()
  if self.template.type == DetectEventType.ScoutOccupyCity then
    local nearestCityTemplate = DataCenter.WorldAllianceCityDataManager:GetNearestMyCityTemplate(LuaEntry.Player:GetMainWorldPos(), 7)
    if nearestCityTemplate then
      self.pointId = nearestCityTemplate:GetPointId()
      return true
    else
      self.pointId = 0
      return false
    end
  end
end

function DetectEventInfo:SetDetectEventInfoState(state)
  self.state = state
end

function DetectEventInfo:CheckActivityDrop()
  local ret = {}
  self.has_builders_alliance_drop = false
  local isFarmer = DataCenter.SeasonFarmerManager:IsActive()
  local activityList = DataCenter.ActivityListDataManager:GetActivityList()
  self.inFarmerMode = isFarmer
  for _, v in pairs(activityList) do
    if v.tableInfo == "activity_drop" and v:IsValid() then
      local isCanDrop = UIUtil.CheckActivityCanDrop(v)
      if isCanDrop then
        local dropId = v.subType
        local templateList = DataCenter.ActivityDropTemplateManager:GetTemplatesByDropId(tonumber(dropId))
        for __, v1 in pairs(templateList) do
          if v1 and v1.builders_alliance == 1 then
            self.has_builders_alliance_drop = true
          end
          if not isFarmer and v1.builders_alliance == 1 then
          elseif v1.drop_way == DropWayEnum.RadarHelp and self.helpInfo or v1.drop_way == DropWayEnum.Radar then
            local drop_show = v1.drop_show
            local isPassCrossServerShow = v1:CheckPassCrossServerShowReward()
            if isPassCrossServerShow and not table.IsNullOrEmpty(drop_show) then
              for _, v in ipairs(drop_show) do
                local rewardInfo = {}
                rewardInfo.itemId = v.id
                rewardInfo.rewardType = RewardType.GOODS
                local count
                local minCount = v.minNum
                local maxCount = v.maxNum
                if maxCount and maxCount ~= minCount then
                  count = string.format("%d-%d", minCount, maxCount)
                else
                  count = minCount
                end
                rewardInfo.count = count
                table.insert(ret, rewardInfo)
              end
            end
          end
        end
      end
    end
  end
  return ret
end

function DetectEventInfo:UpdateBuildersAllianceDrop(isFarmer)
  if self.originalData and self.has_builders_alliance_drop and self.inFarmerMode ~= isFarmer then
    self:ParseRewardData(self.originalData)
  end
end

function DetectEventInfo:Description()
  local sb = StringBuilder.New()
  sb:AppendLine(string.format("id:%s, eId:%s, type:%s, state:%s", self.uuid, self.eventId, self.template.type, self.state))
  if self.template.type == DetectEventType.CAVE_EXPLORATION then
    sb:AppendLine(string.format("cave path ct:%s", self.cavePath and #self.cavePath or "NULL"))
  end
  return sb:ToString()
end

function DetectEventInfo:IsShowRedPointInMainUI()
  if self.template and (self.template.type == DetectEventType.DOMINATOR_COCKATRICE_GUIDE_1 or self.template.type == DetectEventType.DOMINATOR_COCKATRICE_GUIDE_2 or self.template.type == DetectEventType.DOMINATOR_COCKATRICE_GUIDE_3) then
    return false
  end
  return true
end

function DetectEventInfo:IsShowFlyEffectInMainUI()
  if self.template and (self.template.type == DetectEventType.DOMINATOR_COCKATRICE_GUIDE_1 or self.template.type == DetectEventType.DOMINATOR_COCKATRICE_GUIDE_2 or self.template.type == DetectEventType.DOMINATOR_COCKATRICE_GUIDE_3) then
    return false
  end
  return true
end

return DetectEventInfo
