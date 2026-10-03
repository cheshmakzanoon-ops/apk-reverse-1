local DailyTaskManager = BaseClass("DailyTaskManager")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.curReward = {}
  self.dailyQuestTasks = {}
  self.rewardList = {}
  self.rewardListBuilder = {}
  self.rewardListMerge = nil
  self.iconShowList = {}
  self.dailyBoxActive = {}
  self.ActivityOverviewList = {}
  self:AddListener()
end

local function __delete(self)
  self:RemoveListener()
  self.curReward = nil
  self.dailyQuestTasks = nil
  self.rewardList = nil
  self.rewardListBuilder = nil
  self.rewardListMerge = nil
  self.iconShowList = nil
  self.dailyBoxActive = nil
  self.ActivityOverviewList = nil
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.OnPassDay, self.TryReqUpdateData)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.OnPassDay, self.TryReqUpdateData)
end

local function TryReqUpdateData(self)
  DataCenter.DispatchRequestManager:Append(function()
    SFSNetwork.SendMessage(MsgDefines.DailyQuestLs)
  end)
end

local function InitData(self, message)
  self:UpdateDailyTask(message)
end

local function UpdateDailyTask(self, message)
  if message ~= nil then
    self.curReward = 0
    self.dailyQuestTasks = {}
    self.rewardList = {}
    self.rewardListBuilder = {}
    self.rewardListMerge = nil
    self.iconShowList = {}
    self.dailyBoxActive = {}
    if message.curReward ~= nil then
      self.curReward = message.curReward
    end
    if message.rewardList ~= nil then
      for k, v in pairs(message.rewardList) do
        if v.point ~= nil then
          local info = v.info
          local infoBuilder = v.infoBuilder
          if info or infoBuilder then
            local point = v.point
            if v.icon_show ~= nil then
              self.iconShowList[point] = v.icon_show
            end
            table.insert(self.dailyBoxActive, v.point)
            if info ~= nil then
              self.rewardList[point] = DataCenter.RewardManager:ReturnRewardParamForView(info)
            end
            if infoBuilder ~= nil then
              self.rewardListBuilder[point] = DataCenter.RewardManager:ReturnRewardParamForView(infoBuilder)
            end
          end
        end
      end
    end
    if message.dailyQuest ~= nil then
      for k, v in pairs(message.dailyQuest) do
        self:UpdateOneDailyTaskInfo(v)
      end
    end
  end
end

local function UpdateOneDailyTaskInfo(self, message)
  if message ~= nil then
    local id = message.id
    local one = self:FindTaskInfo(id)
    if one == nil then
      one = DailyTaskInfo.New()
      one:UpdateInfo(message)
      self.dailyQuestTasks[id] = one
    else
      one:UpdateInfo(message)
    end
  end
end

local function FindTaskInfo(self, id)
  return self.dailyQuestTasks[id]
end

