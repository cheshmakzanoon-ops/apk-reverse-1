local GetStrongholdOccupyProgressMessage = BaseClass("GetStrongholdOccupyProgressMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetStrongholdOccupyProgressMessage:OnCreate(strongholdId, serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("strongholdId", strongholdId)
  self.sfsObj:PutInt("serverId", serverId)
end

function GetStrongholdOccupyProgressMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.serverId and t.strongholdId and t.progress then
    DataCenter.WorldAllianceCityDataManager:UpdateStrongholdBattleData(t.serverId, t.strongholdId, t)
  end
  EventManager:GetInstance():Broadcast(EventId.CityStrongholdOccupyProgressRefresh, t)
end

return GetStrongholdOccupyProgressMessage
