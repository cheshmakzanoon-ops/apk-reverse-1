local UIActEasterEggTaskView = BaseClass("UIActEasterEggTaskView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIActivityTaskCommonItem = require("UI.ActivityCommon.UIActivityTaskCommonItem")
local ActEasterEggTaskGoalItem = require("UI.LWUIActEasterEgg.UIActEasterEggTask.Component.ActEasterEggTaskGoalItem")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.btnPanel = self:AddComponent(UIButton, "panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, "PopUpTitle/root/desc")
  self.slider = self:AddComponent(UISlider, "PopUpTitle/root/ProgressRoot/Progress/Slider")
  self.point_count_text = self:AddComponent(UITextMeshProUGUIEx, "PopUpTitle/root/ProgressRoot/Progress/PointCountText")
  self.goals_root = self:AddComponent(UIBaseContainer, "PopUpTitle/root/ProgressRoot/Progress/GoalsRoot")
  self.listView = self:AddComponent(UILoopListView2, "PopUpTitle/root/TaskListScroll")
  self.dailyTaskListContent = self:AddComponent(UIBaseContainer, "PopUpTitle/root/TaskListScroll/Viewport/Content")
  self.btnClose = self:AddComponent(UIButton, "PopUpTitle/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.listView:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.goalItemList = {}
  local goalsCount = self.goals_root.transform.childCount
  for i = 0, goalsCount - 1 do
    local child = self.goals_root.transform:GetChild(i)
    self.goalItemList[i + 1] = self:AddComponent(ActEasterEggTaskGoalItem, child)
  end
  self.taskList = {}
  self.itemIndex = 0
  self.taskItem = {}
  self.pointIcon = self:AddComponent(UIButton, "PopUpTitle/root/ProgressRoot/Progress/PointIcon")
end

local function ComponentDestroy(self)
  self.pointIcon = nil
  self.goalItemList = nil
  if self.taskItem then
    for i, v in ipairs(self.taskItem) do
      if v then
        v.gameObject.name = "task_reset"
      end
    end
  end
  self.taskItem = nil
  self.dailyTaskListContent:RemoveComponents(UIActivityTaskCommonItem)
  self.listView:ClearAllItems()
  self.taskList = nil
  self.itemIndex = nil
  self.btnPanel = nil
  self.desc = nil
  self.slider = nil
  self.point_count_text = nil
  self.goals_root = nil
  self.listView = nil
  self.dailyTaskListContent = nil
  self.btnClose = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.EasterEggTaskUpdate, self.OnTaskListUpdate)
  self:AddUIListener(EventId.EasterEggTaskRewardGet, self.OnTaskRewardGet)
  self:AddUIListener(EventId.EasterEggTaskStageRewardGet, self.OnStageRewardGet)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.EasterEggTaskUpdate, self.OnTaskListUpdate)
  self:RemoveUIListener(EventId.EasterEggTaskRewardGet, self.OnTaskRewardGet)
  self:RemoveUIListener(EventId.EasterEggTaskStageRewardGet, self.OnStageRewardGet)
  base.OnRemoveListener(self)
end

function UIActEasterEggTaskView:ReInit()
  self:OnRefreshStagePropsIcon()
  self:OnRefreshTaskList()
  self:OnProgressRefresh()
  self:OnStageRewardRefresh()
end

function UIActEasterEggTaskView:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.taskList then
    return nil
  end
  self.itemIndex = self.itemIndex or 0
  local taskInfo = self.taskList[index]
  local item = loopScroll:NewListViewItem("TorchRelayTaskItem")
  local script = self.dailyTaskListContent:GetComponent(item.gameObject.name, UIActivityTaskCommonItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    script = self.dailyTaskListContent:AddComponent(UIActivityTaskCommonItem, objectName)
    table.insert(self.taskItem, item)
  end
  script:SetActive(true)
  local callback = Bind(self, self.OnGetRewardClick)
  script:SetData(taskInfo, callback)
  return item
end

function UIActEasterEggTaskView:OnStageRewardGet()
  self:OnProgressRefresh()
  self:OnStageRewardRefresh()
end

function UIActEasterEggTaskView:OnTaskRewardGet()
  self:OnRefreshTaskList()
  self:OnProgressRefresh()
  self:OnStageRewardRefresh()
end

function UIActEasterEggTaskView:OnTaskListUpdate()
  self:OnRefreshTaskList()
end

function UIActEasterEggTaskView:OnRefreshStagePropsIcon()
  local config = DataCenter.ActEasterEggManager:GetEggConfigData()
  if config == nil then
    return
  end
  local path = DataCenter.ItemTemplateManager:GetIconPath(tonumber(config.score_item_id))
  self.pointIcon:LoadSprite(path)
end

function UIActEasterEggTaskView:OnRefreshTaskList()
  self.taskList = DataCenter.ActEasterEggTaskManager:GetAllTaskList()
  local noTask = self.taskList == nil or #self.taskList == 0
  self.listView:SetActive(not noTask)
  if not noTask then
    self.listView:SetListItemCount(#self.taskList, false, false)
    self.listView:RefreshAllShownItem()
  end
end

function UIActEasterEggTaskView:OnProgressRefresh()
  local curProgress = DataCenter.ActEasterEggTaskManager:GetTaskStageProgress()
  local totalProgress = DataCenter.ActEasterEggTaskManager:GetMilestonesTotalProgress()
  self.point_count_text:SetText(string.format("%s/%s", curProgress, totalProgress))
  local progressPercent = 0
  if curProgress >= totalProgress then
    progressPercent = 1
  else
    progressPercent = curProgress / totalProgress
  end
  self.slider:SetValue(progressPercent)
end

function UIActEasterEggTaskView:OnStageRewardRefresh()
  local pointList = DataCenter.ActEasterEggTaskManager:GetTaskStageRewardList()
  local curProgress = DataCenter.ActEasterEggTaskManager:GetTaskStageProgress()
  for i, v in ipairs(self.goalItemList) do
    v:ReInit(pointList[i], i, curProgress)
  end
end

local function OnBtnCloseClick(self)
  self.ctrl:CloseSelf()
end

function UIActEasterEggTaskView:OnGetRewardClick(taskData)
  local activityId = DataCenter.ActEasterEggTaskManager.activityId
  SFSNetwork.SendMessage(MsgDefines.EasterReceiveTaskReward, activityId, taskData.id)
end

UIActEasterEggTaskView.OnCreate = OnCreate
UIActEasterEggTaskView.OnDestroy = OnDestroy
UIActEasterEggTaskView.OnEnable = OnEnable
UIActEasterEggTaskView.OnDisable = OnDisable
UIActEasterEggTaskView.ComponentDefine = ComponentDefine
UIActEasterEggTaskView.ComponentDestroy = ComponentDestroy
UIActEasterEggTaskView.DataDefine = DataDefine
UIActEasterEggTaskView.DataDestroy = DataDestroy
UIActEasterEggTaskView.OnAddListener = OnAddListener
UIActEasterEggTaskView.OnRemoveListener = OnRemoveListener
UIActEasterEggTaskView.OnBtnCloseClick = OnBtnCloseClick
return UIActEasterEggTaskView
