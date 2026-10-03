local BulletBase = BaseClass("BulletBase")
local Resource = CS.GameEntry.Resource
local RIGHT = Vector3.right
local UP = Vector3.up
local FORWARD = Vector3.forward
local ZERO = Vector3.zero
local VIEW_INVALID_HANDLE = -1
local BattleColliderUtils = CS.BattleColliderUtils
local BulletViewFacade = CS.PVEBattleLogic.Bullet.BulletViewFacade
local BulletViewUtil = require("Scene.LWBattle.Bullet.BulletViewUtil")
local TornadoSlotData = require("Scene.LWBattle.Bullet.BulletAttachment.TornadoSlotData")

function BulletBase:__delete()
  self:Destroy()
end

function BulletBase:Destroy()
  BattleColliderUtils.RemoveBullet(self.objId)
  self.hasData = nil
  if self.warningEffectReq then
    self.warningEffectReq:Destroy()
    self.warningEffectReq = nil
    self.warningEffectTrans = nil
  end
  self:TryClearTornado()
  self.logic = nil
  self.bulletMgr = nil
  self.objId = nil
  self.meta = nil
  self.motherMeta = nil
  self.motherPos = nil
  self.skill = nil
  self.owner = nil
  self.index = nil
  self.noCollision = nil
  self.angleOffset = nil
  if self.startPos then
    self.startPos:ReturnPool()
  end
  self.startPos = nil
  self.curPos = nil
  self.animCurve = nil
  self.heightWidthRatio = nil
  self.height = nil
  self.flySpeed = nil
  self.lifetime = nil
  self.fanHalfSin = nil
  self:DestroyBulletView()
  self.bulletEffect = nil
  self.bulletEffectTrans = nil
  self.isBulletVisible = nil
  self.viewLoaded = nil
  self.noModelBullet = nil
  self.dotCD = nil
  self.dotMaxCD = nil
  self.colliderType = nil
  self.targetLayerMask = nil
  self.targetAllyExcludeSelf = nil
  self.targetSelfExcludeAlly = nil
  self.targetSearchType = nil
  self.target = nil
  self.collidedIdList = nil
  self.collidedTimes = nil
  self.base_type = nil
  self.bulletHp = nil
  self.inheritHitMap = nil
  self.collider = nil
  self.colliderRadius = nil
  self.dimension = nil
  if self.colliderCenterOffset then
    self.colliderCenterOffset:ReturnPool()
  end
  self.colliderCenterOffset = nil
  self.colliderHeight = nil
  self.prefabBulletOverride = nil
  if self.inertiaVelocity then
    self.inertiaVelocity:ReturnPool()
  end
  self.inertiaVelocity = nil
  self.offset = nil
  self.lifetime = nil
  self.logicDie = nil
  self.bulletScale = nil
  self.scaledTime = nil
  self.isCritical = nil
  self.firePointIndex = nil
  self.source = nil
  self.dead_delay = nil
  if self.curColliderCenterPos then
    self.curColliderCenterPos:ReturnPool()
  end
  self.curColliderCenterPos = nil
  self.lastColliderCenterPos = nil
  self.bulletEffectName = nil
  self.cacheTargetPosForNewBullet = nil
  self.hasTriggerAddBuff = nil
  self.recordBuffId = nil
  self.recordBuffCount = nil
end

