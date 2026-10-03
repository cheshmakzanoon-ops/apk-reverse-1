local PushSkinUpdate = BaseClass("PushSkinUpdate", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.DecorationDataManager:PushSkinUpdateHandler(t)
end

PushSkinUpdate.OnCreate = OnCreate
PushSkinUpdate.HandleMessage = HandleMessage
return PushSkinUpdate
