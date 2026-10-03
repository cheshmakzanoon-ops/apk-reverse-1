local PushResourceDataUpdateMessage = BaseClass("PushResourceDataUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.ResourceItemDataManager:RefreshItemList(t)
end

PushResourceDataUpdateMessage.OnCreate = OnCreate
PushResourceDataUpdateMessage.HandleMessage = HandleMessage
return PushResourceDataUpdateMessage
