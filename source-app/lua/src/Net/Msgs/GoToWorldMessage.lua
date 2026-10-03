local GoToWorldMessage = BaseClass("GoToWorldMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
end

GoToWorldMessage.OnCreate = OnCreate
GoToWorldMessage.HandleMessage = HandleMessage
return GoToWorldMessage
