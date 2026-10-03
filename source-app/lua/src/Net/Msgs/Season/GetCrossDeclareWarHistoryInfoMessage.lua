local GetCrossDeclareWarHistoryInfoMessage = BaseClass("GetCrossDeclareWarHistoryInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetCrossDeclareWarHistoryInfoMessage:OnCreate()
  base.OnCreate(self)
end

function GetCrossDeclareWarHistoryInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonDataManager.CrossDeclareWarHistoryInfo = t
  EventManager:GetInstance():Broadcast(EventId.LWSeasonCrossDeclareWarHistoryInfo)
end

return GetCrossDeclareWarHistoryInfoMessage
