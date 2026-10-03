local PushNewsCenterAddMessage = BaseClass("PushNewsCenterAddMessage", SFSBaseMessage)

local function OnCreate(self, tbl)
end

local function HandleMessage(self, serverData)
  if serverData and serverData.types then
    DataCenter.LWNewsCenterManager:UpdateRed(serverData.types)
  end
end

PushNewsCenterAddMessage.OnCreate = OnCreate
PushNewsCenterAddMessage.HandleMessage = HandleMessage
return PushNewsCenterAddMessage
