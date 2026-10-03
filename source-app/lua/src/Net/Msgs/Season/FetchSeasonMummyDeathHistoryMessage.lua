local FetchSeasonMummyDeathHistoryMessage = BaseClass("FetchSeasonMummyDeathHistoryMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchSeasonMummyDeathHistoryMessage:OnCreate()
  base.OnCreate(self)
end

function FetchSeasonMummyDeathHistoryMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.list then
    EventManager:GetInstance():Broadcast(EventId.RefreshSeasonMummyDeathHistory, t.list)
  end
end

return FetchSeasonMummyDeathHistoryMessage
