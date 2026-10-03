local Resource = CS.GameEntry.Resource
local GameObject = CS.UnityEngine.GameObject
local LWSeasonTowerSceneLogic = BaseClass("LWSeasonTowerSceneLogic")
local LWSeasonTowerCameraLogic = require("Scene.LWSeasonTowerScene.LWSeasonTowerCameraLogic")
local LWSeasonTowerEnemyLogic = require("Scene.LWSeasonTowerScene.LWSeasonTowerEnemyLogic")
local LWSeasonTowerSceneSegmentLogic = require("Scene.LWSeasonTowerScene.LWSeasonTowerSceneSegmentLogic")
local LWSeasonTowerSquadLogic = require("Scene.LWSeasonTowerScene.LWSeasonTowerSquadLogic")
local LWSeasonTowerUtil = require("DataCenter.LWSeasonTowerManager.LWSeasonTowerUtil")
local ReadyEffect = "Assets/Main/Prefabs/UI/LWUISeasonTower/Effect/Prefab/Eff_S6_Runing_Ready.prefab"
local DEFAULT_CAMERA_PREFAB_PATH = "Assets/Main/Prefabs/UI/LWUISeasonTower/SeasonTowerSceneCamera.prefab"
local DEFAULT_SEGMENT_LENGTH = 44
local ARMY_BIRTH_POSITION_Z = 15
local EffectConfig = {
  MoveEffect = {
    {
      Effect = "Assets/Main/Prefabs/UI/LWUISeasonTower/Effect/Prefab/Eff_S6_Runing_01.prefab",
      FailedEffect = "Assets/Main/Prefabs/UI/LWUISeasonTower/Effect/Prefab/Eff_S6_Runing_01_Dis.prefab",
      ImpactEffect = "Assets/Main/Prefabs/UI/LWUISeasonTower/Effect/Prefab/Eff_S6_Runing_01_Impact.prefab",
      Speed = DEFAULT_SEGMENT_LENGTH / 2.4
    },
    {
      Effect = "Assets/Main/Prefabs/UI/LWUISeasonTower/Effect/Prefab/Eff_S6_Runing_02.prefab",
      FailedEffect = "Assets/Main/Prefabs/UI/LWUISeasonTower/Effect/Prefab/Eff_S6_Runing_02_Dis.prefab",
      ImpactEffect = "Assets/Main/Prefabs/UI/LWUISeasonTower/Effect/Prefab/Eff_S6_Runing_02_Impact.prefab",
      Speed = DEFAULT_SEGMENT_LENGTH / 1.5
    },
    {
      Effect = "Assets/Main/Prefabs/UI/LWUISeasonTower/Effect/Prefab/Eff_S6_Runing_03.prefab",
      FailedEffect = "Assets/Main/Prefabs/UI/LWUISeasonTower/Effect/Prefab/Eff_S6_Runing_03_Dis.prefab",
      ImpactEffect = "Assets/Main/Prefabs/UI/LWUISeasonTower/Effect/Prefab/Eff_S6_Runing_03_Impact.prefab",
      Speed = DEFAULT_SEGMENT_LENGTH / 1.1
    }
  }
}
local CAMERA_CONFIG = {
  HEIGHT = 20.5,
  FOV = 60,
  ROTATION = 56.5
}
local StopEpsilon = 0.02
local FailedEffectWaitTime = 1.5
local ReadyMinTime = 2

function LWSeasonTowerSceneLogic:__init()
end

function LWSeasonTowerSceneLogic:__delete()
  self:OnDestroy()
end

function LWSeasonTowerSceneLogic:Enter(param)
  self.param = param or {}
  self.mgr = DataCenter.LWSeasonTowerSceneManager
  self.inLogic = true
  self.inGame = false
  self.sceneSegmentLogic = nil
  self.squadLogic = nil
  self.cameraLogic = nil
  self.moveSpeed = 0
  self.lastForwardSpeed = 0
  self.lastForwardLevel = -1
  self.moveTargetPosZ = nil
  self.finalTargetPosZ = nil
  self.extraStopPosZ = nil
  self.isRetreatingToFinal = false
  self.waitRetreatAfterFailedEffect = false
  self.failedEffectElapsed = 0
  self.levelId = param.levelId
  self.sceneId = param.sceneId
  self.curLevel = -1
  self.sweeping = false
  self.enemyList = {}
  self.resultFloors = {}
  self:InitSceneSegmentLogic()
  self:InitCamera()
