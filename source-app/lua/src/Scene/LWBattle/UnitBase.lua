local UnitBase = BaseClass("UnitBase")
local BuffManager = require("Scene.LWBattle.Buff.BuffManager")
local Resource = CS.GameEntry.Resource
local TINY_VECTOR = Vector3.New(0, 0, 0.001)
local DEATH_BLOOD_TIME = 2.5
local Localization = CS.GameEntry.Localization
local Time = _ENV.Time
local BattleColliderUtils = CS.BattleColliderUtils
local UnitViewFacade = CS.PVEBattleLogic.Unit.UnitViewFacade
local AppearenceUtils = CS.AppearenceUtils

function UnitBase:Init(logic)
  self.buffManager = nil
  self.buffManagerValid = false
  self.renders = {}
  self.maxBlood = 0
  self.curBlood = 0
  if not self.curWorldPos then
    self.curWorldPos = Vector3.zero
  end
  self.invincible = false
  self.logic = logic
  self.morgueDuration = 0
  self.stealth = false
  self.playingPosTimeline = false
  self.hasPosTimelineTarget = false
  self.searchType = BattleSearchType.None
  self.effectMap = {}
  self.flashCountdownValid = false
  self.playHitEffectOnHitPoint = false
  if self.logic and self.logic.battleMgr and self.logic.battleMgr.GetCurBattleType then
    local curPVEType = self.logic.battleMgr:GetCurBattleType()
    self.isPVP = PVPType[curPVEType]
  end
end

function UnitBase:DestroyView()
  for _, v in pairs(self.renders) do
    if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
      AppearenceUtils.HitWhiteV2(v.renderer, false, true)
    end
    UnitViewFacade.ReplaceMaterialReset(v.renderer, v.defaultMat)
  end
  self.renders = {}
  self:EnableCollider(true)
  self.collider = nil
  if not IsNull(self.transform) then
    self.curWorldPos.x, self.curWorldPos.y, self.curWorldPos.z = self.transform:Get_position()
  end
  self.tauntTarget = nil
  self.flashCountdown = nil
  self.flashCountdownValid = false
  self.curBlood = 0
  self.playingPosTimeline = false
  self.posTimelineTarget = nil
  self.hasPosTimelineTarget = false
  self.effectMap = {}
  self.playHitEffectOnHitPoint = nil
end

function UnitBase:DestroyData()
  self.logic = nil
  self.meta = nil
  self.heroEffectMeta = nil
  self:RemoveBuffManager()
  self.curAnimName = nil
  self.name = nil
  self.guid = nil
  self.unitType = nil
  self.invincible = nil
  self.maxBlood = 0
  self.stealth = false
  self.searchType = BattleSearchType.None
  self.propCache = nil
  self.propFrame = nil
end

function UnitBase:OnUpdate(deltaTime)
  self.afterBeAttackDone = false
  self:UpdateBuffManager()
  self:UpdateFlashCountdown(deltaTime)
  if self.hasPosTimelineTarget or self.playingPosTimeline then
    self:UpdatePosTimeLine(deltaTime)
  end
end

function UnitBase:UpdateFlashCountdown(deltaTime)
  if self.flashCountdownValid then
    self.flashCountdown = self.flashCountdown - deltaTime
    if self.flashCountdown < 0 then
      self.flashCountdown = nil
      self.flashCountdownValid = false
      self:HitWhiteReset()
    end
  end
end

function UnitBase:FinishFlashCountdown(unReset)
  if self.flashCountdownValid then
    self.flashCountdown = nil
    self.flashCountdownValid = false
    if not unReset then
      self:HitWhiteReset()
    end
  end
end

function UnitBase:ComponentDefine()
  self.name = UnitType2String[self.unitType] or "" .. self.guid
  self.renders = {}
  local skinnedMeshRenderer = self.gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.SkinnedMeshRenderer))
  local meshRenderer = self.gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.MeshRenderer))
  for i = 0, skinnedMeshRenderer.Length - 1 do
    self.renders[i + 1] = {
      renderer = skinnedMeshRenderer[i],
      defaultMat = skinnedMeshRenderer[i].sharedMaterial
    }
  end
  local count = #self.renders
  for i = 0, meshRenderer.Length - 1 do
    if not string.find(meshRenderer[i].gameObject.name, "shadow", 1, true) and not string.find(meshRenderer[i].gameObject.name, "platform", 1, true) and meshRenderer[i].gameObject.name ~= "HpText" then
      self.renders[i + 1 + count] = {
        renderer = meshRenderer[i],
        defaultMat = meshRenderer[i].sharedMaterial
      }
    end
  end
  local trigger = self.gameObject:GetComponentInChildren(typeof(CS.CitySpaceManTrigger))
  if trigger then
    trigger.ObjectId = self.guid
  else
    Logger.LogError("\232\175\165\229\141\149\228\189\141\230\160\185\232\138\130\231\130\185\230\178\161\230\140\130CitySpaceManTrigger\232\132\154\230\156\172:" .. self.gameObject.name)
  end
  self.collider = self.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Collider))
  self.playingPosTimeline = false
  self.getPosCurFrame = 0
