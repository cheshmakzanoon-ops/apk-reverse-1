local PushNewsCenterLatestMessage = BaseClass("PushNewsCenterLatestMessage", SFSBaseMessage)

local function OnCreate(self, tbl)
end

local function HandleMessage(self, serverData)
  if serverData and serverData then
    DataCenter.LWNewsCenterManager:UpdateNewsCenter(serverData.data)
  end
end

PushNewsCenterLatestMessage.OnCreate = OnCreate
PushNewsCenterLatestMessage.HandleMessage = HandleMessage
return PushNewsCenterLatestMessage
