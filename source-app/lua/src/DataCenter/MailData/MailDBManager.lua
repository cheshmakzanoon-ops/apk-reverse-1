local MailDBManager = BaseClass("MailDBManager")
local INIT_NUM = 20

function MailDBManager:__init()
  self.isInit = false
  self.sql_count = 0
end

local tblMailData = {
  {
    "uid",
    "varchar",
    1,
    "",
    1
  },
  {
    "toUser",
    "varchar",
    0,
    "",
    0
  },
  {
    "fromUser",
    "varchar",
    0,
    "",
    0
  },
  {
    "fromName",
    "varchar",
    0,
    "",
    0
  },
  {
    "title",
    "varchar",
    0,
    "",
    0
  },
  {
    "subTitle",
    "varchar",
    0,
    "",
    0
  },
  {
    "contents",
    "blob",
    0,
    "",
    0
  },
  {
    "rewardId",
    "blob",
    0,
    "",
    0
  },
  {
    "itemIdFlag",
    "integer",
    0,
    "",
    0
  },
  {
    "status",
    "integer",
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
    "rewardStatus",
    "integer",
    0,
    "",
    0
  },
  {
    "saveFlag",
    "integer",
    0,
    "",
    0
  },
  {
    "createTime",
    "bigint",
    0,
    "",
    0
  },
  {
    "reply",
    "integer",
    0,
    "",
    0
  },
  {
    "replyText",
    "varchar",
    0,
    "",
    0
  },
  {
    "translationId",
    "varchar",
    0,
    "",
    0
  },
  {
    "mbLevel",
    "integer",
    0,
    "",
    0
  },
  {
    "rewardTime",
    "bigint",
    0,
    "",
    0
  },
  {
    "extParam1",
    "string",
    0,
    "",
    0
  },
  {
    "extParam2",
    "blob",
    0,
    "",
    0
  },
  {
    "translateMsg",
    "string",
    0,
    "",
    0
  },
  {
    "translatedLang",
    "string",
    0,
    "",
    0
  },
  {
    "custom",
    "string",
    0,
    "",
    0
  },
  {
    "expireTime",
    "bigint",
    0,
    "",
    0
  },
  {
    "mailId",
    "bigint",
    0,
    "",
    0
  }
}
local Only_Insert_MailData_SQL = [[
INSERT OR IGNORE INTO MailData (
"uid",
"toUser",
"fromUser",
"fromName",
"title",
"subTitle",
"contents",
"rewardId",
"itemIdFlag",
"status",
"type",
"rewardStatus",
"saveFlag",
"createTime",
"reply",
"replyText",
"translationId",
"mbLevel",
"rewardTime",
"extParam1",
"extParam2",
"translateMsg",
"translatedLang",
"custom",
"expireTime",
"mailId"
) VALUES ]]
local Insert_MailData_SQL = [[
INSERT OR REPLACE INTO MailData (
"uid",
"toUser",
"fromUser",
"fromName",
"title",
"subTitle",
"contents",
"rewardId",
"itemIdFlag",
"status",
"type",
"rewardStatus",
"saveFlag",
"createTime",
"reply",
"replyText",
"translationId",
"mbLevel",
"rewardTime",
"extParam1",
"extParam2",
"translateMsg",
"translatedLang",
"custom",
"expireTime",
"mailId"
) VALUES ]]
local Update_MailData_SQL = [[
UPDATE MailData
SET type='%d'
WHERE uid='%s']]

local function GetSingleMailDataValue(mail)
  local v = "(" .. "'" .. mail.uid .. "', " .. "'" .. mail.toUser .. "', " .. "'" .. (mail.fromUser or "") .. "'" .. ", " .. "'" .. LuaDBInterface.escape(mail.fromName or "") .. "'" .. ", " .. "'" .. LuaDBInterface.escape(mail.title or "") .. "'" .. ", " .. "'" .. (mail.subTitle or "") .. "'" .. ", " .. "'" .. LuaDBInterface.escape(mail.contents or "") .. "'" .. ", " .. "'" .. (mail.rewardId or "") .. "'" .. ", " .. "'" .. (mail.itemIdFlag or 0) .. "'" .. ", " .. "'" .. (mail.status or 0) .. "'" .. ", " .. "'" .. (mail.type or 0) .. "'" .. ", " .. "'" .. (mail.rewardStatus or 0) .. "'" .. ", " .. "'" .. (mail.saveFlag or 0) .. "'" .. ", " .. "'" .. (mail.createTime or 0) .. "'" .. ", " .. "'" .. (mail.reply or 0) .. "'" .. ", " .. "'" .. (mail.replyText or "") .. "'" .. ", " .. "'" .. (mail.translationId or "") .. "'" .. ", " .. "'" .. (mail.mbLevel or 0) .. "'" .. ", " .. "'" .. (mail.rewardTime or 0) .. "'" .. ", " .. "'" .. (mail.extParam1 or "") .. "'" .. ", " .. "'" .. (mail.extParam2 or "") .. "'" .. ", " .. "'" .. (mail.translateMsg or "") .. "'" .. ", " .. "'" .. (mail.translatedLang or "") .. "'" .. ", " .. "'" .. (mail.custom or "") .. "'" .. ", " .. "'" .. (mail.expireTime or 0) .. "'" .. ", " .. "'" .. (mail.mailId or 0) .. "'" .. ")"
  return v
end

local function escape_sql(v)
  v = tostring(v)
  v = v:gsub("'", "''")
  v = v:gsub("\n", "\\n")
  v = v:gsub("\r", "\\r")
  v = v:gsub("\000", "\\0")
  v = v:gsub("%%", "%%%%")
  return v
end

local function MakeInsertMailDatas(mailDatas, single)
  if single then
    local sql
    if BattleReportMailType[mailDatas.type] then
      sql = Only_Insert_MailData_SQL .. GetSingleMailDataValue(mailDatas)
    else
      sql = Insert_MailData_SQL .. GetSingleMailDataValue(mailDatas)
    end
    return sql
  end
  local sqls = {}
  for k, v in pairs(mailDatas) do
    if BattleReportMailType[v.type] then
      table.insert(sqls, Only_Insert_MailData_SQL .. GetSingleMailDataValue(v))
    else
      table.insert(sqls, Insert_MailData_SQL .. GetSingleMailDataValue(v))
    end
  end
  return sqls
