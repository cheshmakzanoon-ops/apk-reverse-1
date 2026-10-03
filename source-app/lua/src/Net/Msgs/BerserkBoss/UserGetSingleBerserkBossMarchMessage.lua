local UserGetSingleBerserkBossMarchMessage = BaseClass("UserGetSingleBerserkBossMarchMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UserGetSingleBerserkBossMarchMessage:OnCreate(bossUuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", bossUuid)
end

function UserGetSingleBerserkBossMarchMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  DataCenter.LWBerserkBossManager:HandleUpdateSingleBerserkBossInfo(message)
end

return UserGetSingleBerserkBossMarchMessage