end

function UnitBase:ComponentDefineWithoutView()
  self.name = UnitType2String[self.unitType] or "" .. self.guid
  self.playingPosTimeline = false
  self.getPosCurFrame = 0
  self.anim = UnitViewFacade.GetSimpleAnimation(self.viewHandle)
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    if nil == self.animLengthCache then
      self.animLengthCache = {}
    end
    table.clear(self.animLengthCache)
    if nil == self.animNameCache then
      self.animNameCache = {}
    end
    table.clear(self.animNameCache)
  end
end

function UnitBase:BeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff)
end

local function TryReplayEffect(self, path, time)
  if self.effectMap[path] and self.logic.IsEffectValid then
    if self.logic:IsEffectValid(self.effectMap[path]) and self.logic.ReplayEffect then
      self.logic:ReplayEffect(self.effectMap[path], time)
      return true
    else
      self.effectMap[path] = nil
    end
  end
  return false
end

local function PlayReplayableEffect(self, path, pos, rot, time, transform, type)
  if not string.IsNullOrEmpty(path) and not TryReplayEffect(self, path, time) then
    local id = self.logic:ShowEffectObj(path, pos, rot, time, transform, type)
    if id then
      self.effectMap[path] = id
    end
  end
end

function UnitBase:AfterBeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, skill, deathEff)
  if self.curBlood <= 0 then
    self:RemoveAllBuff()
    if self.skillManager then
      self.skillManager:Interrupt()
    end
    self:EnableCollider(false)
  end
  if skill and self.curBlood > 0 then
    skill:DealBulletBuff(self)
  end
  self:TryHitWhite(whiteTime)
  if (self.logic.highQualityMode == nil or self.logic.highQualityMode == true) and not string.IsNullOrEmpty(hitEff) then
    if self.viewHandle and self.logic.ShowHitEffectForViewTarget then
      self.logic:ShowHitEffectForViewTarget(hitEff, hitPoint, nil, nil, nil, self.viewHandle, nil, true)
    elseif self.transform then
      local localPos = BattleColliderUtils.GetInverseTransformPoint(self.transform, hitPoint.x, hitPoint.y, hitPoint.z)
      PlayReplayableEffect(self, hitEff, localPos, nil, nil, self.transform)
    end
  end
  if self.heroEffectMeta then
    local effectMeta = self.heroEffectMeta
    if (self.logic.lowQualityMode == nil or self.logic.lowQualityMode == false) and not string.IsNullOrEmpty(effectMeta.hit_effect) then
      ProfilerUtil.BeginSample("AfterBeAttackHitEffect")
      if self.viewHandle and self.logic.ShowHitEffectForViewTarget then
        local hitEffectLimitNum = effectMeta.hit_effect_num
        if hitDir and effectMeta.hit_effect_direction == 0 then
          hitDir = nil
        end
        if hitEffectLimitNum <= 0 then
          self.logic:ShowHitEffectForViewTarget(effectMeta.hit_effect, nil, hitDir, effectMeta.hit_effect_direction or 2, nil, self.viewHandle)
        else
          local finalHitPoint = self.playHitEffectOnHitPoint and hitPoint or nil
          self.logic:ShowHitEffectForViewTarget(effectMeta.hit_effect, finalHitPoint, hitDir, effectMeta.hit_effect_direction or 2, nil, self.viewHandle, hitEffectLimitNum)
        end
      elseif self.transform then
        local quaternion
        if hitDir then
          if Vector3.SqrMagnitude(hitDir) < 1.0E-8 then
            hitDir = TINY_VECTOR
          end
          if effectMeta.hit_effect_direction == 1 then
            quaternion = Quaternion.LookRotation(hitDir)
          elseif effectMeta.hit_effect_direction == 2 then
            quaternion = Quaternion.LookRotation(-hitDir)
          end
        end
        PlayReplayableEffect(self, effectMeta.hit_effect, nil, quaternion, nil, self.transform)
      end
      ProfilerUtil.EndSample()
    end
    if self.curBlood <= 0 then
      ProfilerUtil.BeginSample("AfterBeAttackDeadEffect")
      if not string.IsNullOrEmpty(deathEff) then
        PlayReplayableEffect(self, deathEff, hitPoint, nil, nil)
      elseif not string.IsNullOrEmpty(effectMeta.death_effect_nomal) then
        local targetPos = hitPoint
        local useSelfCurWorldPos = effectMeta.death_pos == 1
        if useSelfCurWorldPos then
          if self.useColliderPos and self.GetColliderPos then
            targetPos = self:GetColliderPos()
          else
            targetPos = self.curWorldPos
          end
        end
        local rot
        if self.GetDeadEffectRotation then
          rot = self:GetDeadEffectRotation()
        end
        PlayReplayableEffect(self, effectMeta.death_effect_nomal, targetPos, rot, nil)
      end
      ProfilerUtil.EndSample()
      if 0 < effectMeta.sound_id_dead then
        ProfilerUtil.BeginSample("AfterBeAttackDeadSound")
        DataCenter.LWSoundManager:PlaySoundWithLimit(effectMeta.sound_id_dead, SoundLimitType.UnitDeath)
        ProfilerUtil.EndSample()
      end
      local bloodEffect = effectMeta:GetRandomBlood()
      if bloodEffect then
        ProfilerUtil.BeginSample("AfterBeAttackDeadBlood")
        PlayReplayableEffect(self, bloodEffect, self:GetPosition(), nil, DEATH_BLOOD_TIME, nil, EffectObjType.Sprite)
        ProfilerUtil.EndSample()
      end
      if effectMeta.deathShakeParam then
        ProfilerUtil.BeginSample("AfterBeAttackDeadShake")
        self.logic:ShakeCameraWithParam(effectMeta.deathShakeParam)
        ProfilerUtil.EndSample()
      end
      if effectMeta.deathVibrateParam and #effectMeta.deathVibrateParam == 3 then
        ProfilerUtil.BeginSample("AfterBeAttackDeadVib")
        if self.logic.DoVibration then
          self.logic:DoVibration(effectMeta.deathVibrateParam[1], effectMeta.deathVibrateParam[2], effectMeta.deathVibrateParam[3])
        end
        ProfilerUtil.EndSample()
      end
    elseif effectMeta.hitVibrateParam and #effectMeta.hitVibrateParam == 3 and self.logic.DoVibration then
      ProfilerUtil.BeginSample("AfterBeAttackHitVib")
      self.logic:DoVibration(effectMeta.hitVibrateParam[1], effectMeta.hitVibrateParam[2], effectMeta.hitVibrateParam[3])
      ProfilerUtil.EndSample()
    end
  end