end

function LWSeasonTowerSceneLogic:SetConfigSpeed(level, time)
  EffectConfig.MoveEffect[level].Speed = DEFAULT_SEGMENT_LENGTH / time
end

function LWSeasonTowerSceneLogic:InitSceneSegmentLogic()
  if self.sceneSegmentLogic == nil then
    self.sceneSegmentLogic = LWSeasonTowerSceneSegmentLogic.New()
  end
  self.sceneSegmentLogic:Init({
    sceneId = self.sceneId,
    onCreateScene = function(sceneIndex)
      self:CreateFakeEnemy(sceneIndex)
    end,
    onDestroyScene = function(sceneIndex)
      local enemy = self.enemyList[sceneIndex]
      if enemy then
        enemy:DestroyFakeEnemy()
        self.enemyList[sceneIndex] = nil
      end
    end,
    onFirstSceneLoaded = function()
      self:OnSceneLoadFinish()
    end
  })
end

function LWSeasonTowerSceneLogic:InitCamera()
  if self.cameraLogic == nil then
    self.cameraLogic = LWSeasonTowerCameraLogic.New()
  end
  self.cameraLogic:Init({
    cameraPrefabPath = DEFAULT_CAMERA_PREFAB_PATH,
    cameraConfig = CAMERA_CONFIG,
    cameraOffsetIdle = 7,
    cameraOffsetMove = -1.5,
    cameraOffsetSmooth = 6,
    getSquadRoot = function()
      return self:GetSquadRoot()
    end,
    isLogicActive = function()
      return self.inLogic
    end
  })
end

function LWSeasonTowerSceneLogic:EnterGame()
  self.inGame = true
  self:SyncCamera(true)
end

function LWSeasonTowerSceneLogic:CheckLoadingState()
  if self.sceneSegmentLogic == nil then
    return false
  end
  return self.sceneSegmentLogic:CheckLoadingState()
end

function LWSeasonTowerSceneLogic:OnUpdate(dt)
  if not self.inLogic or not self.inGame then
    return
  end
  local squadRoot = self:GetSquadRoot()
  if squadRoot == nil then
    return
  end
  if self.waitingReadyTime then
    self.waitingReadyTime = self.waitingReadyTime - dt
    if self.isPreparingGo and self.waitingReadyTime < 0 then
      self:DoPlayEffect(self.levelList, self.resultFloors)
    end
  end
  local pos = squadRoot.transform.localPosition
  local squadNewPosZ = self:UpdateSquadMovePos(pos.z, dt)
  self:UpdateFailedRetreat(dt)
  local isSquadMoving = self:IsSquadMoving(squadNewPosZ)
  if self.cameraLogic and not self.noneLevelPass then
    self.cameraLogic:UpdateMoveState(dt, squadNewPosZ, isSquadMoving)
  end
  self:CheckEnemyEncounter(squadNewPosZ)
  self:ApplySquadPosition(squadRoot, pos, squadNewPosZ)
  self:UpdateSceneSegments()
end

function LWSeasonTowerSceneLogic:UpdateSquadMovePos(currentPosZ, dt)
  if self.moveTargetPosZ == nil then
    return currentPosZ
  end
  local toTarget = self.moveTargetPosZ - currentPosZ
  local dir = 0 <= toTarget and 1 or -1
  local remainDistance = math.abs(toTarget)
  if 0 <= toTarget then
    self.moveSpeed = self.lastForwardSpeed or 0
  else
    self.moveSpeed = -EffectConfig.MoveEffect[1].Speed
  end
  local moveDeltaZ = self.moveSpeed * dt
  if remainDistance < math.abs(moveDeltaZ) then
    moveDeltaZ = dir * remainDistance
  end
  local nextPosZ = currentPosZ + moveDeltaZ
  if currentPosZ < self.finalTargetPosZ and nextPosZ > self.finalTargetPosZ and self.cameraLogic and not self.noneLevelPass then
    self.cameraLogic:SetFinalFollowLock(true, self.finalTargetPosZ, self.moveSpeed)
  end
  if math.abs(self.moveTargetPosZ - nextPosZ) <= StopEpsilon then
    nextPosZ = self.moveTargetPosZ
    self:OnMoveTargetReached()
  end
  return nextPosZ
