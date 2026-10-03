local UserGetPuzzleBossRankMessage = BaseClass("UserGetPuzzleBossRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.ActivityPuzzleDataManager:HandleMessageUserGetPuzzleBossRank(t)
end

UserGetPuzzleBossRankMessage.OnCreate = OnCreate
UserGetPuzzleBossRankMessage.HandleMessage = HandleMessage
return UserGetPuzzleBossRankMessage
