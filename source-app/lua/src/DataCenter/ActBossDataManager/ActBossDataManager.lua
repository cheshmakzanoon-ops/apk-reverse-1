local ActBossDataManager = BaseClass("ActBossDataManager")
local ActBossData = require("DataCenter.ActBossDataManager.ActBossData")
local ActBossRankDataList = require("DataCenter.ActBossDataManager.ActBossRankDataList")
local Localization = CS.GameEntry.Localization
local Notifier = require("Common.Notifier")
local LWActBossBattleReportData = require("DataCenter.ActBossDataManager.LWActBossBattleReportData")
local __preShowGoBtnReddot = false

local function __TickCountDown(self)
  local showGoBtnReddot = self:CanShowGoBtnReddot()
  if __preShowGoBtnReddot ~= showGoBtnReddot then
    __preShowGoBtnReddot = showGoBtnReddot
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
    Notifier.Dispatch("ActWorldBoss.RefreshReddot")
  end
end

function ActBossDataManager:__init()
  self.inited = false
  self.hasEnterGame = false
  self.actBossTransLastTime = 0
  self.actBossTransTimes = 1000
  self.lastRefreshTime = 0
  self.actBossTransLastRound = 0
  self.actBossDataList = {}
  self.allianceCityBossDic = {}
  self.bossRankList = {}
  self.bossRewards = {}
  self.bossBattleReportDict = {}
  self.worldBossPictureDict = {}
  self.worldBossForegroundDict = {}
  self.worldBossBackgroundDict = {}
  self.worldBossShoutDataDict = {}
  self.lastActType = 0
  self.IsAllDayFuncOpen = false
  self.isShowSvrTimeDesc = CommonUtil.PlayerPrefsGetBool(SettingKeys.WORLD_BOSS_SHOW_SVR_TIME, true)
end

function ActBossDataManager.getters:bossName()
  if self.bossId then
    self.bossName = Localization:GetString(GetTableData(LuaEntry.Player:GetABTestTableName(TableName.Monster), self.bossId, "name"))
    return self.bossName
  end
  return nil
end

function ActBossDataManager:__delete()
  if self.cdTimer then
    self.cdTimer:Stop()
  end
  self.cdTimer = nil
  self.inited = false
  self.actBossTransLastTime = nil
  self.actBossTransTimes = nil
  self.lastRefreshTime = nil
  self.actBossDataList = nil
  self.actBossTransLastRound = nil
  self.allianceCityBossDic = nil
  self.bossRankList = nil
  self.bossRewards = nil
  self.needShowTip = nil
  self.hasEnterGame = nil
  self.bossBattleReportDict = nil
  self.worldBossPictureDict = nil
  self.worldBossForegroundDict = nil
  self.worldBossBackgroundDict = nil
  self.worldBossShoutDataDict = nil
  self.lastActType = nil
  self.IsAllDayFuncOpen = false
end

function ActBossDataManager:InitData(message)
  self.inited = true
  self.bossRankList = {}
  self.bossRewards = {}
  if message.actBossTrans ~= nil then
    self:RefreshTransTime(message.actBossTrans)
  end
  self.allianceCityBossDic = {}
  local kvDic = LuaEntry.DataConfig:TryGetStr("ship_boss", "k12")
  local strArr = string.split(kvDic, ";")
  if 0 < #strArr then
    for i = 1, #strArr do
      local str = strArr[i]
      local arr = string.split(str, ",")
      if 2 <= #arr then
        self.allianceCityBossDic[tonumber(arr[1])] = tonumber(arr[2])
      end
    end
  end
  self.attackMaxNum = LuaEntry.DataConfig:TryGetNum("ship_boss", "k11", 10)
  self.limitTime = LuaEntry.DataConfig:TryGetNum("ship_boss", "k13", 300)
  self.oneBloodSize = LuaEntry.DataConfig:TryGetNum("ship_boss", "k8", 100000)
  self.maxTime = LuaEntry.DataConfig:TryGetNum("ship_boss", "k21", 150)
  if self.activityId and self.activityData then
    self:InitActivityData(self.activityId, self.activityData)
  else
    local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.WorldBoss.Type)
    if dataList ~= nil and 0 < #dataList then
      local activityData = dataList[1]
      self:InitActivityData(activityData.id, activityData)
    end
  end
  for cityId, bossId in pairs(self.allianceCityBossDic) do
    self.cityId = cityId
    self.bossId = bossId
    self.bossName = nil
    break
  end
  if self.cdTimer then
    self.cdTimer:Stop()
  end
  self.cdTimer = TimerManager:GetInstance():GetTimer(1, __TickCountDown, self, false, false, false)
  self.cdTimer:Start()
