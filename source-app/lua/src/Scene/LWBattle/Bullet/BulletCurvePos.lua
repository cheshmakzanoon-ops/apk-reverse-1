local base = require("Scene.LWBattle.Bullet.BulletBase")
local BulletCurvePos = BaseClass("BulletCurvePos", base)
local DIE_PERCENT = _ENV.DIE_PERCENT
local BulletViewFacade = CS.PVEBattleLogic.Bullet.BulletViewFacade

function BulletCurvePos:Create()
  local q = Quaternion.Euler(0, self.rotY, 0)
  local forward = Vector3.forward
  local f = q:MulVec3(forward)
  if self.index == 1 then
    local ownerVelocity = self.owner:GetMoveVelocity()
    self.inertiaSpeed = Vector3.Dot(f, ownerVelocity)
  else
    self.inertiaSpeed = 0
  end
  self.flySpeed = self.inertiaSpeed + self.flySpeed
  local delta = f * (self.flySpeed * self.lifetime)
  self.target = self.startPos + delta
  if self.meta.is_following then
    local newTarget = PveUtil.FindNearestUnitInBoxRange(self.logic, self.startPos, 0.1, 0, delta.z, self.skill.targetLayerMask, nil)
    if newTarget and newTarget.GetPosition then
      local tPos = newTarget:GetPosition()
      if tPos then
        self.target.x = tPos.x
        self.target.z = tPos.z
      end
    end
  end
  self.target.y = 0
  forward:ReturnPool()
  f:ReturnPool()
  base.Create(self)
end

function BulletCurvePos:Destroy()
  base.Destroy(self)
  if self.path then
    self.path:Clear()
    self.path = nil
  end
  self.luaPath = {}
  self.pathDis = {}
  self.AngleOffset = nil
  self.totalDis = nil
  self.duration = nil
  self.springRound = nil
end

function BulletCurvePos:OnUpdateCollision()
end

function BulletCurvePos:OnShow()
  local startPos = self.startPos
  local endPos = self:GetTargetPos()
  if not endPos then
    self:LogicDie()
    return
  end
  local displace = Vector3.New(endPos.x - startPos.x, 0, endPos.z - startPos.z)
  if self.AngleOffset then
    local tempDisplace = displace * Quaternion.Euler(0, self.AngleOffset, 0)
    displace:ReturnPool()
    displace = tempDisplace
    endPos = startPos + displace
  end
  if 0 < self.meta.random_ring_range then
    local randomRadius = math.random() * self.meta.random_ring_range
    local randomAngle = math.random() * 6.283
    local randomOffset = Vector3.New(math.cos(randomAngle), 0, math.sin(randomAngle)) * randomRadius
    local tempDistance = displace + randomOffset
    displace:ReturnPool()
    displace = tempDistance
    endPos = endPos + randomOffset
    randomOffset:ReturnPool()
  end
  if 0 < self.height then
    local distance = displace:Magnitude()
    self.heightWidthRatio = self.height / distance
  end
  self.end_pos = endPos
  if self.meta.parabola_angle == 0 then
    self.path = CS.CatmullRomUtils.CalcCurve(startPos, endPos, self.heightWidthRatio)
  else
    local isLeft = self.meta.parabola_angle == 1
    self.path = CS.CatmullRomUtils.CalcCurveXZPlane(startPos, endPos, self.heightWidthRatio, isLeft)
  end
  self.luaPath = {}
  self.pathDis = {}
  for i = 0, self.path.Count - 1 do
    local csVec = self.path[i]
    self.luaPath[i] = Vector3.New(csVec.x, csVec.y, csVec.z)
  end
  self.totalDis = 0
  for i = 0, self.path.Count - 2 do
    self.pathDis[i + 1] = Vector3.Distance(self.luaPath[i], self.luaPath[i + 1])
    self.totalDis = self.totalDis + self.pathDis[i + 1]
  end
  local forward = self.path[1] - self.path[0]
  if 0 < self.viewHandle then
    BulletViewFacade.SetForward(self.viewHandle, forward.x, forward.y, forward.z)
  end
  if 0 < self.meta.spiral_loops then
    self.duration = 4 / self.flySpeed * self.meta.spiral_loops
    self.springRound = self.meta.spiral_loops * 6.283
  elseif 0 < self.height then
    self.duration = 2 * self.height / self.flySpeed
  else
    self.duration = self.totalDis / self.flySpeed
  end
  if self.noCollision then
    self.duration = self:GetForceLifeTime()
  end
  self.scaledTime = 0
  self:TryShowWarnEffect()
