local CrossKingRoundAllianceScoreRankMessage = BaseClass("CrossKingRoundAllianceScoreRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CrossKingRoundAllianceScoreRankMessage:OnCreate()
  base.OnCreate(self)
end

function CrossKingRoundAllianceScoreRankMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t and t.ls then
    DataCenter.ZoneWarManager:SetCrossKingRoundRank(SeverBattleScoreRankType.ALLIANCE, t.ls)
    EventManager:GetInstance():Broadcast(EventId.AllianceRank)
  end
end

return CrossKingRoundAllianceScoreRankMessage
