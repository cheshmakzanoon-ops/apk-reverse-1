local base = require("Scene.LWBattle.Surfing.SurfingUnit")
local GhostParkourPlayerUnit = BaseClass("GhostParkourPlayerUnit", base)
local HandleSpeedHelper = require("Scene.LWBattle.GhostParkour.HandleSpeedHelper")
local SurfingPlayerIdleState = require("Scene.LWBattle.Surfing.PlayerFSM.SurfingPlayerIdleState")
local SurfingPlayerRunState = require("Scene.LWBattle.Surfing.PlayerFSM.SurfingPlayerRunState")
local SurfingPlayerFinishState = require("Scene.LWBattle.GhostParkour.PlayerFSM.SurfingPlayerFinishState")
local SurfingPlayerEntranceState = require("Scene.LWBattle.GhostParkour.PlayerFSM.SurfingPlayerEntranceState")
local FSM = require("Framework.Common.FSM")
local pveUnitViewUtil = require("Scene.LWBattle.BarrageBattle.Unit.PveUnitViewUtil")
local UnitViewFacade = CS.PVEBattleLogic.Unit.UnitViewFacade
local BattleColliderUtils = CS.BattleColliderUtils
local PvePhysicsUtil = _ENV.PvePhysicsUtil
local Const = require("Scene.LWBattle.Const")
local GameObject = CS.UnityEngine.GameObject
local VIEW_INVALID_HANDLE = -1
local DefaultLineOffset = 4
local LineOffset = DefaultLineOffset
local LineChangeTime = 0.16
local JumpForce = 16.5
local Gravity = -42
local SlideTime = 0.5
local TakeoffSpeed = 30
local FlyHeight = 20
local FlyTime = 10
local CacheCommandInterval = 0.3
local State = {
  Idle = 1,
  Running = 2,
  Die = 3,
  Entrance = 4,
  Finish = 5
}
local BehaviorState = {
  ChangeLanesFinish = 1,
  SlidingFinish = 2,
  TouchGround = 3,
  FreeFallStart = 4,
  FlyStart = 5
}
local MotionState = SurfingMotionState
local CommandOpType = {
  None = 0,
  Up = 1,
  Down = 2,
  Left = 3,
  Right = 4
}
local JUMP_ANIM_NAME = {"up", "up02"}
local UNIT_EFFECT_PATH = {
  [SurfingUnitEffectType.Resurgence] = "Assets/Main/Prefabs/LWBattle/Surfing/Effect/Eff_s_s4_running_fuhuo.prefab",
  [SurfingUnitEffectType.Sliding] = "Assets/Main/Prefabs/LWBattle/Surfing/Effect/Eff_s_s4_running_huachan_smoke.prefab",
  [SurfingUnitEffectType.GotEnergy] = "Assets/Main/Prefabs/LWBattle/GhostParkour/Effect/Eff_s_s4_running_chinengliang.prefab",
  [SurfingUnitEffectType.GotProps] = "Assets/Main/Prefabs/LWBattle/Surfing/Effect/Eff_s_s4_running_chidaoju.prefab"
}
local EFFECT_PATH = {
  [GhostSpeedEffectType.SpeedUpL1] = "Assets/Main/Prefabs/LWBattle/GhostParkour/Effect/Eff_s_s4_running_jiasu_LV1.prefab",
  [GhostSpeedEffectType.SpeedUpL2] = "Assets/Main/Prefabs/LWBattle/GhostParkour/Effect/Eff_s_s4_running_jiasu_LV2.prefab",
  [GhostSpeedEffectType.SpeedUpL3] = "Assets/Main/Prefabs/LWBattle/GhostParkour/Effect/Eff_s_s4_running_jiasu_LV3.prefab",
  [GhostSpeedEffectType.SpeedUpSuper] = "Assets/Main/Prefabs/LWBattle/GhostParkour/Effect/Eff_s_s4_running_jiasu_chaoji.prefab",
  [GhostSpeedEffectType.Dizziness] = "Assets/Main/Prefabs/LWBattle/GhostParkour/Effect/Eff_s_s4_running_xuanyun.prefab"
}
local BUFF_SOUND_IDS = {
  [GhostSpeedEffectType.SpeedUpL1] = 11031,
  [GhostSpeedEffectType.SpeedUpL2] = 11032,
  [GhostSpeedEffectType.SpeedUpL3] = 11033
}
local BUFF_SOUND_LOOP_IDS = {
  [GhostSpeedEffectType.SpeedUpL1] = 11035,
  [GhostSpeedEffectType.SpeedUpL2] = 11036,
  [GhostSpeedEffectType.SpeedUpL3] = 11037,
  [GhostSpeedEffectType.SpeedUpSuper] = 11038
}

