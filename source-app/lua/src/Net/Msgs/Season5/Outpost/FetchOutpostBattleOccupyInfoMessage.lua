local FetchOutpostBattleOccupyInfoMessage = BaseClass("FetchOutpostBattleOccupyInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchOutpostBattleOccupyInfoMessage:OnCreate(serverId, cityId, targetServerId)
  base.OnCreate(self)
  self.sfsObj:PutInt("cityId", cityId)
  self.sfsObj:PutInt("clientServerId", serverId)
  self.sfsObj:PutInt("targetServerId", targetServerId)
end

function FetchOutpostBattleOccupyInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode == nil then
    local serverId = toInt(t.clientServerId)
    local cityId = toInt(t.cityId)
    local targetServerId = toInt(t.targetServerId)
    if 0 < cityId and 0 < serverId and 0 < targetServerId then
      EventManager:GetInstance():Broadcast(EventId.OutpostBattleOccupyServerInfoUpdate, t)
    end
  end
end

return FetchOutpostBattleOccupyInfoMessage
