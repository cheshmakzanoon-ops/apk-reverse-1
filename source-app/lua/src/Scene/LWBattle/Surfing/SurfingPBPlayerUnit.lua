local base = require("Scene.LWBattle.Surfing.SurfingUnit")
local SurfingPBPlayerUnit = BaseClass("SurfingPBPlayerUnit", base)
local SurfingPlayerIdleState = require("Scene.LWBattle.Surfing.PlayerFSM.SurfingPlayerIdleState")
local SurfingPlayerRunState = require("Scene.LWBattle.Surfing.PlayerFSM.SurfingPlayerRunState")
local SurfingPlayerDieState = require("Scene.LWBattle.Surfing.PlayerFSM.SurfingPlayerDieState")
local FSM = require("Framework.Common.FSM")
local UnitViewFacade = CS.PVEBattleLogic.Unit.UnitViewFacade
local pveUnitViewUtil = require("Scene.LWBattle.BarrageBattle.Unit.PveUnitViewUtil")
local Const = require("Scene.LWBattle.Const")
local Queue = require("DataCenter.LWBattle.Logic.Surfing.Queue")
local GameObject = CS.UnityEngine.GameObject
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
  Die = 3
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
  [SurfingUnitEffectType.GotScore] = "Assets/Main/Prefabs/LWBattle/Surfing/Effect/Eff_s_s4_running_chijinbi.prefab",
  [SurfingUnitEffectType.GotProps] = "Assets/Main/Prefabs/LWBattle/Surfing/Effect/Eff_s_s4_running_chidaoju.prefab",
  [SurfingUnitEffectType.ShieldBroken] = "Assets/Main/Prefabs/LWBattle/Surfing/Effect/Eff_s_s4_running_hudunposui.prefab",
  [SurfingUnitEffectType.Resurgence] = "Assets/Main/Prefabs/LWBattle/Surfing/Effect/Eff_s_s4_running_fuhuo.prefab",
  [SurfingUnitEffectType.Morph] = "Assets/Main/Prefabs/LWBattle/Surfing/Effect/Eff_s_s4_running_bianshen.prefab",
  [SurfingUnitEffectType.Sliding] = "Assets/Main/Prefabs/LWBattle/Surfing/Effect/Eff_s_s4_running_huachan_smoke.prefab"
}

function SurfingPBPlayerUnit:Init(logic, frameInfo, eventInfo)
  base.Init(self, logic)
  local go = GameObject("SurfingPBPlayer")
  self.gameObject = go
  self.transform = go.transform
  self:InstantiateTriggerRoot()
  local localPos = Vector3.New(36, 0, 0)
  self.curLine = 0
  self.baseLineX = localPos.x
  self.lineChangeTime = LineChangeTime
  self.localPosition = localPos
  self.lastCameraFollowPos = Vector3.New(localPos.x, localPos.y, localPos.z)
  self.type = Const.ParkourUnitType.Hero
  self.unitType = UnitType.Member
  self.searchType = BattleSearchType.Member
  self.frameInfo = frameInfo
  self.frameQueue = Queue.new()
  if frameInfo then
    for _, v in ipairs(frameInfo) do
      self.frameQueue:enqueue(v)
    end
  end
  self.eventInfo = eventInfo
  local hero = DataCenter.HeroTemplateManager:GetTemplate(10028)
  self.hero = hero
  self.appearanceMeta = hero and DataCenter.AppearanceTemplateManager:GetTemplate(hero.appearance)
  self.maxBlood = 1
  self.curBlood = self.maxBlood
  self.jumpVoValue = JumpForce
  self.gravityValue = Gravity
  self.verticalVelocity = 0
  self.verticalAcceleration = 0
  self.flyHeight = FlyHeight
  self.speedChangeTime = logic.speedChangeTime
  self.moveSpeed = self:GetMoveSpeed()
  self.motionState = MotionState.Running
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
  self.morphing = false
  self.BehaviorState = BehaviorState
  self.colliderMap = {}
  self.isPreventDeath = false
  self.scoreMultiplier = 1
  self.curFrameInfo = self.frameQueue:dequeue()
