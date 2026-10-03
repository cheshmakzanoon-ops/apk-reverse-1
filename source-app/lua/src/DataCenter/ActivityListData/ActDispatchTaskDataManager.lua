local DispatchTaskMarkData = require("UI.UIActivityCenterTable.Component.DispatchTask.DispatchTaskMarkData")
local ActDispatchTaskDataManager = BaseClass("ActDispatchTaskDataManager")
local Localization = CS.GameEntry.Localization
local Time = _ENV.Time
local GetAllianceTaskInterval = 5
local GetAllSingleTaskInterval = 10
local starImgPath = {
  "zyf_nanduxuanze_star",
  "zyf_nanduxuanze_star_red"
}

function ActDispatchTaskDataManager:__init()
  self.singleTask = {}
  self.allianceTask = {}
  self.markTask = {}
  self.MarkDataMap = {}
  self.MarkDataPool = {}
  self.MarkedMission = {}
  self.todayStealNum = 0
  self.todayAssistNum = 0
  self.actViewOpened = false
  self.openServerList = nil
  self.openTimeStamp = nil
  self.endTimeStamp = nil
  self.dispatchFollowTip = StringPool.New("dispatch_des019;dispatch_des020;dispatch_des021", ";")
  self.stealEmojiList = nil
  self.carPosList = nil
  self.fakeAssistorName = nil
  self.fakeAssistorHeadIcon = nil
  self.hideMainUIRedPoint = nil
  self.heroShowTextList = nil
  self.lastGetAllianceTasksTime = 0
  self.lastGetAllSingleTasksTime = 0
  self.bNeedPlayedSweepEffect = nil
  self.lastGetMarkListTime = 0
  self.getMarkListTimeCd = 5000
  self.starSpriteMap = {}
end

function ActDispatchTaskDataManager:__delete()
  self.singleTask = nil
  self.allianceTask = nil
  self.todayStealNum = nil
  self.todayAssistNum = nil
  self.actViewOpened = nil
  self.openServerList = nil
  self.openTimeStamp = nil
  self.endTimeStamp = nil
  self.stealEmojiList = nil
  self.carPosList = nil
  self.fakeAssistorName = nil
  self.fakeAssistorHeadIcon = nil
  self.hideMainUIRedPoint = nil
  self.heroShowTextList = nil
  self.lastGetAllianceTasksTime = 0
  self.lastGetAllSingleTasksTime = 0
  self.bNeedPlayedSweepEffect = nil
  self.starSpriteMap = nil
  self.recordList = nil
  self.recordTypeList = nil
  self:ClearCompleteTimer()
  self.lastGetMarkListTime = 0
  self.getMarkListTimeCd = 5000
end

function ActDispatchTaskDataManager:GetDispatchSetting(configKey)
  local starLevel = self:GetCurrentStarLevel()
  local itemId = 1000 + starLevel
  local value = GetTableData(TableName.LwDispatchSetting, itemId, configKey)
  if string.IsNullOrEmpty(value) then
    return GetTableData(TableName.LwDispatchSetting, 1001, configKey)
  end
  return value
end

function ActDispatchTaskDataManager:GetTaskRefreshSetting()
  local itemId = toInt(self:GetDispatchSetting("refresh_item"))
  local itemCount = 1
  local coinCount = toInt(self:GetDispatchSetting("refresh_diamond"))
  return coinCount, itemId, itemCount
end

function ActDispatchTaskDataManager:GetTaskSuperRefreshSetting()
  local itemId = toInt(self:GetDispatchSetting("refresh_item"))
  local itemCount = LuaEntry.DataConfig:TryGetNum("dispatchtask_setting", "k5", 1)
  local coinCount = LuaEntry.DataConfig:TryGetNum("dispatchtask_setting", "k4", 100)
  return itemId, itemCount, coinCount
end

function ActDispatchTaskDataManager:CheckSuperRefreshOpen()
  if not CS.CommonUtils.IsDebug() then
    local serverArray = LuaEntry.DataConfig:TryGetStr("dispatchtask_setting", "k8")
    if not string.IsNullOrEmpty(serverArray) then
      if self.openServerList == nil then
        self.openServerList = {}
        local array = string.split(serverArray, ";")
        for _, arr in ipairs(array) do
          local list = string.split(arr, "-")
          if #list == 2 then
            local startServer = tonumber(list[1])
            local endServer = tonumber(list[2])
            for i = startServer, endServer do
              table.insert(self.openServerList, i)
            end
          elseif #list == 1 then
            local server = tonumber(list[1]) or 0
            if 0 < server then
              table.insert(self.openServerList, server)
            end
          end
        end
      end
      local server = LuaEntry.Player:GetSourceServerId()
      if not table.hasvalue(self.openServerList, server) then
        return false
      end
    end
  end
  local openTime = LuaEntry.DataConfig:TryGetStr("dispatchtask_setting", "k9")
  local endTime = LuaEntry.DataConfig:TryGetStr("dispatchtask_setting", "k10")
  if string.IsNullOrEmpty(openTime) or string.IsNullOrEmpty(endTime) then
    return true
  end
  if self.openTimeStamp == nil or self.endTimeStamp == nil then
    local year, month, day, hour, min, sec = string.gmatch(openTime, "(%d+)-(%d+)-(%d+)-(%d+)-(%d+)-(%d+)")()
    local openTimeStamp = SafeLocalOsTime({
      year = year,
      month = month,
      day = day,
      hour = hour,
      min = min,
      sec = sec
    })
    self.openTimeStamp = openTimeStamp * 1000
    year, month, day, hour, min, sec = string.gmatch(endTime, "(%d+)-(%d+)-(%d+)-(%d+)-(%d+)-(%d+)")()
    local endTimeStamp = SafeLocalOsTime({
      year = year,
      month = month,
      day = day,
      hour = hour,
      min = min,
      sec = sec
    })
    self.endTimeStamp = endTimeStamp * 1000
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < self.openTimeStamp or curTime > self.endTimeStamp then
    return false
  end
  return true
end

function ActDispatchTaskDataManager:CheckSuperModeOpen()
  local isOpen = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_DISPATCH_TASK_SUPER_MODE)
  if 0 < isOpen then
    return true
  end
  local mainLevel = LuaEntry.DataConfig:TryGetNum("dispatchtask_setting", "k15", 0)
  local lv = DataCenter.BuildManager.MainLv
  if mainLevel <= lv then
    return true
  end
  return false
