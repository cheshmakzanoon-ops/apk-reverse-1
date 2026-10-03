local FSMachine = require("Common.FSMachine")
local Resource = CS.GameEntry.Resource
local GameObject = CS.UnityEngine.GameObject
local TorchConstant = require("DataCenter/LWBattle/Logic/TorchRelayBattle/TorchRelayBattleConstant")
local IdleState = require("DataCenter/LWBattle/Logic/TorchRelayBattle/Player/TorchRelayBattlePlayerStateIdle")
local RunState = require("DataCenter/LWBattle/Logic/TorchRelayBattle/Player/TorchRelayBattlePlayerStateRun")
local FinishState = require("DataCenter/LWBattle/Logic/TorchRelayBattle/Player/TorchRelayBattlePlayerStateFinish")
local TorchRelayBattlePlayer = BaseClass("TorchRelayBattlePlayer")
TorchRelayBattlePlayer.State = {
  None = 0,
  Idle = 1,
  Run = 2,
  Finish = 3
}
TorchRelayBattlePlayer.HorizontalMoveState = {
  Idle = 1,
  Left = 2,
  Right = 3
}
TorchRelayBattlePlayer.Anim = {
  Idle = "Idle",
  DeadIdle = "DeadIdle",
  Roll = "Roll",
  Run01 = "Run01",
  Run02 = "Run02",
  Hit = "Hit",
  Transfer01 = "Transfer01",
  Transfer02 = "Transfer02",
  Happy01 = "Happy01",
  Happy02 = "Happy02",
  Happy03 = "Happy03",
  Happy04 = "Happy04",
  Happy05 = "Happy05"
}

function TorchRelayBattlePlayer:__init(logic)
  self.logic = logic
  if not self.logic or not self.logic.data then
    return
  end
  local postEventData = {
    speed = self.logic.data:GetInitVerticalSpeed(),
    stamina = self.logic.data:GetInitStamina(),
    lucky = self.logic.data:GetLucky()
  }
  PostEventLog.Track(PostEventLog.Defines.ActivityTorchRelayEnterGameGrowUp, postEventData)
  self.staminaMax = self.logic.data:GetInitStamina()
  self.stamina = self.staminaMax
  self.costStaminaPerSecond = self.logic.data:GetStaminaCostPerSecond()
  self.baseSpeed = self.logic.data:GetInitVerticalSpeed()
  self.speed = self.baseSpeed
  self.speedPercentMaxLimit = self.logic.data.stage.speed_up_max * 1.0E-4
  self.speedPower = self.logic.data.stage.start_speed_power
  self.minSpeedPower = 0
  self.maxSpeedPower = self.logic.data.stage.speed_power_max
  self.addSpeedPercent = self.logic.data.stage.speed_percent * 1.0E-4
  self.addSpeedDuration = self.logic.data.stage.speed_last_time
  self.curStateHorizontal = self.HorizontalMoveState.Idle
  local go = GameObject("TorchRelayPlayerRoot")
  self.gameObject = go
  self.transform = self.gameObject.transform
  self.curPos = Vector3.New(0, 0, 0)
  self.curState = nil
  self.birthPos = self.logic.data:GetPlayerBirthPos()
  self:SetPosition(self.birthPos.x, self.birthPos.z)
  self.transform:Set_localScale(TorchConstant.PLAYER_SCALE:Split())
  self.anim = nil
  local playerResPath = self.logic.data.stage:GetMainPlayerResPath()
  self.reqPlayer = Resource:InstantiateAsync(playerResPath)
  self.reqPlayer:completed("+", function(handle)
    local gameObject = handle.gameObject
    local transform = handle.gameObject.transform
    transform:SetParent(self.transform, false)
    transform:Set_localPosition((Vector3.zero + Vector3.up * 0.01):Split())
    transform:Set_localScale(ResetScale:Split())
    transform.rotation = Quaternion.Euler(0, 0, 0)
    gameObject:SetActive(true)
    self.goPlayer = gameObject
    self.transPlayer = transform
    self.anim = transform:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
    self:PlayAnim(self.Anim.Idle)
    self:InitRenderers()
  end)
  self:InitFlyItemAsset()
  self:InitHpBar()
  self.fsm = FSMachine.Create(self)
  self.fsm:Add(self.State.Idle, IdleState.Create())
  self.fsm:Add(self.State.Run, RunState.Create())
  self.fsm:Add(self.State.Finish, FinishState.Create())
  self:ChangeState(self.State.Idle)
  self.buffState = {}
  self.buffStateEffectMap = {}
  self.buffStateEffectHandle = {}
end

function TorchRelayBattlePlayer:__delete()
end