function BulletBase:Init(logic, bulletMgr, objId, params)
  self.hasData = true
  self.logic = logic
  self.bulletMgr = bulletMgr
  self.objId = objId
  self.meta = params.meta
  self.metaId = self.meta.id
  self.motherMeta = params.motherMeta
  self.skill = params.skill
  self.owner = params.skill.owner
  self.index = params.index
  self.forceLifeTime = params.forceLifeTime
  self.noCollision = PVPType[self.logic:GetPVEType()]
  self.angleOffset = params.angleOffset
  local p = params.startPos
  self.startPos = Vector3.New(p.x, p.y, p.z)
  self.motherPos = params.motherPos or Vector3.New(self.startPos.x, self.startPos.y, self.startPos.z)
  if params.angleOffset then
    self.rotY = params.startAngle + params.angleOffset
  else
    self.rotY = params.startAngle
  end
  self.curPos = Vector3.New(self.startPos.x, self.startPos.y, self.startPos.z)
  self:InitAnimCurve()
  self.heightWidthRatio = self.meta.mvt_type_para
  self.height = self.meta.mvt_type_para_2
  self:InitLifeTime()
  if params.meta.melee_angle > 0 then
    self.fanHalfSin = math.sin(params.meta.melee_angle * 0.008725)
  end
  self.colliderCenterOffset = Vector3.zero
  self.isBulletVisible = nil
  self.viewLoaded = false
  self.viewHandle = VIEW_INVALID_HANDLE
  self.dotCD = 0
  self.dotMaxCD = 0
  self.colliderType = ColliderType.Sphere
  self.targetLayerMask, self.targetAllyExcludeSelf, self.targetSelfExcludeAlly, self.targetSearchType = PveUtil.GetTargetLayerBin(self.owner.searchType, self.meta.target_type_bin)
  self.colliderExclusion = self.targetAllyExcludeSelf and self.owner or nil
  self.target = params.target
  if self.meta.base_type == BulletDurabilityType.Collide then
    local limit = self.noCollision and 1 or self.meta.bullet_damage_count
    self.collidedIdList = {}
    self.collidedTimes = 0
    if limit < 0 then
      self.base_type = BulletDurabilityType.CollideInfinity
    else
      self.base_type = BulletDurabilityType.Collide
      self.bulletHp = limit
    end
  elseif self.meta.base_type == BulletDurabilityType.Time then
    self.base_type = BulletDurabilityType.Time
    self.dotMaxCD = self.meta.continuous_gap
  elseif self.meta.base_type == BulletDurabilityType.Once then
    self.base_type = BulletDurabilityType.Once
  end
  self.inheritHitMap = params.inheritHitMap
  self.isCritical = params.isCritical
  self.firePointIndex = params.firePointIndex
  self.source = params.source
  self.dead_delay = self.meta.dead_delay or 0
  self.isSplash = false
  if params.isSplash then
    self.isSplash = true
  end
  self.forceLifeDistance = params.forceLifeDistance
  self.needSetGrowShader = self.meta.bullet_born_scale
  self.recordBuffCount = 0
  self.recordBuffId = 0
  if 0 < self.meta.add_buff then
    local buffMeta = DataCenter.LWBuffTemplateManager:GetTemplate(self.meta.add_buff)
    if buffMeta then
      if 0 < self.meta.add_buff_limit then
        if 0 < buffMeta.add_buff_max_level then
          self.recordBuffId = buffMeta.add_buff_max_level
        else
          self.recordBuffId = buffMeta.id
        end
      end
      self.addBuffType = buffMeta.type
    else
      self.addBuffType = 0
    end
    if self.addBuffType == BuffType.Tornado then
      local tornadoParam = buffMeta.para
      if tornadoParam[1] then
        self.tornadoSlotData = TornadoSlotData.New()
        local slotCount = 10
        if 0 < self.meta.add_buff_limit then
          slotCount = self.meta.add_buff_limit
        end
        self.tornadoSlotData:Init(slotCount, tornadoParam[1], tornadoParam[3], tornadoParam[4], tornadoParam[2])
        self.tornadoElapsed = 0
      end
    end
  end
  self.getPosCurFrame = 0
end

function BulletBase:InitAnimCurve()
  self.animCurve = self.bulletMgr:StringToCurve(self.meta.motion_curve)
end

function BulletBase:InitLifeTime()
  if self.skill ~= nil and self.skill.isWorldTroopEffect then
    self.flySpeed = self.meta.bullet_fly_speed_world
    self.lifetime = self.meta.lifetime_world
  else
    self.flySpeed = self.meta.bullet_fly_speed
    self.lifetime = self.meta.lifetime
  end
end

function BulletBase:Create()
  self.viewLoaded = false
  self.viewHandle = VIEW_INVALID_HANDLE
  self:DoCreateSound()
  local bulletEffect, bulletEffectEmpty = self.meta:GetBulletEffect(self.owner.appearanceId)
  self.bulletEffectName = bulletEffect
  if not bulletEffectEmpty then
    self.isBulletVisible = false
    self:CreateBulletView(bulletEffect)
  else
    self.viewLoaded = true
    self.noModelBullet = true
    self.isBulletVisible = true
  end
  if self.meta and not self.meta.warning_effect_empty then
    self.warningEffectReq = Resource:InstantiateAsync(self.meta.warning_effect, ObjectPoolTag.Battle)
    self.warningEffectReq:completed("+", function(req)
      if req.gameObject then
        self.warningEffectTrans = req.gameObject.transform
        self:SyncWarningEffect()
      else
        Logger.LogError("\232\181\132\230\186\144\230\137\190\228\184\141\229\136\176\239\188\129\232\175\183\230\163\128\230\159\165\232\183\175\229\190\132\239\188\129" .. self.meta.warning_effect)
      end
    end)
  end
  return bulletEffectEmpty
end

function BulletBase:CreateBulletView(bulletEffect)
  local loaded = false
  local viewNameId = BulletViewUtil.GetBulletViewNameId(bulletEffect)
  self.viewHandle, loaded = BulletViewFacade.CreateBulletView(viewNameId)
  if not loaded then
  else
    self.viewLoaded = true
    self:OnLoaded(0)
  end
