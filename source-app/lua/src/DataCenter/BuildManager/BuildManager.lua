local BuildManager = BaseClass("BuildManager")
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting
local ResourceManager = CS.GameEntry.Resource
local RewardUtil = require("Util.RewardUtil")
local BuildingDate = require("DataCenter.BuildManager.BuildingDate")
local WaterPickEffect = {
  "Assets/_Art/Effect/prefab/ui/VFX_ziyuanshouqu_water_shao.prefab",
  "Assets/_Art/Effect/prefab/ui/VFX_ziyuanshouqu_water_zhong.prefab",
  "Assets/_Art/Effect/prefab/ui/VFX_ziyuanshouqu_water_duo.prefab"
}
local ElectricityPickEffect = {
  "Assets/_Art/Effect/prefab/ui/VFX_ziyuanshouqu_shandian_shao.prefab",
  "Assets/_Art/Effect/prefab/ui/VFX_ziyuanshouqu_shandian_zhong.prefab",
  "Assets/_Art/Effect/prefab/ui/VFX_ziyuanshouqu_shandian_duo.prefab"
}
local OilPickEffect = {
  "Assets/_Art/Effect/prefab/ui/VFX_ziyuanshouqu_wasi_shao.prefab",
  "Assets/_Art/Effect/prefab/ui/VFX_ziyuanshouqu_wasi_zhong.prefab",
  "Assets/_Art/Effect/prefab/ui/VFX_ziyuanshouqu_wasi_duo.prefab"
}
local MoneyPickEffect = {
  "Assets/_Art/Effect/prefab/ui/VFX_ziyuanshouqu_jinbi_shao.prefab",
  "Assets/_Art/Effect/prefab/ui/VFX_ziyuanshouqu_jinbi_zhong.prefab",
  "Assets/_Art/Effect/prefab/ui/VFX_ziyuanshouqu_jinbi_duo.prefab"
}
local CrystalPickEffect = {
  "Assets/_Art/Effect/prefab/ui/VFX_ziyuanshouqu_shuijing_shao.prefab",
  "Assets/_Art/Effect/prefab/ui/VFX_ziyuanshouqu_shuijing_zhong.prefab",
  "Assets/_Art/Effect/prefab/ui/VFX_ziyuanshouqu_shuijing_duo.prefab"
}
local StaminaPickEffect = {
  "Assets/_Art/Effect/prefab/ui/VFX_ziyuanshouqu_stamina_shao.prefab",
  "Assets/_Art/Effect/prefab/ui/VFX_ziyuanshouqu_stamina_zhong.prefab",
  "Assets/_Art/Effect/prefab/ui/VFX_ziyuanshouqu_stamina_duo.prefab"
}

local function __init(self)
  self.inViewBuild = {}
  self.noShowRedDot = {}
  self.noShowUnlock = nil
  self.buildListTab = UIBuildListTabType.Economy
  self.changeMovePos = {}
  self.currentBuildMoveState = BuildMoveState.None
  self.allBuilding = {}
  self.buildIdBuilding = {}
  self.allDecorate = {}
  self.MainLv = 0
  self.main_city_pos = Vector2.New(49, 49)
  self.showPoint = 0
  self.newUserWorld = 0
  self.pickEffect = {}
  self.sendList = {}
  self.sendFixList = {}
  self.country = nil
  self.showCityLabel = true
  self:AddListener()
  self.showPutBuildFromPanel = nil
  self.upgradeReward = {}
  self.curMainBuildStamina = 0
  self.onMovingStateBuildUuid = 0
  self.isCheck = false
  self.inViewWorldBuild = {}
  self.delayDic = {}
  self.delayIndex = 0
  self.flameDic = {}
  self.expireBuildingDic = {}
  self.useNewDecorationCountLogicValue = -1
  self.buildingExtData = {}
  self.csBuilding = CS.GameEntry.Data.Building
  self.delayPyramidList = {}
  self.pyramidUpEffectReqList = {}
  self.pyramidDownEffectReqList = {}
  self.pyramidUpEffecIsUsingList = {}
  self.pyramidDownEffecIsUsingList = {}
  self.pyramidUpEffectInternal = 1
  self.pyramidDownEffectInternal = 1
  self.pyramidSpeedUpTipsShowDelay = 1
  self.normalSpeedUpTipsShowDelay = 2.5
  self.pyramidSpeedUpTipsDuringTime = 1
  self.normalSpeedUpTipsDuringTime = 1
end

local function __delete(self)
  if self.delayMoveTimer then
    self.delayMoveTimer:Stop()
    self.delayMoveTimer = nil
  end
  self.sendList = nil
  self.sendFixList = nil
  self.inViewBuild = nil
  self.noShowRedDot = nil
  self.noShowUnlock = nil
  self.buildListTab = nil
  self.changeMovePos = nil
  self.currentBuildMoveState = BuildMoveState.None
  self.allDecorate = nil
  self.flameDic = nil
  self.allBuilding = {}
  self.buildIdBuilding = {}
  self.MainLv = nil
  self.main_city_pos = Vector2.New(49, 49)
  self.newUserWorld = nil
  self.showPoint = nil
  self.showPutBuildFromPanel = nil
  self.country = nil
  for i, v in pairs(self.pickEffect) do
    v:Destroy()
    self.pickEffect[i] = nil
  end
  self.pickEffect = nil
  self.showCityLabel = nil
  self.upgradeReward = nil
  self.curMainBuildStamina = nil
  self:RemoveListener()
  self.inViewWorldBuild = {}
  if self.delayDic then
    for i, delay in pairs(self.delayDic) do
      if self.delayDic[i] then
        self.delayDic[i]:Stop()
        self.delayDic[i] = nil
      end
    end
  end
  self.delayDic = nil
  self.delayIndex = nil
  if self.expireBuildingDic then
    for i, v in pairs(self.expireBuildingDic) do
      if v then
        v:Stop()
      end
    end
  end
  self.expireBuildingDic = nil
  self.useNewDecorationCountLogicValue = nil
  self.buildingExtData = {}
  self.csBuilding = nil
  self:ClearPyramidData()
end

local function Startup()
end

local function InitData(self, message)
  if message.user ~= nil then
    local u = message.user
    if u.newUserWorld ~= nil then
      self.newUserWorld = u.newUserWorld
    else
      self.newUserWorld = NewUserWorld.Pass
    end
    self.country = u.country
    if u.level ~= nil then
      self.MainLv = u.level
    end
  else
    self.newUserWorld = NewUserWorld.Pass
  end
  if message.building_new ~= nil then
    self:UpdateBuildings(message.building_new, nil, true)
  end
  if message.world_building ~= nil then
    local dic = message.world_building
    for k, v in pairs(dic) do
      local buildId = v.bId
      if buildId ~= BuildingTypes.FUN_BUILD_MAIN then
        self:AddBuilding(v, forceCheckAnimal)
      end
    end
  end
  if message.worldMainPoint ~= nil then
    LuaEntry.Player:SetMainWorldPointId(message.worldMainPoint)
  end
  local effectTime = LuaEntry.Effect:GetGameEffect(EffectDefine.BUILD_TIME_REDUCE)
  if 0 < effectTime then
    self.isCheck = true
  end
  if message.decoration_logic_new ~= nil then
    self.useNewDecorationCountLogicValue = checknumber(message.decoration_logic_new)
  end
  if Setting:CheckFirstLaunchSkipUpdate() and not CS.ApplicationLaunch.Instance.Loading.IsLoading then
    local ignoreMainLv = LuaEntry.DataConfig:TryGetNum("first_launch_skip_update", "k2")
    local mainLv = self.MainLv or 0
    if ignoreMainLv <= mainLv and not Setting.FirstLaunchSkipUpdateNewestVersion then
      Setting:DisableFirstLaunchSkipUpdate()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIForceUpdateTip, {anim = true})
    end
  end
end

local function SetOnMovingBuildUuid(self, uuid)
  self.onMovingStateBuildUuid = uuid
end

local function GetOnMovingBuildUuid(self)
  return self.onMovingStateBuildUuid
end

local function UpdateBuildings(self, message, forceCheckAnimal, fromReload)
  self.allBuilding = {}
  self.buildIdBuilding = {}
  self.allDecorate = {}
  if DataCenter.BuildTemplateManager.isAllTrans ~= true then
    local buildingIds = {}
    for k1, v1 in pairs(message) do
      if v1.bId ~= nil then
        buildingIds[v1.bId] = v1.lv
      end
    end
    DataCenter.BuildTemplateManager:TransAllBuildingTemplate(buildingIds)
  end
  for k, v in pairs(message) do
    v.fromReload = fromReload
    self:AddBuilding(v, forceCheckAnimal)
  end
  if fromReload then
    EventManager:GetInstance():Broadcast(EventId.RefreshLandlockDataAndReward)
  end
end

local function SyncBuildingDataToCSharp(self, uuid, remove)
  if not self.csBuilding then
    return
  end
  self.csBuilding:UpdateMyBuilding(uuid, remove)
end

local function AddBuilding(self, message, forceCheckAnimal, isWorldBuild)
  local id = message.uuid
  local one = self.allBuilding[id]
  local refreshBuild = false
  local oldLevel, newLevel, oldPointId, newPointId = -1, -1, 0, 0
  local oldProdStatus, newProdStatus, oldDecorNum, newDecorNum = 0, 0, 0, 0
  local oldDisPatchWorkerList = {}
  local oldBuildingState, newBuildingState = BuildingStateType.Normal, BuildingStateType.Normal
  if one == nil then
    one = BuildingDate.New()
    refreshBuild = one:UpdateInfo(message, forceCheckAnimal, isWorldBuild)
    self.allBuilding[id] = one
    if one:IsMainBuilding() then
      self:SyncBuildingDataToCSharp(id, false)
    end
    local buildId = one.itemId
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
    if buildTemplate ~= nil then
      if buildTemplate.tab_type == UIBuildListTabType.Decorate then
        if self.allDecorate[buildId] == nil then
          self.allDecorate[buildId] = {}
        end
        table.insert(self.allDecorate[buildId], one)
      end
    else
      Logger.Log("GetBuildingDesTemplate fail -> " .. buildId)
    end
    if self.buildIdBuilding[buildId] == nil then
      self.buildIdBuilding[buildId] = {}
    end
    table.insert(self.buildIdBuilding[buildId], one)
    if buildId == BuildingTypes.LW_BUILD_HERO_COUNTDOWN then
      DataCenter.BuildHeroCountdownManager:AddBuild(id)
    end
  else
    oldLevel = one.level
    oldPointId = one.pointId
    oldDisPatchWorkerList = one.assignedHeroList
    oldBuildingState = one.state
    oldProdStatus = one.prodStatus
    oldDecorNum = one.decorNum or 0
    refreshBuild = one:UpdateInfo(message, forceCheckAnimal, isWorldBuild)
  end
  newLevel = one.level
  newPointId = one.pointId
  newBuildingState = one.state
  newProdStatus = one.prodStatus
  newDecorNum = one.decorNum
  if refreshBuild == true then
    EventManager:GetInstance():Broadcast(EventId.BUILD_IN_VIEW, id)
  end
  if oldLevel < newLevel and oldLevel ~= -1 then
    local info = {}
    info.uuid = message.uuid
    info.oldLevel = oldLevel
    info.newLevel = newLevel
    info.fromReload = message.fromReload
    EventManager:GetInstance():Broadcast(EventId.BuildLevelUp, info)
  end
  if newPointId ~= oldPointId then
    local info = {}
    info.uuid = message.uuid
    info.oldPointId = oldPointId
    info.newPointId = newPointId
    info.fromReload = message.fromReload
    EventManager:GetInstance():Broadcast(EventId.BuildMove, info)
  end
  if one:GetIsDecorate() and not message.fromReload then
    local curDecoProgress = newProdStatus or 0
    local prevDecoProgress = oldProdStatus or 0
    if curDecoProgress > prevDecoProgress then
      local info = {}
      info.uuid = message.uuid
      info.oldProdStatus = prevDecoProgress
      info.newProdStatus = curDecoProgress
      EventManager:GetInstance():Broadcast(EventId.BuildDecoProgressLevelUp, info)
    end
    if oldDecorNum ~= newDecorNum then
      local info = {}
      info.uuid = message.uuid
      EventManager:GetInstance():Broadcast(EventId.BuildDecoNumChange, info)
    end
  end
  if oldBuildingState ~= newBuildingState then
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(one.itemId)
    if buildTemplate and buildTemplate.tab_type == UIBuildListTabType.Decorate then
      EventManager:GetInstance():BroadcastDeferred(EventId.BuildStateChange)
    end
  end
  DataCenter.DesertDataManager:UpdateSeasonBuildList(one)
  if one.itemId == BuildingTypes.LW_GIFT_PACKAGE then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local expireTime = one.expireTimeStampMS
    if 0 < expireTime then
      local remain = expireTime - curTime + 10000
      if remain <= 0 then
        SFSNetwork.SendMessage(MsgDefines.ExpireBuildingRemove, tostring(id))
      else
        if self.expireBuildingDic[id] then
          self.expireBuildingDic[id]:Stop()
        end
        local delay = TimerManager:GetInstance():DelayInvoke(function()
          if self.expireBuildingDic and self.expireBuildingDic[id] then
            self.expireBuildingDic[id]:Stop()
            self.expireBuildingDic[id] = nil
          end
          local data = DataCenter.BuildManager:GetBuildingDataByUuid(id)
          if data and data.itemId == BuildingTypes.LW_GIFT_PACKAGE then
            SFSNetwork.SendMessage(MsgDefines.ExpireBuildingRemove, tostring(id))
          end
        end, math.ceil(remain / 1000))
        self.expireBuildingDic[id] = delay
      end
    end
  end
  if one.itemId == BuildingTypes.LW_BUILDING_SEASON2_PERSONAL_FURNACE and self.buildingExtData[id] == nil then
    SFSNetwork.SendMessage(MsgDefines.UserBuildingFurnaceInfo)
  end
end

local function RemoveDecorateBuilding(self, uuid, buildId)
  local decoratelist = self.allDecorate[buildId]
  if decoratelist then
    local removeid = 0
    for i, v in pairs(decoratelist) do
      if v.uuid == uuid then
        removeid = i
      end
    end
    table.remove(decoratelist, removeid)
    if table.count(self.allDecorate[buildId]) == 0 then
      self.allDecorate[buildId] = nil
    end
  end
end

local function RemoveBuilding(self, uuid)
  local building = self.allBuilding[uuid]
  if building ~= nil then
    local buildId = building.itemId
    RemoveDecorateBuilding(self, uuid, buildId)
    local list = self.buildIdBuilding[buildId]
    if list ~= nil then
      local removeId = 0
      for k, v in ipairs(list) do
        if v.uuid == uuid then
          removeId = k
        end
      end
      table.remove(self.buildIdBuilding[buildId], removeId)
      if table.count(self.buildIdBuilding[buildId]) == 0 then
        self.buildIdBuilding[buildId] = nil
      end
    end
    self.allBuilding[uuid] = nil
    if building:IsMainBuilding() then
      self:SyncBuildingDataToCSharp(uuid, true)
    end
    if buildId == BuildingTypes.LW_BUILD_HERO_COUNTDOWN then
      DataCenter.BuildHeroCountdownManager:RemoveBuild(uuid)
    end
  end
  DataCenter.DesertDataManager:RemoveSeasonBuild(uuid)
end

local function CheckIsSendMessage(self, uuid)
  return self.sendList[uuid] ~= nil
end

local function CheckIsSendFixMessage(self, uuid)
  return self.sendFixList[uuid] ~= nil
end

local function DelayClearSendList(self, uuid)
  self.sendList[uuid] = true
  TimerManager:GetInstance():DelayInvoke(function()
    if self.sendList ~= nil then
      self.sendList[uuid] = nil
    end
  end, 1)
end

local function DelayClearSendFixList(self, uuid)
  self.sendFixList[uuid] = true
  TimerManager:GetInstance():DelayInvoke(function()
    if self.sendFixList ~= nil then
      self.sendFixList[uuid] = nil
    end
  end, 1)
end

local function BuildCcdMNewHandle(self, message)
  if message.errorCode == nil then
    if message.remainGold ~= nil then
      LuaEntry.Player.gold = message.remainGold
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
    local arrays = message.itemCostArr
    if arrays ~= nil then
      for k, v in pairs(arrays) do
        DataCenter.ItemData:UpdateOneItem(v)
      end
    end
    local bUuid = 0
    local endTime = 0
    local startTime = 0
    local buildId = 0
    local buildLevel = 0
    local isFixRuin = false
    if message.isFixRuins ~= nil then
      isFixRuin = message.isFixRuins
    end
    if message.buildInfo ~= nil then
      local dic = message.buildInfo
      bUuid = dic.uuid
      if dic ~= nil then
        self:AddBuilding(dic)
        local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
        if buildData ~= nil then
          bUuid = buildData.uuid
          if isFixRuin == true then
            startTime = buildData.destroyStartTime
            endTime = buildData.destroyEndTime
            buildId = buildData.itemId
            buildLevel = buildData.level
            if buildData:IsFixFinish() then
              DataCenter.BuildQueueManager:SetFixFinishFlag(bUuid)
            end
          else
            startTime = buildData.startTime
            endTime = buildData.updateTime
            buildId = buildData.itemId
            buildLevel = buildData.level
            if buildData:IsUpgradeFinish() then
              DataCenter.BuildQueueManager:SetTimeFinishFlag(bUuid)
            end
          end
        end
        EventManager:GetInstance():Broadcast(EventId.UPDATE_BUILD_DATA, bUuid)
      end
    end
    if message.finished ~= nil then
      local isFinish = message.finished
      if isFinish then
        if self:CheckShowUnlock(buildId, buildLevel) == false then
          EventManager:GetInstance():Broadcast(EventId.ShowPower, RewardType.POWER)
        end
        self:FlyExp(bUuid, buildId)
        EventManager:GetInstance():Broadcast(EventId.BuildUpgradeFinish, bUuid)
        EventManager:GetInstance():Broadcast(EventId.ShowMainUIPart)
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Finish, false)
      end
    end
    local signal = SFSObject.New()
    signal:PutLong("bUuid", bUuid)
    signal:PutLong("endTime", endTime)
    signal:PutLong("startTime", startTime)
    if isFixRuin == true then
      EventManager:GetInstance():Broadcast(EventId.AddBuildFixSpeedSuccess, signal)
    else
      EventManager:GetInstance():Broadcast(EventId.AddBuildSpeedSuccess, signal)
    end
  else
    local temp = message.errorCode
    if temp == "E100173" then
      UIUtil.ShowTipsId(170008)
    else
      UIUtil.ShowTips(Localization:GetString(message.errorCode))
    end
  end
end

local function GetBuildIdByNewQueue(self, queueType)
  if queueType == NewQueueType.Science then
    return BuildingTypes.FUN_BUILD_SCIENE
  elseif queueType == NewQueueType.FootSoldier then
    return BuildingTypes.FUN_BUILD_INFANTRY_BARRACK
  elseif queueType == NewQueueType.CarSoldier then
    return BuildingTypes.FUN_BUILD_CAR_BARRACK
  elseif queueType == NewQueueType.BowSoldier then
    return BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK
  elseif queueType == NewQueueType.Hospital then
    return BuildingTypes.LW_BUILD_HOSPITL
  elseif queueType == NewQueueType.OstrichBarn then
    return BuildingTypes.APS_BUILD_PASTURE_OSTRICH
  elseif queueType == NewQueueType.CattleBarn then
    return BuildingTypes.APS_BUILD_PASTURE_CATTLE
  elseif queueType == NewQueueType.SandWormBarn then
    return BuildingTypes.APS_BUILD_PASTURE_SANDWORM
  elseif queueType == NewQueueType.RebirthHospital then
    return BuildingTypes.LW_BUILDING_REBIRTH_HOSPITAL
  end
end

local function GetNewQueueTypeByBuildId(self, buildId)
  if buildId == BuildingTypes.FUN_BUILD_SCIENE or buildId == BuildingTypes.FUN_BUILD_SCIENCE_PART or buildId == BuildingTypes.LW_BUILE_SCIENCE_TWO or buildId == BuildingTypes.LW_BUILE_SCIENCE_THREE then
    return NewQueueType.Science
  elseif buildId == BuildingTypes.FUN_BUILD_INFANTRY_BARRACK then
    return NewQueueType.FootSoldier
  elseif buildId == BuildingTypes.FUN_BUILD_CAR_BARRACK then
    return NewQueueType.CarSoldier
  elseif buildId == BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK then
    return NewQueueType.BowSoldier
  elseif buildId == BuildingTypes.LW_BUILD_HOSPITL then
    return NewQueueType.Hospital
  elseif buildId == BuildingTypes.APS_BUILD_PASTURE_OSTRICH then
    return NewQueueType.OstrichBarn
  elseif buildId == BuildingTypes.APS_BUILD_PASTURE_CATTLE then
    return NewQueueType.CattleBarn
  elseif buildId == BuildingTypes.APS_BUILD_PASTURE_SANDWORM then
    return NewQueueType.SandWormBarn
  elseif buildId == BuildingTypes.LW_BUILDING_REBIRTH_HOSPITAL then
    return NewQueueType.RebirthHospital
  end
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.BUILD_IN_VIEW, self.BuildInViewSignal)
  EventManager:GetInstance():AddListener(EventId.BUILD_OUT_VIEW, self.BuildOutViewSignal)
  EventManager:GetInstance():AddListener(EventId.Guide_video_Play, self.UILoadingExitSignal)
  EventManager:GetInstance():AddListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildDataSignal)
  EventManager:GetInstance():AddListener(EventId.LuaEntryEffectRefreshStatus, self.RefreshCityState)
  EventManager:GetInstance():AddListener(EventId.OnScienceQueueFinish, self.OnScienceQueueFinish)
  EventManager:GetInstance():AddListener(EventId.OnScienceQueueResearch, self.OnScienceQueueResearch)
  EventManager:GetInstance():AddListener(EventId.WORLD_BUILD_IN_VIEW, self.WorldBuildInViewSignal)
  EventManager:GetInstance():AddListener(EventId.WORLD_BUILD_OUT_VIEW, self.WorldBuildOutViewSignal)
  EventManager:GetInstance():AddListener(EventId.OnBuildHeroCountdownStateChange, self.OnBuildHeroCountdownStateChange)
  EventManager:GetInstance():AddListener(EventId.BeforeReleaseCity, self.BeforeReleaseCity)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.BUILD_IN_VIEW, self.BuildInViewSignal)
  EventManager:GetInstance():RemoveListener(EventId.BUILD_OUT_VIEW, self.BuildOutViewSignal)
  EventManager:GetInstance():RemoveListener(EventId.Guide_video_Play, self.UILoadingExitSignal)
  EventManager:GetInstance():RemoveListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildDataSignal)
  EventManager:GetInstance():RemoveListener(EventId.LuaEntryEffectRefreshStatus, self.RefreshCityState)
  EventManager:GetInstance():RemoveListener(EventId.OnScienceQueueResearch, self.OnScienceQueueResearch)
  EventManager:GetInstance():RemoveListener(EventId.OnScienceQueueFinish, self.OnScienceQueueFinish)
  EventManager:GetInstance():RemoveListener(EventId.WORLD_BUILD_IN_VIEW, self.WorldBuildInViewSignal)
  EventManager:GetInstance():RemoveListener(EventId.WORLD_BUILD_OUT_VIEW, self.WorldBuildOutViewSignal)
  EventManager:GetInstance():RemoveListener(EventId.OnBuildHeroCountdownStateChange, self.OnBuildHeroCountdownStateChange)
  EventManager:GetInstance():RemoveListener(EventId.BeforeReleaseCity, self.BeforeReleaseCity)
end

local function AddOneBuildInView(self, bUuid)
  self.inViewBuild[bUuid] = true
end

local function RemoveOneBuildInView(self, bUuid)
  self.inViewBuild[bUuid] = nil
end

function BuildManager.OnScienceQueueResearch(data)
  local self = DataCenter.BuildManager
  if data:ContainsKey("bUuid") then
    local bUuid = data:GetLong("bUuid")
    if bUuid then
      self:BuildingShowStateModel(bUuid)
    end
  end
end

function BuildManager.OnScienceQueueFinish(uid)
  local queue = DataCenter.QueueDataManager:GetQueueByUuid(uid)
  DataCenter.BuildManager:BuildingShowStateModel(queue.funcUuid)
end

function BuildManager:BuildingShowStateModel(bUuid)
  local self = DataCenter.BuildManager
  local data = self:GetBuildingDataByUuid(bUuid)
  local world = CS.SceneManager.World
  if not data or IsNull(world) then
    return
  end
  if data.itemId == BuildingTypes.LW_BUILE_SCIENCE_TWO or data.itemId == BuildingTypes.LW_BUILE_SCIENCE_THREE or data.itemId == BuildingTypes.FUN_BUILD_SCIENE then
    local queue = DataCenter.QueueDataManager:GetQueueByBuildUuidForScience(bUuid)
    if data.level > 0 and queue ~= nil then
      local cityObj = CS.SceneManager.World:GetBuildingByPoint(data.pointId)
      local idleModel, workModel
      if cityObj then
        idleModel = cityObj.gameObject.transform:Find("ModelGo/Normal/idle")
        workModel = cityObj.gameObject.transform:Find("ModelGo/Normal/work")
      end
      if IsNull(idleModel) or IsNull(workModel) then
        return
      end
      idleModel.gameObject:SetActive(queue:GetQueueState() ~= NewQueueState.Work)
      workModel.gameObject:SetActive(queue:GetQueueState() == NewQueueState.Work)
    end
  end
end

local function GetBuildModelByPointId(pointId)
  local world = CS.SceneManager.World
  if IsNull(world) then
    return
  end
  return CS.SceneManager.World:GetBuildingByPoint(pointId)
end