function TorchRelayBattlePlayer:Destroy()
  self.addBuffEffectCpts = nil
  if self.addBuffEffectReq then
    self.addBuffEffectReq:Destroy()
    self.addBuffEffectReq = nil
  end
  if self.invincibleSpecialEffectReq then
    self.invincibleSpecialEffectReq:Destroy()
    self.invincibleSpecialEffectReq = nil
  end
  self.invincibleSpecialEffectCpts = nil
  if self.invincibleSpecialEffectSceneReq then
    self.invincibleSpecialEffectSceneReq:Destroy()
    self.invincibleSpecialEffectSceneReq = nil
  end
  self.invincibleSpecialEffectSceneCpts = nil
  self.addStrengthEffectCpts = nil
  if self.addStrengthEffectReq then
    self.addStrengthEffectReq:Destroy()
    self.addStrengthEffectReq = nil
  end
  self:ClearMPB()
  if self.playerScaleAniSequence ~= nil then
    self.playerScaleAniSequence:Pause()
    self.playerScaleAniSequence:Kill()
    self.playerScaleAniSequence = nil
  end
  if self.playerAddInvincibleBuffSeq ~= nil then
    self.playerAddInvincibleBuffSeq:Pause()
    self.playerAddInvincibleBuffSeq:Kill()
    self.playerAddInvincibleBuffSeq = nil
  end
  if self.playerRemoveInvincibleBuffSeq ~= nil then
    self.playerRemoveInvincibleBuffSeq:Pause()
    self.playerRemoveInvincibleBuffSeq:Kill()
    self.playerRemoveInvincibleBuffSeq = nil
  end
  if not IsNull(self.reqPlayer) then
    self.reqPlayer:Destroy()
  end
  self.reqPlayer = nil
  if not IsNull(self.reqFlyItem) then
    self.reqFlyItem:Destroy()
  end
  self.reqFlyItem = nil
  if not IsNull(self.reqHpBar) then
    self.reqHpBar:Destroy()
  end
  self.reqHpBar = nil
  for i, v in pairs(self.buffStateEffectHandle) do
    if v then
      v:Destroy()
    end
  end
  self.buffStateEffectHandle = nil
  self.buffStateEffectMap = nil
  if self.gameObject then
    GameObject.Destroy(self.gameObject)
    self.gameObject = nil
    self.transform = nil
  end
end

function TorchRelayBattlePlayer:InitRenderers()
  self.renders = {}
  local skinnedMeshRenderer = self.gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.SkinnedMeshRenderer))
  local meshRenderer = self.gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.MeshRenderer))
  if skinnedMeshRenderer then
    local length = skinnedMeshRenderer.Length
    for i = 0, length - 1 do
      table.insert(self.renders, skinnedMeshRenderer[i])
    end
  end
  if meshRenderer then
    local length = meshRenderer.Length
    for i = 0, length - 1 do
      table.insert(self.renders, meshRenderer[i])
    end
  end
  local MPB = CS.UnityEngine.MaterialPropertyBlock()
  MPB:SetColor("_BaseColor", Color.New(1, 1, 1, 1))
  self.MPB = MPB
  self:HideHighLight()
end

function TorchRelayBattlePlayer:SetPosition(x, z)
  self.curPos.x = x
  self.curPos.z = z
  if self.transform then
    self.transform:Set_position(x, 0, z)
  end
end

function TorchRelayBattlePlayer:OnUpdate(deltaTime)
  if self.fsm then
    self.fsm:Update(deltaTime)
  end
  local curStamina = self:GetStamina()
  if curStamina and self.costStaminaPerSecond then
    self:SetStamina(curStamina - deltaTime * self.costStaminaPerSecond)
  end
  for k, v in pairs(self.buffState) do
    if v.durationEnd < Time.time then
      self.buffState[k] = nil
      self:OnRemoveBuff(k)
    end
  end
  if self.buffState[TorchRelayBuffState.AutoCollect] then
    self:OnAutoCollectBuffDoing()
  end
  if self.buffState[TorchRelayBuffState.InvincibleBeAttacked] then
    self:OnUpdateInvincibleBeAttacked(deltaTime)
  end
end

function TorchRelayBattlePlayer:GetStamina()
  if self.stamina then
    return self.stamina
  end
  return 0
end

function TorchRelayBattlePlayer:SetStamina(value)
  self.stamina = value
  self:UpdateHpBar()
end

function TorchRelayBattlePlayer:AddStamina(value)
  self.stamina = math.min(self.stamina + value, self.staminaMax)
end

function TorchRelayBattlePlayer:SubStamina(value)
  self.stamina = math.max(self.stamina - value, 0)
end

function TorchRelayBattlePlayer:GetPosition()
  return self.curPos
end

function TorchRelayBattlePlayer:GetScore()
  if self.birthPos then
    return math.floor(self.curPos.z - self.birthPos.z)
  end
  return math.floor(self.curPos.z)
end

