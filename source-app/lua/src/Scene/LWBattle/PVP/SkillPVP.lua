local SkillPVP = BaseClass("SkillPVP")
local SkillEffectPvp = require("Scene.LWBattle.PVP.SkillEffectPvp")

function SkillPVP:Init(battleMgr, skillMgr, owner, meta, skillInfo, isUltimate)
  self.active = true
  self.battleMgr = battleMgr
  self.skillMgr = skillMgr
  self.owner = owner
  self.meta = meta
  self.isUltimate = isUltimate
  self.skillInfo = skillInfo
  self.level = skillInfo and skillInfo.level or 0
  self.skillEffectMap = {}
  for i, effectMetaId in ipairs(self.meta.effect_pvp) do
    local skillEffect = SkillEffectPvp.New()
    skillEffect:Init(effectMetaId, self, self.owner, self.battleMgr, meta)
    self.skillEffectMap[effectMetaId] = skillEffect
  end
  local attackSpeedAddRate = 0
  if self.owner ~= nil and type(self.owner.GetProperty) == "function" then
    if meta:IsNormalAttack() then
      attackSpeedAddRate = self.owner:GetProperty(HeroEffectDefine.AllAttackSpeedAddRate)
    else
      attackSpeedAddRate = self.owner:GetProperty(HeroEffectDefine.AllCdReduceRate)
    end
    attackSpeedAddRate = math.max(-0.5, attackSpeedAddRate)
  end
  self.cd = meta.pre_cd / (1 + attackSpeedAddRate)
  self.state = 0 < self.cd and SkillCastState.Cooldown or SkillCastState.Ready
  self.realFireDelay = 0
  self.attackInterval = self.cd
  self.timerFire = 0
  self.timerFinish = 0
  local skillEffect = meta:GetSkillEffect(self.owner.appearanceId)
  if 0 < skillEffect then
    self.effectMeta = DataCenter.PveSkillEffectTemplateManager:GetTemplate(skillEffect)
  end
  self.target = nil
  self.targetLayerMask, self.targetAllyExcludeSelf, self.targetSelfExcludeAlly, self.targetSearchType = PveUtil.GetTargetLayerBin(self.owner.searchType, self.meta.target_type_bin)
  self.attackRange = self.meta.attack_range
  self.attack_interval = self.meta.attack_interval
  self.anim_normal = self.meta.anim_normal
  self.anim_move = self.meta.anim_move
  self.anim_normal_transformed = self.meta.anim_normal_transformed
  self.anim_move_transformed = self.meta.anim_move_transformed
  self.hasAnimState = self.owner.anim
  self.attackRangeSquare = self.attackRange * self.attackRange
  self.remainCount = 0
  self.isMovingSkll = self.meta and not table.IsNullOrEmpty(self.meta.moving_logic)
  self.firelogic = meta.firelogic
  self.firepoint = meta.firepoint
end

function SkillPVP:__delete()
  self:Destroy()
end

function SkillPVP:Destroy()
  if self.moveEffectSeq then
    self.moveEffectSeq:Kill()
    self.moveEffectSeq = nil
  end
  if self.moveEffectId then
    self.battleMgr:RemoveEffectObj(self.moveEffectId)
    self.moveEffectId = nil
  end
  DataCenter.LWSoundManager:StopSound(self.soundUid)
  for i, v in pairs(self.skillEffectMap) do
    if v then
      v:Clear()
      ObjectPool:GetInstance():Save(v)
    end
  end
  self.skillEffectMap = nil
  self.battleMgr = nil
  self.skillMgr = nil
  self.owner = nil
  self.meta = nil
  self.isUltimate = nil
  self.skillInfo = nil
  self.level = nil
  self.bulletId = nil
  self.criticalBulletId = nil
  self.buffBulletId = nil
  self.lock = nil
  self.damage = nil
  self.bulletMeta = nil
  self.chantTime = nil
  self.cd = nil
  self.state = nil
  self.realFireDelay = nil
  self.attackInterval = nil
  self.timerFire = nil
  self.timerFinish = nil
  self.effectMeta = nil
  self.target = nil
  self.targetLayerMask = nil
  self.targetAllyExcludeSelf = nil
  self.targetSelfExcludeAlly = nil
  self.targetSearchType = nil
  self.attackRange = nil
  self.attack_interval = nil
  self.anim_normal = nil
  self.anim_move = nil
  self.subSkills = nil
  self.attackRangeSquare = nil
  self.remainCount = nil
  self.timerReFire = nil
  self.isMovingSkll = nil
  self.soundUid = nil
  self.animLength = nil
  self.animSpeed = nil
  self.chantTime = nil
  self.active = false
