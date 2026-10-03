local ChatDBManager = BaseClass("ChatDBManager")

function ChatDBManager:__init()
  self.isInit = false
  self.sql_count = 0
end

local tblUserInfoData = {
  {
    "uid",
    "varchar",
    1,
    "",
    1
  },
  {
    "userName",
    "varchar",
    0,
    "",
    0
  },
  {
    "serverId",
    "integer",
    0,
    "",
    0
  },
  {
    "crossFightSrcServerId",
    "integer",
    0,
    "",
    0
  },
  {
    "headPic",
    "varchar",
    0,
    "",
    0
  },
  {
    "headPicVer",
    "integer",
    0,
    "",
    0
  },
  {
    "gmFlag",
    "integer",
    0,
    "",
    0
  },
  {
    "careerId",
    "varchar",
    0,
    "",
    0
  },
  {
    "lastUpdateTime",
    "bigint",
    0,
    "",
    0
  },
  {
    "monthCard",
    "integer",
    0,
    "",
    0
  },
  {
    "vipLevel",
    "integer",
    0,
    "",
    0
  },
  {
    "svipLevel",
    "integer",
    0,
    "",
    0
  },
  {
    "vipframe",
    "integer",
    0,
    "",
    0
  },
  {
    "vipEndTime",
    "bigint",
    0,
    "",
    0
  },
  {
    "allianceId",
    "varchar",
    0,
    "",
    0
  },
  {
    "allianceSimpleName",
    "varchar",
    0,
    "",
    0
  },
  {
    "chatSkinId",
    "varchar",
    0,
    "",
    0
  },
  {
    "chatFrameId",
    "varchar",
    0,
    "",
    0
  },
  {
    "chatBantime",
    "bigint",
    0,
    "",
    0
  },
  {
    "careerType",
    "integer",
    0,
    "",
    0
  },
  {
    "careerLv",
    "integer",
    0,
    "",
    0
  },
  {
    "mainBuildingLevel",
    "integer",
    0,
    "",
    0
  },
  {
    "nation",
    "varchar",
    0,
    "",
    0
  },
  {
    "monthCardEndTime",
    "integer",
    0,
    "",
    0
  },
  {
    "gender",
    "integer",
    0,
    "",
    0
  },
  {
    "headSkinId",
    "integer",
    0,
    "",
    0
  },
  {
    "headSkinET",
    "bigint",
    0,
    "",
    0
  },
  {
    "titleSkinId",
    "integer",
    0,
    "",
    0
  },
  {
    "titleSkinET",
    "bigint",
    0,
    "",
    0
  }
}
local tblChatData = {
  {
    "Key",
    "varchar",
    1,
    "",
    1
  },
  {
    "seqId",
    "integer",
    0,
    "",
    0
  },
  {
    "group",
    "varchar",
    0,
    "",
    0
  },
  {
    "type",
    "integer",
    0,
    "",
    0
  },
  {
    "roomId",
    "varchar",
    0,
    "",
    0
  },
  {
    "senderUid",
    "varchar",
    0,
    "",
    0
  },
  {
    "senderName",
    "varchar",
    0,
    "",
    0
  },
  {
    "sendState",
    "integer",
    0,
    "",
    0
  },
  {
    "serverTime",
    "real",
    0,
    "",
    0
  },
  {
    "sendLocalTime",
    "bigint",
    0,
    "",
    0
  },
  {
    "post",
    "integer",
    0,
    "",
    0
  },
  {
    "msg",
    "varchar",
    0,
    "",
    0
  },
  {
    "msgMask",
    "varchar",
    0,
    "",
    0
  },
  {
    "isTranslating",
    "integer",
    0,
    "",
    0
  },
  {
    "translateMsg",
    "varchar",
    0,
    "",
    0
  },
  {
    "originalLang",
    "varchar",
    0,
    "",
    0
  },
  {
    "targetLang",
    "varchar",
    0,
    "",
    0
  },
  {
    "attachmentId",
    "varchar",
    0,
    "",
    0
  },
  {
    "media",
    "varchar",
    0,
    "",
    0
  }
}
local tblRoomData = {
  {
    "Key",
    "varchar",
    1,
    "",
    1
  },
  {
    "roomId",
    "varchar",
    1,
    "",
    0
  },
  {
    "gameUid",
    "varchar",
    1,
    "",
    0
  },
  {
    "isPin",
    "integer",
    0,
    "",
    0
  },
  {
    "firstMsgTime",
    "real",
    0,
    "",
    0
  },
  {
    "lastMsgTime",
    "real",
    0,
    "",
    0
  },
  {
    "group",
    "integer",
    0,
    "",
    0
  },
  {
    "owner",
    "varchar",
    0,
    "",
    0
  },
  {
    "appId",
    "varchar",
    0,
    "",
    0
  },
  {
    "name",
    "varchar",
    0,
    "",
    0
  },
  {
    "memberList",
    "varchar",
    0,
    "",
    0
  }
}
local Insert_ChatData_SQL = [[
INSERT OR REPLACE INTO ChatData (
"Key",
"seqId",
"group",
"type",
"roomId",
"senderUid",
"senderName",
"sendState",
"serverTime",
"sendLocalTime",
"post",
"msg",
"msgMask",
"isTranslating",
"translateMsg",
"originalLang",
"targetLang",
"attachmentId",
"media"
) VALUES ]]
local Update_ChatData_SQL = [[
UPDATE ChatData 
SET Key='%s', seqId='%d', sendState='%d' 
WHERE Key='%s']]

