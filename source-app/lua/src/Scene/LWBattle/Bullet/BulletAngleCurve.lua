local base = require("Scene.LWBattle.Bullet.BulletBase")
local BulletAngleCurve = BaseClass("BulletAngleCurve", base)
local Const = require("Scene.LWBattle.Const")
local DIE_PERCENT = _ENV.DIE_PERCENT
local BulletViewFacade = CS.PVEBattleLogic.Bullet.BulletViewFacade

function BulletAngleCurve:Create()
  self.initForward = Vector3.New(0, 0, 1)
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
      self.initForward = Vector3.New(firePointForward.x, 0, firePointForward.z)
    end
    local ownerVelocity = self.owner:GetMoveVelocity()
    self.inertiaSpeed = Vector3.Dot(self.initForward, ownerVelocity)
  else
    self.inertiaSpeed = 0
  end
  local leftRightCurveFactor = self.meta.mvt_type_para
  self.flySpeed = self.inertiaSpeed + self.flySpeed
  self.straightDistance = self.flySpeed * self.lifetime
  local ownerForward = self.owner.transform.forward
  local forwardDot = ownerForward.x * self.initForward.x + ownerForward.z * self.initForward.z
  local curInitForwardDis = (1 - forwardDot) * leftRightCurveFactor
  local ownerForwardDis = math.max(0, self.straightDistance - curInitForwardDis)
  self.ctrlPoint1 = Vector2.New(self.startPos.x, self.startPos.z)
  self.ctrlPoint2 = Vector2.New(self.ctrlPoint1.x + self.initForward.x * curInitForwardDis, self.ctrlPoint1.y + self.initForward.z * curInitForwardDis)
  self.ctrlPoint3 = Vector2.New(self.ctrlPoint2.x + ownerForward.x * ownerForwardDis, self.ctrlPoint2.y + ownerForward.z * ownerForwardDis)
  base.Create(self)
end

function BulletAngleCurve:Destroy()
  base.Destroy(self)
end

function BulletAngleCurve:OnUpdateCollision()
  self:CollisionDetection()
end

function BulletAngleCurve:OnShow()
  if self.logicDie then
    return
  end
  if self.viewHandle > 0 then
    BulletViewFacade.SetForward(self.viewHandle, self.initForward.x, self.initForward.y, self.initForward.z)
  end
  self.totalLifeTime = self.lifetime
  self.scaledTime = 0
end

function BulletAngleCurve:OnUpdateTransform(deltaTime)
  self.scaledTime = self.scaledTime + deltaTime
  local t = self.scaledTime / self.totalLifeTime
  if t >= DIE_PERCENT then
    self:UpdateTransformImp(1)
    self:LogicDie()
    return
  end
  self:UpdateTransformImp(t)
end

function BulletAngleCurve:UpdateTransformImp(t)
  local tmpPosX, tmpPosY, tmpLookPosX, tmpLookPosY = self:BezierCal(t)
  BulletViewFacade.LookAt(self.viewHandle, tmpLookPosX, self.startPos.y, tmpLookPosY)
  self:SetPositionXYZ(tmpPosX, self.startPos.y, tmpPosY)
end

function BulletAngleCurve:BezierCal(t)
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

return BulletAngleCurve
