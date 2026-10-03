local base = require("Scene.LWBattle.Surfing.SurfingUnit")
local SurfingPlayerUnit = BaseClass("SurfingPlayerUnit", base)
local SurfingPlayerIdleState = require("Scene.LWBattle.Surfing.PlayerFSM.SurfingPlayerIdleState")
local SurfingPlayerRunState = require("Scene.LWBattle.Surfing.PlayerFSM.SurfingPlayerRunState")
local SurfingPlayerDieState = require("Scene.LWBattle.Surfing.PlayerFSM.SurfingPlayerDieState")
local PlayerMovementHelper = require("Scene.LWBattle.Surfing.PlayerMovementHelper")
local FSM = require("Framework.Common.FSM")
local UnitViewFacade = CS.PVEBattleLogic.Unit.UnitViewFacade
local BattleColliderUtils = CS.BattleColliderUtils
local pveUnitViewUtil = require("Scene.LWBattle.BarrageBattle.Unit.PveUnitViewUtil")
local Const = require("Scene.LWBattle.Const")
local SurfingNpcCtrl = require("Scene.LWBattle.Surfing.HunterKiller.SurfingNpcCtrl")
local GameObject = CS.UnityEngine.GameObject
local VIEW_INVALID_HANDLE = -1
local LineOffset = 4
local LineChangeTime = 0.16
local JumpForce = 16.5
local Gravity = -42
local SlideTime = 0.5
local HEIGHT_LIMIT = 3.24
local JUMP_DURATION = 0.72
local CURVE_TOP_PARAM = 4
local TakeoffSpeed = 30
local FlyHeight = 20
local FlyTime = 10
local CacheCommandInterval = 0.3
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
local MotionState = {
  Normal = 0,
  Running = 1,
  Jumping = 2,
  AirSliding = 3,
  GroundSliding = 4,
  Flying = 5,
  FreeFalling = 6
}
local CommandOpType = {
  None = 0,
  Up = 1,
  Down = 2,
  Left = 3,
  Right = 4
}
local JUMP_ANIM_NAME = {"up", "up02"}
local EFFECT_PATH = {
  [SurfingUnitEffectType.GotScore] = "Assets/Main/Prefabs/LWBattle/Surfing/Effect/Eff_s_s4_running_chijinbi.prefab",
  [SurfingUnitEffectType.GotProps] = "Assets/Main/Prefabs/LWBattle/Surfing/Effect/Eff_s_s4_running_chidaoju.prefab",
  [SurfingUnitEffectType.ShieldBroken] = "Assets/Main/Prefabs/LWBattle/Surfing/Effect/Eff_s_s4_running_hudunposui.prefab",
  [SurfingUnitEffectType.Resurgence] = "Assets/Main/Prefabs/LWBattle/Surfing/Effect/Eff_s_s4_running_fuhuo.prefab",
  [SurfingUnitEffectType.Morph] = "Assets/Main/Prefabs/LWBattle/Surfing/Effect/Eff_s_s4_running_bianshen.prefab",
  [SurfingUnitEffectType.Sliding] = "Assets/Main/Prefabs/LWBattle/Surfing/Effect/Eff_s_s4_running_huachan_smoke.prefab",
  [SurfingUnitEffectType.SpeedUp] = "Assets/Main/Prefabs/LWBattle/Surfing/Effect/Eff_s_s4_running_jiasu.prefab"
}