end

function ActDispatchTaskDataManager:GetCurrentStarLevel()
  local cityLevel = DataCenter.BuildManager.MainLv
  if self.dispatch_task_k1 == nil then
    local dispatch_task_k1 = LuaEntry.DataConfig:TryGetStr("dispatchtask_setting", "k1", "1;7-12|2;13-17|3;18-22|4;23-26|5;27-30")
    if string.IsNullOrEmpty(dispatch_task_k1) then
      return 0
    end
    self.dispatch_task_k1 = {}
    for item in string.gmatch(dispatch_task_k1, "([^|]+)|?") do
      local starLevelStr, CityLevelStr = string.match(item, "(%d+)[;,](%d+-?%d+)")
      if starLevelStr ~= nil and CityLevelStr ~= nil then
        local starLevel = tonumber(starLevelStr)
        local levelMinStr, levelMaxStr = string.match(CityLevelStr, "(%d+)-(%d+)")
        if levelMinStr ~= nil and levelMaxStr ~= nil then
          local levelMin = tonumber(levelMinStr)
          local levelMax = tonumber(levelMaxStr)
          table.insert(self.dispatch_task_k1, {
            min = levelMin,
            max = levelMax,
            star = starLevel
          })
        else
          local levelMin = toInt(CityLevelStr)
          table.insert(self.dispatch_task_k1, {
            min = levelMin,
            max = levelMin,
            star = starLevel
          })
        end
      end
    end
  end
  for _, v in ipairs(self.dispatch_task_k1) do
    if v.min and v.max and v.star and cityLevel >= v.min and cityLevel <= v.max then
      return v.star
    end
  end
  return 0
end

function ActDispatchTaskDataManager:CheckShowDispatchTaskStarTip()
  local starLevel = self:GetCurrentStarLevel()
  local showTip = true
  local maxLv = self:GetMaxStarAndIndex()
  if starLevel < 1 or starLevel >= maxLv then
    showTip = false
  end
  return showTip
end

function ActDispatchTaskDataManager:GetMaxStarAndIndex()
  local maxLv = 5
  local nowIndex
  local seaonCfg = LuaEntry.DataConfig:TryGetStr("dispatchtask_setting", "k19")
  if not string.IsNullOrEmpty(seaonCfg) then
    if self.dispatch_task_k19 == nil then
      self.dispatch_task_k19 = {}
      self.dispatch_task_k19 = string.string2array_s(seaonCfg, "|", ";")
    end
    local nowSeason, day = DataCenter.SeasonDataManager:GetNowSeasonAndSeasonDay()
    for index, value in ipairs(self.dispatch_task_k19) do
      if nowSeason > tonumber(value[1]) or nowSeason == tonumber(value[1]) and day >= tonumber(value[2]) and maxLv < tonumber(value[3]) then
        maxLv = tonumber(value[3])
        nowIndex = index
      end
    end
  end
  return maxLv, nowIndex
end

function ActDispatchTaskDataManager:GetRuleStr()
  local ruleStr
  local maxLv, index = self:GetMaxStarAndIndex()
  if 5 < maxLv and index then
    if self.dispatch_task_k21 == nil then
      self.dispatch_task_k21 = {}
      local cfg = LuaEntry.DataConfig:TryGetStr("dispatchtask_setting", "k21")
      if cfg then
        self.dispatch_task_k21 = string.split(cfg, ";")
      end
    end
    ruleStr = self.dispatch_task_k21[index]
  end
  return ruleStr
end

function ActDispatchTaskDataManager:GetStarSprites(starLevel)
  local sprites = self.starSpriteMap[starLevel]
  if sprites ~= nil then
    return sprites
  end
  sprites = {}
  if starLevel <= 5 then
    for i = 1, starLevel do
      table.insert(sprites, starImgPath[1])
    end
  else
    local num = starLevel % 5
    for i = 1, 5 do
      if i <= num then
        table.insert(sprites, starImgPath[2])
      else
        table.insert(sprites, starImgPath[1])
      end
    end
  end
  self.starSpriteMap[starLevel] = sprites
  return sprites
end

function ActDispatchTaskDataManager:TriggerPlot()
  local maxLv, index = self:GetMaxStarAndIndex()
  if 5 < maxLv and index then
    if self.dispatch_task_k20 == nil then
      self.dispatch_task_k20 = {}
      local cfg = LuaEntry.DataConfig:TryGetStr("dispatchtask_setting", "k20")
      if cfg then
        self.dispatch_task_k20 = string.string2array_s(cfg, "|", ";")
      end
    end
    local guideIndex = CommonUtil.PlayerPrefsGetInt(SettingKeys.DISPATCH_NEW_GUIDE_INDEX, 0)
    if index > guideIndex then
      self.guideTaskId = tonumber(self.dispatch_task_k20[index][1])
      self.plotGroupId = tonumber(self.dispatch_task_k20[index][2])
      if self.singleTask then
        for key, value in pairs(self.singleTask) do
          if value.cfgId == self.guideTaskId then
            CommonUtil.PlayerPrefsSetInt(SettingKeys.DISPATCH_NEW_GUIDE_INDEX, index)
            EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {
              plotGroupId = self.plotGroupId,
              hideMainUI = false
            })
            break
          end
        end
      end
    end
  end
end

function ActDispatchTaskDataManager:FinishPlot()
  self.plotGroupId = nil
  self.guideTaskId = nil
end

function ActDispatchTaskDataManager:GetTaskRateWithStarLevel(starLevel)
  if self.dispatch_task_k2 then
    return self.dispatch_task_k2[tostring(starLevel)]
  end
  local dispatch_task_k2 = LuaEntry.DataConfig:TryGetStr("dispatchtask_setting", "k2", "1;0.1|2;0.2|3;0.3|4;0.4|5;0.5")
  if string.IsNullOrEmpty(dispatch_task_k2) then
    return 0
  end
  self.dispatch_task_k2 = {}
  for item in string.gmatch(dispatch_task_k2, "([^|]+)|?") do
    local starLevelStr, ValueStr = string.match(item, "(%d+)[;,](.*)")
    if starLevelStr ~= nil and ValueStr ~= nil then
      self.dispatch_task_k2[starLevelStr] = ValueStr
    end
  end
  return self.dispatch_task_k2[tostring(starLevel)]
end