local function DailyQuestLsMessageHandle(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
  else
    self:UpdateDailyTask(message)
    EventManager:GetInstance():Broadcast(EventId.DailyQuestLs)
  end
end

local function GetCurValue(self)
  local result = 0
  if self.dailyQuestTasks ~= nil then
    for k, v in pairs(self.dailyQuestTasks) do
      if v.state == TaskState.Received then
        local template = DataCenter.DailyTaskTemplateManager:GetQuestTemplate(k)
        if template ~= nil then
          result = result + template.point
        end
      end
    end
  end
  return result
end

local function DailyQuestRewardMessageHandle(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
  else
    local crit = LuaEntry.Effect:GetGameEffect(EffectDefine.DAILY_TASK_REWARD_CRIT_94103)
    local tips
    if 0 < crit then
      local rewardNum = tonumber(message.rewardNum)
      if rewardNum <= 0 then
        tips = CS.GameEntry.Localization:GetString("season_mastery_s2_tips_18")
      else
        tips = CS.GameEntry.Localization:GetString("season_mastery_s2_tips_4", tonumber(message.rewardNum))
      end
    end
    DataCenter.RewardManager:ShowCommonReward(message, nil, nil, nil, nil, nil, nil, tips)
    DataCenter.RewardManager:AddRewardsAndRes(message)
    if message.stageArr ~= nil then
      for k, v in pairs(message.stageArr) do
        self:SetCurReward(v)
      end
    end
    EventManager:GetInstance():Broadcast(EventId.DailyQuestReward)
  end
end

local function SetCurReward(self, value)
  table.insert(self.curReward, value)
end

local function GetBoxState(self, index, curPoint)
  for i = 1, #self.curReward do
    if self.curReward[i] == index then
      return TaskState.Received
    end
  end
  local boxValue = self.dailyBoxActive[index]
  if boxValue then
    if curPoint >= boxValue then
      return TaskState.CanReceive
    else
      return TaskState.NoComplete
    end
  end
  return TaskState.NoComplete
end

local function IsAllBoxRewardReceived(self)
  local curPoint = self:GetCurValue()
  for index = 1, 5 do
    if self:GetBoxState(index, curPoint) ~= TaskState.Received then
      return false
    end
  end
  return true
end

local function GetSortDailyTask(self)
  local result = self:GetAllDailyTask()
  table.sort(result, function(a, b)
    if a.state > b.state then
      return true
    elseif a.state == b.state then
      local template1 = DataCenter.DailyTaskTemplateManager:GetQuestTemplate(a.id)
      local template2 = DataCenter.DailyTaskTemplateManager:GetQuestTemplate(b.id)
      if template1 ~= nil and template2 ~= nil and template1.order < template2.order then
        return true
      else
        return false
      end
      return false
    end
  end)
  local receiveList = self:GetAllReceivedDailyTask()
  for i = 1, #receiveList do
    table.insert(result, receiveList[i])
  end
  return result
end

local function GetAllDailyTask(self)
  local result = {}
  if self.dailyQuestTasks ~= nil then
    for k, v in pairs(self.dailyQuestTasks) do
      if v.state ~= TaskState.Received then
        local template = DataCenter.DailyTaskTemplateManager:GetQuestTemplate(v.id)
        if template ~= nil and template.show == QuestShowType.Show then
          table.insert(result, v)
        end
      end
    end
  end
  return result
end

local function GetAllReceivedDailyTask(self)
  local result = {}
  if self.dailyQuestTasks ~= nil then
    for k, v in pairs(self.dailyQuestTasks) do
      if v.state == TaskState.Received then
        local template = DataCenter.DailyTaskTemplateManager:GetQuestTemplate(v.id)
        if template ~= nil and template.show == QuestShowType.Show then
          table.insert(result, v)
        end
      end
    end
  end
  table.sort(result, function(a, b)
    if a.state > b.state then
      return true
    elseif a.state == b.state then
      local template1 = DataCenter.DailyTaskTemplateManager:GetQuestTemplate(a.id)
      local template2 = DataCenter.DailyTaskTemplateManager:GetQuestTemplate(b.id)
      if template1 ~= nil and template2 ~= nil and template1.order < template2.order then
        return true
      else
        return false
      end
      return false
    end
  end)
  return result
end

local function GetDailyCurValue(self, index)
  return self.dailyBoxActive[index]
end

local function GetDailyMaxValue(self)
  local max = table.count(self.dailyBoxActive)
  if next(self.dailyBoxActive) then
    return self.dailyBoxActive[max]
  end
  return 100
end

local function GetDailyProgress(self)
  local maxCount = DataCenter.DailyTaskManager:GetDailyMaxValue()
  local curPoint = DataCenter.DailyTaskManager:GetCurValue()
  local progress = curPoint / maxCount
  if 1 < progress then
    progress = 1
  end
  if progress < 0 then
    progress = 0
  end
  return progress
end

local function GetBoxRewardShow(self, point)
  local isFarmer = DataCenter.SeasonFarmerManager:IsActive()
  local dataList1 = self.rewardList[point]
  if isFarmer then
    local dataList2 = self.rewardListBuilder[point]
    if dataList1 == nil or #dataList1 == 0 then
      return dataList2
    end
    local dataList
    if self.rewardListMerge ~= nil then
      dataList = self.rewardListMerge[point]
    end
    if dataList ~= nil then
      return dataList
    end
    local findIt = false
    dataList = {}
    if dataList1 then
      for _, item in ipairs(dataList1) do
        local tmp = {}
        for k, v in pairs(item) do
          tmp[k] = v
        end
        table.insert(dataList, tmp)
      end
    end
    if dataList2 then
      for _, v1 in ipairs(dataList2) do
        findIt = false
        for _, v2 in ipairs(dataList) do
          if v1 and v2 and v1.rewardType == v2.rewardType and v1.itemId == v2.itemId and type(v1.count) == "number" and type(v2.count) == "number" then
            findIt = true
            v2.count = v2.count + v1.count
            break
          end
        end
        if not findIt then
          table.insert(dataList, v1)
        end
      end
    end
    if self.rewardListMerge == nil then
      self.rewardListMerge = {}
    end
    self.rewardListMerge[point] = dataList
    return dataList
  end
  return dataList1
end

local function GetBoxShowItemIcon(self, point)
  local iconPath
  local iconName = self.iconShowList[point]
  if not string.IsNullOrEmpty(iconName) then
    iconPath = string.format(LoadPath.ItemPath, iconName)
  end
  return iconPath
end

local function GetBoxRewardResItemCount(self, point)
  local count = 0
  local list = self:GetBoxRewardShow(point)
  if list then
    for _, reward in ipairs(list) do
      if reward.rewardType == RewardType.RESOURCE_ITEM then
        count = count + reward.count
      end
    end
  end
  return count
end

local function IsShowDailyTask(self)
  return true
end

local function GetRedDotNum(self)
  local result = 0
  local curPoint = self:GetCurValue()
  for k, v in ipairs(self.dailyBoxActive) do
    if v <= curPoint and self:GetBoxState(k, curPoint) ~= TaskState.Received then
      result = result + 1
    end
  end
  return result
end

local function GetRedNum(self)
  local functionUnlock = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.Daily_Quest)
  if not functionUnlock then
    return 0
  end
  local result = 0
  local list = self:GetAllDailyTask()
  if not table.IsNullOrEmpty(list) then
    for i = 1, table.length(list) do
      if list[i].state == 1 then
        result = result + 1
      end
    end
  end
  local curValue = self:GetCurValue()
  for i = 1, 5 do
    local tempState = self:GetBoxState(i, curValue)
    if tempState == TaskState.CanReceive then
      result = result + 1
    end
  end
  return result
end

local function DailyTaskRewardMessageHandle(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
  else
    DataCenter.RewardManager:AddRewardsAndRes(message)
    if message.taskInfo then
      for k, v in pairs(message.taskInfo) do
        self:UpdateOneDailyTaskInfo(v)
      end
    end
    EventManager:GetInstance():Broadcast(EventId.DailyQuestSuccess)
  end
end

DailyTaskManager.__init = __init
DailyTaskManager.__delete = __delete
DailyTaskManager.InitData = InitData
DailyTaskManager.UpdateDailyTask = UpdateDailyTask
DailyTaskManager.FindTaskInfo = FindTaskInfo
DailyTaskManager.DailyQuestLsMessageHandle = DailyQuestLsMessageHandle
DailyTaskManager.UpdateOneDailyTaskInfo = UpdateOneDailyTaskInfo
DailyTaskManager.GetCurValue = GetCurValue
DailyTaskManager.DailyQuestRewardMessageHandle = DailyQuestRewardMessageHandle
DailyTaskManager.SetCurReward = SetCurReward
DailyTaskManager.GetBoxState = GetBoxState
DailyTaskManager.IsAllBoxRewardReceived = IsAllBoxRewardReceived
DailyTaskManager.GetRedNum = GetRedNum
DailyTaskManager.GetSortDailyTask = GetSortDailyTask
DailyTaskManager.GetBoxRewardShow = GetBoxRewardShow
DailyTaskManager.GetBoxShowItemIcon = GetBoxShowItemIcon
DailyTaskManager.GetBoxRewardResItemCount = GetBoxRewardResItemCount
DailyTaskManager.IsShowDailyTask = IsShowDailyTask
DailyTaskManager.GetRedDotNum = GetRedDotNum
DailyTaskManager.DailyTaskRewardMessageHandle = DailyTaskRewardMessageHandle
DailyTaskManager.GetDailyMaxValue = GetDailyMaxValue
DailyTaskManager.GetDailyCurValue = GetDailyCurValue
DailyTaskManager.GetDailyProgress = GetDailyProgress
DailyTaskManager.GetAllDailyTask = GetAllDailyTask
DailyTaskManager.GetAllReceivedDailyTask = GetAllReceivedDailyTask
DailyTaskManager.AddListener = AddListener
DailyTaskManager.RemoveListener = RemoveListener
DailyTaskManager.TryReqUpdateData = TryReqUpdateData
return DailyTaskManager