end

function BulletCurvePos:TryShowWarnEffect()
  if self.skill and self.skill.showWarnEffect and self.skill.useBulletWarnEffect then
    local pos = self.end_pos
    if self.luaPath and #self.luaPath > 0 then
      pos = self.luaPath[#self.luaPath]
    end
    if pos then
      local effectPos = Vector3.New(pos.x, 0.1, pos.z)
      self.logic:ShowEffectObj(self.skill.warnEffect, effectPos, Quaternion.identity, self.skill.warnEffectTime)
    end
  end
end

function BulletCurvePos:OnUpdateTransform(deltaTime)
  self.scaledTime = self.scaledTime + deltaTime
  local t = self.scaledTime / self.duration
  if t >= DIE_PERCENT then
    self:UpdateTransformImp(1)
    self:CollisionDetection()
    self:LogicDie()
    return
  end
  self:UpdateTransformImp(t)
end

function BulletCurvePos:UpdateTransformImp(t)
  local p
  if self.animCurve then
    p = self.animCurve:Evaluate(t)
  elseif t < 0.5 then
    p = -2 * (t - 0.5) * (t - 0.5) + 0.5
  else
    p = 2 * (t - 0.5) * (t - 0.5) + 0.5
  end
  local allDis = self.totalDis
  local stepDis = allDis * p
  local curDis = 0
  local path = self.path
  local luaPath = self.luaPath
  local point = luaPath[path.Count - 1]
  local nextPoint = point
  for j = 0, path.Count - 1 do
    local d = self.pathDis[j + 1]
    if d == nil then
      local curve = self.animCurve and "hasCurve" or "noCurve"
      if self.animCurve then
        curve = curve .. CS.BulletMotionEditor.CurveToString(self.animCurve)
      end
      Logger.LogError(string.format("\230\138\155\231\137\169\231\186\191\229\173\144\229\188\185\229\188\130\229\184\184\239\188\154j=%s,p=%s,t=%s,curve=%s,metaId=%s,dur=%s,dis=%s,spd=%s,s=%s,%s,%s,e=%s,%s,%s", j, p, t, curve, self.meta.id, self.duration, self.totalDis, self.flySpeed, self.startPos.x, self.startPos.y, self.startPos.z, self.end_pos.x, self.end_pos.y, self.end_pos.z))
      self:LogicDie()
      return
    end
    if stepDis <= curDis + d then
      local t2 = p - curDis / allDis
      local t3 = t2 * allDis / d
      point = Vector3.Lerp(luaPath[j], luaPath[j + 1], t3)
      nextPoint = path[j + 1]
      break
    else
      curDis = curDis + d
    end
  end
  local forward = nextPoint - point
  if 0 < self.viewHandle then
    BulletViewFacade.SetForward(self.viewHandle, forward.x, forward.y, forward.z)
  end
  if 0 < self.meta.spiral_loops then
    local angle = t * self.springRound
    local rX, rY, rZ = BulletViewFacade.GetRight(self.viewHandle)
    local worldRight = Vector3.New(rX, rY, rZ)
    local uX, uY, uZ = BulletViewFacade.GetUp(self.viewHandle)
    local worldUp = Vector3.New(uX, uY, uZ)
    local offset = worldRight * math.cos(angle) + worldUp * math.sin(angle)
    worldRight:ReturnPool()
    worldUp:ReturnPool()
    offset = offset * (-4 * (t - 0.5) * (t - 0.5) + 1) * self.meta.spiral_radius
    self:SetPositionXYZ(offset.x + point.x, offset.y + point.y, offset.z + point.z)
    offset:ReturnPool()
  else
    self:SetPositionXYZ(point.x, point.y, point.z)
  end
end

return BulletCurvePos
