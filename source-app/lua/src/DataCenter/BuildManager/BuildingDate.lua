local BuildingDate = BaseClass("BuildingDate")

local function __init(self)
  self:reset()
end

local function __delete(self)
  self:reset()
end

local function reset(self)
  self.uuid = 0
  self.itemId = 0
  self.level = 0
  self.pointId = 0
  self.state = BuildingStateType.Normal
  self.startTime = 0
  self.updateTime = 0
  self.buildActiveTime = 0
  self.isHelped = 0
  self.lastCollectTime = 0
  self.unavailableTime = 0
  self.produceEndTime = 0
  self.growValStartTime = 0
  self.destroyEndTime = 0
  self.lastCashCdTime = 0
  self.lastStaminaTime = 0
  self.inside = 0
  self.srcServer = 0
  self.server = 0
  self.world = 0
  self.worldId = 0
  self.productTime = 0
  self.assignedHeroList = {}
  self.productStartTime = nil
  self.productEndTime = nil
  self.prodExtend = nil
  self.prodStatus = nil
  self.flameType = 1
  self.decorNum = nil
  self.isWorldBuild = false
  self.buildingDigGame = nil
  self.suppliesSearchInfo = nil
  self.dominatorId = nil
  self.specialStageId = nil
  self.specialStagePassedIds = nil
  self.cachedRangedPoints = nil
  self.cachedMinPointId = nil
  self.cachedMaxPointId = nil
  self.cachedPointId = nil
  self.cachedItemId = nil
end