end

function UnitBase:TryHitWhite(whiteTime)
  if whiteTime and 0 < whiteTime and 0 < self.curBlood then
    if not self.flashCountdownValid then
      self:HitWhite()
    end
    self.flashCountdown = whiteTime
    self.flashCountdownValid = true
  end
end

function UnitBase:HitWhite()
  if self.isPVP then
    return
  end
  if self.unitType == UnitType.Member then
    if self.viewHandle then
      UnitViewFacade.MPBFlashRed(self.viewHandle)
    elseif DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
      if self.logic.GetHitWhiteMPB then
        local mpb = self.logic:GetHitWhiteMPB()
        for _, v in pairs(self.renders) do
          AppearenceUtils.HitWhiteV2(v.renderer, true, true)
        end
        return
      end
    else
      if not RedMat then
        RedMat = UnitViewFacade.GetRedMaterial()
      end
      self:Flash(RedMat)
    end
  elseif self.viewHandle then
    UnitViewFacade.ReplaceMaterialFlashWhite(self.viewHandle)
  else
    if not WhiteMat then
      WhiteMat = UnitViewFacade.GetWhiteMaterial()
    end
    self:Flash(WhiteMat)
  end
end

function UnitBase:DieGray()
end

function UnitBase:HitWhiteReset()
  if self.unitType == UnitType.Member then
    if self.viewHandle then
      UnitViewFacade.MPBResetFlashRed(self.viewHandle)
    else
      for k, v in pairs(self.renders) do
        if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
          AppearenceUtils.HitWhiteV2(v.renderer, false, true)
        else
          UnitViewFacade.ReplaceMaterialReset(v.renderer, v.defaultMat)
        end
      end
    end
  elseif self.viewHandle then
    UnitViewFacade.ReplaceMaterialReset(self.viewHandle)
  else
    for k, v in pairs(self.renders) do
      UnitViewFacade.ReplaceMaterialReset(v.renderer, v.defaultMat)
    end
  end
end

function UnitBase:Flash(color, time, prior)
  for k, v in pairs(self.renders) do
    UnitViewFacade.ReplaceMaterial(v.renderer, color)
  end
end

function UnitBase:ShowFrozen()
end

function UnitBase:HideFrozen()
end