end

function SurfingPBPlayerUnit:ComponentDefine()
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

function SurfingPBPlayerUnit:DestroyView()
  base.DestroyView(self)
  UnitViewFacade.DestroyUnitView(self.viewHandle)
  UnitViewFacade.MPBReset(self.viewHandle)
  self.viewHandle = VIEW_INVALID_HANDLE
  self.viewTransform = nil
  self.viewLoaded = false
  self:ClearAppearanceReplace()
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

function SurfingPBPlayerUnit:DestroyData()
  base.DestroyData(self)
  if self.flySound ~= nil then
    DataCenter.LWSoundManager:StopSound(self.flySound)
    self.flySound = nil
  end
  self.fadeTime = nil
  self.isWaitingAnimFade = nil
  self.waitFadeAnim = nil
end

function SurfingPBPlayerUnit:OnViewLoaded(force)
  if self.waitReplacingHandle then
    self:OnReplaceViewLoaded(false)
    return
  end
  if self.viewLoaded and not force then
    return
  end
  self.viewLoaded = true
  self.viewTransform = UnitViewFacade.GetTransform(self.viewHandle)
  local skinWidth = 0.02
  self.groundDetectionHelper = CS.GroundDetectionHelper()
  self.groundDetectionHelper:Init(self.viewTransform, skinWidth, self.flyHeight)
  self:ComponentDefineWithoutView()
  self:ComponentDefine()
  self:InitFSM()
  if self.logic then
    self.logic:CheckLoadFinish()
  end
  if self.curBlood <= 0 then
    self:Die()
    return
  end
end

function SurfingPBPlayerUnit:InitFSM()
  self.fsm = FSM.New()
  self.fsm:AddState(State.Idle, SurfingPlayerIdleState.New(self))
  self.fsm:AddState(State.Running, SurfingPlayerRunState.New(self))
  self.fsm:AddState(State.Die, SurfingPlayerDieState.New(self))
  if self.cacheState then
    self:ChangeState(self.cacheState)
  elseif self.logic and self.logic.state then
    self:ChangeState(self.logic.state)
  else
    self:ChangeState(Const.SurfingState.Ready)
  end
  self.cacheState = nil
end

function SurfingPBPlayerUnit:UpdateRecordData(frameInfo, eventInfo)
  if frameInfo == nil then
    return
  end
  self.frameInfo = frameInfo
  if self.frameQueue == nil then
    self.frameQueue = Queue.new()
  end
  for _, v in ipairs(frameInfo) do
    self.frameQueue:enqueue(v)
  end
end

function SurfingPBPlayerUnit:ChangeState(newState)
  if self.fsm == nil then
    self.cacheState = newState
    return
  end
  self.state = newState
  if newState == Const.SurfingState.Surfing then
    self.fsm:ChangeState(State.Running)
  elseif newState == Const.SurfingState.Ready then
    self.fsm:ChangeState(State.Idle)
  end
end

function SurfingPBPlayerUnit:OnUpdate(deltaTime, totalDeltaTime)
  base.OnUpdate(self, deltaTime)
  if self.fsm then
    self.fsm:OnUpdate(deltaTime)
  end
  local offset = 0
  if self.frameQueue then
    if self.curFrameInfo == nil then
      self.curFrameInfo = self.frameQueue:dequeue()
    end
    if self.curFrameInfo then
      local timer = self.curFrameInfo.timer
      if timer and totalDeltaTime >= timer then
        local input = self.curFrameInfo.input
        if input then
          if input == INPUT_FLAGS.LEFT then
            self:OnMoveLeft()
          elseif input == INPUT_FLAGS.RIGHT then
            self:OnMoveRight()
          elseif input == INPUT_FLAGS.UP then
            self:OnMoveUp()
          elseif input == INPUT_FLAGS.DOWN then
            self:OnMoveDown()
          end
        end
        self.curFrameInfo = nil
      end
    end
  end
  self:HandleBasicMovement(deltaTime, totalDeltaTime)
  if 0 < self.fadeTime then
    self.fadeTime = self.fadeTime - deltaTime
    if 0 >= self.fadeTime and self.isWaitingAnimFade and self.waitFadeAnim then
      self:TryCrossFadeSimpleAnim(self.waitFadeAnim.name, self.waitFadeAnim.speed, self.waitFadeAnim.fadeTime)
    end
  end
