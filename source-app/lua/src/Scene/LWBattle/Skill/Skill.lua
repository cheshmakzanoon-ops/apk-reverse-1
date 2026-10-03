local Skill = BaseClass("Skill")
local SkillSummonFormation = require("Scene.LWBattle.Skill.SkillSummonFormation")

function Skill:Init(battleMgr, skillMgr, owner, meta, skillInfo, isUltimate)
  self.battleMgr = battleMgr
  self.skillMgr = skillMgr
  self.owner = owner
  self.meta = meta
  self.isUltimate = isUltimate
  self.skillInfo = skillInfo
  self.level = skillInfo and skillInfo.level or 0
  self.slotIndex = skillInfo and skillInfo.slotIndex or 0
  local curPVEType = self.battleMgr:GetPVEType()
  self.isPVP = PVPType[curPVEType]
  if self.isPVP then
    self.bulletId = self.meta.pvp_bullet
    self.criticalBulletId = self.meta.pvp_bullet_critical
    self.cast_count = 0
    self.cast_interval = 0
    self.buffBulletId = self.meta.pvp_buff_bullet
  else
    self.bulletId = self.meta.bullet
    self.criticalBulletId = self.meta.bullet_critical
    self.cast_count = self.meta.cast_count
    self.cast_interval = self.meta.cast_interval
    self.buffBulletId = self.meta.pve_buff_bullet
  end
  if curPVEType == 4 then
    self.bulletId = self.meta.world_bullet
    if CommonUtil.IsDebug() then
      local replaceBulletId = GMUtils.GetInt(GMConst.ReplaceWorldBulletId, 0)
      if 0 < replaceBulletId then
        self.bulletId = replaceBulletId
      end
    end
  end
  if skillInfo and not skillInfo:IsUnlock() then
    self.lock = true
  else
    self.lock = false
  end
  self.specialStraightBulletType = false
  if meta.actionType == SkillActionType.Bullet then
    if skillInfo then
      self.damage = skillInfo:GetAllDamage()
      for i = 1, #self.damage do
        self.damage[i] = self.damage[i] * self.meta.damage_to_monster
      end
    else
      self.damage = self.meta.damageParams
    end
    self.bulletMeta = DataCenter.PveBulletTemplateManager:GetTemplate(self.bulletId)
    local bulletMvType = self.bulletMeta.mvt_type
    if bulletMvType == BulletMoveType.Follow then
      self.chantTime = self.bulletMeta.lifetime
      self.chantBullet = {}
    end
    local metaId = meta.id
    self.specialStraightBulletType = metaId == 434 or metaId == 435 or metaId == 436 or metaId == 445 or metaId == 10010 or metaId == 10011 or metaId == 10012 or metaId == 100121 or metaId == 10013 or metaId == 10014
  end
  self.buff = self.meta.buff
  if 0 < self.buff then
    self.buffMeta = DataCenter.LWBuffTemplateManager:GetTemplate(self.buff)
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
    self.warnEffect = self.effectMeta.warn_effect
    self.showWarnEffect = not string.IsNullOrEmpty(self.warnEffect)
    if self.showWarnEffect then
      self.useBulletWarnEffect = self.effectMeta.warn_effect_bullet
      self.warnEffectTime = self.effectMeta.warn_effect_time
    end
    self.useBulletFireEffect = self.effectMeta.fire_effect_bullet
    self.fireEffectTime = self.effectMeta.fire_effect_time
  end
  self.target = nil
  self.targetLayerMask, self.targetAllyExcludeSelf, self.targetSelfExcludeAlly, self.targetSearchType = PveUtil.GetTargetLayerBin(self.owner.searchType, self.meta.target_type_bin)
  self.attackRange = self.meta.attack_range
  self.attack_interval = self.meta.attack_interval
  if self.isPVP then
    self.anim_normal = self.meta.anim_normal
    self.anim_move = self.meta.anim_move
    self.anim_normal_transformed = self.meta.anim_normal_transformed
    self.anim_move_transformed = self.meta.anim_move_transformed
  elseif curPVEType == PVEType.Barrage then
    self.anim_normal = self.meta.matching_animation
    self.anim_move = self.meta.matching_animation_move
    self.anim_normal_transformed = self.meta.matching_animation_transformed
    self.anim_move_transformed = self.meta.matching_animation_move_transformed
  elseif (curPVEType == PVEType.Parkour or curPVEType == PVEType.Count) and not self.battleMgr:IsDefenseMode() then
    self.anim_normal = self.meta.matching_animation
    self.anim_move = self.meta.matching_animation_move
    self.anim_normal_transformed = self.meta.matching_animation_transformed
    self.anim_move_transformed = self.meta.matching_animation_move_transformed
  else
    self.anim_normal = self.meta.pve_animation
    self.anim_move = self.meta.pve_animation_move
    self.anim_normal_transformed = self.meta.pve_animation_transformed
    self.anim_move_transformed = self.meta.pve_animation_move_transformed
  end
  self.hasAnimState = self.owner.anim
  if meta.subSkills and not meta.isSubSkill then
    self.subSkills = {}
    for _, v in pairs(meta.subSkills) do
      local newSkill = ObjectPool:GetInstance():Load(Skill)
      newSkill:Init(battleMgr, skillMgr, owner, v, skillInfo)
      table.insert(self.subSkills, newSkill)
    end
  end
  if PVE_TEST_MODE and self.owner.bulletMotionEditor and self.bulletMeta then
    local bulletMeta = self.bulletMeta
    self.owner.bulletMotionEditor.AttackRange = self.meta.attack_range
    self.owner.bulletMotionEditor.BulletEffect = bulletMeta.bullet_effect
    self.owner.bulletMotionEditor.HeightWidthRatio = bulletMeta.mvt_type_para
    self.owner.bulletMotionEditor.Height = bulletMeta.mvt_type_para_2
    self.owner.bulletMotionEditor.FlySpeed = bulletMeta.bullet_fly_speed
    if string.IsNullOrEmpty(bulletMeta.motion_curve) then
      self.owner.bulletMotionEditor.CurveString = DEFAULT_BULLET_MOTION_STRING
      self.owner.bulletMotionEditor.MotionCurve = CS.BulletMotionEditor.StringToCurve(DEFAULT_BULLET_MOTION_STRING)
    else
      self.owner.bulletMotionEditor.CurveString = bulletMeta.motion_curve
      self.owner.bulletMotionEditor.MotionCurve = CS.BulletMotionEditor.StringToCurve(bulletMeta.motion_curve)
    end
    self.attackRange = self.owner.bulletMotionEditor.AttackRange
    self.attack_interval = self.owner.bulletMotionEditor.Cooldown
    self.cd = 1
    self.state = SkillCastState.Cooldown
  end
  self.attackRangeSquare = self.attackRange * self.attackRange
  self.remainCount = 0
  self.timerReFire = 0
  self.isMovingSkll = self.meta and not table.IsNullOrEmpty(self.meta.moving_logic)
  self.firelogic = meta.firelogic
  self.firepoint = meta.firepoint
  self.passiveTriggerTimes = 0
  self.highQualityMode = self.battleMgr.highQualityMode == nil or self.battleMgr.highQualityMode == true
  self.isHaveDamageLimit = false
  self.damageLimitNum = 0