local function CheckAnimName(self, anim, name, cache)
  local animName = name
  if anim == nil or animName == nil then
    return nil
  end
  if animName == AnimName.Idle and self.idleAnimName ~= nil then
    animName = self.idleAnimName
  end
  if cache and cache[animName] then
    return cache[animName]
  end
  local retName
  local state = anim:GetState(animName)
  if state ~= nil then
    retName = animName
  end
  if nil == state then
    if animName == "death" then
      state = anim:GetState("dead")
      if state ~= nil then
        retName = "dead"
      end
    end
    if animName == "dead" then
      state = anim:GetState("death")
      if state ~= nil then
        retName = "death"
      end
    end
  end
  if cache then
    cache[animName] = retName
  end
  return retName
end

function UnitBase:PlaySimpleAnim(name, speed)
  if self.anim then
    local theAnimName
    if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
      theAnimName = CheckAnimName(self, self.anim, name, self.animNameCache)
    else
      theAnimName = CheckAnimName(self, self.anim, name)
    end
    if theAnimName == nil then
      return
    end
    self.curAnimName = theAnimName
    self.anim:Play(theAnimName)
    if speed then
      self.anim:SetStateSpeed(theAnimName, speed)
    end
  end
end

function UnitBase:SampleAnim()
  if self.anim then
    self.anim:Sample()
  end
end

function UnitBase:GetState(name)
  if self.anim then
    return self.anim:GetState(name)
  end
end

function UnitBase:RewindAndPlaySimpleAnim(name, speed)
  if self.anim then
    local theAnimName
    if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
      theAnimName = CheckAnimName(self, self.anim, name, self.animNameCache)
    else
      theAnimName = CheckAnimName(self, self.anim, name)
    end
    if theAnimName == nil then
      return
    end
    self.curAnimName = theAnimName
    self.anim:RewindAndPlay(theAnimName)
    if speed then
      self.anim:SetStateSpeed(theAnimName, speed)
    end
  end
end

function UnitBase:CrossFadeSimpleAnim(name, speed, fadeTime)
  if self.anim then
    self.curAnimName = name
    local result = self.anim:CrossFade(name, fadeTime)
    if not result then
      local a = 1
    end
    if speed then
      self.anim:SetStateSpeed(name, speed)
    end
  end
end

function UnitBase:CrossFadeSimpleAnimSafe(name, speed, fadeTime)
  if not self.anim then
    return
  end
  if self.curAnimName == name then
    return
  end
  self.curAnimName = name
  self.anim:CrossFade(name, fadeTime)
  if speed then
    self.anim:SetStateSpeed(name, speed)
  end
end

function UnitBase:RewindSimpleAnim(name)
  if self.anim then
    local theAnimName
    if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
      theAnimName = CheckAnimName(self, self.anim, name, self.animNameCache)
    else
      theAnimName = CheckAnimName(self, self.anim, name)
    end
    if theAnimName == nil then
      return
    end
    self.anim:Rewind(theAnimName)
  end
end

function UnitBase:GetCurAnimName()
  return self.curAnimName
end

function UnitBase:GetAnimLength(name)
  if self.anim then
    if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
      if nil == self.animLengthCache then
        self.animLengthCache = {}
      end
      if self.animLengthCache[name] then
        return self.animLengthCache[name]
      end
      self.anim:SetStateSpeed(name, 1)
      local length = self.anim:GetClipLength(name)
      self.animLengthCache[name] = length
      return length
    else
      self.anim:SetStateSpeed(name, 1)
      return self.anim:GetClipLength(name)
    end
  else
    return 0
  end
end

function UnitBase:HasBuffManager()
  return self.buffManagerValid
end

function UnitBase:UpdateBuffManager()
  if self.buffManagerValid then
    self.buffManager:OnUpdate()
  end
end

function UnitBase:IsMoving()
  return false
end

function UnitBase:IsStunning()
  if self.buffManagerValid then
    return self.buffManager:HasAnyBuffWithType(BuffType.Stun)
  end
  return false
end

function UnitBase:IsImprisoning()
  if self.buffManagerValid then
    return self.buffManager:HasAnyBuffWithType(BuffType.Imprison)
  end
  return false
end

function UnitBase:IsSpecialMoving()
  if self.buffManagerValid then
    return self.buffManager:HasAnyBuffWithType(BuffType.SpecialMove)
  end
  return false
end

function UnitBase:IsFrozen()
  if self.buffManagerValid then
    return self.buffManager:HasAnyBuffWithType(BuffType.Frozen)
  end
  return false
end

function UnitBase:ForbidSkillAnim()
  return false
end

function UnitBase:GetProperty(propertyType)
  if propertyType == nil then
    return 0
  end
  if self.propFrame == nil then
    self.propFrame = {}
  end
  local curFrame = Time.frameCount
  local pFrame = self.propFrame[propertyType] or 0
  if curFrame == pFrame then
    return self.propCache[propertyType]
  end
  self.propFrame[propertyType] = curFrame
  if self.propCache == nil then
    self.propCache = {}
  end
  local originProperty = self:GetRawProperty(propertyType)
  local buffProperty = self:GetPropertyBuff(propertyType)
  local value = originProperty + buffProperty
  self.propCache[propertyType] = value
  return value