function ActDispatchTaskDataManager:GetTaskLevelWithStarLevel(starLevel)
  if self.dispatch_task_k3 then
    return self.dispatch_task_k3[tostring(starLevel)]
  end
  local dispatch_task_k3 = LuaEntry.DataConfig:TryGetStr("dispatchtask_setting", "k3", "1;1|2;2|3;3|4;4|5;5")
  if string.IsNullOrEmpty(dispatch_task_k3) then
    return 0
  end
  self.dispatch_task_k3 = {}
  for item in string.gmatch(dispatch_task_k3, "([^|]+)|?") do
    local starLevelStr, ValueStr = string.match(item, "(%d+)[;,](%d+)")
    if starLevelStr ~= nil and ValueStr ~= nil then
      self.dispatch_task_k3[starLevelStr] = tonumber(ValueStr)
    end
  end
  return self.dispatch_task_k3[tostring(starLevel)]
end

function ActDispatchTaskDataManager:GetMinLevelForStarLevel(starLevel)
  if self.dispatch_task_k1 then
    for _, v in ipairs(self.dispatch_task_k1) do
      if v.star == starLevel then
        return v.min
      end
    end
  end
  return 1
end

function ActDispatchTaskDataManager:GetAllSingleTasksFromServer(force)
  local isOpen = DataCenter.ActivityListDataManager:CheckIfActivityOpen(EnumActivity.DispatchTask.Type)
  if isOpen == true then
    local cur = Time.realtimeSinceStartup
    if force or cur - self.lastGetAllSingleTasksTime > GetAllSingleTaskInterval then
      self.lastGetAllSingleTasksTime = cur
      SFSNetwork.SendMessage(MsgDefines.DispatchGetTasks)
    end
  end
end

function ActDispatchTaskDataManager:UpdateAllSingleTasks(message)
  if self.singleTask == nil then
    self.singleTask = {}
  else
    table.clear(self.singleTask)
  end
  if message.ls ~= nil then
    for _, v in ipairs(message.ls) do
      self:UpdateOneSingleTask(v, false)
    end
    EventManager:GetInstance():Broadcast(EventId.DispatchTaskUpdateAll)
  end
  self:UpdateTodayNum(message)
  if message.gold then
    LuaEntry.Player.gold = message.gold
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
end

function ActDispatchTaskDataManager:UpdateFollowCount(message)
  local uuid = message.uuid
  local followCount = message.followCount
  if uuid and followCount then
    local taskInfo = self.singleTask[uuid]
    if taskInfo then
      taskInfo.followCount = followCount
      EventManager:GetInstance():Broadcast(EventId.DispatchTaskUpdateFollowCount, uuid)
    end
  end
end

function ActDispatchTaskDataManager:UpdateTodayNum(message)
  local update = false
  if message.todayStealNum then
    update = true
    self.todayStealNum = message.todayStealNum
  end
  if message.todayAssistNum then
    update = true
    self.todayAssistNum = message.todayAssistNum
  end
  if update == true then
    EventManager:GetInstance():Broadcast(EventId.DispatchTaskTodayNumUpdate)
  end
end

function ActDispatchTaskDataManager:GetTodayStealNum()
  return self.todayStealNum
end

function ActDispatchTaskDataManager:GetTodayAssistNum()
  return self.todayAssistNum
end

function ActDispatchTaskDataManager:GetAllAllianceTasksFromServer()
  if string.IsNullOrEmpty(LuaEntry.Player.allianceId) then
    return
  end
  local isOpen = DataCenter.ActivityListDataManager:CheckIfActivityOpen(EnumActivity.DispatchTask.Type)
  if isOpen == true then
    local cur = Time.realtimeSinceStartup
    if cur - self.lastGetAllianceTasksTime > GetAllianceTaskInterval then
      self.lastGetAllianceTasksTime = cur
      SFSNetwork.SendMessage(MsgDefines.DispatchGetAllianceTasks)
    end
  end
end

function ActDispatchTaskDataManager:UpdateAllAllianceTasks(tasks)
  self.allianceTask = {}
  if tasks ~= nil then
    for _, v in ipairs(tasks) do
      self:UpdateOneAllianceTask(v, false)
    end
    DataCenter.ActDispatchTaskFakeMarchManager:RemoveAllDisappearEvent()
    EventManager:GetInstance():Broadcast(EventId.DispatchTaskUpdateAlliance)
  end
end

local function SortTasks(taskA, taskB)
  if taskA and not taskB then
    return false
  end
  if not taskA and taskB then
    return true
  end
  local completionTimeA = taskA.completionTime
  local completionTimeB = taskB.completionTime
  local now = UITimeManager:GetInstance():GetServerTime()
  local statusA = 2
  if taskA.rewarded == 1 then
    statusA = 4
  elseif 0 < completionTimeA then
    if completionTimeA <= now and taskA.rewarded == 0 then
      statusA = 1
    elseif completionTimeA > now then
      statusA = 3
    end
  end
  local statusB = 2
  if taskB.rewarded == 1 then
    statusB = 4
  elseif 0 < completionTimeB then
    if completionTimeB <= now and taskB.rewarded == 0 then
      statusB = 1
    elseif completionTimeB > now then
      statusB = 3
    end
  end
  if statusA ~= statusB then
    return statusA < statusB
  end
  local isSpecialA = taskA.cfg.is_special
  local isSpecialB = taskB.cfg.is_special
  if isSpecialA ~= isSpecialB then
    return isSpecialA > isSpecialB
  end
  local colorA = taskA.cfg.color
  local colorB = taskB.cfg.color
  if colorA ~= colorB then
    return colorA > colorB
  end
  local starA = taskA.cfg.task_star
  local starB = taskB.cfg.task_star
  if starA ~= starB then
    return starA > starB
  end
  return completionTimeA < completionTimeB
end

function ActDispatchTaskDataManager:GetAllSingleTasks()
  local tasks = table.values(self.singleTask)
  table.sort(tasks, SortTasks)
  return tasks
end

function ActDispatchTaskDataManager:GetAllAllianceTasks()
  local tasks = table.values(self.allianceTask)
  table.sort(tasks, SortTasks)
  return tasks
end

function ActDispatchTaskDataManager:GetAllianceAssisTaskCount()
  if self.allianceTask then
    local ret = 0
    local now = UITimeManager:GetInstance():GetServerTime()
    for _, task in pairs(self.allianceTask) do
      local completionTime = task.completionTime
      if 0 < completionTime and now > completionTime and task.rewarded ~= 1 then
        ret = ret + 1
      end
    end
    return ret
  end
  return 0
