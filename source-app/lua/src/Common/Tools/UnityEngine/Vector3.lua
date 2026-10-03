local math = _ENV.math
local acos = math.acos
local sqrt = math.sqrt
local max = math.max
local min = math.min
local clamp = Mathf.Clamp
local cos = math.cos
local sin = math.sin
local abs = math.abs
local sign = Mathf.Sign
local setmetatable = _ENV.setmetatable
local rawset = _ENV.rawset
local rawget = _ENV.rawget
local type = _ENV.type
local rad2Deg = 57.295779513082
local deg2Rad = 0.017453292519943
local Vector3 = {}
local _getter = {}
local unity_vector3 = CS.UnityEngine.Vector3
local _vector3_pool = setmetatable({}, {__mode = "k"})

function Vector3.__index(t, k)
  if Vector3.openPoolLog and _vector3_pool[t] then
    Logger.LogError("Vector3 Use Dirty Object: " .. tostring(t.__poolStack))
  end
  local var = rawget(Vector3, k)
  if var ~= nil then
    return var
  end
  var = rawget(_getter, k)
  if var ~= nil then
    return var(t)
  end
  return rawget(unity_vector3, k)
end

local usePool

local function capture_stack(max_level)
  max_level = max_level or 6
  local tb = {}
  for i = 3, 3 + max_level do
    local info = debug.getinfo(i, "Sl")
    if not info then
      break
    end
    local src = string.format("%s:%d", info.short_src or "?", info.currentline or 0)
    table.insert(tb, src)
  end
  return table.concat(tb, " <- ")
end

local function _RemoveFromPool(vector3)
  _vector3_pool[vector3] = nil
end

local function _TryGetFromPool()
  if nil == usePool and LuaEntry and LuaEntry.Player then
    usePool = LuaEntry.Player:IsOpenReturnOpt()
  end
  if usePool and not Vector3.openPoolLog then
    local vector3
    for vec, _ in pairs(_vector3_pool) do
      vector3 = vec
      break
    end
    if vector3 then
      _RemoveFromPool(vector3)
      return vector3
    end
    return nil
  end
  return nil
end

function Vector3:ReturnPool()
  if nil == usePool and LuaEntry and LuaEntry.Player then
    usePool = LuaEntry.Player:IsOpenReturnOpt()
  end
  if usePool then
    self:Set(0, 0, 0)
    if Vector3.openPoolLog then
      self.__poolStack = capture_stack()
      self.x = nil
      self.y = nil
      self.z = nil
    end
    _vector3_pool[self] = true
    if Vector3.GetOpenPoolLog() then
      self.__poolStack = capture_stack()
    end
  end
end

function Vector3.RefreshUsePool()
  if LuaEntry and LuaEntry.Player then
    usePool = LuaEntry.Player:IsOpenReturnOpt()
  end
end

function Vector3.New(x, y, z)
  local t = _TryGetFromPool()
  if t then
    t:Set(x, y, z)
  else
    t = {
      x = x or 0,
      y = y or 0,
      z = z or 0
    }
    setmetatable(t, Vector3)
  end
  return t
end

function Vector3.ForceNew(x, y, z)
  local t = {
    x = x or 0,
    y = y or 0,
    z = z or 0
  }
  setmetatable(t, Vector3)
  return t
end

local _new = Vector3.New

function Vector3.__call(t, x, y, z)
  local t = _TryGetFromPool()
  if t then
    t:Set(x, y, z)
  else
    t = {
      x = x or 0,
      y = y or 0,
      z = z or 0
    }
    setmetatable(t, Vector3)
  end
  return t
end

function Vector3:Set(x, y, z)
  self.x = x or 0
  self.y = y or 0
  self.z = z or 0
end

function Vector3.Get(v)
  return v.x, v.y, v.z
end

function Vector3:Split()
  return self.x, self.y, self.z
end

function Vector3:Clone()
  local t = _TryGetFromPool()
  if t then
    t:Set(self.x, self.y, self.z)
  else
    t = {
      x = self.x,
      y = self.y,
      z = self.z
    }
    setmetatable(t, Vector3)
  end
  return t
end

function Vector3.Distance(va, vb)
  return sqrt((va.x - vb.x) ^ 2 + (va.y - vb.y) ^ 2 + (va.z - vb.z) ^ 2)
end

function Vector3.HorizonDistance(va, vb)
  return sqrt((va.x - vb.x) ^ 2 + (va.z - vb.z) ^ 2)
