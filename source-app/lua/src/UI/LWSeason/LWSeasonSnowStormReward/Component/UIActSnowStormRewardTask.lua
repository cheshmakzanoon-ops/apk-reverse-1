local base = UIBaseContainer
local UIActSnowStormRewardTask = BaseClass("UIActSnowStormRewardTask", base)
local UISnowStormRewardTaskItem = require("UI.LWSeason.LWSeasonSnowStormReward.Component.UISnowStormRewardTaskItem")
local loopListView_path = ""
local content_path = "ViewPort/Content"
local SelfNameCount = 0

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
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
  self.loopListView = self:AddComponent(UILoopListView2, loopListView_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
end

local function ComponentDestroy(self)
  self.loopListView = nil
  self.content = nil
end

local function DataDefine(self)
  SelfNameCount = 0
  self.items = {}
  self.loopListView:InitListView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
end

local function DataDestroy(self)
  self.allianceRoundReward = nil
  self:RemoveItems()
  self.loopListView = nil
end

function UIActSnowStormRewardTask:RefreshView(list, panelType, tabType)
  self:RemoveItems()
  self.panelType = panelType
  self.tabType = tabType
  self.allianceRoundReward = list
  if self.allianceRoundReward and #self.allianceRoundReward > 0 then
    self.loopListView:SetListItemCount(#self.allianceRoundReward, false, false)
    self.loopListView:RefreshAllShownItem()
  end
end

function UIActSnowStormRewardTask:GetScrollItem(listview, index)
  local dataList = self.allianceRoundReward
  if dataList == nil or #dataList <= 0 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #dataList then
    return nil
  end
  local csItem = listview:NewListViewItem("TaskCell")
  if self.items[csItem] == nil then
    SelfNameCount = SelfNameCount + 1
    local nameStr = "TaskCell" .. SelfNameCount
    csItem.gameObject.name = nameStr
    self.items[csItem] = self.content:AddComponent(UISnowStormRewardTaskItem, nameStr)
  end
  self.items[csItem]:ReInit(dataList[index], self.panelType, self.tabType)
  return csItem
end

function UIActSnowStormRewardTask:RemoveItems()
  self.items = {}
  self.content:RemoveComponents(UISnowStormRewardTaskItem)
  self.loopListView:ClearAllItems()
end

UIActSnowStormRewardTask.OnCreate = OnCreate
UIActSnowStormRewardTask.OnDestroy = OnDestroy
UIActSnowStormRewardTask.OnEnable = OnEnable
UIActSnowStormRewardTask.OnDisable = OnDisable
UIActSnowStormRewardTask.ComponentDefine = ComponentDefine
UIActSnowStormRewardTask.ComponentDestroy = ComponentDestroy
UIActSnowStormRewardTask.DataDefine = DataDefine
UIActSnowStormRewardTask.DataDestroy = DataDestroy
return UIActSnowStormRewardTask
