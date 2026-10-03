local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local GetCustomP2PRoomList = BaseClass("GetCustomP2PRoomList", WebSocketBaseMessage)

local function OnCreate(self, page, pageSize)
  self.tableData.page = math.ceil(page)
  self.tableData.pageSize = pageSize
end

local function HandleMessage(self, data)
  if data and data.result then
    ChatManager2:GetInstance().Room:NewPriveRoomListCreate(data)
  end
end

GetCustomP2PRoomList.OnCreate = OnCreate
GetCustomP2PRoomList.HandleMessage = HandleMessage
return GetCustomP2PRoomList