local function GetSingleChatInfoValue(cm)
  local Key = string.format("%s_%d", cm.roomId, cm.seqId)
  local v = "(" .. "'" .. Key .. "', " .. "'" .. cm.seqId .. "', " .. "'" .. cm.group .. "', " .. "'" .. cm.type .. "', " .. "'" .. LuaDBInterface.escape(cm.roomId or "") .. "', " .. "'" .. (cm.senderUid or 0) .. "', " .. "'" .. LuaDBInterface.escape(cm.senderName or "") .. "', " .. "'" .. (cm.sendState or 0) .. "', " .. "'" .. (cm.serverTime or 0) .. "', " .. "'" .. (cm.sendLocalTime or 0) .. "', " .. "'" .. (cm.post or 0) .. "', " .. "'" .. LuaDBInterface.escape(cm.msg or "") .. "', " .. "'" .. LuaDBInterface.escape(cm.msgMask or "") .. "', " .. "'" .. (cm.isTranslating or 0) .. "', " .. "'" .. LuaDBInterface.escape(cm.translateMsg or "") .. "', " .. "'" .. (cm.originalLang or "") .. "', " .. "'" .. (cm.targetLang or "") .. "', " .. "'" .. LuaDBInterface.escape(cm.attachmentId or "") .. "', " .. "'" .. (cm.media or "") .. "' " .. ")"
  return v
end

local function MakeInsertChatInfos(chatMessages, single)
  if single then
    local sql = Insert_ChatData_SQL .. GetSingleChatInfoValue(chatMessages)
    return sql
  end
  local sqls = {}
  for i = 1, #chatMessages do
    table.insert(sqls, Insert_ChatData_SQL .. GetSingleChatInfoValue(chatMessages[i]))
  end
  return sqls
end

local Insert_UserInfo_SQL = [[
INSERT OR REPLACE INTO UserInfoData (
"uid",
"userName",
"serverId",
"crossFightSrcServerId",
"headPic",
"headPicVer",
"gmFlag",
"careerId",
"lastUpdateTime",
"monthCard",
"vipLevel",
"svipLevel",
"vipframe",
"vipEndTime",
"allianceId",
"allianceSimpleName",
"chatSkinId",
"chatFrameId",
"chatBantime",
"careerType",
"careerLv",
"mainBuildingLevel",
"nation",
"monthCardEndTime",
"headSkinId",
"headSkinET",
"titleSkinId",
"titleSkinET"
) VALUES ]]

