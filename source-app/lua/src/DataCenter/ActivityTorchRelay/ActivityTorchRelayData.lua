local ActivityTorchRelayData = BaseClass("ActivityTorchRelayData")
local ActivityTorchRelayConfigTemplate = require("DataCenter/ActivityTorchRelay/ActivityTorchRelayConfigTemplate")
local ActivityTorchRelayGrowUpConfigTemplate = require("DataCenter/ActivityTorchRelay/ActivityTorchRelayGrowUpConfigTemplate")
local rapidjson = require("rapidjson")

function ActivityTorchRelayData:__init()
  self.config = nil
  self.data = nil
  self.activityId = nil
end

function ActivityTorchRelayData:__delete()
  self.config = nil
  self.data = nil
  self.activityId = nil
end

function ActivityTorchRelayData:InitData(data, activityId)
  self.activityId = activityId
  if self.data == nil then
    self.data = {}
  end
  if data ~= nil then
    for i, v in pairs(data) do
      self.data[i] = v
      if i == "levelObj" then
        Logger.LogInfo("TorchRelay:InitData levelObj: " .. rapidjson.encode(v))
        Logger.LogInfo("TorchRelay:InitData address: " .. tostring(self))
      end
    end
  end
  self.config = nil
  local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if activityData ~= nil then
    local lineData = LocalController:instance():getLine(TableName.Activity_Torch_Relay, tonumber(activityData.subType))
    if lineData ~= nil then
      self.config = ActivityTorchRelayConfigTemplate.New()
      self.config:InitData(lineData)
    end
  end
end

function ActivityTorchRelayData:GetEndTime()
  if self.data ~= nil then
    return checknumber(self.data.endTime)
  end
  return 0
end

function ActivityTorchRelayData:GetLeftTime()
  local endTime = self:GetEndTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = endTime - curTime
  return leftTime
end

function ActivityTorchRelayData:GetActivityId()
  return self.activityId
end

function ActivityTorchRelayData:GetAllGrowUpLevelData()
  local res = {}
  if self.data == nil then
    Logger.LogError("TorchRelay:GetAllGrowUpLevelData data is nil")
  elseif self.data.levelObj == nil then
    Logger.LogError("TorchRelay:GetAllGrowUpLevelData levelObj is nil")
  else
    for i, v in pairs(self.data.levelObj) do
      local type = tonumber(i)
      if type then
        res[tostring(type)] = tonumber(v)
      end
    end
  end
  return res
end

function ActivityTorchRelayData:GetGrowUpLevelByType(type)
  local allData = self:GetAllGrowUpLevelData()
  if allData[tostring(type)] ~= nil then
    return allData[tostring(type)]
  end
  Logger.LogInfo("TorchRelay:GetGrowUpLevelByType allData: " .. rapidjson.encode(allData))
  Logger.LogInfo("TorchRelay:GetGrowUpLevelByType address: " .. tostring(self))
  Logger.LogInfo("TorchRelay:GetGrowUpLevelByType activityId: " .. tostring(self.activityId))
  return 0
end

function ActivityTorchRelayData:GetAllGrowUpConfig()
  if self.allGrowUpConfig == nil then
    self.allGrowUpConfig = {}
    if self.config ~= nil then
      LocalController:instance():visitTable(TableName.Activity_Torch_Relay_Grow_Up, function(id, lineData)
        if lineData then
          local group = tonumber(lineData:getValue("grow_up_group"))
          if group and group == self.config.grow_up_id then
            local template = ActivityTorchRelayGrowUpConfigTemplate.New()
            template:InitData(lineData)
            table.insert(self.allGrowUpConfig, template)
          end
        end
      end)
    end
  end
  return self.allGrowUpConfig
end

function ActivityTorchRelayData:GetGrowUpConfig(type, level)
  local allConfig = self:GetAllGrowUpConfig()
  for i, v in pairs(allConfig) do
    if v.attribute == type and v.level == level then
      return v
    end
  end
end

function ActivityTorchRelayData:GetCurGrowUpLevelCostItemCount()
  if self.config ~= nil and self.config.distance_score_id > 0 then
    return DataCenter.ItemData:GetItemCount(self.config.distance_score_id)
  end
  return 0
end

function ActivityTorchRelayData:IsOtherGrowUpTypeLevelOK(type)
  local level = self:GetGrowUpLevelByType(type)
  for i, v in pairs(DataCenter.ActivityTorchRelayManager.GrowUpType) do
    if v ~= type then
      local typeLevel = self:GetGrowUpLevelByType(v)
      if level > typeLevel then
        return false
      end
    end
  end
  return true
end

function ActivityTorchRelayData:IsCanGrowUpLevelUp(type)
  local curLevel = self:GetGrowUpLevelByType(type)
  local nextLevelConfig = self:GetGrowUpConfig(type, curLevel + 1)
  if nextLevelConfig == nil then
    return false, 0
  end
  local curLevelConfig = self:GetGrowUpConfig(type, curLevel)
  if curLevelConfig == nil then
    return false, -1
  end
  if self:GetCurGrowUpLevelCostItemCount() < curLevelConfig.costNum then
    return false, 1
  end
  if not self:IsOtherGrowUpTypeLevelOK(type) then
    return false, 2
  end
  return true, 3
