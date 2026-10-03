local BloodyQueenBattleAreaRankMessage = BaseClass("BloodyQueenBattleAreaRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BloodyQueenBattleAreaRankMessage:OnCreate(param)
  base.OnCreate(self)
end

function BloodyQueenBattleAreaRankMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.PushBloodyQueenBattleAreaRank, t)
  end
end

return BloodyQueenBattleAreaRankMessage
