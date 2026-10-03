local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local RoomQuitCustomRoomListCommand = BaseClass("RoomQuitCustomRoomListCommand", WebSocketBaseMessage)

local function OnCreate(self, roomIds)
  self.tableData.group = "custom"
  self.tableData.roomIds = roomIds
end

local function HandleMessage(self, msg)
  if msg.errorCode then
    UIUtil.ShowErrorCodeTips(msg)
  else
    local serverData = msg.result
    if serverData.status == false then
      return
    end
    local array = serverData.ids
    if array == nil then
      return
    end
    local roomMgr = ChatManager2:GetInstance().Room
    local category
    for i, roomId in ipairs(array) do
      local data = roomMgr:GetRoomData(roomId)
      if data then
        category = data.category
      end
      roomMgr:RemoveRoomData(roomId)
    end
    if category then
      EventManager:GetInstance():Broadcast(ChatEventEnum.Chat_QuitRoom, {category = category})
    end
  end
end

RoomQuitCustomRoomListCommand.OnCreate = OnCreate
RoomQuitCustomRoomListCommand.HandleMessage = HandleMessage
return RoomQuitCustomRoomListCommand
