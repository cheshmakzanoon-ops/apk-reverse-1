local base = UIBaseView
local LWUIZoneMobilizationTaskView = BaseClass("LWUIZoneMobilizationTaskView", base)
local LWUIZoneMobilizationDailyTaskItemRender = require("UI.LWUIZoneMobilization.LWUITask.Component.LWUIZoneMobilizationDailyTaskItemRender")
local panelBtn_path = "panel"
local titleText_path = "PopUpContent/TitleText"
local closeBtn_path = "PopUpContent/CloseBtn"
local dailyTaskScrollView_path = "PopUpContent/DailyTaskScrollView"
local emptyTaskTipsText_path = "PopUpContent/EmptyTaskTipsText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitData()
end

local function OnDestroy(self)
  self:RemoveDailyTaskScroll()
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
  self.panelBtn = self:AddComponent(UIButton, panelBtn_path)
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.dailyTaskScrollView = self:AddComponent(UIScrollView, dailyTaskScrollView_path)
  self.emptyTaskTipsText = self:AddComponent(UIText, emptyTaskTipsText_path)
  self.titleText:SetLocalText("zone_mobilization_task_daily")
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.panelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.dailyTaskScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnDailyTaskItemMoveIn(itemObj, index)
  end)
  self.dailyTaskScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnDailyTaskItemMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self.panelBtn = nil
  self.titleText = nil
  self.closeBtn = nil
  self.dailyTaskScrollView = nil
  self.emptyTaskTipsText = nil
end

local function DataDefine(self)
  self.dailyTaskViewDataList = {}
end

local function DataDestroy(self)
  self.dailyTaskViewDataList = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetZoneMobilizationDailyTaskData, self.ShowDailyTaskView)
  self:AddUIListener(EventId.UpdateZoneMobilizationDailyTaskData, self.ShowDailyTaskView)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.GetZoneMobilizationDailyTaskData, self.ShowDailyTaskView)
  self:RemoveUIListener(EventId.UpdateZoneMobilizationDailyTaskData, self.ShowDailyTaskView)
  base.OnRemoveListener(self)
end

local function InitData(self)
  SFSNetwork.SendMessage(MsgDefines.GetZoneMobilizationTaskInfo, 1)
  self:ShowDailyTaskView()
end

local function ShowDailyTaskView(self)
  self:RemoveDailyTaskScroll()
  local taskDict = DataCenter.LWZoneMobilizationManager:GetZoneMobilizationDailyTaskData()
  local taskCount = table.count(taskDict)
  if 0 < taskCount then
    self.emptyTaskTipsText:SetText("")
    self.dailyTaskViewDataList = table.values(taskDict)
    table.sort(self.dailyTaskViewDataList, function(a, b)
      local aStateOrder = a.state == TaskState.Received and -1 or a.state
      local bStateOrder = b.state == TaskState.Received and -1 or b.state
      if aStateOrder == bStateOrder then
        local aTemplate = DataCenter.QuestTemplateManager:GetQuestTemplate(a.taskId)
        local bTemplate = DataCenter.QuestTemplateManager:GetQuestTemplate(b.taskId)
        if aTemplate and bTemplate then
          return aTemplate.order < bTemplate.order
        end
        return a.taskId < b.taskId
      end
      return aStateOrder > bStateOrder
    end)
    self.dailyTaskScrollView:SetTotalCount(taskCount)
    self.dailyTaskScrollView:RefillCells()
  else
    self.emptyTaskTipsText:SetLocalText("zone_mobilization_task_daily_end")
  end
end

local function OnDailyTaskItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local itemRender = self.dailyTaskScrollView:AddComponent(LWUIZoneMobilizationDailyTaskItemRender, itemObj)
  if itemRender ~= nil then
    itemRender:InitData(self.dailyTaskViewDataList[index])
  end
end

local function OnDailyTaskItemMoveOut(self, itemObj, index)
  self.dailyTaskScrollView:RemoveComponent(itemObj.name, LWUIZoneMobilizationDailyTaskItemRender)
end

local function RemoveDailyTaskScroll(self)
  self.dailyTaskScrollView:ClearCells()
  self.dailyTaskScrollView:RemoveComponents(LWUIZoneMobilizationDailyTaskItemRender)
end

LWUIZoneMobilizationTaskView.OnCreate = OnCreate
LWUIZoneMobilizationTaskView.OnDestroy = OnDestroy
LWUIZoneMobilizationTaskView.OnEnable = OnEnable
LWUIZoneMobilizationTaskView.OnDisable = OnDisable
LWUIZoneMobilizationTaskView.ComponentDefine = ComponentDefine
LWUIZoneMobilizationTaskView.ComponentDestroy = ComponentDestroy
LWUIZoneMobilizationTaskView.DataDefine = DataDefine
LWUIZoneMobilizationTaskView.DataDestroy = DataDestroy
LWUIZoneMobilizationTaskView.OnAddListener = OnAddListener
LWUIZoneMobilizationTaskView.OnRemoveListener = OnRemoveListener
LWUIZoneMobilizationTaskView.InitData = InitData
LWUIZoneMobilizationTaskView.ShowDailyTaskView = ShowDailyTaskView
LWUIZoneMobilizationTaskView.OnDailyTaskItemMoveIn = OnDailyTaskItemMoveIn
LWUIZoneMobilizationTaskView.OnDailyTaskItemMoveOut = OnDailyTaskItemMoveOut
LWUIZoneMobilizationTaskView.RemoveDailyTaskScroll = RemoveDailyTaskScroll
return LWUIZoneMobilizationTaskView
