local LWSeasonBossLoginDataManager = BaseClass("LWSeasonBossLoginDataManager")
local LWActBossBattleReportData = require("DataCenter.ActBossDataManager.LWActBossBattleReportData")
local ActBossData = require("DataCenter.ActBossDataManager.ActBossData")

function LWSeasonBossLoginDataManager:__init()
  self.inited = false
  self.AchievementTaskData = {}
  self.configData = {}
  self.attackInfoRewards = {}
  self.bossBattleReportDict = {}
  self.bossDataRecord = {}
end

function LWSeasonBossLoginDataManager:__delete()
  self.inited = false
  self.AchievementTaskData = nil
  self.configData = nil
  self.attackInfoRewards = nil
  self.bossBattleReportDict = nil
  self.bossDataRecord = nil
end

function LWSeasonBossLoginDataManager:IsVail()
  local actData = self:GetActivityData()
  if actData == nil then
    return false
  end
  return true
end

function LWSeasonBossLoginDataManager:InitData(message)
  self.inited = true
  local virusboss = message.virusboss
  if virusboss ~= nil and virusboss.attackTimes2reward ~= nil then
    self.attackTimes2reward = virusboss.attackTimes2reward
  end
end

function LWSeasonBossLoginDataManager:InitActivityData(id, activityData)
  self.activityId = toInt(id)
  self.activityData = activityData
  if not self.inited then
    return
  end
  if DataCenter.ActBossDataManager.activityData ~= nil then
    self:InitAchievementTaskDataByActivity(DataCenter.ActBossDataManager.activityData)
  end
  SFSNetwork.SendMessage(MsgDefines.GetSeasonVirusAchievementRewardInfo)
  SFSNetwork.SendMessage(MsgDefines.GetSeasonVirusAchievementTaskInfo, tostring(self.activityId))
end

function LWSeasonBossLoginDataManager:InitAchievementTaskDataByActivity(activityData)
  if self.activityId == nil then
    return
  end
  local bossConfigId
  LocalController:instance():visitTable(TableName.WorldBossConfig, function(id, lineData)
    local activity_type = lineData:getIntValue("activity_type", 0)
    if activity_type == activityData.subType and activityData.tableInfo == TableName.WorldBossConfig then
      bossConfigId = id
      return true
    end
    return false
  end)
  if bossConfigId ~= nil then
    LocalController:instance():visitTable(TableName.LW_SEASON_PRE_VIRUS_BOSS, function(id, lineData)
      local worldCfgBossId = tonumber(lineData:getValue("worldboss_cfg_id", 0))
      if worldCfgBossId == bossConfigId then
        self.configData = lineData
        local AchievementTaskData = {}
        local damage_list = lineData:getValue("damage_reward_new")
        local progressSpecialData = lineData:getValue("progress_special_new") or {}
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
        self.AchievementTaskData = AchievementTaskData
        return true
      end
    end)
  end
end

function LWSeasonBossLoginDataManager:ParseBossBattleReportData(message)
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

function LWSeasonBossLoginDataManager:ParseMarchInRecorde(message)
  if message.marches ~= nil then
    local arr = message.marches
    for k, v in pairs(arr) do
      if v ~= nil then
        local oneData = ActBossData.New()
        oneData:ParseData(v)
        if oneData.uuid ~= 0 then
          self.bossDataRecord[oneData.uuid] = oneData
          if oneData.monsterJson.bosstype == 1 then
            LocalController:instance():visitTable(TableName.LW_SEASON_PRE_VIRUS_BOSS, function(id, lineData)
              local bossId = lineData:getValue("boss_id_new")
              if tonumber(bossId) == oneData.monsterId then
                self.configData = lineData
                return true
              end
            end)
          end
        end
      end
    end
  end
  if message.virusbossCfgId ~= nil then
    local virusMonsterId = tonumber(message.virusbossCfgId)
    local worldossCfgId = tonumber(message.worldbossCfgId)
    local oneData = ActBossData.New()
    oneData.monsterId = virusMonsterId
    oneData.monsterJson = {
      bosstype = 1,
      initHp = 1000000,
      hp = 1000000,
      state = 0
    }
    self.bossDataRecord[1] = oneData
    local twoData = ActBossData.New()
    twoData.monsterId = worldossCfgId
    twoData.monsterJson = {
      bosstype = 0,
      initHp = 1000000,
      hp = 1000000,
      state = 0
    }
    self.bossDataRecord[2] = twoData
    LocalController:instance():visitTable(TableName.LW_SEASON_PRE_VIRUS_BOSS, function(id, lineData)
      local bossId = lineData:getValue("boss_id_new")
      if tonumber(bossId) == virusMonsterId then
        self.configData = lineData
        return true
      end
    end)
  end
  if message.userdata ~= nil then
    DataCenter.LWSpreadResearchDataManager.resistance = message.userdata.resistance or 0
  end
  EventManager:GetInstance():Broadcast(EventId.OnActBossDataRefresh)
