local LWHummerSceneLogic = BaseClass("LWHummerSceneLogic", CEventable)
local Plane = _ENV.Plane
local Touch = CS.BitBenderGames.TouchWrapper
local FSMachine = require("Common.FSMachine")
local Data = require("Scene.LWHummerScene.LWHummerSceneData")
local Scene = require("Scene.LWHummerScene.LWHummerScene")
local Constant = require("Scene.LWHummerScene.LWHummerSceneConstant")
local UnitManager = require("Scene.LWHummerScene.Unit.LWHummerSceneUnitManager")
local EffectObjManager = require("Scene.LWBattle.EffectObj.EffectObjManager")
local BulletManager = require("Scene.LWHummerScene.Bullet.LWHummerSceneBulletManager")
local LWHummerSceneBattleManager = require("Scene.LWHummerScene.Battle.LWHummerSceneBattleManager")
LWHummerSceneLogic.State = {
  None = 0,
  Init = 1,
  Ready = 2,
  Play = 3,
  PreBattle = 4,
  Battle = 5,
  ExitBattle = 6
}

function LWHummerSceneLogic:__init()
  self:AddListener()
end

function LWHummerSceneLogic:__delete()
  self:OnDestroy()
end

function LWHummerSceneLogic:OnDestroy()
  self.inLogic = false
  self:RemoveListener()
  if self.fsm ~= nil then
    self.fsm:Dispose()
    self.fsm = nil
  end
  self:ExitBattle()
  if self.scenes then
    for _, scene in pairs(self.scenes) do
      scene:OnDestroy()
    end
    self.scenes = nil
  end
  self.curScene = nil
  if self.unitMgr then
    self.unitMgr:OnDestroy()
    self.unitMgr = nil
    self.units = nil
  end
  if self.effectObjMgr then
    self.effectObjMgr:Delete()
    self.effectObjMg = nil
  end
  if self.bulletMgr then
    self.bulletMgr:Delete()
    self.bulletMgr = nil
  end
  if self.data then
    self.data:Delete()
    self.data = nil
  end
end

function LWHummerSceneLogic:AddListener()
  self:RegisterEvent(EventId.HangRewardRefreshed, self.RefreshNextRewardTime)
  self:RegisterEvent(EventId.JeepAdventureChangePage, self.OnJeepAdventureChangePage)
end

function LWHummerSceneLogic:RemoveListener()
  self:UnregisterEvent(EventId.HangRewardRefreshed)
  self:UnregisterEvent(EventId.JeepAdventureChangePage)
end

function LWHummerSceneLogic:Enter(param)
  self.inLogic = true
  self.param = param
  self.mgr = DataCenter.LWHummerSceneManager
  self.data = Data.New()
  self.staticMgr = nil
  self.rvoMgr = nil
  self.camera = nil
  self.touchCamera = nil
  self.scenes = {}
  self.sceneCount = 0
  self.curScene = nil
  self.unitMgr = UnitManager.New()
  self.units = {}
  self.effectObjMgr = EffectObjManager.New()
  self.bulletMgr = BulletManager.New(self)
  self.cameraOffset = self.data.stage.cameraOffset
  self.curState = self.State.None
  self.fsm = FSMachine.Create(self)
  self.fsm:Add(self.State.Init, require("Scene.LWHummerScene.State.Logic.LWHummerSceneLogicInit").Create())
  self.fsm:Add(self.State.Ready, require("Scene.LWHummerScene.State.Logic.LWHummerSceneLogicReady").Create())
  self.fsm:Add(self.State.Play, require("Scene.LWHummerScene.State.Logic.LWHummerSceneLogicPlay").Create())
  self.fsm:Add(self.State.PreBattle, require("Scene.LWHummerScene.State.Logic.LWHummerSceneLogicPreBattle").Create())
  self.fsm:Add(self.State.Battle, require("Scene.LWHummerScene.State.Logic.LWHummerSceneLogicBattle").Create())
  self.fsm:Add(self.State.ExitBattle, require("Scene.LWHummerScene.State.Logic.LWHummerSceneLogicExitBattle").Create())
  self:ChangeState(self.State.Init, function()
    self.mgr:OnLoadDone()
    self:ChangeState(self.State.Ready)
  end)