function TorchRelayBattlePlayer:GetMoveSpeedVertical()
  if self.buffState[TorchRelayBuffState.Invincible] then
    self.speed = self.baseSpeed * (1 + self.buffState[TorchRelayBuffState.Invincible].addSpeedPercent)
  elseif self.buffState[TorchRelayBuffState.SpeedAdd] then
    self.speed = self.baseSpeed * (1 + self.buffState[TorchRelayBuffState.SpeedAdd].addSpeedPercent)
  else
    self.speed = self.baseSpeed
  end
  return self.speed
end

function TorchRelayBattlePlayer:GetMoveSpeedHorizontal()
  return TorchConstant.PLAYER_HORIZONTAL_MOVE_DISTANCE_PER_SECOND
end

function TorchRelayBattlePlayer:ChangeHorizontalMoveState(state)
  if self.curStateHorizontal == state then
    return
  end
  self.curStateHorizontal = state
end

function TorchRelayBattlePlayer:ChangeState(targetState)
  if self.curState == targetState then
    return
  end
  Logger.Log("\232\183\145\233\133\183 \228\186\186\231\137\169 ChangeState:" .. tostring(targetState))
  self.fsm:Switch(targetState)
  self.curState = targetState
end

function TorchRelayBattlePlayer:InitAttributeShow()
  self.logic:UpdateMainUI_SpeedPower(self.speedPower, 0)
end

function TorchRelayBattlePlayer:GetBuffStateData(buffState)
  if self.buffState then
    return self.buffState[buffState]
  end
  return nil
end

function TorchRelayBattlePlayer:WalkBuffStateData(func)
  if func == nil then
    return
  end
  if self.buffState then
    for state, data in pairs(self.buffState) do
      if data then
        func(state, data)
      end
    end
  end
end

function TorchRelayBattlePlayer:OnStrengthAddTrigger(propsData)
  self:AddStamina(propsData.addStrength)
  self:OnAddBuff(TorchRelayBuffState.StrengthAdd, propsData)
  self:ShowEffectOnAddStrength(propsData)
  self:ShowFlyItem(TorchConstant.PLAYER_FLY_ITEM_STAMINA_ICON, "+" .. tostring(propsData.addStrength))
end

function TorchRelayBattlePlayer:OnSpeedAddTrigger(propsData)
  local buffData = self.buffState[TorchRelayBuffState.SpeedAdd]
  buffData = buffData or {}
  self.speedPower = self.speedPower + propsData.addSpeedPower
  if self.speedPower >= self.maxSpeedPower then
    self.logic:UpdateMainUI_SpeedPower(self.maxSpeedPower, 0)
    buffData.addSpeedPercent = self.addSpeedPercent
    buffData.durationEnd = Time.time + self.addSpeedDuration
    buffData.duration = self.addSpeedDuration
    self.buffState[TorchRelayBuffState.SpeedAdd] = buffData
    self.speedPower = self.speedPower - self.maxSpeedPower
    if self.speedPower > 0 then
      self.logic:UpdateMainUI_SpeedPower(0, 0)
    end
    self:ShowBuffEffect(TorchRelayBuffState.SpeedAdd, propsData)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_speed_up, false, true)
    self.logic:ShowBuffStateUI(TorchRelayBuffState.SpeedAdd, propsData)
  end
  self.logic:UpdateMainUI_SpeedPower(self.speedPower, propsData.addSpeedPower)
  self:OnAddBuff(TorchRelayBuffState.SpeedAdd, propsData)
end

function TorchRelayBattlePlayer:OnDefendTrigger(propsData)
  self.buffState[TorchRelayBuffState.Defend] = {
    durationEnd = Time.time + propsData.duration,
    duration = propsData.duration
  }
  self:OnAddBuff(TorchRelayBuffState.Defend, propsData)
  self:ShowBuffEffect(TorchRelayBuffState.Defend, propsData)
end

function TorchRelayBattlePlayer:OnAutoCollectTrigger(propsData)
  local buffData = self.buffState[TorchRelayBuffState.AutoCollect]
  buffData = buffData or {}
  buffData.durationEnd = Time.time + propsData.duration
  buffData.duration = propsData.duration
  buffData.bound = propsData.bound
  self.buffState[TorchRelayBuffState.AutoCollect] = buffData
  self:OnAddBuff(TorchRelayBuffState.AutoCollect, propsData)
  self:ShowBuffEffect(TorchRelayBuffState.AutoCollect, propsData)
end

function TorchRelayBattlePlayer:OnInvincibleTrigger(propsData)
  local buffData = self.buffState[TorchRelayBuffState.Invincible]
  buffData = buffData or {}
  if not buffData.durationEnd or buffData.durationEnd < Time.time then
    self:OnAddNewInvincibleBuff()
  end
  buffData.addSpeedPercent = propsData.addSpeedPercent
  buffData.durationEnd = Time.time + propsData.duration
  buffData.duration = propsData.duration
  self.buffState[TorchRelayBuffState.Invincible] = buffData
  self:OnAddBuff(TorchRelayBuffState.Invincible, propsData)
  self:ShowBuffEffect(TorchRelayBuffState.Invincible, propsData)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_speed_up, false, true)