end

function Skill:SwitchToWorldTroopEffect()
  self.isWorldTroopEffect = true
end

function Skill:__delete()
  self:Destroy()
end

function Skill:Destroy()
  DataCenter.LWSoundManager:StopSound(self.soundUid)
  self.battleMgr = nil
  self.skillMgr = nil
  self.owner = nil
  self.meta = nil
  self.isUltimate = nil
  self.skillInfo = nil
  self.level = nil
  self.isPVP = nil
  self.bulletId = nil
  self.criticalBulletId = nil
  self.cast_count = nil
  self.cast_interval = nil
  self.buffBulletId = nil
  self.lock = nil
  self.damage = nil
  self.bulletMeta = nil
  self.chantTime = nil
  self.chantBullet = nil
  self.buff = nil
  self.buffMeta = nil
  self.cd = nil
  self.state = nil
  self.realFireDelay = nil
  self.attackInterval = nil
  self.timerFire = nil
  self.timerFinish = nil
  self.effectMeta = nil
  self.warnEffect = nil
  self.showWarnEffect = nil
  self.useBulletWarnEffect = nil
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
  self.isWorldTroopEffect = nil
  self.soundUid = nil
  self.animLength = nil
  self.animSpeed = nil
  self.chantTime = nil
  self.passiveTriggerTimes = nil
  self.audioCache = nil
  self.isHaveDamageLimit = nil
  self.damageLimitNum = nil
  self.slotIndex = nil
  self.summonFormation = nil
  self.summonSlotUnitIdMap = nil
end

function Skill:IsNil()
  return self.meta == nil
end

function Skill:OnUpdate(deltaTime)
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
      if self.remainCount < 1 then
        self.state = self.cd > 0 and SkillCastState.Cooldown or SkillCastState.Ready
        self.skillMgr.castingActiveSkill = nil
      else
        if not self.owner:ForbidSkillAnim() then
          if self.owner:IsMoving() then
            self.owner:RewindAndPlaySimpleAnim(AnimName.Walk, 1)
          else
            self.owner:RewindAndPlaySimpleAnim(AnimName.Idle, self.animSpeed)
          end
        end
        self.timerReFire = self.cast_interval
      end
    end
  end
  if 0 < self.timerReFire then
    self.timerReFire = self.timerReFire - deltaTime
    if 0 >= self.timerReFire then
      if 0 < self.remainCount then
        self.remainCount = self.remainCount - 1
        if self.meta.apType == SkillAPType.Active then
          if self.hasAnimState and self:HasAnim() then
            self:RePlayCastAnim()
            self:ShowEffectAndSound()
          else
            self:ShowEffectAndSound()
            self:ReFire()
            if self.remainCount < 1 then
              self.skillMgr.castingActiveSkill = nil
            else
              self.timerReFire = self.cast_interval
            end
          end
        else
          self:ShowEffectAndSound()
          self:ReFire()
          if 0 < self.remainCount then
            self.timerReFire = self.cast_interval
          end
        end
      else
        self.state = self.cd > 0 and SkillCastState.Cooldown or SkillCastState.Ready
        self.skillMgr.castingActiveSkill = nil
      end
    end
  end
end

function Skill:Interrupt()
  if self.soundUid then
    DataCenter.LWSoundManager:StopSound(self.soundUid)
  end
  if self.timerFire > 0 then
    self:ResetCooldown()
  end
  self.timerFire = 0
  self.timerFinish = 0
  self.timerReFire = 0
  self.remainCount = 0
  if self.chantBullet then
    for bulletUid, bullet in pairs(self.chantBullet) do
      bullet:LogicDie()
    end
    self.chantBullet = {}
  end
end

function Skill:CheckCondition(ignoreRange)
  if self.attackRange <= 0 then
    return self:SearchTarget()
  end
  if self.targetSelfExcludeAlly then
    return self:SearchTarget()
  end
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    ProfilerUtil.BeginSample("PveUtil.CheckCondition->SearchTarget")
    local target
    if ignoreRange then
      target = self:SearchTargetIgnoreRange()
    else
      target = self:SearchTarget()
    end
    ProfilerUtil.EndSample()
    return target
  else
    local center = self.owner:GetPosition()
    local layerMask = self.targetLayerMask
    local radius = self.attackRange
    ProfilerUtil.BeginSample("PveUtil.CheckHasUnitInSphereRange")
    local ret = PveUtil.CheckHasUnitInSphereRange(self.battleMgr, center, radius, layerMask) or nil
    ProfilerUtil.EndSample()
    return ret
  end
end

function Skill:CheckConditionWithTarget(target)
  if self.attackRange <= 0 then
    return true
  end
  if self.targetSelfExcludeAlly then
    return true
  end
  local center = self.owner:GetPosition()
  local targetPos = target:GetPosition()
  local radius = self.attackRange
  local x = targetPos.x - center.x
  local y = targetPos.y - center.y
  local z = targetPos.z - center.z
  return x ^ 2 + y ^ 2 + z ^ 2 <= radius ^ 2
end

function Skill:CheckTriggerParam(triggerType, param)
  if triggerType == SkillTriggerType.Death then
    return true
  elseif triggerType == SkillTriggerType.Cast then
    return param == self.meta.triggerParam
  elseif triggerType == SkillTriggerType.BeHitNew then
    return self:CheckBeHitNewTriggerParam(param)
  end
end

function Skill:SearchTarget(srcPos, extraExclusions)
  if self.meta.actionType == SkillActionType.Bullet or self.meta.actionType == SkillActionType.Summon then
    ProfilerUtil.BeginSample("Skill.SearchTarget")
    local res = self:SearchTargetForBullet(srcPos, extraExclusions)
    ProfilerUtil.EndSample()
    return res
  elseif self.meta.actionType == SkillActionType.Buff or self.meta.actionType == SkillActionType.Halo or self.meta.actionType == SkillActionType.ResetCD then
    return self:SearchTargetForBuff(srcPos, extraExclusions, false)
  end