end

function SurfingPBPlayerUnit:CalculateCollider(deltaTime)
  if not self.autoCollect then
    return
  end
  ProfilerUtil.BeginSample("SurfingPlayerUnit:CalculateCollider")
  local resultList = PvePhysicsUtil.UnitCollider()
  local colliderResultList = resultList
  local colliderResultCount = 0
  if resultList then
    local length = #resultList
    local idPos = false
    local countPos = false
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
          countPos = true
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
      if monster and monster.monsterMeta.monster_type == Const.SurfingMonsterType.Normal and 0 < countIndex then
        local count = colliderResultList[countIndex]
        if 0 < count then
          monster:SetIsAutoMove(true, self)
        end
      end
    end
  end
  ProfilerUtil.EndSample()
end

function SurfingPBPlayerUnit:PlayerCalculateCollider()
  ProfilerUtil.BeginSample("SurfingPlayerUnit:PlayerCalculateCollider")
  local resultList = PvePhysicsUtil.PlayerCollider()
  local colliderResultList = resultList
  local colliderResultCount = 0
  if resultList then
    local length = #resultList
    local idPos = false
    local countPos = false
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
          countPos = true
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
          monster:OnCollisionViewHandle(self)
        else
          Logger.LogError("SurfingPlayerUnit.PlayerCalculateCollider invalid monster : " .. tostring(objId))
        end
      end
    end
  end
  ProfilerUtil.EndSample()
end

function SurfingPBPlayerUnit:HandleBasicMovement(deltaTime, totalDeltaTime)
  local position = self:GetPosition()
  local newX = position.x
  local newY = position.y
  local newZ = position.z
  if self.baseTime == nil then
    Logger.LogError("the baseTime is nil")
    return
  end
  local diffTime = totalDeltaTime - self.baseTime
  local diffZ = 0
  if diffTime <= self.speedChangeTime then
    diffZ = (self.startSpeed + self.endSpeed) * 0.5 * diffTime
  else
    diffZ = self.changeDistance + (diffTime - self.speedChangeTime) * self.endSpeed
  end
  newZ = diffZ + self.baseDistance
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
    if contactPointY >= tmpNewY then
      self:ChangeBehaviorState(self.BehaviorState.TouchGround)
      tmpNewY = contactPointY
    end
    newY = tmpNewY
  elseif self:IsGrounded() and not isGrounded then
    if not self.lineChangeTimer then
      self:ChangeBehaviorState(self.BehaviorState.FreeFallStart, position.y)
    end
  elseif self.motionState == MotionState.FreeFalling then
  end
  if self:IsSliding() then
    self.slideTimer = self.slideTimer - deltaTime
    if 0 >= self.slideTimer then
      self:ChangeBehaviorState(self.BehaviorState.SlidingFinish)
    end
  end
  if self.lineChangeTimer then
    self.lineChangeTimer = self.lineChangeTimer - deltaTime
    local curX = Mathf.Lerp(self.targetX, self.curX, self.lineChangeTimer / self.lineChangeTime)
    newX = curX
    if 0 >= self.lineChangeTimer then
      self:ChangeBehaviorState(self.BehaviorState.ChangeLanesFinish)
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
  local logic = self.logic
  if logic == nil or not logic.isDebug then
    return
  end
  local time = os.date("%H:%M:%S")
  logic:AppendLog(time .. "[" .. Time.frameCount .. "]" .. " BasicMove")
end

function SurfingPBPlayerUnit:GetPosition()
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

function SurfingPBPlayerUnit:GetCameraFollowXYZ()
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

function SurfingPBPlayerUnit:GetMoveSpeed()
  return self.logic:GetMoveSpeed()
end

function SurfingPBPlayerUnit:DeathModifyZ(posZ)
end