local function GetSingleUserInfoValue(userInfo)
  local v = "(" .. "'" .. userInfo.uid .. "', " .. "'" .. LuaDBInterface.escape(userInfo.userName) .. "', " .. "'" .. userInfo.serverId .. "', " .. "'" .. (userInfo.crossFightSrcServerId or 0) .. "', " .. "'" .. (userInfo.headPic or "") .. "', " .. "'" .. (userInfo.headPicVer or 0) .. "', " .. "'" .. (userInfo.gmFlag or 0) .. "', " .. "'" .. (userInfo.careerId or "") .. "', " .. "'" .. (userInfo.lastUpdateTime or 0) .. "', " .. "'" .. (userInfo.monthCard or 0) .. "', " .. "'" .. (userInfo.vipLevel or 0) .. "', " .. "'" .. (userInfo.svipLevel or 0) .. "', " .. "'" .. (userInfo.vipframe or 0) .. "', " .. "'" .. (userInfo.vipEndTime or 0) .. "', " .. "'" .. (userInfo.allianceId or "") .. "', " .. "'" .. (userInfo.allianceSimpleName or "") .. "', " .. "'" .. (userInfo.chatSkinId or "") .. "', " .. "'" .. (userInfo.chatFrameId or "") .. "', " .. "'" .. (userInfo.chatBantime or 0) .. "', " .. "'" .. (userInfo.careerType or 0) .. "', " .. "'" .. (userInfo.careerLv or 0) .. "', " .. "'" .. (userInfo.mainBuildingLevel or 0) .. "', " .. "'" .. (userInfo.nation or "UN") .. "', " .. "'" .. (userInfo.monthCardEndTime or 0) .. "', " .. "'" .. (userInfo.headSkinId or 0) .. "', " .. "'" .. (userInfo.headSkinET or 0) .. "', " .. "'" .. (userInfo.titleSkinId or 0) .. "', " .. "'" .. (userInfo.titleSkinET or 0) .. "' " .. ")"
  return v
end

local function MakeInsertUserInfos(userInfos, single)
  if single then
    local sql = Insert_UserInfo_SQL .. GetSingleUserInfoValue(userInfos)
    return sql
  end
  local sqls = {}
  for i = 1, #userInfos do
    table.insert(sqls, Insert_UserInfo_SQL .. GetSingleUserInfoValue(userInfos[i]))
  end
  return sqls
end

local Insert_RoomData_SQL = [[
INSERT OR REPLACE INTO RoomData (
"Key",
"roomId",
"gameUid",
"isPin",
"firstMsgTime",
"lastMsgTime",
"group",
"owner",
"appId",
"name",
"memberList"
) VALUES ]]
local Update_RoomData_SQL = [[
UPDATE RoomData
SET isPin='%d', name='%s'
WHERE Key='%s']]

local function GetSingleRoomDataValue(uid, rd)
  local Key = string.format("%s-%s", uid, rd.roomId)
  local memberListStr = ""
  if rd.memberList and #rd.memberList > 0 then
    memberListStr = table.concat(rd.memberList, ";")
  end
  local v = "(" .. "'" .. Key .. "', " .. "'" .. LuaDBInterface.escape(rd.roomId) .. "', " .. "'" .. uid .. "', " .. "'" .. (rd.isPin or 0) .. "', " .. "'" .. (rd.firstMsgTime or 0) .. "', " .. "'" .. (rd.lastMsgTime or 0) .. "', " .. "'" .. (rd.group or 0) .. "', " .. "'" .. (rd.owner or 0) .. "', " .. "'" .. (rd.appId or "") .. "', " .. "'" .. (rd.name or 0) .. "', " .. "'" .. memberListStr .. "' " .. ")"
  return v
end

local function MakeInsertRoomDatas(uid, roomDatas, single)
  if single then
    local sql = Insert_RoomData_SQL .. GetSingleRoomDataValue(uid, roomDatas)
    return sql
  end
  local sqls = {}
  for k, v in pairs(roomDatas) do
    table.insert(sqls, Insert_RoomData_SQL .. GetSingleRoomDataValue(uid, v))
  end
  return sqls
end

local function CreateChatTable(sqlTable)
  LuaDBInterface.CreateOneTable(sqlTable, "ChatData", tblChatData)
  table.insert(sqlTable, "CREATE UNIQUE INDEX index_chatdata_key on ChatData (Key)")
  table.insert(sqlTable, "CREATE INDEX index_chatdata_roomId on ChatData (roomId)")
end

local function CreateUserInfoTable(sqlTable)
  LuaDBInterface.CreateOneTable(sqlTable, "UserInfoData", tblUserInfoData)
  table.insert(sqlTable, "CREATE UNIQUE INDEX index_userinfo_uid on UserInfoData (uid)")
