local BuildTimeManager = BaseClass("BuildTimeManager")
local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local BuildTimeTip = require("Scene.BuildTimeTip.BuildTimeTip")
local BuildTimeTipTrainField = require("Scene.BuildTimeTip.BuildTimeTipTrainField")
local BuildTimeTipFarm = require("Scene.BuildTimeTip.BuildTimeTipFarm")
local SceneBuildTimeTipCircle = require("Scene.BuildTimeTip.SceneBuildTimeTipCircle")
local BuildTimeHeroCountdownTip = require("Scene.BuildTimeTip.BuildTimeHeroCountdownTip")
local Const = require("Scene.LWBattle.Const")
local ChangeTime = 6000
local WaitTime = 3000
local IconBgResetScale = Vector3.New(1, 1, 1)
local TrainScale = Vector3.New(1, 1, 1)

local function __init(self)
  self.allBuildTimes = {}
  self.loadingBuildTimes = {}
  self.buildTypeTimeType = {}
  self:AddListener()
  self.showFarmTimeUuid = 0
  self.showFarmQueueUuid = 0
  self.isAddAlpha = false
  self.curTime = 0
end

local function __delete(self)
  self:RemoveUpdate()
  self:RemoveListener()
  for k, v in pairs(self.allBuildTimes) do
    local temp = v.request
    v:OnDestroy()
    temp:Destroy()
  end
  self.allBuildTimes = nil
  self.loadingBuildTimes = nil
  self.showFarmTimeUuid = nil
  self.showFarmQueueUuid = nil
  self.isAddAlpha = nil
  self.curTime = nil
  self.buildTypeTimeType = nil
end

local function Startup()
end

local function AddUpdate(self)
  if self.__update_handle == nil then
    function self.__update_handle()
      self:Update()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.__update_handle)
  end
end

local function RemoveUpdate(self)
  if self.__update_handle ~= nil then
    UpdateManager:GetInstance():RemoveUpdate(self.__update_handle)
    self.__update_handle = nil
  end
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.BuildPlace, self.OnBuildPlaceSignal)
  EventManager:GetInstance():AddListener(EventId.BuildUpgradeStart, self.OnBuildUpgradeStartSignal)
  EventManager:GetInstance():AddListener(EventId.BuildUpgradeFinish, self.OnBuildUpgradeFinishSignal)
  EventManager:GetInstance():AddListener(EventId.BuildFixStart, self.OnBuildFixUpgradeStartSignal)
  EventManager:GetInstance():AddListener(EventId.BuildFixFinish, self.OnBuildFixUpgradeFinishSignal)
  EventManager:GetInstance():AddListener(EventId.AddBuildFixSpeedSuccess, self.AddBuildFixSpeedSuccessSignal)
  EventManager:GetInstance():AddListener(EventId.TrainingArmy, self.OnBuildTrainingStartSignal)
  EventManager:GetInstance():AddListener(EventId.QUEUE_TIME_END, self.QueueTimeEndSignal)
  EventManager:GetInstance():AddListener(EventId.OnScienceQueueResearch, self.OnScienceQueueResearchSignal)
  EventManager:GetInstance():AddListener(EventId.HospitaiStart, self.HospitaiStartSignal)
  EventManager:GetInstance():AddListener(EventId.AddSpeedSuccess, self.AddSpeedSuccessSignal)
  EventManager:GetInstance():AddListener(EventId.AddBuildSpeedSuccess, self.AddBuildSpeedSuccessSignal)
  EventManager:GetInstance():AddListener(EventId.ClickFarmBuildShow, self.ShowFarmTimeSignal)
  EventManager:GetInstance():AddListener(EventId.ClickFarmBuildHide, self.HideFarmTimeSignal)
  EventManager:GetInstance():AddListener(EventId.ClickFarmBuildHideOnly, self.HideFarmTimeSignalOnly)
  EventManager:GetInstance():AddListener(EventId.RefreshEarthOrder, self.RefreshEarthOrderSignal)
  EventManager:GetInstance():AddListener(EventId.GetNewEarthOrder, self.RefreshEarthOrderSignal)
  EventManager:GetInstance():AddListener(EventId.EndEarthOrder, self.RefreshEarthOrderSignal)
  EventManager:GetInstance():AddListener(EventId.ViewEndEarthOrder, self.RefreshEarthOrderSignal)
  EventManager:GetInstance():AddListener(EventId.RefreshResidentOrder, self.RefreshResidentOrderSignal)
  EventManager:GetInstance():AddListener(EventId.CreatWormholeBuild, self.OnBuildPushInfoSignal)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.BuildFixStart, self.OnBuildFixUpgradeStartSignal)
  EventManager:GetInstance():RemoveListener(EventId.BuildFixFinish, self.OnBuildFixUpgradeFinishSignal)
  EventManager:GetInstance():RemoveListener(EventId.AddBuildFixSpeedSuccess, self.AddBuildFixSpeedSuccessSignal)
  EventManager:GetInstance():RemoveListener(EventId.RefreshResidentOrder, self.RefreshResidentOrderSignal)
  EventManager:GetInstance():RemoveListener(EventId.BuildPlace, self.OnBuildPlaceSignal)
  EventManager:GetInstance():RemoveListener(EventId.BuildUpgradeStart, self.OnBuildUpgradeStartSignal)
  EventManager:GetInstance():RemoveListener(EventId.BuildUpgradeFinish, self.OnBuildUpgradeFinishSignal)
  EventManager:GetInstance():RemoveListener(EventId.TrainingArmy, self.OnBuildTrainingStartSignal)
  EventManager:GetInstance():RemoveListener(EventId.QUEUE_TIME_END, self.QueueTimeEndSignal)
  EventManager:GetInstance():RemoveListener(EventId.OnScienceQueueResearch, self.OnScienceQueueResearchSignal)
  EventManager:GetInstance():RemoveListener(EventId.HospitaiStart, self.HospitaiStartSignal)
  EventManager:GetInstance():RemoveListener(EventId.AddSpeedSuccess, self.AddSpeedSuccessSignal)
  EventManager:GetInstance():RemoveListener(EventId.AddBuildSpeedSuccess, self.AddBuildSpeedSuccessSignal)
  EventManager:GetInstance():RemoveListener(EventId.ClickFarmBuildShow, self.ShowFarmTimeSignal)
  EventManager:GetInstance():RemoveListener(EventId.ClickFarmBuildHide, self.HideFarmTimeSignal)
  EventManager:GetInstance():RemoveListener(EventId.ClickFarmBuildHideOnly, self.HideFarmTimeSignalOnly)
  EventManager:GetInstance():RemoveListener(EventId.RefreshEarthOrder, self.RefreshEarthOrderSignal)
  EventManager:GetInstance():RemoveListener(EventId.GetNewEarthOrder, self.RefreshEarthOrderSignal)
  EventManager:GetInstance():RemoveListener(EventId.EndEarthOrder, self.RefreshEarthOrderSignal)
  EventManager:GetInstance():RemoveListener(EventId.ViewEndEarthOrder, self.RefreshEarthOrderSignal)
  EventManager:GetInstance():RemoveListener(EventId.CreatWormholeBuild, self.OnBuildPushInfoSignal)
end

