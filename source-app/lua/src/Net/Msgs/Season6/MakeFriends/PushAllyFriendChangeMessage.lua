local PushAllyFriendChangeMessage = BaseClass("PushAllyFriendChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAllyFriendChangeMessage:OnCreate()
  base.OnCreate(self)
end

function PushAllyFriendChangeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    return
  end
  if t.allianceId1 then
    SFSNetwork.SendMessage(MsgDefines.GetAllianceInfo, t.allianceId1)
  end
  if t.allianceId2 then
    SFSNetwork.SendMessage(MsgDefines.GetAllianceInfo, t.allianceId2)
  end
  if t.type == 1 then
    local now = UITimeManager:GetInstance():GetServerTime()
    local myAllianceId = LuaEntry.Player.allianceId
    if myAllianceId == t.allianceId1 then
      DataCenter.SeasonAllyFriendManager:SetFriendAllianceId(t.allianceId2, now)
    elseif myAllianceId == t.allianceId2 then
      DataCenter.SeasonAllyFriendManager:SetFriendAllianceId(t.allianceId1, now)
    end
    SFSNetwork.SendMessage(MsgDefines.WorldGetAllianceMark)
    SFSNetwork.SendMessage(MsgDefines.FetchAllianceAllyInfo, myAllianceId)
    EventManager:GetInstance():Broadcast(EventId.PushAllianceHaveFriendsUpdate, true)
  elseif t.type == 2 then
    DataCenter.SeasonAllyFriendManager:CleanData()
    DataCenter.WorldFavoDataManager:DropFriendsAllianceMark()
    EventManager:GetInstance():Broadcast(EventId.PushAllianceFriendsLeaveUpdate, true)
  end
end

return PushAllyFriendChangeMessage
