local GetPuzzleBossRankRewardInfoMessage = BaseClass("GetPuzzleBossRankRewardInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.ActivityPuzzleDataManager:HandleMessageGetPuzzleBossRankRewardInfo(t)
end

GetPuzzleBossRankRewardInfoMessage.OnCreate = OnCreate
GetPuzzleBossRankRewardInfoMessage.HandleMessage = HandleMessage
return GetPuzzleBossRankRewardInfoMessage
