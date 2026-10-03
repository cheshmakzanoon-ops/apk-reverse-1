local base = require("Scene.LWBattle.Bullet.BulletBase")
local BulletCircleRandom = BaseClass("BulletCircleRandom", base)

function BulletCircleRandom:InitAnimCurve()
  self.circleMoveRadius = self.meta.mvt_type_para
  self.circleMoveSpeed = self.meta.mvt_type_para_2
  self.circleMoveMinX = math.mininteger
  self.circleMoveMaxX = math.maxinteger
  if self.logic.GetMinMaxMoveX then
    self.circleMoveMinX, self.circleMoveMaxX = self.logic:GetMinMaxMoveX()
  end
  self.circleMoveMinDist = 0.2
  self.circleMoveStartPos = Vector3.New(0, 0, 0)
  self.circleMoveTargetPos = Vector3.New(0, 0, 0)
  self.circleMoveTime = 0
  self.circleMoveTimer = 0
  self.circleMoveValid = false
end

function BulletCircleRandom:CollisionDetection()
  if self.viewHandle > 0 then
    base.CollisionDetection(self)
  else
    local collider = self.target:GetCollider()
    if collider then
      self:DoCollisionForTarget(collider, self.startPos)
      self:DoCollisionForBullet()
    end
  end
end

function BulletCircleRandom:OnShow()
  base.OnShow(self)
  self.circleMoveValid = true
  self:FindNewTarget()
end

function BulletCircleRandom:FindNewTarget()
  local angle = Mathf.Random(0, 360) * Mathf.Deg2Rad
  local randomRadius = Mathf.Random(6, 10) / 10 * self.circleMoveRadius
  local offX = Mathf.Cos(angle) * randomRadius
  local offZ = Mathf.Sin(angle) * randomRadius
  self.circleMoveTargetPos.x = self.startPos.x + offX
  self.circleMoveTargetPos.z = self.startPos.z + offZ
  if self.circleMoveTargetPos.x < self.circleMoveMinX or self.circleMoveTargetPos.x > self.circleMoveMaxX then
    local range = (self.circleMoveMaxX - self.circleMoveMinX) * 0.5
    local mid = (self.circleMoveMaxX + self.circleMoveMinX) * 0.5
    local d = (self.circleMoveTargetPos.x - mid) / range
    local ex = Mathf.Exp(d)
    local enx = Mathf.Exp(-d)
    local tanh = (ex - enx) / (ex + enx)
    self.circleMoveTargetPos.x = mid + tanh * range
  end
  self.circleMoveStartPos.x = self.curPos.x
  self.circleMoveStartPos.z = self.curPos.z
  local dis = Vector3.Distance(self.circleMoveStartPos, self.circleMoveTargetPos)
  self.circleMoveTime = dis / self.circleMoveSpeed
  self.circleMoveTimer = 0
end

function BulletCircleRandom:OnUpdateTransform(deltaTime)
  if not self.circleMoveValid then
    return
  end
  if self.circleMoveTime > 0 then
    self.circleMoveTimer = self.circleMoveTimer + deltaTime
    if self.circleMoveTimer >= self.circleMoveTime then
      self:SetPositionXYZ(self.curPos.x, self.curPos.y, self.curPos.z)
      self:FindNewTarget()
      return
    end
    local de = self.circleMoveTimer / self.circleMoveTime
    self.curPos.x = Mathf.Lerp(self.circleMoveStartPos.x, self.circleMoveTargetPos.x, de)
    self.curPos.z = Mathf.Lerp(self.circleMoveStartPos.z, self.circleMoveTargetPos.z, de)
    self:SetPositionXYZ(self.curPos.x, self.curPos.y, self.curPos.z)
  end
end

return BulletCircleRandom
