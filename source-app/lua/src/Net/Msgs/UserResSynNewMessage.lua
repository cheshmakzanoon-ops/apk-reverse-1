local UserResSynNewMessage = BaseClass("UserResSynNewMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutInt("resourceType", param.resourceType)
    if param.resourceType == ResourceType.ResourceItem and param.itemId ~= nil then
      self.sfsObj:PutUtfString("itemId", tostring(param.itemId))
    end
  end
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  DataCenter.BuildManager:UserResSynNewHandle(message)
end

UserResSynNewMessage.OnCreate = OnCreate
UserResSynNewMessage.HandleMessage = HandleMessage
return UserResSynNewMessage