end

local function CreateRoomDataTable(sqlTable)
  LuaDBInterface.CreateOneTable(sqlTable, "RoomData", tblRoomData)
end

local function ParseResultToUserInfo(result)
  local tbl = {}
  if result == nil or result.error ~= 0 or result.cols == nil then
    ChatPrint("userinfo error!!")
    return tbl
  end
  if result.values == nil or 0 >= #result.values then
    ChatPrint("chat result.values error")
    return tbl
  end
  local col_count = result.col_count
  local cols = result.cols
  if col_count <= 0 then
    ChatPrint("col_count error")
    return tbl
  end
  local UserMgr = ChatManager2:GetInstance().User
  for rowidx = 1, #result.values do
    local row = UserMgr:CreateUserInfo()
    for i = 1, col_count do
      local k = cols[i].name
      local v = result.values[rowidx][i]
      row[k] = v
    end
    row:SetInfoOK()
    table.insert(tbl, row)
  end
  return tbl
end

local function ParseResultToChatMessage(result)
  local tbl = {}
  if result == nil or result.error ~= 0 or result.cols == nil then
    ChatPrint("chat error!")
    return tbl
  end
  if result.values == nil or 0 >= #result.values then
    return tbl
  end
  local col_count = result.col_count
  local cols = result.cols
  local RoomMgr = ChatManager2:GetInstance().Room
  for rowidx = 1, #result.values do
    local row = RoomMgr:CreateChatMessage()
    for i = 1, col_count do
      local k = cols[i].name
      local v = result.values[rowidx][i]
      row[k] = v
    end
    table.insert(tbl, row)
  end
  return tbl
end

local function processCacheUserInfo(result)
  local userInfos = ParseResultToUserInfo(result)
  if userInfos == nil then
    return
  end
  local UserManager = ChatManager2:GetInstance().User
  for i = 1, #userInfos do
    UserManager:addChatUserInfo(userInfos[i])
  end
end

local function processCacheRoomData(result)
  local roomInfos = LuaDBInterface.ParseResultToMultiLuaTables(result)
  ChatManager2:GetInstance().Room:SetCacheRoomInfos(roomInfos)
end

local function onCreateOrAlterTable(self, result)
  local sqls = {}
  if result == nil then
    CreateChatTable(sqls)
    CreateUserInfoTable(sqls)
    CreateRoomDataTable(sqls)
  else
    if 0 < #result then
      if result[1].col_count == 0 or #result[1].values == 0 then
        CreateUserInfoTable(sqls)
      else
        LuaDBInterface.MigrateOneTable(sqls, "UserInfoData", result[1], tblUserInfoData)
      end
    end
    if 1 < #result then
      if result[2].col_count == 0 or #result[2].values == 0 then
        CreateChatTable(sqls)
      else
        LuaDBInterface.MigrateOneTable(sqls, "ChatData", result[2], tblChatData)
      end
    end
    if 2 < #result then
      if result[3].col_count == 0 or #result[3].values == 0 then
        CreateRoomDataTable(sqls)
      else
        LuaDBInterface.MigrateOneTable(sqls, "RoomData", result[3], tblRoomData)
      end
    end
  end
  if 4 <= #result then
    processCacheUserInfo(result[4])
  end
  if 5 <= #result then
    processCacheRoomData(result[5])
  end
  if #sqls == 0 then
    self:__Callback("ok", "table")
    return
  end
  LuaDBInterface.ExecuteMultiSQL(sqls, function(r2)
    if r2 == nil then
      ChatPrint("create error??")
      self:__Callback("error", "internal")
      return
    end
    local allisok = true
    table.walk(r2, function(k, v)
      if v.error ~= 0 then
        ChatPrint("error on sql: " .. sqls[k])
        allisok = false
      end
    end)
    self.isInit = true
    self:__Callback(allisok and "ok" or "error", "create")
  end)
end

function ChatDBManager:__Callback(status, reason)
  if self.callback then
    self.callback(status, reason)
  else
    ChatPrint("db : " .. status .. "," .. reason)
  end
end

