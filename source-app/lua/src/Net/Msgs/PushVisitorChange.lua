local PushVisitorChange = BaseClass("PushVisitorChange", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message then
    DataCenter.CityVisitorManager:AddVisitor(message.visitor)
  end
end

PushVisitorChange.OnCreate = OnCreate
PushVisitorChange.HandleMessage = HandleMessage
return PushVisitorChange