function SurfingPBPlayerUnit:OnMoveLeft()
  if self.curLine > -1 then
    self.curLine = self.curLine - 1
    self.curX = self:GetPosition().x
    self.targetX = self.baseLineX + self.curLine * LineOffset
    self.lineChangeTimer = LineChangeTime
    if not self:IsFlying() then
      self:TryCrossFadeSimpleAnim("left_jump", 1, 0.2)
      DataCenter.LWSoundManager:PlaySound(11010, false)
    end
  end
end

function SurfingPBPlayerUnit:OnMoveRight()
  if self.curLine < 1 then
    self.curLine = self.curLine + 1
    self.curX = self:GetPosition().x
    self.targetX = self.baseLineX + self.curLine * LineOffset
    self.lineChangeTimer = LineChangeTime
    if not self:IsFlying() then
      self:TryCrossFadeSimpleAnim("right_jump", 1, 0.2)
      DataCenter.LWSoundManager:PlaySound(11010, false)
    end
  end
end

function SurfingPBPlayerUnit:OnMoveUp()
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
    self.motionState = MotionState.Jumping
  end
end

function SurfingPBPlayerUnit:OnMoveDown()
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
    local curY = self:GetPosition().y
    local fastDownTime = SlideTime * 0.2
    local newA = 2 * (-curY - curV * fastDownTime) / (fastDownTime * fastDownTime)
    self.verticalAcceleration = newA
    self.verticalMoveStartY = curY
    self.motionState = MotionState.AirSliding
  else
    self.motionState = MotionState.GroundSliding
  end
  self.slideTimer = SlideTime
  self:TryCrossFadeSimpleAnim("down", 1, 0.1)
  DataCenter.LWSoundManager:PlaySound(11011, false)
  self:ShowUnitEffect(SurfingUnitEffectType.Sliding)
end

function SurfingPBPlayerUnit:BeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, attacker)
  if self.invincible then
    return
  end
  base.BeAttack(self, hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff)
end

function SurfingPBPlayerUnit:ChangeToDie(attackerObjId)
  self.fsm:ChangeState(State.Die, attackerObjId)
end

function SurfingPBPlayerUnit:AfterBeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, skill, deathEff)
end

function SurfingPBPlayerUnit:ResetColliderHeight()
end

function SurfingPBPlayerUnit:SetMoveBase(baseTime, baseDistance, startSpeed, endSpeed)
  self.baseTime = baseTime
  self.baseDistance = baseDistance
  self.startSpeed = startSpeed
  self.endSpeed = endSpeed
  self.changeDistance = (startSpeed + endSpeed) * 0.5 * self.speedChangeTime
end

function SurfingPBPlayerUnit:ChangeBehaviorState(state, param)
  if state == BehaviorState.ChangeLanesFinish then
    self.lineChangeTimer = nil
    if not self:IsFlying() then
      self:ChangeToRunAnim()
      self:PlayRunSound()
    end
  elseif state == BehaviorState.SlidingFinish then
    self:ChangeToRunAnim()
    self:PlayRunSound()
    self.motionState = MotionState.Running
  elseif state == BehaviorState.TouchGround then
    if self.motionState == MotionState.AirSliding then
      self.motionState = MotionState.GroundSliding
    else
      self:ChangeToRunAnim()
      if self.motionState ~= state then
        DataCenter.LWSoundManager:PlaySound(11015, false)
        self:PlayRunSound()
      end
      self.motionState = MotionState.Running
    end
  elseif state == BehaviorState.FreeFallStart then
    self.verticalVelocity = 0
    self.verticalAcceleration = self.gravityValue
    self.verticalMoveTimer = 0
    local pos = self:GetPosition()
    self.verticalMoveStartY = param or 0
    self:TryCrossFadeSimpleAnim("fall", 1, 0.2)
    if self.flySound ~= nil then
      DataCenter.LWSoundManager:StopSound(self.flySound)
    end
    if self.motionState ~= state then
      DataCenter.LWSoundManager:PlaySound(11017, false)
    end
    self.motionState = MotionState.FreeFalling
  elseif state == BehaviorState.FlyStart then
    self.flyY = self:GetPosition().y
    self.flySpeed = TakeoffSpeed
    self.flyTimer = FlyTime
    self:TryCrossFadeSimpleAnim("fly", 1, 0.2)
    if self.flySound ~= nil then
      DataCenter.LWSoundManager:StopSound(self.flySound)
    end
    self.flySound = DataCenter.LWSoundManager:PlaySound(11012, true)
    self.motionState = MotionState.Flying
  end
