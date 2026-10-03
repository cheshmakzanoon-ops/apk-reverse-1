local PushRemainGoldWhenErrorcodeTriggeredMessage = BaseClass("PushRemainGoldWhenErrorcodeTriggeredMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushRemainGoldWhenErrorcodeTriggeredMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushRemainGoldWhenErrorcodeTriggeredMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.remainGold ~= nil then
    LuaEntry.Player.gold = t.remainGold
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
end

return PushRemainGoldWhenErrorcodeTriggeredMessage