local function UpdateInfo(self, message, forceCheckAnimal, isWorldBuild)
  if message == nil then
    return
  end
  self.uuid = message.uuid
  if isWorldBuild ~= nil then
    self.isWorldBuild = isWorldBuild
  end
  if message.bId ~= nil then
    self.itemId = message.bId
  end
  if message.lv ~= nil then
    self.level = message.lv
  end
  if message.pId ~= nil then
    self.pointId = message.pId
  end
  if message.state ~= nil then
    self.state = message.state
  else
    self.state = 0
  end
  CommonUtil.ProtectCall(function()
    self.state = BuildingUtils.GetConditionBuildingState(self)
    DataCenter.BuildManager:OnBuildingStateChange(self)
  end)
  if message.sT ~= nil then
    self.startTime = message.sT
  else
    self.startTime = 0
  end
  if message.uT ~= nil then
    self.updateTime = message.uT
  else
    self.updateTime = 0
  end
  if message.help then
    self.isHelped = message.help
  else
    self.isHelped = 0
  end
  if message.lCT then
    self.lastCollectTime = message.lCT
  else
    self.lastCollectTime = 0
  end
  if message.unaT then
    self.unavailableTime = message.unaT
  else
    self.unavailableTime = 0
  end
  if message.pEndT then
    self.produceEndTime = message.pEndT
  else
    self.produceEndTime = 0
  end
  if message.gValT then
    self.growValStartTime = message.gValT
  else
    self.growValStartTime = 0
  end
  if message.dEndT then
    self.destroyEndTime = message.dEndT
  else
    self.destroyEndTime = 0
  end
  if message.dStT then
    self.destroyStartTime = message.dStT
  else
    self.destroyStartTime = 0
  end
  if message.lCashT then
    self.lastCashCdTime = message.lCashT
  else
    self.lastCashCdTime = 0
  end
  if message.lStaT then
    self.lastStaminaTime = message.lStaT
  else
    self.lastStaminaTime = 0
  end
  if message.inside then
    self.inside = message.inside
  else
    self.inside = 0
  end
  if message.srcServer then
    self.srcServer = message.srcServer
  else
    self.srcServer = LuaEntry.Player:GetSelfServerId()
  end
  if message.server then
    self.server = message.server
  else
    self.server = LuaEntry.Player:GetSelfServerId()
  end
  if message.AssignedHero then
    self.assignedHeroList = message.AssignedHero
  end
  if message.world then
    self.worldId = message.world
  elseif message.worldId then
    self.worldId = message.worldId
  elseif self.itemId == BuildingTypes.WORM_HOLE_CROSS then
    self.worldId = LuaEntry.Player:GetCurWorldId()
  end
  self.world = self.worldId
  if message.prodST then
    self.productStartTime = message.prodST
  else
    self.productStartTime = nil
  end
  if message.prodT then
    self.productTime = message.prodT
  else
    self.productTime = nil
  end
  if message.prodET then
    self.productEndTime = message.prodET
  else
    self.productEndTime = nil
  end
  if message.prodBase then
    self.productBase = message.prodBase
  else
    self.productBase = 0
  end
  if message.prodExtend then
    self.prodExtend = message.prodExtend
  else
    self.prodExtend = 0
  end
  if message.prodStatus then
    self.prodStatus = message.prodStatus
  else
    self.prodStatus = nil
  end
  if message.effect then
    self.effects = message.effect
    EventManager:GetInstance():Broadcast(EventId.UpdateBuildEffect, self.uuid)
  end
  if message.decorNum then
    self.decorNum = message.decorNum
  else
    self.decorNum = nil
  end
  if message.fixCityHeroId then
    self.fixCityHeroId = message.fixCityHeroId
  else
    self.fixCityHeroId = nil
  end
  if message.fixCityHeroET then
    self.fixCityHeroEndTime = message.fixCityHeroET
  else
    self.fixCityHeroEndTime = nil
  end
  if message.specialStageId then
    self.specialStageId = message.specialStageId
  else
    self.specialStageId = nil
  end
  if message.dominatorId then
    self.dominatorId = message.dominatorId
  end
  if message.specialStagePassedIds then
    self.specialStagePassedIds = message.specialStagePassedIds
  else
    self.specialStagePassedIds = nil
  end
  if message.buildingDigGame then
    self.buildingDigGame = {}
    self.buildingDigGame.gameInfo = DataCenter.BuildingDigTreasureManager:InitMapData(message.buildingDigGame.gameInfo)
    self.buildingDigGame.mapBoxList = message.buildingDigGame.mapBoxList
  end
  if message.suppliesSearchInfo then
    self.suppliesSearchInfo = message.suppliesSearchInfo
  end
  if message.completeTask then
    self.completeTask = message.completeTask
  end
  local refreshBuild = false
  if forceCheckAnimal and (self.itemId == BuildingTypes.APS_BUILD_PASTURE_CATTLE or self.itemId == BuildingTypes.APS_BUILD_PASTURE_SANDWORM or self.itemId == BuildingTypes.APS_BUILD_PASTURE_OSTRICH) then
    refreshBuild = true
  end
  if 0 < self.destroyEndTime then
    DataCenter.BuildQueueManager:AddFixQueue(self.uuid)
  else
    DataCenter.BuildQueueManager:RemoveFixQueue(self.uuid)
  end
  if self.itemId == BuildingTypes.FUN_BUILD_MAIN then
    if self.state == BuildingStateType.FoldUp then
      DataCenter.BuildManager.MainLv = 0
    else
      if not DataCenter.BuildManager.MainLv or 0 >= DataCenter.BuildManager.MainLv then
        self:OnMainBuildLevelInit()
      end
      if DataCenter.BuildManager.MainLv and self.level - DataCenter.BuildManager.MainLv == 1 then
        self:OnMainBuildLevelUpdate()
      end
      DataCenter.BuildManager.MainLv = self.level
      local seasonType = SeasonUtil.GetSeasonType()
      if self.level >= SEASON_MIN_LEVEL and seasonType ~= SeasonMapType.Nothing then
        DataCenter.AllianceMineManager:InitTemplates()
        DataCenter.SeasonRewardDataManager:InitAchievementsGroupData(true, true)
        EventManager:GetInstance():Broadcast(EventId.SeasonStatusChanged, LuaEntry.Player:GetSelfServerId())
      end
    end
    CS.GameEntry.Setting:SetInt(SettingKeys.FUN_BUILD_MAIN_LEVEL, self.level)
    local enumName = CS.System.Enum.GetName(typeof(CS.URLGroupType), CS.NetworkURLConfig.URLGroupType)
    DataCenter.AccountListManager:UpdatePlayerMainLv(LuaEntry.Player.serverId, LuaEntry.Player.uid, self.level, tostring(enumName), message.fromReload)
    DataCenter.LWTrailTowerManager:UpLvGetTrailTowerInfo()
    EventManager:GetInstance():Broadcast(EventId.HeroStationUpdate)
    EventManager:GetInstance():Broadcast(EventId.RefreshWelfareRedDot)
    EventManager:GetInstance():Broadcast(EventId.MainLvUp)
    EventManager:GetInstance():Broadcast(EventId.MainPosChanged)
  end
  local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.itemId)
  if template ~= nil then
    self.isWorldBuild = template:IsSeasonBuild()
    self.build_tab_type = template.tab_type
  end
  self.expireTimeStampMS = 0
  if self.itemId == BuildingTypes.LW_GIFT_PACKAGE and 0 < self.growValStartTime then
    local buildDesTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.itemId)
    if buildDesTemplate then
      local addTime = 0
      local para3 = buildDesTemplate.para3
      if not string.IsNullOrEmpty(para3) then
        addTime = tonumber(para3)
      end
      if 0 < addTime then
        self.expireTimeStampMS = self.growValStartTime + addTime * 1000
      end
    end
  end
  return refreshBuild