local function GetBuildTimeTypeListByBuildType(self, buildType)
  if self.buildTypeTimeType[buildType] ~= nil then
    return self.buildTypeTimeType[buildType]
  end
  local list = {}
  table.insert(list, BuildTimeType.BuildTime_Fixing)
  table.insert(list, BuildTimeType.BuildTime_Upgrading)
  if buildType == BuildingTypes.FUN_BUILD_CAR_BARRACK then
    table.insert(list, BuildTimeType.BuildTime_CarSoldier)
  elseif buildType == BuildingTypes.FUN_BUILD_INFANTRY_BARRACK then
    table.insert(list, BuildTimeType.BuildTime_FootSoldier)
  elseif buildType == BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK then
    table.insert(list, BuildTimeType.BuildTime_BowSoldier)
  elseif buildType == BuildingTypes.APS_BUILD_FARM_FIELD then
    table.insert(list, BuildTimeType.BuildTime_Farm)
  elseif buildType == BuildingTypes.APS_BUILD_PASTURE_OSTRICH or buildType == BuildingTypes.APS_BUILD_PASTURE_CATTLE or buildType == BuildingTypes.APS_BUILD_PASTURE_SANDWORM then
    table.insert(list, BuildTimeType.BuildTime_pasture)
  elseif buildType == BuildingTypes.FUN_BUILD_TRADING_CENTER then
    table.insert(list, BuildTimeType.BuildTime_tradingCenter)
  elseif buildType == BuildingTypes.LW_BUILD_HERO_COUNTDOWN then
    table.insert(list, BuildTimeType.BuildTime_HeroCountdown)
  end
  self.buildTypeTimeType[buildType] = list
  return list
end