end

function BulletBase:DestroyBulletView()
  if self.viewHandle and self.viewHandle ~= VIEW_INVALID_HANDLE then
    self.viewHandle = BulletViewFacade.DestroyBulletView(self.viewHandle)
  end
  self.viewHandle = VIEW_INVALID_HANDLE
end

function BulletBase:InitBulletEffect()
  if self.skill.isWorldTroopEffect then
    self.bulletScale = self.meta.bullet_effect_size_world
  else
    self.bulletScale = self.meta.bullet_effect_size
  end
  if self.viewHandle > 0 then
    BulletViewFacade.SetLocalScale(self.viewHandle, self.bulletScale, self.bulletScale, self.bulletScale)
    BulletViewFacade.SetPosition(self.viewHandle, self.startPos.x, self.startPos.y, self.startPos.z)
    BulletViewFacade.SetEulerAngles(self.viewHandle, 0, self.rotY, 0)
  end
  self:SetBulletVisible(false)
  self:InitCollider()
  self:InitTrailRenderer()
end

function BulletBase:SyncWarningEffect()
  if self.target then
    if self.warningEffectTrans then
      local targetPos = self:GetTargetPos()
      if targetPos then
        self.warningEffectTrans.position = targetPos
      end
    end
  elseif self.warningEffectReq then
    self.warningEffectReq:Destroy()
    self.warningEffectReq = nil
    self.warningEffectTrans = nil
  end
end

function BulletBase:InitCollider()
  self.colliderRadius = 1
  self.dimension = self.bulletScale
  if self.meta.colliderRadius > 0 then
    self.colliderRadius = self.meta.colliderRadius
    self.dimension = self.bulletScale * self.colliderRadius
    self.curColliderCenterPos = self:GetPosition() * 1
    BattleColliderUtils.AddSphereBullet(self.viewHandle, self.objId, self.colliderRadius, self.targetLayerMask)
    return
  end
  local haveSphereCollider, sphereCollider = BulletViewFacade.TryGetSphereCollider(self.viewHandle)
  if haveSphereCollider then
    self.colliderType = ColliderType.Sphere
    self.collider = sphereCollider
    self.colliderRadius = self.collider.radius
    self.dimension = self.bulletScale * self.colliderRadius
    local x, y, z = BulletViewFacade.GetTransformPoint(self.viewHandle, self.collider.center.x, self.collider.center.y, self.collider.center.z)
    self.colliderCenterOffset = Vector3.New(x - self.startPos.x, y - self.startPos.y, z - self.startPos.z)
    self.curColliderCenterPos = self:GetPosition() + self.colliderCenterOffset
    BattleColliderUtils.AddSphereBullet(self.viewHandle, self.objId, self.bulletScale * self.colliderRadius, self.targetLayerMask)
    return
  end
  local haveCapsuleCollider, capsuleCollider = BulletViewFacade.TryGetCapsuleCollider(self.viewHandle)
  if haveCapsuleCollider then
    self.colliderType = ColliderType.Capsule
    self.collider = capsuleCollider
    self.colliderRadius = self.collider.radius
    self.colliderHeight = self.collider.height
    local dir = self.collider.direction
    local colliderDirection = RIGHT
    if dir == 1 then
      colliderDirection = UP
    elseif dir == 2 then
      colliderDirection = FORWARD
    end
    local localHalfVector = colliderDirection * (self.colliderHeight * 0.5)
    self.dimension = self.bulletScale * (self.colliderRadius + self.colliderHeight)
    local colliderCenter = self.collider.center
    local x, y, z = BulletViewFacade.GetTransformPoint(self.viewHandle, colliderCenter.x, colliderCenter.y, colliderCenter.z)
    self.colliderCenterOffset = Vector3.New(x - self.startPos.x, y - self.startPos.y, z - self.startPos.z)
    self.curColliderCenterPos = self:GetPosition() + self.colliderCenterOffset
    local colliderCenterOffsetX = colliderCenter.x
    local colliderCenterOffsetY = colliderCenter.y
    local colliderCenterOffsetZ = colliderCenter.z
    local localHalfVectorX = localHalfVector.x
    local localHalfVectorY = localHalfVector.y
    local localHalfVectorZ = localHalfVector.z
    BattleColliderUtils.AddCapsuleBullet(self.viewHandle, self.objId, self.bulletScale * self.colliderRadius, self.targetLayerMask, colliderCenterOffsetX - localHalfVectorX, colliderCenterOffsetY - localHalfVectorY, colliderCenterOffsetZ - localHalfVectorZ, colliderCenterOffsetX + localHalfVectorX, colliderCenterOffsetY + localHalfVectorY, colliderCenterOffsetZ + localHalfVectorZ)
    return
  end
  Logger.LogError("\229\173\144\229\188\185\230\178\161\230\156\137Sphere\230\136\150Capsule Collider \229\185\182\228\184\148\230\178\161\230\156\137\233\133\141\231\189\174radius\239\188\140\229\173\144\229\188\185\229\144\141\239\188\154" .. (self.bulletEffectName or ""))
