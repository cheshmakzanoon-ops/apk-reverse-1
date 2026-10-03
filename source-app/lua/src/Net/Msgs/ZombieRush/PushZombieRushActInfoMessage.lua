local PushZombieRushActInfoMessage = BaseClass("PushZombieRushActInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushZombieRushActInfoMessage:OnCreate()
  base.OnCreate(self)
end

function PushZombieRushActInfoMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  DataCenter.LWZombieRushManager:UpdateActInfo(message)
end

return PushZombieRushActInfoMessage
