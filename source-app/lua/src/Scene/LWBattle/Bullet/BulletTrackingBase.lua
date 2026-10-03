local base = require("Scene.LWBattle.Bullet.BulletBase")
local BulletTrackingBase = BaseClass("BulletTrackingBase", base)
local DIE_PERCENT = _ENV.DIE_PERCENT
local BulletViewFacade = CS.PVEBattleLogic.Bullet.BulletViewFacade

function BulletTrackingBase:Create()
  if self.index == 1 then
    local firePointForward = Vector3.zero
    local firePoint
    local firePointNull = false
    if self.owner.GetFirePointById and self.firePointIndex and self.firePointIndex > 0 then
      firePoint, firePointNull = self.owner:GetFirePointById(self.firePointIndex)
    else
      firePoint, firePointNull = self.owner:GetFirePoint()
    end
    if not firePointNull then
      firePointForward:ReturnPool()
      firePointForward = firePoint.forward
    end
    local forward = Vector3.New(firePointForward.x, 0, firePointForward.z)
    local ownerVelocity = self.owner:GetMoveVelocity()
    self.inertiaSpeed = Vector3.Dot(forward, ownerVelocity)
    ownerVelocity:ReturnPool()
    forward:ReturnPool()
  else
    self.inertiaSpeed = 0
  end
  base.Create(self)
end

function BulletTrackingBase:Destroy()
  base.Destroy(self)
  self.ctrlPoint1 = nil
  self.ctrlPoint2 = nil
  self.ctrlPoint3 = nil
  self.inertiaSpeed = nil
end

function BulletTrackingBase:OnUpdateCollision()
end

function BulletTrackingBase:OnShow()
  self.flySpeed = self.flySpeed + self.inertiaSpeed
  self.scaledTime = 0
  self.ctrlPoint1 = self.startPos
  local targetPos = self:GetTargetPos()
  if not targetPos then
    self:LogicDie()
    return
  end
  self.tempTargetPos = Vector3.New(targetPos.x, 0, targetPos.z)
  self.displace = Vector3.New(targetPos.x - self.startPos.x, 0, targetPos.z - self.startPos.z)
  self.distance = self.displace:Magnitude()
  if self.angleOffset then
    self.displace = self.displace * Quaternion.Euler(0, self.angleOffset, 0)
    self.ctrlPoint2 = self.startPos + self.displace * 0.5
  else
    self.ctrlPoint2 = self.startPos + self.displace * 0.5
  end
  if 0 < self.meta.spiral_loops then
    self.angleSpeed = self.flySpeed
    self.flySpeed = self.flySpeed / self.meta.spiral_loops
  end
  if self.noCollision then
    self.duration = self:GetForceLifeTime()
  else
    self.duration = self.distance / self.flySpeed
  end
end

function BulletTrackingBase:DoCollisionForTarget()
  if self.target.GetCurBlood and self.target:GetCurBlood() > 0 and self.target.GetCollider and self.target:GetCollider() then
    if self.base_type == BulletDurabilityType.Collide or self.base_type == BulletDurabilityType.CollideInfinity then
      local objId = self.target.guid
      if self:IsCollideDuplicately(objId) then
        return false
      else
        self.collidedIdList[objId] = true
        self:RealDoCollisionForTarget(self.target:GetCollider(), self:GetPosition(), self.target)
        self.collidedTimes = self.collidedTimes + 1
        return true
      end
    else
      self:RealDoCollisionForTarget(self.target:GetCollider(), self:GetPosition(), self.target)
      return true
    end
  end
  return false
end

function BulletTrackingBase:DoCollisionForBullet()
  self:DoHitShake()
  self:DoHitTriggerNewBullet()
  self:LogicDie()
end

function BulletTrackingBase:OnUpdateTransform(deltaTime)
  self.scaledTime = self.scaledTime + deltaTime
  local t = self.scaledTime
  self.ctrlPoint3 = self:GetTargetPos() or self.tempTargetPos
  local timePercent = t / self.duration
  if timePercent >= DIE_PERCENT then
    self:DoCollisionForTarget()
    self:DoCollisionForBullet()
    return
  end
  local progress
  if self.animCurve then
    progress = self.animCurve:Evaluate(timePercent)
  else
    progress = timePercent
  end
  if DataCenter.LWBattleManager:IsOpenReturnOpt() then
    local aX = self.ctrlPoint1.x + (self.ctrlPoint2.x - self.ctrlPoint1.x) * progress
    local aY = self.ctrlPoint1.y + (self.ctrlPoint2.y - self.ctrlPoint1.y) * progress
    local aZ = self.ctrlPoint1.z + (self.ctrlPoint2.z - self.ctrlPoint1.z) * progress
    local bX = self.ctrlPoint2.x + (-self.ctrlPoint2.x + self.ctrlPoint3.x) * progress
    local bY = self.ctrlPoint2.y + (-self.ctrlPoint2.y + self.ctrlPoint3.y) * progress
    local bZ = self.ctrlPoint2.z + (-self.ctrlPoint2.z + self.ctrlPoint3.z) * progress
    local curPosX = aX + (bX - aX) * progress
    local curPosY = aY + (bY - aY) * progress
    local curPosZ = aZ + (bZ - aZ) * progress
    BulletViewFacade.LookAt(self.viewHandle, bX, bY, bZ)
    if self.meta.spiral_loops > 0 then
      local angle = t * self.angleSpeed
      local rX, rY, rZ = BulletViewFacade.GetRight(self.viewHandle)
      self.worldRight = Vector3.New(rX, rY, rZ)
      local cosAngle = math.cos(angle)
      local offsetX = rX * cosAngle * self.meta.spiral_radius
      local offsetY = (rY * cosAngle + math.sin(angle)) * self.meta.spiral_radius
      local offsetZ = rZ * cosAngle * self.meta.spiral_radius
      curPosX = curPosX + offsetX
      curPosY = curPosY + offsetY
      curPosZ = curPosZ + offsetZ
    end
    self:SetPositionXYZ(curPosX, curPosY, curPosZ)
  else
    local a = self.ctrlPoint1 + (self.ctrlPoint2 - self.ctrlPoint1) * progress
    local b = self.ctrlPoint2 + (-self.ctrlPoint2 + self.ctrlPoint3) * progress
    local curPos = a + (b - a) * progress
    BulletViewFacade.LookAt(self.viewHandle, b.x, b.y, b.z)
    if self.meta.spiral_loops > 0 then
      local angle = t * self.angleSpeed
      local rX, rY, rZ = BulletViewFacade.GetRight(self.viewHandle)
      self.worldRight = Vector3.New(rX, rY, rZ)
      local offset = self.worldRight * math.cos(angle) + Vector3.New(0, math.sin(angle), 0)
      offset = offset * self.meta.spiral_radius
      curPos = curPos + offset
    end
    self:SetPositionXYZ(curPos.x, curPos.y, curPos.z)
  end
end

return BulletTrackingBase
