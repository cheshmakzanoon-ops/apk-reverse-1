local CrossServerListMessage = BaseClass("CrossServerListMessage", SFSBaseMessage)

local function OnCreate(self)
end

local function HandleMessage(self, t)
end

CrossServerListMessage.OnCreate = OnCreate
CrossServerListMessage.HandleMessage = HandleMessage
return CrossServerListMessage