end

function UnitBase:GetPropertyBuff(propertyType)
  if self.buffManagerValid then
    return self.buffManager:GetPropertyBuff(propertyType)
  end
  return 0
end

function UnitBase:GetTypeBuffCount(subType)
  if self.buffManagerValid then
    return self.buffManager:GetTypeBuffCount(subType)
  end
  return 0
end

function UnitBase:GetSingleBuffByType(type)
  if self.buffManagerValid then
    return self.buffManager:GetSingleBuffByType(type)
  end
end

function UnitBase:GetSubTypeBuffCount(subType)
  if self.buffManagerValid then
    return self.buffManager:GetSubTypeBuffCount(subType)
  end
  return 0
end

function UnitBase:GetBuffLevel(metaId)
  if self.buffManagerValid then
    return self.buffManager:GetBuffLevel(metaId)
  end
  return 0
end

function UnitBase:GetModelScaleValue()
  if self.buffManagerValid then
    return self.buffManager:GetModelScaleValue()
  end
  return 1
end

function UnitBase:DoActionForTypeBuff(type, action)
  if self.buffManagerValid then
    self.buffManager:DoActionForTypeBuff(type, action)
    self:OnBuffPropertyDirty()
  end
end

function UnitBase:RemoveAllBuff()
  if self.buffManagerValid then
    self.buffManager:RemoveAllBuff()
    self:OnBuffPropertyDirty()
  end
end

function UnitBase:RemoveAllBuffByType(type)
  if self.buffManagerValid then
    self.buffManager:RemoveAllBuffByType(type)
    self:OnBuffPropertyDirty()
  end
end

function UnitBase:RemoveBuffManager()
  if self.buffManagerValid then
    self.buffManager:Destroy()
    self.buffManager = nil
    self.buffManagerValid = false
    self:OnBuffPropertyDirty()
  end
end

function UnitBase:AddBuff(buffMetaId, param, triggerNewBuffUpperLimit, sourceType, sourceId)
  if not self.buffManagerValid then
    self.buffManager = BuffManager.New(self.logic, self)
    self.buffManagerValid = true
  end
  self:OnBuffPropertyDirty()
  buffMetaId = tonumber(buffMetaId) or 0
  local buff = self.buffManager:AddBuff(buffMetaId, param, nil, triggerNewBuffUpperLimit, sourceType, sourceId)
  if buffMetaId and 0 < buffMetaId then
    local buffMeta = DataCenter.LWBuffTemplateManager:GetTemplate(buffMetaId)
    if buffMeta and not string.IsNullOrEmpty(buffMeta.obtain_dialog_effect) and self.logic.ShowBuffText then
      self.logic:ShowBuffText(Localization:GetString(buffMeta.obtain_dialog_effect), self:GetPosition(), buffMeta.is_debuff, buffMeta.buff_icon)
    end
  end
  return buff
end

function UnitBase:AddBuffs(buffs)
  if not buffs then
    return
  end
  if not self.buffManagerValid then
    self.buffManager = BuffManager.New(self.logic, self)
    self.buffManagerValid = true
  end
  self:OnBuffPropertyDirty()
  local buffChangeMap = {}
  for i = 1, #buffs do
    local buffData = buffs[i]
    local id = buffData.id
    local param = buffData.param
    local lv = buffData.lv or 1
    self.buffManager:AddBuff(id, param, lv)
    if not buffChangeMap[id] then
      buffChangeMap[id] = 1
    else
      buffChangeMap[id] = buffChangeMap[id] + 1
    end
  end
  for buffId, count in pairs(buffChangeMap) do
    local buffMeta = DataCenter.LWBuffTemplateManager:GetTemplate(buffId)
    if not string.IsNullOrEmpty(buffMeta.obtain_dialog_effect) and self.logic.ShowBuffText then
      local txt = ""
      if 1 < count then
        txt = string.format("%s\195\151%s", Localization:GetString(buffMeta.obtain_dialog_effect), count)
      else
        txt = Localization:GetString(buffMeta.obtain_dialog_effect)
      end
      self.logic:ShowBuffText(txt, self:GetPosition(), buffMeta.is_debuff, buffMeta.buff_icon)
    end
  end
end

function UnitBase:AddHaloBuff(skillUid, propertyDic, skillId)
  if not self.buffManagerValid then
    self.buffManager = BuffManager.New(self.logic, self)
    self.buffManagerValid = true
  end
  self.buffManager:AddHaloBuff(skillUid, propertyDic, skillId)
  self:OnBuffPropertyDirty()
