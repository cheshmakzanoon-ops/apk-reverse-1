local RadarZombieBusTrainCityManager = BaseClass("RadarZombieBusTrainCityManager")
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local ArmyNpc = require("DataCenter.LWBeginnerDirectorManager.LWBeginnerArmyNpc")
local LWBeginnerDirectorRadarZombieBusInCity = require("DataCenter.LWBeginnerDirectorManager.LWBeginnerDirectorRadarZombieBusInCity")
local utils = require("DataCenter.LWGateDefenceManager.LWGateDefenceUtils")
local explodeEffectPath = "Assets/Main/Prefabs/World/Eff_s_Dabache_leida_boom.prefab"

function RadarZombieBusTrainCityManager:__init()
  EventManager:GetInstance():AddListener(EventId.GF_enter_city, self.OnEnable)
  EventManager:GetInstance():AddListener(EventId.BeforeReleaseCity, self.OnDisable)
end

function RadarZombieBusTrainCityManager:__delete()
  EventManager:GetInstance():RemoveListener(EventId.GF_enter_city, self.OnEnable)
  EventManager:GetInstance():RemoveListener(EventId.BeforeReleaseCity, self.OnDisable)
  self:OnDisable()
  if self.zombieBusDirector then
    self.zombieBusDirector:Delete()
    self.zombieBusDirector = nil
  end
end

function RadarZombieBusTrainCityManager:StartUp()
end

function RadarZombieBusTrainCityManager.OnUpdate()
  local self = DataCenter.RadarZombieBusTrainCityManager
  if self.active and self.zombieBusDirector and self.zombieBusDirector.start then
    local dt = Time.deltaTime
    self.zombieBusDirector:OnUpdate(dt)
  end
end

function RadarZombieBusTrainCityManager.OnEnable()
  local self = DataCenter.RadarZombieBusTrainCityManager
  if self.active then
    return
  end
  self.active = true
  self.fireEffects = {}
  self.fireRecycleTimers = {}
  self:RefreshCityZombieBus()
  UpdateManager:GetInstance():AddUpdate(self.OnUpdate)
  EventManager:GetInstance():AddListenerWithSelf(EventId.DetectZombieBusCityDataChange, self.RefreshCityZombieBus, self)
end

function RadarZombieBusTrainCityManager.OnDisable()
  local self = DataCenter.RadarZombieBusTrainCityManager
  if not self.active then
    return
  end
  self.active = false
  self:ClearAllZombieBusNPCs()
  if self.zombieBusDirector and self.zombieBusDirector.start then
    self.zombieBusDirector:Stop()
  end
  if self.fireRecycleTimers then
    for i, timer in ipairs(self.fireRecycleTimers) do
      timer:Stop()
    end
  end
  self.fireRecycleTimers = nil
  if self.fireEffects then
    for i, fireEffect in ipairs(self.fireEffects) do
      if fireEffect.req then
        fireEffect.req:Destroy()
      end
    end
  end
  self.fireEffects = nil
  UpdateManager:GetInstance():RemoveUpdate(self.OnUpdate)
  EventManager:GetInstance():RemoveListener2(EventId.DetectZombieBusCityDataChange, self.RefreshCityZombieBus)
end

function RadarZombieBusTrainCityManager:ClearAllZombieBusNPCs()
  if self.zombieBusNPCs then
    for i, zombieBusNpc in ipairs(self.zombieBusNPCs) do
      zombieBusNpc:Delete()
    end
    self.zombieBusNPCs = nil
  end
end

function RadarZombieBusTrainCityManager:RefreshCityZombieBus()
  local data = DataCenter.RadarCenterDataManager:GetZombieBusTrainCityData()
  local eventUuid = data and data.uuid or nil
  local busList = data and data.busList or nil
  self:UpdateCityZombieBus(eventUuid, busList)
end