end

function TorchRelayBattlePlayer:OnObstaclesTrigger(propsData)
  self:EatObstacleRecord(propsData.configId)
  if self.buffState[TorchRelayBuffState.Invincible] then
    return false
  end
  if self.buffState[TorchRelayBuffState.InvincibleBeAttacked] then
    return false
  end
  if self.buffState[TorchRelayBuffState.Defend] then
    self.buffState[TorchRelayBuffState.Defend] = nil
    self:OnRemoveBuff(TorchRelayBuffState.Defend)
    return false
  end
  local subStrength = propsData.subStrength
  self:SubStamina(subStrength)
  self.buffState[TorchRelayBuffState.InvincibleBeAttacked] = {
    durationEnd = Time.time + TorchConstant.PLAYER_BE_ATTACKED_INVINCIBLE_DURATION
  }
  self:ShowBuffEffect(TorchRelayBuffState.InvincibleBeAttacked)
  self:ShowFlyItem(TorchConstant.PLAYER_FLY_ITEM_STAMINA_ICON, "-" .. tostring(propsData.subStrength))
  return true
end

function TorchRelayBattlePlayer:OnAddNewInvincibleBuff()
  self:PlayAddInvincibleBuffAni()
  self:PlayAddInvincibleBuffEffect()
  self:PlayAddInvincibleBuffSceneEffect()
end

function TorchRelayBattlePlayer:OnAddBuff(buffState, propsData)
  self:EatBuffRecord(propsData.configId)
  self:ShowEffectOnAddBuff()
  self:ShowAnimationOnAddBuff()
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_goal_achieved)
end

function TorchRelayBattlePlayer:OnRemoveBuff(buffState)
  self:HideBuffEffect(buffState)
  self.logic:HideBuffStateUI(buffState)
end

function TorchRelayBattlePlayer:RemoveAllBuff()
  for k, v in pairs(self.buffState) do
    self.buffState[k] = nil
    self:OnRemoveBuff(k)
  end
  self:ResetMainPlayerColor()
end

function TorchRelayBattlePlayer:HasBuff(state)
  return self.buffState and self.buffState[state]
end

function TorchRelayBattlePlayer:ShowEffectOnAddBuff()
  if not self.addBuffEffectReq then
    self.addBuffEffectReq = CS.GameEntry.Resource:InstantiateAsync(EffectAssets.TorchRelayAddBuffEffect)
    self.addBuffEffectReq:completed("+", function()
      local buffEffectObj = self.addBuffEffectReq.gameObject
      buffEffectObj.transform:SetParent(self.transform)
      buffEffectObj.transform:Set_localPosition(0, 0.55, 0)
      buffEffectObj.transform:Set_localScale(1, 1, 1)
      buffEffectObj:SetActive(true)
      self:ShowEffectOnAddBuff()
    end)
  elseif self.addBuffEffectReq.isDone then
    if not self.addBuffEffectCpts then
      self.addBuffEffectCpts = self.addBuffEffectReq.gameObject.transform:GetComponentsInChildren(typeof(CS.UnityEngine.ParticleSystem))
    end
    if not IsNull(self.addBuffEffectCpts) then
      for i = 0, self.addBuffEffectCpts.Length - 1 do
        self.addBuffEffectCpts[i]:Play()
      end
    end
  end
end

function TorchRelayBattlePlayer:ShowEffectOnAddStrength(propsData)
  if not self.addStrengthEffectReq then
    local resId = propsData.config.resource_id
    local resConfig = DataCenter.TorchRelayTemplateManager:GetStageResourceTemplate(resId)
    self.addStrengthEffectReq = CS.GameEntry.Resource:InstantiateAsync(resConfig.triiger_effect_resource)
    self.addStrengthEffectReq:completed("+", function()
      local buffEffectObj = self.addStrengthEffectReq.gameObject
      buffEffectObj.transform:SetParent(self.transform)
      buffEffectObj.transform:Set_localPosition(0, 0.55, 0)
      buffEffectObj.transform:Set_localScale(1, 1, 1)
      buffEffectObj:SetActive(true)
      self:ShowEffectOnAddStrength(propsData)
    end)
  elseif self.addStrengthEffectReq.isDone then
    if not self.addStrengthEffectCpts then
      self.addStrengthEffectCpts = self.addStrengthEffectReq.gameObject.transform:GetComponentsInChildren(typeof(CS.UnityEngine.ParticleSystem))
    end
    if not IsNull(self.addStrengthEffectCpts) then
      for i = 0, self.addStrengthEffectCpts.Length - 1 do
        self.addStrengthEffectCpts[i]:Play()
      end
    end
  end
