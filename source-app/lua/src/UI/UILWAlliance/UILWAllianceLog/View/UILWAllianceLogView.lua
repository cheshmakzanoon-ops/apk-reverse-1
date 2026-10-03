local base = UIBaseView
local UILWAllianceLogView = BaseClass("UILWAllianceLogView", base)
local UILWAllianceLogItem = require("UI.UILWAlliance.UILWAllianceLog.Component.UILWAllianceLogItem")
local UICommonTabGroup = require("UI.UICommonTabGroup.UICommonTabGroup")
local closeBtn_path = "safeArea/BottomBar/BtnBack"
local title_path = "safeArea/TopBar/TextTitle"
local svTask_path = "safeArea/MiddleContentContainer/ScrollView"
local svTaskCont_path = "safeArea/MiddleContentContainer/ScrollView/Viewport/Content"
local no_log_txt_path = "safeArea/MiddleContentContainer/noLogTxt"
local tabGroup_path = "safeArea/MiddleContentContainer/UICommonTabGroup"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  DataCenter.AllianceLogManager:ClearAllianceLog()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.titleN = self:AddComponent(UIText, title_path)
  self.titleN:SetLocalText(455080)
  self.svTaskN = self:AddComponent(UILoopListView2, svTask_path)
  self.svTaskCont = self:AddComponent(UIBaseContainer, svTaskCont_path)
  self.svTaskN:InitListView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
  self.svTaskN:SetOnDragingAction(function()
    self:OnDraggingAction()
  end)
  self.svTaskN:SetOnEndDragAction(function(...)
    self:OnEndDragAction()
  end)
  self.no_log_txt = self:AddComponent(UIText, no_log_txt_path)
  self.no_log_txt:SetLocalText(455081)
  self.tabGroup = self:AddComponent(UICommonTabGroup, tabGroup_path)
  self:InitTabGroup()
end

local function ComponentDestroy(self)
  self.taskCellList = nil
  self.closeBtnN = nil
  self.titleN = nil
  self.svTaskN = nil
  self.svTaskCont = nil
  self.no_log_txt = nil
  self.tabGroup = nil
end

local function DataDefine(self)
  self.itemIndex = 0
  self.logList = {}
  self.selectIndex = nil
end

local function DataDestroy(self)
  self.itemIndex = 0
  self.logList = nil
  self.selectIndex = nil
  self.inLoadingMore = nil
  self.needLoadMore = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceLogUpdate, self.RefreshAll)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceLogUpdate, self.RefreshAll)
  base.OnRemoveListener(self)
end

local function InitTabGroup(self)
  local groupList = DataCenter.AllianceLogManager:GetTabGroupList()
  local bindFunc1 = BindCallback(self, self.OnGroupLoadFinsh)
  local bindFunc2 = BindCallback(self, self.OnClickTab)
  
  local function bindFunc3(index)
    return self:RefreshTabRedPoint(index)
  end
  
  self.tabGroup:RefreshGroup(groupList, bindFunc1, bindFunc2, bindFunc3)
end

local function OnGroupLoadFinsh(self)
  self.tabGroup:SelectTab(1)
end

local function OnClickTab(self, index)
  Logger.Log("UILWAllianceLogView : " .. index)
  DataCenter.AllianceLogManager:RequestTabInitLog(index)
  self.selectIndex = index
  self:RefreshAll(true)
end

local function RefreshTabRedPoint(self, index)
  local isRed = false
  return isRed, 0
end

local function UpdateData(self)
end

local function RefreshAll(self, isInit)
  DataCenter.AllianceLogManager:SetTabRed(self.selectIndex, false)
  self.logList = DataCenter.AllianceLogManager:GetAllLog(self.selectIndex)
  if self.logList and #self.logList > 0 then
    self.no_log_txt:SetActive(false)
    self.svTaskN:SetActive(true)
    self.svTaskN:SetListItemCount(#self.logList, isInit ~= nil, false)
    self.svTaskN:RefreshAllShownItem()
  else
    self.no_log_txt:SetActive(true)
    self.svTaskN:SetActive(false)
  end
end

local function ClearScroll(self)
  self.svTaskCont:RemoveComponents(UILWAllianceLogItem)
  self.svTaskN:ClearAllItems()
end

local function GetScrollItem(self, listView, index)
  local count = table.count(self.logList)
  index = index + 1
  if index < 1 or count < index then
    return nil
  end
  local item = listView:NewListViewItem("UILWAllianceLogItem")
  local script = self.svTaskCont:GetComponent(item.gameObject.name, UILWAllianceLogItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    script = self.svTaskCont:AddComponent(UILWAllianceLogItem, objectName)
  end
  script:SetActive(true)
  script:SetItem(self.logList[index])
  return item
end

local function OnDraggingAction(self)
  if self.inLoadingMore then
    return
  end
  local count = #self.logList
  local lastItem = self.svTaskN:GetShownItemByItemIndex(count - 1)
  if lastItem == nil then
    return
  end
  local lastY = self.svTaskN:GetItemCornerPosInViewPort(lastItem).y
  local viewPortSize = self.svTaskN.unity_looplistview2.ViewPortSize
  if 50 <= lastY + viewPortSize then
    self.needLoadMore = true
  end
end

local function OnEndDragAction(self)
  if self.needLoadMore then
    self.inLoadingMore = false
    self.needLoadMore = false
    self:GetMoreLog()
  end
end

local function GetMoreLog(self)
  if self.logList and #self.logList > 0 and DataCenter.AllianceLogManager:GetNeedGetMore(self.selectIndex) then
    self.ctrl:ReqMore(self.logList[#self.logList].time, self.selectIndex)
  end
end

UILWAllianceLogView.OnCreate = OnCreate
UILWAllianceLogView.OnDestroy = OnDestroy
UILWAllianceLogView.OnAddListener = OnAddListener
UILWAllianceLogView.OnRemoveListener = OnRemoveListener
UILWAllianceLogView.ComponentDefine = ComponentDefine
UILWAllianceLogView.ComponentDestroy = ComponentDestroy
UILWAllianceLogView.DataDefine = DataDefine
UILWAllianceLogView.DataDestroy = DataDestroy
UILWAllianceLogView.InitTabGroup = InitTabGroup
UILWAllianceLogView.OnGroupLoadFinsh = OnGroupLoadFinsh
UILWAllianceLogView.OnClickTab = OnClickTab
UILWAllianceLogView.ClearScroll = ClearScroll
UILWAllianceLogView.RefreshAll = RefreshAll
UILWAllianceLogView.UpdateData = UpdateData
UILWAllianceLogView.RefreshTabRedPoint = RefreshTabRedPoint
UILWAllianceLogView.GetScrollItem = GetScrollItem
UILWAllianceLogView.OnDraggingAction = OnDraggingAction
UILWAllianceLogView.OnEndDragAction = OnEndDragAction
UILWAllianceLogView.GetMoreLog = GetMoreLog
return UILWAllianceLogView