local function BuildInViewSignal(bUuid)
  DataCenter.BuildManager:AddOneBuildInView(bUuid)
  DataCenter.BuildBubbleManager:CheckShowBubble(bUuid)
  DataCenter.BuildTrainEffectManager:CheckShowTimeFinishEffect(bUuid)
  DataCenter.BuildTimeManager:BuildInViewSignal(bUuid)
  DataCenter.BuildCanUpgradeEffectManager:TryShowOneEffect(bUuid)
  DataCenter.BuildManager:SetFarmBuild(bUuid)
  DataCenter.BuildManager:BuildingShowStateModel(bUuid)
  DataCenter.BuildHeroCountdownManager:BuildInViewSignal(bUuid)
  BusinessCenterAnimationController:GetInstance():DoWhenBuildInView(bUuid)
end

local function BuildOutViewSignal(bUuid)
  DataCenter.BuildManager:RemoveOneBuildInView(bUuid)
  DataCenter.BuildBubbleManager:DeleteOneBuildBubble(bUuid)
  DataCenter.BuildTrainEffectManager:RemoveOneEffect(bUuid)
  DataCenter.BuildTimeManager:BuildOutViewSignal(bUuid)
  DataCenter.BuildCanUpgradeEffectManager:RemoveOneEffect(bUuid)
end

local function IsBuildInView(self, bUuid)
  return self.inViewBuild[bUuid] ~= nil
end

local function GetFarmEffect(pointId)
  local flameObj
  local cityObj = GetBuildModelByPointId(pointId)
  if cityObj and not IsNull(cityObj) then
    flameObj = cityObj.gameObject.transform:Find("cityStateEffect")
  end
  return flameObj
end

local function ShowBuildFarmEffect(pointId, isOn)
  local cityStateEffect = GetFarmEffect(pointId)
  if IsNull(cityStateEffect) then
    return
  end
  local flameObj = cityStateEffect.transform:Find("fameEffecrRoot")
  if flameObj.gameObject.activeSelf and not isOn then
    TimerManager:GetInstance():DelayInvoke(function()
      local cityStateEffect = GetFarmEffect(pointId)
      if not IsNull(cityStateEffect) then
        local repairEffect = cityStateEffect.transform:Find("repairEffect")
        if not IsNull(repairEffect) then
          repairEffect.gameObject:SetActive(true)
        end
      end
    end, 1)
  end
  if not IsNull(flameObj) then
    flameObj.gameObject:SetActive(isOn)
  end
end

local function RefreshCityState(effectId)
  local self = DataCenter.BuildManager
  if effectId == CityState.RuinedCity then
    local isOn = LuaEntry.Effect:CheckCityFarmState()
    for uuid, data in pairs(self.flameDic) do
      ShowBuildFarmEffect(data.pointId, isOn)
    end
  end
end

local function SetFarmBuild(self, bUuid)
  local data = self.allBuilding[bUuid]
  if data and not data:GetIsDecorate() then
    local isFlame = data:SetFlameState()
    if isFlame and not self.flameDic[bUuid] then
      self.flameDic[bUuid] = data
    end
    local isOn = LuaEntry.Effect:CheckCityFarmState()
    if isFlame then
      ShowBuildFarmEffect(data.pointId, isOn)
    end
  end
end

local function GetBuildState(self, buildId)
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  if buildTemplate ~= nil and not buildTemplate:IsTimeConditionValid() then
    return BuildState.BUILD_LIST_SEASON_TIME_CONDITION
  end
  if buildTemplate ~= nil and not buildTemplate:IsTimePreConditionValid() then
    return BuildState.BUILD_LIST_SEASON_TIME_PRE_CONDITION
  end
  if buildId == BuildingTypes.FUN_BUILD_SCIENCE_PART then
    if self:GetMaxBuildNum(buildId) == 0 then
      return BuildState.BUILD_LIST_STATE_VIP_LEVEL
    end
  elseif buildId == BuildingTypes.FUN_BUILD_ARROW_TOWER then
    if self:GetMaxBuildNum(buildId) == 0 then
      return BuildState.BUILD_LIST_NEED_PARA3_SCIENCE
    end
  elseif buildId == BuildingTypes.SEASON_DESERT_ARMY_ATTACK_2 or buildId == BuildingTypes.SEASON_DESERT_ARMY_DEFEND_2 or buildId == BuildingTypes.SEASON_DESERT_BUILD_DRONE_1 or buildId == BuildingTypes.SEASON_DESERT_BUILD_DRONE_2 then
    if self:GetMaxBuildNum(buildId) == 0 then
      return BuildState.BUILD_LIST_NEED_MASTERY
    end
  elseif BuildingUtils.IsSeasonWeekCardCityBuilding(buildId) then
    local flag = true
    local seasonConfig = DataCenter.SeasonDataManager:GetSeasonConfig()
    if seasonConfig then
      local cardData = DataCenter.SeasonPeriodicCardManager:GetCardData(tonumber(seasonConfig.week_card))
      if cardData and cardData:IsBought() then
        flag = false
      end
    end
    if flag then
      return BuildState.BUILD_LIST_NEED_BUY_WEEKCARD_SEASON
    end
  elseif buildId == BuildingTypes.LW_BUILD_DOMINATOR_MAIN then
    if not DataCenter.DominatorManager:IsDominatorFunctionOn() or not DataCenter.DominatorGuideManager:IsBigGorillaDetectEventClaimed() then
      return BuildState.BUILD_LIST_TABLE_SWITCH_CONDITION
    end
  elseif buildId == BuildingTypes.LW_BUILD_DOMINATOR_TRAIN then
    local isTreatmentFinish = false
    local info = DataCenter.DominatorManager:GetInfoById(DominatorId.Gorilla)
    if info and info:IsFinishTreatment() then
      isTreatmentFinish = true
    end
    if not DataCenter.DominatorManager:IsDominatorFunctionOn() or not isTreatmentFinish then
      return BuildState.BUILD_LIST_TABLE_SWITCH_CONDITION
    end
  elseif buildId == BuildingTypes.LW_CIVILIZATION_SPARK then
    return BuildState.BUILD_LIST_TABLE_SWITCH_CONDITION
  end
  local buildNum = self:GetHaveBuildNumWithOutFoldUpByBuildId(buildId)
  local maxNum = self:GetMaxBuildNum(buildId)
  if buildNum >= maxNum then
    return BuildState.BUILD_LIST_REACH_MAX
  end
  local curMaxNum, maxType = self:GetCurMaxBuildNum(buildId)
  if buildNum >= curMaxNum then
    if maxType == BuildMaxNumType.Cur then
      return BuildState.BUILD_LIST_REACH_CUR_MAX
    elseif maxType == BuildMaxNumType.Guide then
      return BuildState.BUILD_LIST_NEED_GUIDE
    elseif maxType == BuildMaxNumType.Quest then
      return BuildState.BUILD_LIST_NEED_QUEST
    elseif maxType == BuildMaxNumType.Chapter then
      return BuildState.BUILD_LIST_NEED_CHAPTER
    end
    return BuildState.BUILD_LIST_REACH_CUR_MAX
  end
  local list = self:GetFoldUpBuildByBuildId(buildId)
  if list ~= nil then
    for k, v in ipairs(list) do
      return BuildState.BUILD_LIST_RECEIVED
    end
  end
  if buildTemplate ~= nil then
    if not DataCenter.PlayerLevelManager:ReachLevel(buildTemplate.unlock_player_level) then
      return BuildState.BUILD_LIST_STATE_NEED_LEVEL
    end
    if buildTemplate.tab_type == UIBuildListTabType.SeasonBuild then
      local allianceCenterId = toInt(buildTemplate.para1)
      local allianceCenterData = DataCenter.AllianceMineManager:GetAllianceCenterDataByBuildId(allianceCenterId)
      if allianceCenterData ~= nil then
        if allianceCenterData.status == AllianceMineStatus.Build then
          return BuildState.BUILD_LIST_NEED_ALLIANCE_CENTER_FOR_BUILD
        end
      else
        return BuildState.BUILD_LIST_NEED_ALLIANCE_CENTER_FOR_BUILD
      end
      local effectCondition = buildTemplate.effectCondition
      if effectCondition and effectCondition.effectId then
        local effectId = effectCondition.effectId
        local effectValue = LuaEntry.Effect:GetGameEffect(effectId)
        if effectValue == nil or effectValue == 0 then
          return BuildState.BUILD_LIST_SCIENCE_SEASON
        end
      end
    elseif buildTemplate.tab_type == UIBuildListTabType.SeasonCityBuild then
      local effectCondition = buildTemplate.effectCondition
      if effectCondition and effectCondition.effectId then
        local effectId = effectCondition.effectId
        local effectValue = LuaEntry.Effect:GetGameEffect(effectId)
        if effectValue == nil or effectValue == 0 then
          local effectValue1 = DataCenter.LWSeasonTrendsManager:GetEffectValue(effectCondition.effectId)
          if effectValue1 == nil or effectValue1 == 0 then
            return BuildState.BUILD_LIST_INSUFFICIENT_EFFECT_CONDITION
          end
        end
      end
    end
    if buildTemplate.month_card and buildTemplate.month_card ~= 0 and not DataCenter.MonthCardNewManager:CheckIfMonthCardActive() then
      return BuildState.BUILD_LIST_STATE_NEED_BUY_MONTH
    end
    if buildTemplate.need_pve ~= 0 then
      local data = DataCenter.LandLockManager:GetLandLockDataById(buildTemplate.need_pve)
      if data == nil or data.state ~= LandLockState.Finished then
        return BuildState.BUILD_LIST_NEED_UNLOCK_TILE
      end
    end
    if not string.IsNullOrEmpty(buildTemplate.need_talent) and not DataCenter.TalentDataManager:IsTalentOpen(buildTemplate.need_talent) then
      return BuildState.BUILD_LIST_NEED_UNLOCK_TALENT
    end
    local lackItem = false
    local needItem = buildTemplate:GetNeedItem()
    if needItem ~= nil then
      for k1, v1 in ipairs(needItem) do
        local curNum = DataCenter.ItemData:GetItemCount(v1.itemId)
        if curNum < v1.num then
          if buildTemplate.gift_id ~= nil and buildTemplate.gift_id ~= "" then
            local vec1 = string.split(buildTemplate.gift_id, ";")
            local hasExchangeInfo = false
            for k, v in ipairs(vec1) do
              local gift = GiftPackageData:GetInstance():GetInfoById(v)
              if gift ~= nil then
                hasExchangeInfo = true
                break
              end
            end
            if hasExchangeInfo then
              return BuildState.BUILD_LIST_STATE_NEED_BUY
            end
          end
          lackItem = true
        end
      end
    end
    if lackItem and (buildId == 479000 or buildId == 480000 or buildId == 481000 or buildId == 482000) then
      return BuildState.BUILD_LIST_STATE_NEED_ITEM_FORM_GIFT
    end
    local needScience = buildTemplate:GetNeedScience()
    if needScience ~= nil and 0 < table.count(needScience) then
      for k1, v1 in ipairs(needScience) do
        if not DataCenter.ScienceManager:HasScienceByIdAndLevel(v1.scienceId, v1.level) then
          if not buildTemplate:IsPreBuildConditionValid() then
            return BuildState.BUILD_LIST_SCIENCE_BUILD
          end
          return BuildState.BUILD_LIST_SCIENCE
        end
      end
    elseif not buildTemplate:IsPreBuildConditionValid() then
      return BuildState.BUILD_LIST_PREBUILD
    end
    local needPeopleNum = buildTemplate:GetNeedPeopleNumByBuildNum(buildNum + 1)
    if 0 < needPeopleNum and needPeopleNum > LuaEntry.Resource:GetCntByResType(ResourceType.People) then
      return BuildState.BUILD_LIST_LACK_PEOPLE
    end
    if buildTemplate.mono_condition ~= 0 and buildTemplate.mono_condition >= DataCenter.MonopolyManager.player.curId then
      return BuildState.BUILD_LIST_STATE_NEED_MONOPOLY
    end
    if buildTemplate.put ~= BuildPutType.Lv0 then
      local needResource = buildTemplate:GetNeedResource()
      if needResource ~= nil then
        for k, v in ipairs(needResource) do
          if v.count > LuaEntry.Resource:GetCntByResType(v.resourceType) then
            return BuildState.BUILD_LIST_LACK_RESOURCE
          end
        end
      end
      needResource = buildTemplate:GetNeedResourceItem()
      if needResource ~= nil then
        for k, v in ipairs(needResource) do
          if v.count > DataCenter.ResourceItemDataManager:GetCountByItemId(v.itemId) then
            return BuildState.BUILD_LIST_STATE_NEED_RESOURCE_ITEM
          end
        end
      end
    end
    if lackItem then
      return BuildState.BUILD_LIST_STATE_NEED_BUY_ITEM
    end
  end
  return BuildState.BUILD_LIST_STATE_OK
end

local function CheckBuildingUnlockWithPreBuildAndScience(self, buildId)
  local buildNum = DataCenter.BuildManager:GetHaveBuildNumWithOutFoldUpByBuildId(buildId)
  if 0 < buildNum then
    return true
  end
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  if buildTemplate ~= nil then
    local needScience = buildTemplate:GetNeedScience()
    if needScience ~= nil and 0 < table.count(needScience) then
      for _, v1 in ipairs(needScience) do
        if not DataCenter.ScienceManager:HasScienceByIdAndLevel(v1.scienceId, v1.level) then
          return false
        end
      end
    elseif not buildTemplate:IsPreBuildConditionValid() then
      return false
    end
  end
  return true
end

local function GetCanUpgradeBuildUuidList(self, ignore)
  local list = {}
  local buildIdList = DataCenter.BuildManager:GetAllBuildUuid()
  if buildIdList ~= nil then
    table.walk(buildIdList, function(k, v)
      if self:GetBuildCanUpgrade(v, ignore) then
        table.insert(list, v)
      end
    end)
  end
  return list
end

SpecialBuildingIdList = {
  [BuildingTypes.LW_BUILD_PARKINGLOT_FOUR] = true
}

local function GetCanUpgradeBuildUuidListFilterd(self, ignore)
  local list = {}
  local buildIdList = DataCenter.BuildManager:GetAllBuildUuid()
  if buildIdList ~= nil then
    table.walk(buildIdList, function(k, v)
      local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(v)
      local baseBuildingId = buildData.itemId
      local buildDesTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(baseBuildingId)
      if buildData and not SpecialBuildingIdList[buildData.itemId] and not (buildData.level <= 0) and buildData.state ~= BuildingStateType.Upgrading and (not buildDesTemplate or buildDesTemplate.tab_type ~= UIBuildListTabType.Decorate) then
        goto lbl_36
        goto lbl_48
        ::lbl_36::
        if self:GetBuildCanUpgrade(v, ignore) then
          table.insert(list, v)
        end
      end
      ::lbl_48::
    end)
  end
  return list
end

local function GetBuildCanUpgrade(self, bUuid, ignore)
  local canUpgrade = false
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildData ~= nil and buildData.state == BuildingStateType.Normal then
    local level = buildData.level
    local buildId = buildData.itemId
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
    if buildTemplate ~= nil and level < buildTemplate.max_level then
      local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
      if buildLevelTemplate ~= nil then
        if not buildLevelTemplate:IsPreBuildConditionValid() then
          return false
        end
        if not buildLevelTemplate:IsTimeConditionValid() then
          return false
        end
        if not ignore then
          local ret = DataCenter.BuildManager:CheckBuildUpgradeResAndItem(bUuid)
          if not ret.enough then
            return false
          end
        end
        canUpgrade = true
      end
    end
  end
  return canUpgrade
end

local function ShowBuildCanUpgradeBubble(self, bUuid)
  local canUpgrade = false
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildData ~= nil and buildData.state == BuildingStateType.Normal then
    local level = buildData.level
    local buildId = buildData.itemId
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
    if buildTemplate ~= nil then
      if string.IsNullOrEmpty(buildTemplate.upgrade_notice) then
        return false
      elseif level < buildTemplate.max_level and self.MainLv - level >= tonumber(buildTemplate.upgrade_notice) then
        local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
        if buildLevelTemplate ~= nil then
          if not buildLevelTemplate:IsPreBuildConditionValid() then
            return false
          end
          local ret = self:CheckBuildUpgradeResAndItem(bUuid)
          if ret.lackPeopleNum or table.count(ret.lackItemList) > 0 or 0 < table.count(ret.lackResItemList) then
            return false
          end
          canUpgrade = true
        end
      end
    end
  end
  return canUpgrade
end

local function GetCanJoinRoadBuildUuidList(self)
  local list = {}
  local buildIdList = DataCenter.BuildManager:GetAllBuildUuid()
  if buildIdList ~= nil then
    table.walk(buildIdList, function(k, v)
      if self:GetBuildCanJoinRoad(v) then
        table.insert(list, v)
      end
    end)
  end
  return list
end

local function GetBuildCanJoinRoad(self, bUuid)
  local canJoin = false
  return canJoin
end

local function GetSelfBuildMinLevel(self)
  local list = {}
  local temp = self:GetCanUpgradeBuildUuidList(true)
  if next(temp) then
    table.walk(temp, function(k, v)
      list[k] = {}
      list[k].bUuid = v
      list[k].level, list[k].cost = self:GetBuildMinLevel(v)
    end)
    table.sort(list, function(a, b)
      if a.level ~= nil and b.level ~= nil then
        if a.level < b.level then
          return true
        elseif a.level == b.level and a.cost < b.cost then
          return true
        end
        return false
      end
    end)
  end
  return list
end

local function GetBuildMinLevel(self, bUuid)
  local cost = 0
  local level
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildData ~= nil and buildData.state ~= BuildingStateType.FoldUp and buildData.itemId ~= BuildingTypes.FUN_BUILD_MAIN and buildData.level < buildData:getMaxLevel() then
    level = buildData.level
    local buildId = buildData.itemId
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
    if level < buildTemplate.max_level then
      local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
      if buildLevelTemplate ~= nil then
        local resources = buildLevelTemplate:GetNeedResource()
        if resources ~= nil then
          for k, v in ipairs(resources) do
            local resourceType = v.resourceType
            if resourceType == ResourceType.Food then
              cost = v.count
            end
          end
        end
      end
    end
    return level, cost
  end
end

local function GetBuildIconPath(self, buildId, level)
  local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
  if levelTemplate ~= nil and template ~= nil then
    return levelTemplate:GetBuildIconOutCity()
  end
  return DefaultImage
end

local function GetExtraCanBuildNum(self, buildId)
  return DataCenter.BuildManager:GetUnlock2BuildByEffectAndType(buildId)
end

local function FreeBuildingFoldUpNewHandle(self, message)
  if message.errorCode == nil then
    local bUuid = 0
    if message.buildInfo ~= nil then
      local dic = message.buildInfo
      if dic ~= nil then
        bUuid = dic.uuid
        self:AddBuilding(dic)
        local build = self:GetBuildingDataByUuid(bUuid)
        if build:GetIsDecorate() then
          UIUtil.ShowTips(Localization:GetString(130247))
        end
        EventManager:GetInstance():Broadcast(EventId.UPDATE_BUILD_DATA, bUuid)
      end
    end
    if message.needRemove then
      DataCenter.BuildHeroManager:RemoveBuildHero(self.allBuilding[message.needRemove].prodStatus)
      self:RemoveBuilding(message.needRemove)
      EventManager:GetInstance():Broadcast(EventId.UPDATE_BUILD_DATA, message.needRemove)
    end
    EventManager:GetInstance():Broadcast(EventId.DecorateRedPoint)
  else
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
  end
end

local function FreeBuildingExpendDomeHandle(self, message)
  if message.errorCode == nil then
    local bUuid = 0
    bUuid = message.uuid
    self:AddBuilding(message)
    CS.SceneManager.World:OnExtendDome()
    EventManager:GetInstance():Broadcast(EventId.UPDATE_BUILD_DATA, bUuid)
  else
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
  end
end

local function ShowUpLevelReward(bUuid, rewards)
  if table.IsNullOrEmpty(rewards) then
    return
  end
  if rewards ~= nil then
    local hasExp, buildData, pos
    if bUuid then
      buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
      pos = SceneUtils.TileIndexToWorld(buildData.pointId)
    end
    local rewardList = DataCenter.RewardManager:ReturnRewardParamForMessage(rewards) or {}
    for i, v in ipairs(rewardList) do
      local rewardType = v.rewardType
      local itemId = v.itemId
      if DataCenter.SoldierDataManager:GetSoldierLevelById(itemId) ~= 0 and buildData then
        DataCenter.LWCityPerformNpcManager:GetUtil():MilitaryCampCollectSolder(bUuid, itemId, v.count)
      else
        local pic = RewardUtil.GetPic(rewardType, itemId)
        if pic ~= "" then
          local disPos = Vector3.New(0, 0, 0)
          if rewardType == RewardType.RESOURCE_ITEM then
            if tonumber(itemId) == ResourceItemId.HeroExp then
              disPos = UIUtil.GetFlyTargetByRewardType(RewardType.HERO)
            else
              disPos = UIUtil.GetFlyTargetByRewardType(rewardType)
            end
            
            local function fun()
              EventManager:GetInstance():Broadcast(EventId.AcquireHeroExp_FlyEnd)
            end
            
            UIUtil.DoFly(tonumber(rewardType), 5, pic, CS.CSUtils.WorldPositionToUISpacePosition(pos), disPos, nil, nil, fun, nil, 1)
          end
        end
      end
    end
    if pos then
      SceneUtils.ReturnPoolV3(pos)
    end
  end
end

local function FreeBuildingUpNewHandle(self, message)
  if message.errorCode == nil then
    if message.serverSystemTime ~= nil then
      CS.GameEntry.Timer:UpdateServerMilliseconds(message.serverSystemTime)
      UITimeManager:GetInstance():UpdateServerMsDeltaTime(message.serverSystemTime)
    end
    if message.resource ~= nil then
      LuaEntry.Resource:UpdateResource(message.resource)
    end
    if message.remainGold ~= nil then
      LuaEntry.Player.gold = message.remainGold
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
    local bUuid = 0
    local endTime = 0
    local startTime = 0
    local pointId = 0
    local level = 0
    local itemId = 0
    if message.buildInfo ~= nil then
      local dic = message.buildInfo
      if dic ~= nil then
        bUuid = dic.uuid
        if dic.bId ~= nil then
          itemId = dic.bId
        end
        if dic.lv ~= nil then
          level = dic.lv
        end
        if dic.pId ~= nil then
          pointId = dic.pId
        end
        if dic.sT ~= nil then
          startTime = dic.sT
        end
        if dic.uT ~= nil then
          endTime = dic.uT
        end
        local gold = message.gold
        if gold == BuildUpgradeUseGoldType.Yes then
          EventManager:GetInstance():Broadcast(EventId.BuildUpgradeAnimationFinish, bUuid)
        end
        self:AddBuilding(dic)
        self:CheckGetNewBuildSendMessage(itemId, level, bUuid)
        EventManager:GetInstance():Broadcast(EventId.UPDATE_BUILD_DATA, bUuid)
        self:ShowBuildSpeedUpState(dic.uuid, startTime, endTime)
        if 0 < endTime then
          EventManager:GetInstance():Broadcast(EventId.BuildUpgradeStart, bUuid)
          local buildData = self.allBuilding[bUuid]
          EventManager:GetInstance():Broadcast(EventId.GF_building_upgrade_started, buildData)
          if 0 < level then
            DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.BuildUpgradeStart, tostring(tonumber(itemId) + level))
          end
          local now = UITimeManager:GetInstance():GetServerTime()
          if endTime > now then
            DataCenter.LWSoundManager:PlaySound(80013, false)
          end
        else
          self:OpenUpgradeSuccess(itemId, level, bUuid, message.reward, message.onceAddExp)
          if self:CheckShowUnlock(itemId, level) == false then
            EventManager:GetInstance():Broadcast(EventId.ShowPower, RewardType.POWER)
          end
          self:FlyExp(bUuid, itemId)
          if itemId == BuildingTypes.FUN_BUILD_MAIN and level == 10 then
            local ok, errorMsg = xpcall(function()
              CS.GameEntry.Sdk:LogEventLevelUp(level)
              return true
            end, debug.traceback)
          end
          if dic.bId == BuildingTypes.FUN_BUILD_TRADING_CENTER then
            local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(dic.uuid)
            local pos = SceneUtils.TileIndexToWorld(buildData.pointId)
            local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(dic.bId, dic.lv)
            local str = string.split(levelTemplate.para5, ";")
            local add = 0
            if dic.lv == 1 then
              add = tonumber(str[1])
            else
              local lastLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(dic.bId, dic.lv - 1)
              local strLast = string.split(lastLevelTemplate.para5, ";")
              add = tonumber(str[1]) - tonumber(strLast[1])
            end
            local param = {}
            param.type = 0
            param.icon = string.format(LoadPath.UIHeroStation, "UIappoint_icon_01")
            param.name = 162103
            param.pos = CS.SceneManager.World:WorldToScreenPoint(pos)
            SceneUtils.ReturnPoolV3(pos)
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIResourceGetTip, {anim = true}, add, tonumber(str[1]), tonumber(str[2]), tonumber(str[2]), param)
          elseif dic.bId == BuildingTypes.FUN_BUILD_HERO_MONUMENT then
            local k6 = LuaEntry.DataConfig:TryGetStr("aps_pve_exp", "k6") or ""
            for _, lv in ipairs(string.split(k6, ";")) do
              if dic.lv == tonumber(lv) then
                PveUtil.ClearHeroPowerCache()
                break
              end
            end
          elseif dic.bId == BuildingTypes.LW_BUILD_BATTLE_HANGUP_REWARD then
            self.isFetchHangUpRewardSilently = true
            SFSNetwork.SendMessage(MsgDefines.HangUpRewardMessage, 0, true)
          end
          EventManager:GetInstance():Broadcast(EventId.BuildUpgradeFinish, bUuid)
          EventManager:GetInstance():Broadcast(EventId.GF_building_upgrade_done, self.allBuilding[bUuid])
          DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Finish, false)
        end
        if dic.bId == BuildingTypes.LW_BUILDING_SEASON5_RESEARCH and dic.lv == 1 then
          UIUtil.CheckEventTrigger(OpMode.BuildBoxOpenFinish821000, 0, 0.5)
        elseif dic.bId == BuildingTypes.LW_BUILDING_SEASON5_SHOP and dic.lv == 1 then
          UIUtil.CheckEventTrigger(OpMode.BuildBoxOpenFinish827000, 0, 0.5)
        elseif BuildingUtils.IsSeasonWeekCardCityBuilding(dic.bId) then
          DataCenter.BuildBubbleManager:CheckShowBubble(bUuid)
        elseif dic.bId == BuildingTypes.LW_BUILD_SEASON6_BUILD1 and dic.lv == 1 then
          UIUtil.CheckEventTrigger(OpMode.ClickBtnMilitary, 0, 0.5)
        end
        if BuildingUtils.IsSeasonInCityBuilding(dic.bId) then
          DataCenter.BuildBubbleManager:CheckShowBubble(bUuid)
          SeasonUtil.TryUpdateSeasonBuild(605001001)
        end
      end
    end
    if message.queue ~= nil then
      for k, v in pairs(message.queue) do
        DataCenter.QueueDataManager:UpdateQueueData(v)
      end
    end
    if message.build_queue then
      DataCenter.BuildQueueManager:UpdateQueueData({
        message.build_queue
      }, false)
    end
    EventManager:GetInstance():Broadcast(EventId.ShowMainUIPart)
  else
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(self:ShowBuildErrorCode(errorCode))
    end
    EventManager:GetInstance():Broadcast(EventId.GF_upgrade_building_failed)
  end