end

function Skill:SearchTargetForBulletWithAngle(srcPos, extraExclusions, forward, halfAngle, minRadius, maxRadius)
  if halfAngle < 0 or 359 < halfAngle then
    return self:SearchTargetForBullet(srcPos, extraExclusions)
  end
  if not srcPos then
    return nil
  end
  local exclusions = {}
  table.merge(exclusions, extraExclusions)
  return PveUtil.FindUnitInSectorRange(self.battleMgr, srcPos, minRadius or 0, maxRadius or self.attackRange, self.targetLayerMask, exclusions, forward, halfAngle)
end

function Skill:SearchTargetForBullet(srcPos, extraExclusions)
  if self.targetSelfExcludeAlly then
    return self.owner
  end
  local center = srcPos or self.owner:GetPosition()
  local layerMask = self.targetLayerMask
  local radius = self.attackRange
  local exclusions = {}
  table.merge(exclusions, extraExclusions)
  if self.meta.other_condition == PriorityType.All then
    Logger.LogError("\229\173\144\229\188\185\229\158\139\230\138\128\232\131\189\233\133\141\231\189\174\228\186\134\229\164\154\231\155\174\230\160\135\239\188\140skillId=" .. self.meta.id)
    return PveUtil.FindNearestUnitInSphereRange(self.battleMgr, center, radius, layerMask, exclusions)
  elseif self.meta.other_condition == PriorityType.Random then
    return PveUtil.FindRandomUnitInSphereRange(self.battleMgr, center, radius, layerMask, exclusions)
  elseif self.meta.other_condition == PriorityType.Nearest then
    return PveUtil.FindNearestUnitInSphereRange(self.battleMgr, center, radius, layerMask, exclusions)
  elseif self.meta.other_condition == PriorityType.Farthest then
    return PveUtil.FindFarthestUnitInSphereRange(self.battleMgr, center, radius, layerMask, exclusions)
  elseif self.meta.other_condition == PriorityType.LowestHP then
    return PveUtil.FindLowestHPUnitInSphereRange(self.battleMgr, center, radius, layerMask, exclusions)
  elseif self.meta.other_condition == PriorityType.HighestMaxHP then
    return PveUtil.FindHighestMaxHPUnitInSphereRange(self.battleMgr, center, radius, layerMask, exclusions)
  elseif self.meta.other_condition == PriorityType.HighestEffect then
    local effectId = self.meta:GetOtherConditionPara()
    if effectId ~= nil and 0 < effectId then
      return PveUtil.FindHighestPropertyUnitInSphereRange(self.battleMgr, center, radius, layerMask, exclusions, effectId)
    end
  elseif self.meta.other_condition == PriorityType.HighestBuffCount then
    local buffIdArr = self.meta:GetOtherConditionPara()
    if not table.IsNullOrEmpty(buffIdArr) then
      return PveUtil.FindHighestBuffCountUnitInSphereRange(self.battleMgr, center, radius, layerMask, exclusions, buffIdArr)
    end
  elseif self.meta.other_condition == PriorityType.BoxRandom then
    local param = self.meta:GetOtherConditionPara()
    if param and #param == 2 then
      return PveUtil.FindRandomUnitInBoxRange(self.battleMgr, center, radius, param[1], param[2], layerMask, exclusions)
    end
  elseif self.meta.other_condition == PriorityType.BoxNearest then
    local param = self.meta:GetOtherConditionPara()
    if param and #param == 2 then
      return PveUtil.FindNearestUnitInBoxRange(self.battleMgr, center, radius, param[1], param[2], layerMask, exclusions)
    end
  elseif self.meta.other_condition == PriorityType.BoxFarthest then
    local param = self.meta:GetOtherConditionPara()
    if param and #param == 2 then
      return PveUtil.FindFarthestUnitInBoxRange(self.battleMgr, center, radius, param[1], param[2], layerMask, exclusions)
    end
  end
end