end

local function CreateMailTable(sqlTable)
  LuaDBInterface.CreateOneTable(sqlTable, "MailData", tblMailData)
  table.insert(sqlTable, "CREATE INDEX index_maildata_uid on MailData (toUser)")
  table.insert(sqlTable, "CREATE INDEX index_maildata_touser_saveflag_status_rewardstatus ON MailData (`toUser`, `saveFlag`, `status`, `rewardStatus`)")
end

local function ParseResultToMailDatas(result)
  local tbl = {}
  if result == nil or result.error ~= 0 or result.cols == nil then
    MailPrint("userinfo error!!")
    return tbl
  end
  if result.values == nil or 0 >= #result.values then
    MailPrint("mail result.values error")
    return tbl
  end
  local col_count = result.col_count
  local cols = result.cols
  if col_count <= 0 then
    MailPrint("col_count error")
    return tbl
  end
  local MailMgr = DataCenter.MailDataManager
  for rowidx = 1, #result.values do
    local row = MailMgr:CreateMailData()
    for i = 1, col_count do
      local k = cols[i].name
      local v = result.values[rowidx][i]
      row[k] = v
    end
    row:InitBattleReportParam()
    table.insert(tbl, row)
  end
  return tbl
end

local function processCacheMailDatas(result1, result2, result3)
  local redFix
  if result1.error ~= 0 and table.IsNullOrEmpty(result1.values) then
    MailPrint("no datas 1")
  else
    local mailDatas = ParseResultToMailDatas(result1)
    if not table.IsNullOrEmpty(mailDatas) then
      redFix = DataCenter.MailDataManager:OnGetDBMails(mailDatas)
    else
      return
    end
  end
  if result2.error ~= 0 and table.IsNullOrEmpty(result2.values) then
    MailPrint("no datas 2")
  else
    local t2 = LuaDBInterface.ParseResultToMultiLuaTables(result2)
    if not table.IsNullOrEmpty(t2) then
      DataCenter.MailDataManager:OnDBGroupUnreadCount(t2, redFix)
    else
      MailPrint("get count error")
    end
  end
  if result3.error ~= 0 and table.IsNullOrEmpty(result3.values) then
    MailPrint("no datas 3")
  else
    local t3 = LuaDBInterface.ParseResultToMultiLuaTables(result3)
    if not table.IsNullOrEmpty(t3) then
      DataCenter.MailDataManager:OnDBRewardState(t3)
    else
      MailPrint("get reward state error")
    end
  end
end

local function onCreateOrAlterTable(self, result)
  local sqls = {}
  if result == nil then
    CreateMailTable(sqls)
  elseif 0 < #result then
    if result[1].col_count == 0 or #result[1].values == 0 then
      CreateMailTable(sqls)
    else
      LuaDBInterface.MigrateOneTable(sqls, "MailData", result[1], tblMailData)
    end
  end
  if #sqls == 0 then
    self:afterCreateOrAlterTable("ok", "table")
    return
  end
  LuaDBInterface.ExecuteMultiSQL(sqls, function(r2)
    if r2 == nil then
      ChatPrint("create error??")
      self:afterCreateOrAlterTable("error", "internal")
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
    self:afterCreateOrAlterTable(allisok and "ok" or "error", "create")
  end)
end

function MailDBManager:__getGroupCondSQL(groupId, exclude)
  local tbl = {}
  for k, v in pairs(MailTypeToInternalGroup) do
    if v == groupId and (exclude == nil or exclude[k] == nil) then
      table.insert(tbl, k)
    end
  end
  return "type in (" .. table.concat(tbl, ",") .. ")"
end

function MailDBManager:__Callback(status, reason)
  if self.callback then
    self.callback(status, reason)
  else
    ChatPrint("db : " .. status .. "," .. reason)
  end
end

local SQLAllRewardStateFormat = [[
SELECT uid, rewardStatus FROM 
MailData WHERE `toUser` = '%s' ORDER BY createTime
]]
local SQLGroupPageFormat = [[
SELECT %d as groupId, * FROM 
(SELECT * FROM MailData WHERE `toUser` = '%s' AND saveFlag = 0 AND %s ORDER BY createTime DESC LIMIT %d, %d)
]]
local SQLFavorPageFormat = [[
SELECT %d as groupId, * FROM 
(SELECT * FROM MailData WHERE `toUser` = '%s' AND saveFlag = 1 ORDER BY createTime DESC LIMIT %d, %d)
]]
local SQLGroupUnreadAndCountFormat = [[
SELECT %d as `groupId`, x as `total`, y as `unread`, z as `unreward` FROM 
(SELECT count(*) as x FROM MailData WHERE `toUser` = '%s' AND saveFlag = 0 AND %s),
(SELECT count(*) as y FROM MailData WHERE `toUser` = '%s' AND saveFlag = 0 AND status = 0 AND %s),
(SELECT count(*) as z FROM MailData WHERE `toUser` = '%s' AND saveFlag = 0 AND rewardStatus = 0 AND %s)
]]
local SQLFavorUnreadAndCountFormat = [[
SELECT %d as groupId, x as `total`, y as `unread`, z as `unreward` FROM 
(SELECT count(*) as x FROM MailData WHERE `toUser` = '%s' AND saveFlag = 1),
(SELECT count(*) as y FROM MailData WHERE `toUser` = '%s' AND saveFlag = 1 AND status = 0),
(SELECT count(*) as z FROM MailData WHERE `toUser` = '%s' AND saveFlag = 1 AND rewardStatus = 0)
]]
local SQLGroupAllUidFormat = [[
SELECT %d as groupId, uid FROM
(SELECT uid FROM MailData WHERE `toUser` = '%s' AND `saveFlag` = 0 AND `status` = 1 AND `rewardStatus` = 1 AND %s)
]]
local SQLFavorAllUidFormat = [[
SELECT %d as groupId, uid FROM
(SELECT uid FROM MailData WHERE `toUser` = '%s' AND `saveFlag` = 1)
]]
local SQLGroupNotRewardFormat = [[
SELECT %d as groupId, uid FROM
(SELECT uid FROM MailData WHERE `toUser` = '%s' AND `saveFlag` = 0 AND %s AND `rewardStatus` = 0)
]]
local SQLGroupNotRewardFormatNew = [[
SELECT %d as groupId, uid
FROM MailData
WHERE `toUser` = '%s' 
  AND `saveFlag` = 0 
  AND %s 
  AND `rewardStatus` = 0
]]
local SQLGroupNotReadFormat = [[
SELECT %d as groupId, uid FROM
(SELECT uid FROM MailData WHERE `toUser` = '%s' AND `saveFlag` = 0 AND %s AND `status` = 0)
]]
local SQLGroupNotReadFormatNew = [[
SELECT %d as groupId, uid
FROM MailData
WHERE `toUser` = '%s' 
  AND `saveFlag` = 0 
  AND %s 
  AND `status` = 0
]]
local SQLBeforeTimeStampFormat = [[
SELECT uid FROM
(SELECT uid FROM MailData WHERE `toUser` = '%s' AND `saveFlag` = 0 AND `createTime` < %s)
]]

