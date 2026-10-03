local ZombieRushRewardInfoMessage = BaseClass("ZombieRushRewardInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ZombieRushRewardInfoMessage:OnCreate(templateId)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", templateId)
end

function ZombieRushRewardInfoMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  DataCenter.LWZombieRushManager:UpdateReward(message)
end

return ZombieRushRewardInfoMessage
