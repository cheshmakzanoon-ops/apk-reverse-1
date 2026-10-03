local UITorchRelayTaskCtrl = BaseClass("UITorchRelayTaskCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITorchRelayTaskView)
end

local function SetActivityId(self, activityId)
  self.activityId = activityId
end

local function GetDailyTaskEndTime(self)
end

local function GetDailyTaskList(self)
  local activityData = DataCenter.ActivityTorchRelayManager:GetActivityData(self.activityId)
  local idList = activityData.config:GetDailyTaskIdList()
  return DataCenter.ActivityTorchRelayTaskManager:GetTaskListByIds(self.activityId, idList, ActivityTorchRelayTaskType.Daily)
end

local function GetMilestonesList(self)
  local activityData = DataCenter.ActivityTorchRelayManager:GetActivityData(self.activityId)
  local idList = activityData.config:GetMilesTaskIdList()
  return DataCenter.ActivityTorchRelayTaskManager:GetTaskListByIds(self.activityId, idList, ActivityTorchRelayTaskType.Milestones)
end

function UITorchRelayTaskCtrl:GetAllTaskList()
  local activityData = DataCenter.ActivityTorchRelayManager:GetActivityData(self.activityId)
  local idListList = {
    {
      type = ActivityTorchRelayTaskType.Daily,
      idList = activityData.config:GetDailyTaskIdList()
    },
    {
      type = ActivityTorchRelayTaskType.Milestones,
      idList = activityData.config:GetMilesTaskIdList()
    }
  }
  local taskList = DataCenter.ActivityTorchRelayTaskManager:GetAllTaskListByIds(self.activityId, idListList)
  return taskList
end

local function GetMilestonesCurProgress(self)
  return DataCenter.ActivityTorchRelayTaskManager:GetMilestonesProgress(self.activityId)
end

local function GetMilestonesTotalProgress(self)
  local activityData = DataCenter.ActivityTorchRelayManager:GetActivityData(self.activityId)
  local list = activityData.config:GetMilestonesPointList()
  return list[#list].progress
end

local function GetMilestonesProgressPointList(self)
  local activityData = DataCenter.ActivityTorchRelayManager:GetActivityData(self.activityId)
  return activityData.config:GetMilestonesPointList()
end

function UITorchRelayTaskCtrl:GetMilestonesBg()
  local activityData = DataCenter.ActivityTorchRelayManager:GetActivityData(self.activityId)
  if activityData and activityData.config then
    return activityData.config:GetTaskBanner()
  end
end

UITorchRelayTaskCtrl.CloseSelf = CloseSelf
UITorchRelayTaskCtrl.GetDailyTaskEndTime = GetDailyTaskEndTime
UITorchRelayTaskCtrl.GetDailyTaskList = GetDailyTaskList
UITorchRelayTaskCtrl.GetMilestonesList = GetMilestonesList
UITorchRelayTaskCtrl.GetMilestonesCurProgress = GetMilestonesCurProgress
UITorchRelayTaskCtrl.GetMilestonesTotalProgress = GetMilestonesTotalProgress
UITorchRelayTaskCtrl.GetMilestonesProgressPointList = GetMilestonesProgressPointList
UITorchRelayTaskCtrl.SetActivityId = SetActivityId
return UITorchRelayTaskCtrl