local function Update(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  for k, v in pairs(self.allBuildTimes) do
    if v ~= nil then
      if not v.param and v.CheckTime then
        if v:CheckTime() then
          self:CheckGuideClickTime()
        end
      else
        local changeTime = v.param.endTime - curTime
        local maxTime = v.param.endTime - v.param.startTime
        if changeTime <= 0 then
          self:DeleteOneBuildTime(k)
          self:CheckGuideClickTime()
        elseif v.param.model == UIAssets.BuildTimeTip or v.param.model == UIAssets.BuildTimeTip1 or v.param.model == UIAssets.BuildTimeTip2 then
          local changeDelta = curTime - self.curTime
          local half = ChangeTime / 2
          if changeDelta > ChangeTime + WaitTime then
            self.curTime = curTime
            self.isAddAlpha = false
          elseif changeDelta > ChangeTime then
            self.isAddAlpha = nil
          elseif changeDelta > half then
            self.isAddAlpha = true
          else
            self.isAddAlpha = false
          end
          if self.isAddAlpha ~= nil then
            if self.isAddAlpha then
              v:RefreshUpdate(self.isAddAlpha, (changeDelta - half) / half)
            else
              v:RefreshUpdate(self.isAddAlpha, (half - changeDelta) / half)
            end
          end
          local tempValue = 1 - changeTime / maxTime
          v:RefreshSlider(tempValue)
          local tempTimeSec = math.ceil(changeTime / 1000)
          if tempTimeSec ~= v.lastTime then
            v:RefreshTime(tempTimeSec)
          end
        elseif v.param.model == UIAssets.BuildTimeTip4 then
          v:RefreshUpdate()
          local tempValue = 1 - changeTime / maxTime
          v:RefreshSlider(tempValue)
          local tempTimeSec = math.ceil(changeTime / 1000)
          if tempTimeSec ~= v.lastTime then
            v:RefreshTime(tempTimeSec)
          end
        end
      end
    end
  end
end

local function GetBuildNeedShowBuildTimeList(self, uuid)
  local retList = {}
  local data = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
  if data ~= nil and data.state ~= BuildingStateType.FoldUp then
    local buildId = data.itemId
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
    local extraHeight = self:GetExtraPos(buildId)
    local list = self:GetBuildTimeTypeListByBuildType(buildId)
    local isContinue = true
    if list ~= nil and buildTemplate ~= nil then
      local curTime = math.floor(UITimeManager:GetInstance():GetServerTime())
      for k, v in ipairs(list) do
        local needTip = false
        local param = {}
        param.bUuid = uuid
        if v == BuildTimeType.BuildTime_Fixing then
          if curTime < data.destroyEndTime and data.destroyEndTime > 0 and 0 <= data.level then
            isContinue = false
            param.buildTimeType = v
            param.endTime = data.destroyEndTime
            param.startTime = data.destroyStartTime
            if curTime < param.startTime then
              param.startTime = curTime
            end
            param.pos = data.pointId
            param.iconName = string.format(LoadPath.UIBuildBubble, "uibuild_time_icon_upgrade")
            param.iconBg = string.format(LoadPath.UIBuildBubble, "uibuild_time_bg_upgrade")
            param.iconBgScale = IconBgResetScale
            param.iconScale = ResetScale
            param.desName = ""
            param.tileX = buildTemplate.tileX
            param.tileY = buildTemplate.tileY
            param.model = UIAssets.SceneBuildTimeTipCircle
            param.extraHeight = extraHeight
            param.buildId = buildId
            needTip = true
          end
        elseif 0 >= data.destroyStartTime then
          if v == BuildTimeType.BuildTime_Upgrading then
            if curTime < data.updateTime and 0 <= data.level then
              isContinue = false
              param.buildTimeType = v
              param.endTime = data.updateTime
              param.startTime = data.startTime
              param.level = data.level
              if curTime < param.startTime then
                param.startTime = curTime
              end
              param.pos = data.pointId
              param.iconName = string.format(LoadPath.UIBuildBubble, "uibuild_time_icon_upgrade")
              param.iconBg = string.format(LoadPath.UIBuildBubble, "uibuild_time_bg_upgrade")
              param.iconBgScale = IconBgResetScale
              param.iconScale = ResetScale
              param.desName = ""
              param.tileX = buildTemplate.tileX
              param.tileY = buildTemplate.tileY
              param.model = UIAssets.SceneBuildTimeTipCircle
              param.extraHeight = extraHeight
              param.buildId = buildId
              needTip = true
            end
          elseif v == BuildTimeType.BuildTime_FootSoldier then
            local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.FootSoldier)
            if queue ~= nil and not queue:IsEnd() then
              local armyId = ""
              local tempList = string.split(queue.itemId, ";")
              local count = 0
              if tempList ~= nil and 3 < #tempList then
                armyId = tempList[3]
                count = tempList[4]
              elseif tempList ~= nil and 1 < #tempList then
                armyId = tempList[1]
                count = tempList[2]
              end
              local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(armyId)
              if template ~= nil then
                param.iconName = string.format(LoadPath.UIBuildBubble, "uibuild_time_icon_soldier")
                param.iconScale = TrainScale
                param.desName = Localization:GetString(template.name) .. "   x" .. count
              end
              isContinue = false
              param.buildTimeType = v
              param.endTime = queue.endTime
              param.startTime = queue.startTime
              param.pos = data.pointId
              param.tileX = buildTemplate.tileX
              param.tileY = buildTemplate.tileY
              param.model = UIAssets.SceneBuildTimeTipCircle
              param.extraHeight = extraHeight
              param.buildId = buildId
              needTip = true
            end
          elseif v == BuildTimeType.BuildTime_CarSoldier then
            local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.CarSoldier)
            if queue ~= nil and not queue:IsEnd() then
              local armyId = ""
              local count = 0
              local tempList = string.split(queue.itemId, ";")
              if tempList ~= nil and 3 < #tempList then
                armyId = tempList[3]
                count = tempList[4]
              elseif tempList ~= nil and 1 < #tempList then
                armyId = tempList[1]
                count = tempList[2]
              end
              local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(armyId)
              if template ~= nil then
                param.iconName = string.format(LoadPath.UIBuildBubble, "uibuild_time_icon_car")
                param.iconScale = TrainScale
                param.desName = Localization:GetString(template.name) .. "   x" .. count
              end
              isContinue = false
              param.buildTimeType = v
              param.endTime = queue.endTime
              param.startTime = queue.startTime
              param.pos = data.pointId
              param.tileX = buildTemplate.tileX
              param.tileY = buildTemplate.tileY
              param.model = UIAssets.SceneBuildTimeTipCircle
              param.extraHeight = extraHeight
              param.buildId = buildId
              needTip = true
            end
          elseif v == BuildTimeType.BuildTime_BowSoldier then
            local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.BowSoldier)
            if queue ~= nil and not queue:IsEnd() then
              local armyId = ""
              local tempList = string.split(queue.itemId, ";")
              local count = 0
              if tempList ~= nil and 3 < #tempList then
                armyId = tempList[3]
                count = tempList[4]
              elseif tempList ~= nil and 1 < #tempList then
                armyId = tempList[1]
                count = tempList[2]
              end
              local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(armyId)
              if template ~= nil then
                param.iconName = string.format(LoadPath.UIBuildBubble, "uibuild_time_icon_plane")
                param.iconScale = TrainScale
                param.desName = Localization:GetString(template.name) .. "   x" .. count
              end
              isContinue = false
              param.buildTimeType = v
              param.endTime = queue.endTime
              param.startTime = queue.startTime
              param.pos = data.pointId
              param.tileX = buildTemplate.tileX
              param.tileY = buildTemplate.tileY
              param.model = UIAssets.SceneBuildTimeTipCircle
              param.extraHeight = extraHeight
              param.buildId = buildId
              needTip = true
            end
          elseif v == BuildTimeType.BuildTime_Injuries then
            local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.Hospital)
            if queue ~= nil and not queue:IsEnd() then
              isContinue = false
              param.buildTimeType = v
              param.endTime = queue.endTime
              param.startTime = queue.startTime
              param.pos = data.pointId
              param.iconName = string.format(LoadPath.UIBuildBubble, "uibuild_time_icon_zhiliao")
              param.iconBg = string.format(LoadPath.UIBuildBubble, "uibuild_time_bg_upgrade")
              param.iconBgScale = IconBgResetScale
              param.iconScale = ResetScale
              param.desName = Localization:GetString("130057")
              param.tileX = buildTemplate.tileX
              param.tileY = buildTemplate.tileY
              param.model = UIAssets.SceneBuildTimeTipCircle
              param.extraHeight = extraHeight
              param.buildId = buildId
              needTip = true
            end
          elseif v == BuildTimeType.BuildTime_Science then
            local queue = DataCenter.QueueDataManager:GetQueueByBuildUuidForScience(uuid)
            if queue ~= nil and not queue:IsEnd() then
              isContinue = false
              param.buildTimeType = v
              param.endTime = queue.endTime
              param.startTime = queue.startTime
              param.pos = data.pointId
              local template = DataCenter.ScienceManager:GetSearchingScienceTemplate(queue.uuid)
              if template ~= nil then
                param.iconName = string.format(LoadPath.UIBuildBubble, "uibuild_time_icon_science")
                param.iconScale = TrainScale
                param.desName = Localization:GetString(template.name)
              end
              param.iconBg = string.format(LoadPath.UIBuildBubble, "uibuild_time_bg_upgrade")
              param.iconBgScale = IconBgResetScale
              param.tileX = buildTemplate.tileX
              param.tileY = buildTemplate.tileY
              param.model = UIAssets.SceneBuildTimeTipCircle
              param.extraHeight = extraHeight
              param.buildId = buildId
              needTip = true
            end
          elseif v == BuildTimeType.BuildTime_Farm then
            local queue = DataCenter.QueueDataManager:GetQueueByBuildUuidForFarm(uuid)
            if queue ~= nil and not queue:IsEnd() then
              isContinue = false
              param.buildTimeType = v
              param.endTime = queue.endTime
              param.startTime = queue.startTime
              param.pos = data.pointId
              param.iconBg = nil
              param.iconBgScale = IconBgResetScale
              param.iconScale = ResetScale
              local nameStr = Localization:GetString("130080")
              local functionTemplate = DataCenter.FarmingDataManager:GetFramingTemplate(queue.itemId)
              param.iconName = string.format(LoadPath.ItemPath, functionTemplate.icon)
              if functionTemplate ~= nil then
                local itemId = ""
                local count = 0
                if queue:GetParaState() == QueueProductState.PASTURE_MATURE then
                  table.walk(functionTemplate.second_get_goods, function(m, n)
                    itemId = m
                    count = n
                  end)
                else
                  table.walk(functionTemplate.get_goods, function(m, n)
                    itemId = m
                    count = n
                  end)
                end
                local resourceItemData = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(itemId)
                if resourceItemData ~= nil then
                  nameStr = Localization:GetString(resourceItemData.name)
                end
              end
              param.desName = nameStr
              param.tileX = buildTemplate.tileX
              param.tileY = buildTemplate.tileY
              param.queueUuid = queue.uuid
              param.speedItem = functionTemplate.speed_item
              param.showGold = true
              param.model = UIAssets.BuildTimeTip4
              param.extraHeight = extraHeight
              param.buildId = buildId
              needTip = true
            end
          elseif v == BuildTimeType.BuildTime_pasture then
            if self.showFarmQueueUuid == 0 then
              local endTime = LongMaxValue
              local queueList = DataCenter.QueueDataManager:GetQueueListByBuildUuidForPasture(uuid)
              if queueList ~= nil then
                table.walk(queueList, function(a, b)
                  if b:GetQueueState() == NewQueueState.Work and endTime > b.endTime then
                    self.showFarmQueueUuid = b.uuid
                    endTime = b.endTime
                  end
                end)
              end
            end
            if self.showFarmQueueUuid ~= 0 then
              local queue = DataCenter.QueueDataManager:GetQueueByUuid(self.showFarmQueueUuid)
              if queue ~= nil and not queue:IsEnd() then
                isContinue = false
                param.buildTimeType = v
                param.endTime = queue.endTime
                param.startTime = queue.startTime
                param.pos = data.pointId
                param.iconBg = nil
                param.iconBgScale = IconBgResetScale
                param.iconScale = ResetScale
                local nameStr = Localization:GetString("130080")
                local functionTemplate = DataCenter.FarmingDataManager:GetFramingTemplate(queue.itemId)
                param.iconName = string.format(LoadPath.ItemPath, functionTemplate.icon)
                if functionTemplate ~= nil then
                  local itemId = ""
                  local count = 0
                  if queue:GetParaState() == QueueProductState.PASTURE_MATURE then
                    table.walk(functionTemplate.second_get_goods, function(m, n)
                      itemId = m
                      count = n
                    end)
                  else
                    table.walk(functionTemplate.get_goods, function(m, n)
                      itemId = m
                      count = n
                    end)
                  end
                  local resourceItemData = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(itemId)
                  if resourceItemData ~= nil then
                    nameStr = Localization:GetString(resourceItemData.name)
                  end
                end
                param.desName = nameStr
                param.tileX = buildTemplate.tileX
                param.tileY = buildTemplate.tileY
                param.queueUuid = queue.uuid
                param.speedItem = functionTemplate.speed_item
                param.showGold = true
                param.model = UIAssets.BuildTimeTip4
                param.extraHeight = extraHeight
                param.buildId = buildId
                needTip = true
              end
            end
          elseif v == BuildTimeType.BuildTime_HeroCountdown and data.fixCityHeroEndTime and curTime < data.fixCityHeroEndTime then
            isContinue = false
            param.buildTimeType = v
            param.endTime = data.fixCityHeroEndTime
            param.pos = data.pointId
            param.iconName = string.format(LoadPath.UIBuildBubble, "uibuild_time_icon_upgrade")
            param.iconBg = string.format(LoadPath.UIBuildBubble, "uibuild_time_bg_upgrade")
            param.iconBgScale = IconBgResetScale
            param.iconScale = ResetScale
            param.desName = ""
            param.tileX = buildTemplate.tileX
            param.tileY = buildTemplate.tileY
            param.model = UIAssets.BuildTimeHeroCountdownTip
            param.extraHeight = extraHeight
            param.buildId = buildId
            param.heroId = data.fixCityHeroId
            needTip = true
          end
        end
        if needTip then
          table.insert(retList, param)
        end
      end
    end
  end
  return retList
