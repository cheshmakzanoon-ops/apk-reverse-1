local PushNewsCenterGetMessage = BaseClass("PushNewsCenterGetMessage", SFSBaseMessage)

local function OnCreate(self, tbl)
end

local function HandleMessage(self, serverData)
  if serverData then
    DataCenter.LWNewsCenterManager:UpdateNewsCenter(serverData.data)
  end
end

PushNewsCenterGetMessage.OnCreate = OnCreate
PushNewsCenterGetMessage.HandleMessage = HandleMessage
return PushNewsCenterGetMessage
