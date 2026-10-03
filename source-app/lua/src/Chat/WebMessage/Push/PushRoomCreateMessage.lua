local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local PushRoomCreateMessage = BaseClass("PushRoomCreateMessage", WebSocketBaseMessage)
local RoomDataParser = require("Chat.WebMessage.Push.RoomDataParser")
local ChatViewController = require("UI.UIChatNew.Controller.ChatViewUtils")
local rapidjson = require("rapidjson")

local function OnCreate(self)
end

local function DoFirstPersonalTalk(roomData)
  local myUserId = ChatInterface.getPlayerUid()
  if roomData.owner == myUserId and roomData:isPrivateChat() then
    local roomManager = ChatManager2:GetInstance().Room
    EventManager:GetInstance():Broadcast(ChatEventEnum.LF_ChatCellSelect, roomData.roomId)
    local tragetUid = roomData:GetPrivateUser()
    local remainMsgTable = roomManager:getTempPersonMsg(tragetUid)
    if remainMsgTable ~= nil and remainMsgTable.msgList ~= nil then
      local msgId = ChatEventEnum.CHAT_SEND_ROOM_MSG_COMMAND
      for _, msg in ipairs(remainMsgTable.msgList) do
        local t = {
          roomId = roomData.roomId,
          msg = msg,
          extra = remainMsgTable.extra
        }
        EventManager:GetInstance():Broadcast(msgId, t)
      end
    end
    roomManager:clearTempPersonMsg(tragetUid)
  end
end

local function HandleMessage(self, serverData)
  local roomInfo = RoomDataParser.DecodeRoomInfo(serverData)
  local msgs = RoomDataParser.DecodeMsgs(serverData)
  if roomInfo == nil then
    print("data nil")
    return
  end
  ChatViewController:GetInstance():SetPrivateUserInfo(nil)
  local roomManager = ChatManager2:GetInstance().Room
  local roomData = roomManager:CreateChatRoom(roomInfo.roomId, roomInfo.group)
  roomInfo.lastMsgTime = UITimeManager:GetInstance():GetServerTime()
  roomData:onParseServerData(roomInfo)
  local chatData, members, isAdd
  if msgs then
    chatData, members, isAdd = RoomDataParser.ProcessMsgs(msgs, "add")
  end
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_REFRESH_CHANNEL)
  if isAdd then
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_RECIEVE_ROOM_MSG, chatData)
  end
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ROOM_CREATE_RESULT, roomData)
  DoFirstPersonalTalk(roomData)
end

PushRoomCreateMessage.OnCreate = OnCreate
PushRoomCreateMessage.HandleMessage = HandleMessage
return PushRoomCreateMessage
