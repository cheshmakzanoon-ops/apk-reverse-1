local WorkerDataManager = BaseClass("WorkerDataManager")
local WorkerData = require("DataCenter.WorkerData.WorkerData")

local function __init(self)
  self.inited = false
  self.allworker = {}
  self.allWorkerIdMap = {}
  self.newTags = {}
  self.fragItemData = nil
  self.vipWorkerRewardTimes = 0
  self.workerDispatchBuildingTypeOrderDict = nil
  self.vipWorkerDescDict = nil
end

local function __delete(self)
  self.inited = nil
  self.allworker = nil
  self.allWorkerIdMap = nil
  self.newTags = nil
  self.fragItemData = nil
  self.vipWorkerRewardTimes = nil
  self.workerDispatchBuildingTypeOrderDict = nil
  self.vipWorkerDescDict = nil
end

local function AddOneWorker(self, message)
  if self.allworker[message.uid] then
    self.allworker[message.uid]:UpdateInfo(message)
    self.allWorkerIdMap[message.cfgId] = message.uid
  else
    local workerData = {}
    workerData = WorkerData.New()
    workerData:UpdateInfo(message)
    self.allworker[workerData.uid] = workerData
    self.allWorkerIdMap[message.cfgId] = message.uid
    if self.inited then
      self:AddNewTag(message.uid)
    end
  end
end

local function GetWorkerDataByUid(self, uid)
  if uid == nil then
    return nil
  end
  return self.allworker[tonumber(uid)]
end

local function UpdateWokerDispatching(self, workerUid, buildUid)
  local worker = GetWorkerDataByUid(self, tonumber(workerUid))
  if worker then
    worker:SetDispatching(buildUid, nil)
    local worker = {}
    worker.workerUid = workerUid
    worker.buildUid = buildUid
    DataCenter.DispatchingManager.UpdateBuildDispatchInfo(worker)
  else
    Logger.LogError("Do not own the worker Uid is: " .. workerUid)
  end
end

local function UpdateWorkerDataListByBuild(self, tempBuildData)
  for workerUid, info in pairs(tempBuildData) do
    if workerUid ~= nil and workerUid ~= "" and info then
      UpdateWokerDispatching(self, workerUid, info.bUuid)
    end
  end
end

local function InitData(self, message)
  local workers = message.workers
  local buildInfos = message.building_new
  local buildWorkerInfos = {}
  if workers then
    for i, info in pairs(workers.list) do
      AddOneWorker(self, info)
    end
  end
  if buildInfos then
    for i, info in pairs(buildInfos) do
      if info.AssignedHero then
        for index, workerId in pairs(info.AssignedHero) do
          if workerId ~= nil and workerId ~= "" then
            buildWorkerInfos[workerId] = {}
            buildWorkerInfos[workerId].bUuid = info.uuid
            buildWorkerInfos[workerId].slotId = index
          end
        end
      end
    end
    UpdateWorkerDataListByBuild(self, buildWorkerInfos)
  end
  if workers and workers.workerLottery ~= nil then
    DataCenter.WorkerLotteryDataManager:UpdateWorkerLotteryData(workers.workerLottery)
    EventManager:GetInstance():Broadcast(EventId.WorkerLotteryInfoGet)
  end
  if message.vipWorkerRewardTimes ~= nil then
    self.vipWorkerRewardTimes = toInt(message.vipWorkerRewardTimes)
  end
  self.inited = true
end

local function GetVipWorkerGetRewardTimesCurDay(self, message)
  if message.vipWorkerRewardTimes ~= nil then
    self.vipWorkerRewardTimes = message.vipWorkerRewardTimes
  end
end

function WorkerDataManager:UpdateVipWorkerAccumulateCount(message)
  if message.vipWorkerAccumulateCount ~= nil then
    self.vipWorkerAccumulateCount = message.vipWorkerAccumulateCount
  end
end

function WorkerDataManager:GetVipWorkerAccumulateCount()
  return self.vipWorkerAccumulateCount or 0
end

local function GetWorkerListByWorkerState(self, state)
  local workerList = {}
  for i, v in pairs(self.allworker) do
    if v:GetState() == state then
      table.insert(workerList, v)
    end
  end
  return workerList
