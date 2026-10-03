local PushActBerserkBossUpdateMessage = BaseClass("PushActBerserkBossUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushActBerserkBossUpdateMessage:OnCreate()
  base.OnCreate(self)
end

function PushActBerserkBossUpdateMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  DataCenter.LWBerserkBossManager:HandleUpdateBerserkBossRewardAndTimes(message.actBerserkBoss, true)
end

return PushActBerserkBossUpdateMessage