end

local function GetBuildNeedShowBuildTime(self, uuid)
  local data = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
  if data ~= nil and data.state ~= BuildingStateType.FoldUp then
    local buildId = data.itemId
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
    local extraHeight = self:GetExtraPos(buildId)
    local list = self:GetBuildTimeTypeListByBuildType(buildId)
    if list ~= nil and buildTemplate ~= nil then
      local curTime = math.floor(UITimeManager:GetInstance():GetServerTime())
      local isContinue = true
      local param = {}
      param.bUuid = uuid
      for k, v in ipairs(list) do
        if isContinue then
          if v == BuildTimeType.BuildTime_Fixing then
            if curTime < data.destroyEndTime and data.destroyEndTime > 0 and 0 <= data.level then
              isContinue = false
              param.buildTimeType = v
              param.endTime = data.destroyEndTime
              param.startTime = data.destroyStartTime
              if curTime < param.startTime then
                param.startTime = curTime
              end
              param.pos = data.pointId
              param.iconName = string.format(LoadPath.UIBuildBubble, "uibuild_time_icon_upgrade")
              param.iconBg = string.format(LoadPath.UIBuildBubble, "uibuild_time_bg_upgrade")
              param.iconBgScale = IconBgResetScale
              param.iconScale = ResetScale
              param.desName = ""
              param.tileX = buildTemplate.tileX
              param.tileY = buildTemplate.tileY
              param.model = UIAssets.SceneBuildTimeTipCircle
              param.extraHeight = extraHeight
              param.buildId = buildId
            end
          elseif 0 >= data.destroyStartTime then
            if v == BuildTimeType.BuildTime_Upgrading then
              if curTime < data.updateTime and 0 <= data.level then
                isContinue = false
                param.buildTimeType = v
                param.endTime = data.updateTime
                param.startTime = data.startTime
                if curTime < param.startTime then
                  param.startTime = curTime
                end
                param.pos = data.pointId
                param.iconName = string.format(LoadPath.UIBuildBubble, "uibuild_time_icon_upgrade")
                param.iconBg = string.format(LoadPath.UIBuildBubble, "uibuild_time_bg_upgrade")
                param.iconBgScale = IconBgResetScale
                param.iconScale = ResetScale
                param.desName = ""
                param.tileX = buildTemplate.tileX
                param.tileY = buildTemplate.tileY
                param.model = UIAssets.SceneBuildTimeTipCircle
                param.extraHeight = extraHeight
                param.buildId = buildId
              end
            elseif v == BuildTimeType.BuildTime_FootSoldier then
              local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.FootSoldier)
              if queue ~= nil and not queue:IsEnd() then
                local armyId = ""
                local tempList = string.split(queue.itemId, ";")
                local count = 0
                if tempList ~= nil and 3 < #tempList then
                  armyId = tempList[3]
                  count = tempList[4]
                elseif tempList ~= nil and 1 < #tempList then
                  armyId = tempList[1]
                  count = tempList[2]
                end
                local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(armyId)
                if template ~= nil then
                  param.iconName = string.format(LoadPath.UIBuildBubble, "uibuild_time_icon_soldier")
                  param.iconScale = TrainScale
                  param.desName = Localization:GetString(template.name) .. "   x" .. count
                end
                isContinue = false
                param.buildTimeType = v
                param.endTime = queue.endTime
                param.startTime = queue.startTime
                param.pos = data.pointId
                param.tileX = buildTemplate.tileX
                param.tileY = buildTemplate.tileY
                param.model = UIAssets.SceneBuildTimeTipCircle
                param.extraHeight = extraHeight
                param.buildId = buildId
              end
            elseif v == BuildTimeType.BuildTime_CarSoldier then
              local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.CarSoldier)
              if queue ~= nil and not queue:IsEnd() then
                local armyId = ""
                local count = 0
                local tempList = string.split(queue.itemId, ";")
                if tempList ~= nil and 3 < #tempList then
                  armyId = tempList[3]
                  count = tempList[4]
                elseif tempList ~= nil and 1 < #tempList then
                  armyId = tempList[1]
                  count = tempList[2]
                end
                local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(armyId)
                if template ~= nil then
                  param.iconName = string.format(LoadPath.UIBuildBubble, "uibuild_time_icon_car")
                  param.iconScale = TrainScale
                  param.desName = Localization:GetString(template.name) .. "   x" .. count
                end
                isContinue = false
                param.buildTimeType = v
                param.endTime = queue.endTime
                param.startTime = queue.startTime
                param.pos = data.pointId
                param.tileX = buildTemplate.tileX
                param.tileY = buildTemplate.tileY
                param.model = UIAssets.SceneBuildTimeTipCircle
                param.extraHeight = extraHeight
                param.buildId = buildId
              end
            elseif v == BuildTimeType.BuildTime_BowSoldier then
              local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.BowSoldier)
              if queue ~= nil and not queue:IsEnd() then
                local armyId = ""
                local tempList = string.split(queue.itemId, ";")
                local count = 0
                if tempList ~= nil and 3 < #tempList then
                  armyId = tempList[3]
                  count = tempList[4]
                elseif tempList ~= nil and 1 < #tempList then
                  armyId = tempList[1]
                  count = tempList[2]
                end
                local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(armyId)
                if template ~= nil then
                  param.iconName = string.format(LoadPath.UIBuildBubble, "uibuild_time_icon_plane")
                  param.iconScale = TrainScale
                  param.desName = Localization:GetString(template.name) .. "   x" .. count
                end
                isContinue = false
                param.buildTimeType = v
                param.endTime = queue.endTime
                param.startTime = queue.startTime
                param.pos = data.pointId
                param.tileX = buildTemplate.tileX
                param.tileY = buildTemplate.tileY
                param.model = UIAssets.SceneBuildTimeTipCircle
                param.extraHeight = extraHeight
                param.buildId = buildId
              end
            elseif v == BuildTimeType.BuildTime_Injuries then
              local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.Hospital)
              if queue ~= nil and not queue:IsEnd() then
                isContinue = false
                param.buildTimeType = v
                param.endTime = queue.endTime
                param.startTime = queue.startTime
                param.pos = data.pointId
                param.iconName = string.format(LoadPath.UIBuildBubble, "uibuild_time_icon_zhiliao")
                param.iconBg = string.format(LoadPath.UIBuildBubble, "uibuild_time_bg_upgrade")
                param.iconBgScale = IconBgResetScale
                param.iconScale = ResetScale
                param.desName = Localization:GetString("130057")
                param.tileX = buildTemplate.tileX
                param.tileY = buildTemplate.tileY
                param.model = UIAssets.SceneBuildTimeTipCircle
                param.extraHeight = extraHeight
                param.buildId = buildId
              end
            elseif v == BuildTimeType.BuildTime_Science then
              local queue = DataCenter.QueueDataManager:GetQueueByBuildUuidForScience(uuid)
              if queue ~= nil and not queue:IsEnd() then
                isContinue = false
                param.buildTimeType = v
                param.endTime = queue.endTime
                param.startTime = queue.startTime
                param.pos = data.pointId
                local template = DataCenter.ScienceManager:GetSearchingScienceTemplate(queue.uuid)
                if template ~= nil then
                  param.iconName = string.format(LoadPath.UIBuildBubble, "uibuild_time_icon_science")
                  param.iconScale = TrainScale
                  param.desName = Localization:GetString(template.name)
                end
                param.iconBg = string.format(LoadPath.UIBuildBubble, "uibuild_time_bg_upgrade")
                param.iconBgScale = IconBgResetScale
                param.tileX = buildTemplate.tileX
                param.tileY = buildTemplate.tileY
                param.model = UIAssets.SceneBuildTimeTipCircle
                param.extraHeight = extraHeight
                param.buildId = buildId
              end
            elseif v == BuildTimeType.BuildTime_Farm then
              local queue = DataCenter.QueueDataManager:GetQueueByBuildUuidForFarm(uuid)
              if queue ~= nil and not queue:IsEnd() then
                isContinue = false
                param.buildTimeType = v
                param.endTime = queue.endTime
                param.startTime = queue.startTime
                param.pos = data.pointId
                param.iconBg = nil
                param.iconBgScale = IconBgResetScale
                param.iconScale = ResetScale
                local nameStr = Localization:GetString("130080")
                local functionTemplate = DataCenter.FarmingDataManager:GetFramingTemplate(queue.itemId)
                param.iconName = string.format(LoadPath.ItemPath, functionTemplate.icon)
                if functionTemplate ~= nil then
                  local itemId = ""
                  local count = 0
                  if queue:GetParaState() == QueueProductState.PASTURE_MATURE then
                    table.walk(functionTemplate.second_get_goods, function(m, n)
                      itemId = m
                      count = n
                    end)
                  else
                    table.walk(functionTemplate.get_goods, function(m, n)
                      itemId = m
                      count = n
                    end)
                  end
                  local resourceItemData = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(itemId)
                  if resourceItemData ~= nil then
                    nameStr = Localization:GetString(resourceItemData.name)
                  end
                end
                param.desName = nameStr
                param.tileX = buildTemplate.tileX
                param.tileY = buildTemplate.tileY
                param.queueUuid = queue.uuid
                param.speedItem = functionTemplate.speed_item
                param.showGold = true
                param.model = UIAssets.BuildTimeTip4
                param.extraHeight = extraHeight
                param.buildId = buildId
              end
            elseif v == BuildTimeType.BuildTime_pasture then
              if self.showFarmQueueUuid == 0 then
                local endTime = LongMaxValue
                local queueList = DataCenter.QueueDataManager:GetQueueListByBuildUuidForPasture(uuid)
                if queueList ~= nil then
                  table.walk(queueList, function(a, b)
                    if b:GetQueueState() == NewQueueState.Work and endTime > b.endTime then
                      self.showFarmQueueUuid = b.uuid
                      endTime = b.endTime
                    end
                  end)
                end
              end
              if self.showFarmQueueUuid ~= 0 then
                local queue = DataCenter.QueueDataManager:GetQueueByUuid(self.showFarmQueueUuid)
                if queue ~= nil and not queue:IsEnd() then
                  isContinue = false
                  param.buildTimeType = v
                  param.endTime = queue.endTime
                  param.startTime = queue.startTime
                  param.pos = data.pointId
                  param.iconBg = nil
                  param.iconBgScale = IconBgResetScale
                  param.iconScale = ResetScale
                  local nameStr = Localization:GetString("130080")
                  local functionTemplate = DataCenter.FarmingDataManager:GetFramingTemplate(queue.itemId)
                  param.iconName = string.format(LoadPath.ItemPath, functionTemplate.icon)
                  if functionTemplate ~= nil then
                    local itemId = ""
                    local count = 0
                    if queue:GetParaState() == QueueProductState.PASTURE_MATURE then
                      table.walk(functionTemplate.second_get_goods, function(m, n)
                        itemId = m
                        count = n
                      end)
                    else
                      table.walk(functionTemplate.get_goods, function(m, n)
                        itemId = m
                        count = n
                      end)
                    end
                    local resourceItemData = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(itemId)
                    if resourceItemData ~= nil then
                      nameStr = Localization:GetString(resourceItemData.name)
                    end
                  end
                  param.desName = nameStr
                  param.tileX = buildTemplate.tileX
                  param.tileY = buildTemplate.tileY
                  param.queueUuid = queue.uuid
                  param.speedItem = functionTemplate.speed_item
                  param.showGold = true
                  param.model = UIAssets.BuildTimeTip4
                  param.extraHeight = extraHeight
                  param.buildId = buildId
                end
              end
            end
          end
        end
      end
      if not isContinue then
        return param
      end
    end
  end
  return nil
