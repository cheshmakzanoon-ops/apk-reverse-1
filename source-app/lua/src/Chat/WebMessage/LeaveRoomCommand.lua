local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local LeaveRoomCommand = BaseClass("LeaveRoomCommand", WebSocketBaseMessage)

local function OnCreate(self, roomId, group)
  self.tableData.roomId = roomId
  if group then
    self.tableData.group = group
  end
end

local function HandleMessage(self, msg)
  if msg.result.status ~= true then
    ChatPrint("leave room error?")
  end
  ChatPrint("leave room id = " .. tostring(msg.result.id) .. ", status = " .. tostring(msg.result.status))
  if msg and msg.result then
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_REFRESH_CHANNEL, {
      roomId = msg.result.id,
      group = msg.result.group
    })
  end
end

LeaveRoomCommand.OnCreate = OnCreate
LeaveRoomCommand.HandleMessage = HandleMessage
return LeaveRoomCommand