end

function SurfingPBPlayerUnit:IsGrounded()
  return self.motionState == MotionState.Running or self.motionState == MotionState.GroundSliding
end

function SurfingPBPlayerUnit:IsSliding()
  return self.motionState == MotionState.AirSliding or self.motionState == MotionState.GroundSliding
end

function SurfingPBPlayerUnit:IsFlying()
  return self.motionState == MotionState.Flying
end

function SurfingPBPlayerUnit:IsJumping()
  return self.motionState == MotionState.Jumping
end

function SurfingPBPlayerUnit:OnAutoCollect()
  self.autoCollect = true
  if self.triggerRoot == nil and self.triggerRq then
    self.triggerRoot = self.triggerRq.gameObject
  end
  if self.triggerRoot == nil then
    return
  end
  self.autoCollect = true
  self.triggerRoot:SetActive(true)
end

function SurfingPBPlayerUnit:OnAutoCollectFinished()
  self.autoCollect = false
  self.triggerRoot:SetActive(false)
end

function SurfingPBPlayerUnit:InitPlayerCollider()
end

function SurfingPBPlayerUnit:CheckNeedPreventDeath()
end

function SurfingPBPlayerUnit:OnBuffAdded(buff)
  if self.state and self.state == Const.SurfingState.Surfing then
    local bType = buff and buff.meta and buff.meta.type
    if bType == BuffType.SurfingJetPack then
      self:ChangeBehaviorState(BehaviorState.FlyStart)
    elseif bType == BuffType.SurfingMagnet then
      self:OnAutoCollect()
    elseif bType == BuffType.SurfingDoubleCoin or bType == BuffType.SurfingQuatraCoin then
      local scoreMultiplier = tonumber(buff.meta.rawPara)
      self.scoreMultiplier = scoreMultiplier > self.scoreMultiplier and scoreMultiplier or self.scoreMultiplier
    elseif bType == BuffType.SurfingShield then
      if self.isPreventDeath then
        return
      end
      self.isPreventDeath = true
      local viewHandle = self.morphing and self.newAppearanceViewHandle or self.viewHandle
      UnitViewFacade.MPBShieldEffect(viewHandle)
    elseif bType == BuffType.SurfingMorph then
      self:EnterMorph(buff.commonParam)
    end
  end
end

function SurfingPBPlayerUnit:OnBuffRemoved(buff)
  if self.logic == nil then
    return
  end
  if self.state and self.state == Const.SurfingState.Surfing and buff then
    local bType = buff and buff.meta and buff.meta.type
    local count = self:GetTypeBuffCount(bType)
    if 0 < count then
      return
    end
    EventManager:GetInstance():Broadcast(EventId.SurfingOnBuffRemove, buff)
    if bType == BuffType.SurfingJetPack then
      if self:IsFlying() then
        local y = self:GetPosition().y
        self:ChangeBehaviorState(BehaviorState.FreeFallStart, y)
        self.logic:RemoveSkyScores()
      end
    elseif bType == BuffType.SurfingMagnet then
      self:OnAutoCollectFinished()
    elseif bType == BuffType.SurfingDoubleCoin then
      local oBuff = self:GetSingleBuffByType(BuffType.SurfingQuatraCoin)
      if oBuff and oBuff.meta then
        self.scoreMultiplier = tonumber(oBuff.meta.rawPara)
      else
        self.scoreMultiplier = 1
      end
    elseif bType == BuffType.SurfingQuatraCoin then
      local oBuff = self:GetSingleBuffByType(BuffType.SurfingDoubleCoin)
      if oBuff and oBuff.meta then
        self.scoreMultiplier = tonumber(oBuff.meta.rawPara)
      else
        self.scoreMultiplier = 1
      end
    elseif bType == BuffType.SurfingShield then
      self.isPreventDeath = false
      local viewHandle = self.morphing and self.newAppearanceViewHandle or self.viewHandle
      UnitViewFacade.MPBResetShieldEffect(viewHandle)
      self:RemoveAllBuffByType(BuffType.SurfingShield)
      self:ShowUnitEffect(SurfingUnitEffectType.ShieldBroken)
      DataCenter.LWSoundManager:PlaySound(11018, false)
    elseif bType == BuffType.SurfingMorph then
      self:ExitMorph()
    end
  end
