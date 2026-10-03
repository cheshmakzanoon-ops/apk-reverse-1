local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local GetHistoryMsgsCommand = BaseClass("GetHistoryMsgsCommand", WebSocketBaseMessage)

local function SetGetOldestMsgRoom(idToTimes)
  local easterEggRoomId = ChatManager2:GetInstance().Room:GetEasterEggRoomId()
  for id, v in pairs(idToTimes) do
    if id == easterEggRoomId then
      idToTimes[id] = "1"
    end
  end
end

local function setRoomIds(ids)
  local idToTimes = {}
  for _, id in ipairs(ids) do
    idToTimes[id] = "0"
  end
  return idToTimes
end

local function OnCreate(self, ids)
  local t = setRoomIds(ids)
  SetGetOldestMsgRoom(t)
  self.tableData.rooms = t
end

local function HandleMessage(self, msg)
  if msg and msg.result and msg.result.rooms and table.count(msg.result.rooms) == 1 then
    local room = msg.result.rooms[1]
    if room.group == ChatGroupType.GROUP_EASTER_EGG_ROOM then
      DataCenter.ActEasterEggManager:SetReadyForFirstPart(true)
      ChatManager2:GetInstance().Room:onRequestLatestMsg_EasterEggChat(msg)
      DataCenter.ActEasterEggManager:ParseAndAddChatDataToRoom(room.msgs)
      return
    end
  end
  if msg and msg.result and msg.result.rooms then
    for _, data in pairs(msg.result.rooms) do
      local roomData = ChatManager2:GetInstance().Room:GetRoomData(data.roomId)
      if roomData ~= nil then
        roomData.__todo__inited = true
      end
    end
  end
  ChatManager2:GetInstance().Room:onRequestLatestMsg(msg)
  ChatManager2:GetInstance().Room:onJoinRoomOK()
  if not ChatManager2:GetInstance().Room:IsInitPullDone() then
    ChatManager2:GetInstance().Room:OnInitPullCmdBack()
    ChatManager2:GetInstance().Room:InitPrivateLastMsg()
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_INIT_PULL_DONE)
  end
  if msg and msg.result and table.count(msg.result.rooms) == 1 then
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ONE_ROOM_HISTORY_MSG, msg.result.rooms[1])
  end
  if msg and msg.result and msg.result.rooms then
    local room = msg.result.rooms[1]
    if room.group == ChatGroupType.GROUP_FRIENDS_CIRCLE_ROOM or room.group == ChatGroupType.GROUP_FRIENDS_CIRCLE_COMMENT_ROOM then
      return
    end
  end
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_REQUEST_HISTORY_MSG_RESULT, msg.result)
end

GetHistoryMsgsCommand.OnCreate = OnCreate
GetHistoryMsgsCommand.HandleMessage = HandleMessage
return GetHistoryMsgsCommand