end

local function GetWorkerListByResidentBuildingUuid(self, uuid)
  local workerList = {}
  for i, v in pairs(self.allworker) do
    if v.wellBuildUuid == uuid then
      table.insert(workerList, v)
    end
  end
  return workerList
end

local function GetWorkerListByDispatchingBuildingUuid(self, uuid)
  local workerList = {}
  for i, v in pairs(self.allworker) do
    if v.dispatchingBuildUid == uuid then
      table.insert(workerList, v)
    end
  end
  return workerList
end

local function GetCanWorkWorkerListByBuildItmeId(self, buildItemId)
  if buildItemId == BuildingTypes.LW_BUILD_LIBRARY then
    return self.allworker
  end
  local workerDataList = {}
  for i, workerData in pairs(self.allworker) do
    if workerData:IsCanWork(buildItemId) then
      table.insert(workerDataList, workerData)
    end
  end
  return workerDataList
end

local function GetAllWorkerData(self)
  return self.allworker
end

local function GetAvailableWorkersByBuildItemId(self, itemId)
  local list = {}
  for i, workerData in pairs(self.allworker) do
    if (workerData.dispatchingBuildUid == nil or workerData.dispatchingBuildUid == 0) and workerData:IsCanWork(itemId) then
      table.insert(list, workerData)
    end
  end
  return list
end

local function GetPvEWorkerList(self)
  local workerList = {}
  for i, info in pairs(self.allworker) do
    if info.source == "BATTLE_PVE_TRIGGER" and info.clientState == 0 then
      table.insert(workerList, info)
    end
  end
  return workerList
end

local function GetWorkerAddition(self, buuid, effectId)
  local effectValue = 0
  for i, v in pairs(self.allworker) do
    if v.dispatchingBuildUid == buuid then
      effectValue = effectValue + v:GetWorkerProperty(effectId)
    end
  end
  return effectValue
end

local function IsNewWorkerByCfgId(self, cfgId)
  local isNew = true
  for i, v in pairs(self.allworker) do
    if v.cfgId == cfgId then
      isNew = false
      break
    end
  end
  return isNew
end

local function AddNewTag(self, uuid)
  self.newTags[uuid] = true
end

local function RemoveNewTag(self, uuid)
  self.newTags[uuid] = nil
end

local function ClearNewTags(self)
  self.newTags = {}
end

local function IsHaveNewTag(self, uuid)
  local isNew = false
  if self.newTags[uuid] then
    isNew = true
  end
  return isNew
end

local function TryInitFragData(self)
  if self.fragItemData == nil then
    self.fragItemData = {}
    local type137Items = DataCenter.ItemTemplateManager:GetTypeListByType(GOODS_TYPE.GOODS_TYPE_137)
    if type137Items then
      for k, v in pairs(type137Items) do
        local workerId = tonumber(v.para2) or 0
        local needNum = tonumber(v.para1) or 0
        if 0 < workerId then
          local data = {
            workerId = workerId,
            needNum = needNum,
            itemCfg = v
          }
          self.fragItemData[workerId] = data
        end
      end
    end
  end
end

local function GetFragDataById(self, id)
  self:TryInitFragData()
  return self.fragItemData[id]
end

local function GetAllFragData(self)
  self:TryInitFragData()
  return self.fragItemData
end

local function GetVipWorkerRewardTimes(self)
  return self.vipWorkerRewardTimes
end

local function GetWorkerById(self, workerId)
  return self.allWorkerIdMap[workerId]
end

local function GetToUnlockWorkerListByBuildItmeId(self, buildItemId)
  if buildItemId == BuildingTypes.LW_BUILD_LIBRARY then
    return self.allworker
  end
  local allWorkersForBuild = DataCenter.WorkerTemplateManager:GetAllWorkerForBuild(buildItemId)
  local list = {}
  local count = 1
  for _, template in pairs(allWorkersForBuild) do
    local workerId = template.id
    local workerData = self:GetWorkerById(workerId)
    if not workerData then
      local fragData = self:GetFragDataById(workerId)
      if fragData then
        local needNum = fragData.needNum
        local goodsId = fragData.itemCfg.id
        local curNum = DataCenter.ItemData:GetItemCount(goodsId) or 0
        if needNum <= curNum then
          list[count] = workerId
          count = count + 1
        end
      end
    end
  end
  return list
