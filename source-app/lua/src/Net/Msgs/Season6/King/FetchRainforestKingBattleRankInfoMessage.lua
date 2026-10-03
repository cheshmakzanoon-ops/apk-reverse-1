local FetchRainforestKingBattleRankInfoMessage = BaseClass("FetchRainforestKingBattleRankInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchRainforestKingBattleRankInfoMessage:OnCreate()
  base.OnCreate(self)
end

function FetchRainforestKingBattleRankInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  EventManager:GetInstance():Broadcast(EventId.RainforestKingBattleRankUpdate, t)
end

return FetchRainforestKingBattleRankInfoMessage
