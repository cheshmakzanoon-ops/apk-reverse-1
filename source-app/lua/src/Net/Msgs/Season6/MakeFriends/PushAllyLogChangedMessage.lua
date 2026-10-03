local PushAllyLogChangedMessage = BaseClass("PushAllyLogChangedMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAllyLogChangedMessage:OnCreate()
  base.OnCreate(self)
end

function PushAllyLogChangedMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    return
  end
  local playType = t.playType
  local eventType = t.eventType
  if playType and eventType then
    SFSNetwork.SendMessage(MsgDefines.FetchAllianceAllyLogList, playType, eventType, 1, 9)
  end
end

return PushAllyLogChangedMessage
