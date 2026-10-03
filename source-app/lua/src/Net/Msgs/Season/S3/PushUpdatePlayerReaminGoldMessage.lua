local PushUpdatePlayerReaminGoldMessage = BaseClass("PushUpdatePlayerReaminGoldMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushUpdatePlayerReaminGoldMessage:OnCreate()
  base.OnCreate(self)
end

function PushUpdatePlayerReaminGoldMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.remainGold ~= nil then
    LuaEntry.Player.gold = t.remainGold
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
end

return PushUpdatePlayerReaminGoldMessage
