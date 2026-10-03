local ReceivePveMonsterRewardMessage = BaseClass("ReceivePveMonsterRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, pveMonsterId)
  base.OnCreate(self)
  self.sfsObj:PutInt("pveMonsterId", pveMonsterId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.MonsterLockDataManager:DoWhenReceiveMonsterRewardBack(t)
end

ReceivePveMonsterRewardMessage.OnCreate = OnCreate
ReceivePveMonsterRewardMessage.HandleMessage = HandleMessage
return ReceivePveMonsterRewardMessage
