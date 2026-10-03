local ActBattlePassInfo = BaseClass("ActBattlePassInfo")

local function __init(self)
  self.battlePass = {}
  self.battlePass.exp = 0
  self.battlePass.level = 0
  self.battlePass.unlock = 0
  self.battlePass.receiveNum = 0
  self.stateInfo = {}
  self.taskArr = {}
  self.infiniteNum = 0
  self.extraReward = {}
  self.costType = 0
  self.costValue = 0
  self.extraExp = 0
  self.activityId = 0
  self.exchangeId = ""
  self.lastResetTime = 0
  self.scoreId = 0
  self.battlePass.high_unlock = 0
  self.highExchangeId = ""
end

local function __delete(self)
end

local function ParseBattlePass(self, message, type)
  if message == nil then
    return
  end
  if message.exp ~= nil then
    self.battlePass.exp = message.exp
  end
  if message.level ~= nil then
    self.battlePass.level = message.level
  end
  if message.unlock then
    self.battlePass.unlock = message.unlock
  end
  if message.receiveNum then
    self.battlePass.receiveNum = message.receiveNum
  end
  if message.high_unlock then
    self.battlePass.high_unlock = message.high_unlock
  end
end

local function ParseStateInfo(self, message)
  if message == nil then
    return
  end
  self.stateInfo = {}
  for i = 1, #message do
    local level = message[i].level
    if level ~= 0 then
      local param = {}
      param.level = message[i].level
      param.normalState = message[i].normalState
      param.specialState = message[i].specialState
      param.hightRewardState = message[i].special2State or 0
      param.specialReward = DataCenter.RewardManager:ReturnRewardParamForView(message[i].specialReward)
      param.normalReward = DataCenter.RewardManager:ReturnRewardParamForView(message[i].normalReward)
      if message[i].special2Reward then
        param.highReward = DataCenter.RewardManager:ReturnRewardParamForView(message[i].special2Reward)
      else
        param.highReward = {}
      end
      table.insert(self.stateInfo, param)
    end
  end
end

local function ParseTaskArr(self, message, bpType)
  if message == nil then
    return
  end
  self.taskArr[1] = {}
  self.taskArr[2] = {}
  for i = 1, #message do
    local flag = true
    local param = {}
    param.taskId = message[i].taskId
    param.type = message[i].type
    param.num = message[i].num
    param.state = message[i].state
    param.exp = message[i].exp
    param.payExp = message[i].payExp
    param.startTime = message[i].startTime
    if bpType == EnumActivity.BattlePass_new.Type then
      param.taskInfo = DataCenter.ActivityTaskTemplateManager:GetActTaskTemplate(message[i].taskId)
      if param.taskInfo ~= nil then
        if string.IsNullOrEmpty(param.taskInfo.group) or param.taskInfo.group ~= "1" then
          param.type = 2
        else
          param.type = 1
        end
      else
        flag = false
      end
      param.bpType = bpType
      param.reward = DataCenter.RewardManager:ReturnRewardParamForMessage(message[i].freeReward)
      param.extraReward = DataCenter.RewardManager:ReturnRewardParamForMessage(message[i].payReward)
      param.scoreId = self.scoreId
      if self.scoreId > 0 then
        param.exp = 0
        param.payExp = 0
        local removeIndex
        if param.reward then
          for i = 1, #param.reward do
            if param.reward[i].rewardType == RewardType.GOODS and tonumber(param.reward[i].itemId) == self.scoreId then
              param.exp = param.reward[i].count
              removeIndex = i
              break
            end
          end
          if removeIndex ~= nil then
            table.remove(param.reward, removeIndex)
          end
        end
        removeIndex = nil
        if param.extraReward then
          for i = 1, #param.extraReward do
            if param.extraReward[i].rewardType == RewardType.GOODS and tonumber(param.extraReward[i].itemId) == self.scoreId then
              param.payExp = param.extraReward[i].count
              removeIndex = i
              break
            end
          end
          if removeIndex ~= nil then
            table.remove(param.extraReward, removeIndex)
          end
        end
      else
        param.exp = 0
        param.payExp = 0
      end
    else
      param.reward = DataCenter.RewardManager:ReturnRewardParamForMessage(message[i].reward)
      param.extraReward = DataCenter.RewardManager:ReturnRewardParamForMessage(message[i].extraReward)
    end
    if flag then
      if param.type == 1 then
        table.insert(self.taskArr[1], param)
      else
        table.insert(self.taskArr[2], param)
      end
    end
  end
  for i = 1, 2 do
    self:TaskSortHandle(i, bpType)
  end