end

function BulletBase:InitTrailRenderer()
  BulletViewFacade.ClearTrailRenderer(self.viewHandle)
end

function BulletBase:Show()
  self:SetBulletVisible(true)
end

function BulletBase:OnUpdate(collide, deltaTime)
  if not self.viewLoaded then
    ProfilerUtil.BeginSample("BulletCheckLoaded")
    local loaded, tmpDotMaxCD = BulletViewFacade.IsLoaded(self.viewHandle)
    ProfilerUtil.EndSample()
    if not loaded then
      return
    end
    self.viewLoaded = true
    self:OnLoaded(tmpDotMaxCD)
    return
  end
  if self.tornadoElapsed then
    self.tornadoElapsed = self.tornadoElapsed + deltaTime
  end
  if self:CheckDeath(deltaTime) or not self.isBulletVisible then
    return
  end
  self:OnUpdateCollision(collide, deltaTime)
  if not self.hasData then
    return
  end
  ProfilerUtil.BeginSample("BulletOnUpdateTransform")
  self:OnUpdateTransform(deltaTime)
  ProfilerUtil.EndSample()
  self:SyncWarningEffect()
end

function BulletBase:OnLoaded(tmpDotMaxCD)
  self:InitBulletEffect()
  self:Show()
  self:OnShow()
end

function BulletBase:OnShow()
end

function BulletBase:OnUpdateCollision(collider, deltaTime)
  if self.noCollision then
    return
  end
  self.dotCD = self.dotCD - deltaTime
  if self.dotCD <= 0 then
    self.dotCD = self.dotMaxCD
    ProfilerUtil.BeginSample("BulletCollisionDetection")
    if collider ~= false or self.noModelBullet and self.isBulletVisible then
      self:CollisionDetection()
    end
    ProfilerUtil.EndSample()
    if self.base_type == BulletDurabilityType.Once then
      self:LogicDie()
    end
  end
end

function BulletBase:OnUpdateTransform(deltaTime)
end

function BulletBase:CollisionDetection()
  ProfilerUtil.BeginSample("BulletGetCollideList")
  local colliderCount, colliderList = self.bulletMgr:TryGetCollideList(self.objId)
  local cnt = 0
  if colliderCount then
    cnt = colliderCount
  end
  ProfilerUtil.EndSample()
  if cnt <= 0 then
    return
  end
  self.cacheTargetPosForNewBullet = nil
  ProfilerUtil.BeginSample("BulletGetColliderCenterWorldPos")
  local posX, posY, posZ = self:GetColliderCenterWorldPos()
  self.curColliderCenterPos.x = posX
  self.curColliderCenterPos.y = posY
  self.curColliderCenterPos.z = posZ
  ProfilerUtil.EndSample()
  local remainCount = self.meta.bullet_collide_limit
  local hasCollision = false
  if cnt == 1 then
    if 0 < remainCount then
      local colliderObjId = colliderList
      ProfilerUtil.BeginSample("BulletDoCollisionForTargetObjId")
      local collideSuccess = self:DoCollisionForTargetObjId(colliderObjId, self.curColliderCenterPos)
      ProfilerUtil.EndSample()
      hasCollision = collideSuccess or hasCollision
      if collideSuccess then
        remainCount = remainCount - 1
      end
    end
  else
    for i = 1, cnt do
      if remainCount <= 0 then
        break
      end
      local colliderObjId = colliderList[i]
      ProfilerUtil.BeginSample("BulletDoCollisionForTargetObjId")
      local collideSuccess = self:DoCollisionForTargetObjId(colliderObjId, self.curColliderCenterPos)
      ProfilerUtil.EndSample()
      hasCollision = collideSuccess or hasCollision
      if collideSuccess then
        remainCount = remainCount - 1
      end
    end
  end
  ProfilerUtil.BeginSample("BulletDoCollisionForBullet")
  if hasCollision then
    self:DoCollisionForBullet()
  end
  ProfilerUtil.EndSample()
end

function BulletBase:NormalizeDirection(v, magnitude)
  if 1.0E-5 < magnitude then
    v.x = v.x / magnitude
    v.y = v.y / magnitude
    v.z = v.z / magnitude
    return
  end
  v.x = 0
  v.y = 0
  v.z = 0
