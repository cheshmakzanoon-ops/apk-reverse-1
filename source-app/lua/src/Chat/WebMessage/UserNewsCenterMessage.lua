local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local UserNewsCenterMessage = BaseClass("UserNewsCenter", WebSocketBaseMessage)

local function OnCreate(self, uuid, type, lang)
  if uuid then
    self.tableData.uuid = uuid
  end
  if type then
    self.tableData.type = type
  end
  if lang then
    self.tableData.lang = lang
  end
end

local function HandleMessage(self, serverData)
  if serverData and serverData.data then
    DataCenter.LWNewsCenterManager:UpdateCacheData(serverData.data.uuid, serverData.data.newsInfo)
  end
end

UserNewsCenterMessage.OnCreate = OnCreate
UserNewsCenterMessage.HandleMessage = HandleMessage
return UserNewsCenterMessage
