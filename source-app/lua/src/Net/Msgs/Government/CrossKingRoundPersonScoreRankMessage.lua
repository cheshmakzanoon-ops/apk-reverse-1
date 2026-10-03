local CrossKingRoundPersonScoreRankMessage = BaseClass("CrossKingRoundPersonScoreRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CrossKingRoundPersonScoreRankMessage:OnCreate()
  base.OnCreate(self)
end

function CrossKingRoundPersonScoreRankMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t and t.ls then
    DataCenter.ZoneWarManager:SetCrossKingRoundRank(SeverBattleScoreRankType.PERSON, t.ls)
    EventManager:GetInstance():Broadcast(EventId.PlayerRank)
  end
end

return CrossKingRoundPersonScoreRankMessage
