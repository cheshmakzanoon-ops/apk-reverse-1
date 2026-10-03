local FetchSeasonMummyConvertHistoryMessage = BaseClass("FetchSeasonMummyConvertHistoryMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchSeasonMummyConvertHistoryMessage:OnCreate()
  base.OnCreate(self)
end

function FetchSeasonMummyConvertHistoryMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.list then
    EventManager:GetInstance():Broadcast(EventId.RefreshSeasonMummyConvertHistory, t.list)
  end
end

return FetchSeasonMummyConvertHistoryMessage
