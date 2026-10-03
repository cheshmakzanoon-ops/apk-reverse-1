local base = require("Scene.LWBattle.Bullet.BulletBase")
local BulletTargetAngleCurve = BaseClass("BulletTargetAngleCurve", base)
local Const = require("Scene.LWBattle.Const")
local DIE_PERCENT = _ENV.DIE_PERCENT
local BulletViewFacade = CS.PVEBattleLogic.Bullet.BulletViewFacade

function BulletTargetAngleCurve:Create()
  self.initForward = Vector2.New(0, 1)
  if self.index == 1 then
    local firePoint
    local firePointNull = false
    if self.owner.GetFirePointById and self.firePointIndex and 0 < self.firePointIndex then
      firePoint, firePointNull = self.owner:GetFirePointById(self.firePointIndex)
    else
      firePoint, firePointNull = self.owner:GetFirePoint()
    end
    if not firePointNull then
      local firePointForward = firePoint.forward
      self.initForward = Vector2.New(firePointForward.x, firePointForward.z)
    end
    local ownerVelocity = self.owner:GetMoveVelocity()
    self.inertiaSpeed = Vector2.Dot(self.initForward, Vector2.New(ownerVelocity.x, ownerVelocity.z))
  else
    self.inertiaSpeed = 0
  end
  base.Create(self)
end

function BulletTargetAngleCurve:Destroy()
  base.Destroy(self)
end

function BulletTargetAngleCurve:OnUpdateCollision()
end

function BulletTargetAngleCurve:OnShow()
  if self.logicDie then
    return
  end
  local targetPos = self:GetTargetPos()
  if not targetPos then
    self:LogicDie()
    return
  end
  local leftRightCurveFactor = self.meta.mvt_type_para
  local minLeftRightCurveFactor = self.meta.mvt_type_para_2
  self.flySpeed = self.flySpeed + self.inertiaSpeed
  self.ctrlPoint1 = Vector2.New(self.startPos.x, self.startPos.z)
  self.displace = Vector2.New(targetPos.x - self.startPos.x, targetPos.z - self.startPos.z)
  self.distance = math.sqrt(self.displace.x * self.displace.x + self.displace.y * self.displace.y)
  local targetForwardDirection = Vector2.Normalize(self.displace)
  local forwardDot = targetForwardDirection.x * self.initForward.x + targetForwardDirection.y * self.initForward.y
  local curInitForwardDis = math.max((1 - forwardDot) * leftRightCurveFactor, minLeftRightCurveFactor)
  self.ctrlPoint2 = Vector2.New(self.ctrlPoint1.x + self.initForward.x * curInitForwardDis, self.ctrlPoint1.y + self.initForward.y * curInitForwardDis)
  self.ctrlPoint3 = Vector2.New(targetPos.x, targetPos.z)
  if self.viewHandle > 0 then
    BulletViewFacade.SetForward(self.viewHandle, self.initForward.x, 0, self.initForward.y)
  end
  self.lerpFactor = 0
end

function BulletTargetAngleCurve:OnUpdateTransform(deltaTime)
  local targetDist = self.flySpeed * deltaTime
  local tNext = self.lerpFactor + 0.01
  local curPosX = self.curBezierPosX or self.ctrlPoint1.x
  local curPosY = self.curBezierPosY or self.ctrlPoint1.y
  local tmpPosX, tmpPosY, tmpLookPosX, tmpLookPosY = self:BezierCal(tNext)
  local pDeltaX = tmpPosX - curPosX
  local pDeltaY = tmpPosY - curPosY
  local pDeltaMag = math.sqrt(pDeltaX * pDeltaX + pDeltaY * pDeltaY)
  if 1.0E-5 < pDeltaMag then
    tNext = tNext + (targetDist - pDeltaMag) * (tNext - self.lerpFactor) / pDeltaMag
  end
  self.lerpFactor = tNext
  tmpPosX, tmpPosY, tmpLookPosX, tmpLookPosY = self:BezierCal(tNext)
  self.curBezierPosX = tmpPosX
  self.curBezierPosY = tmpPosY
  self:SetPositionXYZ(tmpPosX, self.startPos.y, tmpPosY)
  local directionDeltaX = tmpLookPosX - tmpPosX
  local directionDeltaY = tmpLookPosY - tmpPosY
  local directionMag = math.sqrt(directionDeltaX * directionDeltaX + directionDeltaY * directionDeltaY)
  if 1.0E-5 < directionMag then
    BulletViewFacade.LookAt(self.viewHandle, tmpLookPosX, self.startPos.y, tmpLookPosY)
  end
  self:CollisionDetection()
  if self.lerpFactor >= DIE_PERCENT then
    self:LogicDie()
  end
end

function BulletTargetAngleCurve:BezierCal(t)
  if not self.tmpBezierVec1 then
    self.tmpBezierVec1 = Vector2.New(1, 0)
  end
  if not self.tmpBezierVec2 then
    self.tmpBezierVec2 = Vector2.New(1, 0)
  end
  local t1 = 1 - t
  local p0 = self.ctrlPoint1
  local p1 = self.ctrlPoint2
  local p2 = self.ctrlPoint3
  local tmpV1 = self.tmpBezierVec1
  local tmpV2 = self.tmpBezierVec2
  tmpV1.x = t1 * p0.x + t * p1.x
  tmpV1.y = t1 * p0.y + t * p1.y
  tmpV2.x = t1 * p1.x + t * p2.x
  tmpV2.y = t1 * p1.y + t * p2.y
  tmpV1.x = t1 * tmpV1.x + t * tmpV2.x
  tmpV1.y = t1 * tmpV1.y + t * tmpV2.y
  return tmpV1.x, tmpV1.y, tmpV2.x, tmpV2.y
end

return BulletTargetAngleCurve