end

function TorchRelayBattlePlayer:ShowAnimationOnAddBuff()
  if self:HasBuff(TorchRelayBuffState.Invincible) then
    self:ShowAddBuffAniOnInvincible()
  else
    self:ShowAddBuffAniOnNormal()
  end
end

function TorchRelayBattlePlayer:PlayAddInvincibleBuffAni()
  if self.playerAddInvincibleBuffSeq ~= nil then
    return
  end
  if self.playerScaleAniSequence ~= nil then
    self.playerScaleAniSequence:Kill()
  end
  local sequence = CS.DG.Tweening.DOTween.Sequence()
  self.playerAddInvincibleBuffSeq = sequence
  sequence:Append(DOTween.To(function(x)
    self.transform:Set_localScale(x, x, x)
  end, TorchConstant.RUNNING_MAN_NORMAL_SCALE, TorchConstant.RUNNING_MAN_INVINCIBLE_NORMAL_SCALE, TorchConstant.RUNNING_MAN_INVINCIBLE_ADD_ANI_TIME):SetEase(CS.DG.Tweening.Ease.InOutQuad))
  sequence:AppendCallback(function()
    self:ShowHighLight()
    self.playerAddInvincibleBuffSeq:Kill()
    self.playerAddInvincibleBuffSeq = nil
  end)
end

function TorchRelayBattlePlayer:PlayAddInvincibleBuffEffect()
  if not self.invincibleSpecialEffectReq then
    local path = self.logic.data.stage:GetInvincibleSpecialEffectResPath()
    if string.IsNullOrEmpty(path) then
      return
    end
    self.invincibleSpecialEffectReq = CS.GameEntry.Resource:InstantiateAsync(path)
    self.invincibleSpecialEffectReq:completed("+", function()
      local buffEffectObj = self.invincibleSpecialEffectReq.gameObject
      buffEffectObj.transform:SetParent(self.transform)
      buffEffectObj.transform:Set_localPosition(0, 0.55, 0)
      buffEffectObj.transform:Set_localScale(1, 1, 1)
      buffEffectObj:SetActive(true)
      self:ShowEffectOnAddBuff()
    end)
  elseif self.invincibleSpecialEffectReq.isDone then
    if not self.invincibleSpecialEffectCpts then
      self.invincibleSpecialEffectCpts = self.invincibleSpecialEffectReq.gameObject.transform:GetComponentsInChildren(typeof(CS.UnityEngine.ParticleSystem))
    end
    if not IsNull(self.invincibleSpecialEffectCpts) then
      for i = 0, self.invincibleSpecialEffectCpts.Length - 1 do
        self.invincibleSpecialEffectCpts[i]:Play()
      end
    end
  end
end

function TorchRelayBattlePlayer:PlayAddInvincibleBuffSceneEffect()
  if not self.invincibleSpecialEffectSceneReq then
    local path = self.logic.data.stage:GetInvincibleSceneEffectResPath()
    if string.IsNullOrEmpty(path) then
      return
    end
    self.invincibleSpecialEffectSceneReq = CS.GameEntry.Resource:InstantiateAsync(path)
    self.invincibleSpecialEffectSceneReq:completed("+", function()
      local buffEffectObj = self.invincibleSpecialEffectSceneReq.gameObject
      local x, y, z = self.transform:Get_localPosition()
      buffEffectObj.transform:Set_localPosition(TorchConstant.SCENE_CENTER_X, y, z)
      buffEffectObj.transform:Set_localScale(1, 1, 1)
      buffEffectObj:SetActive(true)
    end)
  elseif self.invincibleSpecialEffectSceneReq.isDone then
    local buffEffectObj = self.invincibleSpecialEffectSceneReq.gameObject
    local x, y, z = self.transform:Get_localPosition()
    buffEffectObj.transform:Set_localPosition(TorchConstant.SCENE_CENTER_X, y, z)
    if not self.invincibleSpecialEffectSceneCpts then
      self.invincibleSpecialEffectSceneCpts = self.invincibleSpecialEffectSceneReq.gameObject.transform:GetComponentsInChildren(typeof(CS.UnityEngine.ParticleSystem))
    end
    if not IsNull(self.invincibleSpecialEffectSceneCpts) then
      for i = 0, self.invincibleSpecialEffectSceneCpts.Length - 1 do
        self.invincibleSpecialEffectSceneCpts[i]:Play()
      end
    end
  end
end

