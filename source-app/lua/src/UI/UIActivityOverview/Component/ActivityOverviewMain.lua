local ActivityOverviewMain = BaseClass("ActivityOverviewMain", UIBaseContainer)
local base = UIBaseContainer
local ActivityOverviewItem = require("UI.UIActivityOverview.Component.ActivityOverviewItem")
local content_path = "ScrollView/Content"
local svList_path = "ScrollView"
local animMask_path = "animMask"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:SetAllCellDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  DataCenter.DailyActivityManager:UpdateActViewHistory(10)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.listGO = {}
  self.contentN = self:AddComponent(HorizontalInfinityScrollView, content_path)
  self.svListN = self:AddComponent(UIBaseContainer, svList_path)
  self.animMask = self:AddComponent(UIBaseContainer, animMask_path)
  self.animMask:SetActive(true)
  self.playingAnim = true
  TimerManager:GetInstance():DelayInvoke(function()
    self.playingAnim = false
    self.animMask:SetActive(false)
  end, 0.4)
end

local function ComponentDestroy(self)
  self.contentN = nil
  self.svListN = nil
end

local function DataDefine(self)
  self.actOverviewList = {}
  self.playingAnim = true
end

local function DataDestroy(self)
  self.actOverviewList = nil
  self.playingAnim = nil
end

local function OnInitScroll(self, go, index)
  local item = self.svListN:AddComponent(ActivityOverviewItem, go)
  self.listGO[go] = item
end

local function OnUpdateScroll(self, go, index)
  local tempSummary = self.actOverviewList[index + 1]
  local cellItem = self.listGO[go]
  local animIndex = self.playingAnim and index or nil
  cellItem:ReInit(tempSummary, animIndex)
end

local function OnDestroyScrollItem(self, go, index)
end

local function SetAllCellDestroy(self)
  self.svListN:RemoveComponents(ActivityOverviewItem)
  self.contentN:DestroyChildNode()
end

local function ReInit(self)
  self:SetAllCellDestroy()
  local bindFunc1 = BindCallback(self, self.OnInitScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
  self.contentN:Init(bindFunc1, bindFunc2, bindFunc3)
  local tempList = DataCenter.DailyActivityManager:GetActivityOverviewList()
  self.actOverviewList = {}
  for i, v in ipairs(tempList) do
    table.insert(self.actOverviewList, v)
  end
  local tempCount = table.count(self.actOverviewList)
  self.contentN:SetItemCount(tempCount)
  local moveToIndex = self:GetTargetIndex()
  self.contentN:MoveItemByIndex(moveToIndex - 1)
end

local function GetTargetIndex(self)
  local moveToIndex = 1
  local hasNew, newList = DataCenter.DailyActivityManager:GetOverviewNewStatus()
  if hasNew then
    for i, v in ipairs(self.actOverviewList) do
      if v.id == newList[1].id then
        moveToIndex = i
        break
      end
    end
  end
  return moveToIndex
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

ActivityOverviewMain.OnCreate = OnCreate
ActivityOverviewMain.OnDestroy = OnDestroy
ActivityOverviewMain.OnEnable = OnEnable
ActivityOverviewMain.OnDisable = OnDisable
ActivityOverviewMain.ComponentDefine = ComponentDefine
ActivityOverviewMain.ComponentDestroy = ComponentDestroy
ActivityOverviewMain.DataDefine = DataDefine
ActivityOverviewMain.DataDestroy = DataDestroy
ActivityOverviewMain.ReInit = ReInit
ActivityOverviewMain.GetTargetIndex = GetTargetIndex
ActivityOverviewMain.OnAddListener = OnAddListener
ActivityOverviewMain.OnRemoveListener = OnRemoveListener
ActivityOverviewMain.SetAllCellDestroy = SetAllCellDestroy
ActivityOverviewMain.OnInitScroll = OnInitScroll
ActivityOverviewMain.OnDestroyScrollItem = OnDestroyScrollItem
ActivityOverviewMain.OnUpdateScroll = OnUpdateScroll
return ActivityOverviewMain