end

function BuildingDate:OnMainBuildLevelUpdate()
  local str = string.format("%s;%s", DataCenter.BuildManager.MainLv, LuaEntry.Player.serverId)
  CS.GameEntry.Resource:SyncGameLogicInfo(str)
  local levelLimit = LuaEntry.DataConfig:TryGetNum("draw_num_show_control", "k1", 20)
  if self.level == levelLimit then
    Logger.Log("RECRUIT_CARD_REWARD_GET   false")
    Setting:SetBool(SettingKeys.RECRUIT_CARD_REWARD_GET, false)
  end
end

function BuildingDate:OnMainBuildLevelInit()
  local levelLimit = LuaEntry.DataConfig:TryGetNum("draw_num_show_control", "k1", 20)
  local hasValue = Setting:HasSetting(SettingKeys.RECRUIT_CARD_REWARD_GET)
  if not hasValue then
    local isOn = levelLimit > self.level
    Setting:SetBool(SettingKeys.RECRUIT_CARD_REWARD_GET, isOn)
  end
end

local function SetFlameState(self)
  if self.flameType ~= 1 then
    return self.flameType == 2
  end
  local world = CS.SceneManager.World
  if IsNull(world) then
    return
  end
  local cityObj = CS.SceneManager.World:GetBuildingByPoint(self.pointId)
  if not cityObj then
    return
  end
  local isOn = LuaEntry.Effect:CheckCityFarmState()
  local flameObj = cityObj.gameObject.transform:Find("cityStateEffect")
  if not IsNull(flameObj) then
    flameObj = flameObj.gameObject.transform:Find("fameEffecrRoot")
    if not IsNull(flameObj) then
      flameObj.gameObject:SetActive(isOn)
    end
  end
  if self.level > 4 then
    self.flameType = flameObj and 2 or 3
  end
  return flameObj
end

local function GetResourcePercent(self)
  local result = 0
  local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.itemId, self.level)
  if buildLevelTemplate ~= nil then
    local outSpeed = buildLevelTemplate:GetCollectSpeed() / 1000
    if 0 < outSpeed then
      local now = UITimeManager:GetInstance():GetServerTime()
      if 0 < self.unavailableTime and now > self.unavailableTime then
        now = self.unavailableTime
      end
      if 0 < self.produceEndTime and now > self.produceEndTime then
        now = self.produceEndTime
      end
      local count = (now - self.lastCollectTime) * outSpeed
      local max = buildLevelTemplate:GetCollectMax()
      if count > max then
        count = max
      end
      result = count / max
    end
  end
  return result
end

local function GetNextChangeTimeByPercent(self, percent)
  local result = 0
  local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.itemId, self.level)
  if buildLevelTemplate ~= nil then
    local outSpeed = buildLevelTemplate:GetCollectSpeed() / 1000
    if 0 < outSpeed and self.unavailableTime == 0 then
      local now = UITimeManager:GetInstance():GetServerTime()
      local max = buildLevelTemplate:GetCollectMax()
      result = percent / 100 * max / outSpeed + self.lastCollectTime - now
    end
  end
  return result
end

local function GetCenterIndex(self)
  local buildDesTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.itemId)
  if buildDesTemplate ~= nil then
    return BuildingUtils.GetBuildModelCenter(self.pointId, buildDesTemplate.tileX, buildDesTemplate.tileY)
  end
  return self.pointId
end

local function GetCenterVec(self)
  local buildDesTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.itemId)
  if buildDesTemplate ~= nil then
    if self.isWorldBuild then
      return BuildingUtils.GetBuildModelCenterVec(self.pointId, buildDesTemplate.tileX, buildDesTemplate.tileY, ForceChangeScene.World)
    else
      return BuildingUtils.GetBuildModelCenterVec(self.pointId, buildDesTemplate.tileX, buildDesTemplate.tileY, ForceChangeScene.City)
    end
  end
  if self.isWorldBuild then
    return SceneUtils.TileIndexToWorld(self.pointId, ForceChangeScene.World)
  end
  return SceneUtils.TileIndexToWorld(self.pointId, ForceChangeScene.City)
