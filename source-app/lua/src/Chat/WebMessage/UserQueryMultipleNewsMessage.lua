local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local UserQueryMultipleNewsMessage = BaseClass("UserQueryMultipleNewsMessage", WebSocketBaseMessage)

local function OnCreate(self, md5Array, lang, extraData)
  self.tableData.md5Array = md5Array
  self.tableData.lang = lang
  self.tableData.extraData = extraData
end

local function HandleMessage(self, serverData)
  if serverData and serverData.data then
    DataCenter.LWNewsCenterManager:OnGetNewsInfosMsg(serverData)
    EventManager:GetInstance():BroadcastDeferred(EventId.CHAT_NEWSCENTER_DATAS_UPDATE)
  end
end

UserQueryMultipleNewsMessage.OnCreate = OnCreate
UserQueryMultipleNewsMessage.HandleMessage = HandleMessage
return UserQueryMultipleNewsMessage
