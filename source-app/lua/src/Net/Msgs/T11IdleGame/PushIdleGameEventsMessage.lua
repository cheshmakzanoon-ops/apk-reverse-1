local PushIdleGameEventsMessage = BaseClass("PushIdleGameEventsMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushIdleGameEventsMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushIdleGameEventsMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.T11IdleGameDataManager:ParsePushGameEvent(t)
    EventManager:GetInstance():Broadcast(EventId.T11IdleGameTaskEventListRefresh)
    EventManager:GetInstance():Broadcast(EventId.T11IdleGameTaskEventDetailRefresh)
  end
end

return PushIdleGameEventsMessage
