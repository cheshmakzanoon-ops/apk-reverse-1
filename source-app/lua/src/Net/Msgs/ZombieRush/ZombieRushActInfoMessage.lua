local ZombieRushActInfoMessage = BaseClass("ZombieRushActInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ZombieRushActInfoMessage:OnCreate()
  base.OnCreate(self)
end

function ZombieRushActInfoMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  DataCenter.LWZombieRushManager:UpdateActInfo(message)
end

return ZombieRushActInfoMessage
