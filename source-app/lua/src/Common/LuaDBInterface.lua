local LuaDBInterface = {
  init = false,
  sql_count = 0,
  executing_sql_count = 0
}
local SQLManager = CS.LuaDatabaseManager

function LuaDBInterface.Init(callback)
  print("[DB]LuaDBInterface.Init")
  
  local function cb(b)
    LuaDBInterface.init = b
    if b == false then
      print("[DB]database error!!!")
    end
    if callback then
      callback(b)
    end
  end
  
  if LuaEntry.Sqlite and LuaEntry.Async then
    SQLManager = LuaEntry.Sqlite
  end
  if LuaDBInterface.init == true then
    cb(true)
  else
    SQLManager.InitDataBase("config.db", cb)
  end
  return
end

function LuaDBInterface.Uninit()
  print("[DB]LuaDBInterface.Uninit")
  LuaDBInterface.init = false
  SQLManager.UninitDatabase()
  print("[DB]LuaDBInterface.Uninit end")
end

function LuaDBInterface.ExecuteSQL(sql, callback)
  LuaDBInterface.sql_count = LuaDBInterface.sql_count + 1
  LuaDBInterface.executing_sql_count = LuaDBInterface.executing_sql_count + 1
  SQLManager.ExecuteSQL(sql, function(r)
    LuaDBInterface.executing_sql_count = LuaDBInterface.executing_sql_count - 1
    if r.error ~= 0 then
      local error = r.error or 0
      local errormsg = r.errormsg or ""
      Logger.LogError("[SQL] error: " .. error .. ", msg: " .. errormsg)
    end
    if callback then
      callback(r)
    end
  end)
  return
end

function LuaDBInterface.ExecuteUrgentSQL(sql, callback)
  LuaDBInterface.sql_count = LuaDBInterface.sql_count + 1
  LuaDBInterface.executing_sql_count = LuaDBInterface.executing_sql_count + 1
  SQLManager.ExecuteUrgentSQL(sql, function(r)
    LuaDBInterface.executing_sql_count = LuaDBInterface.executing_sql_count - 1
    if r.error ~= 0 then
      local error = r.error or 0
      local errormsg = r.errormsg or ""
      Logger.LogError("[SQL] " .. sql .. " error: " .. error .. ", msg: " .. errormsg)
    end
    if callback then
      callback(r)
    end
  end)
  return
end

function LuaDBInterface.ExecuteSTMT(sqlstmt, values, format, callback)
  LuaDBInterface.sql_count = LuaDBInterface.sql_count + 1
  LuaDBInterface.executing_sql_count = LuaDBInterface.executing_sql_count + 1
  SQLManager.ExecuteSTMT(sqlstmt, values, format, function(r)
    LuaDBInterface.executing_sql_count = LuaDBInterface.executing_sql_count - 1
    if r.error ~= 0 then
      local error = r.error or 0
      local errormsg = r.errormsg or ""
      Logger.LogError("[SQL] " .. sqlstmt .. " error: " .. error .. ", msg: " .. errormsg)
    end
    if callback then
      callback(r)
    end
  end)
  return
end

function LuaDBInterface.ExecuteMultiSQL(sqlArr, callback)
  LuaDBInterface.sql_count = LuaDBInterface.sql_count + 1
  LuaDBInterface.executing_sql_count = LuaDBInterface.executing_sql_count + 1
  SQLManager.ExecuteMultiSQL(sqlArr, function(r)
    LuaDBInterface.executing_sql_count = LuaDBInterface.executing_sql_count - 1
    callback(r)
  end)
  return
end

function LuaDBInterface.CreateOneTable(sqlTable, tableName, checkTableInfo)
  local createsql = "CREATE TABLE IF NOT EXISTS \"" .. tableName .. "\" ( "
  table.walk(checkTableInfo, function(k, v)
    local pk = v[5] == 1 and " primary key" or ""
    local notnull = v[3] == 1 and " not null" or ""
    createsql = createsql .. "\n" .. "\"" .. v[1] .. "\"" .. " " .. v[2] .. pk .. notnull .. ","
  end)
  createsql = string.sub(createsql, 1, -2)
  createsql = createsql .. " )"
  table.insert(sqlTable, createsql)
end

function LuaDBInterface.MigrateOneTable(sqlTable, tableName, tableInfo, checkTableInfo)
  local alterInfo = {}
  for i = 1, #checkTableInfo do
    local found = false
    for j = 1, #tableInfo.values do
      if checkTableInfo[i][1] == tableInfo.values[j][2] then
        found = true
        break
      end
    end
    if found == false then
      table.insert(alterInfo, i)
    end
  end
  for j = 1, #alterInfo do
    local pos = alterInfo[j]
    local alterSQL = "ALTER TABLE " .. tableName .. " ADD COLUMN " .. checkTableInfo[pos][1] .. " " .. checkTableInfo[pos][2]
    table.insert(sqlTable, alterSQL)
  end
end

function LuaDBInterface.ParseResultToLuaTable(result)
  if result == nil or result.error ~= 0 or 0 >= #result.values then
    return nil
  end
  if #result.values > 1 then
    print("multi rows??")
  end
  local tbl = {}
  for i = 1, result.col_count do
    local k = result.cols[i].name
    local v = result.values[1][i]
    tbl[k] = v
  end
  return tbl
end

function LuaDBInterface.ParseResultToMultiLuaTables(result)
  local tbl = {}
  if result == nil or result.error ~= 0 or result.cols == nil then
    return tbl
  end
  if result.values == nil or 0 >= #result.values then
    return tbl
  end
  local col_count = result.col_count
  local cols = result.cols
  for rowidx = 1, #result.values do
    local row = {}
    for i = 1, col_count do
      local k = cols[i].name
      local v = result.values[rowidx][i]
      row[k] = v
    end
    table.insert(tbl, row)
  end
  return tbl
end

function LuaDBInterface.escape(keyWord)
  keyWord = string.gsub(keyWord, "'", "''")
  return keyWord
end

return LuaDBInterface
