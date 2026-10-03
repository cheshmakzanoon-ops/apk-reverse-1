local PushSeasonFactionGroupingFinishMessage = BaseClass("PushSeasonFactionGroupingFinishMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushSeasonFactionGroupingFinishMessage:OnCreate()
  base.OnCreate(self)
end

function PushSeasonFactionGroupingFinishMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  DataCenter.SeasonFactionWarDataManager.groupingMode = false
  if t and t.campInfo then
    local mySourceServerId = LuaEntry.Player:GetSourceServerId()
    DataCenter.SeasonFactionWarDataManager.seasonFactionInfo = t.campInfo
    for k, v in pairs(t.campInfo) do
      if v.serverId == mySourceServerId then
        DataCenter.SeasonFactionWarDataManager.myCampId = v.campId
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

return PushSeasonFactionGroupingFinishMessage
