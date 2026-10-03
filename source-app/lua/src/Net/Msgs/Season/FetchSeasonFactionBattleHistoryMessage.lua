local FetchSeasonFactionBattleHistoryMessage = BaseClass("FetchSeasonFactionBattleHistoryMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchSeasonFactionBattleHistoryMessage:OnCreate(theType, round)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", theType)
  self.sfsObj:PutInt("round", round)
end

function FetchSeasonFactionBattleHistoryMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  EventManager:GetInstance():Broadcast(EventId.LWSeasonFactionBattleHistory, t)
end

return FetchSeasonFactionBattleHistoryMessage