function MailDBManager:__MailDBInit()
  LuaDBInterface.ExecuteSQL("SELECT name FROM sqlite_master WHERE type='table' AND name='MailData'", function(result)
    if #result.values > 0 then
      self:PullFromDB()
    else
      onCreateOrAlterTable(self)
    end
  end)
end

local function debugMailData(results)
  if results == nil then
    return
  end
  for groupId, groupResult in ipairs(results) do
    if groupResult.error == 0 and not table.IsNullOrEmpty(groupResult.values) then
      local mailDatas = ParseResultToMailDatas(groupResult)
      local cacheString = ""
      for _, v in ipairs(mailDatas) do
        cacheString = string.format("%s %s, %d, %s;", cacheString, tostring(v.uid), v.type, tostring(v.createTime))
      end
      Logger.LogInfo("MailDataManager::GetDBMail [Debug]: " .. groupId .. ": " .. cacheString)
    else
      Logger.LogInfo(string.format("MailDataManager::GetDBMail [Debug]: %d, %d, %d, %s", groupId, groupResult.error, groupResult.errorcode, groupResult.errormsg))
    end
  end
end

local function debugTypedMailCount(results)
  if results == nil then
    return
  end
  for i, groupResult in ipairs(results) do
    if groupResult.error == 0 and not table.IsNullOrEmpty(groupResult.values) then
      local groupCount = {}
      local cacheString = ""
      for _, value in ipairs(groupResult.values) do
        if value[2] ~= 0 then
          local gId = MailTypeToInternalGroup[value[1]]
          cacheString = cacheString .. string.format("(%d, %s, %d), ", value[1], tostring(gId), value[2])
          if gId ~= nil then
            if groupCount[gId] == nil then
              groupCount[gId] = 0
            end
            groupCount[gId] = groupCount[gId] + value[2]
          end
        end
      end
      Logger.LogInfo(string.format("MailDataManager::GetDBMailCount %d Typed [Debug]: %s", i, cacheString))
      cacheString = ""
      for key, value in pairs(groupCount) do
        cacheString = cacheString .. string.format("(%d, %d), ", key, value)
      end
      Logger.LogInfo(string.format("MailDataManager::GetDBMailCount %d Grouped [Debug]: %s", i, cacheString))
    end
  end
end

function MailDBManager:DebugQueryDB(playerUid)
  local testSqls = {}
  local logMaxGroup = 1
  for i = 1, logMaxGroup do
    local queryMails = ""
    if i == MailInternalGroup.MAIL_IN_favor then
      queryMails = string.format("SELECT %d as groupId, uid, type, createTime FROM MailData WHERE toUser = '%s' AND saveFlag = 1 ORDER BY createTime DESC LIMIT %d", i, playerUid, INIT_NUM)
    else
      local cond = self:__getGroupCondSQL(i)
      queryMails = string.format("SELECT %d as groupId, uid, type, createTime FROM MailData WHERE toUser = '%s' AND saveFlag = 0 AND %s ORDER BY createTime DESC LIMIT %d", i, playerUid, cond, INIT_NUM)
    end
    table.insert(testSqls, queryMails)
  end
  LuaDBInterface.ExecuteMultiSQL(testSqls, function(results)
    pcall(debugMailData, results)
  end)
  testSqls = {}
  local queryAllTypedMailCount1 = ""
  local queryAllTypedMailCount2 = ""
  for i = MailType.MAIL_SYSTEM, MailType.LW_TORCH_RELAY_REWARD do
    queryAllTypedMailCount1 = queryAllTypedMailCount1 .. string.format("SELECT %d as typeId, * FROM(SELECT count(*) as count FROM MailData WHERE toUser = '%s' AND saveFlag = 0 AND type = %d)", i, playerUid, i)
    queryAllTypedMailCount2 = queryAllTypedMailCount2 .. string.format("SELECT %d as typeId, * FROM(SELECT count(*) as count FROM MailData WHERE toUser = '%s' AND saveFlag = 1 AND type = %d)", i, playerUid, i)
    if i ~= MailType.LW_TORCH_RELAY_REWARD then
      queryAllTypedMailCount1 = queryAllTypedMailCount1 .. " UNION "
      queryAllTypedMailCount2 = queryAllTypedMailCount2 .. " UNION "
    end
  end
  table.insert(testSqls, queryAllTypedMailCount1)
  table.insert(testSqls, queryAllTypedMailCount2)
  LuaDBInterface.ExecuteMultiSQL(testSqls, function(results)
    pcall(debugTypedMailCount, results)
  end)
end