function GhostParkourPlayerUnit:Init(logic, localPos, curLine, hero, speedChangeTime, lineOffset)
  base.Init(self, logic, localPos)
  local go = GameObject("SurfingPlayer")
  self.gameObject = go
  self.transform = go.transform
  LineOffset = lineOffset or DefaultLineOffset
  if DataCenter.LWBattleManager.lineOffset then
    LineOffset = DataCenter.LWBattleManager.lineOffset
    LineChangeTime = DataCenter.LWBattleManager.lineChangeTime
    JumpForce = DataCenter.LWBattleManager.jumpForce
    Gravity = DataCenter.LWBattleManager.gravity
    SlideTime = DataCenter.LWBattleManager.slideTime
  end
  self.curLine = curLine
  self.baseLineX = localPos.x + (0 - curLine) * LineOffset
  self.lineChangeTime = LineChangeTime
  self.localPosition = localPos
  self.lastCameraFollowPos = Vector3.New(localPos.x, localPos.y, localPos.z)
  self.type = Const.ParkourUnitType.Hero
  self.unitType = UnitType.Member
  self.searchType = BattleSearchType.Member
  self.speedChangeTime = speedChangeTime
  self.hero = hero
  if hero then
    self.appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(hero.appearance)
    self.heroId = hero.id
  end
  self.parkourHeroId = self.heroId
  self.maxBlood = 1
  self.curBlood = self.maxBlood
  self.jumpVoValue = JumpForce
  self.gravityValue = Gravity
  self.verticalVelocity = 0
  self.verticalAcceleration = 0
  self.flyHeight = FlyHeight
  self.fadeTime = 0
  self.isWaitingAnimFade = nil
  self.waitFadeAnim = nil
  self:SetLocalPosition(self.localPosition)
  self.viewLoaded = false
  self.viewHandle = VIEW_INVALID_HANDLE
  local scale = 1
  local path
  if self.appearanceMeta then
    scale = self.appearanceMeta and self.appearanceMeta.model_size
    path = self.appearanceMeta.model_path
  end
  self.viewScale = scale
  if path then
    self.viewHandle, self.viewLoaded = pveUnitViewUtil.CreateUnitView(self.guid, path, self.transform, scale, 0, 0, 0, ResetPosition.x, ResetPosition.y, ResetPosition.z, LayerMask.NameToLayer("Member"))
    if self.viewLoaded then
      self:OnViewLoaded(true)
    end
  end
  self.colliderMap = {}
  self.BehaviorState = BehaviorState
  self.lastCacheCommandOp = CommandOpType.None
  self.lastCacheCommandTime = 0
  self.moveSpeed = logic:GetMoveSpeed()
  self.handleSpeedHelper = HandleSpeedHelper.New(self, self.moveSpeed)
  self.totalDeltaTime = 0
  self.buffEffectLevel = 0
  self.curBuffEffectId = nil
  self.speedUpBuffs = 0
  self.nitrogen = false
  self.buffSpeedStall = logic:GetSpeedBoardParam()
  self.nitrogenSpeed = logic:GetNitrogenBuffSpeed() or 0
  self.maxBuffCount = #self.buffSpeedStall
  self.collisionTimer = 0
  self.collisionVersion = 0
  self.cameraPos = Vector3.New(0, 0, 0)
  self.obstacleColliderMap = {}
  self:ChangeMotionState(MotionState.Idle)
end

function GhostParkourPlayerUnit:ComponentDefine()
  self.buffPoints = {}
  local appearanceMeta = self.appearanceMeta
  if not table.IsNullOrEmpty(appearanceMeta.buff_path) then
    for i = 1, #appearanceMeta.buff_path do
      if string.IsNullOrEmpty(appearanceMeta.buff_path[i]) then
        self.buffPoints[i] = nil
      elseif self.viewTransform then
        local buffPoint = self.viewTransform:Find(appearanceMeta.buff_path[i])
        if IsNull(buffPoint) then
          Logger.LogError("buff\231\130\185\232\183\175\229\190\132\233\133\141\231\189\174\233\148\153\232\175\175\239\188\140\229\164\150\232\167\130id\239\188\154" .. self.hero.modelId .. "\239\188\140buff\231\130\185\232\183\175\229\190\132\239\188\154" .. appearanceMeta.buff_path[i])
        end
        self.buffPoints[i] = buffPoint
      end
    end
  end
end

function GhostParkourPlayerUnit:OnViewLoaded(force, objHandle)
  if self.viewLoaded and not force then
    return
  end
  self.viewLoaded = true
  self.viewTransform = UnitViewFacade.GetTransform(self.viewHandle)
  local GhostPlayerMovementHelper = require("Scene.LWBattle.GhostParkour.GhostPlayerMovementHelper")
  self.movementHelper = GhostPlayerMovementHelper.New(self, self.transform, self.speedChangeTime)
  self:SetSpeedParam(self.moveSpeed)
  self:ComponentDefineWithoutView()
  self:ComponentDefine()
  self:InitFSM()
  self:InitPlayerCollider()
  self:InitObstacleCollider()
  if self.logic then
    self.logic:CheckLoadFinish()
  end
  if self.curBlood <= 0 then
    return
  end
end

function GhostParkourPlayerUnit:DestroyView()
  BattleColliderUtils.ClearUnitColliderData()
  BattleColliderUtils.ClearPlayerColliderData()
  BattleColliderUtils.ClearObstacleColliderData()
  base.DestroyView(self)
  UnitViewFacade.DestroyUnitView(self.viewHandle)
  if self.fsm then
    self.fsm:Delete()
    self.fsm = nil
  end
  self.viewHandle = VIEW_INVALID_HANDLE
  self.viewTransform = nil
  self.viewLoaded = false
  if self.triggerRq then
    self.triggerRq:Destroy()
    self.triggerRq = nil
  end
  if self.gameObject then
    GameObject.Destroy(self.gameObject)
    self.gameObject = nil
    self.transform = nil
  end
