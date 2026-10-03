local ActSunriseFoundationData = BaseClass("ActSunriseFoundationData")

local function __init(self)
  self.activityId = 0
  self.unlock = 0
  self.rewardArr = {}
  self.exchangeId = 0
end

local function __delete(self)
  self.activityId = nil
  self.unlock = nil
  self.rewardArr = nil
  self.exchangeId = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.activityId ~= nil then
    self.activityId = message.activityId
  end
  if message.unlock ~= nil then
    self.unlock = message.unlock
  end
  if message.rewardArr ~= nil then
    self.rewardArr = message.rewardArr
  end
  if message.exchangeId ~= nil then
    self.exchangeId = message.exchangeId
  end
end

local function GetRedNum(self)
  local redNum = 0
  local rewardNum, freeRewardNum, specRewardNum = self:GetCanRewardNum()
  return specRewardNum
end

local function GetCanRewardNum(self)
  local freeRewardNum = 0
  local specRewardNum = 0
  local curLv = DataCenter.BuildManager.MainLv or 0
  local rewardArr = self.rewardArr
  local buyState = self.unlock == 1
  if rewardArr and 0 < #rewardArr then
    for i = 1, #rewardArr do
      local data = rewardArr[i]
      local itemLv = data.level
      if curLv >= itemLv then
        local rewardFlag = data.rewardFlag
        if rewardFlag == 0 then
          freeRewardNum = freeRewardNum + 1
        end
        if buyState then
          local specialRewardFlag = data.specialRewardFlag
          if specialRewardFlag == 0 then
            specRewardNum = specRewardNum + 1
          end
        end
      end
    end
  end
  local totalNum = freeRewardNum + specRewardNum
  return totalNum, freeRewardNum, specRewardNum
end

local function ProcessData(self, srcList, dstList)
  if table.IsNullOrEmpty(srcList) or dstList == nil then
    return
  end
  for i = 1, #srcList do
    if srcList[i] then
      if dstList[srcList[i].itemId] then
        dstList[srcList[i].itemId].count = dstList[srcList[i].itemId].count + srcList[i].count
      else
        dstList[srcList[i].itemId] = {}
        dstList[srcList[i].itemId].color = DataCenter.RewardManager:GetRewardQuality(srcList[i].rewardType, srcList[i].itemId)
        if srcList[i].rewardType == RewardType.GOODS then
          local goods = DataCenter.ItemTemplateManager:GetItemTemplate(srcList[i].itemId)
          if goods.type == GOODS_TYPE.GOODS_TYPE_99 then
            dstList[srcList[i].itemId].order = 1
          elseif goods.type == GOODS_TYPE.GOODS_TYPE_62 then
            dstList[srcList[i].itemId].order = 2
          elseif tonumber(srcList[i].itemId) == 230007 then
            dstList[srcList[i].itemId].order = 3
          else
            dstList[srcList[i].itemId].color = goods.color
            dstList[srcList[i].itemId].order = goods.order
          end
        elseif srcList[i].rewardType == RewardType.GOLD then
          dstList[srcList[i].itemId].order = 1
        elseif srcList[i].rewardType == RewardType.EXP then
          dstList[srcList[i].itemId].order = 1
        elseif srcList[i].rewardType == RewardType.RESOURCE_ITEM then
          dstList[srcList[i].itemId].order = 1
        else
          dstList[srcList[i].itemId].order = 1
        end
        dstList[srcList[i].itemId].count = srcList[i].count
        dstList[srcList[i].itemId].rewardType = srcList[i].rewardType
        dstList[srcList[i].itemId].itemId = srcList[i].itemId
      end
    end
  end
end

local function SortItem(self, item, isPop)
  if isPop then
    table.sort(item, function(a, b)
      if a.color > b.color then
        return true
      elseif a.color == b.color then
        if a.count and b.count then
          if a.count > b.count then
            return true
          elseif a.count == b.count then
            return a.order > b.order
          end
        elseif a.count then
          return true
        elseif b.count then
          return false
        end
      end
      return false
    end)
  else
    table.sort(item, function(a, b)
      if a.color > b.color then
        return true
      elseif a.color == b.color then
        if a.order < b.order then
          return true
        elseif a.count and b.count and a.order == b.order then
          return a.count > b.count
        end
      end
      return false
    end)
  end
end

local function CheckLvGetReward(self, minLv, lv, valuableType)
  local rewardList = {}
  local free = {}
  local valuable = {}
  local allRewardList = {}
  local willGetFree = {}
  local willGetValuable = {}
  local freeCount = 1
  local valuableCount = 1
  local willGetFreeCount = 1
  local willGetValuableCount = 1
  for i = minLv, #self.rewardArr do
    local rewardData = DataCenter.RewardManager:ReturnRewardParamForView(self.rewardArr[i].reward)
    local specialRewardData = DataCenter.RewardManager:ReturnRewardParamForView(self.rewardArr[i].specialReward)
    if lv >= self.rewardArr[i].level then
      free[freeCount] = rewardData[1]
      freeCount = freeCount + 1
      valuable[valuableCount] = specialRewardData[1]
      valuableCount = valuableCount + 1
      valuable[valuableCount] = specialRewardData[2]
      valuableCount = valuableCount + 1
    else
      willGetFree[willGetFreeCount] = rewardData[1]
      willGetFreeCount = willGetFreeCount + 1
      willGetValuable[willGetValuableCount] = specialRewardData[1]
      willGetValuableCount = willGetValuableCount + 1
      willGetValuable[willGetValuableCount] = specialRewardData[2]
      willGetValuableCount = willGetValuableCount + 1
    end
  end
  local temp = {}
  ProcessData(self, free, temp)
  if 0 < valuableType then
    temp = {}
    if valuableType == 1 then
      ProcessData(self, valuable, temp)
      local count = 1
      for i, v in pairs(temp) do
        rewardList[count] = DeepCopy(v)
        count = count + 1
      end
      ProcessData(self, willGetValuable, temp)
      count = 1
      for i, v in pairs(temp) do
        allRewardList[count] = DeepCopy(v)
        count = count + 1
      end
    end
    self:SortItem(rewardList)
    self:SortItem(allRewardList)
  else
    local count = 1
    for i, v in pairs(temp) do
      rewardList[count] = DeepCopy(v)
      count = count + 1
    end
    self:SortItem(rewardList)
  end
  return rewardList, allRewardList
end

ActSunriseFoundationData.__init = __init
ActSunriseFoundationData.__delete = __delete
ActSunriseFoundationData.ParseData = ParseData
ActSunriseFoundationData.GetRedNum = GetRedNum
ActSunriseFoundationData.GetCanRewardNum = GetCanRewardNum
ActSunriseFoundationData.ProcessData = ProcessData
ActSunriseFoundationData.SortItem = SortItem
ActSunriseFoundationData.CheckLvGetReward = CheckLvGetReward
return ActSunriseFoundationData