function SurfingPlayerUnit:Init(logic, localPos, curLine, hero)
  base.Init(self, logic, localPos)
  local go = GameObject("SurfingPlayer")
  self.gameObject = go
  self.transform = go.transform
  self:InstantiateTriggerRoot()
  if DataCenter.LWBattleManager.lineOffset then
    LineOffset = DataCenter.LWBattleManager.lineOffset
    LineChangeTime = DataCenter.LWBattleManager.lineChangeTime
    JumpForce = DataCenter.LWBattleManager.jumpForce
    Gravity = DataCenter.LWBattleManager.gravity
    SlideTime = DataCenter.LWBattleManager.slideTime
  end
  self.curLine = curLine
  self.baseLineX = localPos.x
  self.lineChangeTime = LineChangeTime
  self.localPosition = localPos
  self.lastCameraFollowPos = Vector3.New(localPos.x, localPos.y, localPos.z)
  self.type = Const.ParkourUnitType.Hero
  self.unitType = UnitType.Member
  self.searchType = BattleSearchType.Member
  self.hero = hero
  self.appearanceMeta = hero and DataCenter.AppearanceTemplateManager:GetTemplate(hero.appearance)
  self.maxBlood = 1
  self.curBlood = self.maxBlood
  self.oldOption = true
  self.jumpVoValue = JumpForce
  self.gravityValue = Gravity
  self.heightLimitValue = HEIGHT_LIMIT
  self.jumpDurationValue = JUMP_DURATION
  self.curveTopParamValue = CURVE_TOP_PARAM
  self.verticalVelocity = 0
  self.verticalAcceleration = 0
  self.maxHeight = 0
  self.jumpDuration = 0
  self.curveTopParam = 0
  self.flyHeight = FlyHeight
  self:ChangeMotionState(MotionState.Running)
  self.fadeTime = 0
  self.isWaitingAnimFade = nil
  self.waitFadeAnim = nil
  self:SetLocalPosition(self.localPosition)
  self.viewLoaded = false
  self.viewHandle = VIEW_INVALID_HANDLE
  local scale = self.appearanceMeta.model_size
  self.viewScale = scale
  local path = self.appearanceMeta.model_path
  self.viewHandle, self.viewLoaded = pveUnitViewUtil.CreateUnitView(self.guid, path, self.transform, scale, 0, 0, 0, ResetPosition.x, ResetPosition.y, ResetPosition.z, LayerMask.NameToLayer("Member"))
  if self.viewLoaded then
    self:OnViewLoaded(true)
  end
  self.morphing = false
  self.BehaviorState = BehaviorState
  self.colliderMap = {}
  self.isPreventDeath = false
  self.scoreMultiplier = 1
  self.collider = nil
  self.lastCenter = nil
  self.lastCacheCommandOp = CommandOpType.None
  self.lastCacheCommandTime = 0
end

function SurfingPlayerUnit:ComponentDefine()
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

function SurfingPlayerUnit:DestroyView()
  BattleColliderUtils.ClearUnitColliderData()
  BattleColliderUtils.ClearPlayerColliderData()
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

function SurfingPlayerUnit:DestroyData()
  base.DestroyData(self)
  self.scoreMultiplier = nil
  self.collider = nil
  self.lastCenter = nil
  self.movementHelper = nil
  self.surfingNpcCtrl = nil
  if self.flySound ~= nil then
    DataCenter.LWSoundManager:StopSound(self.flySound)
    self.flySound = nil
  end
  self.fadeTime = nil
  self.isWaitingAnimFade = nil
  self.waitFadeAnim = nil
end

function SurfingPlayerUnit:OnViewLoaded(force, objHandle)
  if self.waitReplacingHandle and objHandle and self.newAppearanceViewHandle and objHandle == self.newAppearanceViewHandle then
    self:OnReplaceViewLoaded(false)
    return
  end
  if self.viewLoaded and not force then
    return
  end
  self.viewLoaded = true
  self.viewTransform = UnitViewFacade.GetTransform(self.viewHandle)
  self.movementHelper = PlayerMovementHelper.New(self, self.transform, self.logic.speedChangeTime)
  self:ComponentDefineWithoutView()
  self:ComponentDefine()
  self:InitFSM()
  self:InitPlayerCollider()
  if self.logic then
    self.logic:CheckLoadFinish()
  end
  if self.curBlood <= 0 then
    self:Die()
    return
  end
end

function SurfingPlayerUnit:InitFSM()
  self.fsm = FSM.New()
  self.fsm:AddState(State.Idle, SurfingPlayerIdleState.New(self))
  self.fsm:AddState(State.Running, SurfingPlayerRunState.New(self))
  self.fsm:AddState(State.Die, SurfingPlayerDieState.New(self))
  if self.cacheFsm then
    self:ChangeState(self.cacheFsm)
  elseif self.logic and self.logic.state and self.logic.state == Const.SurfingState.Surfing then
    self.fsm:ChangeState(State.Running)
  else
    self.fsm:ChangeState(State.Idle)
  end
  self.cacheFsm = nil