end

function GhostParkourPlayerUnit:DestroyData()
  base.DestroyData(self)
  self.movementHelper = nil
  if self.flySound ~= nil then
    DataCenter.LWSoundManager:StopSound(self.flySound)
    self.flySound = nil
  end
  self.fadeTime = nil
  self.isWaitingAnimFade = nil
  self.waitFadeAnim = nil
end

function GhostParkourPlayerUnit:InitFSM()
  self.fsm = FSM.New()
  self.fsm:AddState(State.Idle, SurfingPlayerIdleState.New(self))
  self.fsm:AddState(State.Running, SurfingPlayerRunState.New(self))
  self.fsm:AddState(State.Entrance, SurfingPlayerEntranceState.New(self))
  self.fsm:AddState(State.Finish, SurfingPlayerFinishState.New(self))
  if self.cacheState then
    self:ChangeState(self.cacheState)
  elseif self.logic and self.logic.state then
    self:ChangeState(self.logic.state)
  else
    self:ChangeState(Const.SurfingState.Ready)
  end
  self.cacheState = nil
end

function GhostParkourPlayerUnit:ChangeState(newState)
  if self.fsm == nil then
    self.cacheState = newState
    return
  end
  local oldState = self.state
  self.state = newState
  if newState == Const.SurfingState.Ready then
    self.fsm:ChangeState(State.Idle)
  elseif newState == Const.SurfingState.Entrance then
    self.fsm:ChangeState(State.Entrance, self.parkourHeroId)
  elseif newState == Const.SurfingState.Surfing then
    if oldState ~= newState then
      self:PlayRunSound()
    end
    self.fsm:ChangeState(State.Running)
  elseif newState == Const.SurfingState.Win then
    self:StopRunSound()
  end
end

function GhostParkourPlayerUnit:OnUpdate(deltaTime, totalDeltaTime)
  base.OnUpdate(self, deltaTime)
  if self.fsm then
    self.fsm:OnUpdate(deltaTime)
  end
  if self.state == Const.SurfingState.Surfing then
    self:PlayerCalculateCollider()
    self:ObstacleCalculateCollider()
    if self.movementHelper then
      self.movementHelper:Update(deltaTime, totalDeltaTime)
    end
    if self.surfingNpcCtrl then
      self.surfingNpcCtrl:OnUpdate(deltaTime)
    end
    self.totalDeltaTime = totalDeltaTime
    if self.collision then
      self.collisionTimer = self.collisionTimer - deltaTime
      if self.collisionTimer <= 0 then
        self.collision = false
        self:SetSpeed()
        self.logic:LogEvent(EVENT_FLAGS.COLLISION_FINISH, self.speed, self.totalDeltaTime)
      end
    end
  end
  if self.fadeTime and 0 < self.fadeTime then
    self.fadeTime = self.fadeTime - deltaTime
    if 0 >= self.fadeTime and self.isWaitingAnimFade and self.waitFadeAnim then
      self:TryCrossFadeSimpleAnim(self.waitFadeAnim.name, self.waitFadeAnim.speed, self.waitFadeAnim.fadeTime)
    end
  end
end

function GhostParkourPlayerUnit:GetPosition()
  local curFrame = Time.frameCount
  if self.getPosCurFrame == curFrame then
    return self.curWorldPos
  end
  self.getPosCurFrame = curFrame
  if IsNotNull(self.transform) then
    self.curWorldPos.x, self.curWorldPos.y, self.curWorldPos.z = self.transform:Get_position()
    return self.curWorldPos
  else
    return self.localPosition
  end
end

function GhostParkourPlayerUnit:GetCameraFollowXYZ()
  local pos = self:GetPosition()
  if self.motionState == MotionState.AirSliding then
    self.lastCameraFollowPos.z = pos.z
    return self.lastCameraFollowPos.x, self.lastCameraFollowPos.y, self.lastCameraFollowPos.z
  elseif self:IsJumping() then
    self.lastCameraFollowPos.z = pos.z
    if self.lineChangeTimer then
      self.lastCameraFollowPos.x = pos.x
    end
    if pos.y < self.verticalMoveStartY then
      self.lastCameraFollowPos.y = pos.y
    end
    return self.lastCameraFollowPos.x, self.lastCameraFollowPos.y, self.lastCameraFollowPos.z
  end
  self.lastCameraFollowPos.x = pos.x
  self.lastCameraFollowPos.y = pos.y
  self.lastCameraFollowPos.z = pos.z
  return pos.x, pos.y, pos.z
end

function GhostParkourPlayerUnit:SetMoveBase(baseTime, baseDistance, startSpeed, endSpeed, speedChangeTime)
  if self.movementHelper then
    self.movementHelper:UpdateMoveValue(baseTime, baseDistance, startSpeed, endSpeed, speedChangeTime)
  end
