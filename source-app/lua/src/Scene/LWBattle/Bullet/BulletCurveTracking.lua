local base = require("Scene.LWBattle.Bullet.BulletTrackingBase")
local BulletCurveTracking = BaseClass("BulletCurveTracking", base)
local BulletViewFacade = CS.PVEBattleLogic.Bullet.BulletViewFacade

function BulletCurveTracking:OnShow()
  base.OnShow(self)
  if self.logicDie then
    return
  end
  local forward = self.ctrlPoint2 - self.ctrlPoint1
  local doubleHeight = 0
  if 0 < self.height then
    doubleHeight = self.height * 2
    self.distance = self.distance + doubleHeight
  else
    doubleHeight = self.distance * self.heightWidthRatio * 2
    self.distance = self.distance + doubleHeight
  end
  if self.meta.random_ring_range == 0 then
    self.ctrlPoint2.y = self.startPos.y + doubleHeight
  else
    local sideAngle = self.meta.random_ring_range == 1 and 90 or -90
    local forwardNormalize = Vector3.Normalize(forward)
    local sideDirection = Quaternion.Euler(0, sideAngle, 0) * forwardNormalize
    self.ctrlPoint2 = self.ctrlPoint2 + sideDirection * doubleHeight
  end
  if self.noCollision then
    self.duration = self:GetForceLifeTime()
  else
    self.duration = self.distance / self.flySpeed
  end
  BulletViewFacade.SetForward(self.viewHandle, forward.x, forward.y, forward.z)
end

return BulletCurveTracking