function MailDBManager:PullFromDB()
  local playerUid = ChatInterface.getPlayerUid()
  local tbl = {
    "pragma table_info ('MailData')"
  }
  LuaDBInterface.ExecuteMultiSQL(tbl, function(r)
    onCreateOrAlterTable(self, r)
  end)
  if CommonUtil.IsGrayServer(700, 735) then
    self:DebugQueryDB(playerUid)
  end
end

function MailDBManager:afterCreateOrAlterTable(status, reason)
  if status == "error" then
    Logger.LogError(string.format("%s: %s, %s", "afterCreateOrAlterTable", status, reason))
    return
  end
  local playerUid = ChatInterface.getPlayerUid()
  local sqls = {}
  for i = 1, MailInternalGroup.MAIL_IN_MAX do
    local queryMails = ""
    if i == MailInternalGroup.MAIL_IN_favor then
      queryMails = string.format("SELECT %d as groupId, uid FROM MailData WHERE toUser = '%s' AND saveFlag = 1 ORDER BY createTime DESC LIMIT %d", i, playerUid, INIT_NUM)
    else
      local cond = self:__getGroupCondSQL(i)
      queryMails = string.format("SELECT %d as groupId, uid FROM MailData WHERE toUser = '%s' AND saveFlag = 0 AND %s ORDER BY createTime DESC LIMIT %d", i, playerUid, cond, INIT_NUM)
    end
    table.insert(sqls, queryMails)
  end
  LuaDBInterface.ExecuteMultiSQL(sqls, function(results)
    self:afterQueryMailList(results)
  end)
end

function MailDBManager:afterQueryMailList(results)
  if results == nil then
    Logger.LogError("afterQueryMailList results is nil")
    return
  end
  local sqls = {}
  for groupId, groupResult in ipairs(results) do
    if groupResult.error == 0 and not table.IsNullOrEmpty(groupResult.values) then
      for _, value in ipairs(groupResult.values) do
        local sql = string.format("SELECT * FROM MailData WHERE uid = '%s'", value[2])
        table.insert(sqls, sql)
      end
    elseif groupResult.error ~= 0 or groupResult.errorcode ~= 0 then
      Logger.LogInfo(string.format("MailDataManager::GetDBMail: %d, %d, %d, %s", groupId, groupResult.error, groupResult.errorcode, groupResult.errormsg))
    end
  end
  for _, sql in ipairs(sqls) do
    LuaDBInterface.ExecuteSQL(sql, function(result1)
      local mailDatas = ParseResultToMailDatas(result1)
      if not table.IsNullOrEmpty(mailDatas) then
        DataCenter.MailDataManager:OnGetDBMails(mailDatas)
      end
    end)
  end
  self:UpdateGroupUnreadCount()
  local rewardStateSQL = string.format(SQLAllRewardStateFormat, playerUid)
  LuaDBInterface.ExecuteSQL(rewardStateSQL, function(result3)
    if result3.error ~= 0 and table.IsNullOrEmpty(result3.values) then
      MailPrint("no datas 3")
    else
      local t3 = LuaDBInterface.ParseResultToMultiLuaTables(result3)
      if not table.IsNullOrEmpty(t3) then
        DataCenter.MailDataManager:OnDBRewardState(t3)
      else
        MailPrint("get reward state error")
      end
    end
  end)
  LuaDBInterface.ExecuteSQL("SELECT 1", function()
    MailPrint("mail db init done.")
    self:__Callback(allisok and "ok" or "error", "create")
  end)
end

local function RandMails(max_count)
  local format = [[
	INSERT OR REPLACE INTO MailData (
		"uid",
		"toUser",
		"fromUser",
		"fromName",
		"title",
		"subTitle",
		"contents",
		"rewardId",
		"itemIdFlag",
		"status",
		"type",
		"rewardStatus",
		"saveFlag",
		"createTime",
		"reply",
		"replyText",
		"translationId",
		"mbLevel",
		"rewardTime",
		"extParam1",
		"extParam2",
		"translateMsg",
		"translatedLang",
		"custom",
		"expireTime"
	) VALUES (abs(RANDOM()), '%s', '', '', '310309', "", '310311', '', '1', '0', '%d', '1', '0', strftime('%%s','now')*1000 + abs(random() %% 1000) - abs(random() %% 86400000*5), '0', '', '', '0', '0', '', '')
	]]
  local t = {}
  local playerUid = ChatInterface.getPlayerUid()
  for i = 1, max_count do
    local type = MailType[table.randomKey(MailType)] or 0
    if type == 10000 then
      type = 2
    end
    local sql = string.format(format, playerUid, type)
    table.insert(t, sql)
  end
  LuaDBInterface.ExecuteMultiSQL(t, function(r)
    local a = 0
  end)
end

local function __doDBCallback(result, callback)
  if callback ~= nil then
    local mailUids = {}
    if result.error ~= 0 and table.IsNullOrEmpty(result.values) then
      MailPrint("result error~~!")
    else
      local t = LuaDBInterface.ParseResultToMultiLuaTables(result)
      for _, v in ipairs(t) do
        table.insert(mailUids, v.uid)
      end
    end
    callback(mailUids)
  end
end

function MailDBManager:Init(callback)
  ChatPrint("MailDBManager:Init")
  self.callback = callback
  self.curPlayerUid = LuaEntry.Player.uid
  self:__MailDBInit()
end

function MailDBManager:Uninit()
  ChatPrint("MailDBManager:Uninit")
  self.callback = nil
  self.self.curPlayerUid = ""
end

function MailDBManager:InsertMailData(mailData, callback)
  if string.IsNullOrEmpty(mailData.uid) or string.IsNullOrEmpty(mailData.toUser) then
    MailPrint("mailData error!!!")
    return
  end
  local sql = MakeInsertMailDatas(mailData, true)
  LuaDBInterface.ExecuteSQL(sql, function(result)
    if callback ~= nil then
      local ret = result.error == 0 and result.change_rows == 1 and true or false
      callback(ret)
    end
  end)
end

