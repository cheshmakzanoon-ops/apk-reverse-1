local rapidjson = require("rapidjson")
local base64 = require("Framework.Common.base64")
local unpack = unpack or table.unpack
local pack = table.pack or function(...)
  return {
    n = select("#", ...),
    ...
  }
end

function SafePack(...)
  return pack(...)
end

function SafeRequire(path)
  local success, rst = pcall(require, path)
  if not success then
    rst = nil
  end
  return rst
end

function SafeUnpack(safe_pack_tb)
  return unpack(safe_pack_tb, 1, safe_pack_tb.n)
end

function ConcatSafePack(safe_pack_l, safe_pack_r)
  local concat = {}
  for i = 1, safe_pack_l.n do
    concat[i] = safe_pack_l[i]
  end
  for i = 1, safe_pack_r.n do
    concat[safe_pack_l.n + i] = safe_pack_r[i]
  end
  concat.n = safe_pack_l.n + safe_pack_r.n
  return concat
end

local function BindNone(self, func)
  return function(...)
    if self ~= nil then
      func(self, ...)
    else
      func(...)
    end
  end
end

local function BindSingle(self, func, param)
  assert(param ~= nil)
  return function(...)
    if self ~= nil then
      func(self, param, ...)
    else
      func(param, ...)
    end
  end
end

local function BindNoneRet(self, func)
  return function(...)
    if self ~= nil then
      return func(self, ...)
    else
      return func(...)
    end
  end
end

local function BindSingleRet(self, func, param)
  assert(param ~= nil)
  return function(...)
    if self ~= nil then
      return func(self, param, ...)
    else
      return func(param, ...)
    end
  end
end

function _ENV:Bind(func, ...)
  assert(self == nil or type(self) == "table")
  assert(func ~= nil and type(func) == "function")
  local pcount = select("#", ...)
  if pcount == 0 then
    return BindNone(self, func)
  elseif pcount == 1 then
    return BindSingle(self, func, select("1", ...))
  end
  local params
  if self == nil then
    params = SafePack(...)
  else
    params = SafePack(self, ...)
  end
  return function(...)
    local args = ConcatSafePack(params, SafePack(...))
    func(SafeUnpack(args))
  end
end

function _ENV:BindRet(func, ...)
  assert(self == nil or type(self) == "table")
  assert(func ~= nil and type(func) == "function")
  local pcount = select("#", ...)
  if pcount == 0 then
    return BindNoneRet(self, func)
  elseif pcount == 1 then
    return BindSingleRet(self, func, select("1", ...))
  end
  local params
  if self == nil then
    params = SafePack(...)
  else
    params = SafePack(self, ...)
  end
  return function(...)
    local args = ConcatSafePack(params, SafePack(...))
    return func(SafeUnpack(args))
  end
end

function BindCallback(...)
  local bindFunc
  local param1, param2 = select(1, ...)
  if type(param1) == "table" and type(param2) == "function" then
    bindFunc = Bind(...)
  elseif type(param1) == "function" then
    bindFunc = Bind(nil, ...)
  else
    error("BindCallback : error params list!")
  end
  return bindFunc
end

function DeepCopy(object)
  local lookup_table = {}
  
  local function _copy(object)
    if type(object) ~= "table" then
      return object
    elseif lookup_table[object] then
      return lookup_table[object]
    end
    local new_table = {}
    lookup_table[object] = new_table
    for index, value in pairs(object) do
      new_table[_copy(index)] = _copy(value)
    end
    return setmetatable(new_table, getmetatable(object))
  end
  
  return _copy(object)
end

function Serialize(tb, flag)
  local result = ""
  result = string.format("%s{", result)
  
  local function filter(str)
    str = string.gsub(str, "%[", " ")
    str = string.gsub(str, "%]", " ")
    str = string.gsub(str, "\"", " ")
    str = string.gsub(str, "%'", " ")
    str = string.gsub(str, "\\", " ")
    str = string.gsub(str, "%%", " ")
    return str
  end
  
  for k, v in pairs(tb) do
    if type(k) == "number" then
      if type(v) == "table" then
        result = string.format("%s[%d]=%s,", result, k, Serialize(v))
      elseif type(v) == "number" then
        result = string.format("%s[%d]=%d,", result, k, v)
      elseif type(v) == "string" then
        result = string.format("%s[%d]=%q,", result, k, v)
      elseif type(v) == "boolean" then
        result = string.format("%s[%d]=%s,", result, k, tostring(v))
      elseif flag then
        result = string.format("%s[%d]=%q,", result, k, type(v))
      else
        error("the type of value is a function or userdata")
      end
    elseif type(v) == "table" then
      result = string.format("%s%s=%s,", result, k, Serialize(v, flag))
    elseif type(v) == "number" then
      result = string.format("%s%s=%d,", result, k, v)
    elseif type(v) == "string" then
      result = string.format("%s%s=%q,", result, k, v)
    elseif type(v) == "boolean" then
      result = string.format("%s%s=%s,", result, k, tostring(v))
    elseif flag then
      result = string.format("%s[%s]=%q,", result, k, type(v))
    else
      error("the type of value is a function or userdata")
    end
  end
  result = string.format("%s}", result)
  return result
end

function NumToRoman(num)
  if type(num) ~= "number" or math.type(num) ~= "integer" or num <= 0 then
    return ""
  end
  local v = {
    1000,
    900,
    500,
    400,
    100,
    90,
    50,
    40,
    10,
    9,
    5,
    4,
    1
  }
  local r = {
    "M",
    "CM",
    "D",
    "CD",
    "C",
    "XC",
    "L",
    "XL",
    "X",
    "IX",
    "V",
    "IV",
    "I"
  }
  local str = ""
  for i = 1, 13 do
    while num >= v[i] do
      num = num - v[i]
      str = str .. r[i]
    end
  end
  return str
