local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local GetCustomRoomListV2Command = BaseClass("GetCustomRoomListV2Command", WebSocketBaseMessage)
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

GetCustomRoomListV2Command.OnCreate = OnCreate
GetCustomRoomListV2Command.HandleMessage = HandleMessage
return GetCustomRoomListV2Command
