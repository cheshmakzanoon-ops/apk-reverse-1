local WearSkinMessage = BaseClass("WearSkinMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, skinId)
  base.OnCreate(self)
  self.sfsObj:PutInt("skinId", skinId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.DecorationDataManager:WearSkinHandler(t)
end

WearSkinMessage.OnCreate = OnCreate
WearSkinMessage.HandleMessage = HandleMessage
return WearSkinMessage