end

function ActivityTorchRelayData:IsGrowUpLevelMaxed(type)
  local curLevel = self:GetGrowUpLevelByType(type)
  local nextLevelConfig = self:GetGrowUpConfig(type, curLevel + 1)
  if nextLevelConfig == nil then
    return true
  end
  return false
end

function ActivityTorchRelayData:SetGrowUpLevel(type, level)
  if self.data == nil then
    Logger.LogError("TorchRelay:SetGrowUpLevel error, data is nil")
    return false
  end
  if self.data.levelObj == nil then
    Logger.LogError("TorchRelay:SetGrowUpLevel error, levelObj is nil")
    return false
  end
  if self.data ~= nil and self.data.levelObj ~= nil then
    for i, v in pairs(self.data.levelObj) do
      if tonumber(i) == type then
        self.data.levelObj[i] = level
        Logger.LogInfo("TorchRelay:SetGrowUpLevel levelObj: " .. rapidjson.encode(self.data.levelObj))
        Logger.LogInfo("TorchRelay:SetGrowUpLevel address: " .. tostring(self))
        return true
      end
    end
  end
  return false
end

function ActivityTorchRelayData:GetCurStage()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local endTime = self:GetEndTime()
  if curTime >= endTime then
    return DataCenter.ActivityTorchRelayManager.Stage.Error
  end
  if self.data ~= nil and self.data.rewardTime ~= nil and self.data.rewardTime > 0 then
    if curTime >= self.data.rewardTime then
      return DataCenter.ActivityTorchRelayManager.Stage.Final
    else
      return DataCenter.ActivityTorchRelayManager.Stage.Normal
    end
  else
    return DataCenter.ActivityTorchRelayManager.Stage.Normal
  end
end

function ActivityTorchRelayData:GetAllCheerPlayersData()
  if self.data ~= nil and self.data.helpPlayers ~= nil then
    return self.data.helpPlayers
  end
end

function ActivityTorchRelayData:GetCheerPlayerDataByUid(uid)
  if self.data ~= nil and self.data.helpPlayers ~= nil then
    for i, v in pairs(self.data.helpPlayers) do
      if v.uid == uid then
        return v
      end
    end
  end
end