end

function SurfingPBPlayerUnit:ShowUnitEffect(type)
  local duration = 0
  if type == SurfingUnitEffectType.GotScore then
    duration = 0.15
  elseif type == SurfingUnitEffectType.GotProps then
    duration = 0.25
  elseif type == SurfingUnitEffectType.ShieldBroken then
    duration = 1
  elseif type == SurfingUnitEffectType.Resurgence then
    duration = 0.7
  elseif type == SurfingUnitEffectType.Morph then
    duration = 1
  elseif type == SurfingUnitEffectType.Sliding then
    duration = 0.4
  end
  local path = EFFECT_PATH[type]
  if path then
    self.logic:ShowEffectObj(EFFECT_PATH[type], ResetPosition, Quaternion.identity, duration, self:GetBuffTransform(1))
  end
end

function SurfingPBPlayerUnit:EnterMorph(path)
  local morphAppearanceId = tonumber(path) or 0
  if morphAppearanceId <= 0 then
    return
  end
  local morphAppearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(morphAppearanceId)
  if morphAppearanceMeta == nil then
    return
  end
  local morphAppearancePath = morphAppearanceMeta.model_path
  if self.appearanceReplacing and self.appearanceReplacingPath == morphAppearancePath then
    return
  end
  if self.newAppearanceViewHandle then
    UnitViewFacade.DestroyUnitView(self.newAppearanceViewHandle)
    self.newAppearanceViewHandle = nil
  end
  self.newAppearanceViewLoaded = false
  self.appearanceReplacing = true
  self.appearanceReplacingPath = morphAppearancePath
  self.appearanceReplacingMeta = morphAppearanceMeta
  local scale = morphAppearanceMeta.model_size
  self.waitReplacingHandle = true
  self.newAppearanceViewHandle, self.newAppearanceViewLoaded = pveUnitViewUtil.CreateUnitView(self.guid, morphAppearancePath, self.transform, scale, 0, 0, 0, ResetPosition.x, ResetPosition.y, ResetPosition.z, LayerMask.NameToLayer("Member"))
  if self.newAppearanceViewLoaded then
    self:OnReplaceViewLoaded(true)
  end
end

function SurfingPBPlayerUnit:OnReplaceViewLoaded(force)
  self.waitReplacingHandle = false
  if self.newAppearanceViewLoaded and not force then
    return
  end
  self.newAppearanceViewLoaded = true
  if self.isPreventDeath then
    UnitViewFacade.MPBShieldEffect(self.newAppearanceViewHandle)
    UnitViewFacade.MPBReset(self.viewHandle)
  end
  UnitViewFacade.SetVisible(self.viewHandle, false)
  self.anim = UnitViewFacade.GetSimpleAnimation(self.newAppearanceViewHandle)
  self:ChangeToRunAnim()
  local morphTransform = UnitViewFacade.GetTransform(self.newAppearanceViewHandle)
  self.morphBuffPoints = {}
  local appearanceMeta = self.appearanceReplacingMeta
  if not table.IsNullOrEmpty(appearanceMeta.buff_path) then
    for i = 1, #appearanceMeta.buff_path do
      if string.IsNullOrEmpty(appearanceMeta.buff_path[i]) then
        self.morphBuffPoints[i] = nil
      else
        local buffPoint = morphTransform:Find(appearanceMeta.buff_path[i])
        if IsNull(buffPoint) then
          Logger.LogError("buff\231\130\185\232\183\175\229\190\132\233\133\141\231\189\174\233\148\153\232\175\175\239\188\140\229\164\150\232\167\130id\239\188\154" .. appearanceMeta.id .. "\239\188\140buff\231\130\185\232\183\175\229\190\132\239\188\154" .. appearanceMeta.buff_path[i])
        end
        self.morphBuffPoints[i] = buffPoint
      end
    end
  end
  self.morphing = true
  self:RefreshBuffsParent()
  self:PlayRunSound()