end

function Vector3.ManhattanDistance(va, vb)
  return abs(va.x - vb.x) + abs(va.y - vb.y) + abs(va.z - vb.z)
end

function Vector3.ManhattanDistanceXZ(va, vb)
  return abs(va.x - vb.x) + abs(va.z - vb.z)
end

function Vector3.Dot(lhs, rhs)
  return lhs.x * rhs.x + lhs.y * rhs.y + lhs.z * rhs.z
end

function Vector3.Lerp(from, to, t)
  t = clamp(t, 0, 1)
  return _new(from.x + (to.x - from.x) * t, from.y + (to.y - from.y) * t, from.z + (to.z - from.z) * t)
end

function Vector3:Magnitude()
  return sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
end

function Vector3.Max(lhs, rhs)
  return _new(max(lhs.x, rhs.x), max(lhs.y, rhs.y), max(lhs.z, rhs.z))
end

function Vector3.Min(lhs, rhs)
  return _new(min(lhs.x, rhs.x), min(lhs.y, rhs.y), min(lhs.z, rhs.z))
end

function Vector3.Normalize(v)
  local x, y, z = v.x, v.y, v.z
  local num = sqrt(x * x + y * y + z * z)
  local t = _TryGetFromPool()
  if t then
    if 1.0E-5 < num then
      t:Set(x / num, y / num, z / num)
      return t
    end
    t:Set(0, 0, 0)
    return t
  else
    if 1.0E-5 < num then
      local t = {
        x = x / num,
        y = y / num,
        z = z / num
      }
      return setmetatable(t, Vector3)
    end
    local t = {
      x = 0,
      y = 0,
      z = 0
    }
    return setmetatable(t, Vector3)
  end
end

function Vector3:SetNormalize()
  local num = sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
  if 1.0E-5 < num then
    self.x = self.x / num
    self.y = self.y / num
    self.z = self.z / num
  else
    self.x = 0
    self.y = 0
    self.z = 0
  end
  return self
end

function Vector3:SqrMagnitude()
  return self.x * self.x + self.y * self.y + self.z * self.z
end

local dot = Vector3.Dot

function Vector3.Angle(from, to)
  local fromNor = from:Normalize()
  local toNor = to:Normalize()
  local ret = acos(clamp(dot(fromNor, toNor), -1, 1)) * rad2Deg
  fromNor:ReturnPool()
  toNor:ReturnPool()
  return ret
end

function Vector3:ClampMagnitude(maxLength)
  if self:SqrMagnitude() > maxLength * maxLength then
    self:SetNormalize()
    self:Mul(maxLength)
  end
  return self
end

function Vector3.OrthoNormalize(va, vb, vc)
  va:SetNormalize()
  local vpa = vb:Project(va)
  vb:Sub(vpa)
  vpa:ReturnPool()
  vb:SetNormalize()
  if vc == nil then
    return va, vb
  end
  local cpa = vc:Project(va)
  vc:Sub(cpa)
  cpa:ReturnPool()
  local cpb = vc:Project(vb)
  vc:Sub(cpb)
  cpb:ReturnPool()
  vc:SetNormalize()
  return va, vb, vc
end

function Vector3.MoveTowards(current, target, maxDistanceDelta)
  local delta = target - current
  local sqrDelta = delta:SqrMagnitude()
  local sqrDistance = maxDistanceDelta * maxDistanceDelta
  if sqrDelta > sqrDistance then
    local magnitude = sqrt(sqrDelta)
    if 1.0E-6 < magnitude then
      delta:Mul(maxDistanceDelta / magnitude)
      delta:Add(current)
      return delta
    else
      return current:Clone()
    end
  end
  return target:Clone()
end

function ClampedMove(lhs, rhs, clampedDelta)
  local delta = rhs - lhs
  if 0 < delta then
    local ret = lhs + min(delta, clampedDelta)
    return ret
  else
    local ret = lhs - min(-delta, clampedDelta)
    return ret
  end
end

local overSqrt2 = 0.7071067811865476

local function OrthoNormalVector(vec)
  local res = _new()
  if abs(vec.z) > overSqrt2 then
    local a = vec.y * vec.y + vec.z * vec.z
    local k = 1 / sqrt(a)
    res.x = 0
    res.y = -vec.z * k
    res.z = vec.y * k
  else
    local a = vec.x * vec.x + vec.y * vec.y
    local k = 1 / sqrt(a)
    res.x = -vec.y * k
    res.y = vec.x * k
    res.z = 0
  end
  return res