function ChatDBManager:__ChatDBInit()
  local uid = ChatInterface.getPlayerUid()
  local roomSQL = string.format("SELECT * FROM RoomData WHERE gameUid = '%s'", uid)
  local tbl = {
    "pragma table_info ('UserInfoData')",
    "pragma table_info ('ChatData')",
    "pragma table_info ('RoomData')",
    "SELECT * FROM UserInfoData LIMIT 300",
    roomSQL
  }
  LuaDBInterface.ExecuteMultiSQL(tbl, function(r)
    onCreateOrAlterTable(self, r)
  end)
end

function ChatDBManager:Init(callback)
  ChatPrint("ChatDBManager:Init")
  self.callback = callback
  self:__ChatDBInit()
end

function ChatDBManager:Uninit()
  ChatPrint("ChatDBManager:Uninit")
  self.callback = nil
end

function ChatDBManager:InsertUserInfo(userInfo, callback)
  if userInfo.uid == nil or userInfo.userName == nil or userInfo.serverId == nil then
    ChatPrint("userInfo error!!!")
    return
  end
  local sql = MakeInsertUserInfos(userInfo, true)
  LuaDBInterface.ExecuteSQL(sql, function(result)
    if callback ~= nil then
      local ret = result.error == 0 and result.change_rows == 1 and true or false
      callback(ret)
    end
  end)
end

function ChatDBManager:InsertUserInfos(userInfos, callback)
  if type(userInfos) ~= "table" or #userInfos == 0 then
    return
  end
  local sqls = MakeInsertUserInfos(userInfos, false)
  LuaDBInterface.ExecuteMultiSQL(sqls, function(result)
    if callback ~= nil then
      local allisok = true
      for _, v in ipairs(result) do
        if v.error ~= 0 then
          allisok = false
        end
      end
      callback(allisok)
    end
  end)
end

function ChatDBManager:InsertRoomDatas(roomDatas, callback)
  if type(roomDatas) ~= "table" or table.count(roomDatas) == 0 then
    return
  end
  local sqls = MakeInsertRoomDatas(roomDatas, false)
  LuaDBInterface.ExecuteMultiSQL(sqls, function(result)
    if callback ~= nil then
      local allisok = true
      for _, v in ipairs(result) do
        if v.error ~= 0 then
          allisok = false
        end
      end
      callback(allisok)
    end
  end)
end

function ChatDBManager:QueryUserInfo(uid, callback)
  local sql = string.format("SELECT * FROM UserInfoData WHERE uid = '%s'", uid)
  LuaDBInterface.ExecuteSQL(sql, function(result)
    if callback ~= nil then
      local userInfo = ParseResultToUserInfo(result)
      if userInfo then
        callback(userInfo[1])
      end
    end
  end)
end

function ChatDBManager:QueryUserInfos(uidTable, callback)
  local c = uidTable and #uidTable or 0
  if c == 0 and callback ~= nil then
    callback(nil)
  end
  local sql_full = "SELECT * FROM UserInfoData WHERE uid IN ("
  for i = 1, c do
    sql_full = sql_full .. "'" .. uidTable[i] .. "'" .. (i ~= c and "," or ")")
  end
  LuaDBInterface.ExecuteSQL(sql_full, function(result)
    if callback ~= nil then
      local userInfos = ParseResultToUserInfo(result)
      if userInfos then
        callback(userInfos)
      end
    end
  end)
end

function ChatDBManager:InsertChatInfo(chatMessage, callback)
  local sql = MakeInsertChatInfos(chatMessage, true)
  LuaDBInterface.ExecuteSQL(sql, function(result)
    if callback ~= nil then
      local ret = result.error == 0 and result.change_rows == 1 and true or false
      callback(ret)
    end
  end)
end

function ChatDBManager:InsertChatInfos(chatMessages, callback)
  if chatMessages == nil or #chatMessages == 0 then
    return
  end
  local sqls = MakeInsertChatInfos(chatMessages, false)
  LuaDBInterface.ExecuteMultiSQL(sqls, function(result)
    if callback ~= nil then
      local ret = true
      callback(ret)
    end
  end)
end

