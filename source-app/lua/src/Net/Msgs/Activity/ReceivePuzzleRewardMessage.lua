local ReceivePuzzleRewardMessage = BaseClass("ReceivePuzzleRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.ActivityPuzzleDataManager:HandleMessageGetPuzzleReward(t)
end

ReceivePuzzleRewardMessage.OnCreate = OnCreate
ReceivePuzzleRewardMessage.HandleMessage = HandleMessage
return ReceivePuzzleRewardMessage
