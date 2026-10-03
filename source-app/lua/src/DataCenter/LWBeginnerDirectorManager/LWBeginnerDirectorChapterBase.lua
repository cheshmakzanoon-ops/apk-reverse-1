local LWBeginnerDirectorChapterBase = BaseClass("LWBeginnerDirectorChapterBase")
local utils = require("DataCenter.LWGateDefenceManager.LWGateDefenceUtils")
local ArmyNpc = require("DataCenter.LWBeginnerDirectorManager.LWBeginnerArmyNpc")

function LWBeginnerDirectorChapterBase:__init()
  self.OnGuideFlowDoneCallBack = Bind(self, self.OnGuideFlowDone)
end

function LWBeginnerDirectorChapterBase:__delete()
  self:Stop()
  self.OnGuideFlowDoneCallBack = nil
  self.totalTime = nil
  self.start = nil
  self.pause = nil
  self.WaitCheckPointDatas = nil
  self.RunPointDatas = nil
  self.taskAllReceived = nil
  self.overTime = nil
end

function LWBeginnerDirectorChapterBase:Start()
  if self.start then
    return
  end
  self.totalTime = 0
  self.start = true
  self.pause = false
  self.maxZombieCount = LuaEntry.DataConfig:TryGetNum("inner_city_zombie_max", "k1", 30)
  self.WaitCheckPointDatas = {}
  if self.directorScript then
    for i = 1, #self.directorScript do
      local pointData = self.directorScript[i]
      pointData.Done = false
      pointData.Start = false
      pointData.RemainTimeToStart = pointData.Delay
      pointData.DisableUpdate = false
      table.insert(self.WaitCheckPointDatas, pointData)
    end
  end
  self.RunPointDatas = {}
  self.UpdatePointDatas = {}
  self.PriorUpdateQueue = {}
  self.ArmyNpcs = {}
  EventManager:GetInstance():AddListener(EventId.GF_guide_done, self.OnGuideFlowDoneCallBack)
end

function LWBeginnerDirectorChapterBase:Pause(pause)
  self.pause = pause
end

function LWBeginnerDirectorChapterBase:Stop()
  if not self.start then
    return
  end
  EventManager:GetInstance():RemoveListener(EventId.GF_guide_done, self.OnGuideFlowDoneCallBack)
  self.start = false
  self.pause = false
  self.RunPointDatas = nil
  self.WaitCheckPointDatas = nil
  self.UpdatePointDatas = nil
  self.PriorUpdateQueue = nil
  for i, armyNpc in ipairs(self.ArmyNpcs) do
    armyNpc:Delete()
  end
  self.ArmyNpcs = nil
  DataCenter.LWGateDefenceManager:CleanAllHeroActors()
  DataCenter.LWGateDefenceManager:CleanAllZombies()
  DataCenter.LWGateDefenceManager:CleanForceTarget()
  DataCenter.LWGateDefenceManager:ReCheckSelfSpawnCondition()
end

function LWBeginnerDirectorChapterBase:OnUpdate(deltaTime)
  if not self.start then
    return
  end
  if self.pause then
    return
  end
  if self.WaitCheckPointDatas and #self.WaitCheckPointDatas > 0 then
    self.totalTime = self.totalTime + deltaTime
    local checkDataLength = #self.WaitCheckPointDatas
    for i = checkDataLength, 1, -1 do
      local pointData = self.WaitCheckPointDatas[i]
      local matchCondition = self:CheckConditionsMatch(pointData)
      if matchCondition then
        table.insert(self.RunPointDatas, pointData)
        table.remove(self.WaitCheckPointDatas, i)
      end
    end
  end
  if self.RunPointDatas and 0 < #self.RunPointDatas then
    for i, runPointData in ipairs(self.RunPointDatas) do
      if not runPointData.Start then
        if runPointData.RemainTimeToStart and 0 < runPointData.RemainTimeToStart then
          runPointData.RemainTimeToStart = runPointData.RemainTimeToStart - deltaTime
        else
          runPointData.Start = true
          self:DoPoint(runPointData)
        end
      end
    end
  end
  if self.PriorUpdateQueue then
    local queueLen = #self.PriorUpdateQueue
    for i = queueLen, 1, -1 do
      local pointData = self.PriorUpdateQueue[i]
      if pointData.Update then
        pointData:Update(deltaTime, self)
        pointData.UpdatedByPrior = true
      end
      table.remove(self.PriorUpdateQueue, i)
    end
  end
  if self.UpdatePointDatas and 0 < #self.UpdatePointDatas then
    local updateDataLength = #self.UpdatePointDatas
    for i = updateDataLength, 1, -1 do
      local pointData = self.UpdatePointDatas[i]
      if not pointData.UpdatedByPrior then
        pointData:Update(deltaTime, self)
      else
        pointData.UpdatedByPrior = false
      end
      if pointData.DisableUpdate then
        table.remove(self.UpdatePointDatas, i)
      end
    end
  end
