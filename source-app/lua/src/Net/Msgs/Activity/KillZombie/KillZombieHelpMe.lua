local KillZombieHelpMe = BaseClass("KillZombieHelpMe", SFSBaseMessage)
local base = SFSBaseMessage

function KillZombieHelpMe:OnCreate()
  base.OnCreate(self)
end

function KillZombieHelpMe:HandleMessage(data)
  base.HandleMessage(self, data)
end

return KillZombieHelpMe