end

function GhostParkourPlayerUnit:SetMoveSpeed(speed)
  self.speed = speed
end

function GhostParkourPlayerUnit:GetMoveSpeed()
  return self.speed or self.logic:GetMoveSpeed()
end

function GhostParkourPlayerUnit:BeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, attacker)
  if self:CheckIsInvincible() then
    return
  end
  if self.buffEffectLevel ~= GhostSpeedEffectType.Dizziness then
    if self.curBuffEffectId and self.curBuffEffectId > 0 then
      self.logic:RemoveEffectObj(self.curBuffEffectId)
    end
    self.curBuffEffectId = self:ShowSpeedEffect(GhostSpeedEffectType.Dizziness)
    self.buffEffectLevel = GhostSpeedEffectType.Dizziness
  end
  self.collision = true
  self.logic:RecordBuffList(ParkourBuffType.OBSTACLE, 0, 0, 0)
  self.logic:DoVibration(0.5, 0.3, 0.3)
  if self.speedCutTarget == nil then
    local value = LuaEntry.DataConfig:TryGetStr("parkour_ghost_config", "k14", "")
    local arr = string.split(value, "|")
    if arr and 1 < #arr then
      self.speedCutTarget = tonumber(arr[3])
      self.speedCutTime = tonumber(arr[1])
      self.speedCutDuration = tonumber(arr[2])
    end
  end
  self.collisionTimer = self.speedCutDuration
  if self.speedCutTarget == nil or self.speedCutTime == nil then
    Logger.LogError("cannot find parkour_ghost_config:k14")
    return
  end
  self:SetSpeedParam(self.speedCutTarget, self.speedCutTime)
  local pos = self:GetPosition()
  if attacker == nil then
    Logger.LogError("GhostParkour -- [BeAttack] attacker is nil")
    return
  end
  local dot = PvePhysicsUtil.TryGetGhostPlayerCollideDir(attacker.guid)
  if dot < -0.5 then
    attacker:SetColliderTag()
    DataCenter.LWSoundManager:PlaySound(11029, false)
    self.logic:LogEvent(EVENT_FLAGS.COLLISION, self.speedCutTarget, self.totalDeltaTime)
    attacker:OnMonsterCollided()
    self:ShowUnitEffect(SurfingUnitEffectType.Resurgence)
  elseif dot < 0.5 then
    if self.targetX > pos.x then
      DataCenter.LWSoundManager:PlaySound(11030, false)
      self.logic:LogEvent(EVENT_FLAGS.COLLISION_LEFT, self.speedCutTarget, self.totalDeltaTime)
      self:OnMoveLeft(true)
    else
      DataCenter.LWSoundManager:PlaySound(11030, false)
      self.logic:LogEvent(EVENT_FLAGS.COLLISION_RIGHT, self.speedCutTarget, self.totalDeltaTime)
      self:OnMoveRight(true)
    end
  end
end

function GhostParkourPlayerUnit:AfterBeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, skill, deathEff)
end

function GhostParkourPlayerUnit:CheckIsInvincible()
  return self.invincible or self:IsFlying()
end

function GhostParkourPlayerUnit:ResetColliderHeight()
  BattleColliderUtils.ChangePlayerCollider(self.guid, 1)
end

function GhostParkourPlayerUnit:ChangeBehaviorState(state, param)
  if state == BehaviorState.ChangeLanesFinish then
    self.lineChangeTimer = nil
    if not self:IsFlying() then
      self:ChangeToRunAnim()
    end
  elseif state == BehaviorState.SlidingFinish then
    self:ChangeToRunAnim()
    self:ChangeMotionState(MotionState.Running)
    self.applyCommand = true
  elseif state == BehaviorState.TouchGround then
    if self.motionState == MotionState.AirSliding then
      self:ChangeMotionState(MotionState.GroundSliding)
    else
      self:ChangeToRunAnim()
      if self.motionState ~= MotionState.Running then
        DataCenter.LWSoundManager:PlaySound(11015, false)
      end
      self:ChangeMotionState(MotionState.Running)
      self.applyCommand = true
    end
  elseif state == BehaviorState.FreeFallStart then
    self.verticalVelocity = 0
    self.verticalAcceleration = self.gravityValue
    self.verticalMoveTimer = 0
    self.verticalMoveStartY = param or 0
    self:TryCrossFadeSimpleAnim("fall", 1, 0.2)
    if self.flySound ~= nil then
      DataCenter.LWSoundManager:StopSound(self.flySound)
    end
    if self.motionState == state or self.lineChangeTimer and self.motionState ~= MotionState.ChangeLanesFinish then
    else
      DataCenter.LWSoundManager:PlaySound(11017, false)
    end
    self:ChangeMotionState(MotionState.FreeFalling)
  elseif state == BehaviorState.FlyStart then
    self.flyY = self:GetPosition().y
    self.flySpeed = TakeoffSpeed
    self.flyTimer = FlyTime
    self:TryCrossFadeSimpleAnim("fly", 1, 0.2)
    if self.flySound ~= nil then
      DataCenter.LWSoundManager:StopSound(self.flySound)
    end
    self.flySound = DataCenter.LWSoundManager:PlaySound(11012, true)
    self:ChangeMotionState(MotionState.Flying)
  end
