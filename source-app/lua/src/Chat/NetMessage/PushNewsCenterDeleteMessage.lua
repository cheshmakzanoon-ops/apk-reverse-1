local PushNewsCenterDeleteMessage = BaseClass("PushNewsCenterDeleteMessage", SFSBaseMessage)

local function OnCreate(self, tbl)
end

local function HandleMessage(self, serverData)
  if not serverData or serverData.types then
  end
end

PushNewsCenterDeleteMessage.OnCreate = OnCreate
PushNewsCenterDeleteMessage.HandleMessage = HandleMessage
return PushNewsCenterDeleteMessage