function RadarZombieBusTrainCityManager:UpdateCityZombieBus(eventUuid, busList)
  self:ClearAllZombieBusNPCs()
  if self.zombieBusDirector and self.zombieBusDirector.start then
    self.zombieBusDirector:Stop()
  end
  if not busList or not eventUuid then
    return
  end
  self.zombieBusNPCs = {}
  local totalBusCount = #busList
  local scripts = {}
  for i, busData in ipairs(busList) do
    local isPass = busData.isPass
    local lastAttackBusIndex = DataCenter.RadarCenterDataManager.lastAttackZombieBusIndex
    local isDefeatJustNow = isPass == 1 and lastAttackBusIndex == i
    if isPass == 0 or isDefeatJustNow then
      local npc = ArmyNpc.New()
      local armyData = {}
      local busIndex = i
      local fightParam = DataCenter.RadarCenterDataManager:GetAttackZombieBusFightParam(busData, busIndex, eventUuid, false)
      armyData.fightParam = fightParam
      armyData.armyId = busData.busId
      armyData.model = LocalController:instance():getValue("detect_zombie_bus", busData.busId, "model_path")
      local x, z = DataCenter.RadarCenterDataManager:GetCityZombieBusPosXZ(busIndex, totalBusCount)
      armyData.pos = {}
      armyData.pos.x = x
      armyData.pos.y = z
      armyData.OnFightEnter = self.OnFightEnter
      armyData.OnDefeat = self.OnDefeat
      npc:Initialize(i, armyData, isPass)
      table.insert(self.zombieBusNPCs, npc)
      if isDefeatJustNow then
        DataCenter.RadarCenterDataManager.lastAttackZombieBusIndex = nil
      else
        self:AddOneSpawnZombieToDirectorScripts(x, z, scripts)
      end
    end
  end
  if not self.zombieBusDirector then
    self.zombieBusDirector = LWBeginnerDirectorRadarZombieBusInCity.New()
  end
  self.zombieBusDirector.directorScript = scripts
  if 0 < #scripts then
    self.zombieBusDirector:Start()
  end
end

function RadarZombieBusTrainCityManager.OnFightEnter(busIndex, position, euler)
  DataCenter.RadarCenterDataManager:OnEnterZombieBusBattle(busIndex, false, position, euler)
end

function RadarZombieBusTrainCityManager.OnDefeat(busIndex, position, euler)
  DataCenter.RadarZombieBusTrainCityManager:SetBusExplodeEffect(position, euler)
end

function RadarZombieBusTrainCityManager:AddOneSpawnZombieToDirectorScripts(x, z, scripts)
  if not scripts then
    return
  end
  local id = #scripts + 1
  local scriptPoint = self:GetZombieBussSpawnZombieParams(id, x, z)
  table.insert(scripts, scriptPoint)
end

local zombieBusCfg = "detect_zombie_bus_config"

