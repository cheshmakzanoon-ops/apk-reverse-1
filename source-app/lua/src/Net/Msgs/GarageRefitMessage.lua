local GarageRefitMessage = BaseClass("GarageRefitMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", param.uuid)
  self.sfsObj:PutInt("count", param.count)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    return
  end
  if t.resources ~= nil then
    LuaEntry.Resource:UpdateResource(t.resources)
  end
  EventManager:GetInstance():Broadcast(EventId.GarageRefitUpdate, t)
end

GarageRefitMessage.OnCreate = OnCreate
GarageRefitMessage.HandleMessage = HandleMessage
return GarageRefitMessage