end

local function FreeBuildingStartFixHandle(self, message)
  if message.errorCode == nil then
    local bUuid = 0
    local endTime = 0
    local startTime = 0
    local pointId = 0
    local level = 0
    local itemId = 0
    if message ~= nil then
      local dic = message
      if dic ~= nil then
        bUuid = dic.uuid
        if dic.bId ~= nil then
          itemId = dic.bId
        end
        if dic.lv ~= nil then
          level = dic.lv
        end
        if dic.pId ~= nil then
          pointId = dic.pId
        end
        if dic.dStT ~= nil then
          startTime = dic.dStT
        end
        if dic.dEndT ~= nil then
          endTime = dic.dEndT
        end
        self:AddBuilding(dic)
        EventManager:GetInstance():Broadcast(EventId.UPDATE_BUILD_DATA, bUuid)
        EventManager:GetInstance():Broadcast(EventId.BuildFixStart, bUuid)
      end
    end
  else
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(self:ShowBuildErrorCode(errorCode))
    end
  end
end

local function FreeBuildingFinishFixHandle(self, message)
  if message.errorCode == nil then
    local bUuid = 0
    if message ~= nil then
      local dic = message
      if dic ~= nil then
        bUuid = dic.uuid
        self:AddBuilding(dic)
        EventManager:GetInstance():Broadcast(EventId.UPDATE_BUILD_DATA, bUuid)
        EventManager:GetInstance():Broadcast(EventId.BuildFixFinish, bUuid)
      end
    end
  else
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(self:ShowBuildErrorCode(errorCode))
    end
  end
end

local function HasBuildByIdAndLevel(self, id, level)
  local curLevel = DataCenter.BuildManager:GetMaxBuildingLevel(id)
  return level <= curLevel
end

local function CheckShowBuildUnlockWhenScienceLevelUp(self, scienceId, level)
  local factoryTableList = DataCenter.FactoryDataManager:GetAllFactoryTemplate()
  if factoryTableList ~= nil then
    table.walk(factoryTableList, function(k, v)
      if v.unlock_type ~= nil and v.unlock_type == TemplateUnlockType.Science and v.unlock_condition[scienceId] ~= nil and level == v.unlock_condition[scienceId] then
        DataCenter.FactoryDataManager:SaveShowFactoryItemOpenFlag(v.id)
        UIUtil.ShowUnlockWindow(nil, string.format(LoadPath.ItemPath, v.icon), Localization:GetString(v.product_name), UnlockWindowType.Product, nil)
        result = true
      end
    end)
  end
  local allBuildIds = DataCenter.BuildTemplateManager:GetBuildListIds()
  if allBuildIds ~= nil then
    table.walk(allBuildIds, function(_, types)
      table.walk(types, function(_, v)
        local buildTemp = v.buildTemplate
        if buildTemp ~= nil and CommonUtil.GetBuildLv(buildTemp.id) == 0 and (buildTemp.tab_type == BuildType.Main or buildTemp.tab_type == BuildType.Second) and self:CheckBuildingUnlockWithPreBuildAndScience(buildTemp.id) == true and DataCenter.PlayerLevelManager:ReachLevel(buildTemp.unlock_player_level) then
          local needScience = buildTemp:GetNeedScience()
          if needScience ~= nil and 0 < table.count(needScience) then
            for _, v1 in ipairs(needScience) do
              if v1.scienceId == scienceId and level >= v1.level then
                EventManager:GetInstance():Broadcast(EventId.UnlockBuilding)
                if buildTemp.building_show == 1 then
                  local icon = self:GetBuildIconPath(buildTemp.id, 1)
                  UIUtil.ShowUnlockWindow(Localization:GetString("115636"), icon, Localization:GetString(buildTemp.name), UnlockWindowType.Building, UIUtil.GetUIMainSavePos(UIMainSavePosType.FastBuild))
                end
              end
            end
          end
        end
      end)
    end)
  end
end

local function CheckShowFarmUnlockWhenReceiveLevelReward(self, farmId)
  local farmTemp = DataCenter.FarmingDataManager:GetFramingTemplate(farmId)
  if farmTemp then
    local meetConditions = true
    for buildId, level in pairs(farmTemp.unlock_condition) do
      if not DataCenter.BuildManager:IsExistBuildByTypeLv(buildId, level) then
        meetConditions = false
        break
      end
    end
    if meetConditions and DataCenter.PlayerLevelManager:ReachLevel(farmTemp.unlock_player_level) then
      UIUtil.ShowUnlockWindow(nil, string.format(LoadPath.ItemPath, farmTemp.icon), Localization:GetString(farmTemp.product_name), UnlockWindowType.Product, nil)
    end
  end
end

local function CheckShowBuildUnlockWhenReceiveLevelReward(self, buildId)
  local buildTemp = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  if buildTemp and self:CheckBuildingUnlockWithPreBuildAndScience(buildTemp.id) and buildTemp.building_show == 1 then
    local icon = self:GetBuildIconPath(buildTemp.id, 1)
    UIUtil.ShowUnlockWindow(Localization:GetString("115636"), icon, Localization:GetString(buildTemp.name), UnlockWindowType.Building, UIUtil.GetUIMainSavePos(UIMainSavePosType.FastBuild))
  end
end

local function GetFactoryUnlockItemKey(self, id)
  local key = SettingKeys.UNLOCK_FACTORY_PRELEVEL .. "_" .. LuaEntry.Player.uid .. tostring(id)
  return key
end

local function GetFactoryUnlockItemLevel(self, id)
  local key = self:GetFactoryUnlockItemKey(id)
  return Setting:GetInt(key, -1)
end

local function SaveFactoryUnlockItemLevel(self, id, level, needCheckLv)
  local currentLv = self:GetFactoryUnlockItemLevel(id)
  local saveFlag = false
  if currentLv == -1 then
    saveFlag = true
  elseif needCheckLv == true then
    if level < currentLv then
      saveFlag = true
    end
  else
    saveFlag = true
  end
  if saveFlag then
    local key = self:GetFactoryUnlockItemKey(id)
    Setting:SetInt(key, level)
  end
end

local function CheckAndShowFactoryUnlockItem(self, id, onlyCheckShow)
  local buildData = self:GetFunbuildByItemID(id)
  if buildData ~= nil then
    local recordLv = self:GetFactoryUnlockItemLevel(id)
    if 0 <= recordLv and recordLv < buildData.level then
      if not onlyCheckShow then
        self:SaveFactoryUnlockItemLevel(id, buildData.level, false)
      end
      local factoryTableList = DataCenter.FactoryDataManager:GetAllFactoryTemplate()
      if factoryTableList ~= nil then
        local currentLv = recordLv + 1
        while currentLv <= buildData.level do
          for _, v in pairs(factoryTableList) do
            if v.unlock_type ~= nil and v.unlock_type == TemplateUnlockType.Build and v.unlock_condition[id] ~= nil and currentLv == v.unlock_condition[id] then
              if onlyCheckShow then
                return true
              end
              UIUtil.ShowUnlockWindow(nil, string.format(LoadPath.ItemPath, v.icon), Localization:GetString(v.product_name), UnlockWindowType.Product, nil)
            end
          end
          currentLv = currentLv + 1
        end
      end
    end
  end
  return false
end

local function CheckShowUnlock(self, id, level)
  if level == 1 and id == BuildingTypes.FUN_BUILD_MAIN then
    return false
  end
  local result = false
  table.walk(BarracksBuild, function(_, v)
    if v == id and 1 < level then
      local idList = DataCenter.ArmyManager:GetArmyList(v)
      for _, armyId in ipairs(idList) do
        if DataCenter.ArmyManager:IsUnLock(armyId) then
          local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(armyId)
          if template ~= nil and template.unlock_train_build ~= nil and table.count(template.unlock_train_build) > 0 then
            for _, buildCon in ipairs(template.unlock_train_build) do
              if buildCon.buildId == id and buildCon.level == level then
                DataCenter.ArmyManager:SaveArmyUnlock(buildCon.buildId, armyId)
                goto lbl_62
              end
            end
          end
        end
      end
    end
    ::lbl_62::
  end)
  local factoryTableList = DataCenter.FactoryDataManager:GetAllFactoryTemplate()
  if factoryTableList ~= nil then
    table.walk(factoryTableList, function(k, v)
      if v.unlock_type ~= nil and v.unlock_type == TemplateUnlockType.Build and v.unlock_condition[id] ~= nil and level == v.unlock_condition[id] then
        self:SaveFactoryUnlockItemLevel(id, level - 1, true)
        DataCenter.FactoryDataManager:SaveShowFactoryItemOpenFlag(v.id)
        return false
      end
    end)
  end
  local farmingTableList = DataCenter.FarmingDataManager:GetFarmTemplateByBuildId(BuildingTypes.APS_BUILD_FARM_FIELD)
  if farmingTableList ~= nil then
    table.walk(farmingTableList, function(k, v)
      if v.unlock_type ~= nil and v.unlock_type == TemplateUnlockType.Build and v.unlock_condition[id] ~= nil and level == v.unlock_condition[id] and DataCenter.PlayerLevelManager:ReachLevel(v.unlock_player_level) then
        UIUtil.ShowUnlockWindow(nil, string.format(LoadPath.ItemPath, v.icon), Localization:GetString(v.product_name), UnlockWindowType.Product, nil)
        result = true
      end
    end)
  end
  local allBuildIds = DataCenter.BuildTemplateManager:GetBuildListIds()
  if allBuildIds ~= nil then
    table.walk(allBuildIds, function(_, types)
      table.walk(types, function(_, v)
        local buildTemp = v.buildTemplate
        if buildTemp ~= nil and CommonUtil.GetBuildLv(buildTemp.id) == 0 and (buildTemp.tab_type == BuildType.Main or buildTemp.tab_type == BuildType.Second) and self:CheckBuildingUnlockWithPreBuildAndScience(buildTemp.id) == true and DataCenter.PlayerLevelManager:ReachLevel(buildTemp.unlock_player_level) then
          local preBuild = buildTemp:GetPreBuild()
          if preBuild ~= nil then
            for _, v1 in ipairs(preBuild) do
              if v1.buildId == id and v1.level == level then
                EventManager:GetInstance():Broadcast(EventId.UnlockBuilding)
                if buildTemp.building_show == 1 then
                  local icon = self:GetBuildIconPath(buildTemp.id, 1)
                  UIUtil.ShowUnlockWindow(Localization:GetString("115636"), icon, Localization:GetString(buildTemp.name), UnlockWindowType.Building, UIUtil.GetUIMainSavePos(UIMainSavePosType.FastBuild))
                  result = true
                end
              end
            end
          end
        end
      end)
    end)
  end
  if result == true and UIManager:GetInstance():GetWindow(UIWindowNames.UIBuildUpgrade) ~= nil then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBuildUpgrade)
  end
  return result
end

local function GetBuildId(self, id)
  return id // BuildLevelCap * BuildLevelCap
end

local function GetBuildLevel(self, id)
  return id % BuildLevelCap
end

local function GetEffectNumWithType(self, value, type)
  if type == EffectLocalType.Num then
    return string.GetFormattedSeperatorNum(value)
  elseif type == EffectLocalType.Time then
    return UITimeManager:GetInstance():SecondToFmtString(value)
  elseif type == EffectLocalType.Percent then
    return string.GetFormattedPercentStr(value / 100)
  elseif type == EffectLocalType.Dialog then
    if value ~= nil and value ~= "" then
      return Localization:GetString(value)
    else
      return ""
    end
  elseif type == EffectLocalType.PositiveNum then
    return "+" .. string.GetFormattedSeperatorNum(value)
  elseif type == EffectLocalType.NegativeNum then
    return "-" .. string.GetFormattedSeperatorNum(value)
  elseif type == EffectLocalType.PositiveTime then
    return "+" .. UITimeManager:GetInstance():SecondToFmtString(value)
  elseif type == EffectLocalType.NegativeTime then
    return "-" .. UITimeManager:GetInstance():SecondToFmtString(value)
  elseif type == EffectLocalType.PositivePercent then
    return "+" .. string.GetFormattedPercentStr(value / 100)
  elseif type == EffectLocalType.NegativePercent then
    return "-" .. string.GetFormattedPercentStr(value / 100)
  end
end

local function CheckShowBuildAddDes(self, id, level)
  local curTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(id, level)
  if curTemplate ~= nil then
    if 1 < level then
      local lastTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(id, level - 1)
      local curNums = curTemplate.local_num
      local lastNums = lastTemplate.local_num
      local curCount = table.count(curNums)
      local lastCount = table.count(lastNums)
      if curCount == lastCount then
        for i = 1, curCount do
          if curNums[i] ~= lastNums[i] then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgradeAddDes, {anim = true}, curTemplate.id)
            return
          end
        end
      end
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgradeAddDes, {anim = true}, curTemplate.id)
    end
  end
end

local function playBuildUpdateEffect(self, id, level)
end

local function IsShowBuildRedDot(self)
  local inBuildNum = self:GetBuildRedDotByTabType(UIBuildListTabType.Economy)
  if 0 < inBuildNum then
    return true
  end
  local outBuildNum = self:GetBuildRedDotByTabType(UIBuildListTabType.Military)
  if 0 < outBuildNum then
    return true
  end
  return false
end

local function IsShowRedDotByOnce(self, buildId)
  return self.noShowRedDot[buildId] == nil
end

local function CanShowUnlock(self, buildId)
  if self.noShowUnlock == nil then
    self:LoadNoShowUnlock()
  end
  return self.noShowUnlock[buildId] == nil
end

local function SetBuildRedDotOnce(self, buildId)
  self.noShowRedDot[buildId] = true
  EventManager:GetInstance():Broadcast(EventId.BuildRedDotRecord)
end

local function SetBuildShowUnlock(self, buildId)
  self.noShowUnlock[buildId] = true
  self:SaveNoShowUnlock()
end

local function GetBuildRedDotByTabType(self, tab)
  local result = 0
  if tab == UIBuildListTabType.Decorate then
    local builds = self.allDecorate
    local listBuilds, foldList, maxNum, count, template, redDotType
    for itemId, decorateList in pairs(builds) do
      template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(itemId)
      redDotType = template.red_dot
      if redDotType ~= BuildRedDotType.No then
        listBuilds = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(itemId)
        foldList = DataCenter.BuildManager:GetFoldUpBuildByBuildId(itemId)
        maxNum = self:GetMaxBuildNum(itemId)
        count = maxNum - table.count(listBuilds)
        if 0 < count then
          local foldCount = 0
          if foldList ~= nil then
            foldCount = table.count(foldList)
            result = result + math.min(foldCount, count)
          end
        end
      end
    end
    return result
  end
  local SeasonIsOpen = SeasonUtil.IsOpen()
  local buildIds = DataCenter.BuildTemplateManager:GetBuildListIds()
  if buildIds[tab] ~= nil then
    local allList = buildIds[tab]
    local season_group = "0"
    local checkSeasonGroup = false
    if tab == UIBuildListTabType.SeasonCityBuild then
      local config = DataCenter.SeasonDataManager:GetSeasonConfig()
      if config == nil then
        season_group = "0"
      else
        season_group = tostring(config.building)
      end
      checkSeasonGroup = true
    end
    for k1, v1 in ipairs(allList) do
      local redDotType = v1.buildTemplate.red_dot
      local id = v1.id
      if checkSeasonGroup and (v1.buildTemplate.season_group ~= season_group or not SeasonIsOpen) then
        redDotType = BuildRedDotType.No
      end
      if id == BuildingTypes.SEASON_CAREER_BUILD and not SeasonIsOpen then
        redDotType = BuildRedDotType.No
      end
      if id == BuildingTypes.LW_BUILD_RACE_ENTRANCE and not RaceEntranceUtil.IsNewEntranceOpen() then
        redDotType = BuildRedDotType.No
      end
      if redDotType == BuildRedDotType.No or redDotType == BuildRedDotType.Once and not self:IsShowRedDotByOnce(id) then
      else
        local state = self:GetBuildState(id)
        if state == BuildState.BUILD_LIST_STATE_OK or state == BuildState.BUILD_LIST_LACK_RESOURCE or state == BuildState.BUILD_LIST_LACK_PEOPLE then
          result = result + 1
        elseif state == BuildState.BUILD_LIST_RECEIVED then
          local foldCount = 0
          local foldList = DataCenter.BuildManager:GetFoldUpBuildByBuildId(id)
          if foldList ~= nil then
            foldCount = table.count(foldList)
          end
          result = result + foldCount
        end
      end
    end
  end
  return result
end

local function GetFirstRedDotBuildingId(self)
  local tabs = {
    UIBuildListTabType.Economy,
    UIBuildListTabType.Military
  }
  local buildIds = DataCenter.BuildTemplateManager:GetBuildListIds()
  for _, tab in pairs(tabs) do
    if buildIds[tab] ~= nil then
      local allList = buildIds[tab]
      for _, data in ipairs(allList) do
        local redDotType = data.buildTemplate.red_dot
        local id = data.id
        if redDotType == BuildRedDotType.No or redDotType == BuildRedDotType.Once and not self:IsShowRedDotByOnce(id) then
        else
          local state = self:GetBuildState(id)
          if state == BuildState.BUILD_LIST_STATE_OK or state == BuildState.BUILD_LIST_LACK_RESOURCE or state == BuildState.BUILD_LIST_LACK_PEOPLE then
            return data.id
          elseif state == BuildState.BUILD_LIST_RECEIVED then
            local foldCount = 0
            local foldList = DataCenter.BuildManager:GetFoldUpBuildByBuildId(id)
            if foldList ~= nil then
              foldCount = table.count(foldList)
            end
            if 0 < foldCount then
              return data.id
            end
          end
        end
      end
    end
  end
  return nil
end

local function IsShowRedDotByTemplateAndState(self, template, state)
  local redDotType = template.red_dot
  if redDotType == BuildRedDotType.No or redDotType == BuildRedDotType.Once and not self:IsShowRedDotByOnce(template.id) then
    return false
  end
  if state == BuildState.BUILD_LIST_STATE_OK or state == BuildState.BUILD_LIST_LACK_RESOURCE or state == BuildState.BUILD_LIST_LACK_PEOPLE or state == BuildState.BUILD_LIST_RECEIVED then
    return true
  end
  return false
end

local function IsDecorateBuildingShowRedDotByTemplateAndState(self, template, state)
  local redDotType = template.red_dot
  local itemId = template.id // BuildLevelCap * BuildLevelCap
  local listBuilds = self:GetAllBuildingByItemIdWithoutPickUp(itemId)
  if redDotType == BuildRedDotType.No or redDotType == BuildRedDotType.Once and not DataCenter.BuildManager:IsShowRedDotByOnce(template.id) then
    return false
  end
  local count = listBuilds and #listBuilds or 0
  if state == BuildState.BUILD_LIST_STATE_OK and count == 0 and not template.isBuy then
    return true
  end
  return false
end

local function PushInitBuildHandle(self, t)
  if t.defaultBuilds ~= nil then
    for k, message in pairs(t.defaultBuilds) do
      if message.serverSystemTime ~= nil then
        CS.GameEntry.Timer:UpdateServerMilliseconds(message.serverSystemTime)
        UITimeManager:GetInstance():UpdateServerMsDeltaTime(message.serverSystemTime)
      end
      if message.remainGold ~= nil then
        LuaEntry.Player.gold = message.remainGold
        EventManager:GetInstance():Broadcast(EventId.UpdateGold)
      end
      local bUuid = 0
      if message.buildInfo ~= nil then
        local dic = message.buildInfo
        if dic ~= nil then
          bUuid = dic.uuid
          self:AddBuilding(dic)
          EventManager:GetInstance():Broadcast(EventId.UPDATE_BUILD_DATA, bUuid)
        end
      end
      if message.queue ~= nil then
        for k, v in pairs(message.queue) do
          DataCenter.QueueDataManager:UpdateQueueData(v)
        end
      end
      if message.build_queue then
        DataCenter.BuildQueueManager:UpdateQueueData({
          message.build_queue
        }, false)
      end
      DataCenter.RewardManager:AddRewardsAndRes(message)
      EventManager:GetInstance():Broadcast(EventId.ShowMainUIPart)
    end
  end
end

local function PushBuildUpgradeFinishHandle(self, message)
  local bUuid = 0
  local endTime = 0
  local startTime = 0
  local pointId = 0
  local level = 0
  local itemId = 0
  local connect = 1
  if message.buildInfo ~= nil then
    local dic = message.buildInfo
    if dic ~= nil then
      bUuid = dic.uuid
      if dic.bId ~= nil then
        itemId = dic.bId
      end
      if dic.lv ~= nil then
        level = dic.lv
      end
      if dic.pId ~= nil then
        pointId = dic.pId
      end
      if dic.sT ~= nil then
        startTime = dic.sT
      end
      if dic.uT ~= nil then
        endTime = dic.uT
      end
      self:AddBuilding(dic)
      EventManager:GetInstance():Broadcast(EventId.UPDATE_BUILD_DATA, bUuid)
      if itemId == BuildingTypes.FUN_BUILD_MAIN and level == 1 then
        CS.SceneManager.World:SetTouchInputControllerEnable(true)
        EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
      end
      if itemId == BuildingTypes.FUN_BUILD_MAIN and level == 10 then
        local ok, errorMsg = xpcall(function()
          CS.GameEntry.Sdk:LogEventLevelUp(level)
          return true
        end, debug.traceback)
      end
      if self:CheckShowUnlock(itemId, level) == false then
        EventManager:GetInstance():Broadcast(EventId.ShowPower, RewardType.POWER)
      end
      self:FlyExp(bUuid, itemId)
      EventManager:GetInstance():Broadcast(EventId.BuildUpgradeFinish, bUuid)
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Finish, false)
    end
    DataCenter.RewardManager:AddRewardsAndRes(message)
  end
  if message.queue ~= nil then
    for k, v in pairs(message.queue) do
      DataCenter.QueueDataManager:UpdateQueueData(v)
    end
  end
  if message.build_queue then
    DataCenter.BuildQueueManager:UpdateQueueData({
      message.build_queue
    }, false)
  end
  EventManager:GetInstance():Broadcast(EventId.ShowMainUIPart)
end

local function UILoadingExitSignal()
  if DataCenter.CityPioneerManager:IsBeforePrologue() then
    return
  end
  DataCenter.EarthOrderDataManager:CheckShowTipAfterInit()
  DataCenter.RecommendShowManager:InitParamFromNet()
  DataCenter.BaseExpansionTemplateManager:InitPositionUnit()
end

local function GetResourceTypeByBuildId(self, buildId)
  if buildId == BuildingTypes.FUN_BUILD_WATER then
    return ResourceType.Water
  elseif buildId == BuildingTypes.FUN_BUILD_STONE then
    return ResourceType.Metal
  elseif buildId == BuildingTypes.FUN_BUILD_OIL then
    return ResourceType.Oil
  elseif buildId == BuildingTypes.FUN_BUILD_OUT_WOOD then
    return ResourceType.ResourceItem
  elseif buildId == BuildingTypes.FUN_BUILD_OUT_STONE then
    return ResourceType.ResourceItem
  end
  return ResourceType.None
end

local function GetResTypeByBuildUuid(self, bUuid)
  local tempBuild = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if tempBuild ~= nil then
    local resourceType = self:GetOutResourceTypeByBuildId(tempBuild.itemId)
    return resourceType
  end
end

local function PushBuildingInfoHandle(self, message)
  if message.buildingInfo ~= nil then
    self:HandleBuildingInfos(message.buildingInfo)
    if message.buildingInfo[1] then
      local data = message.buildingInfo[1]
      if data.bId == BuildingTypes.APS_BUILD_WORMHOLE_SUB and data.lv == 0 then
        local signal = SFSObject.New()
        signal:PutLong("bUuid", data.uuid)
        EventManager:GetInstance():Broadcast(EventId.CreatWormholeBuild, signal)
      elseif data.bId == BuildingTypes.LW_BUILD_HERO then
        local hero_build_info = {
          pId = data.pId,
          bId = data.bId,
          prodStatus = data.prodStatus,
          uuid = data.uuid
        }
        DataCenter.BuildHeroManager:AddBuildHero(hero_build_info, true)
        DataCenter.BuildHeroManager:RemoveHeroFromDropList(hero_build_info.prodStatus)
      else
        local data = self:GetBuildingDataByUuid(data.uuid)
        if data:GetIsDecorate() then
          EventManager:GetInstance():Broadcast(EventId.AddDecorate, data)
        end
      end
    end
  end
end

local function PushAddBuildingHandle(self, message)
  if message.buildings ~= nil then
    self:HandleBuildingInfos(message.buildings)
  end
end

