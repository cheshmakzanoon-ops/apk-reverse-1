local IdleGameEventAllMessage = BaseClass("IdleGameEventAllMessage", SFSBaseMessage)
local base = SFSBaseMessage

function IdleGameEventAllMessage:OnCreate()
  base.OnCreate(self)
end

function IdleGameEventAllMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.T11IdleGameDataManager:ParseAllGameEvent(t)
    EventManager:GetInstance():Broadcast(EventId.T11IdleGameTaskEventListRefresh)
  end
end

return IdleGameEventAllMessage
