local ActBerserkBossGetUserScoreMessage = BaseClass("PushActBerserkBossUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ActBerserkBossGetUserScoreMessage:OnCreate(uid)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("uid", uid)
end

function ActBerserkBossGetUserScoreMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  DataCenter.LWBerserkBossManager:HandleBerserkBossUserDamageStatistics(message)
end

return ActBerserkBossGetUserScoreMessage
