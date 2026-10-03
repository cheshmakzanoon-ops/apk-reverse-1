local PveActManager = BaseClass("PveActManager")
local PveActData = require("DataCenter.PveAct.PveActData")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.dataDict = {}
  self.rankDataDict = {}
  self.startingPve = false
end

local function __delete(self)
  self.dataDict = nil
  self.rankDataDict = nil
  self.startingPve = nil
end

local function GetData(self, actId)
  return self.dataDict[actId]
end

local function GetRankData(self, actId)
  return self.rankDataDict[actId]
end

local function HasActivity(self)
  local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.PveAct.Type)
  return 0 < #actList
end

local function GetActIdList(self)
  local list = {}
  local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.PveAct.Type)
  for _, actData in ipairs(actList) do
    table.insert(list, actData.id)
  end
  return list
end

local function GetActIdByPve(self, pve)
  local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.PveAct.Type)
  for _, actData in ipairs(actList) do
    local strs = string.split(actData.para1 or "", "|")
    for _, str in ipairs(strs) do
      local spls = string.split(str, ";")
      if 0 < #spls and tonumber(spls[1]) == pve then
        return tonumber(actData.id)
      end
    end
  end
  return nil
end

local function StartPve(self, actId, pve)
  self.startingPve = true
  self:SendGetInfo(actId, pve)
  self:SendGetRank(actId)
end

local function EnterPve(self, pve, abandon)
  local actId = self:GetActIdByPve(pve)
  if actId == nil then
    return
  end
  local param = {}
  param.actId = actId
  param.levelId = pve
  param.pveEntrance = PveEntrance.PveAct
  param.abandon = abandon
  DataCenter.BattleLevel:Enter(param)
end

local function GetRestTime(self, actId)
  local actData = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(actId))
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local restTime = math.max(actData.endTime - curTime, 0)
  local restTimeStr = UITimeManager:GetInstance():GetFormattedTimeMs(restTime)
  return restTime, restTimeStr
end

local function GetCompleteTaskDataList(self, actId)
  local data = self.dataDict[actId]
  if data == nil then
    return {}
  end
  local list = {}
  for _, taskData in ipairs(data.tasks) do
    if taskData.state ~= TaskState.Received then
      local questTemplate = DataCenter.QuestTemplateManager:GetQuestTemplate(taskData.id)
      if questTemplate and taskData.num >= tonumber(questTemplate.para2) and taskData.exp > 0 then
        table.insert(list, taskData)
      end
    end
  end
  return list
end

local function GetCompleteStageDataList(self, actId)
  local data = self.dataDict[actId]
  if data == nil then
    return {}
  end
  local list = {}
  for _, stageData in ipairs(data.stages) do
    if stageData.state == 0 and data.exp >= stageData.exp then
      table.insert(list, stageData)
    end
  end
  return list
end

local function GetRedCount(self, actId)
  local completeTasks = self:GetCompleteTaskDataList(actId)
  local completeStages = self:GetCompleteStageDataList(actId)
  return #completeTasks + #completeStages
end

local function GetIcon(self, actId)
  local expIcon = string.format(LoadPath.ItemPath, "item200028")
  local bigIcon = string.format(LoadPath.UIPveAct, "integral_icon_chart1")
  local smallIcon = string.format(LoadPath.UIPveAct, "UIactivitiesranking_btn_reward")
  local actData = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(actId))
  if not string.IsNullOrEmpty(actData.list_icon) then
    expIcon = string.format(LoadPath.UIPveAct, actData.list_icon)
  end
  if not string.IsNullOrEmpty(actData.advertise_pic) then
    local spls = string.split(actData.advertise_pic, ";")
    if #spls == 2 then
      bigIcon = string.format(LoadPath.UIPveAct, spls[1])
      smallIcon = string.format(LoadPath.UIPveAct, spls[2])
    end
  end
  return expIcon, bigIcon, smallIcon
end

local function HasRank(self, actId)
  local data = self.dataDict[actId]
  if data == nil then
    return false
  end
  return data.hasRank
end

local function SendGetInfo(self, actId, pve)
  SFSNetwork.SendMessage(MsgDefines.PveActGetInfo, actId, pve)
end

local function SendGetinfoByActId(self, actId)
  SFSNetwork.SendMessage(MsgDefines.PveActGetInfo, actId)
end

local function SendTaskReward(self, actId, pve, taskId)
  SFSNetwork.SendMessage(MsgDefines.PveActTaskReward, actId, pve, taskId)
end

local function SendStageReward(self, actId, pve, stage)
  SFSNetwork.SendMessage(MsgDefines.PveActStageReward, actId, pve, stage)
end

local function SendGetRank(self, actId)
  SFSNetwork.SendMessage(MsgDefines.PveActGetRank, actId)
end