end

function BuildingDate:GetRangedPoints()
  if self.cachedRangedPoints and self.cachedPointId == self.pointId and self.cachedItemId == self.itemId then
    return self.cachedRangedPoints, self.cachedMinPointId, self.cachedMaxPointId
  end
  local rangedPoints = {}
  local buildDesTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.itemId)
  local minPointId = 9999
  local maxPointId = -9999
  if buildDesTemplate ~= nil then
    local maxX = buildDesTemplate.tileX - 1
    local maxY = buildDesTemplate.tileY - 1
    for x = 0, maxX do
      for y = 0, maxY do
        local pointId = SceneUtils.GetIndexByOffset(self.pointId, -x, -y, self.isWorldBuild == true and ForceChangeScene.World or ForceChangeScene.City)
        if pointId then
          rangedPoints[pointId] = true
          if minPointId > pointId then
            minPointId = pointId
          end
          if maxPointId < pointId then
            maxPointId = pointId
          end
        end
      end
    end
    self.cachedRangedPoints = rangedPoints
    self.cachedPointId = self.pointId
    self.cachedMinPointId = minPointId
    self.cachedMaxPointId = maxPointId
    self.cachedItemId = self.itemId
  end
  return rangedPoints, minPointId, maxPointId
end

local function IsRangePoint(self, index)
  if self.isWorldBuild then
    local buildDesTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.itemId)
    if buildDesTemplate ~= nil then
      local maxX = buildDesTemplate.tileX - 1
      local maxY = buildDesTemplate.tileY - 1
      for x = 0, maxX do
        for y = 0, maxY do
          if index == SceneUtils.GetIndexByOffset(self.pointId, -x, -y) then
            return true
          end
        end
      end
    end
  else
    local rangedPoints, minPointId, maxPointId = self:GetRangedPoints()
    return rangedPoints[index] ~= nil
  end
  return false
end

local function IsUpgradeFinish(self)
  local now = UITimeManager:GetInstance():GetServerTime()
  return self.updateTime > 0 and now >= self.updateTime
end

local function IsActive(self)
  return self.state ~= BuildingStateType.FoldUp and self.level > 0
end

local function IsFixFinish(self)
  local now = UITimeManager:GetInstance():GetServerTime()
  return self.destroyEndTime > 0 and now >= self.destroyEndTime
end

local function IsInFix(self)
  local now = UITimeManager:GetInstance():GetServerTime()
  return self.destroyEndTime > 0 and now < self.destroyEndTime
end

local function IsUpgrading(self)
  local now = UITimeManager:GetInstance():GetServerTime()
  return self.updateTime > 0 and now < self.updateTime
end

local function GetAssignedHeroCount(self)
  local count = 0
  if self.assignedHeroList ~= nil then
    for k, v in pairs(self.assignedHeroList) do
      if v ~= nil and string.IsNullOrEmpty(v) == false then
        count = count + 1
      end
    end
  end
  return count
end

local function GetIsVacancyWorker(self)
  local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.itemId, self.level)
  local count = GetAssignedHeroCount(self)
  if count < buildLevelTemplate.hero_slots then
    return buildLevelTemplate.hero_slots - count
  end
end

local function GetEmptyWorkerSlot(self)
  local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.itemId, self.level)
  local count = GetAssignedHeroCount(self)
  if count < buildLevelTemplate.hero_slots then
    for i = 1, buildLevelTemplate.hero_slots do
      if self.assignedHeroList[i] == nil or string.IsNullOrEmpty(self.assignedHeroList[i]) then
        return i
      end
    end
  end
end

local function GetLowQualityWorkerData(self)
  local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.itemId, self.level)
  local lowWorkerData = {}
  if tonumber(buildLevelTemplate.hero_slots) >= 1 then
    local quality = 999
    local workerData
    for i, uid in pairs(self.assignedHeroList) do
      workerData = DataCenter.WorkerDataManager:GetWorkerDataByUid(tonumber(uid))
      if workerData and quality >= workerData.quality then
        quality = workerData.quality
        lowWorkerData = workerData
      end
    end
  end
  return lowWorkerData
end