end

function ActBossDataManager:InitActivityData(activityId, activityData)
  self.activityId = activityId
  self.activityData = activityData
  if not self.inited then
    return
  end
  self.configData = {}
  LocalController:instance():visitTable(TableName.WorldBossConfig, function(id, lineData)
    local activity_type = lineData:getIntValue("activity_type", 0)
    if activity_type == activityData.subType and activityData.tableInfo == TableName.WorldBossConfig then
      self.configData = lineData
      local k12 = lineData:getValue("k12")
      if k12 ~= nil then
        self.allianceCityBossDic = {}
        for item in string.gmatch(k12, "([^;]+);?") do
          local cityId, bossId = string.match(item, "(%d+),(%d+)")
          if cityId ~= nil and bossId ~= nil then
            self.cityId = cityId
            self.bossId = bossId
            self.bossName = nil
            self.allianceCityBossDic[tonumber(cityId)] = tonumber(bossId)
          end
        end
      end
      local k8 = lineData:getValue("k8")
      if k8 ~= nil then
        self.oneBloodSize = tonumber(k8) or self.oneBloodSize or 100000
      end
      local k11 = lineData:getValue("k11")
      if k11 ~= nil then
        self.attackMaxNum = tonumber(k11) or self.attackMaxNum or 10
      end
      local k13 = lineData:getValue("k13")
      if k13 ~= nil then
        self.limitTime = tonumber(k13) or self.limitTime or 300
      end
      local k18 = lineData:getValue("k18")
      if not string.IsNullOrEmpty(k18) then
        local groups = {}
        for group in string.gmatch(k18, "[^|]+") do
          table.insert(groups, group)
        end
        local lastGroup = groups[#groups]
        local key = string.match(lastGroup, "([^;]+)")
        self.rewardMaxTimes = tonumber(key) or self.rewardMaxTimes or self.attackMaxNum
      end
      local k21 = lineData:getValue("k21")
      if k21 ~= nil then
        self.maxTime = tonumber(k21) or self.maxTime or 150
      end
      local sBossRefreshTime = lineData:getValue("boss_refreshtime")
      if sBossRefreshTime ~= nil then
        local tTimeList = string.split_ii_array(sBossRefreshTime, ";")
        self:InitBossRefreshTime(tTimeList)
      end
      local AchievementTaskData = {}
      local damage_list = lineData:getValue("damage_list")
      local damage_desc = lineData:getValue("damage_desc")
      local progressSpecialData = lineData:getValue("progress_special") or {}
      if damage_list ~= nil then
        local index = 1
        for item in string.gmatch(damage_list, "([^|]+)|?") do
          local split = string.split(item, ";")
          local damage = 0
          if #split == 1 then
            damage = tonumber(split[1])
          else
            damage = tonumber(split[2])
          end
          table.insert(AchievementTaskData, {
            id = index,
            damage = damage,
            desc = "456064",
            damageShowTime = 0,
            progressSpecial = progressSpecialData[index]
          })
          index = index + 1
        end
      end
      if damage_desc ~= nil then
        local index = 1
        for desc in string.gmatch(damage_desc, "([^|]+)|?") do
          if AchievementTaskData[index] ~= nil then
            AchievementTaskData[index].desc = desc
            index = index + 1
          end
        end
      end
      self.AchievementTaskData = AchievementTaskData
      self.worldBossPictureDict = self:SplitWorldBossDataBySeason(lineData:getValue("img_monster") or {})
      self.worldBossForegroundDict = self:SplitWorldBossDataBySeason(lineData:getValue("img_foreground") or {})
      self.worldBossBackgroundDict = self:SplitWorldBossDataBySeason(lineData:getValue("img_sky") or {})
      self.worldBossShoutDataDict = self:SplitWorldBossDataBySeason(lineData:getValue("boss_shout_season") or {})
      self:InitAllDayFuncInfo()
      return true
    end
    return false
  end)
  SFSNetwork.SendMessage(MsgDefines.UserGetActBossAchievement, tostring(activityId))
  SFSNetwork.SendMessage(MsgDefines.ActivityGetRankReward, tostring(activityId), -1)
end

function ActBossDataManager:FetchConfig(key, defaultValue)
  if self.configData ~= nil and self.configData.getValue then
    local data = self.configData:getValue(key)
    if data == nil then
      return defaultValue
    end
    return data
  end
  return defaultValue
end

function ActBossDataManager:GetMaxDamageShow()
  if not self.maxDamage then
    return 0
  end
  local curMax = self.maxDamage
  if not self.configData then
    return 0
  end
  local list = self.configData:getValue("damage_list_show")
  if not list then
    return 0
  end
  local h = 0
  local count = #list
  if count == 0 then
    return h
  end
  local validCount = math.floor(count / 2)
  if curMax > list[2 * validCount] then
    return h
  end
  for i = 1, validCount do
    local low = list[2 * i - 1]
    local high = list[2 * i]
    if curMax < low then
      return h
    end
    if curMax >= low and curMax <= high then
      h = high
    end
  end
  return h
end

function ActBossDataManager:OnEnterGame()
  self.hasEnterGame = true
end

function ActBossDataManager:HideRedPoint()
  if not self.isRedPointHide then
    self.isRedPointHide = true
    EventManager:GetInstance():Broadcast(EventId.OnActBossAttackTimesRefresh)
  end
end

function ActBossDataManager:GetActRedNum()
  if DataCenter.LWSeasonBossLoginDataManager:IsVail() then
    return 0, 0, 0
  end
  local tipNum = self:CanShowGoBtnReddot() and 1 or 0
  local rewardNum = self:CanShowTaskReddot() and 1 or 0
  return tipNum + rewardNum, rewardNum, tipNum
end

function ActBossDataManager:CanShowNewLabel()
  return false
end

function ActBossDataManager:IsNeedMainUIShowTip()
  if self.bossName ~= nil then
    local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
    if activityData ~= nil then
      return true
    end
  end
  return false
end

function ActBossDataManager:ParseRankingData(message)
  if not message then
    return
  end
  local actId = message.activityId
  local rankingInfo = self.bossRankList[actId]
  if rankingInfo == nil then
    rankingInfo = {}
  end
  local playerRankingInfoMsg = message.owner
  if playerRankingInfoMsg then
    local selfPlayerData = BasePlayerInfo.New()
    selfPlayerData:ParseData(playerRankingInfoMsg)
    selfPlayerData.score = playerRankingInfoMsg.score
    selfPlayerData.ranking = playerRankingInfoMsg.rank
    rankingInfo.selfRankData = selfPlayerData
  end
  rankingInfo.rankList = {}
  local rankingList = message.list
  if rankingList then
    for _, v in pairs(rankingList) do
      local playerData = BasePlayerInfo.New()
      playerData:ParseData(v)
      playerData.score = v.score
      playerData.ranking = v.rank
      table.insert(rankingInfo.rankList, playerData)
    end
  end
  self.bossRankList[actId] = rankingInfo
  EventManager:GetInstance():Broadcast(EventId.OnActBossRankRefresh)
end

function ActBossDataManager:GetBossRankDataByActId(actId)
  return self.bossRankList[actId]
end

function ActBossDataManager:ParseRewardData(message)
  if not message then
    return
  end
  local actId = message.activityId
  local bossRewardsOne = self.bossRewards[actId]
  if bossRewardsOne == nil then
    bossRewardsOne = {}
  end
  local rewardData = message.rewardList
  local rewardsInfo = {}
  if not table.IsNullOrEmpty(rewardData) then
    for _, v in pairs(rewardData) do
      local rewardInfo = {}
      rewardInfo.minRanking = v.minLv
      rewardInfo.maxRanking = v.maxLv
      rewardInfo.rewards = DataCenter.RewardManager:ReturnRewardParamForView(v.reward)
      table.insert(rewardsInfo, rewardInfo)
    end
  end
  bossRewardsOne[1] = rewardsInfo
  local personRewardList = message.personRewardList
  local personrewardsInfo = {}
  if not table.IsNullOrEmpty(personRewardList) then
    for _, v in pairs(personRewardList) do
      local rewardInfo = {}
      rewardInfo.times = v.times
      rewardInfo.rewards = DataCenter.RewardManager:ReturnRewardParamForView(v.reward)
      table.insert(personrewardsInfo, rewardInfo)
    end
  end
  bossRewardsOne[2] = personrewardsInfo
  self.bossRewards[actId] = bossRewardsOne
  EventManager:GetInstance():Broadcast(EventId.OnActBossRewardRefresh)
end

function ActBossDataManager:HasRankReward(actId)
  return self.bossRewards ~= nil and self.bossRewards[actId] ~= nil
end

function ActBossDataManager:GetRewardsDataByActId(actId, idx)
  if self.bossRewards[actId] == nil then
    return {}
  end
  return self.bossRewards[actId][idx]
end

function ActBossDataManager:GetAchievementTaskData(taskId)
  if self.AchievementTaskData == nil then
    return nil
  end
  return self.AchievementTaskData[tonumber(taskId)]
end

function ActBossDataManager:JudgeAchievementTaskIsValid(taskId)
  local achievementData = self:GetAchievementTaskData(taskId)
  if achievementData == nil then
    return false
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local surplusTime = achievementData.damageShowTime - curTime
  return surplusTime <= 0
end

function ActBossDataManager:RefreshRankDataList(message)
  if message == nil then
    return
  end
  local oneData = ActBossRankDataList.New()
  oneData:ParseData(message)
  if oneData.uuid ~= 0 then
    self.bossRankList[oneData.uuid] = oneData
  end
end

function ActBossDataManager:GetBossRankDataByUuid(uuid)
  return self.bossRankList[uuid]
end

function ActBossDataManager:RefreshTransTime(message)
  if message.actBossTransTimes ~= nil then
    self.actBossTransTimes = message.actBossTransTimes
  end
  if message.actBossTransLastTime ~= nil then
    self.actBossTransLastTime = message.actBossTransLastTime
  end
  if message.actBossTransLastRound ~= nil then
    self.actBossTransLastRound = message.actBossTransLastRound
  end
  self.lastRefreshTime = UITimeManager:GetInstance():GetServerSeconds()
  if self.hasEnterGame then
    if self.stageTimeList == nil then
      SFSNetwork.SendMessage(MsgDefines.UserGetActBossMarch)
    else
      EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
    end
    EventManager:GetInstance():Broadcast(EventId.OnActBossAttackTimesRefresh)
  end
end

function ActBossDataManager:GetRestTransNum()
  if self.attackMaxNum == -1 then
    return self.attackMaxNum
  end
  return math.max(self.attackMaxNum - self.actBossTransTimes, 0)
end

function ActBossDataManager:GetLastTransTime()
  return self.actBossTransLastTime
end

function ActBossDataManager:RefreshActBossDataList(message)
  if message == nil then
    return
  end
  self.actBossDataList = {}
  self.crossInfo = message.crossInfo
  if message.marches ~= nil then
    local arr = message.marches
    for k, v in pairs(arr) do
      if v ~= nil then
        local oneData = ActBossData.New()
        oneData:ParseData(v)
        if oneData.uuid ~= 0 then
          self.actBossDataList[oneData.uuid] = oneData
        end
      end
    end
  end
  local timeFrame = message.timeFrame
  if timeFrame ~= nil then
    self.stageTimeList = timeFrame
    table.sort(timeFrame, function(a, b)
      return a.startTime < b.startTime
    end)
  end
  self.nextOpenTime = message.nextOpenTime or 0
  EventManager:GetInstance():Broadcast(EventId.OnActBossAttackTimesRefresh)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function ActBossDataManager:GetAttackStageData()
  if self.stageTimeList ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    for _, v in ipairs(self.stageTimeList) do
      if curTime > v.startTime and curTime < v.endTime then
        return v
      elseif curTime < v.startTime then
        return v
      end
    end
  end
  return self.nextOpenTime
end

function ActBossDataManager:IsBossAvailable()
  local stageData = self:GetAttackStageData()
  if stageData ~= nil then
    if type(stageData) == "number" then
      return false
    end
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime > stageData.startTime and curTime < stageData.endTime then
      return true
    end
  end
  return false
end

function ActBossDataManager:CanShowGoBtnReddot()
  if self.rewardMaxTimes then
    return self:IsBossAvailable() and self.actBossTransTimes < self.rewardMaxTimes
  end
  return self:IsBossAvailable()
end

function ActBossDataManager:CanShowTaskReddot()
  local taskList = DataCenter.ActBossDataManager.AchievementTaskData
  if not taskList then
    return false
  end
  for _, v in ipairs(taskList) do
    if v ~= nil and v.state == TaskState.CanReceive then
      return true
    end
  end
  return false
end

function ActBossDataManager:GetActBossDataList()
  return self.actBossDataList
end

function ActBossDataManager:GetActBossDataCount()
  return table.count(self.actBossDataList)
end

function ActBossDataManager:GetActBossDataByUuid(uuid)
  return self.actBossDataList[uuid]
end

function ActBossDataManager:GetActBossDataByCityId(cityId)
  local monsterId = self.allianceCityBossDic[cityId]
  for k, v in pairs(self.actBossDataList) do
    if v.monsterId == monsterId then
      return v
    end
  end
  return nil
end

function ActBossDataManager:GetActBossShowPictureBySeason()
  local backgroundPicPath, monsterPicPath, foregroundPicPath = "", "", ""
  local curSeasonId = SeasonUtil.GetSeason()
  if self.worldBossPictureDict[curSeasonId] then
    monsterPicPath = self.worldBossPictureDict[curSeasonId]
  end
  if self.worldBossForegroundDict[curSeasonId] then
    foregroundPicPath = self.worldBossForegroundDict[curSeasonId]
  end
  if self.worldBossBackgroundDict[curSeasonId] then
    backgroundPicPath = self.worldBossBackgroundDict[curSeasonId]
  end
  return backgroundPicPath, monsterPicPath, foregroundPicPath
end

function ActBossDataManager:SplitWorldBossDataBySeason(data)
  local dict = {}
  for i = 1, table.count(data) do
    local strArr = string.split(data[i], ";")
    if table.count(strArr) == 2 then
      local seasonId = tonumber(strArr[1])
      dict[seasonId] = strArr[2]
    end
  end
  return dict
end

function ActBossDataManager:GetWorldBossShoutData()
  local curSeasonId = SeasonUtil.GetSeason()
  if self.worldBossShoutDataDict[curSeasonId] then
    return self.worldBossShoutDataDict[curSeasonId]
  end
  return ""
end

function ActBossDataManager:HandleBossBattleReportData(message)
  local list = message.list
  if list ~= nil then
    for k, v in pairs(list) do
      if v.activityId then
        local activityId = v.activityId
        local reportList = {}
        if v.list then
          local battleReportList = v.list
          for _, report in pairs(battleReportList) do
            local battleReportData = LWActBossBattleReportData.New()
            battleReportData:InitData(report)
            table.insert(reportList, battleReportData)
          end
          self.bossBattleReportDict[activityId] = reportList
        end
      end
    end
    EventManager:GetInstance():Broadcast(EventId.RefreshActBossBattleReportData)
  end
end

function ActBossDataManager:GetBossBattleReportDataByActId(activityId)
  return self.bossBattleReportDict[activityId]
end

function ActBossDataManager:InitBossRefreshTime(tTimeList)
  self.bossRefreshTimeSvr = {}
  self.bossRefreshTimeLocal = {}
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local curZeroTimeStamp = UITimeManager:GetInstance():GetTodayZeroServerTime(curTime // 1000) * 1000
  for i, v in ipairs(tTimeList) do
    local nSecondInDay = v * 3600
    self.bossRefreshTimeSvr[i] = UITimeManager:GetInstance():SecondToFmtStringHM(nSecondInDay)
    local nTimeStampLocal = curZeroTimeStamp + nSecondInDay * 1000
    self.bossRefreshTimeLocal[i] = UITimeManager:GetInstance():ConvertServerTimeToLocalTime(nTimeStampLocal, true, true)
  end
end

function ActBossDataManager:GetBossRefreshTime(isServerTime)
  if isServerTime then
    return self.bossRefreshTimeSvr
  else
    return self.bossRefreshTimeLocal
  end
end

function ActBossDataManager:SetCurrentType(type)
  self.lastActType = type
end

function ActBossDataManager:GetCurrentType()
  return self.lastActType
end

function ActBossDataManager:SetIsShowSvrTimeDesc(isShowSvrTimeDesc)
  self.isShowSvrTimeDesc = isShowSvrTimeDesc
  CommonUtil.PlayerPrefsSetBool(SettingKeys.WORLD_BOSS_SHOW_SVR_TIME, self.isShowSvrTimeDesc)
end

function ActBossDataManager:InitAllDayFuncInfo()
  self.IsAllDayFuncOpen = false
  if not table.IsNullOrEmpty(self.configData) then
    local function handleConfig(config)
      local ret = {}
      
      ret.serverList = {}
      ret.time = 0
      if config ~= nil then
        local serverAndTime = string.split(config, "|")
        if table.count(serverAndTime) == 2 then
          local serverStr = serverAndTime[1]
          ret.time = checknumber(serverAndTime[2])
          local serverPairStr = string.split(serverStr, ";")
          for _, serverPair in pairs(serverPairStr) do
            local serverArr = string.split(serverPair, "-")
            local serverData = {}
            if table.count(serverArr) == 2 then
              serverData.From = checknumber(serverArr[1])
              serverData.To = checknumber(serverArr[2])
            else
              serverData.From = checknumber(serverArr[1])
              serverData.To = checknumber(serverArr[1])
            end
            table.insert(ret.serverList, serverData)
          end
        end
      end
      return ret
    end
    
    local newStartTimeInfo = handleConfig(self.configData.boss_refreshtime_new)
    local newEndTimeInfo = handleConfig(self.configData.boss_lifetime_new)
    self.NewStartTime = -1
    self.NewDurationTime = -1
    local serverId = LuaEntry.Player.serverId
    for _, serverRange in pairs(newStartTimeInfo.serverList) do
      if serverId >= serverRange.From and serverId <= serverRange.To then
        self.NewStartTime = newStartTimeInfo.time
        break
      end
    end
    for _, serverRange in pairs(newEndTimeInfo.serverList) do
      if serverId >= serverRange.From and serverId <= serverRange.To then
        self.NewDurationTime = newEndTimeInfo.time
        break
      end
    end
    if self.NewStartTime >= 0 and self.NewDurationTime >= 0 then
      self.IsAllDayFuncOpen = true
    end
  end
end

return ActBossDataManager