local function HandleBuildingInfos(self, infos)
  for _, dic in pairs(infos) do
    local bUuid = dic.uuid
    local connect = 1
    if dic.connect ~= nil then
      connect = dic.connect
    end
    self:AddBuilding(dic)
    if oldBuild == nil then
      self:CheckGetNewBuildSendMessage(dic.bId, dic.lv, bUuid)
    end
    DataCenter.BuildBubbleManager:NoRefreshTimerCallBack(bUuid)
    EventManager:GetInstance():Broadcast(EventId.UPDATE_BUILD_DATA, bUuid)
  end
end

local function GetOutResourceTypeByBuildId(self, buildId)
  if buildId == BuildingTypes.FUN_BUILD_WATER then
    return ResourceType.Water
  elseif buildId == BuildingTypes.FUN_BUILD_STONE then
    return ResourceType.Metal
  elseif buildId == BuildingTypes.FUN_BUILD_OIL then
    return ResourceType.Oil
  elseif buildId == BuildingTypes.FUN_BUILD_WIND_TURBINE or buildId == BuildingTypes.FUN_BUILD_SOLAR_POWER_STATION or buildId == BuildingTypes.FUN_BUILD_ELECTRICITY or buildId == BuildingTypes.FUN_BUILD_ELECTRICITY_STORAGE then
    return ResourceType.Electricity
  elseif buildId == BuildingTypes.FUN_BUILD_CONDOMINIUM or buildId == BuildingTypes.FUN_BUILD_VILLA or buildId == BuildingTypes.FUN_BUILD_GROCERY_STORE then
    return ResourceType.Food
  elseif buildId == BuildingTypes.APS_BUILD_PUB then
    return ResourceType.MedalOfWisdom
  elseif buildId == BuildingTypes.FUN_BUILD_HERO_BAR then
    return ResourceType.FORMATION_STAMINA
  elseif buildId == BuildingTypes.FUN_BUILD_OUT_WOOD then
    return ResourceType.ResourceItem
  elseif buildId == BuildingTypes.FUN_BUILD_OUT_STONE then
    return ResourceType.ResourceItem
  end
  return ResourceType.None
end

local function GetBuildTypesByOutResourceType(self, resourceType, itemId)
  if resourceType == ResourceType.ResourceItem then
    local list = self:GetProductResItemBuildingTypes()
    if list ~= nil then
      local result = {}
      if itemId == nil then
      end
      local strItemId = tostring(itemId)
      for k, v in ipairs(list) do
        local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(v)
        if buildTemplate ~= nil and strItemId == buildTemplate.para4 then
          table.insert(result, v)
        end
      end
      return result
    end
  else
    return DataCenter.ResourceManager:GetResourceOutBuildings(resourceType)
  end
end

local function GetUseResourceTypeByBuildId(self, buildId)
  if buildId == BuildingTypes.FUN_BUILD_ELECTRICITY then
    return ResourceType.Electricity
  end
  return ResourceType.None
end

local function UserResupplyBuildingHandle(self, message)
  if message.errorCode == nil then
    local bUuid = message.uuid
    self:AddBuilding(message)
    EventManager:GetInstance():Broadcast(EventId.UPDATE_BUILD_DATA, bUuid)
    if message.resource ~= nil then
      LuaEntry.Resource:UpdateResource(message.resource)
    end
  else
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
  end
end

local function UserResSynNewHandle(self, message)
  if message.errorCode == nil then
    EventManager:GetInstance():Broadcast(EventId.DelayRefreshResource, 1)
    LuaEntry.Resource:UpdateResource(message)
    EventManager:GetInstance():Broadcast(EventId.UserResSynNew)
  else
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
  end
end

local function ShowGetNewResourceEffect(self, param)
  if param.resourceType ~= ResourceType.None then
    if param.resourceType == ResourceType.GreenCrystal or param.resourceType == ResourceType.MedalOfWisdom then
      local num = DataCenter.BuildManager:GetOutResourceNum(param.uuid)
      if 0 < num then
        local pos = CS.SceneManager.World:WorldToScreenPoint(DataCenter.BuildBubbleManager:GetBubblePosition(param.uuid))
        local rewardTyp = RewardType.GOODS
        local showNum = num > ShowGreenMaxNum and ShowGreenMaxNum or num
        UIUtil.DoFly(tonumber(rewardTyp), showNum, param.iconName, pos, Vector3.New(0, 0, 0))
        local buildingDate = self:GetBuildingDataByUuid(param.uuid)
        if buildingDate ~= nil then
          local worldPos = SceneUtils.TileIndexToWorld(buildingDate.pointId)
          worldPos.x = worldPos.x - FlyGetResourceDelta.x
          worldPos.y = worldPos.y - FlyGetResourceDelta.y
          worldPos.z = worldPos.z - FlyGetResourceDelta.z
          DataCenter.DecResourceEffectManager:DecOneItemEffect(worldPos, param.iconName, num, param.uuid)
        end
        local resourceType = param.resourceType
        SFSNetwork.SendMessage(MsgDefines.UserResSynNew, {resourceType = resourceType})
      end
    elseif param.resourceType == ResourceType.ResourceItem then
      local buildIds = self:GetBuildTypesByOutResourceType(param.resourceType, param.itemId)
      if buildIds ~= nil then
        local isSend = false
        local allNum = 0
        local getNum = 0
        local storageLeftNum = DataCenter.ResourceItemDataManager:GetLeftStorageNum()
        for k1, v1 in ipairs(buildIds) do
          local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(v1)
          for k, v in pairs(list) do
            local uuid = v.uuid
            local num = DataCenter.BuildManager:GetOutResourceNum(uuid)
            if 0 < num then
              if 0 < storageLeftNum then
                local trueGetNum = 0
                if storageLeftNum >= num then
                  trueGetNum = num
                else
                  trueGetNum = storageLeftNum
                end
                storageLeftNum = storageLeftNum - trueGetNum
                getNum = getNum + trueGetNum
                local pos = CS.SceneManager.World:WorldToScreenPoint(DataCenter.BuildBubbleManager:GetBubblePosition(param.uuid))
                local rewardTyp = RewardType.RESOURCE_ITEM
                local showNum = trueGetNum > ShowGreenMaxNum and ShowGreenMaxNum or trueGetNum
                UIUtil.DoFly(tonumber(rewardTyp), showNum, param.iconName, pos, Vector3.New(0, 0, 0))
                EventManager:GetInstance():Broadcast(EventId.ShowCapacity)
                local buildingDate = self:GetBuildingDataByUuid(param.uuid)
                if buildingDate ~= nil then
                  local worldPos = SceneUtils.TileIndexToWorld(buildingDate.pointId)
                  worldPos.x = worldPos.x - FlyGetResourceDelta.x
                  worldPos.y = worldPos.y - FlyGetResourceDelta.y
                  worldPos.z = worldPos.z - FlyGetResourceDelta.z
                  DataCenter.DecResourceEffectManager:DecOneItemEffect(worldPos, param.iconName, trueGetNum, param.uuid)
                  isSend = true
                end
              end
              allNum = allNum + num
            end
          end
        end
        if isSend then
          local resourceType = param.resourceType
          SFSNetwork.SendMessage(MsgDefines.UserResSynNew, {
            resourceType = resourceType,
            itemId = param.itemId
          })
        end
        if 0 < allNum then
          if getNum == 0 then
            UIUtil.ShowTipsId(GameDialogDefine.NO_GET_RESOURCE_ITEM_CASE_STORAGE_NO)
            GoToUtil.GotoOpenView(UIWindowNames.UICapacityFull)
          elseif getNum < allNum then
            local resourceName = DataCenter.ResourceItemDataManager:GetName(param.itemId)
            UIUtil.ShowTips(Localization:GetString(GameDialogDefine.STORAGE_NO_BUT_GET, getNum, resourceName))
            GoToUtil.GotoOpenView(UIWindowNames.UICapacityFull)
          end
        end
      end
    else
      local buildIds = self:GetBuildTypesByOutResourceType(param.resourceType)
      if param.resourceType == ResourceType.Water then
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Water, false)
      elseif param.resourceType == ResourceType.Electricity then
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Electric, false)
      elseif param.resourceType == ResourceType.Food then
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Coin, false)
      elseif param.resourceType == ResourceType.Metal then
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Collect_Crystal, false)
      elseif param.resourceType == ResourceType.Oil then
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Gas, false)
      elseif param.resourceType == ResourceType.FORMATION_STAMINA then
        local maxNum = 100
        local config = DataCenter.ArmyFormationDataManager:GetConfigData()
        if config ~= nil then
          maxNum = config.FormationStaminaMax
        end
        local curNum = LuaEntry.Player:GetCurStamina()
        if maxNum <= curNum then
          UIUtil.ShowTipsId(143603)
          return
        end
      end
      if buildIds ~= nil then
        local isSend = false
        for k1, v1 in ipairs(buildIds) do
          local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(v1)
          for k, v in pairs(list) do
            local uuid = v.uuid
            if v.state ~= BuildingStateType.FoldUp then
              local num = DataCenter.BuildManager:GetOutResourceNum(uuid)
              if 0 < num then
                local worldPos = SceneUtils.TileIndexToWorld(v.pointId)
                worldPos.x = worldPos.x - FlyGetResourceDelta.x
                worldPos.y = worldPos.y - FlyGetResourceDelta.y
                worldPos.z = worldPos.z - FlyGetResourceDelta.z
                DataCenter.DecResourceEffectManager:DecOneItemEffect(worldPos, DataCenter.ResourceManager:GetResourceIconByType(param.resourceType), num, uuid)
                self:ShowPickUpResourceEffect(uuid, param.resourceType, worldPos)
                isSend = true
              end
            end
          end
        end
        if isSend then
          local resourceType = param.resourceType
          SFSNetwork.SendMessage(MsgDefines.UserResSynNew, {resourceType = resourceType})
        end
      end
    end
  end
end

local function ShowPickUpResourceEffect(self, buildUuid, resourceType, worldPos)
  local budingData = DataCenter.BuildManager:GetBuildingDataByUuid(buildUuid)
  local percent = budingData:GetResourcePercent()
  local effectPath = ""
  if percent <= 0.05 then
    effectPath = self:GetPickResPath(resourceType, PickResEffectLevel.Low)
  elseif 0.05 < percent and percent <= 0.25 then
    effectPath = self:GetPickResPath(resourceType, PickResEffectLevel.Middle)
  else
    effectPath = self:GetPickResPath(resourceType, PickResEffectLevel.High)
  end
  if effectPath == "" then
    return
  end
  if 0 <= percent then
    local posX = worldPos.x
    local posY = 3
    local posZ = worldPos.z
    self.pickEffect[buildUuid] = ResourceManager:InstantiateAsync(effectPath)
    self.pickEffect[buildUuid]:completed("+", function()
      if self.pickEffect[buildUuid].isError then
        return
      end
      self.pickEffect[buildUuid].gameObject:SetActive(true)
      self.pickEffect[buildUuid].gameObject.transform:Set_localScale(1, 1, 1)
      self.pickEffect[buildUuid].gameObject.transform:Set_position(posX, posY, posZ)
      TimerManager:GetInstance():DelayInvoke(function()
        if self.pickEffect[buildUuid] then
          self.pickEffect[buildUuid]:Destroy()
          self.pickEffect[buildUuid] = nil
        end
      end, 2)
    end)
    EventManager:GetInstance():Broadcast(EventId.RefreshTopResByPickUp, resourceType)
  end
end

local function ShowSpeedUpWorker(tf)
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_WORKER_HOUSE)
  local workerDataList = buildData:GetWorkerList()
  local sprite, obj
  for i = 1, 4 do
    obj = tf:Find("num/worker_list/worker" .. i)
    if #workerDataList <= 4 and workerDataList[i] then
      if obj then
        obj.gameObject:SetActive(true)
        sprite = obj:GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
        local icon = WorkerUtil.GetWorkerIconPath(workerDataList[i].modelId)
        UIUtil.LoadSpriteRenderAuto(sprite, icon)
      end
    else
      obj.gameObject:SetActive(false)
    end
  end
end

function BuildManager:ShowBuildSpeedUpState(uuid, startTime, endTime)
  local reduceTime = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_BUILDSPEEDUP_WORKER) * 1000
  local isCompleteImmediately = reduceTime >= endTime - startTime
  local isExistSpeedUpBuilding = DataCenter.ExchangeSpecialManager:IsExistSpeedUpBuilding(ItemSpdMenu.ItemSpdMenu_City)
  local isShowPyramid = isExistSpeedUpBuilding
  if isShowPyramid then
    self:ClearOverDelayPyramidTimer()
    local list = DataCenter.ExchangeSpecialManager:GetEffectTemplateList(ItemSpdMenu.ItemSpdMenu_City)
    for _, template in pairs(list) do
      if tonumber(template.decoration_id) == BuildingTypes.LW_BUILD_DECORATION_PYRAMID then
        local pyramidData = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(tonumber(template.decoration_id), true)
        self:ShowUpPyramidEffect(uuid, pyramidData)
      end
    end
    local delay = TimerManager:GetInstance():DelayInvoke(function()
      self:ShowPyramidSpeedUpTips(uuid)
    end, self.pyramidSpeedUpTipsShowDelay)
    table.insert(self.delayPyramidList, delay)
    delay = TimerManager:GetInstance():DelayInvoke(function()
      self:ShowBuildSpeedUpTips(uuid)
    end, self.normalSpeedUpTipsShowDelay)
    table.insert(self.delayPyramidList, delay)
  else
    self:ShowBuildSpeedUpTips(uuid)
  end
end

function BuildManager:IsShowPyramidEffectThisServer(showServerList)
  local curServerId = LuaEntry.Player:GetSourceServerId() or 0
  local isShowInServer = false
  for i = 1, #showServerList do
    local serverIdList = string.split(showServerList[i], "-")
    if 2 <= #serverIdList then
      local serverId1 = tonumber(serverIdList[1])
      local serverId2 = tonumber(serverIdList[2])
      if curServerId >= serverId1 and curServerId <= serverId2 then
        isShowInServer = true
        break
      end
    else
      local serverId = tonumber(serverIdList[1])
      if serverId == curServerId then
        isShowInServer = true
        break
      end
    end
  end
  return isShowInServer
end

function BuildManager:ShowUpPyramidEffect(uuid, buildData)
  if buildData == nil then
    return
  end
  local buildDesTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildData.itemId)
  local pos = BuildingUtils.GetBuildModelDownVec(buildData.pointId, 0, buildDesTemplate.tileY)
  local blankUpEffectIndex = 0
  for i = 1, #self.pyramidUpEffecIsUsingList do
    if self.pyramidUpEffecIsUsingList[i] == false then
      blankUpEffectIndex = i
      break
    end
  end
  if blankUpEffectIndex == 0 then
    local upEffectReq = ResourceManager:InstantiateAsync(PyramidSpeedUpEffectPath.Up)
    upEffectReq:completed("+", function(req)
      if req.isError then
        return
      end
      local tf = req.gameObject.transform
      tf.position = pos + Vector3.New(-2, 0.1, 4)
      req.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
      local delay = TimerManager:GetInstance():DelayInvoke(function()
        self.pyramidUpEffecIsUsingList[blankUpEffectIndex] = false
        self:ShowPyramidDownEffect(uuid)
      end, self.pyramidUpEffectInternal)
      table.insert(self.delayPyramidList, delay)
      DataCenter.LWSoundManager:PlaySound(90120, false)
    end)
    table.insert(self.pyramidUpEffectReqList, upEffectReq)
    blankUpEffectIndex = #self.pyramidUpEffectReqList
    self.pyramidUpEffecIsUsingList[blankUpEffectIndex] = true
  else
    local blankUpEffectReq = self.pyramidUpEffectReqList[blankUpEffectIndex]
    if not blankUpEffectReq.isDone then
      Logger.LogError("\233\135\145\229\173\151\229\161\148Up\231\137\185\230\149\136\231\154\132Req\229\173\152\229\156\168\239\188\140\228\189\134\230\152\175\230\156\170\229\138\160\232\189\189\229\174\140\239\188\129 \228\184\141\231\167\145\229\173\166\239\188\129\230\163\128\230\159\165\239\188\129")
      return
    end
    if IsNull(blankUpEffectReq.gameObject) then
      Logger.LogError("\233\135\145\229\173\151\229\161\148Up\231\137\185\230\149\136\231\154\132Req\229\173\152\229\156\168\239\188\140\228\189\134\230\152\175gameObject\228\184\141\229\173\152\229\156\168\239\188\129")
      return
    end
    self.pyramidUpEffecIsUsingList[blankUpEffectIndex] = true
    blankUpEffectReq.gameObject:SetActive(false)
    blankUpEffectReq.gameObject:SetActive(true)
    blankUpEffectReq.gameObject.transform.position = pos + Vector3.New(-2, 0.1, 4)
    blankUpEffectReq.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
    local delay = TimerManager:GetInstance():DelayInvoke(function()
      self.pyramidUpEffecIsUsingList[blankUpEffectIndex] = false
      self:ShowPyramidDownEffect(uuid)
    end, self.pyramidUpEffectInternal)
    table.insert(self.delayPyramidList, delay)
    DataCenter.LWSoundManager:PlaySound(90120, false)
  end
end

function BuildManager:ShowPyramidDownEffect(uuid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
  local buildDesTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildData.itemId)
  local pos = BuildingUtils.GetBuildModelCenterVec(buildData.pointId, buildDesTemplate.tileX, buildDesTemplate.tileY)
  local blankDownEffectIndex = 0
  for i = 1, #self.pyramidDownEffecIsUsingList do
    if self.pyramidDownEffecIsUsingList[i] == false then
      blankDownEffectIndex = i
      break
    end
  end
  if blankDownEffectIndex == 0 then
    local downEffectReq = ResourceManager:InstantiateAsync(PyramidSpeedUpEffectPath.Down)
    downEffectReq:completed("+", function(req)
      if req.isError then
        return
      end
      local tf = req.gameObject.transform
      tf.position = pos
      req.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
      local delay = TimerManager:GetInstance():DelayInvoke(function()
        self.pyramidDownEffecIsUsingList[blankDownEffectIndex] = false
      end, self.pyramidDownEffectInternal)
      table.insert(self.delayPyramidList, delay)
    end)
    table.insert(self.pyramidDownEffectReqList, downEffectReq)
    blankDownEffectIndex = #self.pyramidDownEffectReqList
    self.pyramidDownEffecIsUsingList[blankDownEffectIndex] = true
  else
    local blankDownEffectReq = self.pyramidDownEffectReqList[blankDownEffectIndex]
    if not blankDownEffectReq.isDone then
      Logger.LogError("\233\135\145\229\173\151\229\161\148Down\231\137\185\230\149\136\231\154\132Req\229\173\152\229\156\168\239\188\140\228\189\134\230\152\175\230\156\170\229\138\160\232\189\189\229\174\140\239\188\129 \228\184\141\231\167\145\229\173\166\239\188\129\230\163\128\230\159\165\239\188\129")
      return
    end
    if IsNull(blankDownEffectReq.gameObject) then
      Logger.LogError("\233\135\145\229\173\151\229\161\148Down\231\137\185\230\149\136\231\154\132Req\229\173\152\229\156\168\239\188\140\228\189\134\230\152\175gameObject\228\184\141\229\173\152\229\156\168\239\188\129")
      return
    end
    self.pyramidDownEffecIsUsingList[blankDownEffectIndex] = true
    blankDownEffectReq.gameObject:SetActive(false)
    blankDownEffectReq.gameObject:SetActive(true)
    blankDownEffectReq.gameObject.transform.position = pos
    blankDownEffectReq.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
    local delay = TimerManager:GetInstance():DelayInvoke(function()
      self.pyramidDownEffecIsUsingList[blankDownEffectIndex] = false
    end, self.pyramidDownEffectInternal)
    table.insert(self.delayPyramidList, delay)
  end
end

function BuildManager:ClearOverDelayPyramidTimer()
  if self.delayPyramidList then
    for i, delay in pairs(self.delayPyramidList) do
      if self.delayPyramidList[i]:IsOver() then
        self.delayPyramidList[i]:Stop()
        table.remove(self.delayPyramidList, i)
      end
    end
  end
end

function BuildManager:ClearPyramidData()
  if self.delayPyramidList then
    for i, delay in pairs(self.delayPyramidList) do
      if self.delayPyramidList[i] then
        self.delayPyramidList[i]:Stop()
        self.delayPyramidList[i] = nil
      end
    end
    self.delayPyramidList = {}
  end
  if self.pyramidUpEffectReqList then
    for i, v in pairs(self.pyramidUpEffectReqList) do
      v:Destroy()
      self.pyramidUpEffectReqList[i] = nil
    end
    self.pyramidUpEffectReqList = {}
  end
  if self.pyramidDownEffectReqList then
    for i, v in pairs(self.pyramidDownEffectReqList) do
      v:Destroy()
      self.pyramidDownEffectReqList[i] = nil
    end
    self.pyramidDownEffectReqList = {}
  end
  self.pyramidUpEffecIsUsingList = {}
  self.pyramidDownEffecIsUsingList = {}
end

function BuildManager:BeforeReleaseCity()
  DataCenter.BuildManager:ClearPyramidData()
end

function BuildManager:ShowPyramidSpeedUpTips(uuid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
  local buildDesTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildData.itemId)
  local pos = BuildingUtils.GetBuildModelDownVec(buildData.pointId, 0, buildDesTemplate.tileY)
  local buildCurLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level)
  if buildCurLevelTemplate == nil then
    return
  end
  local reduceTime = DataCenter.ExchangeSpecialManager:GetBuildingReduceTimeByUuid(uuid)
  local list = DataCenter.ExchangeSpecialManager:GetEffectTemplateList(ItemSpdMenu.ItemSpdMenu_City)
  local effReq = ResourceManager:InstantiateAsync("Assets/Main/Prefabs/PyramidSpeedUp/BuildSpeedUpPyramid.prefab")
  effReq:completed("+", function(req)
    if req.isError then
      return
    end
    local tf = req.gameObject.transform
    local text = tf:Find("num"):GetComponent(typeof(CS.SuperTextMesh))
    tf.position = pos + Vector3.New(-2, 1, 0)
    text.text = "-" .. UITimeManager:GetInstance():MilliSecondToFmtString(reduceTime)
    for i = 1, 3 do
      local imgGo = tf:Find("num/ImgContainer/PyramidImg" .. i)
      if imgGo then
        local spriteRenderer = imgGo:GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
        local template = list[i]
        if template then
          spriteRenderer.gameObject:SetActive(true)
          spriteRenderer:LoadSpriteAsync(template.building_banner_icon)
        else
          spriteRenderer.gameObject:SetActive(false)
        end
      end
    end
    self.delayIndex = self.delayIndex + 1
    local index = uuid + self.delayIndex
    local delay = TimerManager:GetInstance():DelayInvoke(function()
      if self.delayDic and self.delayDic[index] then
        self.delayDic[index]:Stop()
        self.delayDic[index] = nil
      end
      if req ~= nil then
        req:Destroy()
      end
    end, self.pyramidSpeedUpTipsDuringTime)
    self.delayDic[index] = delay
  end)
end

function BuildManager:GetShowBuildSpeedUpTime(uuid)
  local all = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_BUILDSPEEDUP_WORKER) * 1000
  local list = DataCenter.ExchangeSpecialManager:GetEffectTemplateList(ItemSpdMenu.ItemSpdMenu_City)
  for _, template in pairs(list) do
    if tonumber(template.effectId) == EffectDefine.LW_BUILDSPEEDUP_WORKER then
      local reduceTime = DataCenter.ExchangeSpecialManager:GetReduceTime(template, uuid)
      all = all - reduceTime
    end
  end
  return all
end

local function ShowBuildSpeedUpTips(self, uuid)
  local speedTime = self:GetShowBuildSpeedUpTime(uuid)
  if speedTime <= 0 then
    return
  end
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
  local buildDesTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildData.itemId)
  local pos = BuildingUtils.GetBuildModelDownVec(buildData.pointId, 0, buildDesTemplate.tileY)
  local effReq = ResourceManager:InstantiateAsync("Assets/Main/Prefabs/CityScene/BuildSpeedUp.prefab")
  effReq:completed("+", function(req)
    if req.isError then
      return
    end
    local tf = req.gameObject.transform
    local text = tf:Find("num"):GetComponent(typeof(CS.SuperTextMesh))
    tf.position = pos + Vector3.New(-2, 1, 0)
    text.text = "-" .. UITimeManager:GetInstance():MilliSecondToFmtString(speedTime)
    ShowSpeedUpWorker(tf)
    self.delayIndex = self.delayIndex + 1
    local index = uuid + self.delayIndex
    local delay = TimerManager:GetInstance():DelayInvoke(function()
      if self.delayDic and self.delayDic[index] then
        self.delayDic[index]:Stop()
        self.delayDic[index] = nil
      end
      if req ~= nil then
        req:Destroy()
      end
    end, self.normalSpeedUpTipsDuringTime)
    self.delayDic[index] = delay
  end)
end

local function GetPickResPath(self, resourceType, type)
  if resourceType == ResourceType.Water then
    return WaterPickEffect[type]
  elseif resourceType == ResourceType.Electricity then
    return ElectricityPickEffect[type]
  elseif resourceType == ResourceType.Oil then
    return OilPickEffect[type]
  elseif resourceType == ResourceType.Food then
    return MoneyPickEffect[type]
  elseif resourceType == ResourceType.Metal then
    return CrystalPickEffect[type]
  elseif resourceType == ResourceType.FORMATION_STAMINA then
    return StaminaPickEffect[type]
  else
    return ""
  end
end

local function ShowGetResourceEffect(self, resourceType)
  if resourceType ~= ResourceType.None then
    local buildIds = DataCenter.ResourceManager:GetResourceOutBuildings(resourceType)
    if buildIds ~= nil then
      for k1, v1 in ipairs(buildIds) do
        local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(v1)
        for k, v in pairs(list) do
          local uuid = v.uuid
          if v.state == BuildingStateType.Normal then
            local num = DataCenter.BuildManager:GetOutResourceNum(uuid)
            if 0 < num then
              local worldPos = SceneUtils.TileIndexToWorld(v.pointId)
              local pos = CS.SceneManager.World:WorldToScreenPoint(worldPos)
              DataCenter.FlyResourceEffectManager:ShowGetResourceEffect(pos, resourceType, FlyMoneyCount)
              DataCenter.DecResourceEffectManager:DecOneItemEffect(worldPos + FlyGetResourceDelta, DataCenter.ResourceManager:GetResourceIconByType(resourceType), num, uuid)
            end
          end
        end
      end
    end
  end