end

function UnitBase:ShowOrHide(isShow)
  if self.gameObject then
    self.gameObject:SetActive(isShow)
  end
end

local function RealSetCacheWorldPos(self, x, y, z)
  if not self.curWorldPos then
    self.curWorldPos = Vector3.zero
  end
  self.curWorldPos.x = x
  self.curWorldPos.y = y
  self.curWorldPos.z = z
end

local function RealSetCacheLocalPos(self, x, y, z)
  if not self.localPosition then
    self.localPosition = Vector3.zero
  end
  self.localPosition.x = x
  self.localPosition.y = y
  self.localPosition.z = z
end

function UnitBase:GetPosition()
  local curFrame = Time.frameCount
  if self.getPosCurFrame == curFrame then
    return self.curWorldPos
  end
  self.getPosCurFrame = curFrame
  if self.transform then
    local x, y, z = self.transform:Get_position()
    RealSetCacheWorldPos(self, x, y, z)
  end
  return self.curWorldPos
end

function UnitBase:SetPosition(worldPos)
  if self.transform then
    self.transform:Set_position(worldPos.x, worldPos.y, worldPos.z)
    RealSetCacheWorldPos(self, worldPos.x, worldPos.y, worldPos.z)
    local localPosX, localPosY, localPosZ = self.transform:Get_localPosition()
    RealSetCacheLocalPos(self, localPosX, localPosY, localPosZ)
  end
end

function UnitBase:SetPositionXYZ(x, y, z)
  if self.transform then
    self.transform:Set_position(x, y, z)
    RealSetCacheWorldPos(self, x, y, z)
    local localPosX, localPosY, localPosZ = self.transform:Get_localPosition()
    RealSetCacheLocalPos(self, localPosX, localPosY, localPosZ)
  end
end

function UnitBase:GetRotationXYZW()
  if self.transform then
    return self.transform:Get_rotation()
  end
  return 0, 0, 0, 1
end

function UnitBase:GetLocalPosition()
  if not self.localPosition and self.transform then
    local x, y, z = self.transform:Get_localPosition()
    RealSetCacheLocalPos(self, x, y, z)
  end
  return self.localPosition or Vector3.zero
end

function UnitBase:SetLocalPosition(localPos)
  if self.transform then
    self.transform:Set_localPosition(localPos.x, localPos.y, localPos.z)
    RealSetCacheLocalPos(self, localPos.x, localPos.y, localPos.z)
    local worldPosX, worldPosY, worldPosZ = self.transform:Get_position()
    RealSetCacheWorldPos(self, worldPosX, worldPosY, worldPosZ)
  end
end

function UnitBase:GetTransform()
  return self.transform
end

function UnitBase:GetBuffTransform(index)
  index = index or 1
  if not table.IsNullOrEmpty(self.buffPoints) then
    local buffPoint = self.buffPoints[index]
    if IsNull(buffPoint) then
      local defaultBuffPoint = self.buffPoints[1]
      if not IsNull(defaultBuffPoint) then
        return defaultBuffPoint
      end
    else
      return buffPoint
    end
  end
  return self:GetTransform()
end

function UnitBase:GetGameObject()
  return self.gameObject
end

function UnitBase:GetMoveVelocity()
  return Vector3.zero
end

function UnitBase:GetCurBlood()
  return self.curBlood
end

function UnitBase:GetMaxBlood()
  return self.maxBlood
end

function UnitBase:GetLocationType()
  return LocationType.None
end

function UnitBase:GetGuid()
  return self.guid
end

function UnitBase:GetTauntTarget()
  return self.tauntTarget
end

function UnitBase:SetTauntTarget(target)
  self.tauntTarget = target
end

function UnitBase:GetCollider()
  if self.viewHandle then
    return UnitViewFacade.GetCollider(self.viewHandle)
  end
  return self.collider
end

function UnitBase:EnableCollider(isEnable)
  if self.viewHandle then
    UnitViewFacade.EnableCollider(self.viewHandle, isEnable)
    return
  end
  if self.collider then
    self.collider.enabled = isEnable
  end
end

function UnitBase:SetInvincible(bool)
  self.invincible = bool
end

function UnitBase:GetHeroCamp()
  return HeroType.None
end

function UnitBase:GetUnitType()
  return self.unitType
end

function UnitBase:ForceFinishFlash()
  self.flashCountdown = nil
  self.flashCountdownValid = false
  if self.viewHandle then
    if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
      UnitViewFacade.MPBReset(self.viewHandle)
    end
    UnitViewFacade.ReplaceMaterialReset(self.viewHandle)
  else
    for k, v in pairs(self.renders) do
      if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
        AppearenceUtils.HitWhiteV2(v.renderer, false, true)
      end
      UnitViewFacade.ReplaceMaterialReset(v.renderer, v.defaultMat)
    end
  end