end

function Vector3.RotateTowards(current, target, maxRadiansDelta, maxMagnitudeDelta)
  local len1 = current:Magnitude()
  local len2 = target:Magnitude()
  if 1.0E-6 < len1 and 1.0E-6 < len2 then
    local from = current / len1
    local to = target / len2
    local cosom = dot(from, to)
    if 0.999999 < cosom then
      return Vector3.MoveTowards(current, target, maxMagnitudeDelta)
    elseif cosom < -0.999999 then
      local axis = OrthoNormalVector(from)
      local q = Quaternion.AngleAxis(maxRadiansDelta * rad2Deg, axis)
      axis:ReturnPool()
      local rotated = q:MulVec3(from)
      local delta = ClampedMove(len1, len2, maxMagnitudeDelta)
      rotated:Mul(delta)
      return rotated
    else
      local angle = acos(cosom)
      local axis = Vector3.Cross(from, to)
      axis:SetNormalize()
      local q = Quaternion.AngleAxis(min(maxRadiansDelta, angle) * rad2Deg, axis)
      axis:ReturnPool()
      local rotated = q:MulVec3(from)
      local delta = ClampedMove(len1, len2, maxMagnitudeDelta)
      rotated:Mul(delta)
      return rotated
    end
  end
  return Vector3.MoveTowards(current, target, maxMagnitudeDelta)
end

function Vector3.Scale(a, b)
  local x = a.x * b.x
  local y = a.y * b.y
  local z = a.z * b.z
  return _new(x, y, z)
end

function Vector3.Cross(lhs, rhs)
  local x = lhs.y * rhs.z - lhs.z * rhs.y
  local y = lhs.z * rhs.x - lhs.x * rhs.z
  local z = lhs.x * rhs.y - lhs.y * rhs.x
  return _new(x, y, z)
end

function Vector3:Equals(other)
  return self.x == other.x and self.y == other.y and self.z == other.z
end

function Vector3.Reflect(inDirection, inNormal)
  local num = -2 * dot(inNormal, inDirection)
  inNormal = inNormal * num
  inNormal:Add(inDirection)
  return inNormal
end

function Vector3.Project(vector, onNormal)
  local num = onNormal:SqrMagnitude()
  if num < 1.175494E-38 then
    return _new(0, 0, 0)
  end
  local num2 = dot(vector, onNormal)
  local v3 = onNormal:Clone()
  v3:Mul(num2 / num)
  return v3
end

function Vector3.ProjectOnPlane(vector, planeNormal)
  local v3 = Vector3.Project(vector, planeNormal)
  v3:Mul(-1)
  v3:Add(vector)
  return v3
end

function Vector3.Slerp(from, to, t)
  local omega, sinom, scale0, scale1
  if t <= 0 then
    return from:Clone()
  elseif 1 <= t then
    return to:Clone()
  end
  local v2 = to:Clone()
  local v1 = from:Clone()
  local len2 = to:Magnitude()
  local len1 = from:Magnitude()
  v2:Div(len2)
  v1:Div(len1)
  local len = (len2 - len1) * t + len1
  local cosom = v1.x * v2.x + v1.y * v2.y + v1.z * v2.z
  if 0.999999 < cosom then
    scale0 = 1 - t
    scale1 = t
  elseif cosom < -0.999999 then
    local axis = OrthoNormalVector(from)
    local q = Quaternion.AngleAxis(180.0 * t, axis)
    axis:ReturnPool()
    local v = q:MulVec3(from)
    v:Mul(len)
    return v
  else
    omega = acos(cosom)
    sinom = sin(omega)
    scale0 = sin((1 - t) * omega) / sinom
    scale1 = sin(t * omega) / sinom
  end
  v1:Mul(scale0)
  v2:Mul(scale1)
  v2:Add(v1)
  v2:Mul(len)
  v1:ReturnPool()
  return v2
end

function Vector3:Mul(q)
  if type(q) == "number" then
    self.x = self.x * q
    self.y = self.y * q
    self.z = self.z * q
  else
    self:MulQuat(q)
  end
  return self
end

function Vector3:Div(d)
  self.x = self.x / d
  self.y = self.y / d
  self.z = self.z / d
  return self
end

function Vector3:Add(vb)
  self.x = self.x + vb.x
  self.y = self.y + vb.y
  self.z = self.z + vb.z
  return self