end

function SkillPVP:IsNil()
  return self.meta == nil
end

function SkillPVP:IsActive()
  return self.active == true
end

function SkillPVP:OnUpdate(deltaTime)
  if self.cd > 0 then
    self.cd = self.cd - deltaTime
    if self.cd <= 0 then
      self:ResetCooldown()
      self:NotifyUltimateReady()
    end
  end
  if 0 < self.timerFire then
    self.timerFire = self.timerFire - deltaTime
    if 0 >= self.timerFire then
      self:Fire()
    end
  end
  if 0 < self.timerFinish then
    self.timerFinish = self.timerFinish - deltaTime
    if 0 >= self.timerFinish then
      if self.chantTime then
        DataCenter.LWSoundManager:StopSound(self.soundUid)
      end
      self.state = self.cd > 0 and SkillCastState.Cooldown or SkillCastState.Ready
      self.skillMgr.castingActiveSkill = nil
    end
  end
end

function SkillPVP:Interrupt()
  if self.timerFire > 0 then
    self:ResetCooldown()
  end
  self.timerFire = 0
  self.timerFinish = 0
  self.timerReFire = 0
  self.remainCount = 0
  if self.skillEffectMap then
    for i, v in pairs(self.skillEffectMap) do
      if v then
        v:Interrupt()
      end
    end
  end
end

local function GetDistanceEffcient(a, b)
  local x, y, z = a.x - b.x, a.y - b.y, a.z - b.z
  return x * x + y * y + z * z
end

function SkillPVP:RestartCD()
  local attackSpeedAddRate = 0
  if self.owner ~= nil and type(self.owner.GetProperty) == "function" then
    if self.meta:IsNormalAttack() then
      attackSpeedAddRate = self.owner:GetProperty(HeroEffectDefine.AllAttackSpeedAddRate)
    else
      attackSpeedAddRate = self.owner:GetProperty(HeroEffectDefine.AllCdReduceRate)
    end
    attackSpeedAddRate = math.max(-0.5, attackSpeedAddRate)
  end
  self.attackInterval = self.attack_interval / (1 + attackSpeedAddRate)
  self.realFireDelay = self.effectMeta.fire_delay
  self.cd = self.attackInterval
end

function SkillPVP:Cast(target)
  self.target = target
  if self.target == nil then
    Logger.LogError("target is nil!")
    return
  end
  self:RestartCD()
  if self.meta.apType == SkillAPType.Active then
    if self.hasAnimState and self:HasAnim() then
      self:PlayCastAnim()
      self:ShowEffectAndSound()
    else
      self:ShowEffectAndSound()
      self:Fire()
      self.skillMgr.castingActiveSkill = nil
    end
  else
    self:ShowEffectAndSound()
    self:Fire()
  end
end

function SkillPVP:PlayCastAnim()
  local realAnimLength = 0
  if not self.animLength then
    self.animLength = self.owner:GetAnimLength(self:GetAnimNormal())
  end
  if self.animLength <= self.attackInterval then
    self.animSpeed = 1
    self.realFireDelay = self.effectMeta.fire_delay
    realAnimLength = self.animLength
  else
    self.animSpeed = self.animLength / self.attackInterval
    self.realFireDelay = self.effectMeta.fire_delay / self.animSpeed
    realAnimLength = self.attackInterval
  end
  if not self.owner:ForbidSkillAnim() then
    local playAnim = true
    local hasMovingLogic = self:HasMovingLogic()
    if hasMovingLogic then
      playAnim = false
    end
    if playAnim then
      if self.owner.Tl_RewindAndPlaySimpleAnim then
        self.owner:Tl_RewindAndPlaySimpleAnim(self:GetAnimNormal(), self.animLength, self.animSpeed)
      else
        self.owner:RewindAndPlaySimpleAnim(self:GetAnimNormal(), self.animSpeed)
      end
    end
    if hasMovingLogic then
      self:TryPlaySkillPosTimeline()
    end
  end
  self.state = SkillCastState.FrontSwing
  self.timerFire = self.realFireDelay
  self.timerFinish = math.max(realAnimLength, self.realFireDelay)
  if self.chantTime then
    self.timerFinish = math.max(self.timerFinish, self.chantTime)
  end
end

function SkillPVP:Fire()
  self.state = self.chantTime and SkillCastState.Chant or SkillCastState.BackSwing
  self.cd = self.attackInterval - self.realFireDelay
  self:RealFire()
end

