local KillZombieHelpOther = BaseClass("KillZombieHelpOther", SFSBaseMessage)
local base = SFSBaseMessage

function KillZombieHelpOther:OnCreate()
  base.OnCreate(self)
end

function KillZombieHelpOther:HandleMessage(data)
  base.HandleMessage(self, data)
end

return KillZombieHelpOther
