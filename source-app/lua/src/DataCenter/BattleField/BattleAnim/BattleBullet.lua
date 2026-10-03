local BattleBullet = BaseClass("BattleBullet")
local DIE_PERCENT = _ENV.DIE_PERCENT
local MyIsNull = IsNull

function BattleBullet:OnCreate()
  self.request = nil
end

function BattleBullet:OnDestroy()
  self:RequestClean()
end

function BattleBullet:RequestClean()
  if self.request ~= nil and type(self.request.Destroy) == "function" then
    self.request:Destroy()
  end
  self.request = nil
end

function BattleBullet:LogicDie()
  self:RequestClean()
  if self.endCB ~= nil then
    self.endCB()
  end
end

function BattleBullet:ReInit(request, startPos, endPos, time, height, endCB)
  self:RequestClean()
  self.request = request
  self.gameObject = request.gameObject
  self.transform = request.gameObject.transform
  self.startPos = startPos
  self.end_pos = endPos
  self.duration = time - 0.2
  self.endCB = endCB
  self.height = height
  local displace = Vector3.New(endPos.x - startPos.x, 0, endPos.z - startPos.z)
  local distance = displace:Magnitude()
  self.heightWidthRatio = self.height / distance
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
  self.transform.forward = forward
  self.scaledTime = 0
end

function BattleBullet:Update()
  if self.request == nil or MyIsNull(self.transform) then
    return
  end
  self.scaledTime = self.scaledTime + Time.deltaTime
  local t = self.scaledTime / self.duration
  if t >= DIE_PERCENT then
    self:LogicDie()
    return
  end
  local allDis = self.totalDis
  local stepDis = allDis * t
  local curDis = 0
  local path = self.path
  local luaPath = self.luaPath
  local point = luaPath[path.Count - 1]
  local nextPoint = point
  for j = 0, path.Count - 1 do
    local d = self.pathDis[j + 1]
    if d == nil then
      self:LogicDie()
      return
    end
    if stepDis <= curDis + d then
      local t2 = t - curDis / allDis
      local t3 = t2 * allDis / d
      point = Vector3.Lerp(luaPath[j], luaPath[j + 1], t3)
      nextPoint = path[j + 1]
      break
    else
      curDis = curDis + d
    end
  end
  local forward = nextPoint - point
  self.transform.forward = forward
  self.transform.position = CS.UnityEngine.Vector3(point.x, point.y, point.z)
end

return BattleBullet
