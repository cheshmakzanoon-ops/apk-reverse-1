local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local GetCustomRoomListCommand = BaseClass("GetCustomRoomListCommand", WebSocketBaseMessage)
local rapidjson = require("rapidjson")

local function OnCreate(self, tbl)
  self.tableData.group = ChatGroupType.GROUP_CUSTOM_GROUP
end

local function HandleMessage(self, data)
  local result = data.result
  local roomMgr = ChatManager2:GetInstance().Room
  local rooms = result.rooms
  roomMgr:SetIsNewPrivateList(data.isPartial)
  roomMgr:OnGetCustomRoomList(rooms)
  roomMgr:OnInitRoomCmdBack()
end

GetCustomRoomListCommand.OnCreate = OnCreate
GetCustomRoomListCommand.HandleMessage = HandleMessage
return GetCustomRoomListCommand
