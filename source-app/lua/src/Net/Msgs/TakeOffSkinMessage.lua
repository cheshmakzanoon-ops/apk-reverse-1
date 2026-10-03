local TakeOffSkinMessage = BaseClass("TakeOffSkinMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, skinId)
  base.OnCreate(self)
  self.sfsObj:PutInt("skinId", skinId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.DecorationDataManager:TakeOffSkinHandler(t)
end

TakeOffSkinMessage.OnCreate = OnCreate
TakeOffSkinMessage.HandleMessage = HandleMessage
return TakeOffSkinMessage
