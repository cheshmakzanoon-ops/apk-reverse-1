local GetEarthOrderMessage = BaseClass("GetEarthOrderMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", param.type)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  DataCenter.EarthOrderDataManager:GetEarthOrderHandle(message)
end

GetEarthOrderMessage.OnCreate = OnCreate
GetEarthOrderMessage.HandleMessage = HandleMessage
return GetEarthOrderMessage
