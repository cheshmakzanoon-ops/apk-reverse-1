local SkillEffectPvp = BaseClass("SkillEffectPvp")

function SkillEffectPvp:__init()
end

function SkillEffectPvp:__delete()
end

function SkillEffectPvp:Init(metaId, skillOwner, unitOwner, logic, skillMeta)
  self.skillOwner = skillOwner
  self.metaId = metaId
  self.owner = unitOwner
  self.battleMgr = logic
  self.skillMeta = skillMeta
  if not metaId or metaId <= 0 then
    Logger.LogError("metaId is error, metaId:" .. tostring(metaId))
    return
  end
  self.meta = DataCenter.SkillEffectPvpTemplateManager:GetTemplate(metaId)
  if not self.meta then
    Logger.LogError("meta not find, metaId:" .. metaId)
    return
  end
  self:InitBullet()
  if self.meta.pvp_actionType == SkillActionType.Bullet then
    if self.skillOwner.skillInfo then
      self.damage = self.skillOwner.skillInfo:GetAllDamage()
      for i = 1, #self.damage do
        self.damage[i] = self.damage[i] * self.skillOwner.meta.damage_to_monster
      end
    else
      self.damage = self.skillOwner.meta.damageParams
    end
  end
  self.firelogic = self.meta.firelogic
  self.firepoint = self.meta.firepoint
  self.highQualityMode = self.battleMgr.highQualityMode == nil or self.battleMgr.highQualityMode == true
  local skillEffectPveId = self.skillMeta:GetSkillEffect(self.owner.appearanceId)
  if skillEffectPveId and 0 < skillEffectPveId then
    self.effectMeta = DataCenter.PveSkillEffectTemplateManager:GetTemplate(skillEffectPveId)
  end
  if self.effectMeta then
    self.useBulletFireEffect = self.effectMeta.fire_effect_bullet
    self.fireEffectTime = self.effectMeta.fire_effect_time
    local audio = self.effectMeta.sound_id_fire_1
    self.audioCache = audio
  end
end

function SkillEffectPvp:Clear()
  self.skillOwner = nil
  self.meta = nil
  self.owner = nil
  self.bulletId = nil
  self.criticalBulletId = nil
  self.buffBulletId = nil
  self.damage = nil
  self.target = nil
end

function SkillEffectPvp:IsNil()
  return self.meta == nil
end

function SkillEffectPvp:Interrupt()
  if self.chantBullet then
    for _, bullet in pairs(self.chantBullet) do
      bullet:LogicDie()
    end
    self.chantBullet = nil
  end
end

function SkillEffectPvp:InitBullet()
  self.bulletId = self.meta.pvp_bullet
  self.criticalBulletId = self.meta.pvp_bullet_critical
  self.buffBulletId = self.meta.pvp_buff_bullet
end

function SkillEffectPvp:CreateBullet(target, param, bulletId, forceLifeDistance)
  self.target = target
  param = param or {}
  param.target = target
  param.forceLifeDistance = forceLifeDistance
  local _bulletId, _criticalBulletId
  _bulletId = bulletId
  if not _bulletId then
    _bulletId, _criticalBulletId = self:GetBulletId()
  end
  self.battleMgr.bulletManager:CreateBulletCreator(_bulletId, self, param, _criticalBulletId)
end

function SkillEffectPvp:Cast(target)
end

