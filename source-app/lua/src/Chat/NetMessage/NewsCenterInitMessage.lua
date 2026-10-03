local NewsCenterInitMessage = BaseClass("NewsCenterInitMessage", SFSBaseMessage)

local function OnCreate(self)
end

local function HandleMessage(self, msg)
end

NewsCenterInitMessage.OnCreate = OnCreate
NewsCenterInitMessage.HandleMessage = HandleMessage
return NewsCenterInitMessage
