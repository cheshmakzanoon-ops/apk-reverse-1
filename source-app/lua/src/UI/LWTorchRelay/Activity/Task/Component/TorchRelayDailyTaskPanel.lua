local TorchRelayDailyTaskPanel = BaseClass("TorchRelayDailyTaskPanel", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIActivityTaskItem = require("UI.LWTorchRelay.Activity.Task.Component.UIActivityTaskItem")
local dailyTaskListPath = "TaskListScroll"
local dailyTaskListContentPath = "TaskListScroll/Viewport/Content"
local refresh_time_path = "refreshTime"

function TorchRelayDailyTaskPanel:OnCreate()
  base.OnCreate(self)
  self.refresh_time = self:AddComponent(UITextMeshProUGUIEx, refresh_time_path)
  self.dailyTaskList = self:AddComponent(UILoopListView2, dailyTaskListPath)
  self.dailyTaskList:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.dailyTaskListContent = self:AddComponent(UIBaseContainer, dailyTaskListContentPath)
  self.dailyTaskDataList = {}
  self.itemIndex = 0
  self.onPointRewardAnimFinishCallBack = BindCallback(self, self.OnRewardGetClick)
  self.timer_action = BindCallback(self, self.RefreshTime)
end

function TorchRelayDailyTaskPanel:OnDestroy()
  self.timer_action = nil
  self.dailyTaskListContent:RemoveComponents(UIActivityTaskItem)
  self.dailyTaskList:ClearAllItems()
  self.dailyTaskList = nil
  self.dailyTaskListContent = nil
  self.itemIndex = nil
  self.dailyTaskDataList = nil
  self.onPointRewardAnimFinishCallBack = nil
  base.OnDestroy(self)
end

function TorchRelayDailyTaskPanel:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActivityTorchRelayTaskUpdate, self.OnTaskListUpdate)
end

function TorchRelayDailyTaskPanel:OnRemoveListener()
  self:RemoveUIListener(EventId.ActivityTorchRelayTaskUpdate, self.OnTaskListUpdate)
  base.OnRemoveListener(self)
end

function TorchRelayDailyTaskPanel:OnEnable()
  base.OnEnable(self)
  self:AddTimer()
end

function TorchRelayDailyTaskPanel:OnDisable()
  base.OnDisable(self)
  self:RemoveTimer()
end

function TorchRelayDailyTaskPanel:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

function TorchRelayDailyTaskPanel:RemoveTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function TorchRelayDailyTaskPanel:ReInit()
  self:RefreshTime()
  self:RefreshTaskList()
end

function TorchRelayDailyTaskPanel:RefreshTaskList()
  self.dailyTaskDataList = self.holder.ctrl:GetDailyTaskList()
  local noTask = self.dailyTaskDataList == nil or #self.dailyTaskDataList == 0
  self.dailyTaskList:SetActive(not noTask)
  if not noTask then
    self.dailyTaskList:SetListItemCount(#self.dailyTaskDataList, false, false)
    self.dailyTaskList:RefreshAllShownItem()
  end
end

function TorchRelayDailyTaskPanel:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.dailyTaskDataList then
    return nil
  end
  local dailyTaskInfo = self.dailyTaskDataList[index]
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

function TorchRelayDailyTaskPanel:RefreshTime()
  local remainTime = UITimeManager:GetInstance():GetResSecondsTo24()
  self.refresh_time:SetLocalText("activity_torch_relay_task_36", UITimeManager:GetInstance():MilliSecondToFmtString(remainTime * 1000))
end

function TorchRelayDailyTaskPanel:OnRewardGetClick()
  self:RefreshTaskList()
end

function TorchRelayDailyTaskPanel:OnTaskListUpdate()
  self:RefreshTaskList()
end

return TorchRelayDailyTaskPanel
