local ActivityReceiveDataManager = BaseClass("ActivityReceiveDataManager")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.activityStatusReceiveDict = {}
  self.statusToActId = {}
  self.actIdToStatusList = {}
  self.actCanGetMaxNumOneDay = {}
  self.actCurNum = {}
end

local function __delete(self)
  self.activityStatusReceiveDict = nil
  self.statusToActId = nil
  self.actIdToStatusList = nil
  self.actCanGetMaxNumOneDay = nil
  self.actCurNum = nil
end

function ActivityReceiveDataManager:GetActIdByStatusId(statusId)
  if self.statusToActId[statusId] == nil then
    local actId = GetTableData(TableName.StatusTab, statusId, "activity_id")
    local actIdNum = tonumber(actId) or 0
    self.statusToActId[statusId] = actIdNum
  end
  return self.statusToActId[statusId]
end

function ActivityReceiveDataManager:GetStatusListByActId(actId)
  if self.actIdToStatusList[actId] == nil then
    self.actIdToStatusList[actId] = {}
    local actTempData = LocalController:instance():getLine(TableName.Activity, toInt(actId))
    if actTempData then
      local actType = tonumber(actTempData.type) or 0
      if actType == EnumActivity.ActValentineReceiveGift.Type then
        local actDetailTemp = LocalController:instance():getLine(actTempData.tableInfo, toInt(actTempData.tableInfoType))
        if actDetailTemp then
          local statusId = tonumber(actDetailTemp.day_first_status) or 0
          if 0 < statusId then
            table.insert(self.actIdToStatusList[actId], statusId)
          end
        end
      end
    end
  end
  return self.actIdToStatusList[actId]
end

function ActivityReceiveDataManager:GetMaxNumOneDayByActId(actId)
  if self.actCanGetMaxNumOneDay[actId] == nil then
    self.actCanGetMaxNumOneDay[actId] = 0
    local actTempData = LocalController:instance():getLine(TableName.Activity, toInt(actId))
    if actTempData then
      local actType = tonumber(actTempData.type) or 0
      if actType == EnumActivity.ActValentineReceiveGift.Type then
        local actDetailTemp = LocalController:instance():getLine(actTempData.tableInfo, toInt(actTempData.tableInfoType))
        if actDetailTemp then
          local bubble_times = tonumber(actDetailTemp.bubble_times) or 0
          self.actCanGetMaxNumOneDay[actId] = bubble_times
        end
      end
    end
  end
  return self.actCanGetMaxNumOneDay[actId]
end

function ActivityReceiveDataManager:GetCurNumByActId(actId)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local todayZero = UITimeManager:GetInstance():GetTodayZeroServerTime(curTime // 1000) * 1000
  local tomorrowZero = todayZero + 86400000
  if self.actCurNum[actId] == nil then
    self.actCurNum[actId] = {curNum = 0, needRefreshTime = 0}
  end
  if curTime >= self.actCurNum[actId].needRefreshTime then
    self.actCurNum[actId].curNum = 0
    local maxNum = self:GetMaxNumOneDayByActId(actId)
    local isNeedCheckTime = false
    if 0 < maxNum then
      isNeedCheckTime = true
    end
    if isNeedCheckTime then
      self.actCurNum[actId].needRefreshTime = tomorrowZero
    else
      self.actCurNum[actId].needRefreshTime = curTime + 864000000
    end
    local statusList = self:GetStatusListByActId(actId)
    for _, statusId in ipairs(statusList) do
      if self.activityStatusReceiveDict[statusId] then
        for playerUuid, expireTime in pairs(self.activityStatusReceiveDict[statusId]) do
          if isNeedCheckTime then
            if curTime < expireTime * 1000 then
              self.actCurNum[actId].curNum = self.actCurNum[actId].curNum + 1
            end
          else
            self.actCurNum[actId].curNum = self.actCurNum[actId].curNum + 1
          end
        end
      end
    end
  end
  return self.actCurNum[actId].curNum
end

function ActivityReceiveDataManager:GetActivityStatusReceiveDict(statusId, playerUuid)
  local ret = false
  if self.activityStatusReceiveDict[statusId] and self.activityStatusReceiveDict[statusId][playerUuid] then
    local actId = self:GetActIdByStatusId(statusId)
    local maxNum = self:GetMaxNumOneDayByActId(actId)
    local isNeedCheckTime = false
    if 0 < maxNum then
      isNeedCheckTime = true
    end
    if isNeedCheckTime then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local expireTime = self.activityStatusReceiveDict[statusId][playerUuid]
      if curTime < expireTime * 1000 then
        ret = true
      end
    else
      ret = true
    end
  end
  return ret
end

function ActivityReceiveDataManager:SetActivityStatusReceiveDictInitMsg(message)
  local activityReceiveArr = message.activityReceiveArr
  if activityReceiveArr == nil then
    return
  end
  for index, val in ipairs(activityReceiveArr) do
    local playerData = string.split(val, "_")
    if playerData and #playerData == 3 then
      local playerUuid = playerData[1]
      local statusId = tonumber(playerData[2]) or 0
      local expireTime = tonumber(playerData[3]) or 0
      if not self.activityStatusReceiveDict[statusId] then
        self.activityStatusReceiveDict[statusId] = {}
      end
      self.activityStatusReceiveDict[statusId][playerUuid] = expireTime
    end
  end
end

function ActivityReceiveDataManager:SetActivityStatusReceiveDictPushMsg(message)
  local record = message.record
  if record == nil then
    return
  end
  local playerData = string.split(record, "_")
  if playerData and #playerData == 3 then
    local playerUuid = playerData[1]
    local statusId = tonumber(playerData[2]) or 0
    local expireTime = tonumber(playerData[3]) or 0
    if not self.activityStatusReceiveDict[statusId] then
      self.activityStatusReceiveDict[statusId] = {}
    end
    self.activityStatusReceiveDict[statusId][playerUuid] = expireTime
    local actId = self:GetActIdByStatusId(statusId)
    if self.actCurNum[actId] then
      self.actCurNum[actId].curNum = self.actCurNum[actId].curNum + 1
    end
  end
end

function ActivityReceiveDataManager:InitData(msg)
  self:SetActivityStatusReceiveDictInitMsg(msg)
end

ActivityReceiveDataManager.__init = __init
ActivityReceiveDataManager.__delete = __delete
return ActivityReceiveDataManager
