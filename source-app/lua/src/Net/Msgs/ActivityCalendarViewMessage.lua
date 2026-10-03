local ActivityCalendarViewMessage = BaseClass("ActivityCalendarViewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ActivityCalendarViewMessage:OnCreate(param)
  base.OnCreate(self)
end

function ActivityCalendarViewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActCalendarManager:OnUpdateActServerData(t)
  end
end

return ActivityCalendarViewMessage
