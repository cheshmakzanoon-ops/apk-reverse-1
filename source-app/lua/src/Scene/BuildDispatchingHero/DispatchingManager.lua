local DispatchingManager = BaseClass("DispatchingManager", Singleton)
local JobHero = require("Scene.BuildDispatchingHero.JobHero")
local JobHeroData = require("Scene.BuildDispatchingHero.JobHeroData")
local Const = require("Scene.BuildDispatchingHero.Const")
local buildWorkerDic = {}

local function __init(self)
  buildWorkerDic = {}
  self.AddListeners(self)
end

local function __delete(self)
  self.DestroyAllWorker(self)
  self.RemoveListener(self)
  buildWorkerDic = {}
end

local function AddListeners(self)
  EventManager:GetInstance():AddListener(EventId.BeforeReleaseCity, self.OnReleaseCity)
  EventManager:GetInstance():AddListener(EventId.UpdateBuildDisPatchingWorekerInfo, self.UpdateBuildDispatchInfo)
  EventManager:GetInstance():AddListener(EventId.ProductLineCollect, self.TakingDelivery)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.BeforeReleaseCity, self.OnReleaseCity)
  EventManager:GetInstance():RemoveListener(EventId.UpdateBuildDisPatchingWorekerInfo, self.UpdateBuildDispatchInfo)
  EventManager:GetInstance():RemoveListener(EventId.ProductLineCollect, self.TakingDelivery)
end

local function OnReleaseCity()
  DataCenter.DispatchingManager:DestroyAllWorker()
end

local function DestroyAllWorker()
  for i, v in pairs(buildWorkerDic) do
    for k, info in pairs(v) do
      if info and info.jobHero then
        info.jobHero:Delete()
        info.jobHero = nil
      end
    end
  end
end

local function CreateJobData(workerUid, bUuid)
  if workerUid == nil or workerUid == "" then
    return
  end
  local job = {}
  local jobHeroData = JobHeroData.New()
  jobHeroData:UpdateInfo(workerUid, bUuid)
  job.jobHeroData = jobHeroData
  buildWorkerDic[bUuid][workerUid] = job
end

local function SetWorker(workerId)
  for bUuid, buildInfo in pairs(buildWorkerDic) do
    for myWorkerId, workerInfo in pairs(buildInfo) do
      if myWorkerId == workerId then
        if not workerInfo.jobHero then
          return
        end
        workerInfo.jobHero:Delete()
        workerInfo.jobHero = nil
        buildInfo[myWorkerId] = nil
      end
    end
  end
end

local function UpdateBuildDispatchInfo(workerData)
  local bUuid = workerData.buildUid
  local workerUid = workerData.workerUid
  SetWorker(workerUid)
  if bUuid then
    if not buildWorkerDic[bUuid] then
      buildWorkerDic[bUuid] = {}
    elseif buildWorkerDic[bUuid][workerUid] then
      buildWorkerDic[bUuid][workerUid].jobHeroData:UpdateInfo(workerUid, bUuid)
      return
    end
    CreateJobData(workerUid, bUuid)
  end
end

local function CreateJobHero(workerInfo, delayTime)
  if IsNull(CS.SceneManager.World) then
    return
  end
  local startPos = workerInfo.jobHeroData:GetStartBuildPos()
  local endPos = workerInfo.jobHeroData:GetEndBuildPos()
  if startPos and endPos then
    local jobHero = JobHero.New()
    jobHero:Create(delayTime, workerInfo.jobHeroData.heroUuid, workerInfo.jobHeroData, function()
      workerInfo.jobHero:Delete()
      workerInfo.jobHero = nil
    end)
    workerInfo.jobHero = jobHero
  end
end

local function TakingDelivery(buildUid)
  local workerList = buildWorkerDic[buildUid]
  if not workerList then
    return
  end
  local time = -1
  for key, info in pairs(buildWorkerDic[buildUid]) do
    time = time + 1
    if not info.jobHero then
      CreateJobHero(info, time * Const.delayTime)
    end
  end
end

DispatchingManager.__init = __init
DispatchingManager.__delete = __delete
DispatchingManager.OnReleaseCity = OnReleaseCity
DispatchingManager.DestroyAllWorker = DestroyAllWorker
DispatchingManager.AddListeners = AddListeners
DispatchingManager.RemoveListener = RemoveListener
DispatchingManager.TakingDelivery = TakingDelivery
DispatchingManager.UpdateBuildDispatchInfo = UpdateBuildDispatchInfo
return DispatchingManager