end

function LWHummerSceneLogic:EnterGame()
  if self.curState == self.State.Ready then
    self:ChangeState(self.State.Play)
  end
end

function LWHummerSceneLogic:OnUpdate(dt)
  if not self.inLogic then
    return
  end
  if self.fsm then
    self.fsm:Update(dt)
  end
  for k, v in pairs(self.units) do
    v:OnUpdate(dt)
  end
  if self.touchCamera then
    local tarPos = self.touchCamera:GetCameraTargetPos()
    local viewTile = SceneUtils.WorldToTile(tarPos + Constant.SCENE_VIEW_OFFSET)
    if self.staticMgr then
      self.staticMgr:OnUpdate(viewTile.x, viewTile.y)
    end
  end
  if self.fingerDown then
    self:OnFingerHold(dt)
  end
  if self.bulletMgr then
    self.bulletMgr:OnUpdate(dt)
  end
  if self.effectObjMgr then
    self.effectObjMgr:OnUpdate()
  end
  self:UpdateCurScene()
  self:SyncCamera(dt)
end

function LWHummerSceneLogic:CheckLoadingState()
  return self.curState > self.State.Init
end

function LWHummerSceneLogic:ChangeState(targetState, param)
  if self.curState == targetState then
    return
  end
  self.fsm:Switch(targetState, param)
  self.curState = targetState
end

function LWHummerSceneLogic:RefreshNextRewardTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local timeDelta = (curTime - DataCenter.StageManager.lastIdleRewardTimeStamp) / 1000
  local nextRewardTime
  if timeDelta < DataCenter.StageManager.hangUpMaxTime / 1000 then
    local minTime = LuaEntry.DataConfig:TryGetNum("stage_idle_reward", "k1")
    nextRewardTime = math.ceil(timeDelta / minTime) * minTime - timeDelta
  end
  self.nextRewardTime = nextRewardTime
end

