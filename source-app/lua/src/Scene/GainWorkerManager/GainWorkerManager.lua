local GainWorkerManager = BaseClass("GainWorkerManager")
local GainWorker = require("Scene.GainWorkerManager.GainWorker")
local AircraftBubbleUtil = require("Scene.GainWorkerManager.AircraftBubbleUtil")
local pveWorkerList = {}
local pveWorkerModelList = {}
local tempBuildingList = {}
local posList = {
  {
    pos = {
      x = 97,
      y = 0,
      z = 82
    }
  },
  {
    pos = {
      x = 99,
      y = 0,
      z = 90
    }
  },
  {
    pos = {
      x = 99,
      y = 0,
      z = 88
    }
  },
  {
    pos = {
      x = 99,
      y = 0,
      z = 86
    }
  },
  {
    pos = {
      x = 99,
      y = 0,
      z = 84
    }
  },
  {
    pos = {
      x = 99,
      y = 0,
      z = 82
    }
  }
}

local function AddListeners(self)
  EventManager:GetInstance():AddListener(EventId.BUILD_IN_VIEW, self.OnBuildInView)
  EventManager:GetInstance():AddListener(EventId.BUILD_OUT_VIEW, self.OnBuildOutView)
  EventManager:GetInstance():AddListener(EventId.OpeningStageSetup, self.OnOpeningStageSetup)
  EventManager:GetInstance():AddListener(EventId.OpeningStageClear, self.OnOpeningStageClear)
  EventManager:GetInstance():AddListener(EventId.OpeningStageMarchBegin, self.OnOpeningStageMarchBegin)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.BUILD_IN_VIEW, self.OnBuildInView)
  EventManager:GetInstance():RemoveListener(EventId.BUILD_OUT_VIEW, self.OnBuildOutView)
  EventManager:GetInstance():RemoveListener(EventId.OpeningStageSetup, self.OnOpeningStageSetup)
  EventManager:GetInstance():RemoveListener(EventId.OpeningStageClear, self.OnOpeningStageClear)
  EventManager:GetInstance():RemoveListener(EventId.OpeningStageMarchBegin, self.OnOpeningStageMarchBegin)
end

local function OnBuildInView(buildId)
  local info = DataCenter.BuildManager:GetBuildingDataByUuid(buildId)
  if info ~= nil and info.itemId == BuildingTypes.Lw_BUILD_BATTLE_FEATURE_ENTRY then
    DataCenter.GainWorkerManager:CreateTips()
  end
end

local function OnBuildOutView(buildId)
  local info = DataCenter.BuildManager:GetBuildingDataByUuid(buildId)
  if info ~= nil and info.itemId == BuildingTypes.Lw_BUILD_BATTLE_FEATURE_ENTRY then
    DataCenter.GainWorkerManager:RemoveAllModel()
  end
end

local function OnOpeningStageSetup(nextStageId)
  DataCenter.GainWorkerManager:CreateTips()
end

local function OnOpeningStageClear(nextStageId)
  DataCenter.GainWorkerManager:RemoveAllModel()
end

local function OnOpeningStageMarchBegin(nextStageId)
  DataCenter.GainWorkerManager.tipUtil:RemoveAllTip()
end

local function CreateTips(self)
  if self.tipUtil then
    self.tipUtil:CreateTips(pveWorkerList)
  end
end

local function __init(self)
  pveWorkerModelList = {}
  AddListeners(self)
  self.bubbleIsOn = true
  self.tipUtil = AircraftBubbleUtil:New()
end