end

function SurfingPlayerUnit:Die()
end

function SurfingPlayerUnit:ChangeState(newState)
  if self.fsm == nil then
    self.cacheFsm = newState
    return
  end
  self.state = newState
  if newState == Const.SurfingState.Surfing then
    self.fsm:ChangeState(State.Running)
  end
end

function SurfingPlayerUnit:OnUpdate(deltaTime, totalDeltaTime)
  base.OnUpdate(self, deltaTime)
  if self.fsm then
    self.fsm:OnUpdate(deltaTime)
  end
  if self.state == Const.SurfingState.Surfing then
    if self.movementHelper then
      self.movementHelper:Update(deltaTime, totalDeltaTime)
    end
    if self.surfingNpcCtrl then
      self.surfingNpcCtrl:OnUpdate(deltaTime)
    end
  end
  self:CalculateCollider()
  self:PlayerCalculateCollider()
  if self.fadeTime and self.fadeTime > 0 then
    self.fadeTime = self.fadeTime - deltaTime
    if self.fadeTime <= 0 and self.isWaitingAnimFade and self.waitFadeAnim then
      self:TryCrossFadeSimpleAnim(self.waitFadeAnim.name, self.waitFadeAnim.speed, self.waitFadeAnim.fadeTime)
    end
  end
end

function SurfingPlayerUnit:GetPosition()
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

function SurfingPlayerUnit:GetCameraFollowXYZ()
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

function SurfingPlayerUnit:GetMoveSpeed()
  return self.logic:GetMoveSpeed()
end

function SurfingPlayerUnit:SetMoveBase(baseTime, baseDistance, startSpeed, endSpeed)
  if self.movementHelper then
    self.movementHelper:UpdateMoveValue(baseTime, baseDistance, startSpeed, endSpeed)
  end
end

function SurfingPlayerUnit:DeathModifyZ(posZ)
  local pos = self:GetPosition()
  posZ = 0 < posZ and posZ or pos.z
  self:SetPositionXYZ(pos.x, 0, posZ)
  EventManager:GetInstance():Broadcast(EventId.SurfingOnPlayerDeathModifyZ)
end

function SurfingPlayerUnit:OnMoveLeft()
  self.lastCacheCommandOp = CommandOpType.None
  if self.curLine > -1 then
    self.curLine = self.curLine - 1
    self.curX = self:GetPosition().x
    self.targetX = self.baseLineX + self.curLine * LineOffset
    self.lineChangeTimer = LineChangeTime
    if not self:IsFlying() then
      self:TryCrossFadeSimpleAnim("left_jump", 1, 0, true)
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_Battle_Surfing_Run_LR, false)
    end
    self.logic:LogPlayerInput(INPUT_FLAGS.LEFT)
    return true
  end
  return false
end

function SurfingPlayerUnit:OnMoveRight()
  self.lastCacheCommandOp = CommandOpType.None
  if self.curLine < 1 then
    self.curLine = self.curLine + 1
    self.curX = self:GetPosition().x
    self.targetX = self.baseLineX + self.curLine * LineOffset
    self.lineChangeTimer = LineChangeTime
    if not self:IsFlying() then
      self:TryCrossFadeSimpleAnim("right_jump", 1, 0, true)
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_Battle_Surfing_Run_LR, false)
    end
    self.logic:LogPlayerInput(INPUT_FLAGS.RIGHT)
    return true
  end
  return false
end

function SurfingPlayerUnit:OnMoveUp()
  if self:IsGrounded() then
    local index = math.random(1, 2)
    local anim = JUMP_ANIM_NAME[index] or JUMP_ANIM_NAME[1]
    self:TryCrossFadeSimpleAnim(anim, 1, 0.2)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_Battle_Surfing_Run_JumpDown, false)
    if self.oldOption then
      self.verticalVelocity = self.jumpVoValue
      self.verticalAcceleration = self.gravityValue
    else
      self.maxHeight = self.heightLimitValue
      self.jumpDuration = self.jumpDurationValue
      self.curveTopParam = self.curveTopParamValue
    end
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

