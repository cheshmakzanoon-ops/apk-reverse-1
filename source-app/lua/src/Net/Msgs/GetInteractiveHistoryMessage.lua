local GetInteractiveHistoryMessage = BaseClass("GetInteractiveHistoryMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetInteractiveHistoryMessage:OnCreate()
  base.OnCreate(self)
end

function GetInteractiveHistoryMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.PlayerInfoDataManager:SetPlayerInteractiveHistory(t.receive, t.send)
  EventManager:GetInstance():Broadcast(EventId.RefreshInteractiveHistory)
end

return GetInteractiveHistoryMessage
