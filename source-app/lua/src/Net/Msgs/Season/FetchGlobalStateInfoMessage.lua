local FetchGlobalStateInfoMessage = BaseClass("FetchGlobalStateInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchGlobalStateInfoMessage:OnCreate()
  base.OnCreate(self)
end

function FetchGlobalStateInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    return
  end
  if t ~= nil and t.list ~= nil then
    DataCenter.SeasonDataManager:SetGlobalStatus(t.list)
    DataCenter.ServerStatusManager:SetGlobalStatus(t.list)
    EventManager:GetInstance():Broadcast(EventId.LuaEntryEffectRefreshStatus)
  end
end

return FetchGlobalStateInfoMessage
