local PushSeasonInfoUpdateMessage = BaseClass("PushSeasonInfoUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage
local SeasonInfoTemplate = require("DataCenter.SeasonManager.SeasonInfoTemplate")

function PushSeasonInfoUpdateMessage:OnCreate()
  base.OnCreate(self)
end

function PushSeasonInfoUpdateMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    return
  end
  if t.serverId and t.serverSeasonInfo then
    local loginServerId = LuaEntry.Player:GetSelfServerId()
    local mySourceServerId = LuaEntry.Player:GetSourceServerId()
    local curServerId = LuaEntry.Player:GetCurServerId()
    local infoList = DataCenter.SeasonDataManager.SpecialServerSeasonInfoList or {}
    local curServerInfo = infoList[toInt(curServerId)]
    local isSingleServerMode_curServ_s5_old = false
    if curServerInfo ~= nil then
      isSingleServerMode_curServ_s5_old = curServerInfo.isSingleServerMode
    end
    local isSingleServerMode_loginServ_s5_old = false
    local loginServerInfo = infoList[toInt(loginServerId)]
    if loginServerInfo ~= nil then
      isSingleServerMode_loginServ_s5_old = loginServerInfo.isSingleServerMode
    end
    local data = SeasonInfoTemplate.New(t.serverId, t.serverSeasonInfo, t.bigMap)
    infoList[t.serverId] = data
    if t.serverId == mySourceServerId then
      DataCenter.SeasonDataManager.playerSeasonInfo = data
      DataCenter.SeasonDataManager.nextSeasonStartTime = data.nextSeasonStartTime
    end
    if t.serverId == loginServerId then
      DataCenter.SeasonDataManager.serverSeasonInfo = data
    end
    if data.serverListInt then
      if data.isSingleServerMode ~= true then
        for serverId, _ in pairs(data.serverListInt) do
          local nServerId = toInt(serverId)
          if SeasonUtil.GetSeasonInfo(serverId) == nil then
            infoList[nServerId] = SeasonInfoTemplate.New(serverId, t.serverSeasonInfo, t.bigMap)
            if nServerId == mySourceServerId then
              DataCenter.SeasonDataManager.playerSeasonInfo = infoList[nServerId]
              DataCenter.SeasonDataManager.nextSeasonStartTime = infoList[nServerId].nextSeasonStartTime
            end
            if nServerId == loginServerId then
              DataCenter.SeasonDataManager.serverSeasonInfo = infoList[nServerId]
            end
          else
            Logger.LogInfo(" SpecialServerSeasonInfo : push skip " .. tostring(serverId))
          end
        end
      else
        for serverId, _ in pairs(data.serverListInt) do
          local nServerId = toInt(serverId)
          if nServerId ~= t.serverId then
            SFSNetwork.SendMessage(MsgDefines.GetSpecialServerSeasonInfo, nServerId)
          end
        end
      end
    end
    DataCenter.SeasonDataManager.SpecialServerSeasonInfoList = infoList
    if CS.CommonUtils.IsDebug() and CS.UnityEngine.Application.isEditor then
      Logger.Log(data:Description())
    end
    DataCenter.SeasonDataManager:InitSeasonActivity(true)
    DataCenter.ActivityListDataManager:UpdateActivityInfo()
    EventManager:GetInstance():Broadcast(EventId.SpecialServerSeasonInfoUpdate, t.serverId)
    EventManager:GetInstance():Broadcast(EventId.SeasonStatusChanged, t.serverId)
    local needBroadcast = false
    local newMode = t.serverSeasonInfo.singleServerMode
    if t.serverId == curServerId and isSingleServerMode_curServ_s5_old ~= newMode then
      needBroadcast = true
    end
    if t.serverId == loginServerId and isSingleServerMode_loginServ_s5_old ~= newMode then
      needBroadcast = true
    end
    if needBroadcast then
      EventManager:GetInstance():Broadcast(EventId.OnS5ChangeToSingleServerMode)
    end
  end
end

return PushSeasonInfoUpdateMessage