end

function GetStandardScale()
  return CS.UnityEngine.Screen.height / 750
end

function IsNumber(obj)
  if type(obj) == "number" then
    return true
  end
  if tonumber(obj) ~= nil then
    return true
  end
  return false
end

local function parserXY(prefix, serverId, X, posX, Y, posY, suffix)
  if prefix ~= nil and serverId ~= nil and 4 < #serverId then
    return nil
  end
  local link = {
    action = "Jump",
    x = tonumber(posX),
    y = tonumber(posY)
  }
  local txt = X .. posX .. Y .. posY
  if suffix ~= nil then
    txt = txt .. suffix
  end
  if prefix ~= nil and serverId ~= nil then
    txt = prefix .. serverId .. txt
    link.server = toInt(serverId)
  end
  if type(link.x) == "number" and type(link.y) == "number" then
    local json = rapidjson.encode(link)
    local linkId = base64.encode(json)
    return string.format("<link='%s'><u>%s</u></link>", linkId, txt)
  end
  return txt
end

local function parserXY2(X, posX, Y, posY)
  return parserXY(nil, nil, X, posX, Y, posY)
end

function FindAndAppendLinkInfo(txt)
  if txt == nil or txt == "" or txt:find("X:") == nil then
    return txt
  end
  local hasLinkData = txt:find("<link") ~= nil and txt:find("</link>") ~= nil
  if hasLinkData then
    return txt
  end
  local ret, count = string.gsub(txt, "(#%s*)(%d+)(.-X:.-)(%d+)(.-Y:.-)(%d+)(.-%)?)", parserXY)
  if count ~= nil and 0 < count then
    return ret
  end
  return string.gsub(txt, "(X:%s*)(%d+)(%s*,?%s*Y:%s*)(%d+)", parserXY2)
end

function case_insensitive_pattern(pattern)
  local p = pattern:gsub("(%%?)(.)", function(percent, letter)
    if percent ~= "" or not letter:match("%a") then
      return percent .. letter
    else
      return string.format("[%s%s]", letter:lower(), letter:upper())
    end
  end)
  return p
end

function PrettyPrintTable(tbl, indent)
  indent = indent or 0
  local indentStr = string.rep("  ", indent)
  local result = ""
  for k, v in pairs(tbl) do
    if type(v) == "table" then
      result = result .. indentStr .. k .. ": {\n"
      result = result .. PrettyPrintTable(v, indent + 1)
      result = result .. indentStr .. "}\n"
    elseif type(v) == "userdata" or type(v) == "object" then
      result = result .. indentStr .. k .. ": object\n"
    else
      result = result .. indentStr .. k .. ": " .. tostring(v) .. "\n"
    end
  end
  return result
end

function GetEnumKey(table, value)
  if table == nil then
    return "default"
  end
  for i, v in pairs(table) do
    if v == value then
      return i
    end
  end
  return "default"
end

local function Log(...)
  if Logger and Logger.LogInfo then
    Logger.LogInfo(string.format(...))
  else
    print(string.format(...))
  end
end

local BaseTimeTb = {
  year = 0,
  month = 0,
  day = 0,
  hour = 0,
  min = 0,
  sec = 0,
  isdst = nil
}

local function TrySafeOsTime(timeTable)
  local ok, tsOrError
  if timeTable == nil then
    ok, tsOrError = pcall(os.time)
  else
    ok, tsOrError = pcall(os.time, timeTable)
  end
  if ok and tsOrError ~= nil then
    return tsOrError
  end
  if ok then
    return nil, "os.time returned nil"
  end
  return nil, tsOrError
end

function SafeLocalOsTime(localTimeTable)
  local ts, errorMsg, isdst
  if localTimeTable == nil then
    ts, errorMsg = TrySafeOsTime()
    if ts ~= nil then
      return ts
    end
    Log([[
[SafeLocalOsTime] os.time empty default failed : 
%s]], tostring(errorMsg))
    localTimeTable = os.date("*t")
    isdst = localTimeTable.isdst
  else
    isdst = localTimeTable.isdst
  end
  local t = BaseTimeTb
  t.year = localTimeTable.year or 0
  t.month = localTimeTable.month or 0
  t.day = localTimeTable.day or 0
  t.hour = localTimeTable.hour or 0
  t.min = localTimeTable.min or 0
  t.sec = localTimeTable.sec or 0
  if isdst == nil then
    local nowLocal = os.date("*t")
    isdst = nowLocal.isdst
  end
  t.isdst = isdst
  ts, errorMsg = TrySafeOsTime(t)
  if ts ~= nil then
    local transLocal = os.date("*t", ts)
    if transLocal.isdst ~= t.isdst then
      t.isdst = transLocal.isdst
      Log("[SafeLocalOsTime] os.time tofix isdst set : %s", tostring(t.isdst))
      ts, errorMsg = TrySafeOsTime(t)
      if ts ~= nil then
        return ts
      end
      Log([[
[SafeLocalOsTime] os.time got exception after isdst fix : %s 
%s]], tostring(t.isdst), tostring(errorMsg))
    else
      return ts
    end
  else
    Log([[
[SafeLocalOsTime] os.time got exception after isdst set : %s 
%s]], tostring(isdst), tostring(errorMsg))
  end
  t.hour = (t.hour or 0) + 1
  ts, errorMsg = TrySafeOsTime(t)
  if ts ~= nil then
    ts = ts - (OneHourTime or 3600)
    return ts
  end
  Log([[
[SafeLocalOsTime] os.time final fail, return epoch 0 : 
%s]], tostring(errorMsg))
  return 0
end