end

function ActDispatchTaskDataManager:UpdateOneSingleTask(taskInfo, needBroadcast)
  if taskInfo ~= nil then
    local uuid = taskInfo.uuid
    taskInfo.cfg = LocalController:instance():getLine(TableName.LwDispatchTask, taskInfo.cfgId)
    if taskInfo.cfg == nil then
      Logger.LogError("lw_dispatch_tasks \232\161\168\230\178\161\230\156\137\228\187\187\229\138\161id=" .. taskInfo.cfgId)
    end
    local oldInfo = self.singleTask[uuid]
    if oldInfo then
      table.clear(oldInfo)
      for i, v in pairs(taskInfo) do
        oldInfo[i] = v
      end
    else
      self.singleTask[uuid] = taskInfo
    end
    if needBroadcast == nil or needBroadcast == true then
      DataCenter.ActDispatchTaskFakeMarchManager:RemoveAllDisappearEvent()
      EventManager:GetInstance():Broadcast(EventId.DispatchTaskUpdateSingle)
    end
    self:RefreshCompleteTimer()
  end
end

function ActDispatchTaskDataManager:UpdateOneAllianceTask(taskInfo, needBroadcast)
  if taskInfo ~= nil then
    local uuid = taskInfo.uuid
    taskInfo.cfg = LocalController:instance():getLine(TableName.LwDispatchTask, taskInfo.cfgId)
    if taskInfo.cfg == nil then
      Logger.LogError("lw_dispatch_tasks \232\161\168\230\178\161\230\156\137\228\187\187\229\138\161id=" .. taskInfo.cfgId)
    end
    self.allianceTask[uuid] = taskInfo
    if needBroadcast == nil or needBroadcast == true then
      EventManager:GetInstance():Broadcast(EventId.DispatchTaskUpdateAlliance)
    end
  end
end

function ActDispatchTaskDataManager:DeleteSingleTasks(taskIdsArr)
  if taskIdsArr then
    for _, v in ipairs(taskIdsArr) do
      self.singleTask[v] = nil
    end
    DataCenter.ActDispatchTaskFakeMarchManager:RemoveAllDisappearEvent()
    EventManager:GetInstance():Broadcast(EventId.DispatchTaskUpdateSingle)
  end
end

function ActDispatchTaskDataManager:DeleteAllianceTasks(taskIdsArr)
  if taskIdsArr then
    for _, v in ipairs(taskIdsArr) do
      self.allianceTask[v] = nil
    end
    EventManager:GetInstance():Broadcast(EventId.DispatchTaskDeleteAllianceItem)
  end
end

function ActDispatchTaskDataManager:GetSingleTaskByPointId(pointId)
  for _, v in pairs(self.singleTask) do
    if v.pointId == pointId then
      return v
    end
  end
  return nil
end

function ActDispatchTaskDataManager:GetSingleTaskByUuid(uuid)
  return self.singleTask[uuid]
end

function ActDispatchTaskDataManager:IsSingleTaskDispatched(taskInfo)
  return taskInfo ~= nil and checknumber(taskInfo.completionTime) > 0
end

function ActDispatchTaskDataManager:IsAllSingleTaskDispatched()
  for _, taskInfo in pairs(self.singleTask or {}) do
    if not self:IsSingleTaskDispatched(taskInfo) then
      return false
    end
  end
  return true
end

function ActDispatchTaskDataManager:ParseTaskCondition(taskInfo)
  if taskInfo and taskInfo.cfg and not taskInfo.cfg.parsed_conditions then
    taskInfo.cfg.parsed_conditions = {}
    for _, v in ipairs(taskInfo.cfg.conditions) do
      local type, value, num = string.match(v, "(%d+)[;](%d+)[;](%d+)")
      local oneCondArr = {
        tonumber(value),
        tonumber(num)
      }
      taskInfo.cfg.parsed_conditions[tonumber(type)] = oneCondArr
    end
  end
end

function ActDispatchTaskDataManager:GetAllUsedHeroList()
  local ret = {}
  for k, v in pairs(self.singleTask) do
    if v.completionTime > 0 and v.rewarded == 0 then
      table.insertto(ret, v.heroList)
    end
  end
  return ret
end

function ActDispatchTaskDataManager:GetAllLogList()
  if self.recordList then
    table.sort(self.recordList, function(a, b)
      return a.time > b.time
    end)
    return self.recordList
  end
  return {}
end

function ActDispatchTaskDataManager:HandleRecord(message)
  if not self.recordTypeList then
    self.recordTypeList = {}
  end
  if message.array then
    if message.type == DispatchTaskRecordType.All then
      self.recordList = message.array
    else
      if message.type then
        self.recordTypeList[message.type] = message.array
      end
      EventManager:GetInstance():Broadcast(EventId.DispatchTaskGetNewRecord, message.type)
    end
  elseif message.type then
    if message.type == DispatchTaskRecordType.All then
      self.recordList = {}
    else
      self.recordTypeList[message.type] = {}
      EventManager:GetInstance():Broadcast(EventId.DispatchTaskGetNewRecord, message.type)
    end
  end
  if message.type == nil or message.type == DispatchTaskRecordType.All or message.type == DispatchTaskRecordType.Assist then
    EventManager:GetInstance():Broadcast(EventId.DispatchTaskGetRecord)
  end
end

function ActDispatchTaskDataManager:UpdateRecordList(type, uuid)
  if self.recordTypeList and not table.IsNullOrEmpty(self.recordTypeList[type]) then
    for key, value in ipairs(self.recordTypeList[type]) do
      if value.uuid == uuid then
        value.isLike = 1
        break
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.DispatchTaskGetThumbsUp, uuid)
end

function ActDispatchTaskDataManager:GetTypeRecordList(recordType)
  if not table.IsNullOrEmpty(self.recordTypeList) then
    if type(self.recordTypeList[recordType]) == "table" and #self.recordTypeList[recordType] > 1 then
      table.sort(self.recordTypeList[recordType], function(a, b)
        local ta = a and a.time or 0
        local tb = b and b.time or 0
        return ta > tb
      end)
    end
    return self.recordTypeList[recordType]
  end
  return nil
end