end

function UnitBase:OnBuffPropertyDirty()
  self.attackBuffDirty = true
  self.defenceBuffDirty = true
  self.chanceToHitDirty = true
  self.critDirty = true
  self.propFrame = nil
  self.propCache = nil
end

function UnitBase:OnBuffAdded(buff)
  self:OnBuffPropertyDirty()
  if buff.meta.type == BuffType.Shield and self.hpBar and self.curBlood > 0 then
    self.hpBar:SetHp(self.curBlood, self.maxBlood, self:GetShieldValue())
  end
end

function UnitBase:OnBuffRemoved(buff)
  self:OnBuffPropertyDirty()
  if buff.meta.type == BuffType.Shield and self.hpBar and self.curBlood > 0 then
    self.hpBar:SetHp(self.curBlood, self.maxBlood, self:GetShieldValue())
  end
  self:ExecuteBuffRemoveOtherLogic(buff)
end

function UnitBase:GetShieldValue()
  if self.buffManagerValid then
    return self.buffManager:GetShieldValue()
  end
  return 0
end

function UnitBase:GetChangeMaxBloodValue()
  if self.buffManagerValid then
    return self.buffManager:GetChangeMaxBloodValue()
  end
  return 0
end

function UnitBase:ReduceShieldValue(hurt)
  if self.buffManagerValid then
    return self.buffManager:ReduceShieldValue(hurt)
  end
  return hurt
end

function UnitBase:IsUntargetable()
  return self:IsStealth()
end

function UnitBase:IsStealth()
  return self.stealth
end

function UnitBase:SetStealth(bool)
  self.stealth = bool
end

function UnitBase:OnPassiveSkillCast(skill)
end

function UnitBase:RemoveAllShieldBuff()
  if self.buffManagerValid then
    self.buffManager:RemoveAllShield()
  end
end

function UnitBase:RemoveBuffTimeOrder(buffMetaId, count)
  if self.buffManagerValid then
    self.buffManager:RemoveBuffByMetaIdTimeOrder(buffMetaId, count)
  end
  self:OnBuffPropertyDirty()
end

function UnitBase:RemoveBuffByMetaId(metaId, count)
  if self.buffManagerValid then
    self.buffManager:RemoveBuffByMetaId(metaId, count)
  end
  self:OnBuffPropertyDirty()
end

function UnitBase:PlayPositionTimeline(positionTimeline, speed)
  self.positionTimeline = positionTimeline
  if self.playingPosTimeline then
    local unitPosInTeam = self:GetUnitPositionInTeam()
    self:SetLocalPosition(unitPosInTeam)
  end
  if table.IsNullOrEmpty(self.positionTimeline) then
    self.playingPosTimeline = false
    return
  end
  self.posTimelineElapsed = 0
  self.posTimelineSpeed = speed or 1
  self:TrySwitchNextMoveLogic()
  self:UpdatePosTimeLine(Time.deltaTime)
end

function UnitBase:TrySwitchNextMoveLogic()
  if not self.posTimelineIndex then
    self.posTimelineIndex = 0
  end
  
  local function ResetMoveLogicData()
    self.playingPosTimeline = false
    self.posTimelineIndex = 0
  end
  
  if not self.meta or table.IsNullOrEmpty(self.positionTimeline) then
    ResetMoveLogicData()
    return
  end
  if self.posTimelineIndex >= #self.positionTimeline then
    ResetMoveLogicData()
    return
  end
  self.posTimelineIndex = self.posTimelineIndex + 1
  self.playingPosTimeline = true
end

local function SetPosTimelineMoveTarget(self, isWorld, target)
  if not self.posTimelineTarget then
    self.posTimelineTarget = {}
  end
  self.posTimelineTarget.isWorld = isWorld
  self.posTimelineTarget.target = target
  self.hasPosTimelineTarget = true
end

function UnitBase:UnsetPosTimelineMoveTarget()
  if self.posTimelineTarget then
    self.posTimelineTarget.isWorld = nil
    self.posTimelineTarget.target = nil
  end
  self.hasPosTimelineTarget = false
end

function UnitBase:DoMoveLogic(moveLogic)
  if not moveLogic then
    return
  end
  if moveLogic == SkillMovingLogicType.TeamZeroPos then
    if self and self.GetTeamZeroWorldPos and self.SetPosition then
      local zeroWorldPos = self:GetTeamZeroWorldPos()
      self.posTimelineTarget = zeroWorldPos
      SetPosTimelineMoveTarget(self, true, zeroWorldPos)
    end
  elseif moveLogic == SkillMovingLogicType.UnitNormalFormationPos and self and self.SetLocalPosition then
    local unitPosInTeam = self:GetUnitPositionInTeam()
    SetPosTimelineMoveTarget(self, false, unitPosInTeam)
  end