end

function LWBeginnerDirectorChapterBase:AddPointToPriorUpdateQueue(pointData)
  if not self.PriorUpdateQueue then
    return
  end
  for i, v in ipairs(self.PriorUpdateQueue) do
    if v.Id == pointData.Id then
      return
    end
  end
  table.insert(self.PriorUpdateQueue, pointData)
end

function LWBeginnerDirectorChapterBase:CheckConditionsMatch(pointData)
  if not pointData then
    return false
  end
  local conditions = pointData.Conditions
  if not conditions then
    return true
  end
  for triggerType, triggerParams in pairs(conditions) do
    if triggerType == BeginnerScriptPointTriggerType.Time then
      local keyTime = triggerParams[1] or 0
      if keyTime > self.totalTime then
        return false
      end
    elseif triggerType == BeginnerScriptPointTriggerType.WaitPreDone then
      local waitPreIds = triggerParams
      for i, waitPreId in ipairs(waitPreIds) do
        local preIdIsRunAlready = false
        for j, runPointData in ipairs(self.RunPointDatas) do
          if runPointData.Id == waitPreId then
            preIdIsRunAlready = true
            if not runPointData.Done then
              return false
            end
          end
        end
        if not preIdIsRunAlready then
          return false
        end
      end
    elseif triggerType == BeginnerScriptPointTriggerType.TaskAllReceived then
      local opEqual = triggerParams[1] == 1
      if not self.taskAllReceived and opEqual then
        return false
      end
      if self.taskAllReceived and not opEqual then
        return false
      end
    elseif triggerType == BeginnerScriptPointTriggerType.OverTime then
      local opEqual = triggerParams[1] == 1
      if not self.overTime and opEqual then
        return false
      end
      if self.overTime and not opEqual then
        return false
      end
    else
      return false
    end
  end
  return true
end

function LWBeginnerDirectorChapterBase:DoPoint(pointData)
  if not pointData then
    return false
  end
  if pointData.PointType == BeginnerScriptPointType.GuideFLow then
    self:DoGuideFLow(pointData)
  elseif pointData.PointType == BeginnerScriptPointType.OpenWindow then
    self:DoOpenWindow(pointData)
  elseif pointData.PointType == BeginnerScriptPointType.MoveCamera then
    self:DoCameraFocus(pointData)
  elseif pointData.PointType == BeginnerScriptPointType.SpawnCityZombie then
    self:DoSpawnZombie(pointData)
  elseif pointData.PointType == BeginnerScriptPointType.SpawnCityActorHero then
    self:DoSpawnCityActorHero(pointData)
  elseif pointData.PointType == BeginnerScriptPointType.SpawnArmyNPC then
    self:DoSpawnArmyNpc(pointData)
  elseif pointData.PointType == BeginnerScriptPointType.UnLockCurMonopoly then
    self:DoUnlockCurMonopoly(pointData)
  elseif pointData.PointType == BeginnerScriptPointType.SetMonopolyVisble then
    self:DoSetMonopolyVisible(pointData)
  elseif pointData.PointType == BeginnerScriptPointType.SetCityPointVisible then
    self:DoSetCityPointVisible(pointData)
  else
    pointData.Done = true
  end
end

function LWBeginnerDirectorChapterBase:DoGuideFLow(pointData)
  if not pointData then
    return
  end
  local flowId = pointData.Params[1]
  if not flowId then
    pointData.Done = true
    return
  else
    local isDone = DataCenter.LWGuideFlowManager:ReadDone(flowId)
    if not isDone then
      DataCenter.UIPopWindowManager:Clear()
      GoToUtil.CloseAllWindows()
      DataCenter.LWGuideFlowManager:TryTriggerFlexibly(flowId)
    else
      pointData.Done = true
    end
  end
end

function LWBeginnerDirectorChapterBase:OnGuideFlowDone(flowId)
  if not self.RunPointDatas then
    return
  end
  for i, runPointData in ipairs(self.RunPointDatas) do
    if runPointData.PointType == BeginnerScriptPointType.GuideFLow and runPointData.Params[1] == flowId then
      runPointData.Done = true
    end
  end
end

function LWBeginnerDirectorChapterBase:DoOpenWindow(pointData)
  if not pointData then
    return
  end
  pointData.Done = true
  local windowName = pointData.Params[1]
  local windowParams = pointData.Params[2]
  if windowName then
    UIManager:GetInstance():OpenWindow(windowName, windowParams)
  end
end

function LWBeginnerDirectorChapterBase:DoSpawnZombie(pointData)
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
  table.insert(self.UpdatePointDatas, pointData)
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

