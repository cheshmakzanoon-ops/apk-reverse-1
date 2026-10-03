local FetchBattleTeamInfoMessage = BaseClass("FetchBattleTeamInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchBattleTeamInfoMessage:OnCreate(teamUuid, serverId, worldId)
  base.OnCreate(self)
  self.sfsObj:PutLong("teamUuid", teamUuid)
  self.sfsObj:PutInt("serverId", serverId)
  self.sfsObj:PutInt("worldId", worldId)
end

function FetchBattleTeamInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    return
  end
  if t.teamUuid and t.resistanceValue then
    EventManager:GetInstance():Broadcast(EventId.BattleTeamInfoRefresh, t)
  end
end

return FetchBattleTeamInfoMessage
