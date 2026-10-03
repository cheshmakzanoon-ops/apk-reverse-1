local PushStrongholdBattleStateMessage = BaseClass("PushStrongholdBattleStateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushStrongholdBattleStateMessage:OnCreate()
  base.OnCreate(self)
end

function PushStrongholdBattleStateMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t.serverId and t.id and t.isBattle ~= nil then
    DataCenter.WorldAllianceCityDataManager:UpdateStrongholdBattleState(t.serverId, t.id, t.isBattle)
  end
end

return PushStrongholdBattleStateMessage
