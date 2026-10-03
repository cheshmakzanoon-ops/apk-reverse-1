local util = require("Common.Tools.cjson.util")
local WriteLogUtil = {}
local namePath = util.GetPersistentDataPath() .. "/" .. "Debug.txt"
local file

local function OpenFile()
  file = io.open(namePath, "w")
  file:write("")
end

local function WriteToFile(msg)
  if file ~= nil then
    file:write(msg)
    file:write("\n")
  end
end

local function CloseFile()
  file:close()
  file = nil
end

WriteLogUtil.WriteToFile = WriteToFile
WriteLogUtil.CloseFile = CloseFile
WriteLogUtil.OpenFile = OpenFile
return ConstClass("WriteLogUtil", WriteLogUtil)