function ActivityTorchRelayData:CanClaimFreePackage()
  local res = false
  if self.config ~= nil and self.config.free_iap_reward > 0 then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if self.data.lastReceiveFreeTime == nil or not UITimeManager:GetInstance():IsSameDayForServer(curTime // 1000, self.data.lastReceiveFreeTime // 1000) then
      res = true
    else
      res = false
    end
  end
  return res
end

function ActivityTorchRelayData:GetEnterGameCheerUids()
  local customUidList = self:GetCheerCustomUidList()
  if customUidList then
    return customUidList
  end
  local res = {}
  if DataCenter.ActivityTorchRelayManager:IsAutoCheerOn() and self.data and not table.IsNullOrEmpty(self.data.helpPlayers) then
    for i, v in pairs(self.data.helpPlayers) do
      table.insert(res, v.uid)
      if 2 <= #res then
        break
      end
    end
  end
  if 0 < #res then
    return res
  end
end

function ActivityTorchRelayData:SetSelfRankRewardData(rankType, data)
  if rankType == DataCenter.ActivityTorchRelayManager.RankType.Personal then
    self.selfRankReward = data
  else
    self.selfAllyRankReward = data
  end
end

function ActivityTorchRelayData:SetRankRewardData(rankType, data)
  if data == nil then
    return
  end
  if rankType == DataCenter.ActivityTorchRelayManager.RankType.Personal then
    if self.personRankReward == nil then
      self.personRankReward = {}
    end
    table.clear(self.personRankReward)
    local totalCount = table.count(data)
    for i = 1, totalCount do
      local key = data[i].key
      local str = string.split(key, "-")
      if 1 < #str then
        local oneData = {}
        oneData.startN = tonumber(str[1])
        oneData.endN = tonumber(str[2])
        oneData.reward = data[i].rewards
        table.insert(self.personRankReward, oneData)
      end
    end
  else
    if self.allyRankReward == nil then
      self.allyRankReward = {}
    end
    table.clear(self.allyRankReward)
    for i = 1, table.count(data) do
      local key = data[i].key
      local str = string.split(key, "-")
      if 1 < #str then
        local oneData = {}
        oneData.startN = tonumber(str[1])
        oneData.endN = tonumber(str[2])
        oneData.reward = data[i].rewards
        table.insert(self.allyRankReward, oneData)
      end
    end
  end
end

function ActivityTorchRelayData:SetSelfRankInfoData(rankType, data)
  if rankType == DataCenter.ActivityTorchRelayManager.RankType.Personal then
    self.selfRank = data
  else
    self.selfAllyRank = data
  end
end

function ActivityTorchRelayData:GetSelfRankInfoData(rankType)
  if rankType == DataCenter.ActivityTorchRelayManager.RankType.Personal then
    return self.selfRank
  else
    return self.selfAllyRank
  end
end

function ActivityTorchRelayData:SetRankListInfoData(rankType, data)
  for _, v in pairs(data) do
    local playerData = BasePlayerInfo.New()
    playerData:ParseData(v)
    playerData.score = v.score
    playerData.ranking = v.rank
    if rankType == DataCenter.ActivityTorchRelayManager.RankType.Personal then
      playerData.picVer = v.picver
      playerData.hideFlag = v.hideFlag or false
      playerData.countryflag = v.countryflag or ""
      if self.personRankList == nil then
        self.personRankList = {}
      end
      self.personRankList[playerData.ranking] = playerData
    elseif rankType == DataCenter.ActivityTorchRelayManager.RankType.Alliance then
      playerData.icon = v.icon
      playerData.aid = v.aid
      playerData.name = v.name
      if self.allyRankList == nil then
        self.allyRankList = {}
      end
      self.allyRankList[playerData.ranking] = playerData
    end
  end
end

function ActivityTorchRelayData:GetRankListInfo(rankType)
  if rankType == DataCenter.ActivityTorchRelayManager.RankType.Personal then
    return self.personRankList
  else
    return self.allyRankList
  end
end

function ActivityTorchRelayData:GetRankRewardData(rankType)
  if rankType == DataCenter.ActivityTorchRelayManager.RankType.Personal then
    return self.personRankReward
  else
    return self.allyRankReward
  end
end

function ActivityTorchRelayData:GetSelfRankRewardData(rankType)
  if rankType == DataCenter.ActivityTorchRelayManager.RankType.Personal then
    return self.selfRankReward
  else
    return self.selfAllyRankReward
  end
end

function ActivityTorchRelayData:GetIsHideNationFlag()
  if self.data and self.data.hideFlag then
    return true
  end
  return false
end

function ActivityTorchRelayData:UpdateAutoSelect()
  local allData = self:GetAllCheerPlayersData() or {}
  local curData = self:GetCheerCurSelectUidList() or {}
  local curCount = 0
  local totalCount = 0
  curCount = table.count(curData)
  totalCount = table.count(allData)
  
  local function GetNotSelectUid()
    for _, v in pairs(allData) do
      local alreadyContains = false
      for _, j in pairs(curData) do
        if j == v.uid then
          alreadyContains = true
          break
        end
      end
      if not alreadyContains then
        return v.uid
      end
    end
  end
  
  if curCount < 2 and curCount < totalCount then
    local index = curCount
    while index <= 2 do
      if curData[index] == nil then
        local uid = GetNotSelectUid()
        if uid then
          table.insert(curData, uid)
        end
      end
      index = index + 1
    end
  end
  self:SetCheerAutoSelectUidList(curData)
  self:SetCheerCustomUidList(nil)
end

function ActivityTorchRelayData:SetCheerCustomUidList(list)
  self.customUidList = list
end

function ActivityTorchRelayData:SetCheerAutoSelectUidList(list)
  self.autoSelectUidList = list
end

function ActivityTorchRelayData:GetCheerAutoSelectUidList()
  return self.autoSelectUidList
end

function ActivityTorchRelayData:GetCheerCurSelectUidList()
  local custom = self:GetCheerCustomUidList()
  if custom ~= nil then
    return custom
  end
  local auto = self:GetCheerAutoSelectUidList()
  if auto ~= nil then
    return auto
  end
  return nil
end

function ActivityTorchRelayData:GetCheerCustomUidList()
  return self.customUidList
end

function ActivityTorchRelayData:IsCheering(uid)
  local uidList = self:GetCheerCurSelectUidList()
  if not uidList then
    return false
  end
  for i, v in ipairs(uidList) do
    if v == uid then
      return true
    end
  end
  return false
end

function ActivityTorchRelayData:RemoveCheerUid(uid)
  local curUids = self:GetCheerCurSelectUidList()
  if not curUids then
    return false
  end
  local count = #curUids
  for i = count, 1, -1 do
    if curUids[i] == uid then
      table.remove(curUids, i)
      break
    end
  end
  self:SetCheerCustomUidList(curUids)
  self:SetCheerAutoSelectUidList(nil)
end

function ActivityTorchRelayData:AddCheerUid(uid)
  local curUids = self:GetCheerCurSelectUidList() or {}
  table.insert(curUids, uid)
  self:SetCheerCustomUidList(curUids)
  self:SetCheerAutoSelectUidList(nil)
end

function ActivityTorchRelayData:SetScoreRecord(serverScore, selfRecord)
  self.serverScoreRecord = serverScore
  self.selfScoreRecord = selfRecord
end

return ActivityTorchRelayData
