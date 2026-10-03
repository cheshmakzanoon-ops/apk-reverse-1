local GrowthPlanGetInfoMessage = BaseClass("GrowthPlanGetInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  WelfareController.setWelfareCache(WelfareMessageKey.GrowthPlanInfo, t)
  EventManager:GetInstance():Broadcast(EventId.GrowthPlanGetInfo, t)
  EventManager:GetInstance():Broadcast(EventId.RefreshWelfareRedDot)
end

GrowthPlanGetInfoMessage.OnCreate = OnCreate
GrowthPlanGetInfoMessage.HandleMessage = HandleMessage
return GrowthPlanGetInfoMessage