end

function UnitBase:GetTeamZeroWorldPos()
  return Vector3.zero
end

function UnitBase:GetTeamRootTransform()
  return nil
end

function UnitBase:GetUnitPositionInTeam()
  return Vector3.zero
end

local MOVE_SPEED = 20

function UnitBase:UpdatePosTimeLine(deltaTime)
  if self.hasPosTimelineTarget then
    local targetPos = self.posTimelineTarget.target
    local isWorld = self.posTimelineTarget.isWorld
    if isWorld then
      local curPos = self:GetPosition()
      local moveDir = targetPos - curPos
      local moveDistance = MOVE_SPEED * deltaTime
      if moveDir:SqrMagnitude() <= moveDistance * moveDistance then
        self:SetPosition(targetPos)
        self:UnsetPosTimelineMoveTarget()
      else
        local newPos = curPos + moveDir:Normalize() * moveDistance
        self:SetPosition(newPos)
      end
    else
      local curPos = self:GetLocalPosition()
      local moveDir = targetPos - curPos
      local moveDistance = MOVE_SPEED * deltaTime
      if moveDir:SqrMagnitude() <= moveDistance * moveDistance then
        self:SetLocalPosition(targetPos)
        self:UnsetPosTimelineMoveTarget()
      else
        local newPos = curPos + moveDir:Normalize() * moveDistance
        self:SetLocalPosition(newPos)
      end
    end
  end
  if self.playingPosTimeline then
    if not self.posTimelineElapsed then
      self.posTimelineElapsed = 0
    end
    local time = 0
    local type = 0
    if self.positionTimeline and self.positionTimeline then
      if self.positionTimeline[self.posTimelineIndex].time then
        time = self.positionTimeline[self.posTimelineIndex].time
        time = time / self.posTimelineSpeed
      end
      if self.positionTimeline[self.posTimelineIndex].type then
        type = self.positionTimeline[self.posTimelineIndex].type
      end
    end
    self.posTimelineElapsed = self.posTimelineElapsed + deltaTime
    if time <= self.posTimelineElapsed then
      CommonUtil.ProtectCall(function()
        self:DoMoveLogic(type)
      end)
      self:TrySwitchNextMoveLogic()
    end
  end
end

function UnitBase:GetSearchType()
  return self.searchType
end

function UnitBase:SetIdleAnimName(newAnimName)
  local _newAnimName = newAnimName
  _newAnimName = _newAnimName or AnimName.Idle
  if self.idleAnimName == _newAnimName then
    return
  end
  local prevIdleName = self.idleAnimName
  prevIdleName = prevIdleName or AnimName.Idle
  if prevIdleName ~= _newAnimName then
    self.idleAnimName = _newAnimName
    if self.curAnimName == prevIdleName then
      self:CrossFadeSimpleAnim(_newAnimName, 1, 0.08)
    end
  end
end

function UnitBase:GetIdleAnimName()
  if self.idleAnimName then
    return self.idleAnimName
  end
  return AnimName.Idle
end

function UnitBase:SetIsTransforming(bool)
  self.isTransforming = bool
end

function UnitBase:GetIsTransforming()
  return self.isTransforming
end

function UnitBase:GetCritProperty()
  return self:GetProperty(HeroEffectDefine.CriticalRate_Result)
end

function UnitBase:GetAttackAndAddDamageBase()
  return PveUtil.CalculateAttackAndAddDamage(self)
end

function UnitBase:GetDefenceAndReduceDamageBase()
  return PveUtil.CalculateDefenceAndReduceDamage(self)
end

function UnitBase:GetChanceToHit()
  return self:GetProperty(HeroEffectDefine.ChanceToHit_Result)
end

function UnitBase:BeHeal(heal)
end

function UnitBase:AfterBeHeal(heal)
end

function UnitBase:OnEnterBornState()
  if self.heroEffectMeta then
    local effectMeta = self.heroEffectMeta
    if effectMeta.bornShakeParam and self.logic then
      self.logic:ShakeCameraWithParam(effectMeta.bornShakeParam)
    end
  end
end

function UnitBase:RegisterBuffFromSource(buffUid, sourceType, sourceId)
  if self.buffManagerValid then
    self.buffManager:SetBuffFromSourceData(buffUid, sourceType, sourceId)
  end
end

function UnitBase:ExecuteBuffRemoveOtherLogic(buff)
  if self.viewHandle and buff.sourceType == BuffFromSourceType.Bullet and self.logic and self.logic.UpdateBulletLogicAfterBuffRemove then
    self.logic:UpdateBulletLogicAfterBuffRemove(buff.sourceId, buff.meta.id)
  end
end

return UnitBase
