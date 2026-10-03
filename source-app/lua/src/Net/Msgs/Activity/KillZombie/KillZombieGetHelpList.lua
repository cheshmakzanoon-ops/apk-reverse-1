local KillZombieGetHelpList = BaseClass("KillZombieGetHelpList", SFSBaseMessage)
local base = SFSBaseMessage

function KillZombieGetHelpList:OnCreate()
  base.OnCreate(self)
end

function KillZombieGetHelpList:HandleMessage(data)
  base.HandleMessage(self, data)
end

return KillZombieGetHelpList
