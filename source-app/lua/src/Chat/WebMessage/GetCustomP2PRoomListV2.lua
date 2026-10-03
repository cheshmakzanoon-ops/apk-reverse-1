local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local GetCustomP2PRoomListV2 = BaseClass("GetCustomP2PRoomListV2", WebSocketBaseMessage)

local function OnCreate(self)
  local param = ChatInterface.getRoomMgr():GetP2PListCountParam()
  self.tableData.p2pIndex = param.privateCount
  self.tableData.cgIndex = param.groupChatCount
  self.tableData.kgIndex = param.kickedChatCount
  self.tableData.pageSize = PrivateListPage
  self.tableData.group = ChatGroupType.GROUP_CUSTOM_GROUP
end

local function HandleMessage(self, data)
  if data and data.result then
    ChatManager2:GetInstance().Room:NewPriveRoomListCreate(data)
  end
end

GetCustomP2PRoomListV2.OnCreate = OnCreate
GetCustomP2PRoomListV2.HandleMessage = HandleMessage
return GetCustomP2PRoomListV2
