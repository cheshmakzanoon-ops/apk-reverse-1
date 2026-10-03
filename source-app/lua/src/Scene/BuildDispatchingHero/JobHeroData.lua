local JobHeroData = BaseClass("JobHeroData")
local Const = require("Scene.BuildDispatchingHero.Const")
local p_entryPath = "ModelGo/point/p_entry"
local p_exitPath = "ModelGo/point/p_exit"
local p_working = "ModelGo/point/p_working"

local function __init(self)
  self:reset()
end

local function __delete(self)
  self:reset()
end

local function reset(self)
  self.heroUuid = 0
  self.dispatchingItemId = 0
  self.buildUuid = 0
  self.startBuildUuid = 0
  self.endBuildUuid = 0
  self.wellBuildUuid = 0
  self.startBuildItemId = 0
  self.walkSpeed = nil
  self.runSpeed = nil
  self.garbage_max = nil
end

local function GetRandomTargetBuildUuidByItemId(self)
  local buildings = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(self.endBuildItemId)
  if table.count(buildings) >= 1 then
    local randomIndex = math.random(1, table.count(buildings))
    return buildings[randomIndex].uuid
  end
end

local function InitPosByBuildUuid(self, buildUuid)
  if IsNull(CS.SceneManager.World) then
    return
  end
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(buildUuid)
  if buildData then
    local cityObj = CS.SceneManager.World:GetBuildingByPoint(buildData.pointId)
    if cityObj then
      local p_entry = cityObj.gameObject.transform:Find(p_entryPath)
      local p_exit = cityObj.gameObject.transform:Find(p_exitPath)
      local p_working = cityObj.gameObject.transform:Find(p_working)
      return p_entry and p_entry.transform.position or cityObj.gameObject.transform.position, p_exit and p_exit.transform.position or cityObj.gameObject.transform.position, p_working and p_working.transform.position or cityObj.gameObject.transform.position
    end
  end
end

local function CanCreateWorker(self)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.startBuildUuid)
  for i = 1, #Const.CanDispatching do
    if Const.CanDispatching[i] == buildData.itemId then
      return true
    end
  end
end

local function IsCanCreate(self)
  local city
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.startBuildUuid)
  if buildData then
    city = CS.SceneManager.World:GetBuildingByPoint(buildData.pointId)
  end
  if self.isCanCreate and CanCreateWorker(self) then
    return city
  end
end

local function UpdateInfo(self, heroUuid, buildUid)
  self.heroUuid = heroUuid
  self.buildUid = buildUid
  if self.buildUid == nil then
    return
  end
  local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(buildUid)
  if buildingData then
    self.buildItemId = buildingData.itemId
  end
  local workerData = DataCenter.WorkerDataManager:GetWorkerDataByUid(self.heroUuid)
  if not workerData then
    return
  end
  local line = LocalController:instance():getLine(TableName.LW_Worker, tonumber(workerData.cfgId))
  if line then
    self.garbage_max = line.garbage_max
    self.walkSpeed = line.speed_city
    self.runSpeed = line.speed_run_city
  end
end

local function getter_cfg(self)
  self.cfg = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.Building), tonumber(self.buildItemId))
  return self.cfg
end

local function getter_endBuildList(self)
  self.endBuildList = string.split(tostring(self.cfg.receiving_building), "|")
  return self.endBuildList
end

local function GetStartBuildPos(self)
  self.start_p_entry, self.start_p_exit, self.start_p_working = InitPosByBuildUuid(self, self.buildUid)
  return {
    entry = self.start_p_entry,
    p_exit = self.start_p_exit,
    working = self.start_p_working
  }
end

local function GetEndBuildPos(self)
  local buildDataList
  for i = 1, #self.endBuildList do
    buildDataList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(tonumber(self.endBuildList[i]))
    if buildDataList and 0 < #buildDataList and 0 < buildDataList[1].level then
      self.endBuildUuid = buildDataList[1].uuid
      self.end_p_entry, self.end_p_exit, self.end_p_working = InitPosByBuildUuid(self, self.endBuildUuid)
      return {
        entry = self.end_p_entry,
        p_exit = self.end_p_exit,
        working = self.end_p_working
      }
    end
  end
end

local function GetEndBuild(self)
  if not self.endBuildUuid then
    self.endBuildUuid = GetRandomTargetBuildUuidByItemId(self, self.endBuildItemId) or nil
  end
  return self.endBuildUuid
end

JobHeroData.__init = __init
JobHeroData.__delete = __delete
JobHeroData.reset = reset
JobHeroData.UpdateInfo = UpdateInfo
JobHeroData.GetStartBuildPos = GetStartBuildPos
JobHeroData.GetEndBuildPos = GetEndBuildPos
JobHeroData.IsCanCreate = IsCanCreate
JobHeroData.GetEndBuild = GetEndBuild
JobHeroData.getters.cfg = getter_cfg
JobHeroData.getters.endBuildList = getter_endBuildList
return JobHeroData
