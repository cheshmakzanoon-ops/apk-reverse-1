local PushNewsCenterInitMessage = BaseClass("PushNewsCenterInitMessage", SFSBaseMessage)

local function OnCreate(self, tbl)
end

local function HandleMessage(self, serverData)
  if serverData and serverData.data then
    DataCenter.LWNewsCenterManager:InitNewsCenterDatas(serverData.data.newsInit)
  end
end

PushNewsCenterInitMessage.OnCreate = OnCreate
PushNewsCenterInitMessage.HandleMessage = HandleMessage
return PushNewsCenterInitMessage