function MailDBManager:InsertMailDatas(mailDatas, callback)
  if table.IsNullOrEmpty(mailDatas) then
    MailPrint("mailDatas error!!!")
    return
  end
  local sqls = MakeInsertMailDatas(mailDatas, false)
  LuaDBInterface.ExecuteMultiSQL(sqls, function(result)
    if callback ~= nil then
      local allisok = true
      for i, v in ipairs(result) do
        if v.error ~= 0 then
          Logger.LogInfo(string.format("MailDataManager::InsertMailDatas [Debug]: %d, %d, %s", v.error, v.errorcode, v.errormsg))
          allisok = false
        end
      end
      callback(allisok, result)
    end
  end)
end

function MailDBManager:QueryMailData(mailId, callback)
  local sql = string.format("SELECT * FROM MailData WHERE uid = '%s'", mailId)
  LuaDBInterface.ExecuteUrgentSQL(sql, function(result)
    if callback ~= nil then
      if result.error ~= 0 or result.errorcode ~= 0 then
        Logger.LogInfo(string.format("MailDataManager::QueryMailData [Debug]: %d, %d, %s", result.error, result.errorcode, result.errormsg))
      end
      if result.error ~= 0 and table.IsNullOrEmpty(result.values) then
        Logger.LogInfo(string.format("MailDataManager::QueryMailData [Debug]: %d, %d, %s", result.error, result.errorcode, result.errormsg))
        callback(nil)
      else
        local mailData = ParseResultToMailDatas(result)
        if mailData then
          callback(mailData[1])
        end
      end
    end
  end)
end

function MailDBManager:UpdateMailData_Claim(mailIds, callback)
  local cond = ""
  if type(mailIds) == "table" then
    for _, v in ipairs(mailIds) do
      if 1 < _ then
        cond = cond .. " or "
      end
      cond = cond .. "`uid` = '" .. v .. "'"
    end
  else
    cond = "`uid` = '" .. mailIds .. "'"
  end
  local Update_Read_SQL = "UPDATE MailData SET `status`=1, `rewardStatus`=1 WHERE "
  local sql = Update_Read_SQL .. cond
  MailPrint("UpdateMailData_Read : " .. cond)
  LuaDBInterface.ExecuteSQL(sql, function(result)
    if callback ~= nil then
    end
  end)
end

function MailDBManager:UpdateMailData_ClaimAll(groupId, callback)
  local playerUid = self.curPlayerUid
  local groupTypes = self:__getGroupCondSQL(groupId)
  local sql = string.format("UPDATE MailData SET rewardStatus=1 WHERE `toUser` = '%s' and %s", playerUid, groupTypes)
  MailPrint("UpdateMailData_ClaimAll : " .. groupId)
  LuaDBInterface.ExecuteSQL(sql, function(result)
    if callback ~= nil then
    end
  end)
end

function MailDBManager:UpdateMailData_Read(mailId, callback)
  local Update_Read_SQL = "UPDATE MailData SET status=1 WHERE `uid`='%s'"
  local sql = string.format(Update_Read_SQL, mailId)
  MailPrint("UpdateMailData_Read : " .. mailId)
  LuaDBInterface.ExecuteSQL(sql, function(result)
    if callback ~= nil then
    end
  end)
end

function MailDBManager:UpdateMailData_Translate(mailId, translateMsg, translatedLang)
  local Update_Read_SQL = "UPDATE MailData SET translateMsg='%s',translatedLang='%s' WHERE `uid`='%s'"
  local translateMsgFixed = escape_sql(translateMsg)
  local sql = string.format(Update_Read_SQL, translateMsgFixed, translatedLang, mailId)
  MailPrint("UpdateMailData_Translated : " .. mailId)
  LuaDBInterface.ExecuteSQL(sql, function(result)
    if callback ~= nil then
    end
  end)
end

function MailDBManager:UpdateMailData_BatchRead(uids)
  local cond = table.concat(uids, "','")
  local sql = "UPDATE MailData SET status=1 WHERE `uid` in ('" .. cond .. "')"
  LuaDBInterface.ExecuteSQL(sql)
end

function MailDBManager:UpdateMailData_ReadAll(groupId, callback)
  local playerUid = self.curPlayerUid
  local groupTypes = self:__getGroupCondSQL(groupId)
  local sql = string.format("UPDATE MailData SET `status`=1 WHERE `toUser` = '%s' AND %s", playerUid, groupTypes)
  MailPrint("UpdateMailData_ReadAll : " .. groupId)
  LuaDBInterface.ExecuteSQL(sql, function(result)
    if callback ~= nil then
    end
  end)
end

function MailDBManager:RemoveMailData(mailId)
  local playerUid = self.curPlayerUid
  local sql = string.format("DELETE FROM MailData WHERE `toUser` = '%s' AND `uid` = '%s'", playerUid, mailId)
  LuaDBInterface.ExecuteSQL(sql, function(result)
    local t = 0
  end)
end

function MailDBManager:RemoveMailDatas(mailIds)
  if table.IsNullOrEmpty(mailIds) then
    MailPrint("RemoveMailDatas null!")
    return
  end
  local cond = table.concat(mailIds, "','")
  local sql1 = "DELETE FROM MailData WHERE `uid` in ('" .. cond .. "')"
  LuaDBInterface.ExecuteSQL(sql1, function(result)
    local t = 0
  end)
end

function MailDBManager:RemoveMailDataAll(groupId)
  if groupId == MailInternalGroup.MAIL_IN_favor then
    self:RemoveFavorMails()
    return
  end
  local playerUid = self.curPlayerUid
  local groupTypes = self:__getGroupCondSQL(groupId)
  local sql1 = string.format("DELETE FROM MailData WHERE `toUser` = '%s' AND `saveFlag` = 0 AND `status` = 1 AND `rewardStatus` = 1 AND %s", playerUid, groupTypes)
  LuaDBInterface.ExecuteSQL(sql1, function(result)
    local t = 0
  end)
end

function MailDBManager:RemoveFavorMails()
  local playerUid = self.curPlayerUid
  local sql = string.format("DELETE FROM MailData WHERE `toUser` = '%s' AND saveFlag = 1", playerUid)
  LuaDBInterface.ExecuteSQL(sql, function(result)
    local t = 0
  end)