function SkillEffectPvp:Fire(target)
  self.target = target
  if self.meta.pvp_actionType == SkillActionType.Bullet then
    local bulletId, criticalBulletId = self:GetBulletId()
    local chantBullet = self.chantBullet
    if chantBullet then
      local removeList = {}
      for bulletUid, bullet in pairs(chantBullet) do
        if bullet.meta.id ~= bulletId or bullet.meta.id ~= criticalBulletId then
          bullet:LogicDie()
          removeList[#removeList + 1] = bulletUid
        end
      end
      for i = 1, #removeList do
        self:UnregisterChantBullet(removeList[i])
      end
    end
    if chantBullet and table.count(chantBullet) > 0 then
      for _, bullet in pairs(chantBullet) do
        bullet:ReInit(self.forceLifeDistance)
      end
    else
      local params = {
        target = self.target
      }
      if self.forceLifeDistance and 0 < self.forceLifeDistance then
        params.forceLifeDistance = self.forceLifeDistance
      end
      self.battleMgr.bulletManager:CreateBulletCreator(bulletId, self, params, criticalBulletId)
    end
  elseif self.meta.pvp_actionType == SkillActionType.Buff then
    if self.target and self.buffBulletId and 0 < self.buffBulletId then
      local params = {redirect = true}
      if self.forceLifeDistance and 0 < self.forceLifeDistance then
        params.forceLifeDistance = self.forceLifeDistance
      end
      self.battleMgr.bulletManager:CreateBulletCreator(self.buffBulletId, self, params, nil)
    end
  elseif self.meta.pvp_actionType == SkillActionType.ReduceCD and self.target then
    self:ApplyReduceCDToTarget(self, self.target)
  end
end

function SkillEffectPvp:GetBulletId()
  local normalBulletId, criticalBulletId = self.bulletId, self.criticalBulletId
  local isNormalAttack = self.skillOwner:IsNormalAttack()
  if self.skillOwner then
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

function SkillEffectPvp:DealBulletBuff(defender)
end

function SkillEffectPvp:SetRedirectTarget(redirectTargets)
  self.redirectTargets = redirectTargets
end

function SkillEffectPvp:Redirect()
  if self.redirectTargets and #self.redirectTargets > 0 then
    self.target = table.remove(self.redirectTargets)
  end
  return self.target
end

function SkillEffectPvp:IsBuff()
  return self.meta.pvp_actionType == SkillActionType.Buff
end

function SkillEffectPvp:HasBuffBullet()
  return self.buffBulletId and self.buffBulletId > 0
end

function SkillEffectPvp:ForceLifeTime(distance)
  self.forceLifeDistance = distance
  if self.meta.horizontal_speed <= 0 then
    self.forceLifeTime = self.meta.damage_delay / 1000
  else
    self.forceLifeTime = distance * (1 / self.meta.horizontal_speed)
  end
end

function SkillEffectPvp:GetForceLifeTime(distance)
  distance = distance or 0
  if 0 >= self.meta.horizontal_speed then
    return self.meta.damage_delay / 1000
  else
    return distance * (1 / self.meta.horizontal_speed)
  end
end

function SkillEffectPvp:GetBulletDamageFactor(bulletIndex)
  if self.damage and self.damage[bulletIndex] then
    return self.damage[bulletIndex]
  end
  return 0
end

function SkillEffectPvp:RegisterChantBullet(bulletUid, bullet)
  if not self.chantBullet then
    self.chantBullet = {}
  end
  self.chantBullet[bulletUid] = bullet
end

function SkillEffectPvp:UnregisterChantBullet(bulletUid)
  if self.chantBullet then
    self.chantBullet[bulletUid] = nil
  end
end

function SkillEffectPvp:ShowFireEffectImp(firePoint)
  if self.highQualityMode then
    if CommonUtil.IsDebug() then
      local replacedEffPath = GMUtils.GetString(GMConst.ReplaceWorldShotEffPath, "")
      if replacedEffPath ~= "" then
        self.battleMgr:ShowEffectObj(replacedEffPath, nil, Quaternion.identity, self.fireEffectTime, firePoint)
        return
      end
    end
    self.battleMgr:ShowEffectObj(self.effectMeta.fire_effect, nil, Quaternion.identity, self.fireEffectTime, firePoint)
  end
end

function SkillEffectPvp:TryPlayCacheFireSound()
  self:PlayFireSoundImp(self.audioCache)
end

function SkillEffectPvp:PlayFireSoundImp(audio)
  if audio and 0 < audio then
    if self.chantTime then
      self.soundUid = DataCenter.LWSoundManager:PlaySound(audio, 0 < self.chantTime)
    else
      self.soundUid = DataCenter.LWSoundManager:PlaySoundWithLimit(audio, SoundLimitType.SkillFire)
    end
  end
end

function SkillEffectPvp:ParseReduceCDParam(rawParam)
  if string.IsNullOrEmpty(rawParam) then
    return nil, nil
  end
  local paramList = string.split(rawParam, ",")
  return tonumber(paramList[1]), tonumber(paramList[2])
end

function SkillEffectPvp:GetReduceCDValue(skill, reduceType, rawValue)
  if not (skill and rawValue) or rawValue <= 0 then
    return 0
  end
  if reduceType == 2 then
    local _, maxCD = skill:GetCurAndMaxCD()
    local rate = rawValue
    if 1 < rate then
      rate = rate * 0.01
    end
    return math.max(maxCD or 0, 0) * math.max(rate, 0)
  end
  return rawValue
end

function SkillEffectPvp:ApplyReduceCDToTarget(skillEffect, target)
  if not target or not target.skillManager then
    return
  end
  local skillMgr = target.skillManager
  local ultimateSkill = skillMgr:GetUltimateSkill()
  if not ultimateSkill then
    return
  end
  local reduceType, rawValue = self:ParseReduceCDParam(skillEffect.meta.pvp_actionParam)
  local reduceValue = self:GetReduceCDValue(ultimateSkill, reduceType or 1, rawValue)
  if 0 < reduceValue then
    skillMgr:ReduceCooldown(ultimateSkill, reduceValue)
  end
end

local function getter_firelogic(self)
  if self.skillOwner == nil then
    return 0
  end
  self.firelogic = self.skillOwner.firelogic
  return self.firelogic
end

SkillEffectPvp.getters.firelogic = getter_firelogic
return SkillEffectPvp