function RadarZombieBusTrainCityManager:GetZombieBussSpawnZombieParams(id, x, z)
  if not self.spawnZombiePosDeltas then
    self.spawnZombiePosDeltas = {}
    local posDeltaStrs = LuaEntry.DataConfig:TryGetStr(zombieBusCfg, "k6")
    if not string.IsNullOrEmpty(posDeltaStrs) then
      local posGroups = string.split(posDeltaStrs, ";")
      for i, posParam in ipairs(posGroups) do
        if not string.IsNullOrEmpty(posParam) then
          local posRowCol = string.split(posParam, ",")
          local baseRow = tonumber(posRowCol[1] or 0)
          local baseCol = tonumber(posRowCol[2] or 0)
          table.insert(self.spawnZombiePosDeltas, {baseRow, baseCol})
        end
      end
    end
    if #self.spawnZombiePosDeltas == 0 then
      table.insert(self.spawnZombiePosDeltas, {0, 0})
    end
  end
  if not self.spawnZombieCD then
    local cdDeltaStrs = LuaEntry.DataConfig:TryGetStr(zombieBusCfg, "k7")
    if not string.IsNullOrEmpty(cdDeltaStrs) then
      local cdMinMax = string.split(cdDeltaStrs, ",")
      local cdMin = tonumber(cdMinMax[1] or 1)
      local cdMax = tonumber(cdMinMax[2] or 5)
      self.spawnZombieCD = {cdMin, cdMax}
    end
    if not self.spawnZombieCD then
      self.spawnZombieCD = {1, 5}
    end
  end
  if not self.spawnZombieNum then
    local zombieNumStrs = LuaEntry.DataConfig:TryGetStr(zombieBusCfg, "k8")
    if not string.IsNullOrEmpty(zombieNumStrs) then
      local numMinMax = string.split(zombieNumStrs, ",")
      local numMin = tonumber(numMinMax[1] or 3)
      local numMax = tonumber(numMinMax[2] or 6)
      self.spawnZombieNum = {numMin, numMax}
    end
    if not self.spawnZombieNum then
      self.spawnZombieNum = {3, 6}
    end
  end
  if not self.spawnZombieLifeTime then
    local lifeTime = LuaEntry.DataConfig:TryGetNum(zombieBusCfg, "k9", 10)
    self.spawnZombieLifeTime = lifeTime
  end
  if not self.spawnZombieHp then
    local hp = LuaEntry.DataConfig:TryGetNum(zombieBusCfg, "k11", 3)
    self.spawnZombieHp = hp
  end
  local pointData = {}
  pointData.Id = id
  pointData.PointType = BeginnerScriptPointType.SpawnCityZombie
  pointData.Conditions = {
    [BeginnerScriptPointTriggerType.Time] = {1}
  }
  pointData.Params = {}
  local baseCol = utils.WorldX_2_Col(x)
  local baseRow = utils.WorldZ_2_Row(z)
  local spawnGrids = {}
  for i, rowCol in ipairs(self.spawnZombiePosDeltas) do
    local pointGrid = {
      row = baseRow + rowCol[1],
      col = baseCol + rowCol[2]
    }
    table.insert(spawnGrids, pointGrid)
  end
  pointData.Params[1] = spawnGrids
  pointData.Params[2] = self.spawnZombieCD
  pointData.Params[3] = self.spawnZombieNum
  pointData.Params[4] = 10
  pointData.Params[5] = self.spawnZombieLifeTime
  pointData.Params[6] = self.spawnZombieHp
  return pointData
end

function RadarZombieBusTrainCityManager:SetBusExplodeEffect(position, euler)
  if self.fireEffects and #self.fireEffects > 0 then
    for i, fireEffect in ipairs(self.fireEffects) do
      if fireEffect.finish then
        fireEffect.finish = false
        local go = fireEffect.req.gameObject
        go.transform:Set_position(position.x, position.y, position.z)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.transform:Set_eulerAngles(euler.x, euler.y, euler.z)
        go:SetActive(true)
        local inPoolTimer = TimerManager:GetInstance():DelayInvoke(function()
          fireEffect.finish = true
          fireEffect.req.gameObject:SetActive(false)
        end, 2)
        table.insert(self.fireRecycleTimers, inPoolTimer)
        return
      end
    end
  end
  local fireEffect = {}
  table.insert(self.fireEffects, fireEffect)
  fireEffect.finish = false
  fireEffect.req = ResourceManager:InstantiateAsync(explodeEffectPath)
  fireEffect.req:completed("+", function()
    if fireEffect.req.isError then
      return
    end
    local go = fireEffect.req.gameObject
    go.transform:Set_position(position.x, position.y, position.z)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go.transform:Set_eulerAngles(euler.x, euler.y, euler.z)
    go:SetActive(true)
    local inPoolTimer = TimerManager:GetInstance():DelayInvoke(function()
      fireEffect.finish = true
      fireEffect.req.gameObject:SetActive(false)
    end, 2)
    table.insert(self.fireRecycleTimers, inPoolTimer)
  end)
end

return RadarZombieBusTrainCityManager
