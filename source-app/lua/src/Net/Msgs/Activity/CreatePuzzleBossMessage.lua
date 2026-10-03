local CreatePuzzleBossMessage = BaseClass("CreatePuzzleBossMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, monsterId)
  base.OnCreate(self)
  self.sfsObj:PutInt("monsterId", monsterId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.ActivityPuzzleDataManager:HandleMessageCreatePuzzleBoss(t)
end

CreatePuzzleBossMessage.OnCreate = OnCreate
CreatePuzzleBossMessage.HandleMessage = HandleMessage
return CreatePuzzleBossMessage
