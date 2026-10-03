local FetchSeasonFactionDeclareEnemyInfoMessage = BaseClass("FetchSeasonFactionDeclareEnemyInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchSeasonFactionDeclareEnemyInfoMessage:OnCreate(targetAllianceId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("targetAllianceId", targetAllianceId)
end

function FetchSeasonFactionDeclareEnemyInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t.targetAllianceId ~= nil then
    EventManager:GetInstance():Broadcast(EventId.LWSeasonFactionWarEnemyInfoUpdate, t)
  end
end

return FetchSeasonFactionDeclareEnemyInfoMessage