function SurfingPlayerUnit:OnMoveDown()
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
    if self.oldOption then
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
    else
      self.verticalMoveTimer = self.jumpDurationValue * 0.75
      self.verticalMoveStartY = 0
      self.maxHeight = self:GetPosition().y
      self.jumpDuration = self.jumpDurationValue
      self.curveTopParam = self.curveTopParamValue
    end
    self.slideTimer = SlideTime
    self:ChangeMotionState(MotionState.AirSliding)
  else
    self.slideTimer = SlideTime
    self:ChangeMotionState(MotionState.GroundSliding)
  end
  self:TryCrossFadeSimpleAnim("down", 1, 0.1)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_Battle_Surfing_Run_Dash, false)
  self:ShowUnitEffect(SurfingUnitEffectType.Sliding)
  if self.collider == nil then
    self.collider = self:GetCollider()
  end
  BattleColliderUtils.ChangePlayerCollider(self.guid, 0.6)
  self.logic:LogPlayerInput(INPUT_FLAGS.DOWN)
  return true
end

function SurfingPlayerUnit:BeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, attacker)
  if self:CheckIsInvincible() then
    return
  end
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_Battle_Surfing_Impact, false)
  base.BeAttack(self, hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff)
  if 0 < hurt then
    hurt = self:ReduceShieldValue(hurt)
    local targetBlood = math.max(self.curBlood - hurt, 0)
    if targetBlood <= 1.0E-7 then
      targetBlood = 0
    end
    if targetBlood <= 0 and self:CheckNeedPreventDeath() then
      return
    end
    self.curBlood = targetBlood
    if 0 >= self.curBlood then
      local attackerObjId = 0
      if attacker then
        attackerObjId = attacker.guid
      end
      self.fsm:ChangeState(State.Die, attackerObjId)
    end
  end
end

function SurfingPlayerUnit:ChangeToDie(attackerObjId)
  self.fsm:ChangeState(State.Die, attackerObjId)
  self:ResetColliderHeight()
end

function SurfingPlayerUnit:AfterBeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, skill, deathEff)
  if self:CheckIsInvincible() then
    return
  end
  base.AfterBeAttack(self, hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, skill, deathEff)
end

function SurfingPlayerUnit:CheckIsInvincible()
  return self.invincible or self:IsFlying()
end

function SurfingPlayerUnit:ResetColliderHeight()
  BattleColliderUtils.ChangePlayerCollider(self.guid, 1)
end

function SurfingPlayerUnit:ChangeBehaviorState(state, param)
  if state == BehaviorState.ChangeLanesFinish then
    self.lineChangeTimer = nil
    if not self:IsFlying() then
      self:ChangeToRunAnim()
      self:PlayRunSound()
    end
  elseif state == BehaviorState.SlidingFinish then
    self:ChangeToRunAnim()
    self:PlayRunSound()
    self:ChangeMotionState(MotionState.Running)
    self.applyCommand = true
  elseif state == BehaviorState.TouchGround then
    if self.motionState == MotionState.AirSliding then
      self:ChangeMotionState(MotionState.GroundSliding)
    else
      self:ChangeToRunAnim()
      if self.motionState ~= state then
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_Battle_Surfing_Landing, false)
        self:PlayRunSound()
      end
      self:ChangeMotionState(MotionState.Running)
      self.applyCommand = true
    end
  elseif state == BehaviorState.FreeFallStart then
    if self.oldOption then
      self.verticalVelocity = 0
      self.verticalAcceleration = self.gravityValue
      self.verticalMoveTimer = 0
      self.verticalMoveStartY = param or 0
    else
      self.verticalMoveTimer = self.jumpDurationValue / 2
      self.verticalMoveStartY = 0
      self.maxHeight = self:GetPosition().y
      self.jumpDuration = self.jumpDurationValue
      self.curveTopParam = self.curveTopParamValue
    end
    self:TryCrossFadeSimpleAnim("fall", 1, 0.2)
    if self.flySound ~= nil then
      DataCenter.LWSoundManager:StopSound(self.flySound)
    end
    if self.motionState == state or self.lineChangeTimer and self.motionState ~= MotionState.ChangeLanesFinish then
    else
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_Battle_Surfing_Run_Down, false)
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
    self.flySound = DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_Battle_Surfing_Jetpack_Loop, true)
    self:ChangeMotionState(MotionState.Flying)
  end
