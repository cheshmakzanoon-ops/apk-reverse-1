local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local ShareNewsCenterMessage = BaseClass("ShareNewsCenterMessage", WebSocketBaseMessage)

local function OnCreate(self, tbl)
  self.tableData.md5Url = tbl.md5Url
  self.tableData.lang = tbl.lang
  self.tableData.roomId = tbl.roomId
end

local function HandleMessage(self, serverData)
  if serverData and serverData.data then
    DataCenter.LWNewsCenterManager:OnShareNewsMd5(serverData.data)
  end
end

ShareNewsCenterMessage.OnCreate = OnCreate
ShareNewsCenterMessage.HandleMessage = HandleMessage
return ShareNewsCenterMessage
