local FetchSeasonFactionWarInviteListMessage = BaseClass("FetchSeasonFactionWarInviteListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchSeasonFactionWarInviteListMessage:OnCreate()
  base.OnCreate(self)
end

function FetchSeasonFactionWarInviteListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  EventManager:GetInstance():Broadcast(EventId.LWSeasonFactionWarInviteListUpdate, t.list)
end

return FetchSeasonFactionWarInviteListMessage
