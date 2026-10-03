local GetPuzzleBossMarchMessage = BaseClass("GetPuzzleBossMarchMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.ActivityPuzzleDataManager:HandleMessageGetPuzzleBossMarch(t)
end

GetPuzzleBossMarchMessage.OnCreate = OnCreate
GetPuzzleBossMarchMessage.HandleMessage = HandleMessage
return GetPuzzleBossMarchMessage