function ActDispatchTaskDataManager:GetNeedThumbsUpList(allList)
  local t = {}
  local playerUid = LuaEntry.Player:GetUid()
  for _, v in ipairs(allList or {}) do
    if v.type == "report" and v.value.isLike == 0 and v.value.type == 0 and v.value.uid ~= playerUid then
      t[#t + 1] = v
    end
  end
  return t
end

function ActDispatchTaskDataManager:GetSingleTaskRedCount()
  local rewardCount = 0
  local tipCount = 0
  if self.actViewOpened == false then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    for _, v in pairs(self.singleTask) do
      if v.completionTime ~= nil then
        if v.completionTime == 0 then
          tipCount = tipCount + 1
        elseif curTime >= v.completionTime and v.rewarded == 0 then
          rewardCount = rewardCount + 1
        end
      end
    end
  end
  return rewardCount + tipCount, rewardCount, tipCount
end

function ActDispatchTaskDataManager:GetSingleTaskNormalCount()
  local ret = 0
  local rewardableCount = 0
  local curTime = UITimeManager:GetInstance():GetServerTime()
  for _, v in pairs(self.singleTask) do
    if v.completionTime == 0 then
      ret = ret + 1
    elseif 0 < v.completionTime and curTime >= v.completionTime and v.rewarded == 0 then
      rewardableCount = rewardableCount + 1
    end
  end
  return ret, rewardableCount
end

function ActDispatchTaskDataManager:GetSingleTaskRewardableCount()
  local ret = 0
  local curTime = UITimeManager:GetInstance():GetServerTime()
  for _, v in pairs(self.singleTask) do
    if 0 < v.completionTime and curTime >= v.completionTime and v.rewarded == 0 then
      ret = ret + 1
    end
  end
  return ret
end

function ActDispatchTaskDataManager:GetSingleTaskRewardableList()
  local ret = {}
  local curTime = UITimeManager:GetInstance():GetServerTime()
  for _, v in pairs(self.singleTask) do
    if v.completionTime > 0 and curTime >= v.completionTime and v.rewarded == 0 then
      table.insert(ret, v)
    end
  end
  return ret
end

function ActDispatchTaskDataManager:GetSingleTaskAssist()
  local ret = {}
  local curTime = UITimeManager:GetInstance():GetServerTime()
  for _, v in pairs(self.singleTask) do
    if v.completionTime > 0 and curTime >= v.completionTime and v.rewarded == 0 and v.assistInfo and v.assistInfo.uid then
      ret[v.uuid] = v
    end
  end
  return ret
end

function ActDispatchTaskDataManager:SetActViewOpened(open)
  if self.actViewOpened ~= open then
    self.actViewOpened = open
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

function ActDispatchTaskDataManager:GetSingleTaskIngCount()
  local ret = 0
  for _, v in pairs(self.singleTask) do
    if 0 < v.completionTime and v.rewarded == 0 then
      ret = ret + 1
    end
  end
  return ret
end

function ActDispatchTaskDataManager:AddFollowCount(uuid)
  if uuid then
    SFSNetwork.SendMessage(MsgDefines.DispatchAddFollowCount, uuid, LuaEntry.Player:GetCurServerId())
  end
end

function ActDispatchTaskDataManager:GetRandomFollowTip()
  return self.dispatchFollowTip:GetRandom()
end

function ActDispatchTaskDataManager:ShowReward(message)
  if message.reward ~= nil then
    local list = {}
    list = DataCenter.RewardManager:ReturnRewardParamForMessage(message.reward) or {}
    table.sort(list, function(a, b)
      if a.rewardType ~= b.rewardType then
        return a.rewardType == RewardType.HERO and true or false
      else
        return a.sortOrder < b.sortOrder
      end
    end)
    local golloesList = DataCenter.RewardManager:GetGolloesRewards(message)
    for i, v in ipairs(golloesList) do
      table.insert(list, v)
    end
    local param = {}
    param.rewardList = list
    param.data = message.data
    if message.ownerInfo and (message.fromDispatchStealMessage or message.fromDispatchAssistMessage) then
      param.fromDispatchStealMessage = message.fromDispatchStealMessage
      param.fromDispatchAssistMessage = message.fromDispatchAssistMessage
      param.ownerInfo = message.ownerInfo
      param.recordUuid = message.recordUuid
    end
    if message.completeByHelper then
      param.completeByHelper = message.completeByHelper
    end
    param.targetServer = message.targetServer
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Ue_GetReward, false)
    
    local function openRewardWindow()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIDispatchTaskReward, {
        anim = true,
        playEffect = false,
        UIMainAnim = UIMainAnimType.LeftRightBottomHide
      }, param)
    end
    
    if not table.IsNullOrEmpty(list) then
      for i, v in pairs(list) do
        if v and v.rewardType == RewardType.HERO and v.heroUuid and DataCenter.HeroDataManager:NeedShowNewHeroWindow(v.heroUuid) then
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroExhibitPanel, {anim = false}, v.heroUuid, {
            v.heroUuid
          }, openRewardWindow, true)
          return
        end
      end
    end
    openRewardWindow()
  end
end

function ActDispatchTaskDataManager:ShowBatchReward(message)
  if message.array then
    local rewardList = {}
    local stealInfoList = {}
    local assistInfoList = {}
    local rewardMap = {}
    local sortOrder = 0
    for _, one in ipairs(message.array) do
      if one then
        if one.reward then
          local list = DataCenter.RewardManager:ReturnRewardParamForMessage(one.reward)
          if list and 0 < #list then
            for _, item in ipairs(list) do
              local type = item.rewardType
              local itemId = tonumber(item.itemId) or 0
              local typeMap = rewardMap[type]
              if typeMap == nil then
                typeMap = {}
                rewardMap[type] = typeMap
              end
              local data = typeMap[itemId]
              if data then
                if data.count then
                  data.count = data.count + item.count
                end
              else
                typeMap[itemId] = item
                item.sortOrder = sortOrder
                sortOrder = sortOrder + 1
                table.insert(rewardList, item)
              end
            end
          end
        end
        local data = one.data
        if data then
          local stealList = data.stealInfoList
          local assistInfo = data.assistInfo
          if stealList and 0 < #stealList then
            table.insertto(stealInfoList, stealList)
          end
          if assistInfo and assistInfo.uid then
            table.insert(assistInfoList, assistInfo)
          end
        end
      end
    end
    local param = {}
    param.rewardList = rewardList
    param.data = {}
    param.data.stealInfoList = stealInfoList
    param.data.assistInfoList = assistInfoList
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Ue_GetReward, false)
    
    local function openRewardWindow()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIDispatchTaskReward, {
        anim = true,
        playEffect = false,
        UIMainAnim = UIMainAnimType.LeftRightBottomHide
      }, param)
    end
    
    if not table.IsNullOrEmpty(rewardList) then
      for i, v in pairs(rewardList) do
        if v and v.rewardType == RewardType.HERO and v.heroUuid and DataCenter.HeroDataManager:NeedShowNewHeroWindow(v.heroUuid) then
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroExhibitPanel, {anim = false}, v.heroUuid, {
            v.heroUuid
          }, openRewardWindow, true)
          return
        end
      end
    end
    openRewardWindow()
  end
