local PushAllyAssistanceMarchArriveMessage = BaseClass("PushAllyAssistanceMarchArriveMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAllyAssistanceMarchArriveMessage:OnCreate()
  base.OnCreate(self)
end

function PushAllyAssistanceMarchArriveMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    return
  end
  EventManager:GetInstance():Broadcast(EventId.PushAllianceFriendsHelp, t)
end

return PushAllyAssistanceMarchArriveMessage
