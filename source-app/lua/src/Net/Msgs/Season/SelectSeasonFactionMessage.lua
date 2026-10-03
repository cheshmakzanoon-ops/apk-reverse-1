local SelectSeasonFactionMessage = BaseClass("SelectSeasonFactionMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SelectSeasonFactionMessage:OnCreate(campId, force)
  base.OnCreate(self)
  self.sfsObj:PutInt("campId", campId)
  self.sfsObj:PutInt("force", force)
end

function SelectSeasonFactionMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if errCode == "season_server_camp_tip001" then
      SFSNetwork.SendMessage(MsgDefines.GetSeasonFactionInfo)
      SFSNetwork.SendMessage(MsgDefines.GetSeasonFactionHistory, 0, 10)
    end
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonFactionWarDataManager.groupingMode = true
  if t.campInfo then
    local mySourceServerId = LuaEntry.Player:GetSourceServerId()
    for serverId, v in pairs(t.campInfo) do
      if toInt(serverId) == mySourceServerId and v.campId ~= nil and v.campId ~= 0 then
        DataCenter.SeasonFactionWarDataManager.myCampId = v.campId
        Setting:SetPrivateInt("SelectSeasonFaction", v.campId)
      end
    end
    DataCenter.SeasonFactionWarDataManager.seasonFactionInfo = t.campInfo
    EventManager:GetInstance():Broadcast(EventId.LWSeasonFactionInfoUpdate)
  end
  if t.history then
    t.pageNum = 0
    t.pageSize = 10
    DataCenter.SeasonDataManager.seasonFactionHistory = t
    EventManager:GetInstance():Broadcast(EventId.LWSeasonFactionHistory, t)
  end
end

return SelectSeasonFactionMessage