end

local function DeleteOneBuildTime(self, bUuid)
  if self.loadingBuildTimes[bUuid] ~= nil then
    self.loadingBuildTimes[bUuid] = nil
  end
  if self.allBuildTimes[bUuid] ~= nil then
    local temp = self.allBuildTimes[bUuid].request
    self.allBuildTimes[bUuid]:OnDestroy()
    temp:Destroy()
    self.allBuildTimes[bUuid] = nil
    self:UpdateTimer()
  end
end

local function UpdateTimer(self)
  if table.count(self.allBuildTimes) == 0 then
    self:RemoveUpdate()
  else
    self:AddUpdate()
  end
end

local function ShowOneBuildTime(self, bUuid, paramList)
  if self.loadingBuildTimes[bUuid] == nil then
    self.loadingBuildTimes[bUuid] = paramList
    local param = paramList and 0 < #paramList and paramList[1] or nil
    if not param then
      return
    end
    local tempModel = param.model
    if param.buildTimeType == BuildTimeType.BuildTime_Upgrading or param.buildTimeType == BuildTimeType.BuildTime_FootSoldier or param.buildTimeType == BuildTimeType.BuildTime_CarSoldier or param.buildTimeType == BuildTimeType.BuildTime_BowSoldier then
      tempModel = UIAssets.BuildTimeTipTrainField
    end
    local request = ResourceManager:InstantiateAsync(tempModel)
    request:completed("+", function()
      if self.loadingBuildTimes[bUuid] == nil then
        request:Destroy()
      else
        request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
        request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        request.gameObject.name = "BuildTime" .. bUuid
        local buildTimeTip
        if tempModel == UIAssets.BuildTimeTipTrainField then
          buildTimeTip = BuildTimeTipTrainField.New()
        elseif tempModel == UIAssets.SceneBuildTimeTipCircle then
          buildTimeTip = SceneBuildTimeTipCircle.New()
        elseif tempModel == UIAssets.BuildTimeTip4 then
          buildTimeTip = BuildTimeTipFarm.New()
        elseif tempModel == UIAssets.BuildTimeHeroCountdownTip then
          buildTimeTip = BuildTimeHeroCountdownTip.New()
        else
          buildTimeTip = BuildTimeTip.New()
        end
        local buildParamList = self.loadingBuildTimes[bUuid]
        buildTimeTip:OnCreate(request)
        self.allBuildTimes[bUuid] = buildTimeTip
        self.allBuildTimes[bUuid]:ReInit(buildParamList)
        self:UpdateTimer()
        self.loadingBuildTimes[bUuid] = nil
      end
    end)
  else
    self.loadingBuildTimes[bUuid] = param
  end
end

local function UpdateBuildTimePosition(self, data)
  if data:ContainsKey("buuid") then
    local buuid = data:GetLong("buuid")
    if self.allBuildTimes[buuid] ~= nil then
      self.allBuildTimes[buuid]:UpdatePosition(data:GetInt("pos"))
    end
  end
end

local function GetBuildTimeTypeByQueueType(self, queueType)
  if queueType == NewQueueType.Hospital then
    return BuildTimeType.BuildTime_Injuries
  elseif queueType == NewQueueType.FootSoldier then
    return BuildTimeType.BuildTime_FootSoldier
  elseif queueType == NewQueueType.Science then
    return BuildTimeType.BuildTime_Science
  elseif queueType == NewQueueType.CarSoldier then
    return BuildTimeType.BuildTime_CarSoldier
  elseif queueType == NewQueueType.BowSoldier then
    return BuildTimeType.BuildTime_BowSoldier
  elseif queueType == NewQueueType.Field then
    return BuildTimeType.BuildTime_Farm
  elseif queueType == NewQueueType.OstrichBarn or queueType == NewQueueType.CattleBarn or queueType == NewQueueType.SandWormBarn then
    return BuildTimeType.BuildTime_pasture
  end
