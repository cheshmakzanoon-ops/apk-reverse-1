local ActMigrationData = BaseClass("ActMigrationData")
local ActMigrationMyData = require("DataCenter.ActMigrationManager.ActMigrationMyData")
local ActMigrationServerData = require("DataCenter.ActMigrationManager.ActMigrationServerData")

function ActMigrationData:__init()
  self.openId = 0
  self.startTime = 0
  self.endTime = 0
  self.serverIdList = {}
  self.serverDic = {}
  self.myInfo = nil
  self.baseScore = 0
  self.baseScoreHalf = 0
  self.colorList = {}
end

function ActMigrationData:__delete()
  self.openId = 0
  self.startTime = 0
  self.endTime = 0
  self.serverIdList = {}
  self.serverDic = {}
  self.myInfo = nil
  self.baseScore = 0
  self.baseScoreHalf = 0
  self.colorList = {}
end

function ActMigrationData:ParseData(t)
  if t == nil then
    return
  end
  if t.migrateOpenId then
    self.openId = t.migrateOpenId
  end
  if t.startTime then
    self.startTime = t.startTime
  end
  if t.endTime then
    self.endTime = t.endTime
  end
  if t.baseScore then
    self.baseScore = t.baseScore
  end
  if t.baseScoreHalf then
    self.baseScoreHalf = t.baseScoreHalf
  end
  local colorList = t.colorList
  if colorList then
    self.colorList = colorList
  end
  local sList = t.migrateServerList
  if sList then
    local idList = {}
    for _, v in pairs(sList) do
      local id = self:UpdateServer(v)
      table.insert(idList, id)
    end
    self.serverIdList = idList
  end
  if t.migrateOpenId then
    self.openId = t.migrateOpenId
  end
  self:UpdateMyInfo(t.myInfo)
end

function ActMigrationData:UpdateServer(info)
  local serverId = info.serverId
  local data = self.serverDic[serverId]
  if data == nil then
    data = ActMigrationServerData.New()
    self.serverDic[serverId] = data
  end
  data:ParseData(info)
  return serverId
end

function ActMigrationData:GetServer(serverId)
  return self.serverDic[serverId]
end

function ActMigrationData:UpdateMyInfo(info)
  if not info then
    return
  end
  if self.myInfo == nil then
    self.myInfo = ActMigrationMyData.New()
  end
  self.myInfo:ParseData(info)
end

function ActMigrationData:GetOpenConfig()
  if not self.openConfig then
    local line = LocalController:instance():getLine(TableName.LW_Migration_Open, self.openId)
    if line then
      local MyMin = math.min
      local MyStr2Array = string.string2array_i_oneSep
      local MySplit = string.split
      local MyToNum = tonumber
      local MyInsert = table.insert
      local info = {}
      info.serverList = MyStr2Array(line:getValue("server_list"), ";")
      info.group = MyToNum(line:getValue("migration_para_group"))
      info.autoPower = MyStr2Array(line:getValue("auto_apply_max_power"), ";")
      info.minPower = MyStr2Array(line:getValue("apply_min_power"), ";")
      info.baseLv = MyStr2Array(line:getValue("base_lv"), ";")
      info.top_rank_count = MyToNum(line:getValue("top_rank_count")) or 0
      info.exchange_group = MyToNum(line:getValue("exchange_group")) or 0
      local stateTimes = {}
      local prepareList = MySplit(line:getValue("prepare_time_list"), "|")
      local l = #prepareList
      local applyList = MySplit(line:getValue("apply_time_list"), "|")
      l = MyMin(l, #applyList)
      local migrationList = MySplit(line:getValue("migration_time_list"), "|")
      l = MyMin(l, #migrationList)
      
      local function DoInsert(list, type, i)
        local tmpList = MyStr2Array(list, ";")
        if i == 1 and type == ActMigrationState.Prepare and 1 < MyToNum(tmpList[1]) then
          MyInsert(stateTimes, {
            state = ActMigrationState.Notice,
            sTime = self.startTime,
            eTime = self.startTime + (MyToNum(tmpList[1]) - 1) * OneDayTime * 1000
          })
        end
        MyInsert(stateTimes, {
          state = type,
          sTime = self.startTime + (MyToNum(tmpList[1]) - 1) * OneDayTime * 1000,
          eTime = self.startTime + (MyToNum(tmpList[2]) - 1) * OneDayTime * 1000
        })
      end
      
      for i = 1, l do
        DoInsert(prepareList[i], ActMigrationState.Prepare, i)
        DoInsert(applyList[i], ActMigrationState.Apply, i)
        DoInsert(migrationList[i], ActMigrationState.Migrate, i)
      end
      DoInsert(line:getValue("publicity_time_list"), ActMigrationState.Announce)
      info.stateTimes = stateTimes
      self.openConfig = info
    end
  end
  return self.openConfig
end

function ActMigrationData:GetStageInfo(stage)
  local openConfig = self:GetOpenConfig()
  if not openConfig then
    return nil
  end
  local stateTimes = openConfig.stateTimes
  return stateTimes[stage]
end

function ActMigrationData:GetCurStageInfo()
  local openConfig = self:GetOpenConfig()
  if not openConfig then
    return 0, nil
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local stateTimes = openConfig.stateTimes
  local l = #stateTimes
  if curTime < self.startTime then
    return 0, stateTimes[1], l
  end
  if curTime >= self.endTime then
    return 0, stateTimes[l], l
  end
  for i, v in ipairs(stateTimes) do
    if curTime < v.eTime then
      return i, v, l
    end
  end
  return l, stateTimes[l], l
end

return ActMigrationData