end

function ActDispatchTaskDataManager:GetStealEmojiList(rand)
  if self.stealEmojiList == nil then
    self.stealEmojiList = {}
    local emojiArray = LuaEntry.DataConfig:TryGetStr("dispatchtask_setting", "k6")
    if not string.IsNullOrEmpty(emojiArray) then
      local emojiList = string.split(emojiArray, ";")
      for _, emojiId in ipairs(emojiList) do
        local data = LocalController:instance():getLine(TableName.LW_EMOJI, emojiId)
        if data then
          table.insert(self.stealEmojiList, data)
        end
      end
    end
  end
  if rand then
    local count = #self.stealEmojiList
    if 4 < count then
      for i = 1, 4 do
        local random = math.random(5, count)
        local tmp = self.stealEmojiList[i]
        self.stealEmojiList[i] = self.stealEmojiList[random]
        self.stealEmojiList[random] = tmp
      end
    end
  end
  return self.stealEmojiList
end

function ActDispatchTaskDataManager:GetUnlockMonopolyId()
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(BuildingTypes.LW_BUILD_DISPATCH_TASK, 0)
  if buildTemplate then
    return buildTemplate.mono_condition or 0
  end
end

function ActDispatchTaskDataManager:CheckUnlock()
  if DataCenter.MonopolyManager.player == nil then
    return false
  end
  local currStageId = DataCenter.MonopolyManager.player.curId
  local unlockMonopolyId = self:GetUnlockMonopolyId()
  return toInt(currStageId) > toInt(unlockMonopolyId)
end

function ActDispatchTaskDataManager:Unlock()
  DataCenter.BuildBubbleManager:OnRefreshDispatchTaskBubble()
end

function ActDispatchTaskDataManager:OnBuildBubbleClick()
  if not LuaEntry.Player:AtHomeNow() and not DataCenter.ActDispatchTaskDataManager:IsOpenCrossSteal() then
    EventManager:GetInstance():Broadcast(EventId.ShowCrossServerBubbleTips, 500021)
    return
  end
  local normalCount, rewardableCount = self:GetSingleTaskNormalCount()
  if 0 < rewardableCount then
    DataCenter.ActDispatchTaskDataManager:TryRewardAll()
  elseif 0 < normalCount then
  end
  local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.DispatchTask.Type)
  if actList and 0 < #actList then
    local actId = tonumber(actList[1].id)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDispatchTaskMain, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, actId)
  else
    UIUtil.ShowTipsId(801141)
  end
end

function ActDispatchTaskDataManager:GetCarPosList()
  if self.carPosList == nil then
    self.carPosList = {}
    local posArray = LuaEntry.DataConfig:TryGetStr("dispatchtask_setting", "k12")
    if not string.IsNullOrEmpty(posArray) then
      local posList = string.split(posArray, ";")
      for _, data in ipairs(posList) do
        local xz = string.split(data, ",")
        if #xz == 2 then
          local pos = Vector3.New(tonumber(xz[1]), 0, tonumber(xz[2]))
          table.insert(self.carPosList, pos)
        end
      end
    end
  end
  return self.carPosList
end

function ActDispatchTaskDataManager:GetAssistorName()
  if self.fakeAssistorName == nil then
    local name = LuaEntry.DataConfig:TryGetStr("dispatchtask_setting", "k13")
    self.fakeAssistorName = name
  end
  return self.fakeAssistorName
end

function ActDispatchTaskDataManager:GetAssistorHeadIcon()
  if self.fakeAssistorHeadIcon == nil then
    local icon = LuaEntry.DataConfig:TryGetStr("dispatchtask_setting", "k14")
    self.fakeAssistorHeadIcon = icon
  end
  return self.fakeAssistorHeadIcon
end

function ActDispatchTaskDataManager:TryRewardAll()
  local list = self:GetSingleTaskRewardableList()
  if #list == 1 then
    local info = list[1]
    if info then
      SFSNetwork.SendMessage(MsgDefines.DispatchReward, info.uuid)
    end
    return
  end
  local idList = {}
  for _, v in ipairs(list) do
    if v.uuid then
      table.insert(idList, v.uuid)
    end
  end
  SFSNetwork.SendMessage(MsgDefines.DispatchBatchReward, idList)
end

function ActDispatchTaskDataManager:GetMainUIRedPointShow()
  return not self.hideMainUIRedPoint
end

function ActDispatchTaskDataManager:HideMainUIRedPoint()
  self.hideMainUIRedPoint = true
end

function ActDispatchTaskDataManager:GetRandomHeroShowText()
  if self.heroShowTextList == nil then
    self.heroShowTextList = {}
    local textArray = LuaEntry.DataConfig:TryGetStr("dispatchtask_setting", "k16")
    if not string.IsNullOrEmpty(textArray) then
      local array = string.split(textArray, ";")
      for _, v in ipairs(array) do
        if not string.IsNullOrEmpty(v) then
          table.insert(self.heroShowTextList, v)
        end
      end
    end
  end
  local count = #self.heroShowTextList
  if count < 0 then
    return nil, nil, nil
  end
  local index = math.random(1, count)
  local text1 = self.heroShowTextList[index]
  local last = self.heroShowTextList[count]
  self.heroShowTextList[index] = last
  self.heroShowTextList[count] = text1
  count = count - 1
  if count < 0 then
    return text1, nil, nil
  end
  index = math.random(1, count)
  local text2 = self.heroShowTextList[index]
  last = self.heroShowTextList[count]
  self.heroShowTextList[index] = last
  self.heroShowTextList[count] = text2
  count = count - 1
  if count < 0 then
    return text1, text2, nil
  end
  index = math.random(1, count)
  local text3 = self.heroShowTextList[index]
  return text1, text2, text3
