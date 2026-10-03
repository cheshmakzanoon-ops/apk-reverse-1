local FetchOutpostCampBattleOccupyListMessage = BaseClass("FetchOutpostCampBattleOccupyListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchOutpostCampBattleOccupyListMessage:OnCreate(serverId, cityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("cityId", cityId)
  self.sfsObj:PutInt("clientServerId", serverId)
end

function FetchOutpostCampBattleOccupyListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode == nil then
    local serverId = toInt(t.clientServerId)
    local cityId = toInt(t.cityId)
    if 0 < cityId and 0 < serverId then
      t.now = UITimeManager:GetInstance():GetServerTime()
      DataCenter.SeasonOutpostManager:SetOutpostCampBattleInfo(serverId, cityId, t)
      EventManager:GetInstance():Broadcast(EventId.OutpostBattleOccupyListUpdate, cityId)
    end
  end
end

return FetchOutpostCampBattleOccupyListMessage
