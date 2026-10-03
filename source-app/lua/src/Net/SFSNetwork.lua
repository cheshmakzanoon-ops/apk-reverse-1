local MsgMap = require("Net.Config.MsgMap")
local Network = CS.GameEntry.Network
local MsgTypeMap = {}
local SFSNetwork = {}

local function GetMsgType(cmd)
  local msgType = MsgTypeMap[cmd]
  if type(msgType) ~= "table" then
    local msgTypePath = MsgMap[cmd]
    if msgTypePath ~= nil then
      local loaded = require(msgTypePath)
      if type(loaded) == "table" then
        msgType = loaded
        MsgTypeMap[cmd] = msgType
      else
        Logger.LogWarning("[\232\173\166\229\145\138] \230\168\161\229\157\151\229\138\160\232\189\189\229\164\177\232\180\165\239\188\129\232\191\148\229\155\158\231\177\187\229\158\139\233\157\158 table\239\188\140cmd:" .. tostring(cmd) .. "\239\188\140type:" .. type(loaded) .. "\239\188\140path:" .. tostring(msgTypePath))
        CS.GameEntry.DebugLuaFile(msgTypePath)
      end
    end
  end
  return msgType
end

function SFSNetwork.SendMessage(cmd, ...)
  local msgType = GetMsgType(cmd)
  local msg = msgType:NewMessage(...)
  Network:SendLuaMessage(cmd, msg:ToBinary())
  if _G._processInitMessage ~= nil and _G._processInitMessage then
    local errorMsg = string.format("SFSNetwork.SendMessage during init message process, move to GameMain.OnEnterGame: %s, %s", tostring(cmd), debug.traceback())
    Logger.LogError(errorMsg)
  end
end

function SFSNetwork.HandleMessage(cmd, t)
  local msgType = GetMsgType(cmd)
  if msgType ~= nil then
    local ok, errorMsg = xpcall(function()
      local msg = msgType:NewEmpty()
      msg:HandleMessage(t)
      return true
    end, debug.traceback)
    if not ok then
      local now = UITimeManager:GetInstance():GetServerSeconds()
      CommonUtil.SendErrorMessageToServer(now, now, errorMsg)
      Logger.LogError(errorMsg)
      return false
    else
      return true
    end
  end
  return false
end

SFSNetwork.GetMsgType = GetMsgType
return SFSNetwork
