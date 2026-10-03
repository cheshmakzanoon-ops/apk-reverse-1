local PushNewActivityMessage = BaseClass("PushNewActivityMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.ActivityListDataManager:AddOneActivity(1, t)
  DataCenter.ActivityListDataManager:AddActivityByPushAtPassDay(t.id)
  EventManager:GetInstance():Broadcast(EventId.OnUpdateActivityEventData, t.id)
  EventManager:GetInstance():Broadcast(EventId.OnRecvNewActivityInfo)
end

PushNewActivityMessage.OnCreate = OnCreate
PushNewActivityMessage.HandleMessage = HandleMessage
return PushNewActivityMessage