local function GetRandomBlankIndex()
  local index = math.random(#posList)
  return index
end

local function GetWorkerDataIndex(workerData)
  for i = 1, #pveWorkerList do
    if pveWorkerList[i].uid == workerData.uid then
      return i
    end
  end
end

local function AddPveWorker(self, workerData)
  local index = GetWorkerDataIndex(workerData)
  if index then
    pveWorkerList[index] = workerData
  else
    table.insert(pveWorkerList, workerData)
  end
end

local function RemovePveWorker(self, workerData)
  local index = GetWorkerDataIndex(workerData)
  if index then
    table.remove(pveWorkerList, index)
    if self.tipUtil then
      self.tipUtil:RemoveTipByUid(workerData.uid)
      EventManager:GetInstance():Broadcast(EventId.GF_building_parkour_bubble_refresh, BuildingTypes.Lw_BUILD_BATTLE_FEATURE_ENTRY)
    end
  end
end

local function HasAnyWorker()
  return pveWorkerList ~= nil and 0 < #pveWorkerList
end

local function GetAllWorkers()
  return pveWorkerList
end

local function AddWorkerModel(worker)
  table.insert(pveWorkerModelList, worker)
end

local function GetModel(workerUid)
  for i = 1, #pveWorkerModelList do
    if pveWorkerModelList[i].data.workerData.uid == workerUid then
      return pveWorkerModelList[i]
    end
  end
end

local function RemoveWorkerModel(self, workerUid)
  local workerModel = GetModel(workerUid)
  if workerModel then
    self:ReduceTempBuilding(workerModel.data.buildData.uuid)
    workerModel:Delete()
  end
end

local function RemoveAllModel(self)
  for i = 1, #pveWorkerModelList do
    pveWorkerModelList[i]:Delete()
  end
  if self.tipUtil then
    self.tipUtil:RemoveAllTip()
  end
  pveWorkerModelList = {}
end

local function AddTempBuilding(buildingUuid)
  if tempBuildingList[buildingUuid] then
    tempBuildingList[buildingUuid] = tempBuildingList[buildingUuid] + 1
  else
    tempBuildingList[buildingUuid] = 1
  end
end

local function ReduceTempBuilding(buildingUuid)
  if tempBuildingList[buildingUuid] then
    tempBuildingList[buildingUuid] = tempBuildingList[buildingUuid] - 1
    if tempBuildingList[buildingUuid] == 0 then
      tempBuildingList[buildingUuid] = nil
    end
  end
end

local function GetWorkerExistBuild(workerData, birthPos)
  local lists = {}
  for i, v in ipairs(workerData.workingBuildList) do
    local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(v)
    for _, data in ipairs(buildList) do
      local temp = tempBuildingList[data.uuid] or 0
      local slot = data:GetEmptyWorkerSlot() or 0
      if temp == 0 and data.level == 0 and not data:IsUpgradeFinish() and not data:IsUpgrading() then
        slot = 1
      end
      if 0 < slot then
        if lists[data.level] == nil then
          lists[data.level] = {}
        end
        table.insert(lists[data.level], {data, slot})
      end
    end
  end
  for lv = 0, 30 do
    local list = lists[lv]
    if list ~= nil and 0 < #list then
      local minDist = 999999999
      local nearest
      for _, info in ipairs(list) do
        local data = info[1]
        local pos = data:GetCenterVec()
        local dist = Vector3.Distance(pos, birthPos)
        if minDist > dist then
          minDist = dist
          nearest = info
        end
      end
      if nearest then
        return nearest[1], nearest[2]
      end
    end
  end
  return nil
end

local function GetIsHavePveWorker()
  if pveWorkerList and 0 < #pveWorkerList then
    return #pveWorkerList
  end
end

local function ShowLandLockWorker(self, workerList, pos)
  local buildMain = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_MAIN)
  for i = 1, #workerList do
    local data = DataCenter.WorkerDataManager:GetWorkerDataByUid(workerList[i])
    local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(data.modelId)
    local workerCfg = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId)
    local buildData, slot = GetWorkerExistBuild(data, pos)
    local workerData = {}
    workerData.path = workerCfg.city_model_path
    workerData.birthPos = pos
    workerData.posList = {}
    workerData.buildData = buildData or buildMain[1]
    workerData.workingSlot = slot or 1
    workerData.targetPos = pos
    workerData.worker = workerCfg
    workerData.isGoworker = true
    workerData.workerData = data
    local delayTime = math.random(2000)
    local worker = GainWorker:New()
    worker:SetData(workerData)
    worker:CreateModel(nil, delayTime * 0.001)
    self:AddTempBuilding(workerData.buildData.uuid)
    AddWorkerModel(worker)
  end
end

local function ShowAllWorkers(self)
  local workerBuildDataList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.Lw_BUILD_BATTLE_FEATURE_ENTRY)
  local buildMain = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_MAIN)
  local cityObj = CS.SceneManager.World:GetBuildingByPoint(workerBuildDataList[1].pointId)
  local copterObj = cityObj.gameObject.transform:Find("ModelGo/Normal/A_build_tingjiping/army_t6_06c").gameObject
  if not copterObj.activeSelf then
    return
  end
  local p_entry = cityObj.gameObject.transform:Find("guildPosList")
  for i = #pveWorkerList, 1, -1 do
    local data = pveWorkerList[i]
    table.remove(pveWorkerList, i)
    local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(data.modelId)
    local workerCfg = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId)
    local buildData, slot = GetWorkerExistBuild(data, p_entry.transform.position)
    local workerData = {}
    workerData.path = workerCfg.city_model_path
    workerData.birthPos = p_entry.transform.position
    workerData.posList = {}
    workerData.buildData = buildData or buildMain[1]
    workerData.workingSlot = slot or 1
    workerData.targetPos = posList[GetRandomBlankIndex()].pos
    workerData.worker = workerCfg
    workerData.workerData = data
    local worker = GainWorker:New()
    worker:SetData(workerData)
    worker:CreateModel()
    self:AddTempBuilding(workerData.buildData.uuid)
    AddWorkerModel(worker)
  end
  local simAnim = cityObj.gameObject.transform:Find("ModelGo"):GetComponent(typeof(CS.SimpleAnimation))
  if simAnim:IsPlaying("joggle") then
    simAnim:Rewind("joggle")
  else
    simAnim:Play("joggle")
  end
  self.tipUtil:RemoveAllTip()
end

