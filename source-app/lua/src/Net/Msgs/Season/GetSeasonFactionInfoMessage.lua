local GetSeasonFactionInfoMessage = BaseClass("GetSeasonFactionInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetSeasonFactionInfoMessage:OnCreate()
  base.OnCreate(self)
end

function GetSeasonFactionInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  end
  if t.groupingActInfo then
    DataCenter.SeasonFactionWarDataManager.groupingActInfo = t.groupingActInfo
    DataCenter.SeasonFactionWarDataManager.groupingMode = t.groupingActInfo.step ~= 1
  elseif t.campInfo then
    DataCenter.SeasonFactionWarDataManager.groupingMode = false
  end
  if t.campInfo then
    local mySourceServerId = LuaEntry.Player:GetSourceServerId()
    DataCenter.SeasonFactionWarDataManager.seasonFactionInfo = t.campInfo
    for k, v in pairs(t.campInfo) do
      if v.serverId == mySourceServerId then
        Setting:SetPrivateBool("EnableShowSnowCampInfoToALL", v.showSelect == 1)
        DataCenter.SeasonFactionWarDataManager.myCampId = v.campId
        break
      end
    end
    pcall(function()
      local mgr = CS.SeasonDataManager.Instance
      if mgr.UpdateServerCampData then
        mgr:UpdateServerCampData(t.campInfo)
      end
    end)
    EventManager:GetInstance():Broadcast(EventId.LWSeasonFactionInfoUpdate)
  end
end

return GetSeasonFactionInfoMessage
