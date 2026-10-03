local TorchRelayMilestonesTaskPanel = BaseClass("TorchRelayMilestonesTaskPanel", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIActivityTaskItem = require("UI.LWTorchRelay.Activity.Task.Component.UIActivityTaskItem")
local TorchRelayTaskGoalItem = require("UI.LWTorchRelay.Activity.Task.Component.TorchRelayTaskGoalItem")
local dailyTaskListPath = "TaskListScroll"
local dailyTaskListContentPath = "TaskListScroll/Viewport/Content"
local desc_path = "desc"
local slider_path = "ProgressRoot/Progress/Slider"
local point_count_text_path = "ProgressRoot/Progress/PointCountText"
local goals_root_path = "ProgressRoot/Progress/GoalsRoot"

function TorchRelayMilestonesTaskPanel:OnCreate()
  base.OnCreate(self)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.desc:SetLocalText("activity_torch_relay_desc_20")
  self.slider = self:AddComponent(UISlider, slider_path)
  self.point_count_text = self:AddComponent(UITextMeshProUGUIEx, point_count_text_path)
  self.goals_root = self:AddComponent(UIBaseContainer, goals_root_path)
  self.goalItemList = {}
  local goalsCount = self.goals_root.transform.childCount
  for i = 0, goalsCount - 1 do
    local child = self.goals_root.transform:GetChild(i)
    self.goalItemList[i + 1] = self:AddComponent(TorchRelayTaskGoalItem, child)
  end
  self.dailyTaskList = self:AddComponent(UILoopListView2, dailyTaskListPath)
  self.dailyTaskList:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.dailyTaskListContent = self:AddComponent(UIBaseContainer, dailyTaskListContentPath)
  self.taskList = {}
  self.itemIndex = 0
  self.onPointRewardAnimFinishCallBack = BindCallback(self, self.OnRewardGetClick)
  self.milestonesBg = self:AddComponent(UIRawImage, "ProgressRoot/bg")
end

function TorchRelayMilestonesTaskPanel:OnDestroy()
  self.dailyTaskListContent:RemoveComponents(UIActivityTaskItem)
  self.dailyTaskList:ClearAllItems()
  self.dailyTaskList = nil
  self.dailyTaskListContent = nil
  self.itemIndex = nil
  self.taskList = nil
  self.onPointRewardAnimFinishCallBack = nil
  base.OnDestroy(self)
end

function TorchRelayMilestonesTaskPanel:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActivityTorchRelayTaskRewardGet, self.OnTaskRewardGet)
  self:AddUIListener(EventId.ActivityTorchRelayTaskUpdate, self.OnTaskListUpdate)
  self:AddUIListener(EventId.ActivityTorchRelayMilesRewardGet, self.OnMilesRewardGet)
end

function TorchRelayMilestonesTaskPanel:OnRemoveListener()
  self:RemoveUIListener(EventId.ActivityTorchRelayTaskRewardGet, self.OnTaskRewardGet)
  self:RemoveUIListener(EventId.ActivityTorchRelayTaskUpdate, self.OnTaskListUpdate)
  self:RemoveUIListener(EventId.ActivityTorchRelayMilesRewardGet, self.OnMilesRewardGet)
  base.OnRemoveListener(self)
end

function TorchRelayMilestonesTaskPanel:ReInit()
  self.milestonesBg:LoadSpriteAsync(self.holder.ctrl:GetMilestonesBg())
  self:OnRefreshTaskList()
  self:OnProgressRefresh()
  self:OnMilesRewardRefresh()
end

function TorchRelayMilestonesTaskPanel:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.taskList then
    return nil
  end
  local dailyTaskInfo = self.taskList[index]
  local item = loopScroll:NewListViewItem("TorchRelayTaskItem")
  local script = self.dailyTaskListContent:GetComponent(item.gameObject.name, UIActivityTaskItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    script = self.dailyTaskListContent:AddComponent(UIActivityTaskItem, objectName)
  end
  script:SetActive(true)
  script:SetData(self.holder.activityId, dailyTaskInfo)
  return item
end

function TorchRelayMilestonesTaskPanel:OnRewardGetClick()
  self:OnRefresh(true)
end

function TorchRelayMilestonesTaskPanel:OnTaskRewardGet()
  self:OnRefreshTaskList()
  self:OnProgressRefresh()
  self:OnMilesRewardRefresh()
end

function TorchRelayMilestonesTaskPanel:OnMilesRewardGet()
  self:OnProgressRefresh()
  self:OnMilesRewardRefresh()
end

function TorchRelayMilestonesTaskPanel:OnTaskListUpdate()
  self:OnRefreshTaskList()
end

function TorchRelayMilestonesTaskPanel:OnRefreshTaskList()
  self.taskList = self.holder.ctrl:GetAllTaskList()
  local noTask = self.taskList == nil or #self.taskList == 0
  self.dailyTaskList:SetActive(not noTask)
  if not noTask then
    self.dailyTaskList:SetListItemCount(#self.taskList, false, false)
    self.dailyTaskList:RefreshAllShownItem()
  end
end

function TorchRelayMilestonesTaskPanel:OnProgressRefresh()
  local curProgress = self.holder.ctrl:GetMilestonesCurProgress()
  local totalProgress = self.holder.ctrl:GetMilestonesTotalProgress()
  self.point_count_text:SetText(string.format("%s/%s", curProgress, totalProgress))
  local progressPercent = 0
  if curProgress >= totalProgress then
    progressPercent = 1
  else
    progressPercent = curProgress / totalProgress
  end
  self.slider:SetValue(progressPercent)
end

function TorchRelayMilestonesTaskPanel:OnMilesRewardRefresh()
  local pointList = self.holder.ctrl:GetMilestonesProgressPointList()
  local curProgress = self.holder.ctrl:GetMilestonesCurProgress()
  for i, v in ipairs(self.goalItemList) do
    v:ReInit(pointList[i], i, curProgress, self.holder.activityId)
  end
end

return TorchRelayMilestonesTaskPanel