end

local function isReachMax(self, bUuid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildData ~= nil and buildData.updateTime > 0 then
    local level = buildData.level
    local buildId = buildData.itemId
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
    if buildTemplate ~= nil and level >= buildTemplate.max_level then
      return true
    end
  end
  return false
end

function BuildManager:DelayWorldMoveHandle(message, zoom, delay)
  if self.delayMoveTimer then
    self.delayMoveTimer:Stop()
    self.delayMoveTimer = nil
  end
  if delay and 0 < delay then
    self.delayMoveTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:WorldMvHandle(message, zoom)
    end, delay)
  else
    self:WorldMvHandle(message, zoom)
  end
end

local function WorldMvHandle(self, message, zoom)
  if self.delayMoveTimer then
    self.delayMoveTimer:Stop()
    self.delayMoveTimer = nil
  end
  if message.errorCode == nil then
    local serverId = message.serverId
    local worldId = message.worldId
    local arrays = message.itemCostArr
    if arrays ~= nil then
      for k, v in pairs(arrays) do
        DataCenter.ItemData:UpdateOneItem(v)
      end
    end
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshItems)
    if message.worldMainPoint ~= nil then
      LuaEntry.Player:SetMainWorldPointId(message.worldMainPoint)
    end
    if message.buildInfo and message.buildInfo.pId then
      LuaEntry.Player:SetMainWorldPointId(message.buildInfo.pId)
    end
    DataCenter.BoardManager:InitData(message)
    local isInSeason = SeasonUtil.IsInSeason(true)
    local seasonType = SeasonUtil.GetSeasonType()
    local reason = message.reason
    local isPlayEffect = reason ~= "RADAR_DETECT" and reason ~= "V1_GOLD_ALLIANCE_CREATE" and reason ~= "WORLD_DETECT"
    if CS.SceneManager.World ~= nil then
      CS.SceneManager.World:OnMainBuildMove()
    end
    do
      local mainWorldPos = LuaEntry.Player:GetMainWorldPos()
      if isPlayEffect and 0 < mainWorldPos and CS.SceneManager.World ~= nil then
        local epidemicSkillPlaying = 0 < DataCenter.ActEpidemicZoneManager:GetSkillActiveEndTime()
        if not epidemicSkillPlaying then
          local data = LuaEntry.Player:GetUid() .. ";" .. mainWorldPos .. ";" .. 0
          EventManager:GetInstance():Broadcast(EventId.ShowDomeShowEffect, data)
        end
        local worldPos = SceneUtils.TileIndexToWorld(mainWorldPos, ForceChangeScene.World)
        EventManager:GetInstance():Broadcast(EventId.MoveCitySuccess)
        if BattleFieldUtil.InBattleField() then
          GoToUtil.GotoDragonPos(worldPos, CS.SceneManager.World.InitZoom, 0.02, function()
            CS.SceneManager.World:UpdateViewRequest(true)
          end, LuaEntry.Player:GetCrossServerId(), LuaEntry.Player:GetCurWorldId())
        else
          GoToUtil.GotoWorldPos(worldPos, zoom or CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
            if LuaEntry.Player:IsInBlackRange() or LuaEntry.Player:IsInCityField() then
              DataCenter.ActWinterStormManager:TryCancelMatch(WinterStormCancelType.MvBlackRange)
            end
            if reason == "MeteoriteDestroyAll" then
              DataCenter.ActMeteoriteBattleManager:SignMeteoriteDestroyAll()
            end
          end, serverId or LuaEntry.Player:GetSelfServerId())
        end
      end
    end
    if seasonType ~= SeasonMapType.Nothing and seasonType ~= SeasonMapType.Desert then
      SFSNetwork.SendMessage(MsgDefines.GetCityAttachmentEffectInfo)
    end
    EventManager:GetInstance():Broadcast(EventId.BuildMainZeroUpgradeSuccess)
    DataCenter.GuideManager:SetCanShowBuild(true)
    DataCenter.RoadBubbleManager:CheckAllCollect()
    if LuaEntry.Player:GetCurWorldId() == 0 and isInSeason and seasonType ~= SeasonMapType.CityStronghold and seasonType ~= SeasonMapType.Desert then
      DataCenter.AllianceSkillManager:RequestWorldEffectAlter()
    end
  else
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
  end
  EventManager:GetInstance():Broadcast(EventId.SetMovingUI, UIMovingType.Close)
  TimerManager:GetInstance():DelayInvoke(function()
    EventManager:GetInstance():Broadcast(EventId.MoveCityPostProcess)
  end, 3)
end

local function ReceiveBuildingGrowValRewardHandle(self, message)
  if message.errorCode == nil then
    if message.reward ~= nil then
      DataCenter.RewardManager:ShowCommonReward(message)
      DataCenter.RewardManager:AddRewardsAndRes(message)
    end
    if message.uuid ~= nil then
      DataCenter.BuildGetItemAfterShowTalkManager:ShowOneTalk(message.uuid)
    end
  else
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    DataCenter.BuildGetItemAfterShowTalkManager:RemoveWillShowTalkUuid()
  end
end

local function IsCanOutItemByBuildId(self, buildId)
  if buildId == BuildingTypes.FUN_BUILD_CONDOMINIUM or buildId == BuildingTypes.FUN_BUILD_VILLA then
    return true
  end
  return false
end

local function IsHaveResource(self, uuid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
  if buildData ~= nil then
    local outResource = self:GetOutResourceTypeByBuildId(buildData.itemId)
    if outResource ~= ResourceType.None then
      local produceEndTime = buildData.produceEndTime
      local unavailableTime = buildData.unavailableTime
      local lastCollectTime = buildData.lastCollectTime
      if 0 < produceEndTime then
        if produceEndTime > unavailableTime then
          if 0 < unavailableTime then
            return unavailableTime > lastCollectTime
          else
            return produceEndTime > lastCollectTime
          end
        end
      elseif 0 < unavailableTime then
        return unavailableTime > lastCollectTime
      end
    end
  end
  return false
end

local function IsHaveItem(self, uuid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
  if buildData ~= nil then
    local buildId = buildData.itemId
    local level = buildData.level
    local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
    if levelTemplate ~= nil then
      local time = UITimeManager:GetInstance():GetServerTime()
      local growValStartTime = buildData.growValStartTime
      local unavailableTime = buildData.unavailableTime
      if 0 < unavailableTime then
        time = unavailableTime
      end
      return (time - growValStartTime) * levelTemplate:GetOutItemSpeed() / 1000 > levelTemplate:GetOutItemNeedValue()
    end
  end
  return false
end

local function GetShowBubbleTime(self, uuid, percent)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
  if buildData ~= nil then
    local buildId = buildData.itemId
    local level = buildData.level
    local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
    if levelTemplate ~= nil then
      local outSpeed = levelTemplate:GetCollectSpeed() / 1000
      if 0 < outSpeed then
        local lastCollectTime = buildData.lastCollectTime
        local produceEndTime = buildData.produceEndTime
        local unavailableTime = buildData.unavailableTime
        if percent == nil then
          percent = levelTemplate:GetShowBubblePercent()
        end
        local needTime = math.max(levelTemplate:GetCollectMax() * percent, 1) / outSpeed
        local time = math.ceil(needTime)
        local willTime = lastCollectTime + time
        if 0 < produceEndTime then
          if lastCollectTime >= produceEndTime then
            return 0
          end
          if produceEndTime > unavailableTime then
            if 0 < unavailableTime then
              if unavailableTime >= willTime then
                return willTime
              else
                return 0
              end
            end
          elseif produceEndTime >= willTime then
            return willTime
          else
            return 0
          end
        elseif 0 < unavailableTime then
          if unavailableTime >= willTime then
            return willTime
          else
            return 0
          end
        end
        return willTime
      end
    end
  end
  return 0
end

local function GetShowItemBubbleTime(self, uuid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
  if buildData ~= nil then
    local buildId = buildData.itemId
    local level = buildData.level
    local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
    local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
    if levelTemplate ~= nil and template ~= nil then
      local outSpeed = levelTemplate:GetOutItemSpeed() / 1000
      if 0 < outSpeed then
        local growValStartTime = buildData.growValStartTime
        local unavailableTime = buildData.unavailableTime
        local needTime = levelTemplate:GetOutItemNeedValue() / outSpeed
        local time = math.ceil(needTime)
        local willTime = growValStartTime + time
        if 0 < unavailableTime then
          if unavailableTime >= willTime then
            return willTime
          else
            return 0
          end
        end
        return willTime
      end
    end
  end
  return 0
end

local function GetOutResourceNum(self, uuid)
  if DataCenter.BuildManager:IsHaveResource(uuid) then
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
    if buildData ~= nil then
      local buildId = buildData.itemId
      local level = buildData.level
      local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
      if levelTemplate ~= nil then
        local outSpeed = levelTemplate:GetCollectSpeed() / 1000
        if 0 < outSpeed then
          local lastCollectTime = buildData.lastCollectTime
          local produceEndTime = buildData.produceEndTime
          local unavailableTime = buildData.unavailableTime
          local result = 0
          local now = UITimeManager:GetInstance():GetServerTime()
          if 0 < unavailableTime and unavailableTime < now then
            now = unavailableTime
          end
          if 0 < produceEndTime and produceEndTime < now then
            now = produceEndTime
          end
          local count = (now - lastCollectTime) * outSpeed
          local max = levelTemplate:GetCollectMax()
          if count > max then
            count = max
          end
          if buildId == BuildingTypes.FUN_BUILD_CONDOMINIUM or buildId == BuildingTypes.FUN_BUILD_GROCERY_STORE then
            count = DataCenter.HeroStationManager:CalcEffectedValue(count, HeroStationEffectType.GlobalMoney)
            count = Mathf.Round(count)
          end
          result = Mathf.Round(count)
          return result
        end
      end
    end
  end
  return 0
end

local function GetCollectMaxEffectByBuildId(self, buildId)
  if buildId == BuildingTypes.FUN_BUILD_WATER then
    return EffectDefine.WATER_CAPACITY_ADD
  elseif buildId == BuildingTypes.FUN_BUILD_STONE then
    return EffectDefine.METAL_CAPACITY_ADD
  elseif buildId == BuildingTypes.FUN_BUILD_OIL then
    return EffectDefine.GAS_CAPACITY_ADD
  end
end

local function GetReduceFactoryTimeEffectByBuildId(self, buildId)
  if buildId == BuildingTypes.FUN_BUILD_PRINT_FACTORY then
    return EffectDefine.PRINT_FACTORY_OUT_SPEED_ADD
  elseif buildId == BuildingTypes.FUN_BUILD_METALLURGY then
    return EffectDefine.METALLURGY_FACTORY_OUT_SPEED_ADD
  elseif buildId == BuildingTypes.FUN_BUILD_OIL_REFINERY then
    return EffectDefine.CHEMISTRY_FACTORY_OUT_SPEED_ADD
  end
end

local function GetWorldTileBtnTypeByBuildId(self, buildId)
  if buildId == BuildingTypes.FUN_BUILD_CAR_BARRACK then
    return WorldTileBtnType.City_TrainingTank
  elseif buildId == BuildingTypes.FUN_BUILD_INFANTRY_BARRACK then
    return WorldTileBtnType.City_TrainingInfantry
  elseif buildId == BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK then
    return WorldTileBtnType.City_TrainingAircraft
  elseif DataCenter.BuildManager:IsFactoryBuild(buildId) then
    return WorldTileBtnType.City_Product
  end
end

local function GetCanGetResourceBuildUuidByResourceType(self, resourceType)
  local result
  if resourceType ~= ResourceType.None then
    local buildIds = DataCenter.ResourceManager:GetResourceOutBuildings(resourceType)
    if buildIds ~= nil then
      local lists = {}
      for k1, v1 in ipairs(buildIds) do
        local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(v1)
        for k, v in pairs(list) do
          local param = {}
          param.uuid = v.uuid
          param.num = DataCenter.BuildManager:GetOutResourceNum(param.uuid)
          table.insert(lists, param)
        end
      end
      if 0 < #lists then
        table.sort(lists, function(a, b)
          return a.num > b.num
        end)
        result = lists[1]
      end
    end
  end
  return result
end

local function FreeBuildingUpgradeFinishHandle(self, message)
  if message.errorCode == nil then
    local bUuid = 0
    if message.buildInfo ~= nil then
      do
        local dic = message.buildInfo
        bUuid = dic.uuid
        self:AddBuilding(dic)
        EventManager:GetInstance():Broadcast(EventId.UPDATE_BUILD_DATA, bUuid)
        if DataCenter.CityDomeManager:IsPlayingExpendDome() then
          DataCenter.CityDomeManager:AddAfterFinishCallBack(function()
            self:AfterBuildFinishShowEffect(bUuid, message.reward, message.onceAddExp)
          end)
        else
          self:AfterBuildFinishShowEffect(bUuid, message.reward, message.onceAddExp)
        end
        EventManager:GetInstance():Broadcast(EventId.GF_building_upgrade_done, self.allBuilding[bUuid])
        EventManager:GetInstance():Broadcast(EventId.BuildBoxOpenFinish, bUuid)
        EventManager:GetInstance():Broadcast(EventId.BuildUpgradeFinish, bUuid)
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Finish, false)
        if dic.bId == BuildingTypes.LW_BUILD_ALLIANCE_CENTER and dic.lv == 1 then
          UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
        elseif dic.bId == BuildingTypes.FUN_BUILD_MAIN then
          if dic.lv == DataCenter.LWZoneMobilizationManager:GetLimitLevel() then
            DataCenter.LWZoneMobilizationManager:RequestZoneMobilizationDonatedInfoData(4)
          end
        elseif dic.bId == BuildingTypes.LW_BUILDING_SEASON5_RESEARCH and dic.lv == 1 then
          UIUtil.CheckEventTrigger(OpMode.BuildBoxOpenFinish821000, 0, 0.5)
        elseif dic.bId == BuildingTypes.LW_BUILDING_SEASON5_SHOP and dic.lv == 1 then
          UIUtil.CheckEventTrigger(OpMode.BuildBoxOpenFinish827000, 0, 0.5)
        elseif BuildingUtils.IsSeasonWeekCardCityBuilding(dic.bId) then
          DataCenter.BuildBubbleManager:CheckShowBubble(bUuid)
        elseif dic.bId == BuildingTypes.LW_BUILD_SEASON6_BUILD1 and dic.lv == 1 then
          UIUtil.CheckEventTrigger(OpMode.ClickBtnMilitary, 0, 0.5)
        end
        if BuildingUtils.IsSeasonInCityBuilding(dic.bId) then
          SeasonUtil.TryUpdateSeasonBuild(605001001)
        end
      end
    end
  else
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(self:ShowBuildErrorCode(errorCode))
    end
  end
end

local function GetEventStoreMax(self)
  local level = DataCenter.RadarCenterDataManager:GetDetectInfoLevel()
  if level < 1 then
    return 1
  end
  local max = 1
  local template = LocalController:instance():getLine(TableName.DETECT_LEVEL, level)
  if template ~= nil then
    max = template.detect_max_num
  end
  return max
end

local function CheckBuildIsReward(self, uuid)
  if self.upgradeReward[uuid] then
    return true
  end
  return false
end

local function ClickBubbleUpgradeReward(self, uuid)
  local message = self.upgradeReward[uuid]
  DataCenter.RewardManager:AddRewardsAndRes(message)
  if next(message.reward) then
    local dic = message.buildInfo
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(dic.uuid)
    local pos = SceneUtils.TileIndexToWorld(buildData.pointId)
    local reward = message.reward[1]
    if reward.type == RewardType.GOODS then
      local goods = DataCenter.ItemTemplateManager:GetItemTemplate(reward.value.itemId)
      if goods ~= nil then
        UIUtil.DoFly(RewardType.GOODS, 5, string.format(LoadPath.ItemPath, goods.icon), CS.SceneManager.World:WorldToScreenPoint(pos), Vector3.New(0, 0, 0))
      end
    elseif reward.type == RewardType.ARM then
      local army = DataCenter.ArmyTemplateManager:GetArmyTemplate(reward.value.itemId)
      local max = DataCenter.ArmyManager:GetArmyNumMax()
      local total = DataCenter.ArmyManager:GetTotalArmyNum()
      if army ~= nil then
        local param = {}
        param.type = RewardType.ARM
        param.path = string.format(LoadPath.SoldierIcons, army.icon)
        param.pos = CS.SceneManager.World:WorldToScreenPoint(pos)
        param.add = reward.value.count
        param.total = total
        param.max = max
        if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UISoliderGetTip) then
          EventManager:GetInstance():Broadcast(EventId.BuildUpgradeRewardArmy, param)
        end
      end
    elseif reward.type == RewardType.PVE_POINT and reward.value ~= 0 then
      local max = LuaEntry.Resource:GetMaxStorageByResType(RewardToResType[reward.type])
      max = Mathf.Floor(max)
      local param = {}
      param.type = RewardType.PVE_POINT
      param.pos = CS.SceneManager.World:WorldToScreenPoint(pos)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIResourceGetTip, {anim = true}, reward.value, reward.total, max, max, param)
    end
  end
  self.upgradeReward[uuid] = nil
end

function BuildManager:SendFreeBuildingUpgradeFinish(uuid)
  WorldArrowManager:GetInstance():RemoveEffect()
  SFSNetwork.SendMessage(MsgDefines.FreeBuildingUpgradeFinish, {uuid = uuid})
  DataCenter.BuildManager:DelayClearSendList(uuid)
end

function BuildManager:BuildingUpgradeTrack(itemId, upgradeType, confirmShown, setChanged)
  if itemId == nil or itemId == 0 then
    Logger.LogError("track C_BUILDING_UPGRADE_FINISHED itemId is nil or 0")
    return
  end
  if upgradeType == nil then
    Logger.LogWarning("track C_BUILDING_UPGRADE_FINISHED itemId = " .. itemId .. " upgradeType is nil")
    return
  end
  if confirmShown == nil then
    confirmShown = false
  end
  local changed = 0
  if setChanged then
    changed = 1
  end
  PostEventLog.Track(PostEventLog.Defines.C_BUILDING_UPGRADE_FINISHED, {
    id = itemId,
    actiontype = upgradeType,
    result = confirmShown,
    int_para1 = changed
  })
end

local function CheckSendBuildFinish(self, uuid, isDelaySend, info)
  local isFinish = true
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
  if buildData ~= nil then
    local guideType = DataCenter.GuideManager:GetGuideType()
    if guideType == GuideType.ClickBuild or guideType == GuideType.ClickBuildFinishBox then
      local para1 = DataCenter.GuideManager:GetGuideTemplateParam("para1")
      if para1 ~= nil and para1 ~= "" and tonumber(para1) == buildData.itemId then
        DataCenter.GuideManager:DoNext()
      end
    elseif guideType == GuideType.QueueBuild then
      local nextId = DataCenter.GuideManager:GetGuideTemplateParam("nextid")
      DataCenter.GuideManager:SetCurGuideId(tonumber(nextId))
      DataCenter.GuideManager:DoGuide()
    end
    if buildData.itemId == BuildingTypes.APS_BUILD_WORMHOLE_SUB and buildData.level == 0 then
      return isFinish
    end
    local curTimeSeconds = UITimeManager:GetInstance():GetServerSeconds()
    if buildData:IsUpgradeFinish() or info and buildData.isWorldBuild and info.endTime and info.endTime ~= 0 and curTimeSeconds > info.endTime then
      isFinish = false
      if DataCenter.BuildManager:CheckIsSendMessage(uuid) == false then
        if isDelaySend then
          return isFinish
        end
        if buildData.itemId == BuildingTypes.FUN_BUILD_MAIN and buildData.level == 7 then
          local protectEndTime = DataCenter.DefenceWallDataManager:GetDefenceWallData().protectEndTime
          local curTime = UITimeManager:GetInstance():GetServerTime()
          if protectEndTime >= curTime then
            UIUtil.ShowSecondMessageByParam({
              tipText = Localization:GetString("shield_destroy_ tips_1"),
              btnNum = 2,
              showToggle = false,
              text1 = "shield_destroy_ tips_2",
              text2 = "shield_destroy_ tips_3",
              sureAction = function()
                self:SendFreeBuildingUpgradeFinish(uuid)
                self:BuildingUpgradeTrack(buildData.itemId, 3, true, false)
              end,
              titleText = Localization:GetString("shield_destroy_ tips_4")
            })
            return isFinish
          end
        end
        local isOn = LuaEntry.Player:GetUserSetting(UserSettingKey.FINISH_BUILDING_RECEIVE_REMINDER) == "1"
        if isOn then
          local showLevel = LuaEntry.DataConfig:TryGetStr("building_finish_check", "k1")
          isOn = not string.IsNullOrEmpty(showLevel) and DataCenter.BuildManager.MainLv >= tonumber(showLevel) or false
          if isOn then
            local param = {
              contentText = Localization:GetString("building_finish_check"),
              btnNum = 2,
              confirmBtnParam = {
                action = function(check)
                  self:SendFreeBuildingUpgradeFinish(uuid)
                  if check == nil then
                    self:BuildingUpgradeTrack(buildData.itemId, 2, false, false)
                  else
                    self:BuildingUpgradeTrack(buildData.itemId, 1, true, not check)
                  end
                end
              }
            }
            UIUtil.TryShowConfirmNew(TodayNoSecondConfirmType.BuildingFinishRemindConfirm, param)
            return isFinish
          end
        end
        self:SendFreeBuildingUpgradeFinish(uuid)
        self:BuildingUpgradeTrack(buildData.itemId, 2, false, false)
      end
    end
  end
  return isFinish
end

local function CheckSendFixBuildFinish(self, uuid)
  local isFinish = true
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
  if buildData ~= nil and buildData:IsFixFinish() then
    isFinish = false
    if DataCenter.BuildManager:CheckIsSendFixMessage(uuid) == false then
      WorldArrowManager:GetInstance():RemoveEffect()
      SFSNetwork.SendMessage(MsgDefines.UserFinishFixBuilding, uuid)
      DataCenter.BuildManager:DelayClearSendFixList(uuid)
    end
  end
  return isFinish
end

local function IsCanUpgradeZeroBuild(self, uuid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
  if buildData ~= nil and buildData.state == BuildingStateType.Normal and buildData.level == 0 then
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildData.itemId)
    if buildTemplate ~= nil then
      local needItem = buildTemplate:GetNeedItem()
      if needItem ~= nil then
        for k2, v2 in ipairs(needItem) do
          local item = DataCenter.ItemData:GetItemById(v2.itemId)
          if item == nil or item.count < v2.num then
            return false
          end
        end
      end
    end
    return true
  end
  return false
end

local function FreeBuildingPlaceMainBuildingHandle(self, message)
  CS.SceneManager.World:UIDestroyBuilding()
  if message.errorCode == nil then
    local bUuid = 0
    if message.buildInfo ~= nil then
      local dic = message.buildInfo
      if dic ~= nil then
        bUuid = dic.uuid
        local buildingId = 0
        if dic.buildingId ~= nil then
          buildingId = dic.buildingId
        end
        if dic.bId ~= nil then
          buildingId = dic.bId
        end
        self:AddBuilding(dic)
        EventManager:GetInstance():Broadcast(EventId.UPDATE_BUILD_DATA, bUuid)
        local signal = SFSObject.New()
        signal:PutLong("bUuid", bUuid)
        signal:PutInt("type", buildingId)
        EventManager:GetInstance():Broadcast(EventId.BuildPlace, signal)
      end
    end
    DataCenter.RewardManager:AddRewardsAndRes(message)
  else
    UIUtil.ShowTips(self:ShowBuildErrorCode(message.errorCode))
    local lastPos = self:GetOneAndRemoveMoveBuild()
    BuildingUtils.ShowPutBuild(BuildingTypes.FUN_BUILD_MAIN, PlaceBuildType.Build, 0, lastPos)
  end
end

local function BuildCityBuildingHandle(self, message)
  if message.errorCode == nil then
    if message.buildInfo ~= nil then
      local dic = message.buildInfo
      if dic ~= nil then
        self:AddBuilding(dic)
        EventManager:GetInstance():Broadcast(EventId.UPDATE_BUILD_DATA, dic.uuid)
      end
    end
  else
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
  end
end

local function HasResourceBuildingFull(self, resourceType)
  local buildIds = DataCenter.ResourceManager:GetResourceOutBuildingUids(resourceType)
  for _, v in ipairs(buildIds) do
    if self:IsResourceBuildingFull(v) then
      return true, v
    end
  end
  return false, nil
end

local function IsResourceBuildingFull(self, buildUUid)
  local data = DataCenter.BuildManager:GetBuildingDataByUuid(buildUUid)
  if data == nil or data.state == BuildingStateType.FoldUp then
    return false
  end
  local currentNum = self:GetOutResourceNum(buildUUid)
  local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(data.itemId, data.level)
  if levelTemplate ~= nil and 0 < currentNum and currentNum >= levelTemplate:GetCollectMax() then
    return true
  end
  return false
end

local function GetAllResourceBuildingFullLatestTime()
  local buildingIds = {
    BuildingTypes.FUN_BUILD_STONE,
    BuildingTypes.FUN_BUILD_OIL,
    BuildingTypes.FUN_BUILD_WATER,
    BuildingTypes.FUN_BUILD_WIND_TURBINE,
    BuildingTypes.FUN_BUILD_VILLA,
    BuildingTypes.FUN_BUILD_ELECTRICITY,
    BuildingTypes.FUN_BUILD_CONDOMINIUM,
    BuildingTypes.FUN_BUILD_GROCERY_STORE
  }
  local currentTime = UITimeManager:GetInstance():GetServerTime()
  local checkIds = {}
  table.walk(buildingIds, function(_, v)
    checkIds[v] = 0
  end)
  local allBuildings = DataCenter.BuildManager:GetAllBuildUuid()
  if allBuildings ~= nil then
    table.walk(allBuildings, function(_, v)
      local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(v)
      if buildData == nil or checkIds[buildData.itemId] == nil or buildData.state == BuildingStateType.FoldUp then
        return
      else
        local time = DataCenter.BuildManager:GetShowBubbleTime(v, 1)
        if time <= 0 then
          return
        elseif checkIds[buildData.itemId] == 0 or time < checkIds[buildData.itemId] then
          checkIds[buildData.itemId] = time
        end
      end
    end)
  end
  local time = 0
  table.walk(checkIds, function(k, v)
    if 0 < v and (time == 0 or v > time) then
      time = v
    end
  end)
  local result = (time - currentTime) / 1000
  result = math.max(result, 0)
  return result
