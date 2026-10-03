local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local JoinRoomMultiCommand = BaseClass("JoinRoomMultiCommand", WebSocketBaseMessage)

local function create(self)
  local roomTbl = {}
  local rooms = ChatManager2:GetInstance().Room:GetRoomDatas()
  for _, roomData in pairs(rooms) do
    if roomData.group ~= ChatGroupType.GROUP_CUSTOM then
      local data = {
        id = roomData.roomId,
        group = roomData.group
      }
      table.insert(roomTbl, data)
    end
  end
  return roomTbl
end

local function createAlliance(self)
  local roomTbl = {}
  local data = {
    id = ChatManager2:GetInstance().Room:GetAllianceRoomId(),
    group = "alliance"
  }
  table.insert(roomTbl, data)
  return roomTbl
end

local function createCrossServer(self)
  local roomTbl = {}
  local data = {
    id = ChatManager2:GetInstance().Room:GetCrossServerRoomId(),
    group = "custom"
  }
  table.insert(roomTbl, data)
  return roomTbl
end

local function createBattleFieldServer(bSelf)
  local room = ChatManager2:GetInstance().Room
  local id = bSelf and room:GetDragonServerSelfRoomId() or room:GetDragonServerAllRoomId()
  local group = bSelf and ChatGroupType.GROUP_DRAGON_SELF_SERVER or ChatGroupType.GROUP_DRAGON_ALL_SERVER
  local roomTbl = {}
  local data = {id = id, group = group}
  table.insert(roomTbl, data)
  return roomTbl
end

local function createNoticeAllServer(roomId)
  local roomTbl = {}
  local data = {id = roomId, group = "notice"}
  table.insert(roomTbl, data)
  return roomTbl
end

local function createManagerAllServer()
  local roomTbl = {}
  local data = {
    id = ChatManager2:GetInstance().Room:GetAllianceMangaerRoomId(),
    group = "manager"
  }
  table.insert(roomTbl, data)
  return roomTbl
end

local function createCommonServer(roomId, groupId)
  local roomTbl = {}
  local data = {id = roomId, group = groupId}
  table.insert(roomTbl, data)
  return roomTbl
end

local function OnCreate(self, groupId, roomId)
  if groupId ~= nil and groupId == ChatGroupType.GROUP_ALLIANCE then
    self.tableData.rooms = createAlliance()
  elseif groupId ~= nil and groupId == ChatGroupType.GROUP_DRAGON_SELF_SERVER then
    self.tableData.rooms = createBattleFieldServer(true)
  elseif groupId ~= nil and groupId == ChatGroupType.GROUP_DRAGON_ALL_SERVER then
    self.tableData.rooms = createBattleFieldServer(false)
  elseif groupId ~= nil and groupId == ChatGroupType.GROUP_ALLIANCE_NOTICE and roomId then
    self.tableData.rooms = createNoticeAllServer(roomId)
  elseif groupId ~= nil and groupId == ChatGroupType.GROUP_ALLIANCE_MANAGER then
    self.tableData.rooms = createManagerAllServer()
  elseif groupId ~= nil and (groupId == ChatGroupType.GROUP_FRIENDS_CIRCLE_ROOM or groupId == ChatGroupType.GROUP_FRIENDS_CIRCLE_COMMENT_ROOM) then
    self.tableData.rooms = createCommonServer(roomId, groupId)
  elseif groupId ~= nil and groupId == ChatGroupType.GROUP_EASTER_EGG_ROOM then
    self.tableData.rooms = createCommonServer(roomId, groupId)
  elseif groupId ~= nil and roomId ~= nil then
    local roomTbl = {}
    local data = {id = roomId, group = groupId}
    table.insert(roomTbl, data)
    self.tableData.rooms = roomTbl
  else
    self.tableData.rooms = create()
  end
end

local function HandleMessage(self, msg)
  ChatManager2:GetInstance().Room:OnInitRoomCmdBack()
end

JoinRoomMultiCommand.OnCreate = OnCreate
JoinRoomMultiCommand.HandleMessage = HandleMessage
return JoinRoomMultiCommand