end

local function CompareBuildType(buildTimeType1, buildTimeType2)
  return buildTimeType1 < buildTimeType2
end

local function OnBuildPlaceSignal(data)
  local bUuid = 0
  if data:ContainsKey("bUuid") then
    bUuid = data:GetLong("bUuid")
  end
  DataCenter.BuildTimeManager:CheckShowTimeWhenBuildPlace(bUuid)
end

local function OnBuildUpgradeStartSignal(bUuid)
  DataCenter.BuildTimeManager:CheckShowTime(bUuid)
end

local function OnBuildUpgradeFinishSignal(data)
  local bUuid = data
  DataCenter.BuildTimeManager:CheckShowTime(bUuid)
end

local function OnBuildFixUpgradeStartSignal(bUuid)
  DataCenter.BuildTimeManager:CheckShowTime(bUuid)
end

local function OnBuildFixUpgradeFinishSignal(data)
  local bUuid = data
  DataCenter.BuildTimeManager:CheckShowTime(bUuid)
end

local function OnBuildTrainingStartSignal(data)
  local bUuid = 0
  if data:ContainsKey("bUuid") then
    bUuid = data:GetLong("bUuid")
  end
  DataCenter.BuildTimeManager:CheckShowTime(bUuid)
end

local function OnScienceQueueResearchSignal(data)
  local bUuid = 0
  if data:ContainsKey("bUuid") then
    bUuid = data:GetLong("bUuid")
  end
  DataCenter.BuildTimeManager:CheckShowTime(bUuid)
end

local function HospitaiStartSignal(data)
  if data:ContainsKey("aboutBuilds") then
    local builds = data:GetSFSArray("aboutBuilds")
    if builds ~= nil then
      for i = 1, builds:Size() do
        local v = builds:GetSFSObject(i)
        if v ~= nil and v:ContainsKey("bUuid") then
          local bUuid = v:GetLong("bUuid")
          DataCenter.BuildTimeManager:CheckShowTime(bUuid)
        end
      end
    end
  end
end

local function AddSpeedSuccessSignal(data)
  local queueType = data
  local buildTimeType = DataCenter.BuildTimeManager:GetBuildTimeTypeByQueueType(queueType)
  if buildTimeType == BuildTimeType.BuildTime_Farm then
    for k, v in pairs(DataCenter.BuildTimeManager.allBuildTimes) do
      if v.param and v.param.buildTimeType == buildTimeType then
        local queue = DataCenter.QueueDataManager:GetQueueByUuid(v.param.queueUuid)
        if queue then
          v.param.endTime = queue.endTime
          v.param.startTime = queue.startTime
        end
        v:RefreshSliderInterVal()
      end
    end
    DataCenter.BuildTimeManager:UpdateTimer()
  elseif queueType == NewQueueType.Science then
    for k, v in pairs(DataCenter.BuildTimeManager.allBuildTimes) do
      if v.param then
        local queue = DataCenter.QueueDataManager:GetQueueByBuildUuidForScience(v.param.bUuid)
        if queue ~= nil and v.param.buildTimeType == buildTimeType then
          v.param.endTime = queue.endTime
          v.param.startTime = queue.startTime
          v:RefreshSliderInterVal()
        end
      end
    end
    DataCenter.BuildTimeManager:UpdateTimer()
  else
    local queue = DataCenter.QueueDataManager:GetQueueByType(queueType)
    for k, v in pairs(DataCenter.BuildTimeManager.allBuildTimes) do
      if not v.param then
        if queue and v.UpdateTime then
          v:UpdateTime(buildTimeType, queue.startTime, queue.endTime)
        end
      elseif v.param.buildTimeType == buildTimeType and queue ~= nil then
        v.param.endTime = queue.endTime
        v.param.startTime = queue.startTime
        v:RefreshSliderInterVal()
      end
    end
  end
end

local function AddBuildSpeedSuccessSignal(data)
  if data:ContainsKey("bUuid") and data:ContainsKey("endTime") and data:ContainsKey("startTime") then
    local bUuid = data:GetLong("bUuid")
    local startTime = data:GetLong("startTime")
    local endTime = data:GetLong("endTime")
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local self = DataCenter.BuildTimeManager
    local allBuildTimes = self.allBuildTimes
    if endTime <= curTime then
      self:DeleteOneBuildTime(bUuid)
    elseif allBuildTimes[bUuid] then
      if allBuildTimes[bUuid].param then
        if allBuildTimes[bUuid].param.buildTimeType == BuildTimeType.BuildTime_Upgrading then
          allBuildTimes[bUuid].param.startTime = startTime
          allBuildTimes[bUuid].param.endTime = endTime
          allBuildTimes[bUuid]:RefreshSliderInterVal()
          self:UpdateTimer()
        end
      elseif allBuildTimes[bUuid].UpdateTime then
        allBuildTimes[bUuid]:UpdateTime(BuildTimeType.BuildTime_Upgrading, startTime, endTime)
      end
    end
  end
end

local function AddBuildFixSpeedSuccessSignal(data)
  if data:ContainsKey("bUuid") and data:ContainsKey("endTime") and data:ContainsKey("startTime") then
    local bUuid = data:GetLong("bUuid")
    if DataCenter.BuildTimeManager.allBuildTimes[bUuid] ~= nil and DataCenter.BuildTimeManager.allBuildTimes[bUuid].param and DataCenter.BuildTimeManager.allBuildTimes[bUuid].param.buildTimeType == BuildTimeType.BuildTime_Fixing then
      DataCenter.BuildTimeManager.allBuildTimes[bUuid].param.startTime = data:GetLong("startTime")
      DataCenter.BuildTimeManager.allBuildTimes[bUuid].param.endTime = data:GetLong("endTime")
      DataCenter.BuildTimeManager.allBuildTimes[bUuid]:RefreshSliderInterVal()
      DataCenter.BuildTimeManager:UpdateTimer()
    end
  end
end

local function BuildInViewSignal(self, data)
  local bUuid = data
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildData == nil or (buildData.itemId == BuildingTypes.APS_BUILD_FARM_FIELD or buildData.itemId == BuildingTypes.APS_BUILD_PASTURE_SANDWORM or buildData.itemId == BuildingTypes.APS_BUILD_PASTURE_CATTLE or buildData.itemId == BuildingTypes.APS_BUILD_PASTURE_OSTRICH) and buildData.destroyStartTime <= 0 then
    return
  end
  local paramList = DataCenter.BuildTimeManager:GetBuildNeedShowBuildTimeList(bUuid)
  if not paramList or #paramList == 0 then
    DataCenter.BuildTimeManager:DeleteOneBuildTime(bUuid)
    if buildData.itemId == BuildingTypes.FUN_BUILD_TRADING_CENTER then
      DataCenter.BuildTimeManager:RefreshEarthOrderSignal()
    end
  else
    local tempTip = DataCenter.BuildTimeManager.allBuildTimes[bUuid]
    if tempTip then
      if tempTip.CheckIfTimeTipExist and tempTip:CheckIfTimeTipExist(paramList) then
        tempTip:ReInit(paramList)
        DataCenter.BuildTimeManager:UpdateTimer()
      end
    else
      DataCenter.BuildTimeManager:DeleteOneBuildTime(bUuid)
      DataCenter.BuildTimeManager:ShowOneBuildTime(bUuid, paramList)
    end
  end
