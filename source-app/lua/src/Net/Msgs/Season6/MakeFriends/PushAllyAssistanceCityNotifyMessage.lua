local PushAllyAssistanceCityNotifyMessage = BaseClass("PushAllyAssistanceCityNotifyMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAllyAssistanceCityNotifyMessage:OnCreate()
  base.OnCreate(self)
end

function PushAllyAssistanceCityNotifyMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    return
  end
  if t.assistanceAlliance then
    t.userInfo = t.assistanceAlliance
    t.fromAllianceId = t.assistanceAlliance.allianceId
  end
  EventManager:GetInstance():Broadcast(EventId.PushAllianceFriendsHelpMe, t)
end

return PushAllyAssistanceCityNotifyMessage
