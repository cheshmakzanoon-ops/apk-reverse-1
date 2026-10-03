local LWOptionalWeekCardInfo = BaseClass("LWOptionalWeekCardInfo")

function LWOptionalWeekCardInfo:__init()
  self.cardId = 0
  self.alreadyBuy = false
  self.startTime = 0
  self.endTime = 0
  self.lastReceiveTime = 0
  self.optionalRewardDic = {}
  self.gridIndex2RewardIndex = {}
  self.name = ""
  self.exchangeId = 0
  self.percent = 0
  self.optionalNum = 0
  self.validDays = 0
  self.forwardBuy = 0
  self.regularRewardList = {}
  self.optionalShowRewardList = {}
  self.order = 0
  self.alreadyReward = 0
  self.totalReward = 0
end

function LWOptionalWeekCardInfo:__delete()
  self.cardId = nil
  self.alreadyBuy = nil
  self.startTime = nil
  self.endTime = nil
  self.lastReceiveTime = nil
  self.optionalRewardDic = nil
  self.gridIndex2RewardIndex = nil
  self.name = nil
  self.exchangeId = nil
  self.percent = nil
  self.optionalNum = nil
  self.validDays = nil
  self.forwardBuy = nil
  self.regularRewardList = nil
  self.optionalShowRewardList = nil
  self.order = nil
  self.alreadyReward = nil
  self.totalReward = nil
end

function LWOptionalWeekCardInfo:InitData(message, isInit)
  if message.id then
    self.cardId = message.id
  end
  if self.cardId ~= 0 then
    local lineData = LocalController:instance():getLine(TableName.WeekCard, self.cardId)
    if lineData ~= nil then
      self.name = lineData.name
      self.exchangeId = lineData.exchange_id
      self.optionalNum = string.IsNullOrEmpty(lineData.optional_num) and 0 or tonumber(lineData.optional_num)
      self.percent = string.IsNullOrEmpty(lineData.percent) and 0 or tonumber(lineData.percent)
      local time = tonumber(lineData.time)
      if 0 < time then
        self.validDays = math.floor(time / 60 / 24)
      end
      self.forwardBuy = string.IsNullOrEmpty(lineData.forwardbuy) and 0 or tonumber(lineData.forwardbuy)
      self.order = string.IsNullOrEmpty(lineData.order) and 0 or tonumber(lineData.order)
      self.init_optional_list = lineData.init_optional_list or ""
    end
  end
  if message.state then
    local state = message.state
    self.alreadyBuy = 0 < state
  end
  if message.startTime then
    self.startTime = message.startTime
  end
  if message.endTime then
    self.endTime = message.endTime
  end
  if message.lastReceiveTime then
    self.lastReceiveTime = message.lastReceiveTime
  end
  if message.optionalReward then
    self.optionalRewardDic = {}
    local rewardArray = string.split(message.optionalReward, "|")
    if not string.IsNullOrEmpty(rewardArray) then
      for i = 1, #rewardArray do
        local rewardStr = rewardArray[i]
        local rewardData = DataCenter.RewardManager:ParseOneRewardStr(rewardStr)
        if rewardData then
          self.optionalRewardDic[i] = rewardData
        end
      end
    end
  elseif isInit then
    local initialRewardDict = self:GetaDefaultChooseReward()
    for i = 1, self.optionalNum do
      self.gridIndex2RewardIndex[i] = -1
    end
    if initialRewardDict then
      for i = 1, #initialRewardDict do
        self:SetSelectRewardIndex(initialRewardDict[i], true)
      end
    end
  end
  if message.alreadyReward then
    self.alreadyReward = message.alreadyReward
  end
  if message.totalReward then
    self.totalReward = message.totalReward
  end
end

local dayTime = 86400000

function LWOptionalWeekCardInfo:GetLastReceiveTime()
  local days = dayTime * self.alreadyReward or 0
  return self.startTime + days
end

function LWOptionalWeekCardInfo:GetCanReceiveReward()
  local canReceiveCount = self:GetCanReceiveCount()
  return 0 < canReceiveCount
end

function LWOptionalWeekCardInfo:GetRegularReward()
  if table.IsNullOrEmpty(self.regularRewardList) then
    local lineData = LocalController:instance():getLine(TableName.WeekCard, self.cardId)
    if lineData ~= nil then
      local regularArray = string.split(lineData.regular_list_c, "|")
      if not string.IsNullOrEmpty(regularArray) then
        for i = 1, #regularArray do
          local rewardStr = regularArray[i]
          local rewardData = DataCenter.RewardManager:ParseOneRewardStr(rewardStr)
          if rewardData then
            table.insert(self.regularRewardList, rewardData)
          end
        end
      end
    end
  end
  return self.regularRewardList
end

function LWOptionalWeekCardInfo:GetAlreadyChooseReward()
  return self.optionalRewardDic
end