function LWBeginnerDirectorChapterBase:DoSpawnCityActorHero(pointData)
  if not pointData then
    return
  end
  pointData.Done = true
  local actorDatas = pointData.Params
  for i, actorData in ipairs(actorDatas) do
    self.insId = self.insId and self.insId + 1 or 1
    local actorId = self.chapterName .. self.insId
    local heroData = {
      actorId,
      actorData[1],
      actorData[2],
      actorData[3],
      actorData[4],
      actorData[5],
      actorData[6],
      actorData[7]
    }
    DataCenter.LWGateDefenceManager:SpawnActorHero(heroData)
  end
end

function LWBeginnerDirectorChapterBase:DoCameraFocus(pointData)
  if not pointData then
    return
  end
  local posX = pointData.Params[1] or 0
  local posZ = pointData.Params[2] or 0
  local lookAtFocusTime = pointData.Params[3] or 0
  local pos = CS.UnityEngine.Vector3.one
  pos.x = posX
  pos.y = 0
  pos.z = posZ
  GoToUtil.GotoPos(pos, CS.SceneManager.World.InitZoom, lookAtFocusTime)
  pointData.focusTime = lookAtFocusTime
  if 0 < lookAtFocusTime then
    if not pointData.Update then
      function pointData.Update(point, deltaTime, director)
        point.focusTime = point.focusTime - deltaTime
        
        if point.focusTime > 0 then
          return
        end
        point.Done = true
        point.DisableUpdate = true
      end
    end
    table.insert(self.UpdatePointDatas, pointData)
  end
end

function LWBeginnerDirectorChapterBase:DoSpawnArmyNpc(pointData)
  if not pointData then
    return
  end
  pointData.Done = true
  local beginnerDirectorMgr = DataCenter.LWBeginnerDirectorManager
  local armyDatas = beginnerDirectorMgr.ArmyNPCs
  local armyStates = beginnerDirectorMgr.bossKill
  local armyKilledRecentStates = beginnerDirectorMgr.bossKillRecent
  for i, armyData in ipairs(armyDatas) do
    local state = armyStates[i] or 0
    local killedRecent = armyKilledRecentStates[i] or 0
    if state == 0 or killedRecent == 1 then
      local npc = ArmyNpc.New()
      local fightParam = {}
      fightParam.type = PVEType.FakePVP
      fightParam.enterType = PVEEnterType.BeginnerEvent
      fightParam.levelId = armyData.armyId
      fightParam.sceneId = 51
      fightParam.extraData = {}
      fightParam.extraData.bossIndx = i
      armyData.fightParam = fightParam
      npc:Initialize(i, armyData, state)
      table.insert(self.ArmyNpcs, npc)
      armyKilledRecentStates[i] = nil
    end
  end
end

function LWBeginnerDirectorChapterBase:GetOneAliveArmyNpc()
  if not self.ArmyNpcs or #self.ArmyNpcs <= 0 then
    return
  end
  return self.ArmyNpcs[1]
end

function LWBeginnerDirectorChapterBase:UpdateArmyNpcState(armyStates)
  if not armyStates then
    return
  end
  if not self.ArmyNpcs or #self.ArmyNpcs == 0 then
    return
  end
  for i, armyNpc in ipairs(self.ArmyNpcs) do
    local state = armyStates[i] and armyStates[i] or 0
    armyNpc:UpdateState(state)
  end
end

function LWBeginnerDirectorChapterBase:DoUnlockCurMonopoly(pointData)
  if not pointData then
    return
  end
  pointData.Done = true
  local curMonoPolyData = DataCenter.MonopolyManager:GetCurData()
  local monoPolyId = pointData.Params[1]
  if monoPolyId and curMonoPolyData and curMonoPolyData.id == monoPolyId then
    DataCenter.MonopolyManager:UnLockCurMonopolyAndSave()
  end
end

function LWBeginnerDirectorChapterBase:DoSetMonopolyVisible(pointData)
  if not pointData then
    return
  end
  pointData.Done = true
  local curMonoPolyData = DataCenter.MonopolyManager:GetCurData()
  for i, data in ipairs(pointData.Params) do
    local monoPolyId = data[1]
    local visible = data[2]
    local onlyModel = data[3]
    if monoPolyId and curMonoPolyData and monoPolyId >= curMonoPolyData.id then
      DataCenter.MonopolyManager:SetTargetObstableRelatedAppearanceVisible(monoPolyId, visible, onlyModel)
    end
  end
end

function LWBeginnerDirectorChapterBase:DoSetCityPointVisible(pointData)
  if not pointData then
    return
  end
  pointData.Done = true
  for i, data in ipairs(pointData.Params) do
    local pointId = data[1]
    local visible = data[2]
    if visible then
      CS.SceneManager.World:ShowObject(pointId)
    else
      CS.SceneManager.World:HideObject(pointId)
    end
  end
end

LWBeginnerDirectorChapterBase.UpdateSpawnZombie = UpdateSpawnZombie
return LWBeginnerDirectorChapterBase
