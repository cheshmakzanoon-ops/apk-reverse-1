local ActivityContentBase = BaseClass("ActivityContentBase", UIBaseView)
local base = UIBaseView

function ActivityContentBase:OnCreate()
  base.OnCreate(self)
end

function ActivityContentBase:OnDestroy()
  base.OnDestroy(self)
end

function ActivityContentBase:OnAddListener()
  base.OnAddListener(self)
end

function ActivityContentBase:OnRemoveListener()
  base.OnRemoveListener(self)
end

function ActivityContentBase:SetData(activityId)
  self.activityId = activityId
  EventManager:GetInstance():Broadcast(EventId.GF_open_activity_content, {
    activityId = self.activityId
  })
end

return ActivityContentBase
