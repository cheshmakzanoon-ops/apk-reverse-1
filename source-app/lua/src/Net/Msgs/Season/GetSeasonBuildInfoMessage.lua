local GetSeasonBuildInfoMessage = BaseClass("GetSeasonBuildInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetSeasonBuildInfoMessage:OnCreate()
  base.OnCreate(self)
end

function GetSeasonBuildInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode == nil and t.list then
    DataCenter.SeasonDataManager.PlayerBuildList = t.list
    EventManager:GetInstance():Broadcast(EventId.LWSeasonPlayerBuildListUpdate)
    return
  end
end

return GetSeasonBuildInfoMessage