function ChatDBManager:UpdateChatData(oldSeqId, chatMessage, callback)
  local OldKey = string.format("%s_%d", chatMessage.roomId, oldSeqId)
  local NewKey = string.format("%s_%d", chatMessage.roomId, chatMessage.seqId)
  local sql = string.format(Update_ChatData_SQL, NewKey, tonumber(chatMessage.seqId), tonumber(chatMessage.sendState), OldKey)
  LuaDBInterface.ExecuteSQL(sql, function(result)
    if callback ~= nil then
      local ret = result.error == 0 and result.change_rows == 1 and true or false
      callback(ret)
    end
  end)
end

function ChatDBManager:RemoveChatRoom(roomId)
  local uid = ChatInterface.getPlayerUid()
  local Key = string.format("%s-%s", uid, roomId)
  local t = {}
  local sql1 = string.format("DELETE FROM RoomData WHERE `Key` = '%s'", Key)
  local sql2 = string.format("DELETE FROM ChatData WHERE `roomId` = '%s'", roomId)
  table.insert(t, sql1)
  table.insert(t, sql2)
  LuaDBInterface.ExecuteMultiSQL(t, function(result)
    local t = 0
  end)
end

function ChatDBManager:QueryChatByTime(roomId, fromTime, toTime, callback)
  local sql = string.format("SELECT * FROM ChatData WHERE `roomId` = '%s' AND `sendLocalTime` >= '%d' AND `sendLocalTime` <= '%d'", roomId, fromTime, toTime)
  LuaDBInterface.ExecuteSQL(sql, function(result)
    if callback ~= nil then
      local charInfos = ParseResultToChatMessage(result)
      callback(chatInfos)
    end
  end)
end

function ChatDBManager:QueryLatestChat(roomId, callback)
  local sql = string.format("SELECT * FROM ChatData WHERE `roomId` == '%s' ORDER BY serverTime DESC LIMIT 30", roomId)
  LuaDBInterface.ExecuteSQL(sql, function(result)
    if callback ~= nil then
      local chatInfos = ParseResultToChatMessage(result)
      callback(chatInfos)
    end
  end)
end

function ChatDBManager:QueryChatBySeqId(roomId, from, to, callback)
  local sql = string.format("SELECT * FROM ChatData WHERE `roomId` = '%s' AND `seqId` >= '%d' AND `seqId` <= '%d'", roomId, from, to)
  LuaDBInterface.ExecuteSQL(sql, function(result)
    if callback ~= nil then
      local charInfos = ParseResultToChatMessage(result)
      callback(chatInfos)
    end
  end)
end

function ChatDBManager:SaveChatItem(chatData, callback)
  if chatData == nil or chatData.post == PostType.Text_ChatRoomSystemMsg then
    return
  end
  local roomData = ChatManager2:GetInstance().Room:GetRoomData(chatData.roomId)
  if roomData == nil then
    return
  end
  if roomData:isPrivateChat() then
    return
  end
  self:InsertChatInfo(chatData, callback)
end

function ChatDBManager:InsertRoomDatas(roomDatas, callback)
  if table.IsNullOrEmpty(roomDatas) then
    ChatPrint("no roomdatas!")
    return
  end
  local uid = ChatInterface.getPlayerUid()
  local sqls = MakeInsertRoomDatas(uid, roomDatas, false)
  local sql = string.format("DELETE FROM RoomData WHERE `gameUid` == '%s'", uid)
  table.insert(sqls, 1, sql)
  LuaDBInterface.ExecuteMultiSQL(sqls, function(result)
    if callback ~= nil then
      local ret = true
      callback(ret)
    end
  end)
end

function ChatDBManager:QueryRoomDatas(callback)
  local uid = ChatInterface.getPlayerUid()
  local sql = string.format("SELECT * FROM RoomData WHERE `gameUid` == '%s'", uid)
  LuaDBInterface.ExecuteSQL(sql, function(result)
    if callback ~= nil then
      local roomInfos = ParseResultToMultiLuaTables(result)
      callback(roomInfos)
    end
  end)
end

function ChatDBManager:UpdateRoomData(rd, callback)
  local uid = ChatInterface.getPlayerUid()
  local Key = string.format("%s-%s", uid, rd.roomId)
  local sql = string.format(Update_RoomData_SQL, 0, rd.name, Key)
  LuaDBInterface.ExecuteSQL(sql, function(result)
    if callback ~= nil and (result.error ~= 0 or result.change_rows ~= 1 or not true) then
      local ret = false
    end
  end)
end

return ChatDBManager