function Skill:SearchTargetForBuff(srcPos, extraExclusions, ignoreRange)
  local ret = {}
  if self.targetSelfExcludeAlly then
    ret[1] = self.owner
    return ret
  end
  local exclusions = {}
  if self.targetAllyExcludeSelf then
    exclusions[self.owner.guid] = true
  end
  table.merge(exclusions, extraExclusions)
  local tempTarget
  if ignoreRange or self.attackRange <= 0 then
    tempTarget = self.battleMgr.unitMgr:GetAllUnitsBySearchTypes(self.targetSearchType, exclusions)
  else
    local center = srcPos or self.owner:GetPosition()
    local layerMask = self.targetLayerMask
    local radius = self.attackRange
    local taregetSearchType = self.targetSearchType
    tempTarget = PveUtil.GetAllUnitsInSphereRange(self.battleMgr, center, radius, layerMask, exclusions, taregetSearchType)
  end
  if self.meta.pos_condition == LocationCondition.Random then
    local toRemove = #tempTarget - self.meta.pos_num
    for i = 1, toRemove do
      table.remove(tempTarget, math.random(#tempTarget))
    end
  elseif self.meta.pos_condition == LocationCondition.FrontOnly then
    for i = #tempTarget, 1, -1 do
      if tempTarget[i]:GetLocationType() ~= LocationType.Front then
        table.remove(tempTarget, i)
      end
    end
  elseif self.meta.pos_condition == LocationCondition.BackOnly then
    for i = #tempTarget, 1, -1 do
      if tempTarget[i]:GetLocationType() ~= LocationType.Back then
        table.remove(tempTarget, i)
      end
    end
  end
  if self.meta.troop_condition == HeroType.Tank then
    for i = #tempTarget, 1, -1 do
      if tempTarget[i]:GetHeroCamp() ~= HeroType.Tank then
        table.remove(tempTarget, i)
      end
    end
  elseif self.meta.troop_condition == HeroType.Missile then
    for i = #tempTarget, 1, -1 do
      if tempTarget[i]:GetHeroCamp() ~= HeroType.Missile then
        table.remove(tempTarget, i)
      end
    end
  elseif self.meta.troop_condition == HeroType.Aircraft then
    for i = #tempTarget, 1, -1 do
      if tempTarget[i]:GetHeroCamp() ~= HeroType.Aircraft then
        table.remove(tempTarget, i)
      end
    end
  end
  if self.meta.other_condition == PriorityType.All then
    return tempTarget
  elseif self.meta.other_condition == PriorityType.Nearest or self.meta.other_condition == PriorityType.BoxNearest then
    local nearest
    local minDist = IntMaxValue
    local center = srcPos or self.owner:GetPosition()
    for _, unit in pairs(tempTarget) do
      local dist = Vector3.ManhattanDistanceXZ(center, unit:GetPosition())
      if minDist > dist then
        minDist = dist
        nearest = unit
      end
    end
    ret[#ret + 1] = nearest
    return ret
  elseif self.meta.other_condition == PriorityType.Farthest or self.meta.other_condition == PriorityType.BoxFarthest then
    local farthest
    local maxDist = 0
    local center = srcPos or self.owner:GetPosition()
    for _, unit in pairs(tempTarget) do
      local dist = Vector3.ManhattanDistanceXZ(center, unit:GetPosition())
      if maxDist < dist then
        maxDist = dist
        farthest = unit
      end
    end
    ret[#ret + 1] = farthest
    return ret
  elseif self.meta.other_condition == PriorityType.LowestHP then
    local lowest
    local lowestHP = IntMaxValue
    for _, unit in pairs(tempTarget) do
      local curHP = unit:GetCurBlood()
      if lowestHP > curHP then
        lowestHP = curHP
        lowest = unit
      end
    end
    ret[#ret + 1] = lowest
    return ret
  elseif self.meta.other_condition == PriorityType.HighestMaxHP then
    local highest
    local highestHP = 0
    for _, unit in pairs(tempTarget) do
      local maxHP = unit:GetMaxBlood()
      if highestHP < maxHP then
        highestHP = maxHP
        highest = unit
      end
    end
    ret[#ret + 1] = highest
    return ret
  elseif self.meta.other_condition == PriorityType.HighestEffect then
    local effectId = self.meta:GetOtherConditionPara()
    if effectId ~= nil and 0 < effectId then
      local highest
      local highestEffect = 0
      for _, unit in pairs(tempTarget) do
        local maxEffect = unit:GetProperty(effectId)
        if highest == nil or highestEffect < maxEffect then
          highestEffect = maxEffect
          highest = unit
        end
      end
      if highest ~= nil then
        ret[#ret + 1] = highest
      end
      return ret
    end
  elseif self.meta.other_condition == PriorityType.HighestBuffCount then
    local buffIdList = self.meta:GetOtherConditionPara()
    if not table.IsNullOrEmpty(buffIdList) then
      local highest
      local highestBuffCount = 0
      for _, unit in pairs(tempTarget) do
        local buffCountTotal = 0
        for _, buffId in pairs(buffIdList) do
          local buffCount = unit:GetBuffLevel(buffId)
          buffCountTotal = buffCountTotal + buffCount
        end
        if highestBuffCount < buffCountTotal then
          highestBuffCount = buffCountTotal
          highest = unit
        end
      end
      ret[#ret + 1] = highest
      return ret
    end
  elseif self.meta.other_condition == PriorityType.Random or self.meta.other_condition == PriorityType.BoxRandom then
    local rand = math.random(#tempTarget)
    ret[#ret + 1] = tempTarget[rand]
    return ret
  end
end

function Skill:SearchTargetIgnoreRange(srcPos, extraExclusions, tauntFirst)
  if self.meta.actionType == SkillActionType.Bullet then
    return self:SearchTargetForBulletIgnoreRange(srcPos, extraExclusions, tauntFirst)
  elseif self.meta.actionType == SkillActionType.Buff or self.meta.actionType == SkillActionType.Halo or self.meta.actionType == SkillActionType.ResetCD then
    return self:SearchTargetForBuffIgnoreRange(srcPos, extraExclusions)
  end
end

function Skill:SearchTargetForBulletIgnoreRange(srcPos, extraExclusions, tauntFirst)
  if self.targetSelfExcludeAlly then
    return self.owner
  end
  local exclusions = {}
  table.merge(exclusions, extraExclusions)
  local target
  if tauntFirst then
    target = self.battleMgr.unitMgr:GetGlobalTauntUnitBySearchTypes(self.targetSearchType, exclusions)
    if target ~= nil then
      return target
    end
  end
  local center = srcPos or self.owner:GetPosition()
  if self.meta.other_condition == PriorityType.All then
    Logger.LogError("\229\173\144\229\188\185\229\158\139\230\138\128\232\131\189\230\156\137\229\164\154\228\184\170\231\155\174\230\160\135\239\188\159\230\138\128\232\131\189\233\133\141\231\189\174id=" .. self.meta.id)
    target = self.battleMgr.unitMgr:GetNearestUnitBySearchTypes(self.targetSearchType, center, exclusions)
  elseif self.meta.other_condition == PriorityType.Random then
    target = self.battleMgr.unitMgr:GetRandomUnitBySearchTypes(self.targetSearchType, exclusions)
  elseif self.meta.other_condition == PriorityType.Nearest then
    if self.battleMgr:GetPVEType() == PVEType.LastStand then
      target = self.battleMgr.unitMgr:GetNearestUnitBySearchTypesIncludesNav(self.targetSearchType, center, exclusions, self.attackRange)
    else
      target = self.battleMgr.unitMgr:GetNearestUnitBySearchTypes(self.targetSearchType, center, exclusions)
    end
  elseif self.meta.other_condition == PriorityType.Farthest then
    target = self.battleMgr.unitMgr:GetFarthestUnitBySearchTypes(self.targetSearchType, center, exclusions)
  elseif self.meta.other_condition == PriorityType.LowestHP then
    target = self.battleMgr.unitMgr:GetLowestHPUnitBySearchTypes(self.targetSearchType, exclusions)
  elseif self.meta.other_condition == PriorityType.HighestMaxHP then
    target = self.battleMgr.unitMgr:GetHighestMaxHPUnitBySearchTypes(self.targetSearchType, exclusions)
  elseif self.meta.other_condition == PriorityType.HighestEffect then
    local effectId = self.meta:GetOtherConditionPara()
    if effectId ~= nil and 0 < effectId then
      target = self.battleMgr.unitMgr:GetHighestPropertyUnitBySearchTypes(self.targetSearchType, exclusions, effectId)
    end
  elseif self.meta.other_condition == PriorityType.HighestBuffCount then
    local buffIdList = self.meta:GetOtherConditionPara()
    if not table.IsNullOrEmpty(buffIdList) then
      target = self.battleMgr.unitMgr:GetHighestBuffCountUnitBySearchTypes(self.targetSearchType, exclusions, buffIdList)
    end
  end
  return target
end

function Skill:SearchTargetForBuffIgnoreRange(srcPos, extraExclusions)
  return self:SearchTargetForBuff(srcPos, extraExclusions, true)
end

function Skill:SearchTargetPriorRange(srcPos, extraExclusions)
  local ret = self:SearchTarget(srcPos, extraExclusions)
  return ret or self:SearchTargetIgnoreRange(srcPos, extraExclusions)
end

local function GetDistanceEffcient(a, b)
  local x, y, z = a.x - b.x, a.y - b.y, a.z - b.z
  return x * x + y * y + z * z
end

function Skill:IsTargetInRange(target)
  if target then
    if self.meta.actionType == SkillActionType.Buff or self.meta.actionType == SkillActionType.Halo or self.meta.actionType == SkillActionType.ResetCD then
      for k, v in pairs(target) do
        local sqrDistance = GetDistanceEffcient(self.owner:GetPosition(), v:GetPosition())
        if sqrDistance > self.attackRangeSquare then
          return false
        end
      end
      return true
    else
      local sqrDistance = GetDistanceEffcient(self.owner:GetPosition(), target:GetPosition())
      return sqrDistance < self.attackRangeSquare
    end
  else
    return false
  end
end

function Skill:RestartCD()
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

function Skill:ReInit()
  local attackSpeedAddRate = 0
  if self.owner ~= nil and type(self.owner.GetProperty) == "function" then
    if self.meta:IsNormalAttack() then
      attackSpeedAddRate = self.owner:GetProperty(HeroEffectDefine.AllAttackSpeedAddRate)
    else
      attackSpeedAddRate = self.owner:GetProperty(HeroEffectDefine.AllCdReduceRate)
    end
    attackSpeedAddRate = math.max(-0.5, attackSpeedAddRate)
  end
  self.cd = self.meta.pre_cd / (1 + attackSpeedAddRate)
  self.state = 0 < self.cd and SkillCastState.Cooldown or SkillCastState.Ready
  self.realFireDelay = self.effectMeta.fire_delay
  self.attackInterval = self.cd
  self.timerFire = 0
  self.timerFinish = 0
end

function Skill:Cast(target)
  self.target = target or self:SearchTarget()
  if self.meta.actionType == SkillActionType.Halo then
    self:RealFire()
  else
    self:RestartCD()
    self.remainCount = self.cast_count - 1
    self.passiveTriggerTimes = self.passiveTriggerTimes + 1
    self.isHaveDamageLimit = false
    self.damageLimitNum = 0
    if self.meta.apType == SkillAPType.Active then
      if self.hasAnimState and self:HasAnim() then
        self:PlayCastAnim()
        self:ShowEffectAndSound()
      else
        self:ShowEffectAndSound()
        self:Fire()
        if self.remainCount < 1 then
          self.skillMgr.castingActiveSkill = nil
        else
          self.timerReFire = self.cast_interval
        end
      end
    else
      self:ShowEffectAndSound()
      self:Fire()
      if self.remainCount > 0 then
        self.timerReFire = self.cast_interval
      end
    end
  end
  if self.meta.buff_condition == BulletBuffType.OnCastToCaster then
    self:AddBuffImp(self.owner)
  end
end

function Skill:PlayCastAnim()
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
    if hasMovingLogic and self.isPVP then
      playAnim = false
    end
    if playAnim then
      if self.owner:IsMoving() then
        local move_anim_length = self.owner:GetAnimLength(self:GetAnimMove())
        if self.owner.Tl_RewindAndPlaySimpleAnim then
          self.owner:Tl_RewindAndPlaySimpleAnim(self:GetAnimMove(), move_anim_length, self.animSpeed)
        else
          self.owner:RewindAndPlaySimpleAnim(self:GetAnimMove(), 1)
        end
      elseif self.owner.Tl_RewindAndPlaySimpleAnim then
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

function Skill:RePlayCastAnim()
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
    if hasMovingLogic and self.isPVP then
      playAnim = false
    end
    if playAnim then
      if self.owner:IsMoving() then
        local moveAnimLegnth = self.owner:GetAnimLength(self:GetAnimMove())
        if self.owner.Tl_RewindAndPlaySimpleAnim then
          self.owner:Tl_RewindAndPlaySimpleAnim(self:GetAnimMove(), moveAnimLegnth, 1)
        else
          self.owner:RewindAndPlaySimpleAnim(self:GetAnimMove(), 1)
        end
      elseif self.owner.Tl_RewindAndPlaySimpleAnim then
        self.owner:Tl_RewindAndPlaySimpleAnim(self:GetAnimNormal(), self.animLength, self.animSpeed)
      else
        self.owner:RewindAndPlaySimpleAnim(self:GetAnimNormal(), self.animSpeed)
      end
    end
    if hasMovingLogic then
      self:TryPlaySkillPosTimeline()
    end
  end
  self.timerFire = self.realFireDelay
  self.timerFinish = math.max(realAnimLength, self.realFireDelay)
  if self.chantTime then
    self.timerFinish = math.max(self.timerFinish, self.chantTime)
  end
end

function Skill:Fire()
  self.state = self.chantTime and SkillCastState.Chant or SkillCastState.BackSwing
  self.cd = self.attackInterval - self.realFireDelay
  self:RealFire()
end

function Skill:ShowEffectAndSound()
  if not self.useBulletFireEffect then
    local firePoint
    if self.owner.unitType and self.owner.unitType == UnitType.Zombie then
      if self.firelogic > 0 then
        local fireIndex = self.firepoint[1] or 1
        firePoint = self.owner:GetFirePointById(fireIndex)
      else
        firePoint = self.owner:GetFirePoint()
      end
    else
      firePoint = self.owner:GetFirePoint()
    end
    self:ShowFireEffectImp(firePoint)
  end
  if self.highQualityMode then
    local cast_effect_slot = self.effectMeta.bone_effect_slot
    if cast_effect_slot and 0 < cast_effect_slot then
      local castEffectParent = self.owner:GetFirePointById(cast_effect_slot)
      self.battleMgr:ShowEffectObj(self.effectMeta.cast_effect, Vector3.zero, Quaternion.identity, self.effectMeta.cast_effect_time, castEffectParent)
    else
      self.battleMgr:ShowEffectObj(self.effectMeta.cast_effect, Vector3.zero, Quaternion.identity, self.effectMeta.cast_effect_time, self.owner:GetBuffTransform())
    end
  end
  if self.showWarnEffect and not self.useBulletWarnEffect then
    if self.targetSelfExcludeAlly then
      local pos = self.owner:GetPosition()
      if self.warnEffectPos == nil then
        self.warnEffectPos = Vector3.New(pos.x, 0.1, pos.z)
      else
        self.warnEffectPos.x = pos.x
        self.warnEffectPos.y = 0.1
        self.warnEffectPos.z = pos.z
      end
      local rot = Quaternion.New(self.owner:GetRotationXYZW())
      self.battleMgr:ShowEffectObj(self.warnEffect, self.warnEffectPos, rot, self.warnEffectTime)
    elseif self.target and self.target.unitType then
      local pos = self.target:GetPosition()
      if self.warnEffectPos == nil then
        self.warnEffectPos = Vector3.New(pos.x, 0.1, pos.z)
      else
        self.warnEffectPos.x = pos.x
        self.warnEffectPos.y = 0.1
        self.warnEffectPos.z = pos.z
      end
      self.battleMgr:ShowEffectObj(self.warnEffect, self.warnEffectPos, Quaternion.identity, self.warnEffectTime)
    end
  end
  if self.effectMeta.fireShakeParam and self.battleMgr.ShakeCameraWithParam then
    self.battleMgr:ShakeCameraWithParam(self.effectMeta.fireShakeParam)
  end
  if self.effectMeta.fireVibrateParam and #self.effectMeta.fireVibrateParam == 3 and self.battleMgr.DoVibration then
    self.battleMgr:DoVibration(self.effectMeta.fireVibrateParam[1], self.effectMeta.fireVibrateParam[2], self.effectMeta.fireVibrateParam[3])
  end
  self.audioCache = self.effectMeta.sound_id_fire_1
  if not self.useBulletFireEffect then
    self:PlayFireSoundImp(self.effectMeta.sound_id_fire_1)
  end
  if 0 < self.effectMeta.sound_id_fire_2 then
    DataCenter.LWSoundManager:PlaySound(self.effectMeta.sound_id_fire_2, false)
  end
end

function Skill:ShowFireEffectImp(firePoint)
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

function Skill:PlayFireSoundImp(id)
  if 0 < id then
    if self.chantTime then
      self.soundUid = DataCenter.LWSoundManager:PlaySound(id, 0 < self.chantTime)
    else
      self.soundUid = DataCenter.LWSoundManager:PlaySoundWithLimit(id, SoundLimitType.SkillFire)
    end
  end
end

function Skill:TryPlayCacheFireSound()
  self:PlayFireSoundImp(self.audioCache)
end

function Skill:ReFire()
  self:RealFire()
end

function Skill:RealFire()
  if self.meta.actionType == SkillActionType.Bullet then
    local bulletId, criticalBulletId = self:GetBulletId()
    if self.chantBullet then
      local removeList
      for bulletUid, bullet in pairs(self.chantBullet) do
        if bullet.meta.id ~= bulletId or bullet.meta.id ~= criticalBulletId then
          bullet:LogicDie()
          if removeList == nil then
            removeList = {}
          end
          removeList[#removeList + 1] = bulletUid
        end
      end
      if removeList then
        for i = 1, #removeList do
          self.chantBullet[removeList[i]] = nil
        end
      end
    end
    if self.chantBullet and table.count(self.chantBullet) > 0 then
      for _, bullet in pairs(self.chantBullet) do
        bullet:ReInit(self.forceLifeDistance)
      end
    else
      local params = {
        target = self.target
      }
      if self.warnEffectPos ~= nil then
        params.target = Vector3.New(self.warnEffectPos.x, 0, self.warnEffectPos.z)
      end
      if self.forceLifeDistance and 0 < self.forceLifeDistance then
        params.forceLifeDistance = self.forceLifeDistance
      end
      self.battleMgr.bulletManager:CreateBulletCreator(bulletId, self, params, criticalBulletId)
    end
  elseif self.meta.actionType == SkillActionType.Buff then
    if self.target then
      for _, target in pairs(self.target) do
        self:AddBuffImp(target)
      end
      if self.buffBulletId and 0 < self.buffBulletId then
        local targetsExceptSelf = {}
        for _, target in pairs(self.target) do
          if target ~= self.owner then
            table.insert(targetsExceptSelf, target)
          end
        end
        if not self.isPVP then
          self:SetRedirectTarget(targetsExceptSelf)
        end
        local params = {redirect = true}
        if self.forceLifeDistance and 0 < self.forceLifeDistance then
          params.forceLifeDistance = self.forceLifeDistance
        end
        self.battleMgr.bulletManager:CreateBulletCreator(self.buffBulletId, self, params, nil)
      end
    end
    if self.subSkills then
      for k, v in pairs(self.subSkills) do
        v:SetTarget(v:SearchTarget())
        v:RealFire()
      end
    end
  elseif self.meta.actionType == SkillActionType.Halo then
    if self.target then
      for _, target in pairs(self.target) do
        local propertyDic = self.meta:GetPropertyDictByLevel(self.level)
        target:AddHaloBuff(string.format("%s/%s", self.owner:GetGuid(), self.meta.id), propertyDic, self.meta.id)
      end
    end
  elseif self.meta.actionType == SkillActionType.Summon then
    if self.owner and self.owner.unitType and not table.IsNullOrEmpty(self.meta.actionParam) then
      for _, summonParam in ipairs(self.meta.actionParam) do
        if summonParam[1] == BattleSummonType.Monster and self.battleMgr.SummonMonster then
          self.battleMgr:SummonMonster(self.owner:GetPosition(), self.owner, summonParam[2], summonParam[3], summonParam[4])
        elseif summonParam[1] == BattleSummonType.Hero and self.battleMgr.SummonPet then
          self:InitSummonFormation()
          local count = summonParam[3]
          self.battleMgr:SummonPet(self.owner, summonParam[2], count, self)
        elseif summonParam[1] == BattleSummonType.RangeMonster and self.battleMgr.RangeSummonMonster then
          self.battleMgr:RangeSummonMonster(self.owner, summonParam[2], summonParam[3], summonParam[4], summonParam[5], summonParam[6], summonParam[7])
        elseif summonParam[1] == BattleSummonType.TriggerItem and self.battleMgr.SummonTriggerItem then
          self.battleMgr:SummonTriggerItem(self.owner:GetPosition(), self.owner, summonParam[2], summonParam[3], summonParam[4])
        elseif summonParam[1] == BattleSummonType.RangeTriggerItem and self.battleMgr.RangeSummonTriggerItem then
          self.battleMgr:RangeSummonTriggerItem(self.owner, summonParam[2], summonParam[3], summonParam[4], summonParam[5], summonParam[6], summonParam[7])
        end
      end
    end
  elseif self.meta.actionType == SkillActionType.ResetCD and not self.isPVP and self.target then
    for _, target in pairs(self.target) do
      local skillMgr = target.skillManager
      if skillMgr then
        local ultimateSkill = skillMgr:GetUltimateSkill()
        if ultimateSkill then
          ultimateSkill:ResetCooldown()
        end
      end
    end
  end
  if not self.isPVP then
    self.skillMgr:PassiveCast(SkillTriggerType.Cast, self.meta.group)
  end
end

function Skill:InitSummonFormation()
  if self.summonFormation ~= nil then
    return
  end
  if string.IsNullOrEmpty(self.meta.summon_formation) then
    return
  end
  self.summonFormation = SkillSummonFormation.New()
  self.summonFormation:Init(self.meta)
  self.summonSlotUnitIdMap = {}
end

function Skill:HasSummonFormation()
  return self.summonFormation ~= nil
end

function Skill:TryGetSummonSlot()
  if self.summonFormation then
    return self.summonFormation:TryGetFreeSlot()
  end
  return -1
end

function Skill:SetSummonSlotUnit(slot, unitId)
  if self.summonSlotUnitIdMap == nil then
    return
  end
  if self.summonSlotUnitIdMap[slot] then
    Logger.LogError("Skill:SetSummonSlotUnit duplicate skillId : " .. self.meta.id .. ". slot : " .. slot)
    return
  end
  self.summonSlotUnitIdMap[slot] = unitId
end

function Skill:GetSummonSlotPos(slot)
  if self.summonFormation then
    return self.summonFormation:GetSlotPos(slot)
  end
end

function Skill:ReleaseSlot(slot, unitId)
  if unitId and self.summonSlotUnitIdMap then
    local cacheUnit = self.summonSlotUnitIdMap[slot]
    if cacheUnit == nil or cacheUnit ~= unitId then
      Logger.LogError("Skill:ReleaseSlot invalid. skillId : " .. self.meta.id .. ". slot : " .. slot .. ". cacheUnit : " .. (cacheUnit or 0) .. ". paramUnit : " .. unitId)
      return
    end
    self.summonSlotUnitIdMap[slot] = nil
  end
  if self.summonFormation then
    self.summonFormation:ReleaseSlot(slot)
  end
end

function Skill:AddBuffImp(target)
  if self.buffMeta == nil or self.isPVP then
    return
  end
  if self.buffMeta.type == BuffType.Property then
    target:AddBuff(self.buff, self.level)
  elseif self.buffMeta.type == BuffType.BeTaunt then
    target:AddBuff(self.buff, self.owner)
  elseif self.buffMeta.type == BuffType.Shield then
    target:AddBuff(self.buff, self.owner)
  elseif self.buffMeta.type == BuffType.Dot then
    target:AddBuff(self.buff, self.owner)
  else
    target:AddBuff(self.buff)
  end
end

function Skill:GetCurAndMaxCD()
  return math.max(self.cd, 0), self.attackInterval
end

function Skill:IsBuffSkill()
  return self.meta.actionType == SkillActionType.Buff
end

function Skill:IsActiveSkill()
  return self.meta.apType == SkillAPType.Active
end

function Skill:IsSpecialStraightBulletType()
  return self.specialStraightBulletType
end

function Skill:DealBulletBuff(defender)
  if self.meta.buff_condition == BulletBuffType.None then
    return
  elseif self.meta.buff_condition == BulletBuffType.OnHit then
    if defender:GetCurBlood() > 0 and (self.meta.buff_param == HeroType.All or self.meta.buff_param == defender:GetHeroCamp()) then
      self:AddBuffImp(defender)
    end
  elseif self.meta.buff_condition == BulletBuffType.OnHitByChance then
    if defender:GetCurBlood() > 0 and math.random() < self.meta.buff_param * 0.01 then
      self:AddBuffImp(defender)
    end
  elseif self.meta.buff_condition == BulletBuffType.OnKill and defender:GetCurBlood() <= 0 then
    self:AddBuffImp(self.owner)
  end
end

function Skill:IsNormalAttack()
  return self.meta:IsNormalAttack()
end

function Skill:RegisterChantBullet(bulletUid, bullet)
  if self.chantBullet then
    self.chantBullet[bulletUid] = bullet
  end
end

function Skill:UnregisterChantBullet(bulletUid)
  if self.chantBullet then
    self.chantBullet[bulletUid] = nil
  end
end

function Skill:Redirect(srcPos, extraExclusions, legalizeTarget)
  if not self.battleMgr then
    return nil
  end
  if self.battleMgr:GetPVEType() == PVEType.World then
    return nil
  end
  if self.isPVP or self:IsBuffSkill() then
    if self.redirectTargets and #self.redirectTargets > 0 then
      self.target = table.remove(self.redirectTargets)
    end
  else
    self.target = self:SearchTargetPriorRange(srcPos, extraExclusions)
    if legalizeTarget then
      self.target = self:LegalizeTarget(self.target)
    end
  end
  return self.target
end

function Skill:TryRedirect()
  if not self.battleMgr then
    return nil
  end
  if self.battleMgr:GetPVEType() == PVEType.World then
    return nil
  end
  if (self.isPVP or self:IsBuffSkill()) and self.redirectTargets and #self.redirectTargets > 0 then
    self.target = table.remove(self.redirectTargets)
    return self.target
  end
  return nil
end

function Skill:SetTarget(target)
  self.target = target
end

function Skill:LegalizeTarget(target)
  if not target then
    return self.owner:GetPosition() + Vector3.New(0, 0, self.attackRange * math.random())
  end
  if self.meta.actionType == SkillActionType.Bullet and self.bulletMeta and not self.bulletMeta.hasRangeLimit then
    return target
  end
  local targetPos = target.unitType and target:GetPosition() or target
  local displace = targetPos - self.owner:GetPosition()
  local sqrDistance = Vector3.SqrMagnitude(displace)
  if sqrDistance > self.attackRangeSquare then
    local direction = Vector3.Normalize(displace)
    targetPos = self.owner:GetPosition() + direction * self.attackRange * math.random()
    return targetPos
  else
    return target
  end
end

function Skill:SearchTargetAroundAim(pos)
  if self.meta.actionType ~= SkillActionType.Bullet or not self.bulletMeta then
    return pos
  end
  if self.bulletMeta.mvt_type == BulletMoveType.Parabola and not self.bulletMeta.is_following then
    return self:LegalizeTarget(pos)
  end
  if not self.bulletMeta.is_following then
    return pos
  end
  if self.targetSelfExcludeAlly then
    return self.owner
  end
  local displace = pos - self.owner:GetPosition()
  local direction = Vector3.Normalize(displace)
  local midPoint = direction * 0.5 * self.meta.attack_range
  local unit = PveUtil.FindNearestUnitInSphereRange(self.battleMgr, midPoint, 0.5 * self.meta.attack_range, self.targetLayerMask, nil, pos)
  if unit then
    return unit
  else
    return self:LegalizeTarget(pos)
  end
end

function Skill:SearchTargetAroundAimIgnoreRange(pos)
  if self.meta.actionType ~= SkillActionType.Bullet or not self.bulletMeta then
    return pos
  end
  if not self.bulletMeta.is_following then
    return pos
  end
  if self.targetSelfExcludeAlly then
    return self.owner
  end
  local midPoint = 0.5 * (pos + self.owner:GetPosition())
  local unit = PveUtil.FindNearestUnitInSphereRange(self.battleMgr, midPoint, 0.5 * self.meta.attack_range, self.targetLayerMask, nil, pos)
  if unit then
    return unit
  else
    return pos
  end
end

function Skill:GetState()
  return self.state
end

function Skill:ResetCooldown()
  self.cd = 0
  self.state = SkillCastState.Ready
end

function Skill:ReduceCooldown(reduceValue)
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

function Skill:NotifyUltimateReady()
  if self.owner and self.owner.UltimateIsReady and self.owner:UltimateIsReady() and self.owner.index then
    EventManager:GetInstance():Broadcast(EventId.GF_zombie_battle_ult_ready, self.owner.index)
  end
end

function Skill:ForceLifeTime(distance)
  self.forceLifeDistance = distance
  if self.meta.horizontal_speed <= 0 then
    self.forceLifeTime = self.meta.damage_delay / 1000
  else
    self.forceLifeTime = distance * (1 / self.meta.horizontal_speed)
  end
end

function Skill:GetForceLifeTime(distance)
  distance = distance or 0
  if 0 >= self.meta.horizontal_speed then
    return self.meta.damage_delay / 1000
  else
    return distance * (1 / self.meta.horizontal_speed)
  end
end

function Skill:SetRedirectTarget(redirectTargets)
  self.redirectTargets = redirectTargets
end

function Skill:IsUltimate()
  return self.isUltimate
end

function Skill:CreateBullet(target, param, bulletId)
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

function Skill:GetBulletDamageFactor(bulletIndex)
  if self.damage and self.damage[bulletIndex] then
    return self.damage[bulletIndex]
  end
  return 0
end

function Skill:TWRealFire()
  local firePoint = self.owner:GetFirePoint()
  self.battleMgr:ShowEffectObj(self.effectMeta.fire_effect, nil, Quaternion.identity, self.fireEffectTime, firePoint)
  self.battleMgr:ShowEffectObj(self.effectMeta.cast_effect, self.owner:GetPosition(), Quaternion.identity, self.effectMeta.cast_effect_time)
  self:RealFire()
end

function Skill:ReplaceBullet(bulletId)
  if 0 < bulletId then
    local meta = DataCenter.PveBulletTemplateManager:GetTemplate(bulletId)
    if meta then
      self:Interrupt()
      self.bulletId = bulletId
      self.bulletMeta = meta
      if self.bulletMeta.mvt_type == BulletMoveType.Follow then
        self.chantTime = self.bulletMeta.lifetime
        if self.chantBullet == nil then
          self.chantBullet = {}
        end
      elseif self.chantTime then
        self.chantTime = nil
      end
    end
  end
end

function Skill:GetBulletId()
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

function Skill:TryPlaySkillPosTimeline()
  if self:HasMovingLogic() then
    if self.owner and self.owner.PlayPositionTimeline then
      self.owner:PlayPositionTimeline(self.meta.moving_logic)
    end
    return true
  end
  return false
end

function Skill:HasMovingLogic()
  if self.isMovingSkll == nil then
    self.isMovingSkll = self.meta and next(self.meta.moving_logic) ~= nil
  end
  return self.isMovingSkll
end

function Skill:HasBuffBullet()
  if self.buffBulletId and self.buffBulletId > 0 then
    return true
  end
  return false
end

function Skill:GetAnimNormal()
  local isTransforming = self.owner and self.owner:GetIsTransforming()
  if not isTransforming then
    return self.anim_normal
  else
    return self.anim_normal_transformed
  end
end

function Skill:GetAnimMove()
  local isTransforming = self.owner and self.owner:GetIsTransforming()
  if not isTransforming then
    return self.anim_move
  else
    return self.anim_move_transformed
  end
end

function Skill:HasAnim()
  local animNormal = self:GetAnimNormal()
  if not string.IsNullOrEmpty(animNormal) then
    return true
  end
  return false
end

function Skill:SetHasAnimState(anim)
  self.hasAnimState = anim
end

function Skill:CheckBeHitNewTriggerParam(param)
  if self.meta.triggerParam == nil or type(self.meta.triggerParam) ~= "table" then
    return false
  end
  local isTrigger = false
  for _, v in ipairs(self.meta.triggerParam) do
    local paramType = v[1]
    local paramValue = v[2]
    if paramType ~= nil and paramType ~= 0 then
      if v[1] == BeHitNewSkillTriggerParamType.MaxTriggerTime then
        if self.passiveTriggerTimes >= v[2] then
          return false
        end
      elseif isTrigger ~= true then
        if v[1] == BeHitNewSkillTriggerParamType.AlwaysTrigger then
          isTrigger = true
        elseif v[1] == BeHitNewSkillTriggerParamType.HurtBiggerThan then
          if param and param.hurt and paramValue <= param.hurt then
            isTrigger = true
          end
        elseif v[1] == BeHitNewSkillTriggerParamType.HurtSmallerThan then
          if param and param.hurt and paramValue >= param.hurt then
            isTrigger = true
          end
        elseif v[1] == BeHitNewSkillTriggerParamType.HpPercentSmallerThan and param and param.hpPercentBefore and param.hpPercentAfter then
          local requirePercent = paramValue / 10000
          if requirePercent < param.hpPercentBefore and requirePercent >= param.hpPercentAfter then
            isTrigger = true
          end
        end
      end
    end
  end
  return isTrigger
end

function Skill:SetDamageLimit(val)
  if self.isHaveDamageLimit then
    return
  end
  self.isHaveDamageLimit = true
  self.damageLimitNum = val
end

function Skill:CheckIsReachDamageLimit(damage)
  if not self.isHaveDamageLimit then
    return false
  end
  local lastDamageLimitNum = self.damageLimitNum
  self.damageLimitNum = self.damageLimitNum - damage
  if self.damageLimitNum < 0 then
    self.damageLimitNum = 0
  end
  if self.damageLimitNum > 0 then
    return false
  else
    return true, lastDamageLimitNum
  end
end

return Skill