local function ShowWorker2(self, workerId, birthPos, targetPos)
  local data
  for i, v in ipairs(pveWorkerList) do
    if v.cfgId == workerId then
      table.remove(pveWorkerList, i)
      data = v
      break
    end
  end
  if data == nil then
    return
  end
  local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(data.modelId)
  local workerCfg = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId)
  local buildData, slot = GetWorkerExistBuild(data, birthPos)
  local buildMain = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_MAIN)
  local workerData = {}
  workerData.path = workerCfg.city_model_path
  workerData.birthPos = birthPos
  workerData.posList = {}
  workerData.buildData = buildData or buildMain[1]
  workerData.workingSlot = slot or 1
  workerData.targetPos = targetPos
  workerData.worker = workerCfg
  workerData.workerData = data
  local worker = GainWorker:New()
  worker:SetData(workerData)
  worker:CreateModel()
  self:AddTempBuilding(workerData.buildData.uuid)
  AddWorkerModel(worker)
  self.tipUtil:RemoveTipByUid(data.uid)
end

local function ShowFakeWorker(self, appearanceId, buildingData, birthPos, targetPos)
  local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(appearanceId)
  local workerCfg = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId)
  local workerData = {}
  workerData.path = workerCfg.city_model_path
  workerData.birthPos = birthPos
  workerData.posList = {}
  workerData.buildData = buildingData
  workerData.targetPos = targetPos
  workerData.worker = workerCfg
  workerData.workerData = nil
  local worker = GainWorker:New()
  worker:SetData(workerData)
  worker:CreateModel()
  self:AddTempBuilding(workerData.buildData.uuid)
  AddWorkerModel(worker)
end

local function ShowAllWorkers2(self, birthPos, jumpDist, jumpAngleMin, jumpAngleMax)
  for i = #pveWorkerList, 1, -1 do
    jumpDist = jumpDist or 3
    jumpAngleMin = jumpAngleMin or 0
    jumpAngleMax = jumpAngleMax or 360
    local targetPos = birthPos + Quaternion.Euler(0, math.random() * (jumpAngleMax - jumpAngleMin) + jumpAngleMin, 0) * Vector3(0, 0, jumpDist)
    self:ShowWorker2(pveWorkerList[i].cfgId, birthPos, targetPos)
  end
end

local function __delete(self)
  tempBuildingList = {}
  pveWorkerModelList = {}
  RemoveAllModel()
  RemoveListener(self)
  self.bubbleIsOn = false
end

local function SetIsShowAllBubble(self, isOn)
  if self.bubbleIsOn ~= isOn then
    self.bubbleIsOn = isOn
    self.tipUtil:AllBubbleSetActive(isOn)
    EventManager:GetInstance():Broadcast(EventId.GF_building_parkour_bubble_refresh, BuildingTypes.Lw_BUILD_BATTLE_FEATURE_ENTRY)
  end
end

local function GetIsShowAllBubble(self)
  return self.bubbleIsOn
end

local function OnWorkerStateChangeMessageBack(self)
end

GainWorkerManager.__init = __init
GainWorkerManager.__delete = __delete
GainWorkerManager.ShowAllWorkers = ShowAllWorkers
GainWorkerManager.AddPveWorker = AddPveWorker
GainWorkerManager.RemovePveWorker = RemovePveWorker
GainWorkerManager.RemoveWorkerModel = RemoveWorkerModel
GainWorkerManager.AddListeners = AddListeners
GainWorkerManager.RemoveListener = RemoveListener
GainWorkerManager.OnBuildInView = OnBuildInView
GainWorkerManager.OnBuildOutView = OnBuildOutView
GainWorkerManager.OnOpeningStageSetup = OnOpeningStageSetup
GainWorkerManager.OnOpeningStageClear = OnOpeningStageClear
GainWorkerManager.OnOpeningStageMarchBegin = OnOpeningStageMarchBegin
GainWorkerManager.RemoveAllModel = RemoveAllModel
GainWorkerManager.CreateTips = CreateTips
GainWorkerManager.GetIsHavePveWorker = GetIsHavePveWorker
GainWorkerManager.SetIsShowAllBubble = SetIsShowAllBubble
GainWorkerManager.GetIsShowAllBubble = GetIsShowAllBubble
GainWorkerManager.OnWorkerStateChangeMessageBack = OnWorkerStateChangeMessageBack
GainWorkerManager.ShowWorker2 = ShowWorker2
GainWorkerManager.ShowAllWorkers2 = ShowAllWorkers2
GainWorkerManager.HasAnyWorker = HasAnyWorker
GainWorkerManager.ShowFakeWorker = ShowFakeWorker
GainWorkerManager.GetWorkerExistBuild = GetWorkerExistBuild
GainWorkerManager.GetAllWorkers = GetAllWorkers
GainWorkerManager.AddTempBuilding = AddTempBuilding
GainWorkerManager.ReduceTempBuilding = ReduceTempBuilding
GainWorkerManager.ShowLandLockWorker = ShowLandLockWorker
return GainWorkerManager