end

function Vector3:Sub(vb)
  self.x = self.x - vb.x
  self.y = self.y - vb.y
  self.z = self.z - vb.z
  return self
end

function Vector3:MulQuat(quat)
  local num = quat.x * 2
  local num2 = quat.y * 2
  local num3 = quat.z * 2
  local num4 = quat.x * num
  local num5 = quat.y * num2
  local num6 = quat.z * num3
  local num7 = quat.x * num2
  local num8 = quat.x * num3
  local num9 = quat.y * num3
  local num10 = quat.w * num
  local num11 = quat.w * num2
  local num12 = quat.w * num3
  local x = (1 - (num5 + num6)) * self.x + (num7 - num12) * self.y + (num8 + num11) * self.z
  local y = (num7 + num12) * self.x + (1 - (num4 + num6)) * self.y + (num9 - num10) * self.z
  local z = (num8 - num11) * self.x + (num9 + num10) * self.y + (1 - (num4 + num5)) * self.z
  self:Set(x, y, z)
  return self
end

function Vector3.AngleAroundAxis(from, to, axis)
  local fromC = from:Clone()
  local toC = to:Clone()
  local fromCProj = Vector3.Project(fromC, axis)
  local tempFromC = fromC - fromCProj
  fromC:ReturnPool()
  fromCProj:ReturnPool()
  fromC = tempFromC
  local toCProj = Vector3.Project(toC, axis)
  local tempToC = toC - toCProj
  toC:ReturnPool()
  toCProj:ReturnPool()
  toC = tempToC
  local angle = Vector3.Angle(fromC, toC)
  local ret = angle * (Vector3.Dot(axis, Vector3.Cross(fromC, toC)) < 0 and -1 or 1)
  fromC:ReturnPool()
  toC:ReturnPool()
  return ret
end

function Vector3.ToString(vec)
  return string.format("[%.2f,%.2f,%.2f]", vec.x, vec.y, vec.z)
end

function Vector3:__tostring()
  return "[" .. self.x .. "," .. self.y .. "," .. self.z .. "]"
end

function Vector3.__div(va, d)
  return _new(va.x / d, va.y / d, va.z / d)
end

function Vector3.__mul(va, d)
  if type(d) == "number" then
    return _new(va.x * d, va.y * d, va.z * d)
  elseif type(va) == "number" then
    return _new(d.x * va, d.y * va, d.z * va)
  else
    local vec = va:Clone()
    vec:MulQuat(d)
    return vec
  end
end

function Vector3.__add(va, vb)
  return _new(va.x + vb.x, va.y + vb.y, va.z + vb.z)
end

function Vector3.__sub(va, vb)
  return _new(va.x - vb.x, va.y - vb.y, va.z - vb.z)
end

function Vector3.__unm(va)
  return _new(-va.x, -va.y, -va.z)
end

function Vector3.__eq(a, b)
  local v = a - b
  local delta = v:SqrMagnitude()
  return delta < 1.0E-10
end

Vector3.openPoolLog = false

function Vector3.SetOpenPoolLog(val)
  Vector3.openPoolLog = val and CommonUtil and CommonUtil.IsDebug()
  if Vector3.openPoolLog then
    function Vector3.__newindex(t, k, v)
      if Vector3.openPoolLog and _vector3_pool[t] then
        Logger.LogError("Vector3 Use Dirty Object: " .. tostring(t.__poolStack))
      end
      rawset(t, k, v)
    end
  else
    Vector3.__newindex = nil
  end
end

function Vector3.GetOpenPoolLog()
  return Vector3.openPoolLog
end

function _getter.up()
  return _new(0, 1, 0)
end

function _getter.down()
  return _new(0, -1, 0)
end

function _getter.right()
  return _new(1, 0, 0)
end

function _getter.left()
  return _new(-1, 0, 0)
end

function _getter.forward()
  return _new(0, 0, 1)
end

function _getter.back()
  return _new(0, 0, -1)
end

function _getter.zero()
  return _new(0, 0, 0)
end

function _getter.one()
  return _new(1, 1, 1)
end

_getter.magnitude = Vector3.Magnitude
_getter.normalized = Vector3.Normalize
_getter.sqrMagnitude = Vector3.SqrMagnitude
Vector3.unity_vector3 = CS.UnityEngine.Vector3
CS.UnityEngine.Vector3 = Vector3
setmetatable(Vector3, Vector3)
return Vector3