function TorchRelayBattlePlayer:PlayRemoveInvincibleBuffAni()
  if self.playerRemoveInvincibleBuffSeq ~= nil then
    return
  end
  if self.playerScaleAniSequence ~= nil then
    self.playerScaleAniSequence:Kill()
  end
  local sequence = CS.DG.Tweening.DOTween.Sequence()
  self.playerRemoveInvincibleBuffSeq = sequence
  sequence:Append(DOTween.To(function(x)
    self.transform:Set_localScale(x, x, x)
  end, TorchConstant.RUNNING_MAN_INVINCIBLE_NORMAL_SCALE, TorchConstant.RUNNING_MAN_NORMAL_SCALE, TorchConstant.RUNNING_MAN_INVINCIBLE_REMOVE_ANI_TIME):SetEase(CS.DG.Tweening.Ease.InOutQuad))
  sequence:AppendCallback(function()
    self:HideHighLight()
    self.playerRemoveInvincibleBuffSeq:Kill()
    self.playerRemoveInvincibleBuffSeq = nil
  end)
end

function TorchRelayBattlePlayer:ShowAddBuffAniOnNormal()
  if self.playerRemoveInvincibleBuffSeq then
    return
  end
  if self.playerScaleAniSequence ~= nil then
    self.playerScaleAniSequence:Kill()
  end
  self.transform:Set_localScale(TorchConstant.RUNNING_MAN_NORMAL_SCALE, TorchConstant.RUNNING_MAN_NORMAL_SCALE, TorchConstant.RUNNING_MAN_NORMAL_SCALE)
  self:ShowHighLight()
  local sequence = CS.DG.Tweening.DOTween.Sequence()
  sequence:Join(self.transform:DOScale(Vector3.New(TorchConstant.RUNNING_MAN_NORMAL_SCALE_ADD_BUFF, TorchConstant.RUNNING_MAN_NORMAL_SCALE_ADD_BUFF, TorchConstant.RUNNING_MAN_NORMAL_SCALE_ADD_BUFF), 0.1):SetEase(CS.DG.Tweening.Ease.InOutQuad))
  sequence:Join(self.transform:DOScale(Vector3.New(TorchConstant.RUNNING_MAN_NORMAL_SCALE, TorchConstant.RUNNING_MAN_NORMAL_SCALE, TorchConstant.RUNNING_MAN_NORMAL_SCALE), 0.1):SetDelay(0.1):SetEase(CS.DG.Tweening.Ease.InOutQuad))
  sequence:AppendInterval(0.2)
  sequence:AppendCallback(function()
    self.transform:Set_localScale(TorchConstant.RUNNING_MAN_NORMAL_SCALE, TorchConstant.RUNNING_MAN_NORMAL_SCALE, TorchConstant.RUNNING_MAN_NORMAL_SCALE)
    self:HideHighLight()
    sequence:Kill()
  end)
  self.playerScaleAniSequence = sequence
end

function TorchRelayBattlePlayer:ShowAddBuffAniOnInvincible()
  if self.playerAddInvincibleBuffSeq then
    return
  end
  if self.playerScaleAniSequence ~= nil then
    self.playerScaleAniSequence:Kill()
  end
  self.transform:Set_localScale(TorchConstant.RUNNING_MAN_INVINCIBLE_NORMAL_SCALE, TorchConstant.RUNNING_MAN_INVINCIBLE_NORMAL_SCALE, TorchConstant.RUNNING_MAN_INVINCIBLE_NORMAL_SCALE)
  local sequence = CS.DG.Tweening.DOTween.Sequence()
  sequence:Join(self.transform:DOScale(Vector3.New(TorchConstant.RUNNING_MAN_INVINCIBLE_NORMAL_SCALE, TorchConstant.RUNNING_MAN_INVINCIBLE_NORMAL_SCALE, TorchConstant.RUNNING_MAN_INVINCIBLE_NORMAL_SCALE), 0.1):SetEase(CS.DG.Tweening.Ease.InOutQuad))
  sequence:Join(self.transform:DOScale(Vector3.New(TorchConstant.RUNNING_MAN_INVINCIBLE_SCALE_ADD_BUFF, TorchConstant.RUNNING_MAN_INVINCIBLE_SCALE_ADD_BUFF, TorchConstant.RUNNING_MAN_INVINCIBLE_SCALE_ADD_BUFF), 0.1):SetDelay(0.1):SetEase(CS.DG.Tweening.Ease.InOutQuad))
  sequence:AppendInterval(0.2)
  sequence:AppendCallback(function()
    self.transform:Set_localScale(TorchConstant.RUNNING_MAN_INVINCIBLE_NORMAL_SCALE, TorchConstant.RUNNING_MAN_INVINCIBLE_NORMAL_SCALE, TorchConstant.RUNNING_MAN_INVINCIBLE_NORMAL_SCALE)
    sequence:Kill()
  end)
  self.playerScaleAniSequence = sequence
end