end

function MailDBManager:UpdateMailData_AddFavor(mailId, callback)
  local Update_Favor_SQL = "UPDATE MailData SET saveFlag=1 WHERE `uid`='%s'"
  local sql = string.format(Update_Favor_SQL, mailId)
  MailPrint("UpdateMailData_AddFavor : " .. mailId)
  LuaDBInterface.ExecuteSQL(sql, function(result)
    if callback ~= nil then
    end
  end)
end

function MailDBManager:UpdateMailData_CancelFavor(mailId, callback)
  local Update_CancelFavor_SQL = "UPDATE MailData SET saveFlag=0 WHERE `uid`='%s'"
  local sql = string.format(Update_CancelFavor_SQL, mailId)
  MailPrint("UpdateMailData_CancelFavor : " .. mailId)
  LuaDBInterface.ExecuteSQL(sql, function(result)
    if callback ~= nil then
    end
  end)
end

function MailDBManager:QueryMoreMails(groupId, start, count, callback)
  local playerUid = self.curPlayerUid
  local sql = ""
  if groupId == MailInternalGroup.MAIL_IN_favor then
    sql = string.format(SQLFavorPageFormat, groupId, playerUid, start, count)
  else
    local cond = self:__getGroupCondSQL(groupId)
    sql = string.format(SQLGroupPageFormat, groupId, playerUid, cond, start, count)
  end
  MailPrint("QueryMoreMails : " .. sql)
  LuaDBInterface.ExecuteSQL(sql, function(result)
    if callback ~= nil then
      if result.error ~= 0 then
        Logger.LogInfo(string.format("MailDataManager::QueryMoreMails [Debug]: %d, %d, %d, %s", groupId, result.error, result.errorcode, result.errormsg))
      end
      if result.errorcode == 10 then
        self:QueryMoreMailsOneByOne(groupId, start, count, nil, callback)
      elseif result.error ~= 0 and table.IsNullOrEmpty(result.values) then
        callback(nil)
      else
        local mailDatas = ParseResultToMailDatas(result)
        callback(mailDatas)
      end
    end
  end)
end

function MailDBManager:QueryMoreMailsOneByOne(groupId, start, count, cond, callback)
  local playerUid = ChatInterface.getPlayerUid()
  local queryMails = ""
  if groupId == MailInternalGroup.MAIL_IN_favor then
    queryMails = string.format("SELECT %d as groupId, uid FROM MailData WHERE toUser = '%s' AND saveFlag = 1 ORDER BY createTime DESC LIMIT %d", groupId, playerUid, count)
  else
    cond = cond or self:__getGroupCondSQL(groupId)
    queryMails = string.format("SELECT %d as groupId, uid FROM MailData WHERE toUser = '%s' AND saveFlag = 0 AND %s ORDER BY createTime DESC LIMIT %d, %d", groupId, playerUid, cond, start, count)
  end
  LuaDBInterface.ExecuteSQL(queryMails, function(result)
    local sqls = {}
    if result.error == 0 and not table.IsNullOrEmpty(result.values) then
      for _, value in ipairs(result.values) do
        local sql = string.format("SELECT * FROM MailData WHERE uid = '%s'", value[2])
        table.insert(sqls, sql)
      end
    elseif result.error ~= 0 or result.errorcode ~= 0 then
      Logger.LogInfo(string.format("MailDataManager::QueryMoreMailsOneByOne: %d, %d, %d, %s", groupId, result.error, result.errorcode, result.errormsg))
    end
    if #sqls == 0 then
      if type(callback) == "function" then
        callback()
      end
      return
    end
    local num = #sqls
    local list = {}
    for _, sql in ipairs(sqls) do
      LuaDBInterface.ExecuteSQL(sql, function(result1)
        local mailDatas = ParseResultToMailDatas(result1)
        if not table.IsNullOrEmpty(mailDatas) then
          DataCenter.MailDataManager:OnGetDBMails(mailDatas)
          table.insertto(list, mailDatas)
        end
        num = num - 1
        if num == 0 and type(callback) == "function" then
          callback(list)
        end
      end)
    end
  end)
end

function MailDBManager:QueryMailsByType(type, start, count, callback)
  local playerUid = self.curPlayerUid
  local cond = "type in (" .. type .. ")"
  local sql = string.format(SQLGroupPageFormat, 0, playerUid, cond, start, count)
  MailPrint("QueryMoreMails : " .. sql)
  LuaDBInterface.ExecuteSQL(sql, function(result)
    if callback ~= nil then
      if result.error ~= 0 then
        Logger.LogInfo(string.format("MailDataManager::QueryMailsByType [Debug]: %d, %d, %d, %s", 0, result.error, result.errorcode, result.errormsg))
      end
      if result.errorcode == 10 then
        self:QueryMoreMailsOneByOne(MailInternalGroup.MAIL_IN_hide, start, count, cond, callback)
      elseif result.error ~= 0 and table.IsNullOrEmpty(result.values) then
        callback(nil)
      else
        local mailDatas = ParseResultToMailDatas(result)
        if not table.IsNullOrEmpty(mailDatas) then
          DataCenter.MailDataManager:OnGetDBMails(mailDatas)
        end
        callback(mailDatas)
      end
    end
  end)
end

function MailDBManager:QueryMailsByTypes(types, start, count, callback)
  if types == nil then
    if callback ~= nil then
      callback(nil)
    end
    return
  end
  local playerUid = self.curPlayerUid
  local cond = "type in (" .. table.concat(types, ",") .. ")"
  local sql = string.format(SQLGroupPageFormat, 0, playerUid, cond, start, count)
  MailPrint("QueryMailsByTypes : " .. sql)
  LuaDBInterface.ExecuteSQL(sql, function(result)
    if callback ~= nil then
      if result.error ~= 0 then
        Logger.LogInfo(string.format("MailDataManager::QueryMailsByTypes [Debug]: %d, %d, %d, %s", 0, result.error, result.errorcode, result.errormsg))
      end
      if result.errorcode == 10 then
        self:QueryMoreMailsOneByOne(MailInternalGroup.MAIL_IN_hide, start, count, cond, callback)
      elseif result.error ~= 0 and table.IsNullOrEmpty(result.values) then
        callback(nil)
      else
        local mailDatas = ParseResultToMailDatas(result)
        if not table.IsNullOrEmpty(mailDatas) then
          DataCenter.MailDataManager:OnGetDBMails(mailDatas)
        end
        callback(mailDatas)
      end
    end
  end)