end

function BulletBase:DoCollisionForTarget(collider, bulletEffectPos)
  if not self:TargetFilter(collider) then
    return false
  end
  local trigger = collider:GetComponent(typeof(CS.CitySpaceManTrigger))
  if trigger ~= nil and trigger.ObjectId ~= 0 then
    local objId = trigger.ObjectId
    return self:DoCollisionForTargetObjId(objId, bulletEffectPos)
  end
  return false
end

function BulletBase:DoCollisionForTargetObjId(objId, bulletEffectPos)
  local obj = self.bulletMgr:GetUnit(objId)
  local searchType
  if obj then
    searchType = obj:GetSearchType()
  end
  if self.targetSearchType and searchType and self.targetSearchType & searchType == 0 then
    return false
  end
  if obj ~= nil and 0 < obj:GetCurBlood() and obj ~= self.colliderExclusion then
    if self.base_type == BulletDurabilityType.Collide or self.base_type == BulletDurabilityType.CollideInfinity then
      if self:IsCollideDuplicately(objId) then
        return false
      else
        ProfilerUtil.BeginSample("BulletRealDoCollision")
        self:RealDoCollisionForTarget(obj:GetCollider(), bulletEffectPos, obj)
        ProfilerUtil.EndSample()
        self.collidedIdList[objId] = true
        self.collidedTimes = self.collidedTimes + 1
        return true
      end
    else
      ProfilerUtil.BeginSample("BulletRealDoCollision")
      self:RealDoCollisionForTarget(obj:GetCollider(), bulletEffectPos, obj)
      ProfilerUtil.EndSample()
      return true
    end
  end
  return false
end

function BulletBase:IsCollideDuplicately(objId)
  if self.collidedIdList and self.collidedIdList[objId] then
    return true
  end
  if self.inheritHitMap and self.inheritHitMap[objId] then
    return true
  end
  return false
end

function BulletBase:RealDoCollisionForTarget(collider, bulletEffectPos, obj)
  if self.skill:IsNil() then
    return
  end
  local damage = self.skill:GetBulletDamageFactor(self.index) * self.meta.damage
  if self.collidedTimes and self.collidedTimes > 0 then
    damage = damage * self.meta.bullet_damage_attenuation ^ self.collidedTimes
  end
  if damage <= 0 then
    return
  end
  local hitPointX, hitPointY, hitPointZ = BattleColliderUtils.GetColliderClosestPoint(collider, bulletEffectPos.x, bulletEffectPos.y, bulletEffectPos.z)
  local hitDir = Vector3.New(hitPointX - self.startPos.x, 0, hitPointZ - self.startPos.z)
  if self.cacheTargetPosForNewBullet == nil and obj.GetPosition then
    local objPos = obj:GetPosition()
    self.cacheTargetPosForNewBullet = Vector3.New(objPos.x, self.curPos.y, objPos.z)
  end
  local hitBackDistance
  if 0 < self.meta.hit_back_distance then
    hitBackDistance = hitDir:SetNormalize() * self.meta.hit_back_distance
  end
  ProfilerUtil.BeginSample("BulletDealDamage")
  self:TryTriggerAddBuff(obj)
  self:DealDamage(obj, damage, Vector3.New(hitPointX, hitPointY, hitPointZ), hitDir, hitBackDistance)
  ProfilerUtil.EndSample()
end

function BulletBase:DealDamage(obj, damage, hitPoint, hitDir, hitBackDistance)
  local params = self.bulletMgr:GetDealDamageParamTable()
  params.attacker = self.owner
  params.defender = obj
  params.bulletMeta = self.meta
  params.damageMultiplier = damage
  params.hitPoint = hitPoint
  params.hitDir = hitDir
  params.whiteTime = self.meta.white_time
  params.stiffTime = self.meta.hit_stiff_time
  params.hitBackDistance = hitBackDistance
  params.hitEff = self.meta.hit_effect
  params.skill = self.skill
  params.isCritical = self.isCritical
  params.isSplash = self.isSplash
  params.exType = nil
  params.exValue = nil
  return self.bulletMgr:DealDamage(params)
end

function BulletBase:DoCollisionForBullet()
  self:DoHitShake()
  self:DoHitSound()
  self:DoHitTriggerNewBullet()
  self:RefreshBulletHp()
end

function BulletBase:DoCreateSound()
  if self.meta.sound_id_create > 0 then
    DataCenter.LWSoundManager:PlaySoundWithLimit(self.meta.sound_id_create, SoundLimitType.BulletCreate)
  end
end