function LWHummerSceneLogic:LoadSceneByCount(loadCount, callback)
  local function GetLastSceneData()
    local z = 0
    
    local res
    if self.scenes ~= nil then
      local lastScene = self.scenes[#self.scenes]
      if lastScene and z < lastScene.sceneData.endZ then
        res = lastScene.sceneData
      end
    end
    return res
  end
  
  if not self.data then
    return
  end
  local sceneConfigs = self.data:GetSceneConfigs(self.sceneCount + 1, loadCount)
  local finishedScene = 0
  for i, sceneCfg in ipairs(sceneConfigs) do
    local lastData = GetLastSceneData()
    local lastZ = 0
    local lastIndex = 0
    if lastData ~= nil then
      lastZ = lastData.endZ
      lastIndex = lastData.index
    end
    local data = {}
    data.config = sceneCfg
    data.startZ = lastZ
    data.endZ = lastZ + sceneCfg.sizeZ
    data.index = lastIndex + 1
    local scene = Scene.New(data, self)
    scene:OnLoad(function()
      finishedScene = finishedScene + 1
      if finishedScene >= #sceneConfigs and callback then
        callback()
      end
    end)
    table.insert(self.scenes, scene)
    self.sceneCount = self.sceneCount + 1
  end
end

function LWHummerSceneLogic:GetSceneByIndex(sceneIndex)
  if self.scenes then
    for i, v in pairs(self.scenes) do
      if v and v.sceneData and v.sceneData.index == sceneIndex then
        return v
      end
    end
  end
end

function LWHummerSceneLogic:UpdateCurScene()
  if self.camera ~= nil and self.scenes ~= nil and self.data ~= nil then
    local curZ = self:GetFollowCameraTarget().z - self.cameraOffset.z
    if self.curScene ~= nil and self.curScene:IsContainsZ(curZ) then
      return
    end
    local newScene
    for i, v in pairs(self.scenes) do
      if v:IsContainsZ(curZ) then
        newScene = v
      end
    end
    if newScene then
      local preSceneData
      local curSceneData = newScene.sceneData
      if self.curScene then
        local preScene = self.curScene:GetPreviousScene()
        if preScene then
          preScene:OnDestroy()
          table.removebyvalue(self.scenes, preScene)
        end
        preSceneData = self.curScene.sceneData
        self:LoadSceneByCount(1)
      end
    end
    self.curScene = newScene
  end
end

function LWHummerSceneLogic:OnFingerDown(pos)
  if not self.fsm.currState or not self.fsm.currState.canInput then
    return
  end
  self.fingerDown = true
  local ray = self.touchCamera:ScreenPointToRay(pos)
  local plane = Plane.New(Vector3.up, 0)
  local hit, dis = plane:Raycast(ray)
  local hitPoint = ray:GetPoint(dis)
  self.lastFingerPosX = hitPoint.x
end

function LWHummerSceneLogic:OnFingerUp()
  self.fingerDown = false
end

function LWHummerSceneLogic:OnFingerHold(dt)
  if not self.fingerDown then
    if self.hasHorizonMove then
      self.player:ChangeHorizontalMoveState(self.player.HorizontalMoveState.Idle, 0)
    end
    return
  end
  if not (self.fsm and self.fsm.currState) or not self.fsm.currState.canInput then
    if self.hasHorizonMove then
      self.player:ChangeHorizontalMoveState(self.player.HorizontalMoveState.Idle, 0)
    end
    return
  end
  local pos
  if 0 < Touch.TouchCount then
    local touch = Touch.Touches[0]
    pos = touch.Position
  end
  if not pos then
    if self.hasHorizonMove then
      self.player:ChangeHorizontalMoveState(self.player.HorizontalMoveState.Idle, 0)
    end
    return
  end
  self.player:AddOneBuff(self.data.stage.fingerDownBuff)
  local curPos = self.player:GetPosition()
  local nowX = curPos.x
  local ray = self.touchCamera:ScreenPointToRay(pos)
  local plane = Plane.New(Vector3.up, 0)
  local hit, dis = plane:Raycast(ray)
  local hitPoint = ray:GetPoint(dis)
  local delta = hitPoint.x - self.lastFingerPosX
  local absDelta = math.abs(delta)
  if absDelta < Constant.DISPLACE_EPSILON then
    if self.hasHorizonMove then
      self.player:ChangeHorizontalMoveState(self.player.HorizontalMoveState.Idle, 0)
    end
    self.hasHorizonMove = false
  else
    self.hasHorizonMove = true
    local clamp = self:ClampMoveX(nowX + delta * self.data.stage.playerHSpeed)
    self.lastFingerPosX = hitPoint.x
    self.player:SetPosition(clamp, curPos.z)
    if 0 < delta then
      self.player:ChangeHorizontalMoveState(self.player.HorizontalMoveState.Right, absDelta)
    else
      self.player:ChangeHorizontalMoveState(self.player.HorizontalMoveState.Left, absDelta)
    end
  end
end

function LWHummerSceneLogic:ClampMoveX(x)
  return Mathf.Clamp(x, Constant.SCENE_SAFE_X[1], Constant.SCENE_SAFE_X[2])
end

LWHummerSceneLogic.velocity = Vector3.unity_vector3(0, 0, 0)
LWHummerSceneLogic.smoothTime = 0.2
LWHummerSceneLogic.tmpV1 = Vector3.New(0, 0, 0)
LWHummerSceneLogic.tmpV2 = Vector3.New(0, 0, 0)
LWHummerSceneLogic.tmpV3 = Vector3.New(0, 0, 0)

function LWHummerSceneLogic:GetFollowCameraTarget()
  if self.followCameraTarget == nil then
    self.followCameraTarget = Vector3.New(0, 0, 0)
  end
  return self.followCameraTarget
end

function LWHummerSceneLogic:CameraFollowLookAt(targetPos)
  local transform = self.touchCamera.transform
  local x, y, z = transform:Get_position()
  local followCameraTarget = self:GetFollowCameraTarget()
  local offsetX = targetPos.x - followCameraTarget.x
  local offsetY = targetPos.y - followCameraTarget.y
  local offsetZ = targetPos.z - followCameraTarget.z
  transform:Set_position(x + offsetX, y + offsetY, z + offsetZ)
  followCameraTarget.x = targetPos.x
  followCameraTarget.y = targetPos.y
  followCameraTarget.z = targetPos.z
end

function LWHummerSceneLogic:LookAt(lookWorldPosition)
  local followTarget = self:GetFollowCameraTarget()
  followTarget.x = lookWorldPosition.x
  followTarget.y = lookWorldPosition.y
  followTarget.z = lookWorldPosition.z
  self.touchCamera:LookAt(lookWorldPosition)
end

function LWHummerSceneLogic:SyncCamera(dt)
  if not (self.fsm.currState and self.fsm.currState.syncCamera) or not self.player then
    return
  end
  self:UpdateCurCameraOffset(dt)
  local v1 = self:GetFollowCameraTarget()
  self.tmpV1:Set(v1.x, v1.y, v1.z)
  self.tmpV2:Set(self.data:GetSceneCenterX() + self.cameraOffset.x, self.cameraOffset.y, self.player:GetPosition().z + self.cameraOffset.z)
  self.tmpV2.x = self.tmpV2.x + self.tmpV3.x * 0.3
  self.tmpV2.y = self.tmpV2.y + self.tmpV3.y * 0.3
  self.tmpV2.z = self.tmpV2.z + self.tmpV3.z * 0.3
  local distance = true
  if math.abs(self.tmpV1.x - self.tmpV2.x) < 0.01 and math.abs(self.tmpV1.y - self.tmpV2.y) < 0.01 and math.abs(self.tmpV1.z - self.tmpV2.z) < 0.01 then
    distance = false
    self.velocity.x, self.velocity.y, self.velocity.z = 0, 0, 0
  end
  if distance then
    local targetPos, v = Vector3.SmoothDamp(v1, self.tmpV2, self.velocity, self.smoothTime)
    self.velocity = v
    self:CameraFollowLookAt(targetPos)
  end
end

function LWHummerSceneLogic:UpdateCurCameraOffset(dt)
  local offset = self.data.stage.cameraOffset
  if self.player and self.player.buffState[HummerSceneBuffType.TriggerSpeedAdd] and self.player.buffState[HummerSceneBuffType.TriggerSpeedAdd].buffNum > 0 then
    offset = self.data.stage.cameraSpeedOffset
  end
  self.cameraOffset = offset
end

function LWHummerSceneLogic:AddUnit(param, resLoadCallback)
  local unit = self.unitMgr:Get(param, resLoadCallback)
  self.units[unit.guid] = unit
  return unit
end

function LWHummerSceneLogic:RemoveUnit(unit)
  if self.jumpZombieList then
    for i, v in ipairs(self.jumpZombieList) do
      if v.jumpZombie and v.jumpZombie == unit then
        v.jumpZombie = nil
        break
      end
    end
  end
  self.units[unit.guid] = nil
  self.unitMgr:Recycle(unit)
end

function LWHummerSceneLogic:GetUnit(guid)
  local unit
  if self.units[guid] then
    unit = self.units[guid]
  end
  return unit
end

function LWHummerSceneLogic:AddPlayer(resLoadCallback)
  local param = {}
  param.unitType = HummerSceneUnitType.Player
  param.logic = self
  local bornData = {}
  param.bornData = bornData
  bornData.pos = self.data:GetPlayerBirthPos()
  bornData.prefabPath = self.data:GetMainPlayerResPath()
  local unit = self:AddUnit(param, resLoadCallback)
  self.player = unit
  local camPos = Vector3.New(self.data:GetSceneCenterX(), 0, self.player:GetPosition().z) + self.data.stage.cameraOffset
  self:LookAt(camPos)
  return unit
end

function LWHummerSceneLogic:RefreshTruckGoods()
  if self.player then
    self.player:RefreshTruckGoods()
  end
end

function LWHummerSceneLogic:AddZombie(type, resLoadCallback)
  local unit
  if self.player then
    local param = {}
    param.unitType = HummerSceneUnitType.Zombie
    param.logic = self
    local bornData = {}
    param.bornData = bornData
    local z = self.player:GetPosition().z
    bornData.pos = self.data:GetRandomZombieSpawnPos(z)
    local cfg = self.data:GetRandomZombieCfg(type)
    bornData.prefabPath = cfg.asset
    bornData.cfgId = cfg.id
    unit = self:AddUnit(param, resLoadCallback)
  end
  return unit
end

function LWHummerSceneLogic:AddTrigger(resLoadCallback)
  local unit
  if self.player then
    local param = {}
    param.unitType = HummerSceneUnitType.Trigger
    param.logic = self
    local bornData = {}
    param.bornData = bornData
    local z = self.player:GetPosition().z
    bornData.pos = self.data:GetRandomTrggerSpawnPos(z)
    bornData.cfgId = self.data:GetRandomTriggerId()
    if bornData.cfgId == 2 then
      for i, v in pairs(self.units) do
        if v.bornData and v.unitType == HummerSceneUnitType.Trigger and v.bornData.cfgId == bornData.cfgId then
          bornData.cfgId = 1
          break
        end
      end
    end
    bornData.prefabPath = self.data:GetTriggerTemplate(bornData.cfgId).prefabPath
    unit = self:AddUnit(param, resLoadCallback)
  end
  return unit
end

function LWHummerSceneLogic:AddDrop(position, resLoadCallback)
  local unit
  if self.player then
    local param = {}
    param.unitType = HummerSceneUnitType.Drop
    param.logic = self
    param.sceneRoot = self.player.transform
    local bornData = {}
    param.bornData = bornData
    bornData.pos = position
    bornData.prefabPath = self.data:GetRandomDropPath()
    unit = self:AddUnit(param, resLoadCallback)
  end
  EventManager:GetInstance():Broadcast(EventId.JeepAdventureAddMultiKill)
  return unit
end

function LWHummerSceneLogic:AddAir(resLoadCallback)
  local unit
  if self.player then
    local param = {}
    param.unitType = HummerSceneUnitType.Air
    param.logic = self
    local bornData = {}
    param.bornData = bornData
    local pos = self.player:GetPosition()
    bornData.pos = Vector3.New(self.data:GetSceneCenterX(), pos.y, pos.z + Constant.AIR_POSITION_Z)
    bornData.prefabPath = self.data.stage.airPrefabPath
    unit = self:AddUnit(param, resLoadCallback)
  end
  return unit
end

function LWHummerSceneLogic:GetUnitType(guid)
  local unitType = HummerSceneUnitType.None
  if self.units[guid] then
    unitType = self.units[guid].unitType
  end
  return unitType
end

function LWHummerSceneLogic:GetUnitByType(unitType)
  local unit
  for k, v in pairs(self.units) do
    if v.unitType == unitType then
      unit = v
      break
    end
  end
  return unit
end

function LWHummerSceneLogic:GetDominatorMoveTarget()
  local unit
  for k, v in pairs(self.units) do
    if v.unitType == HummerSceneUnitType.Zombie and v.curState == v.State.Run and v:GetPosition().z >= self.dominator:GetPosition().z then
      unit = v
      break
    end
  end
  return unit
end

function LWHummerSceneLogic:GetDominatorBattleTarget()
  if self.inBattle and self.battleMgr then
    return self.battleMgr.unitMgr:GetNearestUnitBySearchTypes(UnitType.Zombie, self.dominator:GetPosition())
  end
end

function LWHummerSceneLogic:AddJumpZombie(resLoadCallback)
  if self.jumpZombieList == nil then
    self.jumpZombieList = {}
    local transList = self.player:GetJumpZombieTransList()
    for i, v in ipairs(transList) do
      local data = {}
      data.transform = v
      data.index = i
      table.insert(self.jumpZombieList, data)
    end
  end
  local free
  local num = 0
  for i, v in ipairs(self.jumpZombieList) do
    if v.jumpZombie == nil then
      num = num + 1
      if 2 <= num then
        free = v
        break
      end
    end
  end
  local unit
  if free then
    local param = {}
    param.unitType = HummerSceneUnitType.JumpZombie
    param.logic = self
    param.sceneRoot = nil
    local bornData = {}
    param.bornData = bornData
    local z = self.player:GetPosition().z
    local x, _, _ = free.transform:Get_position()
    bornData.pos = self.data:GetRandomJumpZombieSpawnPos(z, x, free.index)
    local cfg = self.data:GetRandomZombieCfg(self.data.ZombiePoolType.Drop)
    bornData.prefabPath = cfg.asset
    bornData.cfgId = cfg.id
    bornData.targetTrans = free.transform
    bornData.targetTransDirType = free.index <= 3 and 1 or 2
    unit = self:AddUnit(param, resLoadCallback)
    free.jumpZombie = unit
  end
  return unit
end

function LWHummerSceneLogic:DropJumpZombie()
  if self.jumpZombieList then
    for i, v in ipairs(self.jumpZombieList) do
      if v.jumpZombie then
        v.jumpZombie:OnDropJumpZombie()
      end
    end
  end
end

function LWHummerSceneLogic:AddDominator(resLoadCallback)
  if self.dominator == nil then
    local unit
    if self.player then
      local param = {}
      param.unitType = HummerSceneUnitType.Dominator
      param.logic = self
      local bornData = {}
      param.bornData = bornData
      local pos = self.player:GetPosition()
      bornData.pos = Vector3.New(self.data:GetSceneCenterX(), pos.y, pos.z + self.data:GetDominatorSpawnOffset())
      bornData.prefabPath = self.data:GetCurDominatorPath()
      bornData.cfgId = self.data:GetCurDominatorId()
      unit = self:AddUnit(param, resLoadCallback)
    end
    self.dominator = unit
  end
  return self.dominator
end

function LWHummerSceneLogic:AddOneJumpZombieSpeedBuff(jumpZombie)
  self.player:AddOneJumpZombieSpeedBuff(jumpZombie)
end

function LWHummerSceneLogic:RemoveOneJumpZombieSpeedBuff(jumpZombie)
  self.player:RemoveOneJumpZombieSpeedBuff(jumpZombie)
end

function LWHummerSceneLogic:ChangeBattle(trigger)
  self:ExitBattle()
  self.battleTrigger = trigger
  self:ChangeState(self.State.PreBattle)
end

function LWHummerSceneLogic:CreateBattle()
  local param = {}
  param.heroList = self.data:GetUnlockHelpHeroList()
  param.monsterCfg = self.battleTrigger.cfg
  param.logic = self
  self.battleMgr = LWHummerSceneBattleManager.New()
  self.battleMgr:Enter(param)
  self.inBattle = true
end

function LWHummerSceneLogic:ExitBattle()
  if self.battleTrigger then
    self.battleTrigger:ShowBattleExit()
    self.battleTrigger = nil
  end
  if self.battleMgr then
    self.battleMgr:Exit()
    self.battleMgr = nil
  end
  self.inBattle = false
end

function LWHummerSceneLogic:GetEnterTransList()
  local transList = {}
  if self.player then
    transList = self.player:GetMembersTransList()
  end
  return transList
end

function LWHummerSceneLogic:ShowEffectObj(path, pos, rot, time, parent, type)
  return self.effectObjMgr:ShowEffectObj(path, pos, rot, time, parent, type)
end

function LWHummerSceneLogic:RemoveEffectObj(id)
  self.effectObjMgr:RemoveEffectObj(id)
end

function LWHummerSceneLogic:CastSkill(metaId, fireTrans, targetPos)
  self.bulletMgr:CreateBulletCreator(metaId, fireTrans, targetPos)
end

function LWHummerSceneLogic:OnJeepAdventureChangePage(pageType)
  if self.dominator then
    if pageType == JeepAdventurePageType.Domintor then
      self.dominator:ChangeState(self.dominator.State.Spawn)
    else
      self.dominator:ChangeState(self.dominator.State.Hide)
    end
  end
end

return LWHummerSceneLogic
