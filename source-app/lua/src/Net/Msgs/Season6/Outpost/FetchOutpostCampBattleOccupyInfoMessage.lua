local FetchOutpostCampBattleOccupyInfoMessage = BaseClass("FetchOutpostCampBattleOccupyInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchOutpostCampBattleOccupyInfoMessage:OnCreate(serverId, cityId, campId)
  base.OnCreate(self)
  self.sfsObj:PutInt("cityId", cityId)
  self.sfsObj:PutInt("clientServerId", serverId)
  self.sfsObj:PutInt("campId", campId)
end

function FetchOutpostCampBattleOccupyInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode == nil then
    local serverId = toInt(t.clientServerId)
    local cityId = toInt(t.cityId)
    local campId = toInt(t.campId)
    if 0 < cityId and 0 < serverId and 0 < campId then
      EventManager:GetInstance():Broadcast(EventId.OutpostBattleOccupyServerInfoUpdate, t)
    end
  end
end

return FetchOutpostCampBattleOccupyInfoMessage