function SkillPVP:ShowEffectAndSound()
  local firePoint = self.owner:GetFirePoint()
  if self.battleMgr.highQualityMode == nil or self.battleMgr.highQualityMode == true then
    self.battleMgr:ShowEffectObj(self.effectMeta.fire_effect, nil, Quaternion.identity, self.effectMeta.fire_effect_time, firePoint)
    self.battleMgr:ShowEffectObj(self.effectMeta.cast_effect, Vector3.zero, Quaternion.identity, self.effectMeta.cast_effect_time, self.owner:GetBuffTransform())
  end
  if self.effectMeta.fireShakeParam and self.battleMgr.ShakeCameraWithParam then
    self.battleMgr:ShakeCameraWithParam(self.effectMeta.fireShakeParam)
  end
  if self.effectMeta.fireVibrateParam and #self.effectMeta.fireVibrateParam == 3 and self.battleMgr.DoVibration then
    self.battleMgr:DoVibration(self.effectMeta.fireVibrateParam[1], self.effectMeta.fireVibrateParam[2], self.effectMeta.fireVibrateParam[3])
  end
  if self.effectMeta.sound_id_fire_1 and self.effectMeta.sound_id_fire_1 > 0 then
    if self.chantTime then
      self.soundUid = DataCenter.LWSoundManager:PlaySound(self.effectMeta.sound_id_fire_1, 0 < self.chantTime)
    else
      self.soundUid = DataCenter.LWSoundManager:PlaySoundWithLimit(self.effectMeta.sound_id_fire_1, SoundLimitType.SkillFire)
    end
  end
  if self.effectMeta.moveEffectResPath then
    self.battleMgr:ShowEffectObj(self.effectMeta.moveEffectResPath, Vector3.zero, Quaternion.identity, self.effectMeta.moveEffectLifeTime, self.owner:GetBuffTransform(), nil, false, function(id, effectObj)
      if self.moveEffectSeq then
        self.moveEffectSeq:Kill()
        self.moveEffectSeq = nil
      end
      if self.moveEffectId then
        self.battleMgr:RemoveEffectObj(self.moveEffectId)
        self.moveEffectId = nil
      end
      self.moveEffectId = id
      local effectTrans = effectObj.req.gameObject.transform
      local seq = DOTween.Sequence()
      local pos = self.owner.platoon.army.transform.position
      pos.x = pos.x + self.effectMeta.moveEffectTargetPos[1]
      pos.z = pos.z + self.effectMeta.moveEffectTargetPos[2]
      seq:Append(effectTrans:DOMove(pos, self.effectMeta.moveEffectMoveTime)):SetEase(CS.DG.Tweening.Ease.Linear)
      seq:OnComplete(function()
        if self.moveEffectSeq then
          self.moveEffectSeq:Kill()
          self.moveEffectSeq = nil
        end
      end)
      self.moveEffectSeq = seq
    end)
  end
  if self.effectMeta.sound_id_fire_2 and 0 < self.effectMeta.sound_id_fire_2 then
    DataCenter.LWSoundManager:PlaySound(self.effectMeta.sound_id_fire_2)
  end
end

function SkillPVP:RealFire()
  for i, v in pairs(self.skillEffectMap) do
    if v then
      v:Fire(self.target)
    end
  end
end

function SkillPVP:AddBuffImp(target)
  return
end

function SkillPVP:GetCurAndMaxCD()
  return math.max(self.cd, 0), self.attackInterval
end

function SkillPVP:IsBuffSkill()
  return self.meta.actionType == SkillActionType.Buff
end

function SkillPVP:IsActiveSkill()
  return self.meta.apType == SkillAPType.Active
end

function SkillPVP:DealBulletBuff(defender)
end

function SkillPVP:IsNormalAttack()
  return self.meta:IsNormalAttack()
end

function SkillPVP:Redirect(srcPos, extraExclusions, legalizeTarget)
  if not self.battleMgr then
    return nil
  end
  if self.battleMgr:GetPVEType() == PVEType.World then
    return nil
  end
  if bulletId == nil then
    return nil
  end
  Logger.LogError(" \232\191\148\229\155\158\228\186\134\230\138\128\232\131\189\231\154\132target,  bulletId:" .. bulletId)
  return nil
end

function SkillPVP:SetTarget(target)
  self.target = target
end

function SkillPVP:GetState()
  return self.state
end

function SkillPVP:ResetCooldown()
  self.cd = 0
  self.state = SkillCastState.Ready
end

function SkillPVP:ReduceCooldown(reduceValue)
  if not reduceValue or reduceValue <= 0 or 0 >= self.cd then
    return 0
  end
  local oldCd = math.max(self.cd, 0)
  self.cd = math.max(self.cd - reduceValue, 0)
  if 0 >= self.cd then
    if self.state == SkillCastState.Cooldown then
      self:ResetCooldown()
    end
    self:NotifyUltimateReady()
  end
  return oldCd - self.cd
