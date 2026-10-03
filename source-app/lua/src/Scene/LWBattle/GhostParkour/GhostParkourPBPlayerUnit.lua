local base = require("Scene.LWBattle.Surfing.SurfingUnit")
local GhostParkourPBPlayerUnit = BaseClass("GhostParkourPBPlayerUnit", base)
local SurfingPlayerIdleState = require("Scene.LWBattle.Surfing.PlayerFSM.SurfingPlayerIdleState")
local SurfingPlayerRunState = require("Scene.LWBattle.Surfing.PlayerFSM.SurfingPlayerRunState")
local SurfingPlayerDieState = require("Scene.LWBattle.Surfing.PlayerFSM.SurfingPlayerDieState")
local SurfingPlayerEntranceState = require("Scene.LWBattle.GhostParkour.PlayerFSM.SurfingPlayerEntranceState")
local SurfingPlayerFinishState = require("Scene.LWBattle.GhostParkour.PlayerFSM.SurfingPlayerFinishState")
local FSM = require("Framework.Common.FSM")
local UnitViewFacade = CS.PVEBattleLogic.Unit.UnitViewFacade
local pveUnitViewUtil = require("Scene.LWBattle.BarrageBattle.Unit.PveUnitViewUtil")
local Const = require("Scene.LWBattle.Const")
local Queue = require("DataCenter.LWBattle.Logic.Surfing.Queue")
local HandleSpeedHelper = require("Scene.LWBattle.GhostParkour.HandleSpeedHelper")
local GhostParkourLogger = require("Scene.LWBattle.GhostParkour.GhostParkourLogger")
local GameObject = CS.UnityEngine.GameObject
local BattleColliderUtils = CS.BattleColliderUtils
local VIEW_INVALID_HANDLE = -1
local LineOffset = 4
local LineChangeTime = 0.16
local JumpForce = 16.5
local Gravity = -42
local SlideTime = 0.5
local TakeoffSpeed = 30
local FlyHeight = 20
local FlyTime = 10
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
local JUMP_ANIM_NAME = {"up", "up02"}
local EFFECT_PATH = {
  [SurfingUnitEffectType.Resurgence] = "Assets/Main/Prefabs/LWBattle/Surfing/Effect/Eff_s_s4_running_fuhuo.prefab",
  [SurfingUnitEffectType.Sliding] = "Assets/Main/Prefabs/LWBattle/Surfing/Effect/Eff_s_s4_running_huachan_smoke.prefab",
  [SurfingUnitEffectType.GotEnergy] = "Assets/Main/Prefabs/LWBattle/GhostParkour/Effect/Eff_s_s4_running_chinengliang.prefab",
  [SurfingUnitEffectType.GotProps] = "Assets/Main/Prefabs/LWBattle/Surfing/Effect/Eff_s_s4_running_chidaoju.prefab"
}
local SPEED_EFFECT_PATH = {
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

function GhostParkourPBPlayerUnit:Init(logic, info, heroId, speedChangeTime, index, first)
  base.Init(self, logic)
  if logic == nil then
    Logger.LogError("GhostParkour -- [Init] logic is nil")
    return true
  end
  if info == nil then
    if self.logic then
      self.logic:HideGhostPlayer(index)
      self.logic:CheckLoadFinish(2)
    end
    Logger.LogError("GhostParkour -- [Init] match player info is nil")
    return true
  end
  local go = GameObject("SurfingPBPlayer")
  self.gameObject = go
  self.transform = go.transform
  local isNpc = info.isNpc
  local lane, curLine, uid, uuid
  if isNpc then
    local meta = DataCenter.ParkourGhostNpcTemplateManager:GetTemplate(info.uid)
    if meta then
      lane = meta.road or 0
      uuid = meta.playback
    end
    uid = DataCenter.LWGhostParkourDataManager:GetNpcUid()
  else
    lane = info.lane
    uid = info.uid
    uuid = info.uuid
  end
  if uid == nil or uid == 0 or uid == "" then
    if self.logic then
      self.logic:HideGhostPlayer(index)
      self.logic:CheckLoadFinish(2)
    end
    Logger.LogError("GhostParkour -- [Init] uid error")
    return true
  end
  if uuid == nil or uuid == 0 then
    if self.logic then
      self.logic:HideGhostPlayer(index)
      self.logic:CheckLoadFinish(2)
    end
    Logger.LogError("GhostParkour -- [Init] uuid error")
    return true
  end
  curLine = logic:GetCurLine(lane)
  local localPos = logic:GetBirthPos(curLine)
  self.curLine = curLine or 0
  self.localPosition = localPos or Vector3.New(36, 0, 0)
  self.lastCameraFollowPos = Vector3.New(localPos.x, localPos.y, localPos.z)
  self.baseLineX = localPos.x + (0 - curLine) * LineOffset
  self.lineChangeTime = LineChangeTime
  self.index = index
  self.first = first
  if first then
    self.colliderMap = {}
    self.obstacleColliderMap = {}
  end
  local ghostParkourLogger = GhostParkourLogger.New(PVELogFuncType.GhostParkour)
  local result = ghostParkourLogger:DownloadLogFile(uid, uuid, function(recordInfo)
    if self.logic == nil then
      Logger.LogError("GhostParkour -- [Init] logic is nil")
      return
    end
    if recordInfo == nil then
      self.logic:HideGhostPlayer(index)
      self.logic:CheckLoadFinish()
      Logger.LogError("GhostParkour -- [Init] DownloadLogFile parsing failed, uuid = " .. uuid)
      return
    end
    self.logic:CheckLoadFinish()
    self.recordInfo = recordInfo
    local frameInfo = recordInfo.frameInfo
    self.frameInfo = frameInfo
    self.frameQueue = Queue.new()
    if frameInfo then
      for _, v in ipairs(frameInfo) do
        self.frameQueue:enqueue(v)
      end
    end
    local eventInfo = recordInfo.eventInfo
    self.eventInfo = eventInfo
    self.eventQueue = Queue.new()
    if eventInfo then
      for _, v in ipairs(eventInfo) do
        self.eventQueue:enqueue(v)
      end
    end
    local exitInfo = recordInfo.exitInfo
    self.exitInfo = exitInfo
    self.exitQueue = Queue.new()
    if exitInfo then
      for _, v in ipairs(exitInfo) do
        self.exitQueue:enqueue(v)
      end
    end
    self.curFrameInfo = self.frameQueue:dequeue()
    self.curEventInfo = self.eventQueue:dequeue()
    self.curExitInfo = self.exitQueue:dequeue()
  end, 2)
  if result then
    Logger.LogInfo("GhostParkour -- download log success")
  else
    if self.logic then
      self.logic:HideGhostPlayer(index)
      self.logic:CheckLoadFinish(2)
    end
    Logger.LogError("GhostParkour -- download log error, uuid = " .. uuid)
    return true
  end
  self.type = Const.ParkourUnitType.Hero
  self.unitType = UnitType.Member
  self.searchType = BattleSearchType.Member
  self.parkourHeroId = heroId
  if not self.first then
    local gHeroMeta = DataCenter.ParkourHeroTemplateManager:GetTemplate(heroId)
    if gHeroMeta then
      heroId = gHeroMeta.enemy_id
    end
  end
  self.heroId = heroId
  local hero = DataCenter.HeroTemplateManager:GetTemplate(heroId or 10028)
  self.hero = hero
  self.appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(hero.appearance)
  self.maxBlood = 1
  self.curBlood = self.maxBlood
  self.jumpVoValue = JumpForce
  self.gravityValue = Gravity
  self.verticalVelocity = 0
  self.verticalAcceleration = 0
  self.flyHeight = FlyHeight
  self.speedChangeTimeConst = speedChangeTime
  self.speedChangeTime = speedChangeTime
  self.motionState = MotionState.Idle
  self.fadeTime = 0
  self.isWaitingAnimFade = nil
  self.waitFadeAnim = nil
  self:SetLocalPosition(self.localPosition)
  self.viewLoaded = false
  self.viewHandle = VIEW_INVALID_HANDLE
  local scale = self.appearanceMeta.model_size
  self.viewScale = scale
  local path = self.appearanceMeta.model_path
  self.viewHandle, self.viewLoaded = pveUnitViewUtil.CreateUnitView(self.guid, path, self.transform, scale, 0, 0, 0, ResetPosition.x, ResetPosition.y, ResetPosition.z, LayerMask.NameToLayer("Default"))
  if self.viewLoaded then
    self:OnViewLoaded(true)
  end
  self.totalDeltaTime = 0
  self.boardBuffId = LuaEntry.DataConfig:TryGetNum("parkour_ghost_config_c", "k8") or 0
  self.nitrogenSpeed = logic:GetNitrogenBuffSpeed() or 0
  self.buffEffectLevel = 0
  self.curBuffEffectId = 0
  self.speedUpBuffs = 0
  self.nitrogen = false
  self.buffSpeedStall = logic:GetSpeedBoardParam()
  self.maxBuffCount = #self.buffSpeedStall
  self.moveSpeed = logic:GetMoveSpeed()
  self.handleSpeedHelper = HandleSpeedHelper.New(self, self.moveSpeed)
  self:SetSpeedParam(self.moveSpeed)
end

function GhostParkourPBPlayerUnit:ComponentDefine()
  self.buffPoints = {}
  local appearanceMeta = self.appearanceMeta
  if not table.IsNullOrEmpty(appearanceMeta.buff_path) then
    for i = 1, #appearanceMeta.buff_path do
      if string.IsNullOrEmpty(appearanceMeta.buff_path[i]) then
        self.buffPoints[i] = nil
      else
        local buffPoint = self.viewTransform:Find(appearanceMeta.buff_path[i])
        if IsNull(buffPoint) then
          Logger.LogError("buff\231\130\185\232\183\175\229\190\132\233\133\141\231\189\174\233\148\153\232\175\175\239\188\140\229\164\150\232\167\130id\239\188\154" .. self.hero.modelId .. "\239\188\140buff\231\130\185\232\183\175\229\190\132\239\188\154" .. appearanceMeta.buff_path[i])
        end
        self.buffPoints[i] = buffPoint
      end
    end
  end
end

function GhostParkourPBPlayerUnit:OnViewLoaded(force, objHandle)
  if self.viewLoaded and not force then
    return
  end
  self.viewLoaded = true
  self.viewTransform = UnitViewFacade.GetTransform(self.viewHandle)
  local skinWidth = 0.02
  self.groundDetectionHelper = CS.GhostGroundDetectionHelper()
  self.groundDetectionHelper:Init(self.viewTransform, skinWidth, self.flyHeight)
  self:ComponentDefineWithoutView()
  self:ComponentDefine()
  self:InitFSM()
  if self.first then
    self:InitPlayerCollider()
    self:InitObstacleCollider()
  end
  if self.logic then
    self.logic:CheckLoadFinish()
  end
  if self.curBlood <= 0 then
    self:Die()
    return
  end
end

function GhostParkourPBPlayerUnit:DestroyView()
  if self.first then
    BattleColliderUtils.ClearPlayerColliderData()
    BattleColliderUtils.ClearObstacleColliderData()
  end
  base.DestroyView(self)
  if self.fsm then
    self.fsm:Delete()
    self.fsm = nil
  end
  UnitViewFacade.DestroyUnitView(self.viewHandle)
  self.viewHandle = VIEW_INVALID_HANDLE
  self.viewTransform = nil
  self.viewLoaded = false
  if self.gameObject then
    GameObject.Destroy(self.gameObject)
    self.gameObject = nil
    self.transform = nil
  end
end

function GhostParkourPBPlayerUnit:DestroyData()
  base.DestroyData(self)
  self.fadeTime = nil
  self.isWaitingAnimFade = nil
  self.waitFadeAnim = nil
end

function GhostParkourPBPlayerUnit:InitFSM()
  self.fsm = FSM.New()
  self.fsm:AddState(State.Idle, SurfingPlayerIdleState.New(self))
  self.fsm:AddState(State.Running, SurfingPlayerRunState.New(self))
  self.fsm:AddState(State.Die, SurfingPlayerDieState.New(self))
  self.fsm:AddState(State.Entrance, SurfingPlayerEntranceState.New(self))
  self.fsm:AddState(State.Finish, SurfingPlayerFinishState.New(self))
  if self.cacheFsm then
    self:ChangeState(self.cacheFsm)
  elseif self.logic and self.logic.state then
    self:ChangeState(self.logic.state)
  else
    self:ChangeState(Const.SurfingState.Ready)
  end
  self.cacheFsm = nil
end

function GhostParkourPBPlayerUnit:ChangeState(newState)
  if self.fsm == nil then
    self.cacheFsm = newState
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
    if self.flySound ~= nil then
      DataCenter.LWSoundManager:StopSound(self.flySound)
      self.flySound = nil
    end
  end
end

function GhostParkourPBPlayerUnit:GetPosition()
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

function GhostParkourPBPlayerUnit:OnUpdate(deltaTime, totalDeltaTime)
  if self.first then
    base.OnUpdate(self, deltaTime)
  end
  if self.state ~= Const.SurfingState.Surfing then
    return
  end
  if self.logic == nil then
    return
  end
  if self.fsm then
    self.fsm:OnUpdate(deltaTime)
  end
  self.totalDeltaTime = totalDeltaTime
  if self.finished then
    return
  end
  local offsetTime, offsetZTime = 0, 0
  local x, y, z
  if self.frameQueue then
    while self.curFrameInfo ~= nil or not (0 >= self.frameQueue:size()) do
      if self.curFrameInfo == nil then
        self.curFrameInfo = self.frameQueue:dequeue()
      end
      if self.curFrameInfo then
        local timer = self.curFrameInfo.timer
        if timer and totalDeltaTime >= timer then
          local offset = totalDeltaTime - timer
          local input = self.curFrameInfo.input
          if input then
            if 0 < offset then
              offsetTime = timer - (totalDeltaTime - deltaTime)
              x, y = self:HandleMovementXYOffset(offsetTime, timer)
            end
            if input == INPUT_FLAGS.LEFT then
              self:OnMoveLeft(x, offsetTime)
            elseif input == INPUT_FLAGS.RIGHT then
              self:OnMoveRight(x, offsetTime)
            elseif input == INPUT_FLAGS.UP then
              self:OnMoveUp(y, offsetTime)
            elseif input == INPUT_FLAGS.DOWN then
              self:OnMoveDown(y, offsetTime)
            end
          end
          self.curFrameInfo = nil
        else
          break
        end
      end
    end
  end
  if self.eventQueue then
    while self.curEventInfo ~= nil or not (0 >= self.eventQueue:size()) do
      if self.curEventInfo == nil then
        self.curEventInfo = self.eventQueue:dequeue()
      end
      if self.curEventInfo then
        local timer = self.curEventInfo.eventTimer
        if timer and totalDeltaTime >= timer then
          local offset = totalDeltaTime - timer
          if 0 < offset then
            local lastTotalDeltaTime = totalDeltaTime - deltaTime
            offsetZTime = timer - lastTotalDeltaTime
            z = self:HandleMovementZOffset(offsetZTime, lastTotalDeltaTime)
          end
          self.speedChange = false
          if self.curEventInfo.eventFlag == EVENT_FLAGS.BUFF_SPEED_UP then
            self:OnBuffSpeedUp(offset)
          elseif self.curEventInfo.eventFlag == EVENT_FLAGS.BUFF_SPEED_DOWN then
            self:OnBuffSpeedDown(offset)
          elseif self.curEventInfo.eventFlag == EVENT_FLAGS.NITROGEN_SPEED_UP then
            self:OnNitrogenSpeedUp(offset)
          elseif self.curEventInfo.eventFlag == EVENT_FLAGS.NITROGEN_SPEED_DOWN then
            self:OnNitrogenSpeedDown(offset)
          elseif self.curEventInfo.eventFlag == EVENT_FLAGS.COLLISION then
            self:OnCollisionSpeedDown(0, offset, offsetZTime)
          elseif self.curEventInfo.eventFlag == EVENT_FLAGS.COLLISION_LEFT then
            x, y = self:HandleMovementXYOffset(offsetZTime, timer)
            self:OnCollisionSpeedDown(1, offset, offsetZTime, x)
          elseif self.curEventInfo.eventFlag == EVENT_FLAGS.COLLISION_RIGHT then
            x, y = self:HandleMovementXYOffset(offsetZTime, timer)
            self:OnCollisionSpeedDown(2, offset, offsetZTime, x)
          elseif self.curEventInfo.eventFlag == EVENT_FLAGS.COLLISION_FINISH then
            self.collision = false
            self:SetSpeed(offset)
          end
          self.curEventInfo = nil
          if not self.speedChange then
            z = nil
          end
        else
          break
        end
      end
    end
  end
  self:HandleBasicMovement(deltaTime - offsetTime, totalDeltaTime, x, y, z)
  if self.eventQueue then
    if self.curExitInfo == nil and 0 < self.exitQueue:size() then
      self.curExitInfo = self.exitQueue:dequeue()
    end
    if self.curExitInfo and self.curExitInfo.deadTimer <= self.totalDeltaTime then
      if self.curExitInfo.exitFlag == EXIT_FLAGS.WIN then
        self.finished = true
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
        self.fsm:ChangeState(State.Finish, self.parkourHeroId, self.first)
        self:OnPlayerFinished()
        if self.first then
          self:ResetColliderHeight()
          if self.logic then
            if self.logic.OnGameFinished then
              self.logic:OnGameFinished()
            end
            self.logic:ChangeState(Const.SurfingState.Win)
          end
        end
        return
      end
      self.curExitInfo = nil
    end
  end
  if self.first then
    self:PlayerCalculateCollider()
    self:ObstacleCalculateCollider()
  end
  if 0 < self.fadeTime then
    self.fadeTime = self.fadeTime - deltaTime
    if 0 >= self.fadeTime and self.isWaitingAnimFade and self.waitFadeAnim then
      self:TryCrossFadeSimpleAnim(self.waitFadeAnim.name, self.waitFadeAnim.speed, self.waitFadeAnim.fadeTime)
    end
  end
end

function GhostParkourPBPlayerUnit:SetMoveBase(baseTime, baseDistance, startSpeed, endSpeed, speedChangeTime)
  self.speedChange = true
  self.baseTime = baseTime
  self.baseDistance = baseDistance
  self.startSpeed = startSpeed
  self.endSpeed = endSpeed
  speedChangeTime = speedChangeTime or self.speedChangeTimeConst
  self.changeDistance = (startSpeed + endSpeed) * 0.5 * speedChangeTime
  self.speedChangeTime = speedChangeTime
end

function GhostParkourPBPlayerUnit:OnCollisionSpeedDown(type, offset, offsetZTime, x)
  if type == 0 then
    self:ShowUnitEffect(SurfingUnitEffectType.Resurgence)
    if self.first then
      DataCenter.LWSoundManager:PlaySound(11029, false)
    end
  elseif self.first then
    DataCenter.LWSoundManager:PlaySound(11030, false)
  end
  if self.buffEffectLevel ~= GhostSpeedEffectType.Dizziness then
    if self.curBuffEffectId and 0 < self.curBuffEffectId then
      self.logic:RemoveEffectObj(self.curBuffEffectId)
    end
    self.curBuffEffectId = self:ShowSpeedEffect(GhostSpeedEffectType.Dizziness)
    self.buffEffectLevel = GhostSpeedEffectType.Dizziness
  end
  self.collision = true
  if self.speedCutTarget == nil then
    local value = LuaEntry.DataConfig:TryGetStr("parkour_ghost_config", "k14", "")
    local arr = string.split(value, "|")
    if arr and 1 < #arr then
      self.speedCutTarget = tonumber(arr[3])
      self.speedCutTime = tonumber(arr[1])
    end
  end
  if self.speedCutTarget == nil or self.speedCutTime == nil then
    Logger.LogError("cannot find parkour_ghost_config:k14")
    return
  end
  self:SetSpeedParam(self.speedCutTarget, self.speedCutTime, offset)
end

function GhostParkourPBPlayerUnit:ChangeBehaviorState(state, param)
  if state == BehaviorState.ChangeLanesFinish then
    self.lineChangeTimer = nil
    if not self:IsFlying() then
      self:ChangeToRunAnim()
    end
  elseif state == BehaviorState.SlidingFinish then
    self:ChangeToRunAnim()
    self.motionState = MotionState.Running
    self:ResetColliderHeight()
  elseif state == BehaviorState.TouchGround then
    if self.motionState == MotionState.AirSliding then
      self.motionState = MotionState.GroundSliding
      self:ResetColliderHeight()
    else
      self:ChangeToRunAnim()
      if self.first and self.motionState ~= MotionState.Running then
        DataCenter.LWSoundManager:PlaySound(11015, false)
      end
      self.motionState = MotionState.Running
    end
  elseif state == BehaviorState.FreeFallStart then
    self.verticalVelocity = 0
    self.verticalAcceleration = self.gravityValue
    self.verticalMoveTimer = 0
    self.verticalMoveStartY = param or 0
    self:TryCrossFadeSimpleAnim("fall", 1, 0.2)
    if self.first and self.flySound ~= nil then
      DataCenter.LWSoundManager:StopSound(self.flySound)
    end
    if self:IsSliding() then
      self:ResetColliderHeight()
    end
    if self.motionState == state or self.lineChangeTimer and self.motionState ~= MotionState.ChangeLanesFinish then
    else
      DataCenter.LWSoundManager:PlaySound(11017, false)
    end
    self.motionState = MotionState.FreeFalling
  elseif state == BehaviorState.FlyStart then
    self.flyY = self:GetPosition().y
    self.flySpeed = TakeoffSpeed
    self.flyTimer = FlyTime
    self:TryCrossFadeSimpleAnim("fly", 1, 0.2)
    if self.first then
      if self.flySound ~= nil then
        DataCenter.LWSoundManager:StopSound(self.flySound)
      end
      self.flySound = DataCenter.LWSoundManager:PlaySound(11012, true)
    end
    if self:IsSliding() then
      self:ResetColliderHeight()
    end
    self.motionState = MotionState.Flying
  end
end

function GhostParkourPBPlayerUnit:OnBuffSpeedUp(offset)
  self.speedUpBuffs = self.speedUpBuffs + 1
  local max = self.maxBuffCount
  self.speedUpBuffs = Mathf.Min(self.speedUpBuffs, max)
  if self.first then
    local buff = self:AddBuff(self.boardBuffId)
    EventManager:GetInstance():Broadcast(EventId.SurfingOnBuffAdd, {
      buff = buff,
      level = self.speedUpBuffs
    })
  end
  if self.nitrogen then
    return
  end
  if self.collision then
    return
  end
  local result = self:SetSpeed(offset)
  if self.first then
    DataCenter.LWSoundManager:PlaySound(BUFF_SOUND_IDS[self.buffEffectLevel], false)
  end
  return result
end

function GhostParkourPBPlayerUnit:OnBuffSpeedDown(offset)
  if self.logic == nil then
    return
  end
  self.speedUpBuffs = 0
  if self.nitrogen then
    return
  end
  self:SetSpeed(offset)
end

function GhostParkourPBPlayerUnit:OnBuffRemoved(buff)
  if self.logic == nil then
    return
  end
  if self.state and self.state == Const.SurfingState.Surfing and buff then
    local bType = buff and buff.meta and buff.meta.type
    if bType == BuffType.GhostSpeedUp or bType == BuffType.GhostNitrogen then
      EventManager:GetInstance():Broadcast(EventId.SurfingOnBuffRemove, buff)
    end
  end
end

function GhostParkourPBPlayerUnit:SetMoveSpeed(speed)
  self.speed = speed
end

function GhostParkourPBPlayerUnit:GetMoveSpeed()
  return self.speed or self.logic:GetMoveSpeed()
end

function GhostParkourPBPlayerUnit:OnMoveLeft(x)
  if self.curLine > -1 then
    self.curLine = self.curLine - 1
    self.curX = x or self:GetPosition().x
    self.targetX = self.baseLineX + self.curLine * LineOffset
    self.lineChangeTimer = LineChangeTime
    if not self:IsFlying() then
      self:TryCrossFadeSimpleAnim("left_jump", 1, 0.2)
      if self.first then
        DataCenter.LWSoundManager:PlaySound(11010, false)
      end
    end
  end
end

function GhostParkourPBPlayerUnit:OnMoveRight(x)
  if self.curLine < 1 then
    self.curLine = self.curLine + 1
    self.curX = x or self:GetPosition().x
    self.targetX = self.baseLineX + self.curLine * LineOffset
    self.lineChangeTimer = LineChangeTime
    if not self:IsFlying() then
      self:TryCrossFadeSimpleAnim("right_jump", 1, 0.2)
      if self.first then
        DataCenter.LWSoundManager:PlaySound(11010, false)
      end
    end
  end
end

function GhostParkourPBPlayerUnit:OnMoveUp(y, offsetTime)
  if self:IsGrounded() then
    local index = math.random(1, 2)
    local anim = JUMP_ANIM_NAME[index] or JUMP_ANIM_NAME[1]
    self:TryCrossFadeSimpleAnim(anim, 1, 0.2)
    if self.first then
      DataCenter.LWSoundManager:PlaySound(11019, false)
    end
    self.verticalVelocity = self.jumpVoValue
    self.verticalAcceleration = self.gravityValue
    self.verticalMoveTimer = 0
    self.verticalMoveStartY = y or self:GetPosition().y
    if self.motionState == MotionState.GroundSliding then
      self.slideTimer = 0
    end
    if self:IsSliding() then
      self:ResetColliderHeight()
    end
    self.motionState = MotionState.Jumping
  end
end

function GhostParkourPBPlayerUnit:OnMoveDown(y, offsetTime)
  if self:IsSliding() then
    return
  end
  if self:IsFlying() then
    return
  end
  if not self:IsGrounded() then
    local curV = self.verticalVelocity + self.verticalAcceleration * self.verticalMoveTimer
    self.verticalVelocity = curV
    self.verticalMoveTimer = 0
    local curY = y or self:GetPosition().y
    local fastDownTime = SlideTime * 0.2
    local newA = 2 * (-curY - curV * fastDownTime) / (fastDownTime * fastDownTime)
    if 0 < newA then
      newA = -newA
      local newV = (-curY - 0.5 * newA * fastDownTime * fastDownTime) / fastDownTime
      self.verticalVelocity = newV
    end
    self.verticalAcceleration = newA
    self.verticalMoveStartY = curY
    self.motionState = MotionState.AirSliding
  else
    self.motionState = MotionState.GroundSliding
  end
  self.slideTimer = SlideTime
  self:TryCrossFadeSimpleAnim("down", 1, 0.1)
  if self.first then
    DataCenter.LWSoundManager:PlaySound(11011, false)
  end
  self:ShowUnitEffect(SurfingUnitEffectType.Sliding)
  if self.first then
    BattleColliderUtils.ChangePlayerCollider(self.guid, 0.6)
  end
end

function GhostParkourPBPlayerUnit:OnNitrogenSpeedUp(offset)
  self.nitrogen = true
  if self.first and self.logic then
    self.logic:OnNitrogenSpeedUp()
  end
  if self.collision then
    return
  end
  if self.buffEffectLevel ~= GhostSpeedEffectType.SpeedUpSuper then
    if self.curBuffEffectId and self.curBuffEffectId > 0 then
      self.logic:RemoveEffectObj(self.curBuffEffectId)
    end
    self.curBuffEffectId = self:ShowSpeedEffect(GhostSpeedEffectType.SpeedUpSuper)
    self.buffEffectLevel = GhostSpeedEffectType.SpeedUpSuper
    if self.first then
      DataCenter.LWSoundManager:PlaySound(11034, false)
      self:PlayBuffSound(GhostSpeedEffectType.SpeedUpSuper)
    end
  end
  self:SetSpeedParam(self.nitrogenSpeed, nil, offset)
end

function GhostParkourPBPlayerUnit:OnNitrogenSpeedDown(offset)
  self.nitrogen = false
  if self.first then
    self.logic:OnNitrogenSpeedUpFinished()
  end
  self:SetSpeed(offset)
end

function GhostParkourPBPlayerUnit:HandleBasicMovement(deltaTime, totalDeltaTime, x, y, z)
  local position = self:GetPosition()
  local newX = x or position.x
  local newY = y or position.y
  local newZ = z or position.z
  if self.baseTime == nil then
    Logger.LogError("the baseTime is nil")
    return
  end
  local diffTime = totalDeltaTime - self.baseTime
  local diffZ = 0
  local curSpeed = 0
  if diffTime <= self.speedChangeTime then
    diffZ = (self.startSpeed + self.endSpeed) * 0.5 * diffTime
    curSpeed = self.startSpeed + (self.endSpeed - self.startSpeed) * (diffTime / self.speedChangeTime)
  else
    diffZ = self.changeDistance + (diffTime - self.speedChangeTime) * self.endSpeed
    curSpeed = self.endSpeed
  end
  self:SetMoveSpeed(curSpeed)
  if z then
    newZ = z + diffZ
  else
    newZ = diffZ + self.baseDistance
  end
  local isGrounded, contactPointY = self.groundDetectionHelper:DetectGround(newX, newY, newZ + self.logic.renderOffsetZ)
  if isGrounded then
    newY = contactPointY
  end
  if self:IsFlying() then
    local deltaY = self.flySpeed * deltaTime
    local tmpNewY = self.flyY + deltaY
    if tmpNewY > self.flyHeight then
      tmpNewY = self.flyHeight
    end
    self.flyY = tmpNewY
    newY = tmpNewY
  elseif not self:IsGrounded() then
    local vert
    self.verticalMoveTimer = self.verticalMoveTimer + deltaTime
    local t = self.verticalMoveTimer
    local vo = self.verticalVelocity
    local a = self.verticalAcceleration
    vert = vo * t + 0.5 * a * t * t
    local tmpNewY = self.verticalMoveStartY + vert
    local grounded, tContactPointY = self.groundDetectionHelper:DetectGround(newX, tmpNewY, newZ + self.logic.renderOffsetZ)
    if grounded then
      contactPointY = tContactPointY
    end
    if tmpNewY <= contactPointY then
      self:ChangeBehaviorState(BehaviorState.TouchGround)
      tmpNewY = contactPointY
    end
    newY = tmpNewY
  elseif self:IsGrounded() and not isGrounded and not self.lineChangeTimer then
    self:ChangeBehaviorState(BehaviorState.FreeFallStart, newY)
  end
  if self:IsSliding() then
    self.slideTimer = self.slideTimer - deltaTime
    if 0 >= self.slideTimer then
      self:ChangeBehaviorState(BehaviorState.SlidingFinish)
    end
  end
  if self.lineChangeTimer then
    self.lineChangeTimer = self.lineChangeTimer - deltaTime
    local curX = Mathf.Lerp(self.targetX, self.curX, self.lineChangeTimer / self.lineChangeTime)
    newX = curX
    if 0 >= self.lineChangeTimer then
      self:ChangeBehaviorState(BehaviorState.ChangeLanesFinish)
    end
  end
  self.newX = newX
  self.newY = newY
  self.newZ = newZ + self.logic.renderOffsetZ
  local realZ, reset = self.logic:CheckOffsetZ(self.newZ)
  self:SetPositionXYZ(self.newX, self.newY, realZ)
  if reset then
    self.logic:ApplyResetOffsetZ()
  end
end

function GhostParkourPBPlayerUnit:SetSpeed(offset)
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
      if self.first then
        self:PlayBuffSound(GhostSpeedEffectType.SpeedUpSuper)
      end
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
    self.speedUpBuffs = Mathf.Min(self.speedUpBuffs, max)
    if self.buffEffectLevel ~= self.speedUpBuffs then
      if self.curBuffEffectId and self.curBuffEffectId > 0 then
        self.logic:RemoveEffectObj(self.curBuffEffectId)
      end
      self.curBuffEffectId = self:ShowSpeedEffect(self.speedUpBuffs)
      self.buffEffectLevel = self.speedUpBuffs
      if self.first then
        self:PlayBuffSound(self.speedUpBuffs)
      end
    end
    if max >= self.speedUpBuffs then
      speed = self.buffSpeedStall[self.speedUpBuffs]
    end
  end
  offset = offset or 0
  return self:SetSpeedParam(speed, nil, offset)
end

function GhostParkourPBPlayerUnit:SetSpeedParam(speed, duration, offset)
  if 0 < speed then
    duration = duration or self.speedChangeTimeConst
    offset = offset or 0
    self.handleSpeedHelper:SetMoveParam(speed, self.totalDeltaTime - offset, duration)
  end
end

function GhostParkourPBPlayerUnit:HandleMovementXYOffset(deltaTime, totalDeltaTime)
  local position = self:GetPosition()
  local newX = position.x
  local newY = position.y
  if self.baseTime == nil then
    Logger.LogError("the baseTime is nil")
    return
  end
  if self:IsFlying() then
    local deltaY = self.flySpeed * deltaTime
    local tmpNewY = self.flyY + deltaY
    if tmpNewY > self.flyHeight then
      tmpNewY = self.flyHeight
    end
    self.flyY = tmpNewY
    newY = tmpNewY
  elseif not self:IsGrounded() then
    local vert
    local verticalMoveTimer = self.verticalMoveTimer + deltaTime
    local t = verticalMoveTimer
    local vo = self.verticalVelocity
    local a = self.verticalAcceleration
    vert = vo * t + 0.5 * a * t * t
    local tmpNewY = self.verticalMoveStartY + vert
    newY = tmpNewY
  end
  if self:IsSliding() then
    self.slideTimer = self.slideTimer - deltaTime
    if self.slideTimer <= 0 then
      self:ChangeBehaviorState(BehaviorState.SlidingFinish)
    end
  end
  if self.lineChangeTimer then
    self.lineChangeTimer = self.lineChangeTimer - deltaTime
    local curX = Mathf.Lerp(self.targetX, self.curX, self.lineChangeTimer / self.lineChangeTime)
    newX = curX
    if 0 >= self.lineChangeTimer then
      self:ChangeBehaviorState(BehaviorState.ChangeLanesFinish)
    end
  end
  return newX, newY
end

function GhostParkourPBPlayerUnit:HandleMovementZOffset(offset, totalDeltaTime)
  local position = self:GetPosition()
  local newZ = position.z
  if self.baseTime == nil then
    Logger.LogError("the baseTime is nil")
    return
  end
  local diffTime = totalDeltaTime + offset - self.baseTime
  local diffZ = 0
  if diffTime <= self.speedChangeTime then
    diffZ = (self.startSpeed + self.endSpeed) * 0.5 * diffTime
  else
    diffZ = self.changeDistance + (diffTime - self.speedChangeTime) * self.endSpeed
  end
  newZ = diffZ + self.baseDistance
  return newZ
end

function GhostParkourPBPlayerUnit:IsGrounded()
  return self.motionState == MotionState.Idle or self.motionState == MotionState.Running or self.motionState == MotionState.GroundSliding
end

function GhostParkourPBPlayerUnit:IsSliding()
  return self.motionState == MotionState.AirSliding or self.motionState == MotionState.GroundSliding
end

function GhostParkourPBPlayerUnit:IsFlying()
  return self.motionState == MotionState.Flying
end

function GhostParkourPBPlayerUnit:IsJumping()
  return self.motionState == MotionState.Jumping
end

function GhostParkourPBPlayerUnit:ShowUnitEffect(type)
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
  local path = EFFECT_PATH[type]
  if path then
    self.logic:ShowEffectObj(path, ResetPosition, Quaternion.identity, duration, self:GetBuffTransform(1))
  end
end

function GhostParkourPBPlayerUnit:GetBuffTransform(index)
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

function GhostParkourPBPlayerUnit:GetCameraFollowXYZ()
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

function GhostParkourPBPlayerUnit:ChangeToRunAnim()
  return self:TryCrossFadeSimpleAnim("run", 1, 0.2)
end

function GhostParkourPBPlayerUnit:TryCrossFadeSimpleAnim(name, speed, fadeTime, force)
  if force then
    self.fadeTime = 0
    self:ClearWaitFadeAnim()
    self:CrossFadeSimpleAnim(name, speed, fadeTime)
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

function GhostParkourPBPlayerUnit:AddWaitFadeAnim(name, speed, fadeTime)
  if self.waitFadeAnim == nil then
    self.waitFadeAnim = {}
  end
  self.waitFadeAnim.name = name
  self.waitFadeAnim.speed = speed
  self.waitFadeAnim.fadeTime = fadeTime
  self.isWaitingAnimFade = true
end

function GhostParkourPBPlayerUnit:ClearWaitFadeAnim()
  if self.waitFadeAnim and self.waitFadeAnim.name then
    for i, _ in pairs(self.waitFadeAnim) do
      self.waitFadeAnim[i] = nil
    end
  end
  self.isWaitingAnimFade = false
end

function GhostParkourPBPlayerUnit:ShowSpeedEffect(type)
  local path = SPEED_EFFECT_PATH[type]
  if path then
    return self.logic:ShowEffectObj(path, nil, nil, -1, self:GetBuffTransform(1))
  end
end

function GhostParkourPBPlayerUnit:InitPlayerCollider()
  BattleColliderUtils.AddPlayerCollider(self.viewHandle, self.guid, LayerMask.GetMask("Junk", "Zombie"))
end

function GhostParkourPBPlayerUnit:GetFollowCamera()
  if self.logic and self.logic.battleMgr then
    return self.logic.battleMgr.touchCameraTransform
  end
end

function GhostParkourPBPlayerUnit:InitObstacleCollider()
  BattleColliderUtils.AddObstacleCollider(self:GetFollowCamera(), self.viewHandle, self.guid, LayerMask.GetMask("Zombie"))
end

function GhostParkourPBPlayerUnit:PlayerCalculateCollider()
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

function GhostParkourPBPlayerUnit:ObstacleCalculateCollider()
  ProfilerUtil.BeginSample("GhostParkourPBPlayerUnit:ObstacleCalculateCollider")
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

function GhostParkourPBPlayerUnit:OnMonsterCollision(monster)
  if monster then
    monster:OnCollisionViewHandle(self)
  end
end

function GhostParkourPBPlayerUnit:BeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, attacker)
  if self.invincible or not self.first then
    return
  end
  local pos = self:GetPosition()
  if attacker == nil then
    Logger.LogError("GhostParkour -- [BeAttack] attacker is nil")
    return
  end
  local dot = PvePhysicsUtil.TryGetGhostPlayerCollideDir(attacker.guid)
  if dot < -0.5 then
    attacker:SetColliderTag()
    attacker:OnMonsterCollided()
  end