end

function ActDispatchTaskDataManager:RefreshCompleteTimer()
  self:ClearCompleteTimer()
  local has = false
  local time = math.maxinteger
  local curTime = UITimeManager:GetInstance():GetServerTime()
  for _, v in pairs(self.singleTask) do
    if v.completionTime > 0 and curTime < v.completionTime and v.rewarded == 0 then
      local diff = v.completionTime - curTime
      if time > diff then
        has = true
        time = diff
      end
    end
  end
  if has and 0 < time then
    time = math.ceil(time / 1000)
    self.completeDelay = TimerManager:GetInstance():DelayInvoke(function()
      self.completeDelay = nil
      EventManager:GetInstance():Broadcast(EventId.DispatchTaskCompleteRefresh)
      DataCenter.ActDispatchTaskDataManager:RefreshCompleteTimer()
    end, time)
  end
end

function ActDispatchTaskDataManager:ClearCompleteTimer()
  if self.completeDelay then
    self.completeDelay:Stop()
    self.completeDelay = nil
  end
end

function ActDispatchTaskDataManager:GetMaxMarch()
  local list = DataCenter.ArmyFormationDataManager:GetArmyFormationIdList()
  local maxMarch = tonumber(self:GetDispatchSetting("max_taskqueue"))
  if list ~= nil then
    maxMarch = maxMarch * #list
  end
  local buildAddNum = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_DISPATCH_TASK_ADD_SEQ)
  maxMarch = maxMarch + buildAddNum
  return maxMarch
end

function ActDispatchTaskDataManager:GetBuildAddRewardInfo()
  local buildAddNum = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_DISPATCH_TASK_ADD_BOX)
  local itemId = LuaEntry.DataConfig:TryGetNum("lw_dispatch_good_up", "k1")
  return buildAddNum, itemId
end

function ActDispatchTaskDataManager:GetProtectName()
  return "????????"
end

function ActDispatchTaskDataManager:PushHeroDispatchMissionStealHandler(msg)
  if CS.SceneManager.World == nil then
    return
  end
  if msg.playerInfo and msg.pointId then
    local emojiList = self:GetStealEmojiList(true)
    local data = emojiList[1]
    UIUtil.ShowThumbsUpBroadcastPopUI(msg.serverId, msg.pointId, msg.playerInfo, ":", "Assets/Main/Sprites/UI/LWChatEmoji/Default/" .. data.path .. ".png", "Assets/Main/Prefabs/UI/LWPlayerInfo/DispatchStealMessageTip.prefab")
  end
end

function ActDispatchTaskDataManager:IsOpenCrossSteal()
  local cfg = LuaEntry.DataConfig:TryGetNum("dispatchtask_setting", "k18")
  local isOpen = false
  if cfg ~= 0 then
    local checkServerOpenTime = LuaEntry.Player:GetCheckServerOpenTime()
    if checkServerOpenTime ~= 0 and cfg <= UITimeManager:GetInstance():GetServerOpenDaysByTimeStamp(checkServerOpenTime) then
      isOpen = true
    end
  end
  return isOpen
end

function ActDispatchTaskDataManager:GetNeedPlayedSweepEffect()
  return self.bNeedPlayedSweepEffect
end

function ActDispatchTaskDataManager:SetNeedPlayedSweepEffect(bIsNeed)
  self.bNeedPlayedSweepEffect = bIsNeed
end

function ActDispatchTaskDataManager:IsCrossServerSwitchOpen()
  local cfg = LuaEntry.DataConfig:TryGetNum("dispatchtask_setting", "k18")
  local isOpen = false
  if cfg ~= 0 then
    local checkServerOpenTime = LuaEntry.Player:GetCheckServerOpenTime()
    local isCrossServerSwitchOpen = LuaEntry.DataConfig:CheckSwitch("hidden_cross_server")
    if checkServerOpenTime ~= 0 and cfg <= UITimeManager:GetInstance():GetServerOpenDaysByTimeStamp(checkServerOpenTime) and isCrossServerSwitchOpen then
      isOpen = true
    end
  end
  return isOpen
end

local function GetNeedLvByBuildId(buildId)
  local needLv = 0
  local template = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, 1)
  if template then
    local preBuild = template:GetPreBuild()
    if preBuild and preBuild[1] and preBuild[1].level then
      needLv = preBuild[1].level
    end
  end
  return needLv
end

function ActDispatchTaskDataManager:GetParkNeedLv(index)
  local needLv = 0
  if index == 2 then
    if self.park2NeedLv == nil then
      self.park2NeedLv = GetNeedLvByBuildId(BuildingTypes.LW_BUILD_PARKINGLOT_TWO)
    end
    needLv = self.park2NeedLv
  elseif index == 3 then
    if self.park3NeedLv == nil then
      self.park3NeedLv = GetNeedLvByBuildId(BuildingTypes.LW_BUILD_PARKINGLOT_THREE)
    end
    needLv = self.park3NeedLv
  end
  return needLv
end

function ActDispatchTaskDataManager:ShowMarchLimitTip()
  local tipStr
  for i = 2, 4 do
    if not DataCenter.ArmyFormationDataManager:HasArmyFormationInIndex(i, true) then
      if i < 4 then
        do
          local needLv = self:GetParkNeedLv(i)
          tipStr = Localization:GetString("dispatch_march_full_1", needLv, i)
        end
        break
      end
      tipStr = Localization:GetString("dispatch_march_full_2")
      break
    end
  end
  if tipStr == nil then
    tipStr = Localization:GetString("dispatch_march_full_3")
  end
  UIUtil.ShowTips(tipStr)
end

function ActDispatchTaskDataManager:IsMarkFuncOpen()
  local isOpen = LuaEntry.DataConfig:CheckSwitch("dispatchtask_quick_mark_switch")
  if not isOpen then
    return false
  end
  return FunctionSeasonUtil.IsFuncOpen(FunctionSeasonUtil.FuncType.DispatchTaskMark)
end

function ActDispatchTaskDataManager:SendGetMarkList(force)
  if not LuaEntry.Player:IsInAlliance() then
    return
  end
  local isOpen = DataCenter.ActivityListDataManager:CheckIfActivityOpen(EnumActivity.DispatchTask.Type)
  if not isOpen then
    return
  end
  if not self:IsMarkFuncOpen() then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if not force and now - checknumber(self.lastGetMarkListTime) < self.getMarkListTimeCd then
    return
  end
  self.lastGetMarkListTime = now
  SFSNetwork.SendMessage(MsgDefines.GetAllianceShareMissionList)