end

function LWSeasonBossLoginDataManager:ParseRewardInfo(message)
  local rewardsInfo = {}
  if not table.IsNullOrEmpty(message) and message.personRewardList ~= nil then
    for _, v in pairs(message.personRewardList) do
      local rewardInfo = {}
      rewardInfo.times = v.times
      rewardInfo.rewards = DataCenter.RewardManager:ReturnRewardParamForView(v.reward)
      table.insert(rewardsInfo, rewardInfo)
    end
  end
  self.attackInfoRewards = rewardsInfo
  EventManager:GetInstance():Broadcast(EventId.OnActBossRankRefresh)
end

function LWSeasonBossLoginDataManager:RefreshTransTime(message)
  DataCenter.ActBossDataManager:RefreshTransTime(message)
  if self.attackTimes2reward ~= nil then
    self.attackTimes2reward.times = message.actBossTransTimes or 0
  end
end

function LWSeasonBossLoginDataManager:ParseVirusAttackTimes(message)
  self.attackTimes2reward = message.attackTimes2reward
  if message.rewards then
    DataCenter.RewardManager:ShowCommonReward({
      reward = message.rewards
    })
    DataCenter.RewardManager:AddRewardsAndRes({
      reward = message.rewards
    })
  end
end

function LWSeasonBossLoginDataManager:GetActivityData()
  return DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
end

function LWSeasonBossLoginDataManager:GetActBossActivityId()
  return tostring(DataCenter.ActBossDataManager.activityId)
end

function LWSeasonBossLoginDataManager:GetBossData()
  local actBoss, seasonBoss
  local bossList = DataCenter.ActBossDataManager:GetActBossDataList()
  if (bossList == nil or next(bossList) == nil) and self.bossDataRecord ~= nil then
    bossList = self.bossDataRecord
  end
  for k, v in pairs(bossList) do
    if v.monsterJson ~= nil then
      if v.monsterJson.bosstype == 0 then
        actBoss = v
      elseif v.monsterJson.bosstype == 1 then
        seasonBoss = v
      end
    end
  end
  return actBoss, seasonBoss
end

function LWSeasonBossLoginDataManager:GetAchievementTaskData(taskId)
  if self.AchievementTaskData == nil then
    return nil
  end
  return self.AchievementTaskData[tonumber(taskId)]
end

function LWSeasonBossLoginDataManager:GetConfigData()
  return self.configData
end

function LWSeasonBossLoginDataManager:GetMaxDamageShow()
  if not self.maxDamage then
    return 0
  end
  local curMax = self.maxDamage
  if not DataCenter.ActBossDataManager.configData then
    return 0
  end
  local list = DataCenter.ActBossDataManager.configData:getValue("damage_list_show")
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

function LWSeasonBossLoginDataManager:GetRankRewardState(attackTime)
  if self.attackTimes2reward == nil then
    return TaskState.NotExist
  end
  if not string.IsNullOrEmpty(self.attackTimes2reward.taketimes) then
    local receiveList = string.split(self.attackTimes2reward.taketimes, ",")
    for _, count in pairs(receiveList) do
      if tonumber(count) == attackTime then
        return TaskState.Received
      end
    end
  end
  if attackTime <= self.attackTimes2reward.times then
    return TaskState.CanReceive
  else
    return TaskState.NoComplete
  end
end

