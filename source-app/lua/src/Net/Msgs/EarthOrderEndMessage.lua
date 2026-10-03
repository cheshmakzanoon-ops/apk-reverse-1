local EarthOrderEndMessage = BaseClass("EarthOrderEndMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutLong("uuid", param.uuid)
  end
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.resource ~= nil then
    LuaEntry.Resource:UpdateResource(message.resource)
  end
  if message.additionalMoney then
  end
  DataCenter.EarthOrderDataManager:EarthOrderEndHandle(message)
end

EarthOrderEndMessage.OnCreate = OnCreate
EarthOrderEndMessage.HandleMessage = HandleMessage
return EarthOrderEndMessage