end

function GhostParkourPlayerUnit:ChangeMotionState(state)
  if self.motionState ~= state then
    if self:IsSliding() and state ~= MotionState.AirSliding and state ~= MotionState.GroundSliding then
      self:ResetColliderHeight()
    end
    self.motionState = state
  end
end

function GhostParkourPlayerUnit:IsGrounded()
  return self.motionState == MotionState.Idle or self.motionState == MotionState.Running or self.motionState == MotionState.GroundSliding
end

function GhostParkourPlayerUnit:IsSliding()
  return self.motionState == MotionState.AirSliding or self.motionState == MotionState.GroundSliding
end

function GhostParkourPlayerUnit:IsFlying()
  return self.motionState == MotionState.Flying
end

function GhostParkourPlayerUnit:IsJumping()
  return self.motionState == MotionState.Jumping
end

function GhostParkourPlayerUnit:TryApplyCacheCommand()
  if not self.fsm then
    return
  end
  if not self.state then
    return
  end
  if self.state ~= Const.SurfingState.Surfing then
    return
  end
  if not self.logic then
    return
  end
  if not self.applyCommand then
    return
  end
  self.applyCommand = false
  local cacheCommand = self.lastCacheCommandOp
  self.lastCacheCommandOp = CommandOpType.None
  if cacheCommand == CommandOpType.Up or cacheCommand == CommandOpType.Down then
    local timeDiff = self.logic.totalRunTime - self.lastCacheCommandTime
    if 0 <= timeDiff and timeDiff < CacheCommandInterval then
      if cacheCommand == CommandOpType.Up then
        self:OnMoveUp()
      elseif cacheCommand == CommandOpType.Down then
        self:OnMoveDown()
      end
    end
  end
end

function GhostParkourPlayerUnit:PlayerCalculateCollider()
  ProfilerUtil.BeginSample("SurfingPlayerUnit:PlayerCalculateCollider")
  local resultList = PvePhysicsUtil.GhostPlayerCollider()
  local colliderResultList = resultList
  local colliderResultCount = 0
  if resultList then
    local length = #resultList
    local idPos = false
    local indexPos = 0
    local count = 0
    local index = 0
    if 0 < length and 0 < resultList[1] then
      table.clear(self.colliderMap)
      colliderResultCount = length
      idPos = true
      for i = 1, length do
        local data = resultList[i]
        if data < 0 then
          break
        end
        if idPos then
          idPos = false
          indexPos = 0
          count = data
        else
          if count == 0 or index > count then
            break
          end
          index = index + 1
          self.colliderMap[data] = i
        end
      end
    end
  end
  if 0 < colliderResultCount then
    for objId, countIndex in pairs(self.colliderMap) do
      local monster = self.logic:GetMonster(objId)
      local count = colliderResultList[countIndex]
      if 0 < count then
        if monster then
          self:OnMonsterCollision(monster)
        else
          Logger.LogError("SurfingPlayerUnit.PlayerCalculateCollider invalid monster : " .. tostring(objId))
        end
      end
    end
  end
  ProfilerUtil.EndSample()
end

function GhostParkourPlayerUnit:OnMonsterCollision(monster)
  if monster then
    monster:OnCollisionViewHandle(self, self.collisionVersion)
  end
end

function GhostParkourPlayerUnit:OnBuffAdd(buff)
  if self.state and self.state == Const.SurfingState.Surfing then
    local bType = buff and buff.meta and buff.meta.type
    if bType == BuffType.GhostSpeedUp then
      self.speedUpBuffs = self.speedUpBuffs + 1
      local max = self.maxBuffCount
      self.speedUpBuffs = Mathf.Min(self.speedUpBuffs, max)
      EventManager:GetInstance():Broadcast(EventId.SurfingOnBuffAdd, {
        buff = buff,
        level = self.speedUpBuffs
      })
      self.logic:LogEvent(EVENT_FLAGS.BUFF_SPEED_UP, self.speed, self.totalDeltaTime)
      if self.nitrogen then
        return
      end
      if self.collision then
        return
      end
      self:SetSpeed()
      DataCenter.LWSoundManager:PlaySound(BUFF_SOUND_IDS[self.buffEffectLevel], false)
    elseif bType == BuffType.GhostNitrogen then
      self.logic:LogEvent(EVENT_FLAGS.NITROGEN_SPEED_UP, self.logic:GetNitrogenBuffSpeed(), self.totalDeltaTime)
      self:OnNitrogenSpeedUp()
    end
  end
end

function GhostParkourPlayerUnit:OnBuffRemoved(buff)
  if self.logic == nil then
    return
  end
  if self.state and self.state == Const.SurfingState.Surfing and buff then
    local bType = buff and buff.meta and buff.meta.type
    if bType == BuffType.GhostSpeedUp then
      self.speedUpBuffs = 0
      EventManager:GetInstance():Broadcast(EventId.SurfingOnBuffRemove, buff)
      self.logic:LogEvent(EVENT_FLAGS.BUFF_SPEED_DOWN, self.speed, self.totalDeltaTime)
      if self.nitrogen then
        return
      end
      self:SetSpeed()
    elseif bType == BuffType.GhostNitrogen then
      EventManager:GetInstance():Broadcast(EventId.SurfingOnBuffRemove, buff)
      self.logic:LogEvent(EVENT_FLAGS.NITROGEN_SPEED_DOWN, self.speed, self.totalDeltaTime)
      self.nitrogen = false
      self.logic:OnNitrogenSpeedUpFinished()
      self:SetSpeed()
    end
  end
