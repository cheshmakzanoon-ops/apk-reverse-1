local GetPuzzleActivityInfoMessage = BaseClass("GetPuzzleActivityInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("activityId", tostring(activityId))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.ActivityPuzzleDataManager:HandleMessageGetInfo(t)
end

GetPuzzleActivityInfoMessage.OnCreate = OnCreate
GetPuzzleActivityInfoMessage.HandleMessage = HandleMessage
return GetPuzzleActivityInfoMessage
