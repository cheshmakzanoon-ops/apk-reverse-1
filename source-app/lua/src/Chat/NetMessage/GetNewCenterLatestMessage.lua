local GetNewCenterLatestMessage = BaseClass("GetNewCenterLatestMessage", SFSBaseMessage)

local function OnCreate(self, type, uid)
  self.sfsObj:PutInt("type", type)
  self.sfsObj:PutLong("uuid", uid)
end

local function HandleMessage(self, msg)
end

GetNewCenterLatestMessage.OnCreate = OnCreate
GetNewCenterLatestMessage.HandleMessage = HandleMessage
return GetNewCenterLatestMessage