local function GetWorkerList(self)
  local workerData
  local workerList = {}
  for i, uid in pairs(self.assignedHeroList) do
    workerData = DataCenter.WorkerDataManager:GetWorkerDataByUid(tonumber(uid))
    table.insert(workerList, workerData)
  end
  table.sort(workerList, function(a, b)
    if a.quality > b.quality then
      return true
    end
  end)
  return workerList
end

local function GetEffect(self, effectId)
  if self.effects and self.effects[effectId] then
    return self.effects[effectId]
  end
end

local function GetBuildEffect(self, effectId)
  local workerData, playerEffect
  local effect = 0
  for i, uid in pairs(self.assignedHeroList) do
    if not string.IsNullOrEmpty(uid) then
      workerData = DataCenter.WorkerDataManager:GetWorkerDataByUid(tonumber(uid))
      effect = effect + workerData:GetWorkerProperty(effectId)
    end
  end
  playerEffect = LuaEntry.Effect:GetGameEffect(effectId)
  playerEffect = playerEffect or 0
  effect = effect + playerEffect
  return effect
end

local function GetIsDecorate(self)
  local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.itemId)
  if template and template.tab_type == UIBuildListTabType.Decorate then
    return true
  end
end

local function GetDecorNum(self)
  if self.decorNum == nil then
    return -1
  end
  return self.decorNum
end

local function ClientRefreshBuildingState(self)
  local prevState = self.state
  self.state = BuildingUtils.GetConditionBuildingState(self)
  return prevState ~= self.state
end

local function CheckBuildingWorkerRedDot(self)
  local isRedDot = false
  local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.itemId, self.level)
  local count = GetAssignedHeroCount(self)
  local workerDataList = DataCenter.WorkerDataManager:GetAvailableWorkersByBuildItemId(self.itemId)
  if buildLevelTemplate == nil then
    return isRedDot
  end
  if count < buildLevelTemplate.hero_slots and 0 < #workerDataList then
    isRedDot = true
    return isRedDot
  end
  local minRankPower = -1
  for i, uid in pairs(self.assignedHeroList) do
    local workerData = DataCenter.WorkerDataManager:GetWorkerDataByUid(tonumber(uid))
    if workerData then
      if minRankPower < 0 then
        minRankPower = workerData.rankPower
      elseif minRankPower > workerData.rankPower then
        minRankPower = workerData.rankPower
      end
    end
  end
  for i = 1, #workerDataList do
    if minRankPower < workerDataList[i].rankPower then
      isRedDot = true
      return isRedDot
    end
  end
  return isRedDot
end

local function CheckBuildingWorkerSlotRedDot(self, index)
  local isRedDot = false
  local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.itemId, self.level)
  if buildLevelTemplate == nil then
    return isRedDot
  end
  if index > buildLevelTemplate.hero_slots or index < 1 then
    return isRedDot
  end
  local workerDataList = DataCenter.WorkerDataManager:GetAvailableWorkersByBuildItemId(self.itemId)
  if (self.assignedHeroList[index] == nil or string.IsNullOrEmpty(self.assignedHeroList[index])) and 0 < #workerDataList then
    isRedDot = true
    return isRedDot
  end
  local minRankPower = -1
  local uid = self.assignedHeroList[index]
  local workerData = DataCenter.WorkerDataManager:GetWorkerDataByUid(tonumber(uid))
  if workerData then
    minRankPower = workerData.rankPower
  end
  for i = 1, #workerDataList do
    if minRankPower < workerDataList[i].rankPower then
      isRedDot = true
      return isRedDot
    end
  end
  return isRedDot
end

function BuildingDate:IsMainBuilding()
  if not self.itemId then
    return false
  end
  return self.itemId == BuildingTypes.FUN_BUILD_MAIN
end

local function IsTheHighestLevel(self)
  local datas = DataCenter.BuildManager:GetBuildingDatasByBuildingId(self.id)
  for k, v in pairs(datas) do
    if v ~= self and v.level > self.level then
      return false
    end
  end
  return true
end