local function HandleGetInfo(self, message)
  local actId = message.activityId
  if actId == nil then
    return
  end
  local data = self.dataDict[actId]
  if data == nil then
    data = PveActData.New(actId)
  end
  if message.pveInfo then
    local pveInfo = message.pveInfo
    data.pveInfo[pveInfo.level] = pveInfo
  end
  if message.taskArr then
    data.tasks = {}
    for _, serverTaskData in ipairs(message.taskArr) do
      local taskData = TaskInfo.New()
      taskData:UpdateInfo(serverTaskData)
      table.insert(data.tasks, taskData)
    end
  end
  if message.stageArr then
    data.stages = message.stageArr
  end
  if message.score then
    data.score = message.score
  end
  if message.exp then
    data.exp = message.exp
  end
  if message.hasRank then
    data.hasRank = message.hasRank
  end
  self.dataDict[actId] = data
  EventManager:GetInstance():Broadcast(EventId.PveActGetInfo, actId)
  if self.startingPve then
    if message.pveInfo then
      DataCenter.BattleLevel:OnStartLevelMessage(message.pveInfo)
    end
    self.startingPve = false
  end
end

local function HandleTaskReward(self, message)
  local actId = message.activityId
  if actId == nil then
    return
  end
  local data = self.dataDict[actId]
  if data == nil then
    return
  end
  if message.reward then
    DataCenter.RewardManager:AddRewardsAndRes(message)
    DataCenter.RewardManager:ShowCommonReward(message)
  end
  if message.taskId then
    for _, taskData in ipairs(data.tasks) do
      if taskData.id == message.taskId then
        taskData.state = TaskState.Received
        break
      end
    end
  end
  if message.score then
    data.score = message.score
  end
  if message.exp then
    data.exp = message.exp
  end
  local param = {}
  param.actId = actId
  param.taskId = message.taskId
  EventManager:GetInstance():Broadcast(EventId.PveActTaskReward, param)
end

local function HandleStageReward(self, message)
  local actId = message.activityId
  if actId == nil then
    return
  end
  local data = self.dataDict[actId]
  if data == nil then
    return
  end
  if message.reward then
    DataCenter.RewardManager:AddRewardsAndRes(message)
    DataCenter.RewardManager:ShowCommonReward(message)
  end
  if message.stage then
    for _, stageData in ipairs(data.stages) do
      if stageData.stage == message.stage then
        stageData.state = 1
      end
    end
  end
  if message.score then
    data.score = message.score
  end
  local param = {}
  param.actId = actId
  param.stage = message.stage
  EventManager:GetInstance():Broadcast(EventId.PveActStageReward, param)
end

local function HandleUpdateTask(self, message)
  local actId = message.activityId
  if actId == nil then
    return
  end
  local data = self.dataDict[actId]
  if data == nil then
    return
  end
  if message.taskArr then
    for _, serverTaskData in ipairs(message.taskArr) do
      for _, taskData in ipairs(data.tasks) do
        if taskData.id == serverTaskData.id or taskData.id == serverTaskData.taskId then
          taskData:UpdateInfo(serverTaskData)
          break
        end
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.PveActTaskUpdate, actId)
end

local function HandleGetRank(self, message)
  local actId = message.activityId
  if actId == nil then
    return
  end
  self.rankDataDict[actId] = message
  EventManager:GetInstance():Broadcast(EventId.PveActGetRank, actId)
end

local function HandleScoreUpdate(self, message)
  local actId = message.activityId
  if actId == nil then
    return
  end
  local data = self.dataDict[actId]
  if data == nil then
    return
  end
  if message.add then
  end
  if message.score then
    data.score = message.score
  end
  EventManager:GetInstance():Broadcast(EventId.PveActScoreUpdate, actId)
end

local function HandleRankUpdate(self, message)
  local actId = message.activityId
  if actId == nil then
    return
  end
  local data = self.dataDict[actId]
  if data == nil then
    return
  end
  if message.hasRank then
    data.hasRank = message.hasRank
    if CS.SceneManager.IsInPVE() then
      self:SendGetRank(actId)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.PveActRankUpdate, actId)
end

PveActManager.__init = __init
PveActManager.__delete = __delete
PveActManager.Startup = Startup
PveActManager.GetData = GetData
PveActManager.GetRankData = GetRankData
PveActManager.HasActivity = HasActivity
PveActManager.GetActIdList = GetActIdList
PveActManager.GetActIdByPve = GetActIdByPve
PveActManager.StartPve = StartPve
PveActManager.EnterPve = EnterPve
PveActManager.GetRestTime = GetRestTime
PveActManager.GetCompleteTaskDataList = GetCompleteTaskDataList
PveActManager.GetCompleteStageDataList = GetCompleteStageDataList
PveActManager.GetRedCount = GetRedCount
PveActManager.GetIcon = GetIcon
PveActManager.HasRank = HasRank
PveActManager.SendGetInfo = SendGetInfo
PveActManager.SendGetinfoByActId = SendGetinfoByActId
PveActManager.SendTaskReward = SendTaskReward
PveActManager.SendStageReward = SendStageReward
PveActManager.SendGetRank = SendGetRank
PveActManager.HandleGetInfo = HandleGetInfo
PveActManager.HandleTaskReward = HandleTaskReward
PveActManager.HandleStageReward = HandleStageReward
PveActManager.HandleUpdateTask = HandleUpdateTask
PveActManager.HandleGetRank = HandleGetRank
PveActManager.HandleScoreUpdate = HandleScoreUpdate
PveActManager.HandleRankUpdate = HandleRankUpdate
return PveActManager
