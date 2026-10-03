local GetNewCenterMessage = BaseClass("GetNewCenterMessage", SFSBaseMessage)

local function OnCreate(self, type, priority)
  self.sfsObj:PutInt("type", type)
  if priority then
    self.sfsObj:PutInt("priority", priority)
  end
end

local function HandleMessage(self, msg)
end

GetNewCenterMessage.OnCreate = OnCreate
GetNewCenterMessage.HandleMessage = HandleMessage
return GetNewCenterMessage
