local RecycleLotteryLogsMessage = BaseClass("RecycleLotteryLogsMessage", SFSBaseMessage)
local base = SFSBaseMessage

function RecycleLotteryLogsMessage:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

function RecycleLotteryLogsMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.ActRecycleReceiveLotteryHistoryMsg, t.dataArr)
  end
end

return RecycleLotteryLogsMessage