function BulletBase:DoHitSound()
  if self.meta.sound_id_hit > 0 then
    DataCenter.LWSoundManager:PlaySoundWithLimit(self.meta.sound_id_hit, SoundLimitType.BulletHit)
  end
end

function BulletBase:TriggerDeathRattle()
  if self.skill:IsNil() then
    return
  end
  if not table.IsNullOrEmpty(self.meta.death_rattle_bullet) then
    local _index = self.index + 1
    for i = 1, #self.meta.death_rattle_bullet do
      local bulletId = self.meta.death_rattle_bullet[i]
      if 0 < bulletId then
        local bulletTemplate = DataCenter.PveBulletTemplateManager:GetTemplate(bulletId)
        if bulletTemplate and bulletTemplate.mvt_type == BulletMoveType.Revert then
          self.bulletMgr:CreateBulletCreator(bulletId, self.skill, {
            pos = self:GetPosition(),
            angle = self:GetAngle(),
            index = _index,
            redirect = false,
            target = self.owner
          })
        else
          self.bulletMgr:CreateBulletCreator(bulletId, self.skill, {
            pos = self:GetPosition(),
            angle = self:GetAngle(),
            index = _index,
            redirect = true
          })
        end
        _index = _index + 1
      end
    end
  end
  if self.meta.hit_monster_born and self.owner and self.logic and self.logic.SummonMonster then
    self.logic:SummonMonster(self:GetPosition(), self.owner, self.meta.hit_monster_born[1], self.meta.hit_monster_born[2], self.meta.hit_monster_born[3])
  end
end

function BulletBase:CheckDeath(deltaTime)
  self.lifetime = self.lifetime - deltaTime
  if self.lifetime <= 0 then
    if not self.logicDie then
      self:PlayDissipateEffect()
      self:LogicDie()
    else
      self:RenderDie()
    end
    return true
  end
  return self.logicDie
end

function BulletBase:LogicDie()
  if not self.hasData then
    return
  end
  if self.logicDie then
    return
  end
  self.logicDie = true
  self:TriggerDeathRattle()
  if self.dead_delay > 0 then
    self.lifetime = self.dead_delay
    self:OnLogicDie()
  else
    self:RenderDie()
  end
end

function BulletBase:OnLogicDie()
end

function BulletBase:RenderDie()
  self.bulletMgr:RemoveBullet(self)
end

function BulletBase:DoHitShake()
  if self.meta.hitShakeParam then
    self.bulletMgr:ShakeCameraWithParam(self.meta.hitShakeParam)
  end
end

function BulletBase:DoHitTriggerNewBullet(pos)
  pos = pos or self:GetPosition()
  if self.motherMeta and self.motherMeta.second_attack > 0 and self.index <= self.motherMeta.second_attack_count then
    local exclusions = {}
    table.merge(exclusions, self.collidedIdList)
    if not self.motherMeta.second_attack_repeat then
      table.merge(exclusions, self.inheritHitMap)
    end
    self:CreateChildBulletCreator(pos, exclusions)
  end
end

function BulletBase:CreateChildBulletCreator(pos, exclusions)
  local newTarget
  local newPos = pos
  if self.motherMeta.second_attack_angle == nil or self.motherMeta.second_attack_angle <= 0 then
    newTarget = self.skill:Redirect(pos, exclusions, false)
  else
    newTarget = self.skill:TryRedirect()
    if not newTarget then
      if self.cacheTargetPosForNewBullet then
        newPos = self.cacheTargetPosForNewBullet
      end
      local forward = (newPos - self.motherPos).normalized
      if forward then
        newTarget = self.skill:SearchTargetForBulletWithAngle(newPos, exclusions, forward.normalized, self.motherMeta.second_attack_angle * 0.5, self.motherMeta.second_attack_limit_min, self.motherMeta.second_attack_limit_max)
      end
    end
  end
  if not newTarget then
    return
  end
  local aimDir = newTarget:GetPosition() - newPos
  aimDir.y = 0
  local aimDirNor = aimDir.normalized
  local angle = 0
  if aimDir:SqrMagnitude() > 1.0E-6 then
    local rotation = Quaternion.LookRotation(aimDirNor)
    angle = rotation.eulerAngles.y
  end
  aimDirNor:ReturnPool()
  aimDir:ReturnPool()
  self.bulletMgr:CreateBulletCreator(self.motherMeta.second_attack, self.skill, {
    pos = newPos,
    angle = angle,
    target = newTarget,
    index = self.index + 1,
    redirect = false,
    exclusions = exclusions,
    mother = self.motherMeta,
    isSplash = true,
    motherPos = self.motherPos
  })
end

