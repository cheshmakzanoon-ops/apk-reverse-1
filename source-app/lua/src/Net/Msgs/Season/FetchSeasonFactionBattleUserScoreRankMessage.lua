local FetchSeasonFactionBattleUserScoreRankMessage = BaseClass("FetchSeasonFactionBattleUserScoreRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchSeasonFactionBattleUserScoreRankMessage:OnCreate()
  base.OnCreate(self)
end

function FetchSeasonFactionBattleUserScoreRankMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  EventManager:GetInstance():Broadcast(EventId.LWSeasonFactionBattleScoreRank, t)
end

return FetchSeasonFactionBattleUserScoreRankMessage
