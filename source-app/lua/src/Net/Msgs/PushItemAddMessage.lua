local PushItemAddMessage = BaseClass("PushItemAddMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.ItemData:UpdateOneItem(t, true, false)
end

PushItemAddMessage.OnCreate = OnCreate
PushItemAddMessage.HandleMessage = HandleMessage
return PushItemAddMessage