end

local function UpdateBuildDataSignal(self)
end

local function LoadNoShowUnlock(self)
  self.noShowUnlock = {}
  local str = Setting:GetString(LuaEntry.Player.uid .. SettingKeys.BUILD_NO_SHOW_UNLOCK, "")
  if str ~= nil and str ~= "" then
    local list = string.split(str, ";")
    for _, v in ipairs(list) do
      if v ~= "" then
        local buildId = tonumber(v)
        self.noShowUnlock[buildId] = true
      end
    end
  end
end

local function SaveNoShowUnlock(self)
  local str = ""
  for k, _ in pairs(self.noShowUnlock) do
    str = str .. k .. ";"
  end
  Setting:SetString(LuaEntry.Player.uid .. SettingKeys.BUILD_NO_SHOW_UNLOCK, str)
end

local function ShowBuildErrorCode(self, errorCode)
  if errorCode == GameDialogDefine.BUILD_BOARD_LIMIT_MYBASE_RANGE then
    return Localization:GetString(GameDialogDefine.BUILD_BOARD_LIMIT_MYBASE_RANGE, DataCenter.BoardManager:GetBuildMaxRadius())
  elseif errorCode == GameDialogDefine.BUILD_LIMIT_OTHERBASE_RANGE then
    return Localization:GetString(GameDialogDefine.BUILD_LIMIT_OTHERBASE_RANGE, DataCenter.BoardManager:GetOtherLimitRadius())
  elseif errorCode == GameDialogDefine.OUT_MYBASE_RANGE then
    return Localization:GetString(GameDialogDefine.OUT_MYBASE_RANGE, DataCenter.BoardManager:GetBuildMaxRadius())
  elseif errorCode == GameDialogDefine.IN_OTHERBASE_RANGE then
    return Localization:GetString(GameDialogDefine.IN_OTHERBASE_RANGE, DataCenter.BoardManager:GetOtherLimitRadius())
  elseif errorCode == GameDialogDefine.OUT_UNLOCK_RANGE_REASON then
    return Localization:GetString(GameDialogDefine.OUT_UNLOCK_RANGE_REASON, CS.SceneManager.World.CurTileCountXMin, CS.SceneManager.World.CurTileCountYMin, CS.SceneManager.World.CurTileCountXMax, CS.SceneManager.World.CurTileCountYMax)
  end
  return Localization:GetString(errorCode)
end

local function FindMainBuildInitPositionHandle(self, message)
  if message.errorCode == nil then
    if message.pointId ~= nil then
      self.showPoint = message.pointId
    end
    if message.maxAreaSize ~= nil then
      CS.SceneManager.World:SetWorldSize(message.maxAreaSize)
    end
  else
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
  end
  EventManager:GetInstance():Broadcast(EventId.REGET_MAIN_POSITION)
end

local function FreeBuildingPlaceNewHandle(self, message, isPlayAni)
  CS.SceneManager.World:UIDestroyBuilding()
  EventManager:GetInstance():Broadcast(EventId.UIPlaceBuildSendMessageBack)
  if message.errorCode == nil then
    if message.serverSystemTime ~= nil then
      CS.GameEntry.Timer:UpdateServerMilliseconds(message.serverSystemTime)
      UITimeManager:GetInstance():UpdateServerMsDeltaTime(message.serverSystemTime)
    end
    if message.remainGold ~= nil then
      LuaEntry.Player.gold = message.remainGold
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
    if message.itemInfo ~= nil then
      DataCenter.ItemData:UpdateOneItem(message.itemInfo)
    end
    if message.queue ~= nil then
      for k, v in pairs(message.queue) do
        DataCenter.QueueDataManager:UpdateQueueData(v)
      end
    end
    if message.build_queue then
      DataCenter.BuildQueueManager:UpdateQueueData({
        message.build_queue
      }, false)
    end
    local bUuid = 0
    if message.buildInfo ~= nil then
      local dic = message.buildInfo
      if dic ~= nil then
        bUuid = dic.uuid
        local buildingId = 0
        if dic.buildingId ~= nil then
          buildingId = dic.buildingId
        end
        if dic.bId ~= nil then
          buildingId = dic.bId
        end
        local endTime = 0
        if dic.uT ~= nil then
          endTime = dic.uT
        end
        self:AddBuilding(dic)
        if not DataCenter.GuideManager:IsSendBuildPlace() then
          local buildingDate = self:GetBuildingDataByUuid(bUuid)
          if buildingDate ~= nil then
            buildingDate.state = BuildingStateType.Normal
            buildingDate.startTime = 0
            buildingDate.updateTime = 0
          end
        end
        EventManager:GetInstance():Broadcast(EventId.UPDATE_BUILD_DATA, bUuid)
        local signal = SFSObject.New()
        signal:PutLong("bUuid", bUuid)
        signal:PutInt("type", buildingId)
        EventManager:GetInstance():Broadcast(EventId.BuildPlace, signal)
        if buildingId == BuildingTypes.LW_BUILD_HERO then
          local isInit = false
          if isPlayAni ~= nil then
            isInit = not isPlayAni
          end
          DataCenter.BuildHeroManager:AddBuildHero(dic, isInit)
        end
        if 0 < endTime then
          local now = UITimeManager:GetInstance():GetServerTime()
          if endTime > now then
            DataCenter.LWSoundManager:PlaySound(80013, false)
          end
        end
        EventManager:GetInstance():Broadcast(EventId.GF_building_build_started, self:GetBuildingDataByUuid(bUuid))
      end
    end
    DataCenter.RewardManager:AddRewardsAndRes(message)
  else
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(self:ShowBuildErrorCode(errorCode))
    end
  end
end

local function FreeBuildingReplaceNewHandle(self, message)
  CS.SceneManager.World:UIDestroyBuilding()
  EventManager:GetInstance():Broadcast(EventId.UIPlaceBuildSendMessageBack)
  if message.errorCode == nil then
    if message.resource ~= nil then
      LuaEntry.Resource:UpdateResource(message.resource)
    end
    if message.buildInfo ~= nil then
      local dic = message.buildInfo
      if dic ~= nil then
        local bUuid = dic.uuid
        self:AddBuilding(dic)
        EventManager:GetInstance():Broadcast(EventId.UPDATE_BUILD_DATA, bUuid)
      end
    end
    if message.changeBuildInfos ~= nil then
      local dic = message.changeBuildInfos
      for _, v in pairs(dic) do
        local bUuid = v.uuid
        if bUuid ~= nil then
          self:AddBuilding(v)
          EventManager:GetInstance():Broadcast(EventId.UPDATE_BUILD_DATA, bUuid)
        end
      end
    end
    EventManager:GetInstance():Broadcast(EventId.DecorateRedPoint)
  else
    local errorCode = message.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(self:ShowBuildErrorCode(errorCode))
    end
  end
end

local function AddOneChangeMoveBuild(self, index)
  table.insert(self.changeMovePos, index)
end

function BuildManager:SetCurrentBuildMoveState(state)
  self.currentBuildMoveState = state
end

function BuildManager:GetCurrentBuildMoveState()
  return self.currentBuildMoveState
end

local function GetOneAndRemoveMoveBuild(self)
  return table.remove(self.changeMovePos, #self.changeMovePos)
end

local function BuildWorldMoveNewHandle(self, message)
  CS.SceneManager.World:UIDestroyBuilding()
  if message.errorCode == nil then
    if message.buildInfo ~= nil then
      local dic = message.buildInfo
      if dic ~= nil then
        local bUuid = dic.uuid
        local oldData = DeepCopy(DataCenter.BuildManager:GetBuildingDataByUuid(bUuid))
        local moveData = {old = oldData}
        self:AddBuilding(dic)
        EventManager:GetInstance():Broadcast(EventId.UPDATE_BUILD_DATA, bUuid)
        moveData.new = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
        moveData.uuid = bUuid
        EventManager:GetInstance():Broadcast(EventId.BuildingMove, moveData)
        if dic.bId == BuildingTypes.LW_BUILD_HERO then
          DataCenter.BuildHeroManager:MoveBuildHero(dic)
        end
      end
    end
  else
    UIUtil.ShowTips(self:ShowBuildErrorCode(message.errorCode))
    local lastPos = self:GetOneAndRemoveMoveBuild()
    local temp = CS.SceneManager.World:GetBuildingByPoint(lastPos)
    if temp ~= nil then
      local tempPos = SceneUtils.TileIndexToWorld(lastPos)
      temp.transform.position = tempPos
      SceneUtils.ReturnPoolV3(tempPos)
    end
  end
end

local function CanFastBuild(self)
  local allDataList = DataCenter.BuildTemplateManager:GetBuildListIds()
  local types = {
    UIBuildListTabType.Economy,
    UIBuildListTabType.Military
  }
  for _, type in ipairs(types) do
    if allDataList[type] ~= nil then
      for _, data in pairs(allDataList[type]) do
        if data.buildTemplate.disrecommend == 0 then
          local state = self:GetBuildState(data.id)
          if state == BuildState.BUILD_LIST_STATE_OK or state == BuildState.BUILD_LIST_RECEIVED then
            return true
          end
        end
      end
    end
  end
  return false
end

local function GetFastBuildDataList(self)
  local dataList = {}
  local receivedList = {}
  local allDataList = DataCenter.BuildTemplateManager:GetBuildListIds()
  local types = {
    UIBuildListTabType.Economy,
    UIBuildListTabType.Military
  }
  for _, type in ipairs(types) do
    if allDataList[type] ~= nil then
      for _, data in pairs(allDataList[type]) do
        if data.buildTemplate.disrecommend == 0 then
          local state = self:GetBuildState(data.id)
          if state == BuildState.BUILD_LIST_RECEIVED then
            table.insert(receivedList, data)
          elseif state == BuildState.BUILD_LIST_STATE_OK then
            table.insert(dataList, data)
          end
        end
      end
    end
  end
  table.sort(receivedList, function(a, b)
    return a.buildTemplate.order < b.buildTemplate.order
  end)
  table.sort(dataList, function(a, b)
    return a.buildTemplate.order < b.buildTemplate.order
  end)
  table.insertto(receivedList, dataList)
  return receivedList
end

local function GetBuildExp(self, buildId, level)
  local template = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
  return template and template.exp or 0
end

local function FlyExp(self, bUuid, buildId)
  if CS.SceneManager.World then
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
    local worldPos = SceneUtils.TileIndexToWorld(buildData.pointId)
    local pos = CS.SceneManager.World:WorldToScreenPoint(worldPos)
    SceneUtils.ReturnPoolV3(worldPos)
    local exp = self:GetBuildExp(buildId, buildData.level)
    DataCenter.PlayerLevelManager:FlyExp(ExpSource.Building, pos, exp)
  end
end

local function SetNewUserWorld(self, value)
  self.newUserWorld = value
end

local function IsInNewUserWorld(self)
  return self.newUserWorld == NewUserWorld.Ing
end

local function GetMaxBuildingLevel(self, buildId)
  local data = self:GetMaxLvBuildDataByBuildId(buildId)
  if data == nil then
    return 0
  end
  return data.level
end

local function GetBuildingDataByUuid(self, uuid)
  local data = self.allBuilding[uuid]
  return data
end

local function GetAllBuildingByItemIdWithoutPickUp(self, buildId)
  local result = {}
  local list = self.buildIdBuilding[buildId]
  local i = 1
  if list ~= nil then
    for i = 1, #list do
      local v = list[i]
      if v.state ~= BuildingStateType.FoldUp then
        result[i] = v
        i = i + 1
      end
    end
  end
  return result
end

local function GetFunbuildByItemID(self, buildId)
  local ret
  if self.buildIdBuilding ~= nil then
    local list = self.buildIdBuilding[buildId]
    if list ~= nil and table.count(list) > 0 then
      ret = list[1]
    end
    if ret == nil and buildId == BuildingTypes.WORM_HOLE_CROSS and BattleFieldUtil.InBattleField() then
      return {
        server = LuaEntry.Player:GetCurServerId(),
        worldId = LuaEntry.Player:GetCurWorldId(),
        worldType = LuaEntry.Player:GetCurWorldType(),
        pointId = LuaEntry.Player:GetMainWorldPos()
      }
    end
  end
  return ret
end

function BuildManager:GetFunbuildListByItemID(buildId)
  local list
  if self.buildIdBuilding ~= nil then
    list = self.buildIdBuilding[buildId]
  end
  return list
end

local function HasBuilding(self, buildId, includeFoldUp)
  local data = self:GetMaxLvBuildDataByBuildId(buildId, includeFoldUp)
  return data ~= nil and data.level > 0
end

function BuildManager:HasSeasonMummyYardBuilding(includeFoldUp)
  local buildId = SeasonUtil.GetMummyYardBuildingId()
  local data = self:GetMaxLvBuildDataByBuildId(buildId, includeFoldUp)
  return data ~= nil and (data.level > 0 or buildId == BuildingTypes.LW_BUILD_ARMY_YARD_MUMMY_S5 or buildId == BuildingTypes.LW_BUILD_ARMY_YARD_MUMMY_S6)
end

local function GetMaxLvBuildDataByBuildId(self, buildId, includeFoldUp)
  local list = self.buildIdBuilding[buildId]
  if list ~= nil then
    local result
    local level = -1
    for k, v in ipairs(list) do
      if level < v.level and (includeFoldUp or v.state ~= BuildingStateType.FoldUp) then
        level = v.level
        result = v
      end
    end
    return result
  end
end

local function GetArmyBuildMaxLevelData(self)
  local buildingTypes = {
    BuildingTypes.FUN_BUILD_CAR_BARRACK,
    BuildingTypes.FUN_BUILD_INFANTRY_BARRACK,
    BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK
  }
  local result
  local level = -1
  for k, v in pairs(buildingTypes) do
    local buildData = self:GetMaxLvBuildDataByBuildId(v)
    if buildData ~= nil and level < buildData.level then
      level = buildData.level
      result = buildData
    end
  end
  return result
end

local function GetUnlock2BuildByEffectAndType(self, buildId)
  local result = 0
  if buildId == BuildingTypes.APS_BUILD_FARM_FIELD then
    result = LuaEntry.Effect:GetGameEffect(EffectDefine.ADD_FIELD_NUM)
  elseif buildId == BuildingTypes.FUN_BUILD_WATER then
    result = LuaEntry.Effect:GetGameEffect(EffectDefine.ADD_WATER_BUILD_NUM)
  elseif buildId == BuildingTypes.FUN_BUILD_CONDOMINIUM then
    result = LuaEntry.Effect:GetGameEffect(EffectDefine.ADD_HOTEL_NUM)
  elseif buildId == BuildingTypes.FUN_BUILD_STONE then
    result = LuaEntry.Effect:GetGameEffect(EffectDefine.ADD_METAL_COLLECT_NUM)
  elseif buildId == BuildingTypes.FUN_BUILD_SCIENCE_PART then
    result = LuaEntry.Effect:GetGameEffect(EffectDefine.ADD_SCIENCE_QUEUE)
  elseif buildId == BuildingTypes.FUN_BUILD_ARROW_TOWER then
    result = LuaEntry.Effect:GetGameEffect(EffectDefine.ADD_BUILD_ARROW_TOWER_NUM)
  end
  return result
end

local function IsExistBuildByTypeLv(self, buildId, level)
  return level <= self:GetMaxBuildingLevel(buildId)
end

local function GetAllBuildUuid(self)
  local result
  if self.allBuilding ~= nil then
    result = {}
    for k, v in pairs(self.allBuilding) do
      table.insert(result, k)
    end
  end
  return result
end

local function GetAllBuildData(self)
  if self.allBuilding ~= nil then
    return self.allBuilding
  end
end

local function GetBuildingDatasByBuildingId(self, buildingId)
  local result = {}
  for _, data in pairs(self.allBuilding) do
    if data.itemId == buildingId then
      table.insert(result, data)
    end
  end
  return result
end

local function GetFoldUpBuildByBuildId(self, buildId)
  local list = self.buildIdBuilding[buildId]
  if list ~= nil then
    local result = {}
    for k, v in ipairs(list) do
      if v.state == BuildingStateType.FoldUp then
        table.insert(result, v)
      end
    end
    if table.count(result) > 1 then
      table.sort(result, function(a, b)
        if a.level == b.level then
          return a.uuid < b.uuid
        end
        if a.level > b.level then
          return true
        end
        return false
      end)
    end
    return result
  end
end

function BuildManager:UpdateBuildByTaskId(taskId)
  local buildUuid = {}
  if self.allBuilding ~= nil and taskId ~= nil then
    local strTaskId = tostring(taskId)
    for k, v in pairs(self.allBuilding) do
      if v ~= nil then
        local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(v.itemId, v.level)
        if buildLevelTemplate ~= nil and buildLevelTemplate.quest_condition == strTaskId then
          Logger.Log("refresh build " .. v.itemId)
          EventManager:GetInstance():Broadcast(EventId.UPDATE_BUILD_DATA, v.uuid)
          table.insert(buildUuid, v.uuid)
        end
      end
    end
  end
  return buildUuid
end

function BuildManager:DoActionForAllBuilding(buildId, buildingState, action)
  if not buildingState then
    return
  end
  local list = self.buildIdBuilding[buildId]
  if list ~= nil then
    for i = 1, #list do
      local v = list[i]
      if v.state == buildingState then
        action(v)
      end
    end
  end
end

function BuildManager:DoActionForAllBuildingExceptState(buildId, buildingState, action)
  if not buildingState then
    return
  end
  local list = self.buildIdBuilding[buildId]
  if list ~= nil then
    for i = 1, #list do
      local v = list[i]
      if v.state ~= buildingState then
        action(v)
      end
    end
  end
end

local function GetHaveBuildNumWithOutFoldUpByBuildId(self, buildId)
  local list = self:GetAllBuildingByItemIdWithoutPickUp(buildId)
  if list ~= nil then
    return #list
  end
  return 0
end

local AdditionCountTechnological = {
  [10201000] = 90006,
  [10202000] = 90007,
  [10207000] = 90008,
  [10124000] = 90011,
  [10103000] = 90010,
  [10104000] = 90021,
  [10221000] = 50237
}
local AdditionUpLevelResTechnological = 50136

local function GetCurMaxBuildNum(self, buildId)
  local result = 0
  local guideMaxNum = 0
  local taskMaxNum = 0
  local chapterMaxNum = 0
  local maxType = BuildMaxNumType.Cur
  local buildDesTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  if buildDesTemplate ~= nil then
    result = buildDesTemplate:GetCurMaxCanBuildNum()
    guideMaxNum = buildDesTemplate:GetGuideCanBuildMaxNum()
    taskMaxNum = buildDesTemplate:GetQuestCanBuildMaxNum()
    chapterMaxNum = buildDesTemplate:GetChapterCanBuildMaxNum()
  end
  if result > guideMaxNum then
    result = guideMaxNum
    maxType = BuildMaxNumType.Guide
  end
  if taskMaxNum < result then
    result = taskMaxNum
    maxType = BuildMaxNumType.Quest
  end
  if chapterMaxNum < result then
    result = chapterMaxNum
    maxType = BuildMaxNumType.Chapter
  end
  local addition = 0
  if AdditionCountTechnological[buildId] then
    addition = LuaEntry.Effect:GetGameEffect(AdditionCountTechnological[buildId])
  end
  result = result + self:GetUnlock2BuildByEffectAndType(buildId)
  result = result + addition
  return result, maxType
end

local function GetMaxBuildNum(self, buildId)
  local result = 0
  local buildDesTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  if buildDesTemplate ~= nil then
    result = buildDesTemplate:GetMaxCanBuildNum()
  end
  local addition = 0
  if AdditionCountTechnological[buildId] then
    addition = LuaEntry.Effect:GetGameEffect(AdditionCountTechnological[buildId])
  end
  result = result + self:GetUnlock2BuildByEffectAndType(buildId)
  return result + addition
end

local function AllianceHelpAddSpeed(self, uuid, endTime, startTime)
  local data = self:GetBuildingDataByUuid(uuid)
  if data ~= nil then
    data.updateTime = endTime
    data.startTime = startTime
  end
end

local function AllianceHelpFixAddSpeed(self, uuid, endTime, startTime)
  local data = self:GetBuildingDataByUuid(uuid)
  if data ~= nil then
    data.destroyEndTime = endTime
    data.destroyStartTime = startTime
  end
end

local function OnAllianceCallHelp(self, uuid)
  local data = self:GetBuildingDataByUuid(uuid)
  if data ~= nil then
    if data.isHelped == AllianceHelpState.No then
      data.isHelped = AllianceHelpState.UpgradeHelped
    elseif data.isHelped == AllianceHelpState.RuinsHelped then
      data.isHelped = AllianceHelpState.UpgradeAndRuinsHelped
    end
  end
end

local function OnAllianceCallFixHelp(self, uuid)
  local data = self:GetBuildingDataByUuid(uuid)
  if data ~= nil then
    if data.isHelped == AllianceHelpState.No then
      data.isHelped = AllianceHelpState.RuinsHelped
    elseif data.isHelped == AllianceHelpState.UpgradeHelped then
      data.isHelped = AllianceHelpState.UpgradeAndRuinsHelped
    end
  end
end

local function GetAllInBaseTruckShowBuild(self)
  if self.allBuilding ~= nil then
    local hasHouse = false
    local result = {}
    for k, v in pairs(self.allBuilding) do
      if v.state ~= BuildingStateType.FoldUp then
        local buildId = v.itemId
        if buildId == BuildingTypes.FUN_BUILD_LIBRARY then
          hasHouse = true
        end
        if buildId ~= BuildingTypes.FUN_BUILD_MAIN and buildId ~= BuildingTypes.FUN_BUILD_DOME then
          local buildDesTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
          if buildDesTemplate ~= nil and (buildDesTemplate.build_type == BuildType.Normal or buildDesTemplate.build_type == BuildType.Main) then
            table.insert(result, v)
          end
        end
      end
    end
    if hasHouse then
      return result
    end
  end
end

local function GetPathTimeFromDroneToBuildTarget(self, pos)
  if not self:IsShowBuildFlyPath() then
    return 0
  end
  local flyTime = BuildRobotFlyTime
  local buildData = self:GetMaxLvBuildDataByBuildId(BuildingTypes.FUN_BUILD_DRONE)
  if buildData == nil then
    buildData = self:GetMaxLvBuildDataByBuildId(BuildingTypes.FUN_BUILD_MAIN)
  end
  if buildData ~= nil then
    local startPos = CS.PathUtils.GetDroneCenterPos(buildData:GetCenterVec()) + Vector3.New(0, 1, 0) * BuildRobotTakeOffHeight
    local endPos = pos
    flyTime = CS.PathUtils.CalRobotMoveNeedTime(startPos, endPos) * 1000
  end
  return math.ceil(BuildRobotTakeOffTime + BuildRobotRotationTime + flyTime)
end

local function GetPathTimeFromDroneToRoadTarget(self, roads)
  local flyTime = 0
  local buildData = self:GetMaxLvBuildDataByBuildId(BuildingTypes.FUN_BUILD_DRONE)
  if buildData == nil then
    buildData = self:GetMaxLvBuildDataByBuildId(BuildingTypes.FUN_BUILD_MAIN)
  end
  if buildData ~= nil then
    local vecUp = Vector3.New(0, 1, 0)
    local startPos = CS.PathUtils.GetDroneCenterPos(buildData:GetCenterVec()) + vecUp:Mul(BuildRobotTakeOffHeight)
    local endPos = CS.PathUtils.GetRoadRobotWorkStartPosForLua(roads) + vecUp:Mul(RoadRobotWorkHeight)
    flyTime = CS.PathUtils.CalRobotMoveNeedTime(startPos, endPos) * 1000
  end
  local buildTime = table.count(roads) * DataCenter.BoardManager:GetBuildTime()
  return math.ceil(BuildRobotTakeOffTime + BuildRobotRotationTime + flyTime + buildTime)
end

local function GetBuildingDataByPointId(self, pointId, isWorldBuild)
  if self.allBuilding ~= nil then
    for k, v in pairs(self.allBuilding) do
      if (isWorldBuild and v.isWorldBuild or not isWorldBuild and not v.isWorldBuild) and v.state ~= BuildingStateType.FoldUp and v:IsRangePoint(pointId) then
        return v
      end
    end
  end
end

local function GetAllBuildWithoutPickUp(self)
  local result
  if self.allBuilding ~= nil then
    result = {}
    for k, v in pairs(self.allBuilding) do
      if v.state ~= BuildingStateType.FoldUp then
        table.insert(result, v)
      end
    end
  end
  return result
end

local function PushBuildFoldUpHandle(self, message)
  local bUuid = 0
  if message.buildInfo ~= nil then
    local dic = message.buildInfo
    if dic ~= nil then
      bUuid = dic.uuid
      self:AddBuilding(dic)
      EventManager:GetInstance():Broadcast(EventId.UPDATE_BUILD_DATA, bUuid)
    end
  end
  if message.needRemove then
    if self.allBuilding[message.needRemove] then
      DataCenter.BuildHeroManager:RemoveBuildHero(self.allBuilding[message.needRemove].prodStatus)
    end
    self:RemoveBuilding(message.needRemove)
    EventManager:GetInstance():Broadcast(EventId.NoticeMainViewUpdateMarch)
    EventManager:GetInstance():Broadcast(EventId.UPDATE_BUILD_DATA, message.needRemove)
  end
end

local function CheckReplaceMain(self)
  if LuaEntry.Player:GetMainWorldPos() == 0 and SceneUtils.GetIsInWorld() and CS.SceneManager.World ~= nil and CS.SceneManager.World:IsBuildFinish() and not DataCenter.AllianceLeaderElectManager:IsAutoJoin() then
    local mainBuild = self:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
    DataCenter.GuideManager:SetCurGuideId(GuideEndId)
    SFSNetwork.SendMessage(MsgDefines.FindMainBuildInitPosition)
    local mainBuildModelPath = BuildingUtils.GetWorldBuildingModelName(BuildingTypes.FUN_BUILD_MAIN, DataCenter.BuildManager.MainLv)
    CS.SceneManager.World:UICreateBuildingModelPath(BuildingTypes.FUN_BUILD_MAIN, mainBuild.uuid, self.showPoint, PlaceBuildType.Replace, mainBuildModelPath)
  end
end

local function CheckShowReplaceTip(self)
  local mainBuild = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
  if LuaEntry.Player:GetMainWorldPos() == 0 then
    if SceneUtils.GetIsInCity() then
      UIUtil.ShowMessage(Localization:GetString("110235"), 1, GameDialogDefine.GOTO, GameDialogDefine.CANCEL, function()
        SceneUtils.ChangeToWorld()
      end, nil, function()
        SceneUtils.ChangeToWorld()
      end)
    end
    return true
  elseif mainBuild == nil or mainBuild.state == BuildingStateType.FoldUp then
    return true
  end
  return false
end

local function PushBuildingConnectStatusHandle(self, message)
end

local function SetShowPutBuildFromPanel(self, showPutBuildFromPanel)
  self.showPutBuildFromPanel = showPutBuildFromPanel
end

local function GetShowPutBuildFromPanel(self)
  return self.showPutBuildFromPanel
end

local function IsShowDiamond(self)
  return self.MainLv >= ShowDiamondLevel
end

local function IsShowBuildFlyPath(self)
  local chapterId = DataCenter.ChapterTaskManager:GetCurChapterId()
  if chapterId ~= nil and chapterId <= BuildRobotFlyChapterId then
    return false
  end
  return true
end

local function GetGarageIndex(self, buildId)
  for i, bId in ipairs(GarageBuildIds) do
    if buildId == bId then
      return i
    end
  end
  return nil
end

local function GetCountry(self)
  return self.country
end

local function PushBuildDeleteHandle(self, message)
  if message.buildingUuids then
    for _, bUuid in ipairs(message.buildingUuids) do
      self:RemoveBuilding(bUuid)
      EventManager:GetInstance():Broadcast(EventId.UPDATE_BUILD_DATA, bUuid)
    end
  end
end

local function GetBuildIdByPointId(self, pointId)
  local pointInfo = CS.SceneManager.World:GetPointInfo(pointId)
  if pointInfo == nil or pointInfo.PointType ~= WorldPointType.PlayerBuilding then
    return nil
  end
  cast(pointInfo, typeof(CS.BuildPointInfo))
  if pointInfo == nil then
    return nil
  end
  local buildId = pointInfo.itemId
  return buildId
end

local function SetShowCityLabel(self, show)
  self.showCityLabel = show
  EventManager:GetInstance():Broadcast(EventId.SetCityLabelShow, show)
end

local function UpgradeBuilding(self, bUuid)
  local buildData = self.allBuilding[bUuid]
  if buildData == nil then
    return
  end
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildData.itemId)
  local ret = self:CheckBuildUpgradeResAndItem(bUuid)
  local lackResource = ret.lackResourceDict
  local lackItem = ret.lackItemList
  local lackResItem = ret.lackResItemList
  local noBuyItemId = ret.noBuyItemId
  local noBuyResItemId = ret.noBuyResItemId
  if buildData.updateTime > 0 then
    UIUtil.ShowTipsId(GameDialogDefine.BUILD_UPGRADING)
  elseif buildData.state == BuildingStateType.Normal then
    if noBuyItemId ~= nil then
      UIUtil.ShowTipsId(GameDialogDefine.ITEM_NO_REACH, DataCenter.ItemTemplateManager:GetName(noBuyItemId))
    elseif noBuyResItemId ~= nil then
      UIUtil.ShowTipsId(GameDialogDefine.ITEM_NO_REACH, DataCenter.ResourceItemDataManager:GetName(noBuyResItemId))
    elseif not table.IsNullOrEmpty(lackResource) then
      local lackTab = {}
      for k, v in pairs(lackResource) do
        local param = {}
        param.type = ResLackType.Res
        param.resType = k
        param.targetNum = v
        table.insert(lackTab, param)
      end
      GoToResLack.GoToItemResLackList(lackTab)
      UIUtil.ShowTipsId(120020)
    elseif not table.IsNullOrEmpty(lackItem) then
      local lackTab = {}
      for i = 1, #lackItem do
        local param = {}
        param.type = ResLackType.Item
        param.itemId = lackItem[i].itemId
        param.targetNum = lackItem[i].count
        table.insert(lackTab, param)
      end
      GoToResLack.GoToItemResLackList(lackTab)
      UIUtil.ShowTipsId(120021)
    elseif not table.IsNullOrEmpty(lackResItem) then
      local lackTab = {}
      for i = 1, #lackResItem do
        local param = {}
        param.type = ResLackType.ResItem
        param.itemId = lackResItem[i].itemId
        param.targetNum = lackResItem[i].count
        table.insert(lackTab, param)
      end
      GoToResLack.GoToItemResLackList(lackTab)
      UIUtil.ShowTipsId(120021)
    else
      local needPathTime = 0
      if buildTemplate.scan == BuildScanAnim.Play then
        needPathTime = DataCenter.BuildManager:GetPathTimeFromDroneToBuildTarget(buildData:GetCenterVec())
      end
      local param = {}
      param.uuid = tostring(bUuid)
      param.gold = BuildUpgradeUseGoldType.No
      param.upLevel = buildData.level + 1
      param.clientParam = ""
      param.truckId = 0
      param.pathTime = needPathTime
      param.robotUuid = 0
      SFSNetwork.SendMessage(MsgDefines.FreeBuildingUpNew, param)
    end
  end
