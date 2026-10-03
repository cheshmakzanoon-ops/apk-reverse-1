local ActivityTrendInfoMessage = BaseClass("ActivityTrendInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.ActTrendsDataManager:InitTrendData(t)
end

ActivityTrendInfoMessage.OnCreate = OnCreate
ActivityTrendInfoMessage.HandleMessage = HandleMessage
return ActivityTrendInfoMessage
