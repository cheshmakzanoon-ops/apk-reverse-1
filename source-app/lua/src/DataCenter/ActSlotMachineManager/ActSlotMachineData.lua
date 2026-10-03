local ActSlotMachineData = BaseClass("ActSlotMachineData")
local ActivityFreeRewardData = require("DataCenter.ActivityFreeRewardData.ActivityFreeRewardData")
local ActivitySlotsInfoTemplate = require("DataCenter.ActSlotMachineManager.ActivitySlotsInfoTemplate")

local function __init(self)
  self.activityId = 0
  self.rewardProcessDict = {}
  self.totalScore = 0
  self.dayTimes = 0
  self.lastLotteryFreeTime = 0
  self.lastReceiveFreeTime = 0
  self.backUpTimes = 0
  self.boxArr = {}
  self.taskArr = {}
  self.eventBox = {}
  self.taskArrData = {}
  self.dayReward = {}
  self.activityFreeRewardData = ActivityFreeRewardData.New()
  self.infoTempId = 0
  self.infoTemp = nil
  self.historyData = {}
  self.historyDayArr = {}
  self.historyDataNeedRefresh = true
  self.blueBoxArr = {}
  self.purpleBoxArr = {}
  self.orangeBoxArr = {}
  self.indexArr = {}
  self.rewardArr = {}
  self.qualityArr = {}
end

local function __delete(self)
  self.activityId = nil
  self.rewardProcessDict = nil
  self.totalScore = nil
  self.dayTimes = nil
  self.lastLotteryFreeTime = nil
  self.lastReceiveFreeTime = nil
  self.backUpTimes = nil
  self.boxArr = nil
  self.taskArr = nil
  self.eventBox = nil
  self.taskArrData = nil
  self.dayReward = nil
  self.activityFreeRewardData = nil
  self.infoTempId = nil
  self.infoTemp = nil
  self.historyData = nil
  self.historyDayArr = nil
  self.historyDataNeedRefresh = nil
  self.blueBoxArr = nil
  self.purpleBoxArr = nil
  self.orangeBoxArr = nil
  self.indexArr = nil
  self.rewardArr = nil
  self.qualityArr = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.activityId ~= nil then
    self.activityId = message.activityId
  end
  if message.rewardProcess ~= nil then
    self.rewardProcessDict = {}
    for k, v in pairs(message.rewardProcess) do
      self.rewardProcessDict[v] = 1
    end
  end
  if message.totalScore ~= nil then
    self.totalScore = message.totalScore
  end
  if message.dayTimes ~= nil then
    self.dayTimes = message.dayTimes
  end
  if message.lastLotteryFreeTime ~= nil then
    self.lastLotteryFreeTime = message.lastLotteryFreeTime
  end
  if message.lastReceiveFreeTime ~= nil then
    self.lastReceiveFreeTime = message.lastReceiveFreeTime
  end
  if message.dayReward ~= nil then
    self.dayReward = message.dayReward
  end
  if message.multiple ~= nil then
    self.multiple = message.multiple
  end
  if message.reward ~= nil then
    self.reward = message.reward
  end
  if message.boxArr ~= nil then
    self.eventBox = message.boxArr
  end
  if message.taskArr ~= nil then
    self.taskArr = message.taskArr
    self.taskArrData = {}
    for k, v in pairs(self.taskArr) do
      local taskTemp = DataCenter.ActivityTaskTemplateManager:GetActTaskTemplate(v.taskId)
      local taskData = {data = v, temp = taskTemp}
      table.insert(self.taskArrData, taskData)
    end
    table.sort(self.taskArrData, function(a, b)
      if a.temp.order ~= b.temp.order then
        return a.temp.order < b.temp.order
      end
      return a.temp.id < b.temp.id
    end)
  end
  self.infoTempId = LocalController:instance():getLine(TableName.Activity, toInt(self.activityId)).tableInfoType
  local line = LocalController:instance():getLine(TableName.ActivitySlotsInfo, toInt(self.infoTempId))
  self.infoTemp = ActivitySlotsInfoTemplate.New()
  self.infoTemp:InitData(line)
  self:UpdateActivityFreeRewardData()
  self:SetHistoryLodDataDirty()
