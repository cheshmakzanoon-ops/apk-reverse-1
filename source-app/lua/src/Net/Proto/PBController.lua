local PBController = BaseClass("PBController")
local rapidjson = require("rapidjson")
local pb = require("pb")
local protoc = require("Common.protoc")
local base64 = require("Framework.Common.base64")
local ProtoConfig = {
  "Assets/Main/Proto/Wrappers.proto.bytes",
  "Assets/Main/Proto/BattleReport.proto.bytes",
  "Assets/Main/Proto/LwBattleReport.proto.bytes",
  "Assets/Main/Proto/Mail.proto.bytes",
  "Assets/Main/Proto/AllianceCityRecordProto.proto.bytes",
  "Assets/Main/Proto/WorldPointInfo.proto.bytes",
  "Assets/Main/Proto/ArmyUnitInfo.proto.bytes",
  "Assets/Main/Proto/DeliteReport.proto.bytes",
  "Assets/Main/Proto/WorldCityRankMail.proto.bytes",
  "Assets/Main/Proto/DestroyMail.proto.bytes",
  "Assets/Main/Proto/LwScoutReport.proto.bytes",
  "Assets/Main/Proto/ShieldInfo.proto.bytes"
}

function PBController.InitBytes(bytes)
  protoc:loadBytes(bytes)
end

function PBController.InitPBConfig()
end

function PBController.LoadBytes(filename)
  local luafile = CS.UnityEngine.Application.dataPath .. "/Proto/" .. filename
  local file = io.open(luafile, "r")
  local data = file:read("*a")
  file:close()
  protoc:loadBytes(data)
end

function PBController.ParsePb1(strBinary, pbType)
  local bytes = base64.decode(strBinary)
  local success, ret = pcall(function()
    return pb.decode(pbType, bytes)
  end)
  if success then
    return ret
  else
    Logger.LogError(string.format("ParseProtoError:%s|%s|%s", ret, pbType, strBinary))
  end
end

function PBController.ParsePbFromBytes(bytes, pbType)
  local success, ret = pcall(function()
    return pb.decode(pbType, bytes)
  end)
  if success then
    return ret
  else
    local strBinary = base64.encode(bytes)
    Logger.LogError(string.format("ParseProtoError:%s|%s|%s", ret, pbType, strBinary))
  end
end

PBController.ProtoConfig = ProtoConfig
return PBController