end

function GhostParkourPlayerUnit:OnMoveLeft(option)
  self.lastCacheCommandOp = CommandOpType.None
  if self.curLine > -1 then
    self.curLine = self.curLine - 1
    self.curX = self:GetPosition().x
    self.targetX = self.baseLineX + self.curLine * LineOffset
    self.lineChangeTimer = LineChangeTime
    if not self:IsFlying() then
      self:TryCrossFadeSimpleAnim("left_jump", 1, 0, true)
      DataCenter.LWSoundManager:PlaySound(11010, false)
    end
    self.logic:LogPlayerInput(INPUT_FLAGS.LEFT)
    if not option then
      self.collisionVersion = self.collisionVersion + 0.001
    end
    return true
  end
  return false
end

function GhostParkourPlayerUnit:OnMoveRight(option)
  self.lastCacheCommandOp = CommandOpType.None
  if self.curLine < 1 then
    self.curLine = self.curLine + 1
    self.curX = self:GetPosition().x
    self.targetX = self.baseLineX + self.curLine * LineOffset
    self.lineChangeTimer = LineChangeTime
    if not self:IsFlying() then
      self:TryCrossFadeSimpleAnim("right_jump", 1, 0, true)
      DataCenter.LWSoundManager:PlaySound(11010, false)
    end
    self.logic:LogPlayerInput(INPUT_FLAGS.RIGHT)
    if not option then
      self.collisionVersion = self.collisionVersion + 0.001
    end
    return true
  end
  return false
end

function GhostParkourPlayerUnit:OnMoveUp()
  if self:IsGrounded() then
    local index = math.random(1, 2)
    local anim = JUMP_ANIM_NAME[index] or JUMP_ANIM_NAME[1]
    self:TryCrossFadeSimpleAnim(anim, 1, 0.2)
    DataCenter.LWSoundManager:PlaySound(11019, false)
    self.verticalVelocity = self.jumpVoValue
    self.verticalAcceleration = self.gravityValue
    self.verticalMoveTimer = 0
    self.verticalMoveStartY = self:GetPosition().y
    if self.motionState == MotionState.GroundSliding then
      self.slideTimer = 0
    end
    self:ChangeMotionState(MotionState.Jumping)
    self.logic:LogPlayerInput(INPUT_FLAGS.UP)
    return true
  end
  self.lastCacheCommandOp = CommandOpType.Up
  self.lastCacheCommandTime = self.logic.totalRunTime
  return false
end

function GhostParkourPlayerUnit:OnMoveDown()
  if self:IsSliding() then
    self.lastCacheCommandOp = CommandOpType.Down
    self.lastCacheCommandTime = self.logic.totalRunTime
    return false
  end
  if self:IsFlying() then
    self.lastCacheCommandOp = CommandOpType.Down
    self.lastCacheCommandTime = self.logic.totalRunTime
    return false
  end
  if not self:IsGrounded() then
    local curV = self.verticalVelocity + self.verticalAcceleration * self.verticalMoveTimer
    self.verticalVelocity = curV
    self.verticalMoveTimer = 0
    local curY = self:GetPosition().y
    local fastDownTime = SlideTime * 0.2
    local newA = 2 * (-curY - curV * fastDownTime) / (fastDownTime * fastDownTime)
    if 0 < newA then
      newA = -newA
      local newV = (-curY - 0.5 * newA * fastDownTime * fastDownTime) / fastDownTime
      self.verticalVelocity = newV
    end
    self.verticalAcceleration = newA
    self.verticalMoveStartY = curY
    self.slideTimer = SlideTime
    self:ChangeMotionState(MotionState.AirSliding)
  else
    self.slideTimer = SlideTime
    self:ChangeMotionState(MotionState.GroundSliding)
  end
  self:TryCrossFadeSimpleAnim("down", 1, 0.1)
  DataCenter.LWSoundManager:PlaySound(11011, false)
  self:ShowUnitEffect(SurfingUnitEffectType.Sliding)
  BattleColliderUtils.ChangePlayerCollider(self.guid, 0.6)
  self.logic:LogPlayerInput(INPUT_FLAGS.DOWN)
  return true
end

function GhostParkourPlayerUnit:InitPlayerCollider()
  BattleColliderUtils.AddPlayerCollider(self.viewHandle, self.guid, LayerMask.GetMask("Junk", "Zombie"))
end

