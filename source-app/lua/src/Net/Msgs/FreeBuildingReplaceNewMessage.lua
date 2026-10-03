local FreeBuildingReplaceNewMessage = BaseClass("FreeBuildingReplaceNewMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutLong("buildUuid", param.buildUuid)
    self.sfsObj:PutInt("pointId", param.pointId)
  end
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  DataCenter.BuildManager:FreeBuildingReplaceNewHandle(message)
end

FreeBuildingReplaceNewMessage.OnCreate = OnCreate
FreeBuildingReplaceNewMessage.HandleMessage = HandleMessage
return FreeBuildingReplaceNewMessage