end

local function GetWorkerDispatchBuildingTypeOrderDict(self)
  if self.workerDispatchBuildingTypeOrderDict == nil then
    self.workerDispatchBuildingTypeOrderDict = {}
    local orderStr = LuaEntry.DataConfig:TryGetStr("worker_hall_order", "k1")
    if not string.IsNullOrEmpty(orderStr) then
      local orderList = string.string2array_i_oneSep(orderStr, "|")
      for i, type in ipairs(orderList) do
        self.workerDispatchBuildingTypeOrderDict[type] = i
      end
    end
  end
  return self.workerDispatchBuildingTypeOrderDict
end

local function GetVipWorkerDescDict(self)
  if self.vipWorkerDescDict == nil then
    self.vipWorkerDescDict = {}
    local descStr = LuaEntry.DataConfig:TryGetStr("worker_hall_headquarters_display", "k1")
    if not string.IsNullOrEmpty(descStr) then
      self.vipWorkerDescDict = string.string2table_is(descStr, ";", "|")
    end
  end
  return self.vipWorkerDescDict
end

function WorkerDataManager:GetTargetWorkerStateByCfgId(workerId)
  local workerUuid = DataCenter.WorkerDataManager:GetWorkerById(workerId)
  if not workerUuid then
    return nil
  end
  local workerData = DataCenter.WorkerDataManager:GetWorkerDataByUid(workerUuid)
  if not workerData then
    return nil
  end
  return workerData.state
end

WorkerDataManager.__init = __init
WorkerDataManager.__delete = __delete
WorkerDataManager.InitData = InitData
WorkerDataManager.GetWorkerDataByUid = GetWorkerDataByUid
WorkerDataManager.UpdateWokerDispatching = UpdateWokerDispatching
WorkerDataManager.GetWorkerListByWorkerState = GetWorkerListByWorkerState
WorkerDataManager.AddOneWorker = AddOneWorker
WorkerDataManager.GetWorkerListByResidentBuildingUuid = GetWorkerListByResidentBuildingUuid
WorkerDataManager.GetWorkerListByDispatchingBuildingUuid = GetWorkerListByDispatchingBuildingUuid
WorkerDataManager.GetCanWorkWorkerListByBuildItmeId = GetCanWorkWorkerListByBuildItmeId
WorkerDataManager.GetAllWorkerData = GetAllWorkerData
WorkerDataManager.UpdateWorkerDataListByBuild = UpdateWorkerDataListByBuild
WorkerDataManager.GetAvailableWorkersByBuildItemId = GetAvailableWorkersByBuildItemId
WorkerDataManager.GetWorkerAddition = GetWorkerAddition
WorkerDataManager.IsNewWorkerByCfgId = IsNewWorkerByCfgId
WorkerDataManager.AddNewTag = AddNewTag
WorkerDataManager.RemoveNewTag = RemoveNewTag
WorkerDataManager.ClearNewTags = ClearNewTags
WorkerDataManager.IsHaveNewTag = IsHaveNewTag
WorkerDataManager.TryInitFragData = TryInitFragData
WorkerDataManager.GetFragDataById = GetFragDataById
WorkerDataManager.GetAllFragData = GetAllFragData
WorkerDataManager.GetVipWorkerGetRewardTimesCurDay = GetVipWorkerGetRewardTimesCurDay
WorkerDataManager.GetVipWorkerRewardTimes = GetVipWorkerRewardTimes
WorkerDataManager.GetWorkerById = GetWorkerById
WorkerDataManager.GetToUnlockWorkerListByBuildItmeId = GetToUnlockWorkerListByBuildItmeId
WorkerDataManager.GetWorkerDispatchBuildingTypeOrderDict = GetWorkerDispatchBuildingTypeOrderDict
WorkerDataManager.GetVipWorkerDescDict = GetVipWorkerDescDict
return WorkerDataManager
