local PushZombieRushActPlanChangeMessage = BaseClass("PushZombieRushActPlanChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushZombieRushActPlanChangeMessage:OnCreate()
  base.OnCreate(self)
end

function PushZombieRushActPlanChangeMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  DataCenter.LWZombieRushPlanInfoManager:UpdateActInfo(message)
  EventManager:GetInstance():Broadcast(EventId.UpdateZombieRushPlanInfo)
end

return PushZombieRushActPlanChangeMessage
