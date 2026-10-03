local apiInit, apiCreateAccess
if CS ~= nil then
  apiInit = CS.LuaArrAccessAPI.Init
  apiCreateAccess = CS.LuaArrAccessAPI.CreateLuaShareAccess
else
  apiInit = LuaArrAccessAPI.Init
  apiCreateAccess = LuaArrAccessAPI.CreateLuaShareAccess
end
apiInit(jit ~= nil)
local LuaCSharpArray = {
  class = "LuaCSharpArray"
}
local fields = {}
local pin_func = lua_safe_pin_bind
local IsJit = 0
if jit then
  IsJit = 1
end
setmetatable(LuaCSharpArray, LuaCSharpArray)

function LuaCSharpArray.__index(t, k)
  local var = rawget(LuaCSharpArray, k)
  return var
end

local needDetect = true

local function GlobalAutoDetectArch()
  if needDetect == false then
    return
  end
  needDetect = false
  if jit then
    local data = LuaCSharpArray.New(3)
    data:AutoDetectArch()
  end
end

function LuaCSharpArray.New(len)
  GlobalAutoDetectArch()
  local v = {}
  for i = 1, len do
    v[i] = 0
  end
  setmetatable(v, LuaCSharpArray)
  return v
end

local oldGCFunc

local function newGCFunc(self)
  self:OnGC()
  oldGCFunc(self)
end

local function SetCSharpAccessGCFunc(pin)
  local mt = getmetatable(pin)
  if oldGCFunc == nil then
    oldGCFunc = mt.__gc
  end
  mt.__gc = newGCFunc
end

function LuaCSharpArray:GetCSharpAccess()
  if self.__pin == nil then
    self.__pin = apiCreateAccess()
    pin_func(self, self.__pin)
    SetCSharpAccessGCFunc(self.__pin)
  end
  return self.__pin
end

function LuaCSharpArray:DestroyCSharpAccess()
  if self.__pin ~= nil then
    self.__pin:OnGC()
    self.__pin = nil
  end
end

function LuaCSharpArray:AutoDetectArch()
  if jit then
    self[1] = 32167
    self[2] = 9527.5
    self[3] = -2000000
    local acc = self:GetCSharpAccess()
    acc:AutoDetectArch()
  end
end

return LuaCSharpArray
