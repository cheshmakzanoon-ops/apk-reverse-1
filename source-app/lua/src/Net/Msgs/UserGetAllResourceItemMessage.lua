local UserGetAllResourceItemMessage = BaseClass("UserGetAllResourceItemMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.ResourceItemDataManager:DoWhenStorageMaxErrorHandle(t)
end

UserGetAllResourceItemMessage.OnCreate = OnCreate
UserGetAllResourceItemMessage.HandleMessage = HandleMessage
return UserGetAllResourceItemMessage