end

function ActDispatchTaskDataManager:RecycleOneMark(markData)
  if markData == nil then
    return
  end
  markData:Reset()
  table.insert(self.MarkDataPool, markData)
end

function ActDispatchTaskDataManager:RecycleMarkDataList()
  if table.IsNullOrEmpty(self.MarkDataMap) then
    return
  end
  for _, markData in pairs(self.MarkDataMap) do
    self:RecycleOneMark(markData)
  end
end

function ActDispatchTaskDataManager:GetOrCreateMarkData()
  local markData
  if table.IsNullOrEmpty(self.MarkDataPool) then
    markData = DispatchTaskMarkData.New()
  else
    markData = table.remove(self.MarkDataPool)
  end
  return markData
end

function ActDispatchTaskDataManager:OnGetMarkListCallback(payload)
  if payload == nil then
    return
  end
  if payload.allianceId ~= LuaEntry.Player.allianceId then
    return
  end
  local arr = payload.shareMissionArr
  self:RecycleMarkDataList(self.MarkDataMap)
  self.MarkDataMap = {}
  self.MarkedMission = {}
  if not table.IsNullOrEmpty(arr) then
    for _, mark in pairs(arr) do
      if mark ~= nil and mark.serverPoint ~= nil then
        local markData = self:GetOrCreateMarkData()
        markData:Init(mark)
        self.MarkDataMap[mark.uuid] = markData
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.DispatchTaskGetMarkList)
end

function ActDispatchTaskDataManager:GetMarkList()
  local function sortMarkList(markA, markB)
    return markA:CompareTo(markB)
  end
  
  if not table.IsNullOrEmpty(self.MarkDataMap) then
    local markDataList = {}
    for _, markData in pairs(self.MarkDataMap) do
      if markData:CanShowInList() then
        table.insert(markDataList, markData)
      end
    end
    table.sort(markDataList, sortMarkList)
    return markDataList
  end
  return {}
end

function ActDispatchTaskDataManager:GetOneMark(uuid)
  if not table.IsNullOrEmpty(self.MarkDataMap) then
    return self.MarkDataMap[uuid]
  end
  return nil
end

function ActDispatchTaskDataManager:GetOneMarkByMissionUuid(missionUuid)
  if not table.IsNullOrEmpty(self.MarkDataMap) then
    for _, markData in pairs(self.MarkDataMap) do
      if markData:GetMissionUuid() == missionUuid then
        return markData
      end
    end
  end
  return nil
end

function ActDispatchTaskDataManager:UpdateSteal(missionUuid)
  local markData = self:GetOneMarkByMissionUuid(missionUuid)
  if markData == nil then
    return
  end
  markData:UpdateSteal()
end

function ActDispatchTaskDataManager:RemoveOneMark(uuid)
  if not table.IsNullOrEmpty(self.MarkDataMap) and table.containsKey(self.MarkDataMap, uuid) then
    local markData = self.MarkDataMap[uuid]
    self:RecycleOneMark(markData)
    self.MarkDataMap[uuid] = nil
  end
end

function ActDispatchTaskDataManager:GetMarkListRedCount()
  local count = 0
  if not table.IsNullOrEmpty(self.MarkDataMap) then
    for _, markData in pairs(self.MarkDataMap) do
      if markData:CanShowInList() and markData:CanClaim() then
        count = count + 1
      end
    end
  end
  if 0 < count then
    local todayStealNum = self:GetTodayStealNum()
    local steal_count = self:GetDispatchSetting("steal_count")
    local leftStealCount = math.max(0, steal_count - todayStealNum)
    return math.max(0, math.min(count, leftStealCount))
  end
  return 0
end

function ActDispatchTaskDataManager:TryThumbsUpMark(uuid)
  local markData = table.TryGetValue(self.MarkDataMap, checknumber(uuid), nil)
  if markData == nil then
    return
  end
  if markData:FromMe() then
    UIUtil.ShowTipsId("dispatch_quick_mark_like_tips_fail_3")
    return
  end
  if markData:HasThumbsUp() then
    UIUtil.ShowTipsId("dispatch_quick_mark_like_tips_fail_1")
    return
  end
  local thumbsUpType = InteractiveUtil.ThumbsUpType.DispatchMarkLike
  if not InteractiveUtil.CanThumbsUp(thumbsUpType) then
    UIUtil.ShowTipsId("dispatch_quick_mark_like_tips_fail_2")
    return
  end
  local param = {}
  param.missionUuid = markData:GetMissionUuid()
  param.content = ""
  param.extParam = ""
  SFSNetwork.SendMessage(MsgDefines.AllianceShareMissionThumbsUp, param)
end

function ActDispatchTaskDataManager:OnThumbsUpCallback(payload)
  if payload == nil then
    return
  end
  if payload.thumbsUpObj ~= nil and payload.thumbsUpObj.result then
    UIUtil.ShowTipsId("dispatch_quick_mark_like_tips")
    if payload.shareMissionInfo ~= nil then
      local uuid = checknumber(payload.shareMissionInfo.uuid)
      local markData = table.TryGetValue(self.MarkDataMap, uuid, nil)
      if markData == nil or not markData:Valid() then
        return
      end
      markData:UpdateThumbsUp(payload.shareMissionInfo.hasThumbs)
      markData:TriggerUpdate()
    end
  end
end

function ActDispatchTaskDataManager:OnPushMarkAdd(missionUuid)
  missionUuid = checknumber(missionUuid)
  if not table.hasvalue(self.MarkedMission, missionUuid) then
    table.insert(self.MarkedMission, missionUuid)
  end
end

function ActDispatchTaskDataManager:HasMarked(missionUuid)
  missionUuid = checknumber(missionUuid)
  if table.hasvalue(self.MarkedMission, missionUuid) then
    return true
  end
  if not table.IsNullOrEmpty(self.MarkDataMap) then
    for _, markData in pairs(self.MarkDataMap) do
      if markData:GetMissionUuid() == missionUuid then
        return true
      end
    end
  end
  return false
end

function ActDispatchTaskDataManager:IsSelectURSwitchOpen()
  local isOpen = LuaEntry.DataConfig:CheckSwitch("secret_select_ur")
  return isOpen
end

return ActDispatchTaskDataManager