function TorchRelayBattlePlayer:ShowBuffEffect(buffState, propsData)
  if buffState == TorchRelayBuffState.InvincibleBeAttacked then
    self:ShowBeAttackAni()
    return
  end
  local buffEffectObj = self.buffStateEffectMap[buffState]
  if not buffEffectObj then
    if self.buffStateEffectHandle[buffState] and self.buffStateEffectHandle[buffState].isDone == false then
      return
    end
    local resId = propsData.config.resource_id
    local resConfig = DataCenter.TorchRelayTemplateManager:GetStageResourceTemplate(resId)
    self.buffStateEffectHandle[buffState] = CS.GameEntry.Resource:InstantiateAsync(resConfig.triiger_effect_resource)
    self.buffStateEffectHandle[buffState]:completed("+", function()
      buffEffectObj = self.buffStateEffectHandle[buffState].gameObject
      if buffEffectObj == nil then
        self.logic:PrintRealErrorLog("load buff nil!  buffState:" .. tostring(buffState) .. "  resId:" .. tostring(resId) .. "  path:" .. tostring(resConfig.triiger_effect_resource))
        return
      end
      buffEffectObj.transform:SetParent(self.transform)
      buffEffectObj.transform:Set_localPosition(0, 0, 0)
      buffEffectObj.transform:Set_localScale(1, 1, 1)
      buffEffectObj:SetActive(true)
      self.buffStateEffectMap[buffState] = buffEffectObj
    end)
  else
    buffEffectObj:SetActive(true)
  end
end

function TorchRelayBattlePlayer:HideBuffEffect(buffState)
  if buffState == TorchRelayBuffState.InvincibleBeAttacked then
    self:HideBeAttackAni()
    return
  end
  if buffState == TorchRelayBuffState.Invincible then
    self:PlayRemoveInvincibleBuffAni()
  end
  if self.buffStateEffectMap[buffState] then
    self.buffStateEffectMap[buffState]:SetActive(false)
  end
end

function TorchRelayBattlePlayer:ShowBeAttackAni()
  if not IsNull(self.anim) then
    if self.anim:IsPlaying(self.Anim.Hit) then
      self.anim:Rewind(self.Anim.Hit)
    else
      self.anim:Play(self.Anim.Hit)
    end
    self.anim:PlayQueued(self.Anim.Run01)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_soldier_shout_02)
  end
end

function TorchRelayBattlePlayer:HideBeAttackAni()
end

function TorchRelayBattlePlayer:PlayAnim(anim)
  if not IsNull(self.anim) then
    self.anim:Play(anim)
  end
end

function TorchRelayBattlePlayer:OnAutoCollectBuffDoing()
  local buffData = self.buffState[TorchRelayBuffState.AutoCollect]
  
  local function func_SetPropsFollow(list)
    if not list then
      return
    end
    for i, v in ipairs(list) do
      if v and v.active then
        local distance = v.transform.position.z - self.transform.position.z
        if 0 < distance and distance <= buffData.bound.maxZ and v.transform.position.y < buffData.bound.maxY then
          v:SetFollowPlayer(true)
        end
      end
    end
  end
  
  local curScenePropsList = self.logic.curScene:GetScenePropsListByType(TorchRelayScenePropsMainType.Buff)
  func_SetPropsFollow(curScenePropsList)
  local nextScene = self.logic.curScene:GetNextScene()
  if nextScene then
    local nextScenePropsList = nextScene:GetScenePropsListByType(TorchRelayScenePropsMainType.Buff)
    func_SetPropsFollow(nextScenePropsList)
  end
end

function TorchRelayBattlePlayer:OnUpdateInvincibleBeAttacked(deltaTime)
  if not self.renders or not self.MPB then
    return
  end
  local durationEnd = self.buffState[TorchRelayBuffState.InvincibleBeAttacked].durationEnd
  local color = self.MPB:GetColor("_BaseColor")
  if durationEnd - Time.time <= TorchConstant.PLAYER_BE_ATTACKED_INVINCIBLE_DURATION * 0.5 then
    color.g = color.g + TorchConstant.PLAYER_BE_ATTACKED_INVINCIBLE_EFFECT_CHANGE_PER_SECOND * deltaTime
    color.b = color.b + TorchConstant.PLAYER_BE_ATTACKED_INVINCIBLE_EFFECT_CHANGE_PER_SECOND * deltaTime
  else
    color.g = color.g - TorchConstant.PLAYER_BE_ATTACKED_INVINCIBLE_EFFECT_CHANGE_PER_SECOND * deltaTime
    color.b = color.b - TorchConstant.PLAYER_BE_ATTACKED_INVINCIBLE_EFFECT_CHANGE_PER_SECOND * deltaTime
  end
  self.MPB:SetColor("_BaseColor", color)
  for _, v in ipairs(self.renders) do
    v:SetPropertyBlock(self.MPB)
  end
end

function TorchRelayBattlePlayer:ShowHighLight()
  if self.renders and self.MPB then
    self.MPB:SetFloat("_USERIM", 1)
    for _, v in ipairs(self.renders) do
      v:SetPropertyBlock(self.MPB)
    end
  end