function LWSeasonBossLoginDataManager:GetAttackInfoRewards()
  return self.attackInfoRewards
end

function LWSeasonBossLoginDataManager:GetBossBattleReportDataByActId(activityId)
  return self.bossBattleReportDict[activityId]
end

function LWSeasonBossLoginDataManager:CheckCanToPlayerS1SeasonPreBossCirHit()
  if not self:IsVail() then
    return false
  end
  local actBoss, seasonBoss = self:GetBossData()
  if actBoss == nil or seasonBoss == nil then
    return false
  end
  local troop = CS.SceneManager.World:GetTroop(actBoss.uuid)
  local actBossState = actBoss.monsterJson.state
  if troop then
    actBossState = troop:GetMarchInfo().actBossState
  end
  troop = CS.SceneManager.World:GetTroop(seasonBoss.uuid)
  local seasonBossState = seasonBoss.monsterJson.state
  if troop then
    seasonBossState = troop:GetMarchInfo().actBossState
  end
  local canPlayer = actBossState == 1 and seasonBossState == 0 or actBossState == 0 and seasonBossState == 1
  return canPlayer
end

function LWSeasonBossLoginDataManager:FetchConfig(key, defaultValue)
  if self.configData ~= nil and self.configData.getValue then
    local data = self.configData:getValue(key)
    if data == nil then
      return defaultValue
    end
    return data
  end
  return defaultValue
end

function LWSeasonBossLoginDataManager:GetAttackTimes()
  if self.attackTimes2reward == nil then
    return 0
  end
  return self.attackTimes2reward.times or 0
end

function LWSeasonBossLoginDataManager:GetActivityFunctionEnd()
  if not self:IsVail() then
    return false
  end
  local endTime = self:GetActivityData().endTime
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local hour = (endTime - curTime) / 3600000
  if hour < 1 then
    return true
  end
  return false
end

function LWSeasonBossLoginDataManager:IsBossAvailable()
  local stageData = DataCenter.ActBossDataManager:GetAttackStageData()
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

function LWSeasonBossLoginDataManager:GetReddot()
  if not self:IsVail() then
    return false
  end
  if self:GetReddotType1() then
    return true
  end
  if self:GetReddotType2() then
    return true
  end
  return false
end

function LWSeasonBossLoginDataManager:IsInActivityEndTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local dayEnd = UITimeManager:GetInstance():GetTomorrowZero()
  local isInTDay = dayEnd - curTime <= 3600000
  return isInTDay
end

function LWSeasonBossLoginDataManager:GetReddotType1()
  if self:IsInActivityEndTime() then
    return false
  end
  if not self:IsVail() then
    return false
  end
  if self:GetShowRankReddot() then
    return true
  end
  if self:CanShowTaskReddot() then
    return true
  end
  if DataCenter.ActBossDataManager:CanShowTaskReddot() then
    return true
  end
  return false
end

function LWSeasonBossLoginDataManager:GetReddotType2()
  if self:IsInActivityEndTime() then
    return false
  end
  if not self:IsVail() then
    return false
  end
  if self.attackTimes2reward ~= nil and DataCenter.ActBossDataManager.rewardMaxTimes ~= nil and self:IsBossAvailable() and self.attackTimes2reward.times < DataCenter.ActBossDataManager.rewardMaxTimes then
    return true
  end
  return false
end

function LWSeasonBossLoginDataManager:CanShowTaskReddot()
  if self:IsInActivityEndTime() then
    return false
  end
  local taskList = self.AchievementTaskData
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

function LWSeasonBossLoginDataManager:GetShowRankReddot()
  if self:IsInActivityEndTime() then
    return false
  end
  if self.attackInfoRewards == nil then
    return false
  end
  for _, v in pairs(self.attackInfoRewards) do
    if self:GetRankRewardState(v.times) == TaskState.CanReceive then
      return true
    end
  end
  return false
end

function LWSeasonBossLoginDataManager:JudgeAchievementTaskIsValid(taskId)
  local achievementData = self:GetAchievementTaskData(taskId)
  if achievementData == nil then
    return false
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local surplusTime = achievementData.damageShowTime - curTime
  return surplusTime <= 0
end

return LWSeasonBossLoginDataManager