function BulletBase:DoHitTriggerNewBulletUnit(source)
  source = source or self.owner
  if self.motherMeta and self.motherMeta.second_attack > 0 and self.index <= self.motherMeta.second_attack_count then
    local exclusions = {}
    table.merge(exclusions, self.collidedIdList)
    if not self.motherMeta.second_attack_repeat then
      table.merge(exclusions, self.inheritHitMap)
    end
    self:CreateChildBulletUnitCreator(source, exclusions)
  end
end

function BulletBase:CreateChildBulletUnitCreator(source, exclusions)
  if not source then
    return
  end
  local newTarget
  local pos = source:GetPosition()
  local newPos = pos
  if self.motherMeta.second_attack_angle == nil or self.motherMeta.second_attack_angle <= 0 then
    newTarget = self.skill:Redirect(pos, exclusions, false)
  else
    newTarget = self.skill:TryRedirect()
    if not newTarget then
      if self.cacheTargetPosForNewBullet then
        newPos = self.cacheTargetPosForNewBullet
      end
      local forward = (newPos - self.motherPos).normalized
      if forward then
        newTarget = self.skill:SearchTargetForBulletWithAngle(newPos, exclusions, forward.normalized, self.motherMeta.second_attack_angle * 0.5, self.motherMeta.second_attack_limit_min, self.motherMeta.second_attack_limit_max)
      end
    end
  end
  if not newTarget then
    return
  end
  local aimDir = newTarget:GetPosition() - newPos
  aimDir.y = 0
  local aimDirNor = aimDir.normalized
  local angle = 0
  if aimDir:SqrMagnitude() > 1.0E-6 then
    local rotation = Quaternion.LookRotation(aimDirNor)
    angle = rotation.eulerAngles.y
  end
  aimDirNor:ReturnPool()
  aimDir:ReturnPool()
  self.bulletMgr:CreateBulletCreator(self.motherMeta.second_attack, self.skill, {
    pos = pos,
    angle = angle,
    target = newTarget,
    index = self.index + 1,
    redirect = false,
    exclusions = exclusions,
    mother = self.motherMeta,
    source = source,
    isSplash = true
  })
end

function BulletBase:RefreshBulletHp()
  if self.base_type == BulletDurabilityType.Collide then
    self.bulletHp = self.bulletHp - 1
    if self.bulletHp <= 0 then
      self:LogicDie()
    end
  end
end

function BulletBase:SetBulletVisible(visible)
  self.isBulletVisible = visible
  if self.viewHandle > 0 then
    BulletViewFacade.SetVisible(self.viewHandle, visible)
  end
end

function BulletBase:GetTargetPos()
  if not self.target then
    return self.owner:GetPosition()
  elseif self.target.unitType then
    if self.target.useColliderPos and self.target.GetColliderPos then
      return self.target:GetColliderPos()
    end
    return self.target:GetPosition()
  elseif self.target.x and self.target.z then
    return self.target
  end
  return nil
end

function BulletBase:TargetFilter(collider)
  if not self.fanHalfSin then
    return true
  end
  local cannonTrans = self.owner.cannon
  if not cannonTrans then
    return false
  end
  local targetPos = collider.transform.position
  targetPos.y = 0
  local ownerPos = self.owner:GetPosition()
  ownerPos.y = 0
  local targetDir = targetPos - ownerPos
  local targetDirNor = Vector3.Normalize(targetDir)
  local cannonWorldForward
  if self.owner.localForward then
    cannonWorldForward = cannonTrans:TransformDirection(self.owner.localForward)
  else
    cannonWorldForward = cannonTrans.forward
  end
  local cross = Vector3.Cross(cannonWorldForward, targetDirNor)
  local deg = math.abs(cross.y)
  cross:ReturnPool()
  if deg < self.fanHalfSin and 0 < Vector3.Dot(cannonWorldForward, targetDirNor) then
    targetDirNor:ReturnPool()
    return true
  else
    targetDirNor:ReturnPool()
    return false
  end
end

function BulletBase:GetPosition()
  return self.curPos
end

function BulletBase:SetPosition(pos)
  self.curPos = pos
  if self.viewHandle > 0 then
    BulletViewFacade.SetLocalPosition(self.viewHandle, pos.x, pos.y, pos.z)
  end
end

function BulletBase:SetPositionXYZ(x, y, z)
  self.curPos:Set(x, y, z)
  if self.viewHandle > 0 then
    BulletViewFacade.SetLocalPosition(self.viewHandle, x, y, z)
  end
end

function BulletBase:SetPositionXYZDelay(x, y, z)
  self.curPos:Set(x, y, z)
end

function BulletBase:GetAngle()
  if self.viewHandle > 0 and self.viewLoaded then
    return BulletViewFacade.GetEulerAnglesY(self.viewHandle)
  else
    return 0
  end
