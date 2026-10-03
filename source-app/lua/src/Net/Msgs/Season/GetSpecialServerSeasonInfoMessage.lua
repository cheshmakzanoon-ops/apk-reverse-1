local GetSpecialServerSeasonInfoMessage = BaseClass("GetSpecialServerSeasonInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local SeasonInfoTemplate = require("DataCenter.SeasonManager.SeasonInfoTemplate")

function GetSpecialServerSeasonInfoMessage:OnCreate(serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", toInt(serverId))
end

function GetSpecialServerSeasonInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    Logger.Log(errCode)
  else
    if t.serverId and t.serverSeasonInfo then
      local infoList = DataCenter.SeasonDataManager.SpecialServerSeasonInfoList or {}
      local data = SeasonInfoTemplate.New(t.serverId, t.serverSeasonInfo, t.bigMap)
      local serverListInt = data:GetServerListInt(false)
      infoList[t.serverId] = data
      if serverListInt and data.isSingleServerMode ~= true then
        for _, serverId in pairs(serverListInt) do
          if SeasonUtil.GetSeasonInfo(serverId) == nil then
            infoList[toInt(serverId)] = SeasonInfoTemplate.New(serverId, t.serverSeasonInfo, t.bigMap)
          else
            Logger.LogInfo(" SpecialServerSeasonInfo : skip " .. tostring(serverId))
          end
        end
      end
      DataCenter.SeasonDataManager.SpecialServerSeasonInfoList = infoList
      if CS.CommonUtils.IsDebug() and CS.UnityEngine.Application.isEditor then
        Logger.Log(data:Description())
        Logger.LogInfo("SpecialServerSeasonInfo : " .. tostring(t.serverId) .. " , " .. tostring(data.seasonConfigId) .. " , " .. tostring(data.isSingleServerMode))
      end
    end
    EventManager:GetInstance():Broadcast(EventId.SpecialServerSeasonInfoUpdate, t.serverId)
    if t.campInfo then
      pcall(function()
        local mgr = CS.SeasonDataManager.Instance
        if mgr.UpdateServerCampData then
          mgr:UpdateServerCampData(t.campInfo)
        end
      end)
    end
  end
end

return GetSpecialServerSeasonInfoMessage