end

function LWSeasonTowerSceneLogic:OnMoveTargetReached()
  self.moveSpeed = 0
  if self.isRetreatingToFinal then
    self.isRetreatingToFinal = false
    self.moveTargetPosZ = nil
    self.extraStopPosZ = nil
    self.sweeping = false
    self:OnSweepStateChange()
    if self.cameraLogic and not self.noneLevelPass then
      self.cameraLogic:SetFinalFollowLock(false)
    end
    if self.squadLogic then
      self.squadLogic:PlayIdleAnim()
    end
    return
  end
  if self:IsMovingToExtraStopPos() then
    self.moveTargetPosZ = nil
    self.waitRetreatAfterFailedEffect = true
    self.failedEffectElapsed = 0
    EventManager:GetInstance():Broadcast(EventId.SeasonTowerDestroyEnemyFailed, self.lastForwardLevel)
    self:PlayFailedEffect()
  end
end

function LWSeasonTowerSceneLogic:IsMovingToExtraStopPos()
  return not self.isRetreatingToFinal and self.extraStopPosZ ~= nil and self.finalTargetPosZ ~= nil and math.abs(self.moveTargetPosZ - self.extraStopPosZ) <= StopEpsilon
end

function LWSeasonTowerSceneLogic:UpdateFailedRetreat(dt)
  if not self.waitRetreatAfterFailedEffect then
    return
  end
  self.failedEffectElapsed = self.failedEffectElapsed + dt
  if not self:IsFailedEffectFinished() then
    return
  end
  self.waitRetreatAfterFailedEffect = false
  self.isRetreatingToFinal = true
  self.moveTargetPosZ = self.finalTargetPosZ
end

function LWSeasonTowerSceneLogic:IsSquadMoving(squadPosZ)
  if math.abs(self.moveSpeed) > 0.01 then
    return true
  end
  return self.moveTargetPosZ ~= nil and math.abs(self.moveTargetPosZ - squadPosZ) > StopEpsilon
end

function LWSeasonTowerSceneLogic:CheckEnemyEncounter(squadPosZ)
  local sceneIndex = math.floor(squadPosZ / DEFAULT_SEGMENT_LENGTH) + 1
  if self.enemyList[sceneIndex] == nil then
    self:CreateFakeEnemy(sceneIndex)
  end
  local enemy = self.enemyList[sceneIndex]
  if not (enemy ~= nil and enemy.alive) or self.curLevel <= 0 or 0 >= self.moveSpeed then
    return
  end
  local armyPos = enemy.armyRoot.transform.localPosition
  if squadPosZ > armyPos.z - 9 then
    enemy:ExecuteDestroyAnim(self.curLevel, self.levelFloor)
    self:PlayEffectSequence()
  end
end

function LWSeasonTowerSceneLogic:ApplySquadPosition(squadRoot, pos, squadPosZ)
  squadRoot.transform:Set_localPosition(pos.x, pos.y, squadPosZ)
  squadRoot.transform:Set_localEulerAngles(0, 0, 0)
end

function LWSeasonTowerSceneLogic:UpdateSceneSegments()
  if self.sceneSegmentLogic == nil then
    return
  end
  self.sceneSegmentLogic:UpdateCurScene(self:GetCameraLookTargetPos())
end

function LWSeasonTowerSceneLogic:OnLateUpdate()
  self:SyncCamera(false)
end

function LWSeasonTowerSceneLogic:OnDestroy()
  self.inLogic = false
  self.inGame = false
  if self.sceneSegmentLogic then
    self.sceneSegmentLogic:Shutdown()
    self.sceneSegmentLogic = nil
  end
  if self.cameraLogic then
    self.cameraLogic:Shutdown()
    self.cameraLogic = nil
  end
  self.curLevel = -1
  self.sweeping = false
  self:DestroyFakeEnemy()
  self:DestroySquad()
  self.param = nil
