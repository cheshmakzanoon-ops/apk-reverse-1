local ExpireBuildingRemoveMessage = BaseClass("ExpireBuildingRemoveMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid)
  base.OnCreate()
  self.sfsObj:PutUtfString("uuid", uuid)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
end

ExpireBuildingRemoveMessage.OnCreate = OnCreate
ExpireBuildingRemoveMessage.HandleMessage = HandleMessage
return ExpireBuildingRemoveMessage
