local IdleGameEventHelpMessage = BaseClass("IdleGameEventHelpMessage", SFSBaseMessage)
local base = SFSBaseMessage

function IdleGameEventHelpMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("targetUid", param.playerUid)
  self.sfsObj:PutLong("eventUuid", param.eventUuid)
  self.sfsObj:PutInt("eventId", param.eventId)
end

function IdleGameEventHelpMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.T11IdleGameTaskEventAllHelpViewRefresh, t)
  end
end

return IdleGameEventHelpMessage