end

local function BuildOutViewSignal(self, data)
  local bUuid = tonumber(data)
  if bUuid == DataCenter.BuildTimeManager.showFarmTimeUuid then
    DataCenter.BuildTimeManager.showFarmTimeUuid = 0
    DataCenter.BuildTimeManager.showFarmQueueUuid = 0
  end
  DataCenter.BuildTimeManager:DeleteOneBuildTime(bUuid)
end

local function QueueTimeEndSignal(data)
  if data == NewQueueType.OstrichBarn or data == NewQueueType.CattleBarn or data == NewQueueType.SandWormBarn then
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIPasture)
    local buildId = DataCenter.BuildManager:GetBuildIdByNewQueue(tonumber(data))
    local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
    local uuid = 0
    if list ~= nil then
      for k, v in pairs(list) do
        uuid = v.uuid
      end
    end
    if window ~= nil and window.View ~= nil and window.View.activeSelf == true and uuid == window.View.buildUuid then
    else
      return
    end
  end
  DataCenter.BuildTimeManager:RefreshTimeByQueueType(data)
end

local function ShowFarmTimeSignal(data)
  local bUuid = 0
  if data:ContainsKey("bUuid") then
    bUuid = data:GetLong("bUuid")
  end
  DataCenter.BuildTimeManager.showFarmQueueUuid = 0
  if data:ContainsKey("queueUuid") then
    DataCenter.BuildTimeManager.showFarmQueueUuid = data:GetLong("queueUuid")
  end
  local paramList = DataCenter.BuildTimeManager:GetBuildNeedShowBuildTimeList(bUuid)
  if not paramList or #paramList == 0 then
    DataCenter.BuildTimeManager:DeleteOneBuildTime(bUuid)
  else
    local tempTip = DataCenter.BuildTimeManager.allBuildTimes[bUuid]
    if tempTip then
      if tempTip.CheckIfTimeTipExist and tempTip:CheckIfTimeTipExist(paramList) then
        tempTip:ReInit(paramList)
        DataCenter.BuildTimeManager:UpdateTimer()
      end
    else
      DataCenter.BuildTimeManager:DeleteOneBuildTime(bUuid)
      DataCenter.BuildTimeManager:ShowOneBuildTime(bUuid, paramList)
    end
    DataCenter.BuildTimeManager.showFarmTimeUuid = bUuid
  end
end

local function HideFarmTimeSignal(data)
  local bUuid = DataCenter.BuildTimeManager.showFarmTimeUuid
  if bUuid ~= 0 then
    DataCenter.BuildTimeManager:DeleteOneBuildTime(bUuid)
    if DataCenter.BuildTimeManager.showFarmTimeUuid ~= 0 then
      CS.SceneManager.World:QuitFocus(LookAtFocusTime)
    end
    DataCenter.BuildTimeManager.showFarmTimeUuid = 0
    DataCenter.BuildTimeManager.showFarmQueueUuid = 0
  end
  DataCenter.RecommendShowManager:ResetState()
end

local function HideFarmTimeSignalOnly(data)
  local bUuid = DataCenter.BuildTimeManager.showFarmTimeUuid
  if bUuid ~= 0 then
    DataCenter.BuildTimeManager:DeleteOneBuildTime(bUuid)
    DataCenter.BuildTimeManager.showFarmTimeUuid = 0
    DataCenter.BuildTimeManager.showFarmQueueUuid = 0
  end
  DataCenter.RecommendShowManager:ResetState()
end

local function RefreshResidentOrderSignal()
  if DataCenter.ResidentOrderDataManager:IsGuideSpecialBubbleShow() == false then
    return
  end
  local bUuid = 0
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_BUSINESS_CENTER)
  if buildData ~= nil and buildData.state == BuildingStateType.Normal and DataCenter.BuildTimeManager.allBuildTimes[buildData.uuid] == nil then
    bUuid = buildData.uuid
    DataCenter.BuildTimeManager:DeleteOneBuildTime(bUuid)
    DataCenter.BuildTimeManager:AddResidentOrder(bUuid, buildData)
  end
end

local function AddResidentOrder(self, bUuid, buildData)
  if buildData ~= nil or buildData.destroyStartTime > 0 then
    return
  end
  local leftTime = DataCenter.ResidentOrderDataManager:GetOrderSendLeftTime()
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(BuildingTypes.FUN_BUILD_BUSINESS_CENTER)
  if 0 < leftTime then
    local param = {}
    local now = UITimeManager:GetInstance():GetServerTime()
    local endTime = math.ceil(leftTime + now)
    local buildId = BuildingTypes.FUN_BUILD_BUSINESS_CENTER
    param.buildTimeType = BuildTimeType.BuildTime_tradingCenter
    param.endTime = endTime
    param.startTime = DataCenter.ResidentOrderDataManager.lastGetOrderRewardTime
    param.pos = buildData.pointId
    param.iconName = string.format(LoadPath.UIBuildBubble, "uibuild_time_icon_time")
    param.iconBg = string.format(LoadPath.UIBuildBubble, "uibuild_time_bg_upgrade")
    param.iconBgScale = IconBgResetScale
    param.iconScale = ResetScale
    param.model = UIAssets.SceneBuildTimeTipCircle
    param.extraHeight = DataCenter.BuildTimeManager:GetExtraPos(buildId)
    param.buildId = buildId
    param.tileX = buildTemplate.tileX
    param.tileY = buildTemplate.tileY
    DataCenter.BuildTimeManager:ShowOneBuildTime(bUuid, param)
  end
end

local function RefreshEarthOrderSignal()
  local bUuid = 0
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_TRADING_CENTER)
  if buildData ~= nil and buildData.state == BuildingStateType.Normal then
    bUuid = buildData.uuid
    DataCenter.BuildTimeManager:DeleteOneBuildTime(bUuid)
    DataCenter.BuildTimeManager:AddEarthOrderSignal(bUuid, buildData)
  end
end

local function AddEarthOrderSignal(self, bUuid, buildData)
  if buildData ~= nil or buildData.destroyStartTime > 0 or buildData.level == 0 then
    return
  end
  local info = DataCenter.EarthOrderDataManager:GetOneEarthOrder()
  if info ~= nil then
    local param = {}
    local endTime = info.expTime
    if endTime ~= nil and BuildingUtils.IsRocketPlayingArrive(buildData.pointId) == false and LuaEntry.Effect:GetGameEffect(EffectDefine.EARTH_ORDER_UNLOCK) == 1 then
      local buildId = BuildingTypes.FUN_BUILD_TRADING_CENTER
      param.buildTimeType = BuildTimeType.BuildTime_tradingCenter
      param.endTime = endTime
      param.startTime = 0
      param.pos = buildData.pointId
      param.iconName = string.format(LoadPath.CommonNewPath, "Common_icon_time")
      param.iconBg = string.format(LoadPath.UIBuildBubble, "uibuild_time_bg_upgrade")
      param.iconBgScale = IconBgResetScale
      param.iconScale = ResetScale
      param.model = UIAssets.BuildTimeTip2
      param.extraHeight = DataCenter.BuildTimeManager:GetExtraPos(buildId)
      param.buildId = buildId
      DataCenter.BuildTimeManager:ShowOneBuildTime(bUuid, param)
    end
  else
  end
end

local function OnBuildPushInfoSignal(data)
  local bUuid = 0
  if data:ContainsKey("bUuid") then
    bUuid = data:GetLong("bUuid")
  end
  DataCenter.BuildTimeManager:CheckShowTime(bUuid)
end

