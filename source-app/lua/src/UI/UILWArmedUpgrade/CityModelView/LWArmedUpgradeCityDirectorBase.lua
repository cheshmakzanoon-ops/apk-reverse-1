local LWArmedUpgradeCityDirectorBase = BaseClass("LWArmedUpgradeCityDirectorBase")
local utils = require("DataCenter.LWGateDefenceManager.LWGateDefenceUtils")

function LWArmedUpgradeCityDirectorBase:__init()
end

function LWArmedUpgradeCityDirectorBase:__delete()
  self:Stop()
end

function LWArmedUpgradeCityDirectorBase:Start()
  if self.start then
    return
  end
  self.start = true
  self.maxZombieCount = 1
  local curLevel = DataCenter.LWArmedUpgradeManager.armedUpgradeLevel
  local template = DataCenter.LWArmedUpgradeTemplateManager:GetArmedUpgradeTemplateByLevel(curLevel)
  if template then
    self.maxZombieCount = template.zombie_max
  end
  self.updatePointList = {}
  self.priorUpdateQueue = {}
  if self.directorConfig then
    local count = table.count(self.directorConfig)
    for i = 1, count do
      local pointData = self.directorConfig[i]
      pointData.Done = false
      pointData.Start = false
      self:DoPoint(pointData)
    end
  end
end

function LWArmedUpgradeCityDirectorBase:Stop()
  if not self.start then
    return
  end
  self.start = false
  self.updatePointList = nil
  self.priorUpdateQueue = nil
  DataCenter.LWGateDefenceManager:CleanAllHeroActors()
  DataCenter.LWGateDefenceManager:CleanAllZombies()
  DataCenter.LWGateDefenceManager:CleanForceTarget()
  DataCenter.LWGateDefenceManager:ReCheckSelfSpawnCondition()
end

function LWArmedUpgradeCityDirectorBase:OnUpdate(deltaTime)
  if not self.start then
    return
  end
  if self.priorUpdateQueue then
    local queueLen = table.count(self.priorUpdateQueue)
    for i = queueLen, 1, -1 do
      local pointData = self.priorUpdateQueue[i]
      if pointData.Update then
        pointData:Update(deltaTime, self)
        pointData.UpdatedByPrior = true
      end
      table.remove(self.priorUpdateQueue, i)
    end
  end
  if self.updatePointList then
    local count = table.count(self.updatePointList)
    for i = count, 1, -1 do
      local pointData = self.updatePointList[i]
      if not pointData.UpdatedByPrior then
        pointData:Update(deltaTime, self)
      else
        pointData.UpdatedByPrior = false
      end
    end
  end
end

function LWArmedUpgradeCityDirectorBase:DoPoint(pointData)
  if not pointData then
    return false
  end
  if pointData.PointType == BeginnerScriptPointType.SpawnCityZombie then
    self:DoSpawnZombie(pointData)
  elseif pointData.PointType == BeginnerScriptPointType.SpawnCityActorHero then
    self:DoSpawnCityActorHero(pointData)
  else
    pointData.Done = true
  end
end

function LWArmedUpgradeCityDirectorBase:DoSpawnZombie(pointData)
  if not pointData then
    return
  end
  pointData.Done = true
  pointData.startGrids = pointData.Params[1]
  pointData.cdSpan = pointData.Params[2]
  pointData.spawnSpan = pointData.Params[3]
  pointData.bigZombiePerc = pointData.Params[4]
  pointData.lifeTime = pointData.Params[5]
  pointData.maxZombieCount = self.maxZombieCount
  pointData.spawnCD = math.random(pointData.cdSpan[1] * 1000, pointData.cdSpan[2] * 1000)
  pointData.zombieHp = pointData.Params[6]
  if not pointData.Update then
    pointData.Update = self.UpdateSpawnZombie
  end
  table.insert(self.updatePointList, pointData)
end

local function UpdateSpawnZombie(pointData, deltaTime, director)
  pointData.spawnCD = pointData.spawnCD - deltaTime * 1000
  if pointData.spawnCD > 0 then
    return
  end
  local gateDefenceMgr = DataCenter.LWGateDefenceManager
  if gateDefenceMgr.zombieAmount < pointData.maxZombieCount then
    local spawnCount = math.random(pointData.spawnSpan[1], pointData.spawnSpan[2])
    for i = 1, spawnCount do
      local spawnGrid = pointData.startGrids[math.random(1, #pointData.startGrids)]
      local destGrid = utils.GetNearestDestGrid(spawnGrid, true)
      if spawnGrid and destGrid then
        local bigZombie = math.random(1, 100) < pointData.bigZombiePerc
        gateDefenceMgr:SpawnZombie(spawnGrid, destGrid, 0, pointData.lifeTime or 10, bigZombie, pointData.zombieHp)
      end
      if gateDefenceMgr.zombieAmount >= pointData.maxZombieCount then
        break
      end
    end
    pointData.spawnCD = math.random(pointData.cdSpan[1] * 1000, pointData.cdSpan[2] * 1000)
  else
    director:AddPointToPriorUpdateQueue(pointData)
  end
end

function LWArmedUpgradeCityDirectorBase:AddPointToPriorUpdateQueue(pointData)
  if not self.priorUpdateQueue then
    return
  end
  for i, v in ipairs(self.priorUpdateQueue) do
    if v.Id == pointData.Id then
      return
    end
  end
  table.insert(self.priorUpdateQueue, pointData)
end

function LWArmedUpgradeCityDirectorBase:DoSpawnCityActorHero(pointData)
  if not pointData then
    return
  end
  pointData.Done = true
  local actorDatas = pointData.Params
  for i, actorData in ipairs(actorDatas) do
    self.insId = self.insId and self.insId + 1 or 1
    local actorId = self.chapterName .. self.insId
    local spawnPos = DataCenter.LWCivilizationSparkExtend:LWArmedUpgradeCityDirectorBase_getCityActorHeroSpawnPos(actorData)
    local heroData = {
      actorId,
      actorData[1],
      spawnPos,
      actorData[3],
      actorData[4],
      actorData[5],
      actorData[6],
      actorData[7]
    }
    DataCenter.LWGateDefenceManager:SpawnActorHero(heroData)
  end
end

LWArmedUpgradeCityDirectorBase.UpdateSpawnZombie = UpdateSpawnZombie
return LWArmedUpgradeCityDirectorBase
