local UserGetAllBerserkBossMarchMessage = BaseClass("UserGetAllBerserkBossMarchMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UserGetAllBerserkBossMarchMessage:OnCreate()
  base.OnCreate(self)
end

function UserGetAllBerserkBossMarchMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  DataCenter.LWBerserkBossManager:HandleInitAllBerserkBossInfo(message)
end

return UserGetAllBerserkBossMarchMessage
