local RecycleConsumeLogsMessage = BaseClass("RecycleConsumeLogsMessage", SFSBaseMessage)
local base = SFSBaseMessage

function RecycleConsumeLogsMessage:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

function RecycleConsumeLogsMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.ActRecycleReceiveConsumeHistoryMsg, t.dataArr)
  end
end

return RecycleConsumeLogsMessage
