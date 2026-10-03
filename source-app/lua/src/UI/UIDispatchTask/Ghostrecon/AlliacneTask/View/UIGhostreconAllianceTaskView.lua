local base = UIBaseView
local UIGhostreconAllianceTaskView = BaseClass("UIGhostreconAllianceTaskView", base)
local UIGhostreconAllianceTaskItem = require("UI.UIDispatchTask.Ghostrecon.AlliacneTask.Component.UIGhostreconAllianceTaskItem")
local titleText_path = "Root/Content/UICommonPopBg/bg_3/TitleTxt"
local closeBtn_path = "Root/Content/UICommonPopBg/bg_3/CloseBtn"
local closePanel_path = "Panel"
local scrollView_path = "Root/Content/ContentHolder/ScrollView"
local tipText_path = "Root/Content/ContentHolder/TipText"
local noneText_path = "Root/Content/ContentHolder/NoneText"

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
  SFSNetwork.SendMessage(MsgDefines.GhostReconGetAllianceTaskList)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.closePanel = self:AddComponent(UIButton, closePanel_path)
  self.scrollView = self:AddComponent(UILoopListView2, scrollView_path)
  self.tipText = self:AddComponent(UIText, tipText_path)
  self.noneText = self:AddComponent(UIText, noneText_path)
  self.scrollView:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.content = self:AddComponent(UIBaseContainer, "Root/Content/ContentHolder/ScrollView/View/Content")
  self.closeBtn:SetOnClick(Bind(self, self.ctrl.CloseSelf))
  self.closePanel:SetOnClick(Bind(self, self.ctrl.CloseSelf))
  self.titleText:SetLocalText("ghostrecon_023")
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self.titleText = nil
  self.closeBtn = nil
  self.closePanel = nil
  self.scrollView = nil
  self.tipText = nil
  self.noneText = nil
  self.content = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.taskList = nil
  self.init = nil
end

local function OnAddListener(self)
  self:AddUIListener(EventId.GhostreconAllianceTaskRefresh, self.Refresh)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.GhostreconAllianceTaskRefresh, self.Refresh)
end

local function Refresh(self)
  self.taskList = DataCenter.ActGhostreconAllianceManager.allianceTaskList
  if self.taskList == nil or #self.taskList == 0 then
    self.noneText:SetActive(true)
    self.scrollView:SetActive(false)
  else
    self.noneText:SetActive(false)
    self.scrollView:SetActive(true)
    if self.init then
      self.scrollView:SetListItemCount(#self.taskList, false, false)
      self.scrollView:RefreshAllShownItem()
    else
      self.scrollView:SetListItemCount(#self.taskList, false, false)
      self.scrollView:MovePanelToItemIndex(0, 0)
      self.init = true
    end
  end
  if DataCenter.ActGhostreconManager:GetTeamworkRewardTimesFull() then
    self.tipText:SetLocalText("ghostrecon_025")
  else
    self.tipText:SetText(DataCenter.ActGhostreconManager:GetTeamworkRewardTimesText())
  end
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollView:AddComponent(UIGhostreconAllianceTaskItem, itemObj)
  cellItem:SetData(self.taskList[index].uuid)
  cellItem:SetActive(true)
end

local function OnItemMoveOut(self, itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, UIGhostreconAllianceTaskItem)
end

local function ClearScroll(self)
  self.scrollView:ClearAllItems()
  self.content:RemoveComponents(UIGhostreconAllianceTaskItem)
  self.scrollCellPool = {}
  self.showDatalist = {}
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.taskList then
    return nil
  end
  local prefabName = self:GetItemPrefabName(index)
  local itemScript = self:GetItemScript(index)
  local item = loopScroll:NewListViewItem(prefabName)
  local script = self.content:GetComponent(item.gameObject.name, itemScript)
  if script == nil then
    local objectName = UIUtil.GetLoopListItemIndex()
    item.gameObject.name = objectName
    script = self.content:AddComponent(itemScript, objectName)
  end
  script:SetActive(true)
  script:SetData(self.taskList[index].uuid)
  return item
end

local function GetItemPrefabName(self, index)
  return "UIGhostreconAllianceTaskItem"
end

local function GetItemScript(self, index)
  return UIGhostreconAllianceTaskItem
end

UIGhostreconAllianceTaskView.OnCreate = OnCreate
UIGhostreconAllianceTaskView.OnDestroy = OnDestroy
UIGhostreconAllianceTaskView.OnEnable = OnEnable
UIGhostreconAllianceTaskView.OnDisable = OnDisable
UIGhostreconAllianceTaskView.ComponentDefine = ComponentDefine
UIGhostreconAllianceTaskView.ComponentDestroy = ComponentDestroy
UIGhostreconAllianceTaskView.DataDefine = DataDefine
UIGhostreconAllianceTaskView.DataDestroy = DataDestroy
UIGhostreconAllianceTaskView.OnAddListener = OnAddListener
UIGhostreconAllianceTaskView.OnRemoveListener = OnRemoveListener
UIGhostreconAllianceTaskView.Refresh = Refresh
UIGhostreconAllianceTaskView.OnItemMoveIn = OnItemMoveIn
UIGhostreconAllianceTaskView.OnItemMoveOut = OnItemMoveOut
UIGhostreconAllianceTaskView.ClearScroll = ClearScroll
UIGhostreconAllianceTaskView.OnGetItemByIndex = OnGetItemByIndex
UIGhostreconAllianceTaskView.GetItemPrefabName = GetItemPrefabName
UIGhostreconAllianceTaskView.GetItemScript = GetItemScript
return UIGhostreconAllianceTaskView
