local GetAllMarchesOfAlMineMessage = BaseClass("GetAllMarchesOfAlMineMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
end

GetAllMarchesOfAlMineMessage.OnCreate = OnCreate
GetAllMarchesOfAlMineMessage.HandleMessage = HandleMessage
return GetAllMarchesOfAlMineMessage