end

function TorchRelayBattlePlayer:HideHighLight()
  if self.renders and self.MPB then
    self.MPB:SetFloat("_USERIM", 0)
    for _, v in ipairs(self.renders) do
      v:SetPropertyBlock(nil)
    end
  end
end

function TorchRelayBattlePlayer:ResetMainPlayerColor()
  if self.MPB then
    self.MPB:SetColor("_BaseColor", Color.New(1, 1, 1, 1))
  end
end

function TorchRelayBattlePlayer:EatObstacleRecord(obstaclesId)
end

function TorchRelayBattlePlayer:EatBuffRecord(buffId)
end

function TorchRelayBattlePlayer:ClearMPB()
  if self.renders and self.MPB then
    self.MPB:SetFloat("_USERIM", 0)
    self.MPB:SetColor("_BaseColor", Color.New(1, 1, 1, 1))
    for _, v in ipairs(self.renders) do
      v:SetPropertyBlock(nil)
    end
  end
  self.renders = nil
  self.MPB = nil
end

function TorchRelayBattlePlayer:InitFlyItemAsset()
  self.reqFlyItem = Resource:InstantiateAsync(TorchConstant.PLAYER_FLY_ITEM_ASSET)
  self.reqFlyItem:completed("+", function(handle)
    if self.reqFlyItem.isError or not self.transform then
      self.reqFlyItem:Destroy()
      return
    end
    local gameObject = handle.gameObject
    local transform = handle.gameObject.transform
    transform:SetParent(self.transform, false)
    transform:Set_localPosition((Vector3.zero + Vector3.up * 2.3):Split())
    transform:Set_localScale(0.7, 0.7, 0.7)
    gameObject:SetActive(false)
    self.goFlyItem = gameObject
    self.transFlyItem = transform
    self.textFlyItem = transform:Find("num"):GetComponent(typeof(CS.SuperTextMesh))
    self.spriteFlyItem = transform:Find("num/icon"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  end)
end

local hpBarSize = CS.UnityEngine.Vector2(0, 0)

function TorchRelayBattlePlayer:InitHpBar()
  self.reqHpBar = Resource:InstantiateAsync(TorchConstant.PLAYER_HP_BAR_ASSET)
  self.reqHpBar:completed("+", function(handle)
    if self.reqHpBar.isError or not self.transform then
      self.reqHpBar:Destroy()
      return
    end
    local gameObject = handle.gameObject
    local transform = handle.gameObject.transform
    transform:SetParent(self.transform, false)
    transform:Set_localPosition((Vector3.zero + Vector3.up * 2.8):Split())
    transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    gameObject:SetActive(true)
    self.goHpBar = gameObject
    self.spriteHpBar = transform:Find("HPBar/Slider"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
    self.hpBarWidth = TorchConstant.PLAYER_HP_BAR_WIDTH
    hpBarSize.y = self.spriteHpBar.size.y
    self:UpdateHpBar()
  end)
end

function TorchRelayBattlePlayer:HideHpBar()
  if not IsNull(self.goHpBar) then
    self.goHpBar:SetActive(false)
  end
end

function TorchRelayBattlePlayer:UpdateHpBar()
  local percent = 1
  if self.staminaMax and self.staminaMax > 0 then
    percent = self:GetStamina() / self.staminaMax
  end
  if self.spriteHpBar and self.hpBarWidth then
    local tw = self.hpBarWidth * percent
    local tXOffset = (self.hpBarWidth - tw) / 2
    hpBarSize.x = tw
    self.spriteHpBar.size = hpBarSize
    self.spriteHpBar.transform:Set_localPosition(-tXOffset, 0, 0)
  end
end

function TorchRelayBattlePlayer:ShowFlyItem(iconPath, showText)
  if IsNull(self.goFlyItem) or IsNull(self.textFlyItem) or IsNull(self.spriteFlyItem) then
    if self.logic then
      self.logic:PrintRealErrorLog("show fly item when obj is null")
    end
    return
  end
  self.textFlyItem.text = showText
  self.spriteFlyItem:LoadSprite(iconPath)
  self.goFlyItem:SetActive(false)
  self.goFlyItem:SetActive(true)
  if string.contains(showText, "+") then
    self.textFlyItem.color32 = Color32.New(0, 255, 0, 255)
  elseif string.contains(showText, "-") then
    self.textFlyItem.color32 = Color32.New(255, 0, 0, 255)
  end
end

function TorchRelayBattlePlayer:PlayTransferAnim()
  if self.transPlayer then
    self.transPlayer.rotation = Quaternion.Euler(0, 90, 0)
  end
  if self.anim then
    self.anim:Play("Transfer01")
  end
end

return TorchRelayBattlePlayer
