local ActBerserkBossGetRewardInfoMessage = BaseClass("PushActBerserkBossUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ActBerserkBossGetRewardInfoMessage:OnCreate()
  base.OnCreate(self)
end

function ActBerserkBossGetRewardInfoMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  DataCenter.LWBerserkBossManager:HandleRefreshBerserkBossRankRewardInfo(message)
end

return ActBerserkBossGetRewardInfoMessage