local function CheckRecommend(self)
  if DataCenter.BuildManager.MainLv < 8 then
    return
  end
  if DataCenter.BuildManager.MainLv > 30 then
    return
  end
  if self.id == BuildingTypes.FUN_BUILD_MAIN then
    return
  end
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(BuildingTypes.FUN_BUILD_MAIN)
  local lv = DataCenter.BuildManager.MainLv
  local mainBuildData = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.FUN_BUILD_MAIN)[1]
  if mainBuildData:IsUpgradeFinish() or mainBuildData:IsUpgrading() then
    lv = lv + 1
  end
  local mainBuidingTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(BuildingTypes.FUN_BUILD_MAIN, lv)
  local canShowUpgrade = buildTemplate.max_level > self.level and self.level > 0
  if canShowUpgrade and mainBuidingTemplate ~= nil and not mainBuidingTemplate:IsTimeConditionValid() then
    canShowUpgrade = false
  end
  if not canShowUpgrade then
    return
  end
  local preBuild = mainBuidingTemplate:GetPreBuild()
  if not preBuild then
    return
  end
  for _, v1 in ipairs(preBuild) do
    if v1.buildId == BuildingTypes.FUN_BUILD_SCIENE and (self.itemId == BuildingTypes.FUN_BUILD_SCIENE or self.itemId == BuildingTypes.LW_BUILE_SCIENCE_TWO or self.itemId == BuildingTypes.LW_BUILE_SCIENCE_THREE) then
      local itemId = GoToUtil.GetHighestLevelBuild(BuildingTypes.FUN_BUILD_SCIENE, BuildingTypes.LW_BUILE_SCIENCE_TWO, BuildingTypes.LW_BUILE_SCIENCE_THREE)
      if self.itemId == itemId then
        return true
      end
      local data = DataCenter.BuildManager:GetBuildingDatasByBuildingId(itemId)[1]
      return data.level == self.level
    elseif v1.buildId == BuildingTypes.LW_BUILD_TANKCENTER and (self.itemId == BuildingTypes.LW_BUILD_TANKCENTER or self.itemId == BuildingTypes.LW_BUILD_ARTILLERYCENTER or self.itemId == BuildingTypes.LW_BUILD_AIRCRAFTCENTER) then
      local itemId = GoToUtil.GetHighestLevelBuild(BuildingTypes.LW_BUILD_TANKCENTER, BuildingTypes.LW_BUILD_ARTILLERYCENTER, BuildingTypes.LW_BUILD_AIRCRAFTCENTER)
      if self.itemId == itemId then
        return true
      end
      local data = DataCenter.BuildManager:GetBuildingDatasByBuildingId(itemId)[1]
      return data.level == self.level
    end
    if v1.buildId == self.itemId and v1.level > self.level then
      for _, v2 in ipairs(preBuild) do
        if v2.buildId == self.itemId then
          local datas = DataCenter.BuildManager:GetBuildingDatasByBuildingId(v2.buildId)
          for _, v3 in pairs(datas) do
            if v2.level <= v3.level then
              return false
            end
            if v3.level > self.level then
              return false
            end
          end
        end
      end
      return true
    end
  end
end

BuildingDate.__init = __init
BuildingDate.__delete = __delete
BuildingDate.reset = reset
BuildingDate.UpdateInfo = UpdateInfo
BuildingDate.GetResourcePercent = GetResourcePercent
BuildingDate.GetCenterIndex = GetCenterIndex
BuildingDate.GetCenterVec = GetCenterVec
BuildingDate.IsRangePoint = IsRangePoint
BuildingDate.IsUpgradeFinish = IsUpgradeFinish
BuildingDate.IsActive = IsActive
BuildingDate.IsFixFinish = IsFixFinish
BuildingDate.IsInFix = IsInFix
BuildingDate.IsUpgrading = IsUpgrading
BuildingDate.GetNextChangeTimeByPercent = GetNextChangeTimeByPercent
BuildingDate.GetAssignedHeroCount = GetAssignedHeroCount
BuildingDate.GetIsVacancyWorker = GetIsVacancyWorker
BuildingDate.GetLowQualityWorkerData = GetLowQualityWorkerData
BuildingDate.GetEffect = GetEffect
BuildingDate.GetEmptyWorkerSlot = GetEmptyWorkerSlot
BuildingDate.GetWorkerList = GetWorkerList
BuildingDate.GetBuildEffect = GetBuildEffect
BuildingDate.GetIsDecorate = GetIsDecorate
BuildingDate.SetFlameState = SetFlameState
BuildingDate.GetDecorNum = GetDecorNum
BuildingDate.ClientRefreshBuildingState = ClientRefreshBuildingState
BuildingDate.CheckBuildingWorkerRedDot = CheckBuildingWorkerRedDot
BuildingDate.CheckBuildingWorkerSlotRedDot = CheckBuildingWorkerSlotRedDot
BuildingDate.CheckRecommend = CheckRecommend
BuildingDate.IsTheHighestLevel = IsTheHighestLevel
return BuildingDate