end

function SkillPVP:NotifyUltimateReady()
  if self.owner and self.owner.UltimateIsReady and self.owner:UltimateIsReady() and self.owner.index then
    EventManager:GetInstance():Broadcast(EventId.GF_zombie_battle_ult_ready, self.owner.index)
  end
end

function SkillPVP:GetEffect(effectMetaId)
  if self.meta and effectMetaId == 0 then
    effectMetaId = self.meta.id * 10
  end
  if self.skillEffectMap then
    return self.skillEffectMap[effectMetaId]
  end
  return nil
end

function SkillPVP:ForceLifeTime(distance)
  for i, v in pairs(self.skillEffectMap) do
    if v then
      v:ForceLifeTime(distance)
    end
  end
end

function SkillPVP:GetForceLifeTime(bulletId, distance)
  for i, v in pairs(self.skillEffectMap) do
    if v and v.bulletId == bulletId then
      v:GetForceLifeTime(distance)
    end
  end
end

function SkillPVP:SetRedirectTarget(redirectTargets)
  self.redirectTargets = redirectTargets
end

function SkillPVP:IsUltimate()
  return self.isUltimate
end

function SkillPVP:CreateBullet(target, param, bulletId)
  self.target = target
  param = param or {}
  param.target = target
  if self.forceLifeDistance and self.forceLifeDistance > 0 then
    param.forceLifeDistance = self.forceLifeDistance
  end
  local _bulletId, _criticalBulletId
  _bulletId = bulletId
  if not _bulletId then
    _bulletId, _criticalBulletId = self:GetBulletId()
  end
  self.battleMgr.bulletManager:CreateBulletCreator(_bulletId, self, param, _criticalBulletId)
end

function SkillPVP:GetBulletDamageFactor(bulletIndex)
  if self.damage and self.damage[bulletIndex] then
    return self.damage[bulletIndex]
  end
  return 0
end

function SkillPVP:GetBulletId()
  local normalBulletId, criticalBulletId = self.bulletId, self.criticalBulletId
  local isNormalAttack = self:IsNormalAttack()
  if self.owner then
    local function GetBulletFromBuff(buff)
      local buffSubtype = buff.meta.sub_type
      
      if isNormalAttack and buffSubtype ~= BuffSubType.ReplaceBulletForNormalAttack and buffSubtype ~= BuffSubType.ReplaceBulletForAll then
        return
      elseif not isNormalAttack and buffSubtype ~= BuffSubType.ReplaceBulletForUltimate and buffSubtype ~= BuffSubType.ReplaceBulletForAll then
        return
      end
      local rawPara = buff.meta.rawPara
      local ids = string.split(rawPara, ";")
      if ids and 0 < #ids then
        normalBulletId = tonumber(ids[1])
        if 1 < #ids then
          criticalBulletId = tonumber(ids[2])
        end
      end
    end
    
    if self.owner.DoActionForTypeBuff then
      self.owner:DoActionForTypeBuff(BuffType.ReplaceBullet, GetBulletFromBuff)
    end
  end
  return normalBulletId, criticalBulletId
end

function SkillPVP:TryPlaySkillPosTimeline()
  if self:HasMovingLogic() then
    if self.owner and self.owner.PlayPositionTimeline then
      self.owner:PlayPositionTimeline(self.meta.moving_logic)
    end
    return true
  end
  return false
end

function SkillPVP:HasMovingLogic()
  if self.isMovingSkll == nil then
    self.isMovingSkll = self.meta and next(self.meta.moving_logic) ~= nil
  end
  return self.isMovingSkll
end

function SkillPVP:HasBuffBullet()
  if self.buffBulletId and self.buffBulletId > 0 then
    return true
  end
  return false
end

function SkillPVP:GetAnimNormal()
  local isTransforming = self.owner and self.owner:GetIsTransforming()
  if not isTransforming then
    return self.anim_normal
  else
    return self.anim_normal_transformed
  end
end

function SkillPVP:GetAnimMove()
  local isTransforming = self.owner and self.owner:GetIsTransforming()
  if not isTransforming then
    return self.anim_move
  else
    return self.anim_move_transformed
  end
end

function SkillPVP:HasAnim()
  local animNormal = self:GetAnimNormal()
  if not string.IsNullOrEmpty(animNormal) then
    return true
  end
  return false
end

function SkillPVP:IsHeroAwakenSkill()
  return self.meta:IsHeroAwakenSkill()
end

function SkillPVP:IsTimePauseAwakenSkill()
  return self.meta:IsTimePauseAwakenSkill()
end

return SkillPVP