end

local function TaskSortHandle(self, index, bpType)
  local list1 = {}
  local list2 = {}
  local list3 = {}
  local list4 = {}
  for i = #self.taskArr[index], 1, -1 do
    self.taskArr[index][i].bpType = bpType
    if self.taskArr[index][i].state == 1 then
      table.insert(list1, self.taskArr[index][i])
    elseif self.taskArr[index][i].state == 2 then
      if self.battlePass.unlock == 1 then
        if self.taskArr[index][i].payExp == 0 then
          table.insert(list3, self.taskArr[index][i])
        else
          table.insert(list1, self.taskArr[index][i])
        end
      else
        table.insert(list4, self.taskArr[index][i])
      end
    elseif self.taskArr[index][i].state == 0 then
      if self.taskArr[index][i] and self.taskArr[index][i].startTime then
        if self.taskArr[index][i].startTime > UITimeManager:GetInstance():GetServerTime() then
          table.insert(list2, self.taskArr[index][i])
        else
          table.insert(list2, 1, self.taskArr[index][i])
        end
      end
    elseif self.taskArr[index][i].state == 3 or bpType == EnumActivity.BattlePass_new.Type and self.taskArr[index][i].state == 4 then
      table.insert(list3, self.taskArr[index][i])
    end
  end
  self.taskArr[index] = {}
  list1 = self:SortTask(list1)
  list2 = self:SortTask(list2)
  list3 = self:SortTask(list3)
  list4 = self:SortTask(list4)
  for i = 1, #list1 do
    table.insert(list4, list1[i])
  end
  for i = 1, #list2 do
    table.insert(list4, list2[i])
  end
  for i = 1, #list3 do
    table.insert(list4, list3[i])
  end
  self.taskArr[index] = list4
end

local function SortTask(self, list)
  local taskData1, taskData2
  table.sort(list, function(a, b)
    if a.bpType == EnumActivity.BattlePass_new.Type then
      taskData1 = DataCenter.ActivityTaskTemplateManager:GetActTaskTemplate(a.taskId)
      taskData2 = DataCenter.ActivityTaskTemplateManager:GetActTaskTemplate(b.taskId)
    else
      taskData1 = DataCenter.QuestTemplateManager:GetQuestTemplate(a.taskId)
      taskData2 = DataCenter.QuestTemplateManager:GetQuestTemplate(b.taskId)
    end
    if taskData1.order > taskData2.order then
      return true
    elseif taskData1.order == taskData2.order then
      return false
    end
    return false
  end)
  return list
end

local function ParseOther(self, message)
  if message.extraReward then
    self.extraReward = DataCenter.RewardManager:ReturnRewardParamForMessage(message.extraReward)
  end
  if message.costType ~= nil then
    self.costType = message.costType
  end
  if message.costValue then
    self.costValue = message.costValue
  end
  if message.activityType then
    self.type = message.activityType
  end
  if message.extraExp then
    self.extraExp = message.extraExp
  end
  if message.exchangeId then
    self.exchangeId = message.exchangeId
  end
  if message.infiniteNum then
    self.infiniteNum = message.infiniteNum
  end
  if message.activityId then
    self.activityId = message.activityId
    local actData = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(self.activityId))
    if actData ~= nil then
      self.scoreId = tonumber(actData.para_5)
    end
  end
  if message.lastResetTime then
    self.lastResetTime = Mathf.Floor(message.lastResetTime / 1000)
  end
  if message.highExchangeId then
    self.highExchangeId = message.highExchangeId
  end
end

local function RefreshTaskState(self, message, taskArr, type)
  if message then
    local taskId = tonumber(message.taskId)
    for i = 1, #self.taskArr do
      for k = 1, #self.taskArr[i] do
        if self.taskArr[i][k].taskId == taskId then
          self.taskArr[i][k].state = message.state
          break
        end
      end
    end
  elseif taskArr then
    local taskId, startTime
    for i = 1, #taskArr do
      taskId = type == EnumActivity.BattlePass_new.Type and taskArr[i].id or taskArr[i].taskId
      startTime = type == EnumActivity.BattlePass_new.Type and taskArr[i].time or taskArr[i].taskId
      taskId = tonumber(taskId)
      for k = 1, #self.taskArr[1] do
        if taskId == self.taskArr[1][k].taskId then
          self.taskArr[1][k].num = taskArr[i].num
          self.taskArr[1][k].state = taskArr[i].state
        end
      end
      for k = 1, #self.taskArr[2] do
        if taskId == self.taskArr[2][k].taskId then
          self.taskArr[2][k].num = taskArr[i].num
          self.taskArr[2][k].state = taskArr[i].state
        end
      end
    end
    for i = 1, 2 do
      self:TaskSortHandle(i, type)
    end
  end
