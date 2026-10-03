local FiveStarMessage = BaseClass("FiveStarMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, index)
  base.OnCreate(self)
  self.sfsObj:PutInt("platforom", index)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
end

FiveStarMessage.OnCreate = OnCreate
FiveStarMessage.HandleMessage = HandleMessage
return FiveStarMessage