end

function MailDBManager:GetAllCanDeleteMailUids(groupId, callback)
  local playerUid = self.curPlayerUid
  local sql = ""
  if groupId == MailInternalGroup.MAIL_IN_favor then
    sql = string.format(SQLFavorAllUidFormat, groupId, playerUid)
  else
    local cond = self:__getGroupCondSQL(groupId)
    sql = string.format(SQLGroupAllUidFormat, groupId, playerUid, cond)
  end
  MailPrint("GetAllCanDeleteMailUids : " .. sql)
  LuaDBInterface.ExecuteSQL(sql, function(result)
    __doDBCallback(result, callback)
  end)
end

function MailDBManager:GetAllUnreadMailUids(groupId, callback)
  local playerUid = self.curPlayerUid
  local sql = ""
  local sqlFunc = LuaDBInterface.ExecuteSQL
  if groupId == MailInternalGroup.MAIL_IN_favor then
    return
  else
    local cond = self:__getGroupCondSQL(groupId, MailCantClaimAllType)
    sql = string.format(SQLGroupNotReadFormatNew, groupId, playerUid, cond)
    sqlFunc = LuaDBInterface.ExecuteUrgentSQL
  end
  MailPrint("GetAllUnreadMailUids : " .. sql)
  sqlFunc(sql, function(result)
    __doDBCallback(result, callback)
  end)
end

function MailDBManager:GetAllCanRewardMailUids(groupId, callback)
  local playerUid = self.curPlayerUid
  local sql = ""
  local sqlFunc = LuaDBInterface.ExecuteSQL
  if groupId == MailInternalGroup.MAIL_IN_favor then
    return
  else
    local cond = self:__getGroupCondSQL(groupId, MailCantClaimAllType)
    sql = string.format(SQLGroupNotRewardFormatNew, groupId, playerUid, cond)
    sqlFunc = LuaDBInterface.ExecuteUrgentSQL
  end
  sqlFunc(sql, function(result)
    __doDBCallback(result, callback)
  end)
end

function MailDBManager:GetAllExpireMailUids(timeStamp, callback)
  local sql = string.format(SQLBeforeTimeStampFormat, self.curPlayerUid, timeStamp)
  MailPrint("GetAllExpireMailUids : " .. sql)
  LuaDBInterface.ExecuteSQL(sql, function(result)
    __doDBCallback(result, callback)
  end)
end

function MailDBManager:UpdateMailContents(mailId, contents, callback)
  local Update_Contents_SQL = "UPDATE MailData SET contents='%s' WHERE `uid`='%s'"
  local sql = string.format(Update_Contents_SQL, contents, mailId)
  MailPrint("UpdateMailContents : " .. sql)
  LuaDBInterface.ExecuteSQL(sql, function(result)
    __doDBCallback(result, callback)
  end)
end

function MailDBManager:QueryMailDataContent(mailId, callback)
  local sql = string.format("SELECT contents FROM MailData WHERE uid = '%s'", mailId)
  LuaDBInterface.ExecuteUrgentSQL(sql, function(result)
    if callback ~= nil then
      if result.error ~= 0 or result.errorcode ~= 0 then
        Logger.LogInfo(string.format("MailDataManager::QueryMailData [Debug]: %d, %d, %s", result.error, result.errorcode, result.errormsg))
      end
      if result.error ~= 0 and table.IsNullOrEmpty(result.values) then
        Logger.LogInfo(string.format("MailDataManager::QueryMailData [Debug]: %d, %d, %s", result.error, result.errorcode, result.errormsg))
        callback(nil)
      else
        local mailData = ParseResultToMailDatas(result)
        if mailData then
          callback(mailData[1])
        end
      end
    end
  end)
end

function MailDBManager:UpdateGroupUnreadCount(callback)
  local tCount = {}
  local playerUid = ChatInterface.getPlayerUid()
  for i = 1, MailInternalGroup.MAIL_IN_MAX do
    local sql2 = ""
    if i == MailInternalGroup.MAIL_IN_favor then
      sql2 = string.format(SQLFavorUnreadAndCountFormat, i, playerUid, playerUid, playerUid)
    else
      local cond = self:__getGroupCondSQL(i)
      sql2 = string.format(SQLGroupUnreadAndCountFormat, i, playerUid, cond, playerUid, cond, playerUid, cond)
    end
    table.insert(tCount, sql2)
  end
  local tCountSQL = table.concat(tCount, " UNION ALL ")
  LuaDBInterface.ExecuteSQL(tCountSQL, function(result2)
    if result2.error ~= 0 and table.IsNullOrEmpty(result2.values) then
      MailPrint("no datas 2")
    else
      local t2 = LuaDBInterface.ParseResultToMultiLuaTables(result2)
      if not table.IsNullOrEmpty(t2) then
        DataCenter.MailDataManager:OnDBGroupUnreadCount(t2, redFix)
        if type(callback) == "function" then
          callback()
        end
      else
        MailPrint("get count error")
      end
    end
  end)
end