local function CheckShowTime(self, bUuid)
  if DataCenter.BuildManager:IsBuildInView(bUuid) then
    local paramList = DataCenter.BuildTimeManager:GetBuildNeedShowBuildTimeList(bUuid)
    if not paramList or #paramList == 0 then
      self:DeleteOneBuildTime(bUuid)
      local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
      if buildData ~= nil and buildData.itemId == BuildingTypes.FUN_BUILD_TRADING_CENTER then
        DataCenter.BuildTimeManager:RefreshEarthOrderSignal()
      end
    else
      local tempTip = DataCenter.BuildTimeManager.allBuildTimes[bUuid]
      if tempTip then
        if tempTip.CheckIfTimeTipExist and tempTip:CheckIfTimeTipExist(paramList) then
          tempTip:ReInit(paramList)
          DataCenter.BuildTimeManager:UpdateTimer()
        end
      else
        DataCenter.BuildTimeManager:DeleteOneBuildTime(bUuid)
        DataCenter.BuildTimeManager:ShowOneBuildTime(bUuid, paramList)
      end
    end
  else
    self:DeleteOneBuildTime(bUuid)
  end
end

local function CheckShowTimeWhenBuildPlace(self, bUuid)
  local paramList = DataCenter.BuildTimeManager:GetBuildNeedShowBuildTimeList(bUuid)
  if not paramList or #paramList == 0 then
    DataCenter.BuildTimeManager:DeleteOneBuildTime(bUuid)
  else
    local tempTip = DataCenter.BuildTimeManager.allBuildTimes[bUuid]
    if tempTip then
      if tempTip.CheckIfTimeTipExist and tempTip:CheckIfTimeTipExist(paramList) then
        tempTip:ReInit(paramList)
        DataCenter.BuildTimeManager:UpdateTimer()
      end
    else
      DataCenter.BuildTimeManager:DeleteOneBuildTime(bUuid)
      DataCenter.BuildTimeManager:ShowOneBuildTime(bUuid, paramList)
    end
  end
end

local function RefreshTimeByQueueType(self, queueType)
  if queueType == NewQueueType.Science then
    local listA = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_SCIENCE_PART)
    if listA ~= nil then
      for a, b in pairs(listA) do
        DataCenter.BuildTimeManager:CheckShowTime(b.uuid)
      end
    end
  end
  local buildId = DataCenter.BuildManager:GetBuildIdByNewQueue(tonumber(queueType))
  local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
  if list ~= nil then
    for k, v in pairs(list) do
      DataCenter.BuildTimeManager:CheckShowTime(v.uuid)
    end
  end
end

local function GetExtraPos(self, buildId)
  if buildId == BuildingTypes.FUN_BUILD_MAIN then
    return Vector3.New(0, 1.5, 0)
  end
  return Vector3.New(0, 0, 0)
end

local function GetTimeBubbleByBuildId(self, buildId)
  for k, v in pairs(self.allBuildTimes) do
    if v.paramData and v.paramData.buildId == buildId then
      return v
    end
  end
end

local function GetTimeObjByTimeTypeAndBuildId(self, timeType, buildId)
  for k, v in pairs(self.allBuildTimes) do
    if v.GetGuideObj and v.param.buildTimeType == timeType and v.param.buildId == buildId then
      return v:GetGuideObj()
    end
  end
end

local function CheckGuideClickTime(self)
  if DataCenter.GuideManager:InGuide() then
    local template = DataCenter.GuideManager:GetCurTemplate()
    if template ~= nil then
      for k, v in ipairs(template.jumptype) do
        if v == GuideJumpType.ClickTime then
          local state = DataCenter.GuideManager:GetCanDoGuideState(template.id)
          if state == GuideCanDoType.No then
            DataCenter.GuideManager:DoJump()
          end
        end
      end
    end
  end
end

local function RefreshActive(self, uuid, isActive)
  if self.allBuildTimes ~= nil and self.allBuildTimes[uuid] ~= nil then
    self.allBuildTimes[uuid]:RefreshActive(isActive)
  end
end

BuildTimeManager.__init = __init
BuildTimeManager.__delete = __delete
BuildTimeManager.Startup = Startup
BuildTimeManager.GetBuildTimeTypeListByBuildType = GetBuildTimeTypeListByBuildType
BuildTimeManager.Update = Update
BuildTimeManager.GetBuildNeedShowBuildTime = GetBuildNeedShowBuildTime
BuildTimeManager.ShowOneBuildTime = ShowOneBuildTime
BuildTimeManager.DeleteOneBuildTime = DeleteOneBuildTime
BuildTimeManager.AddListener = AddListener
BuildTimeManager.RemoveListener = RemoveListener
BuildTimeManager.AddUpdate = AddUpdate
BuildTimeManager.RemoveUpdate = RemoveUpdate
BuildTimeManager.UpdateTimer = UpdateTimer
BuildTimeManager.UpdateBuildTimePosition = UpdateBuildTimePosition
BuildTimeManager.GetBuildTimeTypeByQueueType = GetBuildTimeTypeByQueueType
BuildTimeManager.OnBuildPlaceSignal = OnBuildPlaceSignal
BuildTimeManager.OnBuildUpgradeStartSignal = OnBuildUpgradeStartSignal
BuildTimeManager.CompareBuildType = CompareBuildType
BuildTimeManager.OnBuildUpgradeFinishSignal = OnBuildUpgradeFinishSignal
BuildTimeManager.OnBuildTrainingStartSignal = OnBuildTrainingStartSignal
BuildTimeManager.OnScienceQueueResearchSignal = OnScienceQueueResearchSignal
BuildTimeManager.HospitaiStartSignal = HospitaiStartSignal
BuildTimeManager.AddSpeedSuccessSignal = AddSpeedSuccessSignal
BuildTimeManager.AddBuildSpeedSuccessSignal = AddBuildSpeedSuccessSignal
BuildTimeManager.BuildInViewSignal = BuildInViewSignal
BuildTimeManager.BuildOutViewSignal = BuildOutViewSignal
BuildTimeManager.QueueTimeEndSignal = QueueTimeEndSignal
BuildTimeManager.ShowFarmTimeSignal = ShowFarmTimeSignal
BuildTimeManager.HideFarmTimeSignal = HideFarmTimeSignal
BuildTimeManager.HideFarmTimeSignalOnly = HideFarmTimeSignalOnly
BuildTimeManager.RefreshEarthOrderSignal = RefreshEarthOrderSignal
BuildTimeManager.AddEarthOrderSignal = AddEarthOrderSignal
BuildTimeManager.CheckShowTime = CheckShowTime
BuildTimeManager.CheckShowTimeWhenBuildPlace = CheckShowTimeWhenBuildPlace
BuildTimeManager.RefreshTimeByQueueType = RefreshTimeByQueueType
BuildTimeManager.GetExtraPos = GetExtraPos
BuildTimeManager.GetTimeObjByTimeTypeAndBuildId = GetTimeObjByTimeTypeAndBuildId
BuildTimeManager.RefreshResidentOrderSignal = RefreshResidentOrderSignal
BuildTimeManager.AddResidentOrder = AddResidentOrder
BuildTimeManager.CheckGuideClickTime = CheckGuideClickTime
BuildTimeManager.RefreshActive = RefreshActive
BuildTimeManager.OnBuildFixUpgradeStartSignal = OnBuildFixUpgradeStartSignal
BuildTimeManager.OnBuildFixUpgradeFinishSignal = OnBuildFixUpgradeFinishSignal
BuildTimeManager.AddBuildFixSpeedSuccessSignal = AddBuildFixSpeedSuccessSignal
BuildTimeManager.OnBuildPushInfoSignal = OnBuildPushInfoSignal
BuildTimeManager.GetBuildNeedShowBuildTimeList = GetBuildNeedShowBuildTimeList
BuildTimeManager.GetTimeBubbleByBuildId = GetTimeBubbleByBuildId
return BuildTimeManager
