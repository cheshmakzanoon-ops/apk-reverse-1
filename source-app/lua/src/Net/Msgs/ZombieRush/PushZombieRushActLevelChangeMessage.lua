local PushZombieRushActLevelChangeMessage = BaseClass("PushZombieRushActLevelChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushZombieRushActLevelChangeMessage:OnCreate()
  base.OnCreate(self)
end

function PushZombieRushActLevelChangeMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  DataCenter.LWZombieRushPlanInfoManager:UpdatePlanInfo(message)
  EventManager:GetInstance():Broadcast(EventId.UpdateZombieRushLevelInfo)
end

return PushZombieRushActLevelChangeMessage