local function GetConditionByInfo(group, types, mailIds, excludeMailIds)
  if group == MailInternalGroup.MAIL_IN_favor then
    return ""
  end
  local condTab = {}
  local groupCond = DataCenter.MailDataManager.DB:__getGroupCondSQL(group)
  for i = 1, #types do
    local cond = ""
    local type = types[i] or {}
    local mailId = mailIds[i] or {}
    local excludeMailId = excludeMailIds[i] or {}
    if next(type) then
      cond = "type in (" .. table.concat(type, ",") .. ")"
    end
    if next(mailId) then
      if string.IsNullOrEmpty(cond) then
        cond = "(mailId in (" .. table.concat(mailId, ",") .. ") AND " .. groupCond .. ")"
      else
        cond = "(" .. cond .. " OR (mailId in (" .. table.concat(mailId, ",") .. ") AND " .. groupCond .. "))"
      end
    end
    if next(excludeMailId) then
      if string.IsNullOrEmpty(cond) then
        cond = "mailId not in (" .. table.concat(excludeMailId, ",") .. ")"
      else
        cond = "(" .. cond .. " AND mailId not in (" .. table.concat(excludeMailId, ",") .. "))"
      end
    end
    if not string.IsNullOrEmpty(cond) then
      table.insert(condTab, "(" .. cond .. ")")
    end
  end
  local condTotal = " AND " .. groupCond
  if not table.IsNullOrEmpty(condTab) then
    condTotal = condTotal .. " AND (" .. table.concat(condTab, " OR ") .. ")"
  end
  return condTotal
end

function MailDBManager:GetGroupMailByKeyword(group, types, mailIds, excludeMailIds, keywords, startIndex, callback, isGetCount)
  local playerUid = ChatInterface.getPlayerUid()
  local sql, values
  local likeConds = {}
  local fields = {
    "title",
    "subtitle",
    "contents"
  }
  values = {}
  values[1] = playerUid
  for i = 1, #keywords do
    for _, field in ipairs(fields) do
      table.insert(likeConds, field .. " LIKE '%' || ? || '%'")
      table.insert(values, keywords[i])
    end
  end
  values[#values + 1] = startIndex
  values[#values + 1] = INIT_NUM
  if group == MailInternalGroup.MAIL_IN_favor then
    sql = [[
FROM MailData 
WHERE toUser = ? AND saveFlag = 1 AND (]] .. table.concat(likeConds, " OR ") .. [[
)
ORDER BY createTime DESC 
LIMIT ?, ?
]]
  else
    local cond = GetConditionByInfo(group, types, mailIds, excludeMailIds)
    if string.IsNullOrEmpty(cond) then
      Logger.LogError("GetGroupMailByKeyword Condition Null!")
      return
    end
    sql = [[
FROM MailData 
WHERE toUser = ? 
AND ]] .. cond .. [[
 
AND (]] .. table.concat(likeConds, " OR ") .. [[
)
ORDER BY createTime DESC 
LIMIT ?, ?
]]
  end
  if isGetCount then
    sql = "SELECT count(*) as count " .. sql
  else
    sql = "SELECT * " .. sql
  end
  LuaDBInterface.ExecuteSTMT(sql, values, nil, function(result1)
    if isGetCount then
      local result = LuaDBInterface.ParseResultToMultiLuaTables(result1)
      if callback then
        callback(result)
      end
    else
      local mailDatas = ParseResultToMailDatas(result1)
      if callback then
        callback(mailDatas)
      end
    end
  end)
end

function MailDBManager:QueryMailsByTypesAndMailIds(group, types, mailIds, excludeMailIds, start, count, callback, isGetCount)
  if types == nil or mailIds == nil then
    if callback ~= nil then
      callback(nil)
    end
    return
  end
  local playerUid = self.curPlayerUid
  local condTotal = GetConditionByInfo(group, types, mailIds, excludeMailIds)
  local sql = ""
  if group == MailInternalGroup.MAIL_IN_favor then
    sql = string.format("FROM MailData WHERE `toUser` = '%s' AND saveFlag = 1 %s ORDER BY createTime DESC LIMIT %d, %d", playerUid, condTotal, start, count)
  else
    sql = string.format("FROM MailData WHERE `toUser` = '%s' AND saveFlag = 0 %s ORDER BY createTime DESC LIMIT %d, %d", playerUid, condTotal, start, count)
  end
  if isGetCount then
    sql = "SELECT count(*) as count " .. sql
  else
    sql = "SELECT * " .. sql
  end
  LuaDBInterface.ExecuteSQL(sql, function(result)
    if callback ~= nil then
      if result.error ~= 0 and table.IsNullOrEmpty(result.values) then
        callback(nil)
      elseif isGetCount then
        local result1 = LuaDBInterface.ParseResultToMultiLuaTables(result)
        callback(result1)
      else
        local mailDatas = ParseResultToMailDatas(result)
        callback(mailDatas)
      end
    end
  end)
end

function MailDBManager:QueryMailsByTypesAndMailIdsWithTime(group, types, day, start, count, callback, isGetCount)
  if types == nil then
    if callback ~= nil then
      callback(table.empty)
    end
    return
  end
  local timeLimit = UITimeManager:GetInstance():GetServerTime() - day * 24 * 60 * 60 * 1000
  local playerUid = self.curPlayerUid
  local condTotal = GetConditionByInfo(group, types, table.empty, table.empty)
  local sql = ""
  if group == MailInternalGroup.MAIL_IN_favor then
    sql = string.format("FROM MailData WHERE `toUser` = '%s' AND `createTime` > %s AND saveFlag = 1 %s ORDER BY createTime DESC LIMIT %d, %d", playerUid, timeLimit, condTotal, start, count)
  else
    sql = string.format("FROM MailData WHERE `toUser` = '%s' AND `createTime` > %s AND saveFlag = 0 %s ORDER BY createTime DESC LIMIT %d, %d", playerUid, timeLimit, condTotal, start, count)
  end
  if isGetCount then
    sql = "SELECT count(*) as count " .. sql
  else
    sql = "SELECT * " .. sql
  end
  LuaDBInterface.ExecuteSQL(sql, function(result)
    if callback ~= nil then
      if result.error ~= 0 and table.IsNullOrEmpty(result.values) then
        callback(nil)
      elseif isGetCount then
        local result1 = LuaDBInterface.ParseResultToMultiLuaTables(result)
        callback(result1)
      else
        local mailDatas = ParseResultToMailDatas(result)
        callback(mailDatas)
      end
    end
  end)
end

return MailDBManager
