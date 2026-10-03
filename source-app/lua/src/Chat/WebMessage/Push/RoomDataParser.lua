local RoomDataParser = {}
local rapidjson = require("rapidjson")

local function __ParseMemberUids(msg)
  local memberUids = {}
  local UserMgr = ChatManager2:GetInstance().User
  local memberArr = rapidjson.decode(msg)
  if memberArr == nil or type(memberArr) ~= "table" then
    if msg == ChatInterface.getPlayer().Uid then
      table.insert(memberUids, msg)
    else
      ChatPrint("??")
      table.insert(memberUids, msg)
    end
  else
    for uid, value in pairs(memberArr) do
      if value then
        table.insert(memberUids, uid)
      end
    end
  end
  return memberUids
end

function RoomDataParser.DecodeRoomInfo(serverData)
  if serverData.data == nil or serverData.data.roomInfo == nil then
    return nil
  end
  local roomInfo = serverData.data.roomInfo
  if type(roomInfo) == "string" then
    if string.IsNullOrEmpty(roomInfo) then
      return nil
    end
    roomInfo = rapidjson.decode(roomInfo)
  end
  return roomInfo
end

function RoomDataParser.DecodeMsgs(serverData)
  if serverData.data == nil or serverData.data.msgs == nil then
    return nil
  end
  local msgs = serverData.data.msgs
  if type(msgs) == "string" then
    if string.IsNullOrEmpty(msgs) then
      return nil
    end
    msgs = rapidjson.decode(msgs)
  end
  return msgs
end

function RoomDataParser.DecodeMsgList(serverData)
  if serverData.data == nil or serverData.data.msgs == nil then
    return nil
  end
  local msgList = {}
  local msg
  for i = 1, #serverData.data.msgs do
    msg = serverData.data.msgs[i]
    if type(msg) == "string" and not string.IsNullOrEmpty(msg) then
      msg = rapidjson.decode(msg)
      table.insert(msgList, msg)
    end
  end
  return msgList
end

local function IsInMembers(members)
  for _, memberUid in pairs(members) do
    if memberUid == LuaEntry.Player.uid then
      return true
    end
  end
end

function RoomDataParser.ProcessMsgs(msgs, action)
  if msgs == nil then
    return nil, nil
  end
  local isAddOK
  local roomMgr = ChatManager2:GetInstance().Room
  local chatData = roomMgr:CreateChatMessage()
  chatData:onParseServerData(msgs)
  local roomData = roomMgr:GetRoomData(chatData.roomId)
  if roomData == nil then
    return nil, nil
  end
  local members = __ParseMemberUids(msgs.msg)
  if 0 < #members then
    if action == "add" then
      roomData:addMembers(members)
    elseif action == "remove" then
      roomData:removeMembers(members)
    elseif action == "quit" then
      roomData:removeMember(chatData.senderUid)
    end
    isAddOK = roomMgr:AddChat(chatData, true)
  end
  return chatData, members, isAddOK
end

return RoomDataParser