end

function ActBattlePassInfo:RefreshBP2TaskState(message, taskArr, type)
  for i = 1, #taskArr do
    for k = 1, #self.taskArr[1] do
      if taskArr[i].taskId == self.taskArr[1][k].taskId then
        self.taskArr[1][k].num = taskArr[i].num
        self.taskArr[1][k].startTime = taskArr[i].startTime
        self.taskArr[1][k].state = taskArr[i].state
      end
    end
    for k = 1, #self.taskArr[2] do
      if taskArr[i].taskId == self.taskArr[2][k].taskId then
        self.taskArr[2][k].num = taskArr[i].num
        self.taskArr[2][k].startTime = taskArr[i].startTime
        self.taskArr[2][k].state = taskArr[i].state
      end
    end
  end
  for i = 1, 2 do
    self:TaskSortHandle(i, type)
  end
end

local function RefreshStageState(self, message)
  for i = 1, #self.stateInfo do
    if self.stateInfo[i].level == message.level then
      if message.type == 0 then
        self.stateInfo[i].normalState = 1
      elseif message.type == 1 then
        self.stateInfo[i].normalState = 1
        self.stateInfo[i].specialState = 1
      elseif message.type == 2 then
        self.stateInfo[i].normalState = 1
        self.stateInfo[i].specialState = 1
        self.stateInfo[i].hightRewardState = 1
      end
      if message.normalState then
        self.stateInfo[i].normalState = message.normalState
      end
      if message.specialState then
        self.stateInfo[i].specialState = message.specialState
      end
      if message.special2State then
        self.stateInfo[i].hightRewardState = message.special2State
      end
      break
    end
  end
end

local function GetExchangeId(self)
  return self.exchangeId
end

local function GetRedNum(self, type)
  local actData = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(self.activityId))
  if actData == nil then
    return 0
  end
  if type == 1 or type == 3 then
    return 0
  end
  local subType = actData.subViewType
  if subType == BattlePassType.SevenDayLogin or subType == BattlePassType.NewYearSevenDayLogin or subType == BattlePassType.ValentineLogin then
    local num = 0
    for i = 1, #self.stateInfo do
      if self.stateInfo[i].level <= self.battlePass.level then
        if self.stateInfo[i].normalState == 0 then
          num = num + 1
        end
        if self.battlePass.unlock == 1 and self.stateInfo[i].specialState == 0 then
          num = num + 1
        end
      end
    end
    return num
  elseif subType == BattlePassType.ActSevenDay then
    local num = 0
    for i = 1, #self.stateInfo do
      if self.stateInfo[i].level <= self.battlePass.level then
        if self.stateInfo[i].normalState == 0 then
          num = num + 1
        end
        if self.battlePass.unlock == 1 and self.stateInfo[i].specialState == 0 then
          num = num + 1
        end
      end
    end
    local nextTemplate = DataCenter.ActBattlePassTemplateManager:GetTemplateById(self.activityId, self.battlePass.level + 1)
    if nextTemplate == nil and 0 < self.extraExp then
      num = num + Mathf.Floor(self.battlePass.exp / self.extraExp)
    end
    return num
  else
    local num = 0
    for i = 1, #self.stateInfo do
      local haveHighPayReward = self:HaveHighPayStage()
      if self.stateInfo[i].level <= self.battlePass.level then
        if self.stateInfo[i].normalState == 0 then
          num = num + 1
        end
        if self.battlePass.unlock == 1 and self.stateInfo[i].specialState == 0 then
          num = num + 1
        end
        if haveHighPayReward and self.battlePass.high_unlock == 1 and self.stateInfo[i].hightRewardState == 0 then
          num = num + 1
        end
      end
    end
    local nextTemplate = DataCenter.ActBattlePassTemplateManager:GetTemplateById(self.activityId, self.battlePass.level + 1, actData.type)
    if nextTemplate == nil and 0 < self.extraExp then
      local exp
      if self.type == EnumActivity.BattlePass_new.Type then
        local allExp = self.extraExp * self.infiniteNum
        exp = self.battlePass.exp - allExp
      else
        exp = self.battlePass.exp
      end
      num = num + Mathf.Floor(exp / self.extraExp)
    end
    if type == 1 then
      return num
    elseif type == 2 then
      num = 0
    end
    for k = 1, #self.taskArr[1] do
      if self.taskArr[1][k].state == 1 then
        num = num + 1
        if self.battlePass.unlock == 1 and self.taskArr[1][k].payExp ~= 0 then
          num = num + 1
        end
      elseif self.taskArr[1][k].state == 2 and self.battlePass.unlock == 1 and self.taskArr[1][k].payExp ~= 0 then
        num = num + 1
      end
    end
    if type == 2 then
      return num
    elseif type == 3 then
      num = 0
    end
    for k = 1, #self.taskArr[2] do
      if self.taskArr[2][k].state == 1 then
        num = num + 1
        if self.battlePass.unlock == 1 and self.taskArr[2][k].payExp ~= 0 then
          num = num + 1
        end
      elseif self.taskArr[2][k].state == 2 and self.battlePass.unlock == 1 and self.taskArr[2][k].payExp ~= 0 then
        num = num + 1
      end
    end
    if type == 3 then
      return num
    end
    return num
  end
  return 0
