local FetchOutpostBattleRankMessage = BaseClass("FetchOutpostBattleRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchOutpostBattleRankMessage:OnCreate()
  base.OnCreate(self)
end

function FetchOutpostBattleRankMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  EventManager:GetInstance():Broadcast(EventId.OutpostBattleRankRefresh, t)
end

return FetchOutpostBattleRankMessage