end

function BulletBase:GetColliderCenterWorldPos()
  local selfPos = self:GetPosition()
  return selfPos.x + self.colliderCenterOffset.x, selfPos.y + self.colliderCenterOffset.y, selfPos.z + self.colliderCenterOffset.z
end

function BulletBase:GetForceLifeTime()
  if self.forceLifeTime then
    return self.forceLifeTime
  end
  if self.skill and self.skill.forceLifeTime then
    return self.skill.forceLifeTime
  end
  return 0
end

function BulletBase:GetForceLifeDistance()
  if self.forceLifeDistance then
    return self.forceLifeDistance
  end
  if self.skill and self.skill.forceLifeDistance then
    return self.skill.forceLifeDistance
  end
  return 0
end

function BulletBase:IsValidMonsterType(defender)
  if not self.meta or self.meta.add_buff <= 0 then
    return false
  end
  if not defender or not defender.monsterMeta then
    return false
  end
  if table.count(self.meta.add_enemy_type) == 0 then
    return false
  end
  local targetMonsterType = defender.monsterMeta.monster_type
  for i, monsterType in ipairs(self.meta.add_enemy_type) do
    if monsterType == targetMonsterType then
      return true
    end
  end
  return false
end

function BulletBase:TryTriggerAddBuff(defender)
  if not self:IsValidMonsterType(defender) then
    return
  end
  local addBuff = self:AddBuffToDefender(defender)
  if addBuff and self.recordBuffId == addBuff.meta.id then
    self:RecordTriggerNewBuffCount(defender, addBuff.id)
  end
end

function BulletBase:AddBuffToDefender(defender)
  local achieveLimit = self.meta.add_buff_limit > 0 and self.recordBuffCount >= self.meta.add_buff_limit or false
  if self.meta.add_buff_mode == BulletAddBuffMode.TriggerAfterCausedDamage then
    return defender:AddBuff(self.meta.add_buff, nil, achieveLimit, BuffFromSourceType.Bullet, self.objId)
  elseif self.meta.add_buff_mode == BulletAddBuffMode.TriggerOnceAfterCausedDamage then
    if not self.hasTriggerAddBuff then
      self.hasTriggerAddBuff = {}
    end
    if not self.hasTriggerAddBuff[defender.guid] then
      self.hasTriggerAddBuff[defender.guid] = true
      return defender:AddBuff(self.meta.add_buff, nil, achieveLimit, BuffFromSourceType.Bullet, self.objId)
    end
  end
  return nil
end

function BulletBase:RecordTriggerNewBuffCount(defender, buffUid)
  self.recordBuffCount = self.recordBuffCount + 1
end

function BulletBase:UpdateTriggerNewBuffCountAfterBuffRemove(buffId)
  if not self.hasData then
    return
  end
  if self.recordBuffId == buffId then
    self.recordBuffCount = self.recordBuffCount - 1
  end
end

function BulletBase:TryGetTornadoSlot(uniId)
  if self.tornadoSlotData == nil then
    return -1
  end
  return self.tornadoSlotData:TryGetSlot(uniId)
end

function BulletBase:TryCalcTornado(slotIndex)
  if self.tornadoSlotData == nil then
    return nil
  end
  return self.tornadoSlotData:Calc(slotIndex, self.tornadoElapsed)
end

function BulletBase:TryReleaseTornadoSlot(unitId, slotIndex)
  if self.tornadoSlotData == nil then
    return
  end
  self.tornadoSlotData:ReleaseSlot(unitId, slotIndex)
end

function BulletBase:TryClearTornado()
  if self.addBuffType and self.addBuffType == BuffType.Tornado and self.tornadoSlotData ~= nil and self.logic.GetUnit then
    local tornadoSlotUnitToIndex = self.tornadoSlotData.tornadoSlotUnitToIndex
    for monsterId, _ in pairs(tornadoSlotUnitToIndex) do
      local unit = self.logic:GetUnit(monsterId)
      if unit and unit.RemoveAllBuffByType then
        unit:RemoveAllBuffByType(BuffType.Tornado)
      end
    end
  end
  self.tornadoSlotData = nil
  self.addBuffType = nil
end

function BulletBase:PlayDissipateEffect()
  if self.skill ~= nil and self.skill.isWorldTroopEffect then
    return
  end
  local path = self.meta.disappear_effect
  if string.IsNullOrEmpty(path) then
    return
  end
  local pos = self:GetPosition()
  local rot = Vector3.New(0, self:GetAngle(), 0)
  if self.logic and self.logic.ShowEffectObj then
    self.logic:ShowEffectObj(path, pos, rot)
  end
end

return BulletBase