end

function SurfingPlayerUnit:ChangeMotionState(state)
  if self.motionState ~= state then
    if self:IsSliding() and state ~= MotionState.AirSliding and state ~= MotionState.GroundSliding then
      self:ResetColliderHeight()
    end
    self.motionState = state
  end
end

function SurfingPlayerUnit:IsGrounded()
  return self.motionState == MotionState.Running or self.motionState == MotionState.GroundSliding
end

function SurfingPlayerUnit:IsSliding()
  return self.motionState == MotionState.AirSliding or self.motionState == MotionState.GroundSliding
end

function SurfingPlayerUnit:IsFlying()
  return self.motionState == MotionState.Flying
end

function SurfingPlayerUnit:IsJumping()
  return self.motionState == MotionState.Jumping
end

function SurfingPlayerUnit:TryApplyCacheCommand()
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

function SurfingPlayerUnit:OnAutoCollect()
  if self.autoCollect then
    return
  end
  if self.triggerRoot == nil and self.triggerRq then
    self.triggerRoot = self.triggerRq.gameObject
  end
  if self.triggerRoot == nil then
    return
  end
  self.autoCollect = true
  self.triggerRoot:SetActive(true)
  BattleColliderUtils.AddUnitCollider(self.viewHandle, self.guid, LayerMask.GetMask("Junk"), self.triggerRoot)
end

function SurfingPlayerUnit:OnAutoCollectFinished()
  self.autoCollect = false
  BattleColliderUtils.RemoveUnitCollider()
  self.triggerRoot:SetActive(false)
end

function SurfingPlayerUnit:OnAutoCollectTrigger(propsData)
  local buffData = self.buffState[TorchRelayBuffState.AutoCollect]
  buffData = buffData or {}
  buffData.durationEnd = Time.time + propsData.duration
  buffData.duration = propsData.duration
  buffData.bound = propsData.bound
  self.buffState[TorchRelayBuffState.AutoCollect] = buffData
  self:OnAddBuff(TorchRelayBuffState.AutoCollect, propsData)
  self:ShowBuffEffect(TorchRelayBuffState.AutoCollect, propsData)
end

function SurfingPlayerUnit:CalculateCollider(deltaTime)
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

function SurfingPlayerUnit:PlayerCalculateCollider()
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

function SurfingPlayerUnit:OnBuffAdded(buff)
  if self.state and self.state == Const.SurfingState.Surfing then
    local bType = buff and buff.meta and buff.meta.type
    if bType == BuffType.SurfingJetPack then
      Logger.LogInfo("Surfing -- OnBuffAdded: fly start")
      self:ChangeBehaviorState(BehaviorState.FlyStart)
    elseif bType == BuffType.SurfingMagnet then
      self:OnAutoCollect()
    elseif bType == BuffType.SurfingDoubleCoin or bType == BuffType.SurfingQuatraCoin then
      local scoreMultiplier = tonumber(buff.meta.rawPara)
      self.scoreMultiplier = scoreMultiplier > self.scoreMultiplier and scoreMultiplier or self.scoreMultiplier
    elseif bType == BuffType.SurfingShield then
      Logger.LogInfo("Surfing -- OnBuffAdded: shield start")
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

