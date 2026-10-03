local base = require("Scene.LWBattle.Bullet.BulletBase")
local BulletHalfCurve = BaseClass("BulletHalfCurve", base)
local DIE_PERCENT = _ENV.DIE_PERCENT
local BulletViewFacade = CS.PVEBattleLogic.Bullet.BulletViewFacade

function BulletHalfCurve:Destroy()
  base.Destroy(self)
  if self.path then
    self.path:Clear()
    self.path = nil
  end
  self.totalDis = nil
  self.duration = nil
end

function BulletHalfCurve:OnShow()
  local startPos = self.startPos
  local endPos
  if self.target.x then
    endPos = self.target
  else
    endPos = self.target:GetPosition()
  end
  endPos.y = startPos.y
  local displace = Vector3.New(endPos.x - startPos.x, 0, endPos.z - startPos.z)
  local distance = displace:Magnitude()
  displace:ReturnPool()
  if self.skill ~= nil and self.skill.isWorldTroopEffect and self.meta.bullet_fly_speed_world ~= 0 then
    self.duration = distance / self.meta.bullet_fly_speed_world * 1000
  else
    self.duration = distance / self.meta.bullet_fly_speed * 1000
  end
  self.scaledTime = 0
  self.path = CS.CatmullRomUtils.CalcCurve(startPos, endPos, 0.4)
  self.totalDis = 0
  for i = 0, self.path.Count - 2 do
    self.totalDis = self.totalDis + Vector3.Distance(self.path[i], self.path[i + 1])
  end
end

function BulletHalfCurve:OnUpdateTransform(deltaTime)
  self.scaledTime = self.scaledTime + deltaTime
  local t = self.scaledTime / self.duration
  if t >= DIE_PERCENT then
    self:DoHitShake()
    self:LogicDie()
    return
  end
  t = -2 * (t - 0.5) * (t - 0.5) + 0.5
  local allDis = self.totalDis
  local stepDis = allDis * t
  local curDis = 0
  local path = self.path
  local point = path[path.Count - 1]
  local nextPoint = point
  for j = 0, path.Count - 1 do
    local d = Vector3.Distance(path[j], path[j + 1])
    if stepDis <= curDis + d then
      local t2 = t - curDis / allDis
      local t3 = t2 * allDis / d
      point = Vector3.Lerp(path[j], path[j + 1], t3)
      nextPoint = path[j + 1]
      break
    else
      curDis = curDis + d
    end
  end
  self:SetPositionXYZ(point.x, point.y, point.z)
  BulletViewFacade.SetForward(self.viewHandle, nextPoint.x - point.x, nextPoint.y - point.y, nextPoint.z - point.z)
end

return BulletHalfCurve