function LWOptionalWeekCardInfo:GetAlreadyChooseRewardCount()
  local totalCount = 0
  for i, rewardData in pairs(self.optionalRewardDic) do
    if rewardData ~= nil then
      totalCount = totalCount + 1
    end
  end
  return totalCount
end

function LWOptionalWeekCardInfo:GetOptionalShowReward()
  if table.IsNullOrEmpty(self.optionalShowRewardList) then
    local lineData = LocalController:instance():getLine(TableName.WeekCard, self.cardId)
    if lineData ~= nil then
      local regularArray = string.split(lineData.optional_list_c, "|")
      if not string.IsNullOrEmpty(regularArray) then
        for i = 1, #regularArray do
          local rewardStr = regularArray[i]
          local rewardData = DataCenter.RewardManager:ParseOneRewardStr(rewardStr)
          if rewardData then
            table.insert(self.optionalShowRewardList, rewardData)
          end
        end
      end
    end
  end
  return self.optionalShowRewardList
end

function LWOptionalWeekCardInfo:SetSelectRewardIndex(rewardIndex, isAdd)
  local optionalShowRewardList = self:GetOptionalShowReward()
  local targetGridIndex = 0
  if isAdd then
    for gridIndex, rewardData in pairs(self.gridIndex2RewardIndex) do
      if rewardData == -1 then
        targetGridIndex = gridIndex
        break
      end
    end
    if self.gridIndex2RewardIndex[targetGridIndex] then
      self.gridIndex2RewardIndex[targetGridIndex] = rewardIndex
      if optionalShowRewardList[rewardIndex] then
        local reward = optionalShowRewardList[rewardIndex]
        self.optionalRewardDic[targetGridIndex] = reward
      end
    end
  else
    for gridIndex, rewardData in pairs(self.gridIndex2RewardIndex) do
      if rewardData == rewardIndex then
        targetGridIndex = gridIndex
        break
      end
    end
    self:DeleteReward(targetGridIndex)
  end
end

function LWOptionalWeekCardInfo:DeleteReward(targetGridIndex)
  if self.gridIndex2RewardIndex[targetGridIndex] then
    self.gridIndex2RewardIndex[targetGridIndex] = -1
    self.optionalRewardDic[targetGridIndex] = nil
  end
end

function LWOptionalWeekCardInfo:IsSelectReward(rewardIndex)
  for gridIndex, rewardData in pairs(self.gridIndex2RewardIndex) do
    if rewardData == rewardIndex then
      return true
    end
  end
  return false
end

function LWOptionalWeekCardInfo:GetSelectRewardIndexArray()
  local rewardArray = {}
  for gridIndex, rewardIndex in pairs(self.gridIndex2RewardIndex) do
    table.insert(rewardArray, rewardIndex - 1)
  end
  return rewardArray
end

function LWOptionalWeekCardInfo:GetaDefaultChooseReward()
  if table.IsNullOrEmpty(self.defaultChooseRewardList) then
    self.defaultChooseRewardList = {}
    local lineData = LocalController:instance():getLine(TableName.WeekCard, self.cardId)
    if lineData ~= nil and not string.IsNullOrEmpty(lineData.init_optional_list) then
      local defaultRewards = string.split(lineData.init_optional_list, "|")
      if not table.IsNullOrEmpty(defaultRewards) then
        local optionalRewards = self:GetOptionalShowReward()
        
        local function getrewardInRewardArrayIndex(itemId, itemType, itemNum, rewards)
          for i = 1, #rewards do
            local reward = rewards[i]
            if reward.itemId == itemId and reward.rewardType == itemType and reward.count == itemNum then
              return i
            end
          end
          return nil
        end
        
        for i = 1, #defaultRewards do
          local defaultReward = defaultRewards[i]
          local rewardData = string.split(defaultReward, ";")
          if not table.IsNullOrEmpty(rewardData) and 3 <= #rewardData then
            local itemId = tonumber(rewardData[1])
            local itemType = tonumber(rewardData[2])
            local itemNum = tonumber(rewardData[3])
            local index = getrewardInRewardArrayIndex(itemId, itemType, itemNum, optionalRewards)
            if index then
              table.insert(self.defaultChooseRewardList, index)
            end
          end
        end
      end
    end
  end
  return self.defaultChooseRewardList
end

function LWOptionalWeekCardInfo:GetCanReceiveCount()
  if not self.alreadyBuy then
    return 0
  end
  if not self.startTime then
    return 0
  end
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  if not self.endTime or serverTime >= self.endTime then
    return false
  end
  local nowTime = UITimeManager:GetInstance():GetServerTime()
  local canReceiveCount = math.ceil((nowTime - self.startTime) / dayTime)
  canReceiveCount = canReceiveCount - self.alreadyReward or 0
  if canReceiveCount > self.totalReward then
    canReceiveCount = self.totalReward
  end
  return canReceiveCount
end

return LWOptionalWeekCardInfo