function GhostParkourPlayerUnit:ShowUnitEffect(type)
  local duration = 0
  if type == SurfingUnitEffectType.Resurgence then
    duration = 0.7
  elseif type == SurfingUnitEffectType.Sliding then
    duration = 0.4
  elseif type == SurfingUnitEffectType.GotEnergy then
    duration = 0.15
  elseif type == SurfingUnitEffectType.GotProps then
    duration = 0.25
  end
  local path = UNIT_EFFECT_PATH[type]
  if path then
    self.logic:ShowEffectObj(path, ResetPosition, Quaternion.identity, duration, self:GetBuffTransform(1))
  end
end

function GhostParkourPlayerUnit:PlayRunSound()
  if self.runSound == nil then
    self.runSound = DataCenter.LWSoundManager:PlaySound(11043, true, true)
  end
end

function GhostParkourPlayerUnit:StopRunSound()
  if self.runSound ~= nil then
    DataCenter.LWSoundManager:StopSound(self.runSound)
    self.runSound = nil
  end
end

function GhostParkourPlayerUnit:GetBuffTransform(index)
  if self.morphBuffPoints == nil then
    return base.GetBuffTransform(self, index)
  end
  index = index or 1
  if not table.IsNullOrEmpty(self.morphBuffPoints) then
    local buffPoint = self.morphBuffPoints[index]
    if IsNull(buffPoint) then
      local defaultBuffPoint = self.morphBuffPoints[1]
      if not IsNull(defaultBuffPoint) then
        return defaultBuffPoint
      end
    else
      return buffPoint
    end
  end
  return self:GetTransform()
end

function GhostParkourPlayerUnit:ChangeToRunAnim()
  return self:TryCrossFadeSimpleAnim("run", 1, 0.2)
end

function GhostParkourPlayerUnit:TryCrossFadeSimpleAnim(name, speed, fadeTime, force)
  if force then
    self.fadeTime = 0
    self:ClearWaitFadeAnim()
    self:RewindAndPlaySimpleAnim(name, speed)
    return
  end
  if self.fadeTime > 0 then
    self:AddWaitFadeAnim(name, speed, fadeTime)
    return
  end
  self:ClearWaitFadeAnim()
  local deltaTime
  if self.isDebug and self.isEditor then
    deltaTime = Time.deltaTime
  else
    deltaTime = Time.unscaledDeltaTime
  end
  self.fadeTime = fadeTime + deltaTime
  self:CrossFadeSimpleAnim(name, speed, fadeTime)
end

function GhostParkourPlayerUnit:AddWaitFadeAnim(name, speed, fadeTime)
  if self.waitFadeAnim == nil then
    self.waitFadeAnim = {}
  end
  self.waitFadeAnim.name = name
  self.waitFadeAnim.speed = speed
  self.waitFadeAnim.fadeTime = fadeTime
  self.isWaitingAnimFade = true
end

function GhostParkourPlayerUnit:ClearWaitFadeAnim()
  if self.waitFadeAnim and self.waitFadeAnim.name then
    for i, _ in pairs(self.waitFadeAnim) do
      self.waitFadeAnim[i] = nil
    end
  end
  self.isWaitingAnimFade = false
end

function GhostParkourPlayerUnit:GetCurTransform()
  local viewHandle = self.viewHandle
  if viewHandle then
    return UnitViewFacade.GetTransform(viewHandle)
  end
end

function GhostParkourPlayerUnit:OnNitrogenSpeedUp()
  self.nitrogen = true
  if self.collision then
    return
  end
  if self.buffEffectLevel ~= GhostSpeedEffectType.SpeedUpSuper then
    if self.curBuffEffectId and self.curBuffEffectId > 0 then
      self.logic:RemoveEffectObj(self.curBuffEffectId)
    end
    self.curBuffEffectId = self:ShowSpeedEffect(GhostSpeedEffectType.SpeedUpSuper)
    self.buffEffectLevel = GhostSpeedEffectType.SpeedUpSuper
    DataCenter.LWSoundManager:PlaySound(11034, false)
    self:PlayBuffSound(GhostSpeedEffectType.SpeedUpSuper)
  end
  self:SetSpeedParam(self.nitrogenSpeed)
end

function GhostParkourPlayerUnit:SetSpeed()
  if self.collision then
    return
  end
  local speed = self.moveSpeed
  if self.nitrogen then
    speed = self.nitrogenSpeed
    if self.buffEffectLevel ~= GhostSpeedEffectType.SpeedUpSuper then
      if self.curBuffEffectId and self.curBuffEffectId > 0 then
        self.logic:RemoveEffectObj(self.curBuffEffectId)
      end
      self.curBuffEffectId = self:ShowSpeedEffect(GhostSpeedEffectType.SpeedUpSuper)
      self.buffEffectLevel = GhostSpeedEffectType.SpeedUpSuper
      self:PlayBuffSound(GhostSpeedEffectType.SpeedUpSuper)
    end
  elseif 0 >= self.speedUpBuffs then
    self.speedUpBuffs = 0
    if self.buffEffectLevel > 0 then
      self.buffEffectLevel = 0
      if self.curBuffEffectId and self.curBuffEffectId > 0 then
        self.logic:RemoveEffectObj(self.curBuffEffectId)
        self.curBuffEffectId = nil
      end
    end
    self:StopBuffSound()
  else
    local max = self.maxBuffCount
    if self.buffEffectLevel ~= self.speedUpBuffs then
      if self.curBuffEffectId and self.curBuffEffectId > 0 then
        self.logic:RemoveEffectObj(self.curBuffEffectId)
      end
      self.curBuffEffectId = self:ShowSpeedEffect(self.speedUpBuffs)
      self.buffEffectLevel = self.speedUpBuffs
      self:PlayBuffSound(self.speedUpBuffs)
    end
    if max >= self.speedUpBuffs then
      speed = self.buffSpeedStall[self.speedUpBuffs]
    end
  end
  self:SetSpeedParam(speed)
