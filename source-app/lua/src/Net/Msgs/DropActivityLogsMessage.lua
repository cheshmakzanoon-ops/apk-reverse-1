local DropActivityLogsMessage = BaseClass("DropActivityLogsMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DropActivityLogsMessage:OnCreate(activityId, day, type)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("day", day or 1)
  self.sfsObj:PutInt("type", type or 1)
end

function DropActivityLogsMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActLimitedTimeFeastData:UpdateActivityDropHistory(t)
    EventManager:GetInstance():Broadcast(EventId.ActLimitedTimeFeastHistoryDataUpdate)
  end
end

return DropActivityLogsMessage
