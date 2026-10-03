local GetStrongholdBattleStateMessage = BaseClass("GetStrongholdBattleStateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetStrongholdBattleStateMessage:OnCreate(serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
end

function GetStrongholdBattleStateMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t.serverId and t.inBattleIds then
    DataCenter.WorldAllianceCityDataManager:SetStrongholdBattleState(t.serverId, t.inBattleIds)
  end
end

return GetStrongholdBattleStateMessage