end

function LWSeasonTowerSceneLogic:TryPlayEffect(levelList, resultFloors)
  self.levelList = levelList or {}
  self.resultFloors = resultFloors or {}
  local stageData = DataCenter.LWSeasonTowerManager:GetSelectStage()
  if stageData then
    self.currentFloor = stageData.floor
  end
  self.isPreparingGo = true
  self:DoPlayEffect(levelList, resultFloors)
end

function LWSeasonTowerSceneLogic:DoPlayEffect(levelList, resultFloors)
  if self.waitingReadyTime and self.waitingReadyTime > 0 or not self.isPreparingGo then
    return
  end
  self.isPreparingGo = false
  self.showLevelList = {}
  if levelList ~= nil then
    for i = 1, #levelList do
      self.showLevelList[i] = levelList[i]
    end
  end
  self.resultFloors = resultFloors or {}
  self.noneLevelPass = #self.showLevelList == 0
  local squadRoot = self:GetSquadRoot()
  if squadRoot == nil then
    return
  end
  local _, _, z = squadRoot.transform:Get_position()
  self.finalTargetPosZ = z + #self.showLevelList * DEFAULT_SEGMENT_LENGTH
  self.extraStopPosZ = self.finalTargetPosZ + ARMY_BIRTH_POSITION_Z - 10
  self.isRetreatingToFinal = false
  self.lastForwardSpeed = 0
  self.lastForwardLevel = -1
  self.waitRetreatAfterFailedEffect = false
  self.failedEffectElapsed = 0
  self.moveSpeed = 0
  if self.cameraLogic and not self.noneLevelPass then
    self.cameraLogic:ResetSweepState()
    self.cameraLogic:SetFollowLock(0 < #self.showLevelList)
  end
  if 0 < #self.showLevelList or self.noneLevelPass then
    self.moveTargetPosZ = self.extraStopPosZ
  else
    self.moveTargetPosZ = nil
  end
  self:SetShowSceneList(self.showLevelList, self.currentFloor)
  if self.noneLevelPass then
    self.showLevelList = {1}
  end
  self.sweeping = true
  self:OnSweepStateChange()
  self:PlayEffectSequence()
  if self.squadLogic then
    self.squadLogic:PlayRunAnim()
  end
  self.startSweepSoundId = DataCenter.LWSoundManager:PlaySound(SeasonTowerConfig.Sound.SweepStartSound, false)
end

function LWSeasonTowerSceneLogic:OnSweepStateChange()
  EventManager:GetInstance():Broadcast(EventId.SeasonTowerSweepStageChange, {
    isSweeping = self.sweeping,
    showLevelList = self.showLevelList,
    noneLevelPass = self.noneLevelPass
  })
  if self.squadLogic then
    self.squadLogic:ChangeSweepingState(self.sweeping)
  end
  for _, v in pairs(self.enemyList) do
    v:ChangeSweepingState(self.sweeping)
  end
end

function LWSeasonTowerSceneLogic:PlayEffectSequence()
  Logger.LogInfo("GetEffectShowListForLeftFloor => ", table.concat(self.showLevelList, ","))
  local level = table.remove(self.showLevelList, 1)
  local levelFloor = table.remove(self.resultFloors, 1)
  if not self.noneLevelPass then
    self:UpdateSceneData(level, levelFloor)
  end
  self:PlayEffect(level, levelFloor)
end

function LWSeasonTowerSceneLogic:SetShowSceneList(showLevelList, currentFloor)
  self.sceneSegmentLogic:SetShowSceneList(showLevelList, currentFloor)
end

function LWSeasonTowerSceneLogic:UpdateSceneData(level, levelFloor)
  if level == nil then
    return
  end
  local stageData = DataCenter.LWSeasonTowerManager:GetSelectStage()
  if stageData == nil then
    return
  end
  if self.currentFloor == nil then
    self.currentFloor = stageData.floor
  end
  self.currentFloor = self.currentFloor + levelFloor
  local army = stageData:GetArmyByFloor(self.currentFloor)
  if army == nil then
    return
  end
  local difficultyTemplate = LWSeasonTowerUtil.GetDifficulty(stageData.stageId, self.currentFloor)
  if difficultyTemplate == nil then
    return
  end
  self.levelId = army.armyId
  self.sceneId = difficultyTemplate.show
end

function LWSeasonTowerSceneLogic:PlayEffect(level, levelFloor)
  local data = EffectConfig.MoveEffect[level]
  if data == nil then
    self.curLevel = -1
    if self.startSweepSoundId then
      DataCenter.LWSoundManager:StopSound(self.startSweepSoundId)
    end
    return
  end
  self.curLevel = level
  self.levelFloor = levelFloor
  self.lastForwardSpeed = data.Speed
  self.lastForwardLevel = level
  if self.squadLogic then
    self.squadLogic:PlayEffect(data.Effect)
    self.squadLogic:PlayImpactEffect(data.ImpactEffect)
  end
end

function LWSeasonTowerSceneLogic:ShowReadyEffect()
  self.waitingReadyTime = ReadyMinTime
  if self.squadLogic then
    self.squadLogic:ShowReadyEffect()
  end
end

function LWSeasonTowerSceneLogic:ClearReadyEffect()
  if self.squadLogic then
    self.squadLogic:ClearReadyEffect()
  end
end

function LWSeasonTowerSceneLogic:PlayFailedEffect()
  local level = self.lastForwardLevel
  local data = level and EffectConfig.MoveEffect[level] or nil
  local failedEffectPath = data and data.FailedEffect or nil
  if failedEffectPath == nil then
    return
  end
  if self.squadLogic then
    self.squadLogic:PlayEffect(failedEffectPath, nil, true)
  end
  self.cameraLogic:DoCameraShake()
end

function LWSeasonTowerSceneLogic:IsFailedEffectFinished()
  return self.failedEffectElapsed >= FailedEffectWaitTime
end

function LWSeasonTowerSceneLogic:ChangeStage(param)
  self.param = param or {}
  self.levelId = param.levelId
  self.sceneId = param.sceneId
  self:CreateHeroes()
end

function LWSeasonTowerSceneLogic:CreateHeroes()
  self:CreateFakeEnemy(1)
  self:CreateSquad()
end

function LWSeasonTowerSceneLogic:CreateFakeEnemy(sceneIndex)
  if self.enemyList[sceneIndex] then
    return
  end
  local enemy = LWSeasonTowerEnemyLogic.New()
  enemy:Init({
    sceneIndex = sceneIndex,
    levelId = self.levelId,
    sceneId = self.sceneId,
    sweeping = self.sweeping
  })
  self.enemyList[sceneIndex] = enemy
end

function LWSeasonTowerSceneLogic:DestroyFakeEnemy()
  for _, v in pairs(self.enemyList) do
    v:DestroyFakeEnemy()
  end
  self.enemyList = {}
end

function LWSeasonTowerSceneLogic:CreateSquad()
  if self.squadLogic == nil then
    self.squadLogic = LWSeasonTowerSquadLogic.New()
  end
  self.squadLogic:Init({
    sceneId = self.sceneId,
    enterType = self.param.enterType,
    sweeping = self.sweeping
  })
end

function LWSeasonTowerSceneLogic:DestroySquad()
  if self.squadLogic then
    self.squadLogic:DestroySquad()
    self.squadLogic = nil
  end
end

function LWSeasonTowerSceneLogic:OnSceneLoadFinish(sceneRoot)
  self.mgr:OnLoadDone()
  self:CreateHeroes()
end

function LWSeasonTowerSceneLogic:GetSquadRoot()
  if self.squadLogic == nil then
    return nil
  end
  return self.squadLogic:GetRoot()
end

function LWSeasonTowerSceneLogic:GetCameraLookTargetPos()
  if self.cameraLogic == nil then
    return nil
  end
  return self.cameraLogic:GetLookTargetPos()
end

function LWSeasonTowerSceneLogic:SyncCamera(force)
  if self.cameraLogic and not self.noneLevelPass then
    self.cameraLogic:Sync(force)
  end
end

return LWSeasonTowerSceneLogic
