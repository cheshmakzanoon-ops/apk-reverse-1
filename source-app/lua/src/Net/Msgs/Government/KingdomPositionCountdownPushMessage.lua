local KingdomPositionCountdownPushMessage = BaseClass("KingdomPositionCountdownPushMessage", SFSBaseMessage)
local base = SFSBaseMessage

function KingdomPositionCountdownPushMessage:OnCreate(param)
  base.OnCreate(self)
end

function KingdomPositionCountdownPushMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.RefreshKingdomPositionCountDown)
  end
end

return KingdomPositionCountdownPushMessage