end

function GhostParkourPlayerUnit:SetSpeedParam(speed, duration)
  if 0 < speed then
    duration = duration or self.speedChangeTime
    self.handleSpeedHelper:SetMoveParam(speed, self.totalDeltaTime, duration)
  end
end

function GhostParkourPlayerUnit:GetSpeedStr()
  if self.handleSpeedHelper then
    return self.handleSpeedHelper:GetLogStr()
  end
end

function GhostParkourPlayerUnit:ShowSpeedEffect(type)
  local path = EFFECT_PATH[type]
  if path then
    return self.logic:ShowEffectObj(path, nil, nil, -1, self:GetBuffTransform(1))
  end
end

function GhostParkourPlayerUnit:PlayBuffSound(type)
  if self.buffLoopSoundId ~= nil then
    DataCenter.LWSoundManager:StopSound(self.buffLoopSoundId)
  end
  local soundId = BUFF_SOUND_LOOP_IDS[type]
  if soundId then
    self.buffLoopSoundId = DataCenter.LWSoundManager:PlaySound(soundId, true, true)
  end
end

function GhostParkourPlayerUnit:StopBuffSound()
  if self.buffLoopSoundId ~= nil then
    DataCenter.LWSoundManager:StopSound(self.buffLoopSoundId)
    self.buffLoopSoundId = nil
  end
end

function GhostParkourPlayerUnit:ChangeToFinish()
  self:ChangeState(Const.SurfingState.Win)
  local pos = self:GetPosition()
  local posZ = pos.z
  local offsetZ = self.logic:GetRankOffsetZ()
  if 0 < offsetZ then
    posZ = posZ + offsetZ
  end
  self.newX = pos.x
  self.newY = 0
  self.newZ = posZ + self.logic.renderOffsetZ
  local realZ, reset = self.logic:CheckOffsetZ(self.newZ)
  self:SetPositionXYZ(self.newX, self.newY, realZ)
  if reset then
    self.logic:ApplyResetOffsetZ()
  end
  self.fadeTime = nil
  self.fsm:ChangeState(State.Finish, self.parkourHeroId, true)
  self:OnPlayerFinished()
end

function GhostParkourPlayerUnit:OnPlayerFinished()
  if self.curBuffEffectId then
    self.logic:RemoveEffectObj(self.curBuffEffectId)
    self.curBuffEffectId = nil
  end
  if self.nitrogen then
    self.nitrogen = nil
    self.logic:OnNitrogenSpeedUpFinished()
  end
  self:StopRunSound()
  self:StopBuffSound()
end

function GhostParkourPlayerUnit:OnAnimFinished()
  if self.logic then
    self.logic:OnAnimFinished()
  end
end

function GhostParkourPlayerUnit:GetFollowCamera()
  if self.logic and self.logic.battleMgr then
    return self.logic.battleMgr.touchCameraTransform
  end
end

function GhostParkourPlayerUnit:InitObstacleCollider()
  BattleColliderUtils.AddObstacleCollider(self:GetFollowCamera(), self.viewHandle, self.guid, LayerMask.GetMask("Zombie"))
end

function GhostParkourPlayerUnit:ObstacleCalculateCollider()
  ProfilerUtil.BeginSample("SurfingPlayerUnit:ObstacleCalculateCollider")
  local resultList = PvePhysicsUtil.ObstacleCollider()
  local colliderResultList = resultList
  local colliderResultCount = 0
  if resultList then
    local length = #resultList
    if 0 < length then
      if resultList[1] == 0 then
        ProfilerUtil.EndSample()
        return
      end
      local idPos = false
      local count = 0
      local index = 0
      local dCount = 0
      table.clear(self.obstacleColliderMap)
      idPos = true
      for i = 1, length do
        local data = resultList[i]
        if data < 0 then
          index = 0
          count = 0
          idPos = true
        elseif idPos then
          idPos = false
          count = data
        elseif count == 0 then
        elseif data == 0 then
        else
          index = index + 1
          self.obstacleColliderMap[data] = count
          dCount = dCount + 1
        end
      end
      colliderResultCount = dCount
    end
  end
  if 0 < colliderResultCount then
    for objId, countIndex in pairs(self.obstacleColliderMap) do
      local monster = self.logic:GetMonster(objId)
      local count = colliderResultList[countIndex]
      if 0 < count then
        if monster then
          monster:OnMonsterCollided()
        else
          Logger.LogError("GhostParkourPlayerUnit.ObstacleCalculateCollider invalid monster : " .. tostring(objId))
        end
      end
    end
  end
  ProfilerUtil.EndSample()
end

return GhostParkourPlayerUnit