end

local function UpdateDailyRewardData(self, message)
  if message.lastReceiveFreeTime ~= nil then
    self.lastReceiveFreeTime = message.lastReceiveFreeTime
  end
  self:UpdateActivityFreeRewardData()
end

local function UpdateActivityFreeRewardData(self)
  self.activityFreeRewardData.activityId = self.activityId
  self.activityFreeRewardData.freeReward = DataCenter.RewardManager:ReturnRewardParamForView(self.dayReward)
  self.activityFreeRewardData.lastReceiveFreeTime = self.lastReceiveFreeTime
  self.rewardPackGroupId = self:GetGiftPackId()
end

local function CanGetDailyReward(self)
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local result = not UITimeManager:GetInstance():IsSameDayForServer(self.lastReceiveFreeTime / 1000, curTime)
  return result
end

local function CanGetFreePack(self)
  return self:CanGetDailyReward()
end

local function CanGotoPackShop(self)
  local canGetFreePack = self:CanGetFreePack()
  if canGetFreePack then
    return true
  end
  local rewardPackGroupId = self:GetGiftPackId()
  local packs = GiftPackManager.GetPacksByGroupId(rewardPackGroupId, false)
  return not table.IsNullOrEmpty(packs)
end

local function GetGiftPackId(self)
  local rewardPackGroupId = 0
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  local dataStr = activityInfo.para_6
  local dataArr = string.string2array_i_oneSep(dataStr, ";")
  if #dataArr == 2 then
    rewardPackGroupId = dataArr[2]
  end
  return rewardPackGroupId
end

local function GetRedNum(self)
  local num = 0
  local tipNum = 0
  if self:CanGetFreePack() then
    num = num + 1
  end
  local progressNum = self:GetProgressRewardNum()
  num = num + progressNum
  local taskShowData = self.taskArrData
  local taskGetNum = 0
  for k, v in ipairs(taskShowData) do
    if v.data.state ~= TaskState.Received then
      if v.data.state == TaskState.CanReceive then
        taskGetNum = taskGetNum + 1
      end
      break
    end
  end
  num = num + taskGetNum
  local infoTemp = self.infoTemp
  local bpId = tonumber(infoTemp.bp_id) or 0
  local _, bpNum, bpTipNum = DataCenter.ActivityListDataManager:GetRewardNumByTypeAndId(EnumActivity.BattlePass_new.Type, bpId)
  num = num + bpNum
  tipNum = tipNum + bpTipNum
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  local jumpTo = activityInfo:GetFirstActiveJumpTo()
  local _, changeNum, changeTipNum = DataCenter.ActivityListDataManager:GetRewardNumByTypeAndId(EnumActivity.CitySkinExchange.Type, jumpTo)
  num = num + changeNum
  tipNum = tipNum + changeTipNum
  return num + tipNum, num, tipNum
end

local function UpdateLotteyMessage(self, message)
  self.totalScore = message.totalScore
  self.dayTimes = message.dayTimes
  if message.lastLotteryFreeTime then
    self.lastLotteryFreeTime = message.lastLotteryFreeTime
  end
  if message.eventBox then
    table.insert(self.eventBox, message.eventBox)
  end
  self:SetHistoryLodDataDirty()
end

local function UpdateBoxMessage(self, message)
  for k, v in pairs(self.eventBox) do
    if v.uuid == message.uuid then
      self.eventBox[k] = message
      break
    end
  end
  self:SetHistoryLodDataDirty()
end

local function RemoveBoxUuid(self, uuid)
  local targetIndex = -1
  for k, v in pairs(self.eventBox) do
    if v.uuid == uuid then
      targetIndex = k
      break
    end
  end
  if 0 < targetIndex then
    table.remove(self.eventBox, targetIndex)
  end
end

local function UpdateProgressRewardMessage(self, message)
  if message.rewardProcess ~= nil then
    self.rewardProcessDict = {}
    for k, v in pairs(message.rewardProcess) do
      self.rewardProcessDict[v] = 1
    end
  end
  if message.totalScore then
    self.totalScore = message.totalScore
  end