function SurfingPlayerUnit:OnBuffRemoved(buff)
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
        Logger.LogInfo("Surfing -- OnBuffRemoved: fly end")
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
      Logger.LogInfo("Surfing -- OnBuffRemoved: shield end")
      self.isPreventDeath = false
      local viewHandle = self.morphing and self.newAppearanceViewHandle or self.viewHandle
      UnitViewFacade.MPBResetShieldEffect(viewHandle)
      self:RemoveAllBuffByType(BuffType.SurfingShield)
      self:ShowUnitEffect(SurfingUnitEffectType.ShieldBroken)
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_Battle_Surfing_Shield_Break, false)
    elseif bType == BuffType.SurfingMorph then
      self:ExitMorph()
    end
  end
end

function SurfingPlayerUnit:EnterMorph(path)
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

function SurfingPlayerUnit:OnReplaceViewLoaded(force)
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

function SurfingPlayerUnit:ClearAppearanceReplace()
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

function SurfingPlayerUnit:ExitMorph()
  self:ClearAppearanceReplace()
  local curAnim = self:GetCurAnimName()
  UnitViewFacade.SetVisible(self.viewHandle, true)
  self.anim = UnitViewFacade.GetSimpleAnimation(self.viewHandle)
  self:TryCrossFadeSimpleAnim(curAnim, 1, 0.2)
  self.morphing = false
  self:RefreshBuffsParent()
end

function SurfingPlayerUnit:RefreshBuffsParent()
  if self.buffManager then
    self.buffManager:RefreshBuffsParent()
  end
end

function SurfingPlayerUnit:CheckNeedPreventDeath()
  if self.isPreventDeath then
    self.isPreventDeath = false
    self.logic:ClearMonstersByOffset()
    self:RemoveAllBuffByType(BuffType.SurfingShield)
    return true
  end
  if self.logic and self.logic.isGuide then
    return true
  end
  return false
end

function SurfingPlayerUnit:InitPlayerCollider()
  BattleColliderUtils.AddPlayerCollider(self.viewHandle, self.guid, LayerMask.GetMask("Junk", "Zombie"))
end

function SurfingPlayerUnit:Resurgence()
  self.curBlood = self.maxBlood
  self.fsm:ChangeState(State.Running)
  self:EnableCollider(true)
end

function SurfingPlayerUnit:ShowUnitEffect(type)
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
  elseif type == SurfingUnitEffectType.SpeedUp then
    duration = 1
  end
  local path = EFFECT_PATH[type]
  if path then
    self.logic:ShowEffectObj(EFFECT_PATH[type], ResetPosition, Quaternion.identity, duration, self:GetBuffTransform(1))
  end
end

function SurfingPlayerUnit:PlayRunSound()
  if self.runSound ~= nil then
    DataCenter.LWSoundManager:StopSound(self.runSound)
  end
  self.runSound = DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_Battle_Surfing_Ftsp_Loop, true)
end

function SurfingPlayerUnit:GetBuffTransform(index)
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

function SurfingPlayerUnit:GetDebugLog()
  return self.movementHelper:GetDebugLog()
end

function SurfingPlayerUnit:ChangeToRunAnim()
  return self:TryCrossFadeSimpleAnim("run", 1, 0.2)
end

function SurfingPlayerUnit:TryCrossFadeSimpleAnim(name, speed, fadeTime, force)
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

function SurfingPlayerUnit:AddWaitFadeAnim(name, speed, fadeTime)
  if self.waitFadeAnim == nil then
    self.waitFadeAnim = {}
  end
  self.waitFadeAnim.name = name
  self.waitFadeAnim.speed = speed
  self.waitFadeAnim.fadeTime = fadeTime
  self.isWaitingAnimFade = true
end

function SurfingPlayerUnit:ClearWaitFadeAnim()
  if self.waitFadeAnim and self.waitFadeAnim.name then
    for i, _ in pairs(self.waitFadeAnim) do
      self.waitFadeAnim[i] = nil
    end
  end
  self.isWaitingAnimFade = false
end

function SurfingPlayerUnit:InstantiateTriggerRoot()
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

function SurfingPlayerUnit:GetCurTransform()
  local viewHandle = self.morphing and self.newAppearanceViewHandle or self.viewHandle
  if viewHandle then
    return UnitViewFacade.GetTransform(viewHandle)
  end
end

return SurfingPlayerUnit
