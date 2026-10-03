local RecycleBuyLogsMessage = BaseClass("RecycleBuyLogsMessage", SFSBaseMessage)
local base = SFSBaseMessage

function RecycleBuyLogsMessage:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

function RecycleBuyLogsMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.ActRecycleReceiveBuyHistoryMsg, t.dataArr)
  end
end

return RecycleBuyLogsMessage
