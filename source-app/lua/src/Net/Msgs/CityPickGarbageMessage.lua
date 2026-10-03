local CityPickGarbageMessage = BaseClass("CityPickGarbageMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutLong("uuid", param.uuid)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.GuideCityManager:CityPickGarbageHandle(t)
end

CityPickGarbageMessage.OnCreate = OnCreate
CityPickGarbageMessage.HandleMessage = HandleMessage
return CityPickGarbageMessage