end

function GhostParkourPBPlayerUnit:AfterBeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, skill, deathEff)
end

function GhostParkourPBPlayerUnit:PlayRunSound()
  if self.runSound == nil then
    self.runSound = DataCenter.LWSoundManager:PlaySound(11043, true, true)
  end
end

function GhostParkourPBPlayerUnit:StopRunSound()
  if self.runSound ~= nil then
    DataCenter.LWSoundManager:StopSound(self.runSound)
    self.runSound = nil
  end
end

function GhostParkourPBPlayerUnit:ChangeToFinish()
  if self.finished then
    return
  end
  self:ResetColliderHeight()
  self.fsm:ChangeState(State.Idle)
  self:OnPlayerFinished()
end

function GhostParkourPBPlayerUnit:OnPlayerFinished()
  if self.curBuffEffectId then
    self.logic:RemoveEffectObj(self.curBuffEffectId)
    self.curBuffEffectId = nil
  end
  if self.first and self.nitrogen then
    self.nitrogen = nil
    self.logic:OnNitrogenSpeedUpFinished()
  end
  self:StopRunSound()
  self:StopBuffSound()
end

function GhostParkourPBPlayerUnit:OnAnimFinished()
end

function GhostParkourPBPlayerUnit:ResetColliderHeight()
  if self.first then
    BattleColliderUtils.ChangePlayerCollider(self.guid, 1)
  end
end

function GhostParkourPBPlayerUnit:PlayBuffSound(type)
  if self.buffLoopSoundId ~= nil then
    DataCenter.LWSoundManager:StopSound(self.buffLoopSoundId)
  end
  local soundId = BUFF_SOUND_LOOP_IDS[type]
  if soundId then
    self.buffLoopSoundId = DataCenter.LWSoundManager:PlaySound(soundId, true, true)
  end
end

function GhostParkourPBPlayerUnit:StopBuffSound()
  if self.buffLoopSoundId ~= nil then
    DataCenter.LWSoundManager:StopSound(self.buffLoopSoundId)
    self.buffLoopSoundId = nil
  end
end

function GhostParkourPBPlayerUnit:HideGhostPlayer()
  if self.viewHandle then
    UnitViewFacade.SetVisible(self.viewHandle, false)
  end
end

return GhostParkourPBPlayerUnit
