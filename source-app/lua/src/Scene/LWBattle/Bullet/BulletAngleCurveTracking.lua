local base = require("Scene.LWBattle.Bullet.BulletTrackingBase")
local BulletAngleCurveTracking = BaseClass("BulletAngleCurveTracking", base)
local BulletViewFacade = CS.PVEBattleLogic.Bullet.BulletViewFacade

function BulletAngleCurveTracking:Create()
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
  base.Create(self)
end

function BulletAngleCurveTracking:OnShow()
  local targetPos = self:GetTargetPos()
  if not targetPos then
    self:LogicDie()
    return
  end
  self.tempTargetPos = Vector3.New(targetPos.x, 0, targetPos.z)
  local leftRightCurveFactor = self.meta.mvt_type_para
  local minLeftRightCurveFactor = self.meta.mvt_type_para_2
  self.flySpeed = self.flySpeed + self.inertiaSpeed
  self.scaledTime = 0
  self.ctrlPoint1 = self.startPos
  self.displace = Vector3.New(targetPos.x - self.startPos.x, 0, targetPos.z - self.startPos.z)
  self.distance = self.displace:Magnitude()
  local targetForwardDirection = Vector3.Normalize(self.displace)
  local forwardDot = targetForwardDirection.x * self.initForward.x + targetForwardDirection.z * self.initForward.z
  local curInitForwardDis = math.max((1 - forwardDot) * leftRightCurveFactor, minLeftRightCurveFactor)
  self.ctrlPoint2 = Vector3.New(self.ctrlPoint1.x + self.initForward.x * curInitForwardDis, self.startPos.y, self.ctrlPoint1.z + self.initForward.z * curInitForwardDis)
  local forward = self.ctrlPoint2 - self.ctrlPoint1
  self.distance = self.distance * 2
  self.duration = self.distance / self.flySpeed
  BulletViewFacade.SetForward(self.viewHandle, forward.x, forward.y, forward.z)
end

return BulletAngleCurveTracking