end

local function GetOneTaskReward(self, message)
  for k, v in ipairs(self.taskArrData) do
    if v.data.taskId == message.taskId then
      v.data.state = TaskState.Received
      break
    end
  end
end

local function IsHaveFreeLottery(self)
  local isCfgHaveFree = self.infoTemp.cost_1_free > 0
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local result = not UITimeManager:GetInstance():IsSameDayForServer(self.lastLotteryFreeTime / 1000, curTime)
  return isCfgHaveFree and result
end

local function UpdateActTasks(self, message)
  local updateTaskList = message.a_task
  if updateTaskList and 0 < #updateTaskList then
    for k, v in pairs(updateTaskList) do
      local taskId = v.id
      for taskIndex, taskData in ipairs(self.taskArrData) do
        if taskData.data.taskId == taskId then
          taskData.data.num = v.num
          taskData.data.state = v.state
          break
        end
      end
    end
  end
end

local function GetProgressRewardNum(self)
  local num = 0
  local curNum = self.totalScore
  local infoTemp = self.infoTemp
  local scoreRewardData = infoTemp.scoreRewardData
  for i = 1, #scoreRewardData do
    local needNum = scoreRewardData[i][1]
    if curNum >= needNum and self.rewardProcessDict[i - 1] == nil then
      num = num + 1
    end
  end
  return num
end

local function SetHistoryLogData(self, message)
  if message.dayArr and message.dayNumArr then
    table.clear(self.historyDayArr)
    for i, v in ipairs(message.dayArr) do
      local dayNum = v
      local recordCount = message.dayNumArr[i] or 0
      table.insert(self.historyDayArr, {dayNum = dayNum, recordCount = recordCount})
    end
  end
  local dayNum = message.dayNum
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.historyData[dayNum] == nil then
    self.historyData[dayNum] = {}
    self.historyData[dayNum].updateTime = 0
    self.historyData[dayNum].serverData = {}
  end
  local startNum = message.start or 1
  if startNum == 1 then
    self.historyData[dayNum].updateTime = curTime
    self.historyData[dayNum].serverData = {}
  end
  for k, v in ipairs(message.recordArr) do
    self.historyData[dayNum].serverData[startNum + k - 1] = v
  end
  self.historyDataNeedRefresh = false
end

local function SetHistoryLodDataDirty(self)
  self.historyDataNeedRefresh = true
end

local function GetHistoryLogDataNeedRefresh(self)
  return self.historyDataNeedRefresh
end

ActSlotMachineData.__init = __init
ActSlotMachineData.__delete = __delete
ActSlotMachineData.ParseData = ParseData
ActSlotMachineData.UpdateDailyRewardData = UpdateDailyRewardData
ActSlotMachineData.UpdateActivityFreeRewardData = UpdateActivityFreeRewardData
ActSlotMachineData.CanGetDailyReward = CanGetDailyReward
ActSlotMachineData.CanGetFreePack = CanGetFreePack
ActSlotMachineData.CanGotoPackShop = CanGotoPackShop
ActSlotMachineData.GetGiftPackId = GetGiftPackId
ActSlotMachineData.GetRedNum = GetRedNum
ActSlotMachineData.UpdateLotteyMessage = UpdateLotteyMessage
ActSlotMachineData.UpdateProgressRewardMessage = UpdateProgressRewardMessage
ActSlotMachineData.IsHaveFreeLottery = IsHaveFreeLottery
ActSlotMachineData.UpdateBoxMessage = UpdateBoxMessage
ActSlotMachineData.RemoveBoxUuid = RemoveBoxUuid
ActSlotMachineData.GetOneTaskReward = GetOneTaskReward
ActSlotMachineData.UpdateActTasks = UpdateActTasks
ActSlotMachineData.GetProgressRewardNum = GetProgressRewardNum
ActSlotMachineData.SetHistoryLogData = SetHistoryLogData
ActSlotMachineData.SetHistoryLodDataDirty = SetHistoryLodDataDirty
ActSlotMachineData.GetHistoryLogDataNeedRefresh = GetHistoryLogDataNeedRefresh
return ActSlotMachineData