end

local function CheckCurGetReward(self)
  local normalState = {}
  local specialState = {}
  local hightPayState = {}
  local haveHightPayStage = self:HaveHighPayStage()
  for i = 1, #self.stateInfo do
    if self.stateInfo[i].level <= self.battlePass.level then
      if self.stateInfo[i].normalState == 0 then
        table.insert(normalState, i)
      end
      if self.battlePass.unlock == 1 and self.stateInfo[i].specialState == 0 then
        table.insert(specialState, i)
      end
      if haveHightPayStage and self.stateInfo[i].high_unlock == 1 and self.stateInfo[i].hightRewardState == 0 then
        table.insert(hightPayState, i)
      end
    end
  end
  local index = self.battlePass.level
  if next(normalState) then
    index = normalState[1]
  end
  if next(specialState) and index > specialState[1] then
    index = specialState[1]
  end
  if next(hightPayState) and index > hightPayState[1] then
    index = hightPayState[1]
  end
  return index
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

local function CheckLvGetReward(self, minLv, lv, isValuable)
  local rewardList = {}
  local free = {}
  local valuable = {}
  if isValuable then
    lv = #self.stateInfo
  end
  for i = minLv, #self.stateInfo do
    if lv >= self.stateInfo[i].level then
      table.insert(free, self.stateInfo[i].normalReward[1])
      table.insert(valuable, self.stateInfo[i].specialReward[1])
      table.insert(valuable, self.stateInfo[i].specialReward[2])
    end
  end
  local temp = {}
  ProcessData(self, free, temp)
  if isValuable then
    temp = {}
  end
  if self.battlePass.unlock == 1 or isValuable then
    ProcessData(self, valuable, temp)
    for i, v in pairs(temp) do
      table.insert(rewardList, v)
    end
    self:SortItem(rewardList)
  elseif self.battlePass.unlock == 0 then
    for i, v in pairs(temp) do
      table.insert(rewardList, v)
    end
    self:SortItem(rewardList)
  end
  return rewardList
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

local function GetCurrentAccumulatedExp(self)
  if self.activityId <= 0 then
    return 0
  end
  local exp = 0
  if self.battlePass.level == 0 then
    return self.battlePass.exp
  end
  for i = 0, self.battlePass.level - 1 do
    local needExp = DataCenter.ActBattlePassTemplateManager:GetLevelNeedExp(self.activityId, i, self.type)
    exp = exp + needExp
  end
  exp = exp + self.battlePass.exp
  exp = exp + self.extraExp * self.battlePass.receiveNum
  return exp
end

local function IsHaveExtraReward(self)
  local isHave = true
  if self.extraReward == nil or #self.extraReward == 0 then
    isHave = false
  end
  return isHave
end

local function GetHighExchangeId(self)
  return self.highExchangeId
end

local function HaveHighPayStage(self)
  return string.IsNullOrEmpty(self:GetHighExchangeId()) == false
