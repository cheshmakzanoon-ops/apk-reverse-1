local base = require("Scene.LWBattle.Bullet.BulletBase")
local BulletStaticLineTracking = BaseClass("BulletStaticLineTracking", base)
local BulletViewFacade = CS.PVEBattleLogic.Bullet.BulletViewFacade

function BulletStaticLineTracking:OnUpdateCollision()
end

function BulletStaticLineTracking:Create()
  self.lineRenderers = {}
  self.sourceTransform = nil
  self.dead_delay = 0
  self.is_special_dying = false
  self.constantY = 0
  self.collidedIdList = {}
  base.Create(self)
end

function BulletStaticLineTracking:Destroy()
  self.lineRenderers = nil
  self.sourceTransform = nil
  self.dead_delay = 0
  self.is_special_dying = false
  self.constantY = nil
  base.Destroy(self)
end

function BulletStaticLineTracking:SetEffectStartEndPosition()
  if not self.lineRenderers then
    return
  end
  local endPos = self:GetTargetPos()
  if not endPos then
    self:LogicDie()
    return
  end
  if not self.cachedStartVector3 then
    self.cachedStartVector3 = Vector3.New()
  end
  if not self.cachedEndVector3 then
    self.cachedEndVector3 = Vector3.New()
  end
  local startX, startY, startZ = 0, 0, 0
  if self.sourceTransform then
    startX, startY, startZ = self.sourceTransform:Get_position()
  end
  local targetColliderPosY = self:GetTargetColliderPosY()
  self.cachedStartVector3.x = startX
  self.cachedStartVector3.y = self.constantY
  self.cachedStartVector3.z = startZ
  self.cachedEndVector3.x = endPos.x
  self.cachedEndVector3.y = targetColliderPosY or self.constantY
  self.cachedEndVector3.z = endPos.z
  if not self.posArray then
    self.posArray = {}
  end
  self.posArray[1] = self.cachedStartVector3
  self.posArray[2] = self.cachedEndVector3
  for i = 1, #self.lineRenderers do
    self.lineRenderers[i]:SetPositions(self.posArray)
  end
end

function BulletStaticLineTracking:DoCollisionForBullet()
  self:DoHitShake()
  self:DoHitSound()
  if self.target then
    local _objId = self.target:GetGuid()
    self.collidedIdList[_objId] = true
    self:DoHitTriggerNewBulletUnit(self.target)
  end
end

function BulletStaticLineTracking:SpecialDie()
  if self.is_special_dying then
    return
  end
  self.is_special_dying = true
  self.lifetime = self.meta.dead_delay
end

function BulletStaticLineTracking:OnShow()
  if self.viewHandle <= 0 then
    return
  end
  self.is_special_dying = false
  local cs_lineRenderers = BulletViewFacade.GetLineRendererArray(self.viewHandle)
  if IsNull(cs_lineRenderers) then
    self:LogicDie()
    return
  end
  for i = 0, cs_lineRenderers.Length - 1 do
    self.lineRenderers[i + 1] = cs_lineRenderers[i]
  end
  local parentTransform, src
  if self.source then
    src = self.source
  else
    src = self.skill.owner
  end
  if src then
    if src.GetFirePointById and self.firePointIndex and 0 < self.firePointIndex then
      parentTransform = src:GetFirePointById(self.firePointIndex)
    elseif src.GetFirePoint then
      parentTransform = src:GetFirePoint()
    else
      parentTransform = src:GetTransform()
    end
  end
  self.constantY = nil
  if self.skill and self.skill.owner then
    local owner = self.skill.owner
    local firePoint
    if owner.GetFirePointById and self.firePointIndex and 0 < self.firePointIndex then
      firePoint = owner:GetFirePointById(self.firePointIndex)
    elseif owner.GetFirePoint then
      firePoint = owner:GetFirePoint()
    end
    if not IsNull(firePoint) then
      local posX, posY, posZ = firePoint:Get_position()
      self.constantY = posY
    end
  end
  if not self.constantY then
    if not IsNull(parentTransform) then
      local posX, posY, posZ = parentTransform:Get_position()
      self.constantY = posY
    else
      self.constantY = 0
    end
  end
  self.sourceTransform = parentTransform
  if IsNull(self.sourceTransform) then
    self:LogicDie()
  end
  if self.viewHandle > 0 then
    local worldPosX, worldPosY, worldPosZ = self.sourceTransform:Get_position()
    BulletViewFacade.SetPosition(self.viewHandle, worldPosX, self.constantY, worldPosZ)
    BulletViewFacade.ResetLocalRotation(self.viewHandle)
  end
  if self.target and self.target.unitType then
    self:DoCollisionForTarget(self.target)
    self:DoCollisionForBullet()
  end
  self:SetEffectStartEndPosition()
end

function BulletStaticLineTracking:OnUpdateTransform(deltaTime)
  self:SetEffectStartEndPosition()
  if self.is_special_dying then
    return
  end
  if self.target and self.target.unitType and self.target:GetCurBlood() <= 0 then
    self:SpecialDie()
    return
  end
  if self.source and self.source.unitType and 0 >= self.source:GetCurBlood() then
    self:SpecialDie()
    return
  end
  local startX, startY, startZ = 0, 0, 0
  if self.sourceTransform then
    startX, startY, startZ = self.sourceTransform:Get_position()
  end
  self:SetPositionXYZ(startX, self.constantY, startZ)
  local endPos = self:GetTargetPos()
  if endPos then
    local targetColliderPosY = self:GetTargetColliderPosY()
    BulletViewFacade.SetForward(self.viewHandle, endPos.x - startX, (targetColliderPosY or self.constantY) - startY, endPos.z - startZ)
  end
end

function BulletStaticLineTracking:InitCollider()
  return
end

function BulletStaticLineTracking:DoCollisionForTarget(target)
  if not target or not target.unitType then
    return
  end
  local obj = target
  if not obj or obj:GetCurBlood() <= 0 then
    return
  end
  local damage = self.skill:GetBulletDamageFactor(self.index) * self.meta.damage
  if damage <= 0 then
    return
  end
  local hitPoint = self:GetHitPoint(target)
  local hitDir = Vector3.New(hitPoint.x - self.startPos.x, 0, hitPoint.z - self.startPos.z)
  local hitBackDistance
  if 0 < self.meta.hit_back_distance then
    hitBackDistance = hitDir:SetNormalize() * self.meta.hit_back_distance
  end
  self:DealDamage(obj, damage, hitPoint, hitDir, hitBackDistance)
end

function BulletStaticLineTracking:GetTargetColliderPosY()
  if self.target and IsNotNull(self.target.collider) then
    return self.target.collider.bounds.max.y
  end
end

function BulletStaticLineTracking:GetHitPoint(target)
  if not target then
    return self.owner:GetPosition()
  elseif target.unitType then
    return target:GetPosition()
  elseif target.x and target.z then
    return target
  end
  return nil
end

return BulletStaticLineTracking
