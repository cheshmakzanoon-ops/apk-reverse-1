local base = require("Scene.LWHummerScene.Bullet.LWHummerSceneBulletBase")
local LWHummerSceneBulletCurve = BaseClass("LWHummerSceneBulletCurve", base)
local DIE_PERCENT = _ENV.DIE_PERCENT

function LWHummerSceneBulletCurve:__init()
end

function LWHummerSceneBulletCurve:__delete()
  self:Destory()
end

function LWHummerSceneBulletCurve:Destory()
  base.Destory(self)
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
  self.scaledTime = nil
end

function LWHummerSceneBulletCurve:OnShow()
  local startPos = self.startPos
  local endPos = self:GetTargetPos()
  if not endPos then
    self:LogicDie()
    return
  end
  self.end_pos = endPos
  self.path = CS.CatmullRomUtils.CalcCurve(startPos, endPos, self.heightWidthRatio)
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
  self.bulletEffectTrans.forward = forward
  self.duration = self.totalDis / self.flySpeed
  self.scaledTime = 0
end

function LWHummerSceneBulletCurve:OnUpdateTransform()
  if self.scaledTime == nil then
    return
  end
  self.scaledTime = self.scaledTime + Time.deltaTime
  local t = self.scaledTime / self.duration
  if t >= DIE_PERCENT then
    self:CollisionDetection()
    self:LogicDie()
    return
  end
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
  self.bulletEffectTrans.forward = forward
  self:SetPosition(CS.UnityEngine.Vector3(point.x, point.y, point.z))
end

return LWHummerSceneBulletCurve