end

local function CheckLvGetRewardHighBP(self, minLv, lv, valuableType)
  local rewardList = {}
  local free = {}
  local valuable = {}
  local highValuable = {}
  local allRewardList = {}
  local willGetFree = {}
  local willGetValuable = {}
  local willGetHighValuable = {}
  local freeCount = 1
  local valuableCount = 1
  local highValuableCount = 1
  local willGetFreeCount = 1
  local willGetValuableCount = 1
  local willGetHighValuableCount = 1
  for i = minLv, #self.stateInfo do
    if lv >= self.stateInfo[i].level then
      free[freeCount] = self.stateInfo[i].normalReward[1]
      freeCount = freeCount + 1
      valuable[valuableCount] = self.stateInfo[i].specialReward[1]
      valuableCount = valuableCount + 1
      valuable[valuableCount] = self.stateInfo[i].specialReward[2]
      valuableCount = valuableCount + 1
      highValuable[highValuableCount] = self.stateInfo[i].highReward[1]
      highValuableCount = highValuableCount + 1
      highValuable[highValuableCount] = self.stateInfo[i].highReward[2]
      highValuableCount = highValuableCount + 1
    else
      willGetFree[willGetFreeCount] = self.stateInfo[i].normalReward[1]
      willGetFreeCount = willGetFreeCount + 1
      willGetValuable[willGetValuableCount] = self.stateInfo[i].specialReward[1]
      willGetValuableCount = willGetValuableCount + 1
      willGetValuable[willGetValuableCount] = self.stateInfo[i].specialReward[2]
      willGetValuableCount = willGetValuableCount + 1
      willGetHighValuable[willGetHighValuableCount] = self.stateInfo[i].highReward[1]
      willGetHighValuableCount = willGetHighValuableCount + 1
      willGetHighValuable[willGetHighValuableCount] = self.stateInfo[i].highReward[2]
      willGetHighValuableCount = willGetHighValuableCount + 1
    end
  end
  local temp = {}
  ProcessData(self, free, temp)
  if 0 < valuableType then
    temp = {}
    if valuableType == 2 then
      ProcessData(self, highValuable, temp)
      local count = 1
      for i, v in pairs(temp) do
        rewardList[count] = DeepCopy(v)
        count = count + 1
      end
      ProcessData(self, willGetHighValuable, temp)
      count = 1
      for i, v in pairs(temp) do
        allRewardList[count] = DeepCopy(v)
        count = count + 1
      end
    elseif valuableType == 1 then
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
    if self.battlePass.high_unlock == 1 then
      ProcessData(self, highValuable, temp)
    end
    if self.battlePass.unlock == 1 then
      ProcessData(self, valuable, temp)
    end
    local count = 1
    for i, v in pairs(temp) do
      rewardList[count] = DeepCopy(v)
      count = count + 1
    end
    self:SortItem(rewardList)
  end
  return rewardList, allRewardList
end

ActBattlePassInfo.__init = __init
ActBattlePassInfo.__delete = __delete
ActBattlePassInfo.ParseBattlePass = ParseBattlePass
ActBattlePassInfo.ParseStateInfo = ParseStateInfo
ActBattlePassInfo.ParseTaskArr = ParseTaskArr
ActBattlePassInfo.TaskSortHandle = TaskSortHandle
ActBattlePassInfo.ParseOther = ParseOther
ActBattlePassInfo.RefreshTaskState = RefreshTaskState
ActBattlePassInfo.RefreshStageState = RefreshStageState
ActBattlePassInfo.GetExchangeId = GetExchangeId
ActBattlePassInfo.GetRedNum = GetRedNum
ActBattlePassInfo.CheckCurGetReward = CheckCurGetReward
ActBattlePassInfo.CheckLvGetReward = CheckLvGetReward
ActBattlePassInfo.SortTask = SortTask
ActBattlePassInfo.SortItem = SortItem
ActBattlePassInfo.GetCurrentAccumulatedExp = GetCurrentAccumulatedExp
ActBattlePassInfo.IsHaveExtraReward = IsHaveExtraReward
ActBattlePassInfo.GetHighExchangeId = GetHighExchangeId
ActBattlePassInfo.HaveHighPayStage = HaveHighPayStage
ActBattlePassInfo.CheckLvGetRewardHighBP = CheckLvGetRewardHighBP
return ActBattlePassInfo