end

local function OpenUpgradeSuccess(self, buildId, level, uuid, rewards, curUpgradeStashExp)
  if not table.IsNullOrEmpty(rewards) then
    DataCenter.RewardManager:AddRewards(rewards)
  end
  if level <= 1 then
    self.ShowUpLevelReward(uuid, rewards)
    return
  end
  local preLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level - 1)
  local curLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
  local buildingTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  if preLevelTemplate == nil or curLevelTemplate == nil or buildingTemplate == nil then
    return
  end
  local curNums = curLevelTemplate.local_num
  local preNums = preLevelTemplate.local_num
  local maxCount = table.count(curNums)
  local diaCount = table.count(buildingTemplate.effect_Local_dialog)
  if maxCount > diaCount then
    maxCount = diaCount
  end
  if maxCount == 0 then
    return
  end
  local hasChangeValue = false
  for i = 1, maxCount do
    local type = buildingTemplate.effect_Local_type[i]
    local needAdd = true
    local preValue, curValue
    if type == EffectLocalType.Dialog then
      local val = DataCenter.BuildManager:GetEffectNumWithType(curNums[i], type)
      if val == nil or val == "" then
        needAdd = false
      end
      curValue = val
    else
      preValue = DataCenter.BuildManager:GetEffectNumWithType(tonumber(preNums[i]) or 0, type)
      curValue = DataCenter.BuildManager:GetEffectNumWithType(tonumber(curNums[i]) or 0, type)
      needAdd = preValue ~= curValue
    end
    if needAdd then
      hasChangeValue = true
    end
  end
  if not hasChangeValue then
    return
  end
  if buildId == BuildingTypes.FUN_BUILD_MAIN then
    UIManager:GetInstance():OpenWindow(UIWindowNames.MainBuildUpgradeSuccess, buildId, level, uuid, rewards, curUpgradeStashExp)
    if Setting:CheckFirstLaunchSkipUpdate() then
      local ignoreMainLv = LuaEntry.DataConfig:TryGetNum("first_launch_skip_update", "k2")
      if level >= ignoreMainLv and not Setting.FirstLaunchSkipUpdateNewestVersion then
        Setting:DisableFirstLaunchSkipUpdate()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIForceUpdateTip, {anim = true})
      end
    end
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgradeSuccess, buildId, level, uuid, rewards, curUpgradeStashExp)
  end
end

local function CheckGetNewBuildSendMessage(self, buildId, level, bUuid)
  if buildId == BuildingTypes.FUN_BUILD_MAIN and level == DataCenter.RadarCenterDataManager:GetRadarBubbleOpenMainCityLevel() then
    EventManager:GetInstance():Broadcast(EventId.DetectInfoChange)
    return
  end
  if buildId == BuildingTypes.FUN_BUILD_RADAR_CENTER then
    return
  end
  if level == 1 then
    if buildId == BuildingTypes.FUN_BUILD_BUSINESS_CENTER then
      DataCenter.ResidentOrderDataManager:GetResidentOrder()
    elseif buildId == BuildingTypes.FUN_BUILD_GROCERY_STORE then
      DataCenter.GroceryStoreOrderDataManager:SendGetGroceryStoreOrder()
    elseif DataCenter.BuildManager:IsFactoryBuild(buildId) then
      SFSNetwork.SendMessage(MsgDefines.SynFoodFactory, bUuid)
    elseif buildId == BuildingTypes.LW_FIRST_PAY then
    end
  end
  DataCenter.LWCivilizationSparkExtend:BuildingManager_getNewBuild(buildId, level)
end

local function IsFactoryBuild(self, buildType)
  for _, v in ipairs(FactoryBuild) do
    if buildType == v then
      return true
    end
  end
  return false
end

local function GetBuildQueueState(self, uuid)
  local buildData = self:GetBuildingDataByUuid(uuid)
  if buildData ~= nil then
    if buildData.destroyStartTime > 0 then
      return BuildQueueState.Ruins
    elseif 0 < buildData.updateTime then
      return BuildQueueState.UPGRADE
    end
    local buildId = buildData.itemId
    local queueType = self:GetNewQueueTypeByBuildId(buildId)
    if queueType ~= nil then
      if queueType == NewQueueType.Science then
        local queue = DataCenter.QueueDataManager:GetQueueByBuildUuidForScience(uuid)
        if queue ~= nil and queue:GetQueueState() == NewQueueState.Work then
          return BuildQueueState.RESEARCH
        end
      else
        local queue = DataCenter.QueueDataManager:GetQueueByType(queueType)
        if queue ~= nil and queue:GetQueueState() == NewQueueState.Work then
          if queueType == NewQueueType.FootSoldier or queueType == NewQueueType.CarSoldier or queueType == NewQueueType.BowSoldier then
            return BuildQueueState.TRAINING
          elseif queueType == NewQueueType.Hospital then
            return BuildQueueState.CURE_ARMY
          elseif queueType == NewQueueType.RebirthHospital then
            return BuildQueueState.REBIRTH_ARMY
          end
        end
      end
    end
    local state = DataCenter.FactoryDataManager:GetFactoryStateByBuildUuid(uuid)
    if state == FactoryWorkState.Work then
      return BuildQueueState.FACTORY
    end
  end
  return BuildQueueState.DEFAULT
end

local function SetCurStamina(self)
  self.curMainBuildStamina = LuaEntry.Player:GetCurStamina()
end

local function CanPutLv0(self, buildId)
  local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  return template ~= nil and template.put == BuildPutType.Lv0
end

local function CheckBuildUpgradeResAndItem(self, bUuid)
  local stockInfo = DataCenter.BuildUpgradeStockManager:GetUpgradeStockById(bUuid)
  local buildData = self.allBuilding[bUuid]
  local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level)
  local lackResourceList = {}
  local lackResourceDict = {}
  local hasResource = false
  local allSubmit = true
  local gotoBtnWink = true
  local needPeopleNum = 0
  local needResource, needItem, needResItem
  if buildLevelTemplate then
    needPeopleNum = buildLevelTemplate:GetNeedPeopleNum()
  end
  local lackPeopleNum = false
  if 0 < needPeopleNum then
    local resourceType = ResourceType.People
    lackPeopleNum = needPeopleNum > LuaEntry.Resource:GetCntByResType(resourceType)
    if lackPeopleNum then
      lackResourceDict[resourceType] = needPeopleNum
      table.insert(lackResourceList, {resourceType = resourceType, count = needPeopleNum})
      hasResource = true
      allSubmit = false
    end
  end
  if buildLevelTemplate then
    needResource = buildLevelTemplate:GetNeedResource()
  end
  if needResource ~= nil then
    for _, v in ipairs(needResource) do
      local need = v.count
      if stockInfo ~= nil then
        need = need - stockInfo:GetSubmitCountByResource(v.resourceType)
      end
      if 0 < need then
        allSubmit = false
        local own = LuaEntry.Resource:GetCntByResType(v.resourceType)
        if need > own then
          lackResourceDict[v.resourceType] = need
          table.insert(lackResourceList, {
            resourceType = v.resourceType,
            count = need
          })
        else
          gotoBtnWink = gotoBtnWink and false
        end
      end
      hasResource = true
    end
  end
  local noBuyItemId
  local lackItemList = {}
  local lackItemDict = {}
  local hasItem = false
  if buildLevelTemplate then
    needItem = buildLevelTemplate:GetNeedItem()
  end
  if needItem ~= nil then
    for _, v in ipairs(needItem) do
      local need = v.num
      if stockInfo ~= nil then
        need = need - stockInfo:GetSubmitCountByItem(v.itemId)
      end
      if 0 < need then
        allSubmit = false
        local own = DataCenter.ItemData:GetItemCount(v.itemId)
        if need > own then
          lackItemDict[v.itemId] = need
          table.insert(lackItemList, {
            itemId = v.itemId,
            count = need
          })
          local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(v.itemId)
          if itemTemplate == nil or 0 >= itemTemplate.price then
            noBuyItemId = v.itemId
          end
        else
          gotoBtnWink = gotoBtnWink and false
        end
      end
      hasItem = true
    end
  end
  local noBuyResItemId
  local lackResItemList = {}
  local lackResItemDict = {}
  local hasResItem = false
  if buildLevelTemplate then
    needResItem = buildLevelTemplate:GetNeedResourceItem()
  end
  if needResItem ~= nil then
    for _, v in ipairs(needResItem) do
      local need = v.count
      if stockInfo ~= nil then
        need = need - stockInfo:GetSubmitCountByResourceItem(v.itemId)
      end
      if 0 < need then
        allSubmit = false
        local own = DataCenter.ResourceItemDataManager:GetCountByItemId(v.itemId)
        if need > own then
          lackResItemDict[v.itemId] = need
          table.insert(lackResItemList, {
            itemId = v.itemId,
            count = need
          })
          local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(v.itemId)
          if template == nil or 0 >= template.price then
            noBuyResItemId = v.itemId
          end
        else
          gotoBtnWink = gotoBtnWink and false
        end
      end
      hasResItem = true
    end
  end
  local ret = {}
  ret.enough = table.count(lackResourceList) + table.count(lackItemList) + table.count(lackResItemList) == 0
  ret.needPeopleNum = needPeopleNum
  ret.needResource = needResource
  ret.needItem = needItem
  ret.needResItem = needResItem
  ret.lackPeopleNum = lackPeopleNum
  ret.lackResourceList = lackResourceList
  ret.lackResourceDict = lackResourceDict
  ret.lackItemList = lackItemList
  ret.lackItemDict = lackItemDict
  ret.lackResItemList = lackResItemList
  ret.lackResItemDict = lackResItemDict
  ret.hasResource = hasResource
  ret.hasItem = hasItem
  ret.hasResItem = hasResItem
  ret.noBuyItemId = noBuyItemId
  ret.noBuyResItemId = noBuyResItemId
  ret.allSubmit = allSubmit
  ret.gotoBtnWink = gotoBtnWink
  ret.buildId = buildData.itemId
  return ret
end

local function GetMainUpgradeNeedItemCount(self)
  local buildData = self:GetMaxLvBuildDataByBuildId(BuildingTypes.FUN_BUILD_MAIN)
  local ret = self:CheckBuildUpgradeResAndItem(buildData.uuid)
  local count = 0
  for _, v in ipairs(ret.needItem) do
    count = count + v.num
  end
  return count or 0
end

local function GetProductResItemBuildingTypes(self)
  return ProductResourceItemBuildingTypes
end

function BuildManager:CanUseDiamondBuyItem()
  local useDiamondLevel = LuaEntry.DataConfig:TryGetNum("building_base", "k13")
  return useDiamondLevel <= self.MainLv
end

function BuildManager:GetOwnNumByBuildIdAndLevel(buildId, level)
  local result = 0
  local list = self:GetAllBuildingByItemIdWithoutPickUp(buildId)
  if list ~= nil then
    for k, v in ipairs(list) do
      if level <= v.level then
        result = result + 1
      end
    end
  end
  return result
end

function BuildManager:BackBuildingCollectTimeMessageHandle(message)
  if message.errorCode == nil then
    if message.buildInfo ~= nil then
      local dic = message.buildInfo
      if dic ~= nil then
        local bUuid = dic.uuid
        self:AddBuilding(dic)
        EventManager:GetInstance():Broadcast(EventId.UPDATE_BUILD_DATA, bUuid)
      end
    end
  else
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
  end
  if DataCenter.GuideManager:GetGuideType() == GuideType.BackBuildCollectTime then
    DataCenter.GuideManager:DoNext()
  end
end

local function UpdatePeopleByBuildReward(self, reward, pos)
  if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIBuildUpgradeSuccess) then
    local param = {}
    param.list = {
      ResourceType.People
    }
    param.uiName = UIWindowNames.UIBuildUpgradeSuccess
    param.noUseResetResource = true
    param.hideBtnList = {
      UIMainTopBtnType.Stamina
    }
    EventManager:GetInstance():Broadcast(EventId.ShowMainUIExtraResource, param)
    TimerManager:GetInstance():DelayInvoke(function()
      EventManager:GetInstance():Broadcast(EventId.HideMainUIExtraResource, UIWindowNames.UIBuildUpgradeSuccess)
    end, 5)
  end
  TimerManager:GetInstance():DelayInvoke(function()
    LuaEntry.Resource:UpdateResource({
      people = reward.total
    })
  end, 1)
  UIUtil.DoFly(RewardType.PEOPLE, 5, DataCenter.ResourceManager:GetResourceIconByType(ResourceType.People), CS.SceneManager.World:WorldToScreenPoint(pos), Vector3.New(0, 0, 0))
end

function BuildManager:AfterBuildFinishShowEffect(uuid, rewards, onceAddExp)
  local buildData = self:GetBuildingDataByUuid(uuid)
  if buildData ~= nil then
    local buildId = buildData.itemId
    local level = buildData.level
    self:FlyExp(uuid, buildId)
    self:CheckGetNewBuildSendMessage(buildId, level, uuid)
    if buildId == BuildingTypes.FUN_BUILD_MAIN then
      if level == 10 then
        local ok, errorMsg = xpcall(function()
          CS.GameEntry.Sdk:LogEventLevelUp(level)
          return true
        end, debug.traceback)
      end
    elseif buildId == BuildingTypes.FUN_BUILD_TRADING_CENTER then
      local pos = SceneUtils.TileIndexToWorld(buildData.pointId)
      local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
      local str = string.split(levelTemplate.para5, ";")
      local add = 0
      if level == 1 then
        add = tonumber(str[1])
      else
        local lastLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level - 1)
        local strLast = string.split(lastLevelTemplate.para5, ";")
        add = tonumber(str[1]) - tonumber(strLast[1])
      end
      local param = {}
      param.type = 0
      param.icon = string.format(LoadPath.UIHeroStation, "UIappoint_icon_01")
      param.name = 162103
      param.pos = CS.SceneManager.World:WorldToScreenPoint(pos)
      SceneUtils.ReturnPoolV3(pos)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIResourceGetTip, {anim = true}, add, tonumber(str[1]), tonumber(str[2]), tonumber(str[2]), param)
    else
      local template = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
      if template and not self.isCheck then
        local effect = template.building_effect_last
        for i, v in pairs(effect) do
          if i == EffectDefine.BUILD_TIME_REDUCE then
            local effectTime = LuaEntry.Effect:GetGameEffect(EffectDefine.BUILD_TIME_REDUCE)
            if 0 < effectTime then
              self.isCheck = true
              UIManager:GetInstance():OpenWindow(UIWindowNames.UIUnLockNewFunc, {anim = true})
              return
            end
          end
        end
      end
    end
    local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
    self:OpenUpgradeSuccess(buildId, level, uuid, rewards, onceAddExp)
    if self:CheckShowUnlock(buildId, level) == false then
      EventManager:GetInstance():Broadcast(EventId.ShowPower, RewardType.POWER)
    end
  end
end

function BuildManager.WorldBuildInViewSignal(bUuid)
  DataCenter.BuildManager:AddOneWorldBuildInView(bUuid)
  DataCenter.WorldBuildTimeManager:BuildInViewSignal(bUuid)
end

function BuildManager.WorldBuildOutViewSignal(bUuid)
  DataCenter.BuildManager:RemoveOneWorldBuildInView(bUuid)
  DataCenter.WorldBuildTimeManager:BuildOutViewSignal(bUuid)
end

function BuildManager:AddOneWorldBuildInView(bUuid)
  self.inViewWorldBuild[bUuid] = true
end

function BuildManager:RemoveOneWorldBuildInView(bUuid)
  self.inViewWorldBuild[bUuid] = nil
end

function BuildManager:IsWorldBuildInView(bUuid)
  return self.inViewWorldBuild[bUuid] ~= nil
end

function BuildManager.OnBuildHeroCountdownStateChange(bUuid)
  DataCenter.BuildBubbleManager:CheckShowBubble(bUuid)
  DataCenter.BuildTimeManager:BuildInViewSignal(bUuid)
end

local function GetBuildLevelTemplateByUuid(self, bUuid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildData == nil then
    return nil
  end
  local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level)
  return buildLevelTemplate
end

local function GetBuildingCountByType(self, buildType)
  local count = 0
  for k, v in pairs(self.allBuilding) do
    if v.itemId == buildType then
      count = count + 1
    end
  end
  return count
end

local function HandleProduceBuildingUpgrade(self, message)
  local bUuid = 0
  if message.buildInfo ~= nil then
    local dic = message.buildInfo
    if dic ~= nil then
      bUuid = dic.uuid
      self:AddBuilding(dic)
      EventManager:GetInstance():Broadcast(EventId.UPDATE_BUILD_DATA, bUuid)
    end
  end
end

local function GetBuildingNameByUuid(self, bUuid)
  local buildingName = ""
  local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildingData ~= nil then
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildingData.itemId, buildingData.level)
    if buildTemplate ~= nil then
      buildingName = Localization:GetString(buildTemplate.name)
    end
  end
  return buildingName
end

local function GetMainLevel(self)
  return self.MainLv
end

function BuildManager:GetDecorateByState(state, isNot)
  local decoratelist = {}
  if state then
    for j, list in pairs(self.allDecorate) do
      for i, v in pairs(list) do
        if isNot then
          if v.state ~= state then
            table.insert(decoratelist, v)
          end
        elseif v.state == state then
          table.insert(decoratelist, v)
        end
      end
    end
  else
    decoratelist = DeepCopy(self.allDecorate)
  end
  return decoratelist
end

function BuildManager:GetDecorationTypeCountByQuality(quality)
  local retList = {}
  for buildId, list in pairs(self.allDecorate) do
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
    if tonumber(buildTemplate.para3) == quality then
      if retList[buildId] == nil then
        retList[buildId] = 1
      else
        retList[buildId] = retList[buildId] + 1
      end
    end
  end
  return table.count(retList)
end

function BuildManager:GetBuildQueueByUuid(uuid)
  local buildData = self:GetBuildingDataByUuid(uuid)
  if buildData ~= nil then
    local buildId = buildData.itemId
    local queueType = self:GetNewQueueTypeByBuildId(buildId)
    if queueType ~= nil then
      if queueType == NewQueueType.Science then
        local queue = DataCenter.QueueDataManager:GetQueueByBuildUuidForScience(uuid)
        return queue
      else
        local queue = DataCenter.QueueDataManager:GetQueueByType(queueType)
        return queue
      end
    end
  end
  return nil
end

function BuildManager:GetAllDecoPropertyMap()
  local retList = {}
  for buildBaseId, list in pairs(self.allDecorate) do
    for k, v in pairs(list) do
      if v.state == BuildingStateType.Normal then
        local buildingId = v.itemId
        local level = v.level
        local progress = v.prodStatus or 0
        local effectList = BuildingUtils.GetDecorationProgressEffectInfo(buildingId, level, progress)
        table.walk(effectList, function(k1, v1)
          if k1 == 75950 then
            k1 = 75949
          end
          local effectTemp = DataCenter.EffectNumberTemplateManager:GetTemplate(k1)
          local type = effectTemp.display_type_gallery
          local effectTypeList
          if retList[type] ~= nil then
            effectTypeList = retList[type]
          else
            effectTypeList = {}
            retList[type] = effectTypeList
          end
          if effectTypeList[k1] then
            effectTypeList[k1] = effectTypeList[k1] + v1
          else
            effectTypeList[k1] = v1
          end
        end)
      end
    end
  end
  return retList
end