end

function SurfingPBPlayerUnit:ClearAppearanceReplace()
  if self.isPreventDeath then
    UnitViewFacade.MPBShieldEffect(self.viewHandle)
    UnitViewFacade.MPBReset(self.newAppearanceViewHandle)
  end
  if self.newAppearanceViewHandle then
    UnitViewFacade.DestroyUnitView(self.newAppearanceViewHandle)
    self.newAppearanceViewHandle = nil
  end
  self.newAppearanceViewLoaded = false
  self.appearanceReplacing = false
  self.appearanceReplacingPath = nil
  self.appearanceReplacingMeta = nil
  self.morphBuffPoints = nil
  self.waitReplacingHandle = false
end

function SurfingPBPlayerUnit:ExitMorph()
  self:ClearAppearanceReplace()
  local curAnim = self:GetCurAnimName()
  UnitViewFacade.SetVisible(self.viewHandle, true)
  self.anim = UnitViewFacade.GetSimpleAnimation(self.viewHandle)
  self:TryCrossFadeSimpleAnim(curAnim, 1, 0.2)
  self.morphing = false
  self:RefreshBuffsParent()
end

function SurfingPBPlayerUnit:RefreshBuffsParent()
  if self.buffManager then
    self.buffManager:RefreshBuffsParent()
  end
end

function SurfingPBPlayerUnit:PlayRunSound()
  if self.runSound ~= nil then
    DataCenter.LWSoundManager:StopSound(self.runSound)
  end
  self.runSound = DataCenter.LWSoundManager:PlaySound(11013, true)
end

function SurfingPBPlayerUnit:InstantiateTriggerRoot()
  if self.transform == nil then
    return
  end
  if self.triggerRq then
    return
  end
  local triggerRq = CS.GameEntry.Resource:InstantiateAsync("Assets/Main/Prefabs/LWBattle/Surfing/Hero/TriggerRoot.prefab")
  triggerRq:completed("+", function(handle)
    local ok, msg = xpcall(function()
      local trans = handle.gameObject.transform
      local parent = self.transform
      trans:SetParent(parent)
      trans:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      trans:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      trans:Set_localRotation(0, 0, 0, 1)
      handle.gameObject:SetActive(false)
    end, debug.traceback)
    if not ok then
      Logger.LogError(msg)
      if handle and not IsNull(handle.gameObject) then
        handle.gameObject:SetActive(false)
      end
    end
  end)
  self.triggerRq = triggerRq
end

function SurfingPBPlayerUnit:GetBuffTransform(index)
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

function SurfingPBPlayerUnit:TryApplyCacheCommand()
end

function SurfingPBPlayerUnit:Resurgence()
  self.curBlood = self.maxBlood
  self.fsm:ChangeState(State.Running)
  self:EnableCollider(true)
end

function SurfingPBPlayerUnit:ChangeToRunAnim()
  return self:TryCrossFadeSimpleAnim("run", 1, 0.2)
end

function SurfingPBPlayerUnit:TryCrossFadeSimpleAnim(name, speed, fadeTime, force)
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

function SurfingPBPlayerUnit:AddWaitFadeAnim(name, speed, fadeTime)
  if self.waitFadeAnim == nil then
    self.waitFadeAnim = {}
  end
  self.waitFadeAnim.name = name
  self.waitFadeAnim.speed = speed
  self.waitFadeAnim.fadeTime = fadeTime
  self.isWaitingAnimFade = true
end

function SurfingPBPlayerUnit:ClearWaitFadeAnim()
  if self.waitFadeAnim and self.waitFadeAnim.name then
    for i, _ in pairs(self.waitFadeAnim) do
      self.waitFadeAnim[i] = nil
    end
  end
  self.isWaitingAnimFade = false
end

return SurfingPBPlayerUnit
