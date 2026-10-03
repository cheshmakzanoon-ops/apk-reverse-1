local Logger = BaseClass("Logger")
local CS_DEBUG = CS.GameFramework.Log.LUA_Debug
local CS_INFO = CS.GameFramework.Log.Info
local CS_WARNING = CS.GameFramework.Log.Warning
local CS_ERROR = CS.GameFramework.Log.LUA_Error
local IsWriteLog = CS.CommonUtils.IsWriteLog()

local function MakeMsg(...)
  local msg
  local c = select("#", ...)
  if c == 0 then
    return
  elseif c == 1 then
    msg = select(1, ...)
  else
    msg = table.concat({
      ...
    }, "")
  end
  return msg
end

local function MakeErrorMsg(...)
  local msg
  local c = select("#", ...)
  if c == 0 then
    return
  elseif c == 1 then
    msg = select(1, ...)
  else
    msg = table.concat({
      ...
    }, "")
  end
  return msg
end

local function Log(...)
  if CS.CommonUtils.IsDebug() or CS.UnityEngine.Application.isEditor then
    local msg = MakeMsg(...)
    if not msg then
      return
    end
    CS_DEBUG(msg)
  end
end

local function LogInfo(...)
  local msg = MakeMsg(...)
  if not msg then
    return
  end
  CS_INFO(msg)
end

local function LogWarning(...)
  local msg = MakeMsg(...)
  if not msg then
    return
  end
  CS_WARNING(debug.traceback(msg, 2))
end

local function LogError(...)
  local msg = MakeErrorMsg(...)
  if not msg then
    return
  end
  CS_ERROR(debug.traceback(msg, 2))
end

local function LogCustom(msg, color, tag)
  if CS.CommonUtils.IsDebug() or CS.UnityEngine.Application.isEditor then
    color = color or "65FF00"
    if tag then
      msg = string.format("<color=#%s>[%s]%s</color>", color, tag, msg)
    else
      msg = string.format("<color=#%s>%s</color>", color, msg)
    end
    CS_DEBUG(debug.traceback(msg, 2))
  end
end

function logErrorWithTag(tag, ...)
  CS_ERROR(debug.traceback("#" .. tag .. "# " .. tostring(...)))
end

function printError(fmt, ...)
  logErrorWithTag("ERR", string.format(tostring(fmt), ...) .. "\n" .. debug.traceback("", 2))
end

function Logger.Table(value, desciption, nesting)
  if type(nesting) ~= "number" then
    nesting = 3
  end
  local lookup = {}
  local result = {}
  
  local function trim(input)
    input = string.gsub(input, "^[ \t\n\r]+", "")
    return string.gsub(input, "[ \t\n\r]+$", "")
  end
  
  local function split(input, delimiter)
    input = tostring(input)
    delimiter = tostring(delimiter)
    if delimiter == "" then
      return false
    end
    local pos, arr = 0, {}
    for st, sp in function()
      return string.find(input, delimiter, pos, true)
    end, nil, nil do
      table.insert(arr, string.sub(input, pos, st - 1))
      pos = sp + 1
    end
    table.insert(arr, string.sub(input, pos))
    return arr
  end
  
  local traceback = split(debug.traceback("", 2), "\n")
  local tLen = #traceback
  local fromStr = trim(traceback[3] .. "\n")
  if 3 < tLen then
    fromStr = trim(traceback[4] .. "\n")
  end
  local logStr = "<color=#a9ff16>dump from: " .. fromStr .. "</color>"
  
  local function _dump_value(v)
    if type(v) == "string" then
      v = "\"" .. v .. "\""
    end
    return tostring(v)
  end
  
  local function _dump(value, desciption, indent, nest, keylen)
    desciption = desciption or "<var>"
    local spc = ""
    if type(keylen) == "number" then
      spc = string.rep(" ", keylen - string.len(_dump_value(desciption)))
    end
    if type(value) ~= "table" then
      result[#result + 1] = string.format("%s%s%s = %s", indent, _dump_value(desciption), spc, _dump_value(value))
    elseif lookup[tostring(value)] then
      result[#result + 1] = string.format("%s%s%s = *REF*", indent, _dump_value(desciption), spc)
    else
      lookup[tostring(value)] = true
      if nest > nesting then
        result[#result + 1] = string.format("%s%s = *MAX NESTING*", indent, _dump_value(desciption))
      else
        result[#result + 1] = string.format("%s%s = {", indent, _dump_value(desciption))
        local indent2 = indent .. "    "
        local keys = {}
        local keylen = 0
        local values = {}
        for k, v in pairs(value) do
          keys[#keys + 1] = k
          local vk = _dump_value(k)
          local vkl = string.len(vk)
          if keylen < vkl then
            keylen = vkl
          end
          values[k] = v
        end
        table.sort(keys, function(a, b)
          if type(a) == "number" and type(b) == "number" then
            return a < b
          else
            return tostring(a) < tostring(b)
          end
        end)
        for i = 1, #keys do
          local k = keys[i]
          _dump(values[k], k, indent2, nest + 1, keylen)
        end
        result[#result + 1] = string.format("%s}", indent)
      end
    end
  end
  
  _dump(value, desciption, "", 1)
  local maxLine = #result
  for i = 1, maxLine do
    logStr = logStr .. "\n" .. result[i]
    if string.len(logStr) > 13000 or i == maxLine then
      print(logStr)
      logStr = ""
    end
  end
  return result
end

Logger.Log = Log
Logger.LogInfo = LogInfo
Logger.LogWarning = LogWarning
Logger.LogError = LogError
Logger.LogCustom = LogCustom
return Logger