function BuildManager:IsCanUpgradeDecoration(baseBuildingId, level, containGlue)
  local buildingData = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(baseBuildingId, level)
  local levelOneBuildingData = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(baseBuildingId, 1)
  local upgradeNeedCount = 0
  local hasCount = 0
  local UseNewDecorationCountLogic = DataCenter.BuildManager:UseNewDecorationCountLogic()
  if 0 < levelOneBuildingData.equal_glue_value then
    upgradeNeedCount = (tonumber(buildingData.para2) or 0) * levelOneBuildingData.equal_glue_value
    hasCount = containGlue and DataCenter.ItemData:GetItemCount(GLUE_GOOD_ID) or 0
    if self.allDecorate[baseBuildingId] then
      local haveList = self.allDecorate[baseBuildingId]
      table.walk(haveList, function(k, v)
        local tempBuildingData = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(baseBuildingId, v.level)
        if UseNewDecorationCountLogic and v.state == BuildingStateType.FoldUp then
          hasCount = hasCount + (tonumber(tempBuildingData.para1) or 0) * levelOneBuildingData.equal_glue_value * v:GetDecorNum()
        else
          hasCount = hasCount + (tonumber(tempBuildingData.para1) or 0) * levelOneBuildingData.equal_glue_value
        end
      end)
    end
    hasCount = hasCount - (tonumber(buildingData.para1) or 0) * levelOneBuildingData.equal_glue_value
  else
    upgradeNeedCount = tonumber(buildingData.para2) or 0
    if self.allDecorate[baseBuildingId] then
      local haveList = self.allDecorate[baseBuildingId]
      table.walk(haveList, function(k, v)
        local tempBuildingData = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(baseBuildingId, v.level)
        if UseNewDecorationCountLogic then
          if v.state == BuildingStateType.FoldUp then
            hasCount = hasCount + (tonumber(tempBuildingData.para1) or 0) * v:GetDecorNum()
          else
            hasCount = hasCount + (tonumber(tempBuildingData.para1) or 0)
          end
        else
          hasCount = hasCount + (tonumber(tempBuildingData.para1) or 0)
        end
      end)
    end
    hasCount = hasCount - (tonumber(buildingData.para1) or 0)
  end
  return hasCount, upgradeNeedCount
end

function BuildManager:IsDecorationExistInCity(baseBuildingId)
  local ret = false
  if self.allDecorate[baseBuildingId] then
    local haveList = self.allDecorate[baseBuildingId]
    table.walk(haveList, function(k, v)
      if v.state == BuildingStateType.Normal then
        ret = true
      end
    end)
  end
  return ret
end

function BuildManager:IsDecoratorHasRedDot(quality)
  local baseBuildingIdMap = DataCenter.BuildTemplateManager:GetNoBuyDecorateDataListByQuality()
  for k, v in pairs(baseBuildingIdMap) do
    local hasBuilding = self:HasBuilding(k, true)
    if hasBuilding then
      local buildData = self:GetMaxLvBuildDataByBuildId(k, true)
      local buildDataExist = self:GetMaxLvBuildDataByBuildId(k, false)
      local buildDesTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(k)
      if buildData and (quality == nil or tonumber(buildDesTemplate.para3) == quality) then
        local lvTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level)
        local groupId = 0
        if lvTemplate then
          groupId = lvTemplate.decoGroupUpgradeBaseId or 0
        end
        local isAdvanceUpgrade = 0 < groupId
        local hasCount, needCountWithoutGlue = DataCenter.BuildManager:IsCanUpgradeDecoration(buildData.itemId, buildData.level, false)
        if not isAdvanceUpgrade then
          if needCountWithoutGlue <= hasCount and buildData.level < buildDesTemplate.max_level or buildData.state == BuildingStateType.FoldUp and (buildDataExist == nil or buildData.level > buildDataExist.level) then
            return true
          end
        else
          local curProgress = buildData.prodStatus or 0
          local curProgressInfo = DataCenter.DecorationUpgradeTemplateManager:GetLvAndStageInfoByProgress(groupId, buildData.level, curProgress)
          if curProgressInfo then
            local upgradeCostItem = toInt(curProgressInfo.cost_item)
            if hasCount >= upgradeCostItem then
              return true
            end
          end
        end
      end
    end
  end
  return false
end

function BuildManager:GetAllDecoratorBuildingData()
  return self.allDecorate
end

function BuildManager:UseNewDecorationCountLogic()
  if self.useNewDecorationCountLogicValue ~= -1 then
    if self.useNewDecorationCountLogicValue == 0 then
      return false
    end
    if self.useNewDecorationCountLogicValue == 1 then
      return true
    end
    if self.useNewDecorationCountLogicValue == 2 then
      return 0 < LuaEntry.Player:GetGMFlag()
    end
  end
  return false
end

function BuildManager:HandleDecorationUpgradeMessage(msg)
  if msg == nil then
    return
  end
  local newBuildInfo = msg.buildInfo
  local useNewDecorationCountLogic = self:UseNewDecorationCountLogic()
  if not useNewDecorationCountLogic then
    local deleteBuildInfo = msg.delete
    if deleteBuildInfo then
      for i, info in pairs(deleteBuildInfo) do
        DataCenter.BuildManager:RemoveBuilding(info.needRemove)
      end
    end
  else
    local buildId = 0
    if newBuildInfo and self.allBuilding ~= nil and newBuildInfo.uuid ~= nil then
      local buildInfo = self.allBuilding[newBuildInfo.uuid]
      if buildInfo ~= nil then
        buildId = buildInfo.itemId
      end
    end
    local deleteBuildInfo = msg.deleteNewArr
    if deleteBuildInfo ~= nil and 0 < buildId then
      local baseBuildId = buildId // BuildLevelCap * BuildLevelCap
      local dataList = DataCenter.BuildManager:GetFoldUpBuildByBuildId(baseBuildId)
      if dataList then
        for _, v in pairs(deleteBuildInfo) do
          local dataCount = #dataList
          for index = 1, dataCount do
            if dataList[index] ~= nil and dataList[index].level == v.lv then
              local oldNum = dataList[index]:GetDecorNum()
              if oldNum ~= -1 then
                local newNum = math.max(0, oldNum - v.num)
                if newNum <= 0 then
                  DataCenter.BuildManager:RemoveBuilding(dataList[index].uuid)
                else
                  dataList[index].decorNum = newNum
                end
              end
            end
          end
        end
      end
    end
  end
  if newBuildInfo then
    DataCenter.BuildManager:AddBuilding(newBuildInfo)
  end
  EventManager:GetInstance():Broadcast(EventId.DecorateRedPoint)
end

local BLOCK_GATE_ZOMBIE_BUILDINGS = {
  [BuildingTypes.LW_BUILD_BLACKMARKET] = true,
  [BuildingTypes.LW_BUILD_ARMY_YARD_MUMMY_S3] = true,
  [BuildingTypes.LW_BUILD_ARMY_YARD_MUMMY_S4] = true,
  [BuildingTypes.LW_BUILD_ARMY_YARD_MUMMY_S5] = true,
  [BuildingTypes.LW_BUILD_ARMY_YARD_MUMMY_S6] = true
}

function BuildManager:RefreshBuildingStateByType(buildingType)
  for k, v in pairs(self.allBuilding) do
    if v.itemId == buildingType then
      local changed = v:ClientRefreshBuildingState()
      if changed then
        EventManager:GetInstance():Broadcast(EventId.UPDATE_BUILD_DATA, k)
        self:OnBuildingStateChange(v)
      end
    end
  end
end

function BuildManager:OnBuildingStateChange(buildingInfo)
  if not buildingInfo then
    return
  end
  if BLOCK_GATE_ZOMBIE_BUILDINGS[buildingInfo.itemId] then
    local pointId = buildingInfo.pointId
    local buildDesTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildingInfo.itemId)
    if not buildDesTemplate then
      return
    end
    local tileX, tileY = buildDesTemplate.tileX, buildDesTemplate.tileY
    if buildingInfo.state == BuildingStateType.FoldUp then
      DataCenter.LWGateDefenceManager:RemoveBlockRangeForGameRange(pointId, tileX + 3, tileY + 4)
    else
      DataCenter.LWGateDefenceManager:AddBlockRangeForGameRange(pointId, tileX + 3, tileY + 4)
    end
  end
end

function BuildManager:UpdateFurnaceData(t)
  if t and t.building_uuid then
    local data = self.buildingExtData[t.building_uuid]
    if data == nil then
      data = {}
      self.buildingExtData[t.building_uuid] = data
    end
    data.uuid = t.building_uuid
    data.startTime = t.state_time
    data.state = t.state
    data.endTime = t.burning_end_time
    data.settingState = t.auto_open
  end
  EventManager:GetInstance():Broadcast(EventId.BUILDING_FURNACE_DATA_UPDATE)
end

function BuildManager:UpdateFurnaceSettingData(t)
  if t and self.buildingExtData then
    for key, value in pairs(self.buildingExtData) do
      value.settingState = t.auto
    end
  end
  EventManager:GetInstance():Broadcast(EventId.BUILDING_FURNACE_SETTING_DATA_UPDATE)
end

function BuildManager:GetFurnaceData(uuid)
  return self.buildingExtData[uuid]
end

function BuildManager:GetFurnaceStateAndTemp()
  local furnace = self:GetFunbuildByItemID(BuildingTypes.LW_BUILDING_SEASON2_PERSONAL_FURNACE)
  if furnace then
    local furnaceData = self.buildingExtData[furnace.uuid]
    if furnaceData then
      local state = furnaceData.state
      local meta = DataCenter.HeatSourceTemplateManager:GetPersonalStoveTemplateByLevel(furnace.level)
      if meta then
        local temp = meta:GetTemperatureByState(state)
        if state == HeatSourceState.Overload then
          local effectValue = LuaEntry.Effect:GetGameEffect(EffectDefine.PERSONAL_STOVE_OVERLOAD_ADD_94105)
          if 0 < effectValue then
            temp = temp + effectValue
            return state, temp, meta, {
              [EffectDefine.PERSONAL_STOVE_OVERLOAD_ADD_94105] = effectValue
            }
          end
        end
        return state, temp, meta
      end
    end
  end
  return HeatSourceState.None, 0, nil
end

function BuildManager:GetVictoryTowerTemp()
  local tower = self:GetFunbuildByItemID(BuildingTypes.LW_BUILD_DECORATION)
  if tower and tower.state ~= BuildingStateType.FoldUp then
    local meta = DataCenter.HeatSourceTemplateManager:GetVictoryTowerTemplateByLevel(tower.level)
    if meta then
      local temp = meta:GetTemperatureByState()
      return temp, meta
    end
  end
  return 0, nil
end

function BuildManager:UpdateBuildingTimeByUuid(uuid, updateTime)
  if self.allBuilding[uuid] then
    self.allBuilding[uuid].updateTime = updateTime
  end
end

function BuildManager:GetMaxLevelUpgradeFinishBuild()
  local buildIdList = DataCenter.BuildManager:GetAllBuildUuid()
  local targetData
  for k, v in pairs(buildIdList) do
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(v)
    if buildData:IsUpgradeFinish() then
      if targetData == nil then
        targetData = buildData
      elseif targetData.level < buildData.level then
        targetData = buildData
      end
    end
  end
  return targetData
end

function BuildManager:SetShakeCollectCheckList(idList)
  if idList then
    self.shakeCollectCheckList = idList
  end
end

function BuildManager:CheckCanShakeCollect(id)
  if self.shakeCollectCheckList and #self.shakeCollectCheckList > 0 then
    for k, v in pairs(self.shakeCollectCheckList) do
      if id == v then
        return true
      end
    end
  end
  if BuildingUtils.IsSeasonInCityBuilding(id) then
    local buildList = BuildingUtils.GetSeasonBuildingGroupByType(id)
    for k, v in pairs(buildList) do
      if id == v.itemId then
        return true
      end
    end
  end
  return false
end

function BuildManager:HaveRedDotBattleCenterBuilding()
  local buildIds = DataCenter.BuildTemplateManager:GetBuildListIds()
  local target = DataCenter.LoginGuideManager.battleCenterBuildId
  if buildIds[UIBuildListTabType.Military] ~= nil then
    local allList = buildIds[UIBuildListTabType.Military]
    for _, data in ipairs(allList) do
      local redDotType = data.buildTemplate.red_dot
      local id = data.id
      if target == id then
        if redDotType == BuildRedDotType.No or redDotType == BuildRedDotType.Once and not self:IsShowRedDotByOnce(id) then
          return nil
        else
          local state = self:GetBuildState(id)
          if state == BuildState.BUILD_LIST_STATE_OK or state == BuildState.BUILD_LIST_LACK_RESOURCE or state == BuildState.BUILD_LIST_LACK_PEOPLE then
            return data.id
          end
        end
      end
    end
  end
  return nil
end

BuildManager.__init = __init
BuildManager.__delete = __delete
BuildManager.Startup = Startup
BuildManager.InitData = InitData
BuildManager.UpdateBuildings = UpdateBuildings
BuildManager.BuildCcdMNewHandle = BuildCcdMNewHandle
BuildManager.GetBuildIdByNewQueue = GetBuildIdByNewQueue
BuildManager.AddListener = AddListener
BuildManager.RemoveListener = RemoveListener
BuildManager.AddOneBuildInView = AddOneBuildInView
BuildManager.RemoveOneBuildInView = RemoveOneBuildInView
BuildManager.BuildInViewSignal = BuildInViewSignal
BuildManager.BuildOutViewSignal = BuildOutViewSignal
BuildManager.IsBuildInView = IsBuildInView
BuildManager.GetBuildState = GetBuildState
BuildManager.GetBuildIconPath = GetBuildIconPath
BuildManager.GetExtraCanBuildNum = GetExtraCanBuildNum
BuildManager.FreeBuildingFoldUpNewHandle = FreeBuildingFoldUpNewHandle
BuildManager.FreeBuildingUpNewHandle = FreeBuildingUpNewHandle
BuildManager.FreeBuildingExpendDomeHandle = FreeBuildingExpendDomeHandle
BuildManager.HasBuildByIdAndLevel = HasBuildByIdAndLevel
BuildManager.GetCanUpgradeBuildUuidList = GetCanUpgradeBuildUuidList
BuildManager.GetCanUpgradeBuildUuidListFilterd = GetCanUpgradeBuildUuidListFilterd
BuildManager.GetBuildCanUpgrade = GetBuildCanUpgrade
BuildManager.ShowBuildCanUpgradeBubble = ShowBuildCanUpgradeBubble
BuildManager.GetBuildCanJoinRoad = GetBuildCanJoinRoad
BuildManager.GetCanJoinRoadBuildUuidList = GetCanJoinRoadBuildUuidList
BuildManager.GetBuildId = GetBuildId
BuildManager.GetBuildLevel = GetBuildLevel
BuildManager.GetEffectNumWithType = GetEffectNumWithType
BuildManager.CheckShowBuildAddDes = CheckShowBuildAddDes
BuildManager.IsShowBuildRedDot = IsShowBuildRedDot
BuildManager.IsShowRedDotByOnce = IsShowRedDotByOnce
BuildManager.CanShowUnlock = CanShowUnlock
BuildManager.GetBuildRedDotByTabType = GetBuildRedDotByTabType
BuildManager.IsShowRedDotByTemplateAndState = IsShowRedDotByTemplateAndState
BuildManager.IsDecorateBuildingShowRedDotByTemplateAndState = IsDecorateBuildingShowRedDotByTemplateAndState
BuildManager.SetBuildRedDotOnce = SetBuildRedDotOnce
BuildManager.SetBuildShowUnlock = SetBuildShowUnlock
BuildManager.PushInitBuildHandle = PushInitBuildHandle
BuildManager.PushBuildUpgradeFinishHandle = PushBuildUpgradeFinishHandle
BuildManager.UILoadingExitSignal = UILoadingExitSignal
BuildManager.GetResourceTypeByBuildId = GetResourceTypeByBuildId
BuildManager.PushBuildingInfoHandle = PushBuildingInfoHandle
BuildManager.PushAddBuildingHandle = PushAddBuildingHandle
BuildManager.HandleBuildingInfos = HandleBuildingInfos
BuildManager.GetOutResourceTypeByBuildId = GetOutResourceTypeByBuildId
BuildManager.GetUseResourceTypeByBuildId = GetUseResourceTypeByBuildId
BuildManager.UserResupplyBuildingHandle = UserResupplyBuildingHandle
BuildManager.UserResSynNewHandle = UserResSynNewHandle
BuildManager.ShowGetResourceEffect = ShowGetResourceEffect
BuildManager.isReachMax = isReachMax
BuildManager.WorldMvHandle = WorldMvHandle
BuildManager.ReceiveBuildingGrowValRewardHandle = ReceiveBuildingGrowValRewardHandle
BuildManager.IsCanOutItemByBuildId = IsCanOutItemByBuildId
BuildManager.IsHaveResource = IsHaveResource
BuildManager.IsHaveItem = IsHaveItem
BuildManager.GetShowBubbleTime = GetShowBubbleTime
BuildManager.GetShowItemBubbleTime = GetShowItemBubbleTime
BuildManager.GetOutResourceNum = GetOutResourceNum
BuildManager.GetCollectMaxEffectByBuildId = GetCollectMaxEffectByBuildId
BuildManager.GetReduceFactoryTimeEffectByBuildId = GetReduceFactoryTimeEffectByBuildId
BuildManager.GetWorldTileBtnTypeByBuildId = GetWorldTileBtnTypeByBuildId
BuildManager.GetCanGetResourceBuildUuidByResourceType = GetCanGetResourceBuildUuidByResourceType
BuildManager.GetSelfBuildMinLevel = GetSelfBuildMinLevel
BuildManager.GetBuildMinLevel = GetBuildMinLevel
BuildManager.FreeBuildingUpgradeFinishHandle = FreeBuildingUpgradeFinishHandle
BuildManager.CheckSendBuildFinish = CheckSendBuildFinish
BuildManager.ShowGetNewResourceEffect = ShowGetNewResourceEffect
BuildManager.IsCanUpgradeZeroBuild = IsCanUpgradeZeroBuild
BuildManager.FreeBuildingPlaceMainBuildingHandle = FreeBuildingPlaceMainBuildingHandle
BuildManager.CheckShowUnlock = CheckShowUnlock
BuildManager.CheckBuildingUnlockWithPreBuildAndScience = CheckBuildingUnlockWithPreBuildAndScience
BuildManager.CheckShowBuildUnlockWhenScienceLevelUp = CheckShowBuildUnlockWhenScienceLevelUp
BuildManager.CheckShowFarmUnlockWhenReceiveLevelReward = CheckShowFarmUnlockWhenReceiveLevelReward
BuildManager.CheckShowBuildUnlockWhenReceiveLevelReward = CheckShowBuildUnlockWhenReceiveLevelReward
BuildManager.BuildCityBuildingHandle = BuildCityBuildingHandle
BuildManager.HasResourceBuildingFull = HasResourceBuildingFull
BuildManager.IsResourceBuildingFull = IsResourceBuildingFull
BuildManager.GetAllResourceBuildingFullLatestTime = GetAllResourceBuildingFullLatestTime
BuildManager.UpdateBuildDataSignal = UpdateBuildDataSignal
BuildManager.LoadNoShowUnlock = LoadNoShowUnlock
BuildManager.SaveNoShowUnlock = SaveNoShowUnlock
BuildManager.ShowBuildErrorCode = ShowBuildErrorCode
BuildManager.FindMainBuildInitPositionHandle = FindMainBuildInitPositionHandle
BuildManager.FreeBuildingPlaceNewHandle = FreeBuildingPlaceNewHandle
BuildManager.FreeBuildingReplaceNewHandle = FreeBuildingReplaceNewHandle
BuildManager.AddOneChangeMoveBuild = AddOneChangeMoveBuild
BuildManager.GetOneAndRemoveMoveBuild = GetOneAndRemoveMoveBuild
BuildManager.BuildWorldMoveNewHandle = BuildWorldMoveNewHandle
BuildManager.CanFastBuild = CanFastBuild
BuildManager.GetFastBuildDataList = GetFastBuildDataList
BuildManager.GetBuildExp = GetBuildExp
BuildManager.FlyExp = FlyExp
BuildManager.SetNewUserWorld = SetNewUserWorld
BuildManager.IsInNewUserWorld = IsInNewUserWorld
BuildManager.GetMaxBuildingLevel = GetMaxBuildingLevel
BuildManager.GetBuildingDataByUuid = GetBuildingDataByUuid
BuildManager.GetAllBuildingByItemIdWithoutPickUp = GetAllBuildingByItemIdWithoutPickUp
BuildManager.AddBuilding = AddBuilding
BuildManager.RemoveBuilding = RemoveBuilding
BuildManager.GetFunbuildByItemID = GetFunbuildByItemID
BuildManager.HasBuilding = HasBuilding
BuildManager.GetMaxLvBuildDataByBuildId = GetMaxLvBuildDataByBuildId
BuildManager.GetUnlock2BuildByEffectAndType = GetUnlock2BuildByEffectAndType
BuildManager.IsExistBuildByTypeLv = IsExistBuildByTypeLv
BuildManager.GetAllBuildUuid = GetAllBuildUuid
BuildManager.GetFoldUpBuildByBuildId = GetFoldUpBuildByBuildId
BuildManager.DoActionForAllFoldupBuilding = DoActionForAllFoldupBuilding
BuildManager.GetHaveBuildNumWithOutFoldUpByBuildId = GetHaveBuildNumWithOutFoldUpByBuildId
BuildManager.GetCurMaxBuildNum = GetCurMaxBuildNum
BuildManager.GetMaxBuildNum = GetMaxBuildNum
BuildManager.AllianceHelpAddSpeed = AllianceHelpAddSpeed
BuildManager.OnAllianceCallHelp = OnAllianceCallHelp
BuildManager.GetAllInBaseTruckShowBuild = GetAllInBaseTruckShowBuild
BuildManager.GetPathTimeFromDroneToBuildTarget = GetPathTimeFromDroneToBuildTarget
BuildManager.GetPathTimeFromDroneToRoadTarget = GetPathTimeFromDroneToRoadTarget
BuildManager.GetBuildingDataByPointId = GetBuildingDataByPointId
BuildManager.GetAllBuildWithoutPickUp = GetAllBuildWithoutPickUp
BuildManager.PushBuildFoldUpHandle = PushBuildFoldUpHandle
BuildManager.CheckReplaceMain = CheckReplaceMain
BuildManager.PushBuildingConnectStatusHandle = PushBuildingConnectStatusHandle
BuildManager.ShowPickUpResourceEffect = ShowPickUpResourceEffect
BuildManager.GetPickResPath = GetPickResPath
BuildManager.GetArmyBuildMaxLevelData = GetArmyBuildMaxLevelData
BuildManager.SetShowPutBuildFromPanel = SetShowPutBuildFromPanel
BuildManager.GetShowPutBuildFromPanel = GetShowPutBuildFromPanel
BuildManager.IsShowDiamond = IsShowDiamond
BuildManager.GetResTypeByBuildUuid = GetResTypeByBuildUuid
BuildManager.CheckIsSendMessage = CheckIsSendMessage
BuildManager.DelayClearSendList = DelayClearSendList
BuildManager.IsShowBuildFlyPath = IsShowBuildFlyPath
BuildManager.FreeBuildingStartFixHandle = FreeBuildingStartFixHandle
BuildManager.FreeBuildingFinishFixHandle = FreeBuildingFinishFixHandle
BuildManager.CheckSendFixBuildFinish = CheckSendFixBuildFinish
BuildManager.CheckIsSendFixMessage = CheckIsSendFixMessage
BuildManager.DelayClearSendFixList = DelayClearSendFixList
BuildManager.OnAllianceCallFixHelp = OnAllianceCallFixHelp
BuildManager.AllianceHelpFixAddSpeed = AllianceHelpFixAddSpeed
BuildManager.GetGarageIndex = GetGarageIndex
BuildManager.GetCountry = GetCountry
BuildManager.PushBuildDeleteHandle = PushBuildDeleteHandle
BuildManager.GetFactoryUnlockItemKey = GetFactoryUnlockItemKey
BuildManager.GetFactoryUnlockItemLevel = GetFactoryUnlockItemLevel
BuildManager.SaveFactoryUnlockItemLevel = SaveFactoryUnlockItemLevel
BuildManager.CheckAndShowFactoryUnlockItem = CheckAndShowFactoryUnlockItem
BuildManager.GetBuildIdByPointId = GetBuildIdByPointId
BuildManager.SetShowCityLabel = SetShowCityLabel
BuildManager.UpgradeBuilding = UpgradeBuilding
BuildManager.CheckGetNewBuildSendMessage = CheckGetNewBuildSendMessage
BuildManager.IsFactoryBuild = IsFactoryBuild
BuildManager.CheckBuildIsReward = CheckBuildIsReward
BuildManager.ClickBubbleUpgradeReward = ClickBubbleUpgradeReward
BuildManager.GetEventStoreMax = GetEventStoreMax
BuildManager.GetBuildQueueState = GetBuildQueueState
BuildManager.GetNewQueueTypeByBuildId = GetNewQueueTypeByBuildId
BuildManager.SetCurStamina = SetCurStamina
BuildManager.CanPutLv0 = CanPutLv0
BuildManager.CheckBuildUpgradeResAndItem = CheckBuildUpgradeResAndItem
BuildManager.GetMainUpgradeNeedItemCount = GetMainUpgradeNeedItemCount
BuildManager.GetProductResItemBuildingTypes = GetProductResItemBuildingTypes
BuildManager.GetBuildTypesByOutResourceType = GetBuildTypesByOutResourceType
BuildManager.OpenUpgradeSuccess = OpenUpgradeSuccess
BuildManager.SetOnMovingBuildUuid = SetOnMovingBuildUuid
BuildManager.GetOnMovingBuildUuid = GetOnMovingBuildUuid
BuildManager.CheckShowReplaceTip = CheckShowReplaceTip
BuildManager.UpdatePeopleByBuildReward = UpdatePeopleByBuildReward
BuildManager.GetBuildLevelTemplateByUuid = GetBuildLevelTemplateByUuid
BuildManager.GetBuildingCountByType = GetBuildingCountByType
BuildManager.HandleProduceBuildingUpgrade = HandleProduceBuildingUpgrade
BuildManager.GetAllBuildData = GetAllBuildData
BuildManager.GetBuildingDatasByBuildingId = GetBuildingDatasByBuildingId
BuildManager.GetFirstRedDotBuildingId = GetFirstRedDotBuildingId
BuildManager.ShowUpLevelReward = ShowUpLevelReward
BuildManager.GetBuildingNameByUuid = GetBuildingNameByUuid
BuildManager.ShowBuildSpeedUpTips = ShowBuildSpeedUpTips
BuildManager.GetMainLevel = GetMainLevel
BuildManager.SetFarmBuild = SetFarmBuild
BuildManager.RefreshCityState = RefreshCityState
BuildManager.SyncBuildingDataToCSharp = SyncBuildingDataToCSharp
return BuildManager
