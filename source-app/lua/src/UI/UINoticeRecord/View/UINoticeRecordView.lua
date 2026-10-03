local UINoticeRecordView = BaseClass("UINoticeRecordView", UIBaseView)
local base = UIBaseView
local SelectBarContent = require("UI.UINoticeRecord.Component.SelectBarContent")
local TypeMenuContent = require("UI.UINoticeRecord.Component.TypeMenuContent")
local UINoticeRecordItem = require("UI.UINoticeRecord.Component.UINoticeRecordItem")
local UIWebViewContent = require("UI.LWUIAllianceNoticeDetail.Component.UIWebViewContent")
local curtain_path = "curtain"
local btn_close_path = "panel/btnClose"
local type_select_bar_path = "panel/content/TypeSelectBar"
local scroll_view_path = "panel/content/scrollView"
local empty_content_path = "panel/content/EmptyContent"
local select_type_pos_set_path = "panel/content/SelectTypePosSet"
local select_menu_path = "panel/content/SelectMenu"
local content_path = "panel/content/scrollView/Viewport/Content"

function UINoticeRecordView:OnCreate()
  base.OnCreate(self)
  self.ctrl.view = self
  self:ComponentDefine()
  self:DataDefine()
  self:Init()
end

function UINoticeRecordView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  DataCenter.TranslateResultSaveDataManager:ClearAllDoingState(TranslateSaveDataFuncType.NoticeRecord)
  base.OnDestroy(self)
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.showDataList then
    return nil
  end
  local packData = self.showDataList[index]
  local item = loopScroll:NewListViewItem("LWUINoticeRecordItem")
  local script = self.content:GetComponent(item.gameObject.name, UINoticeRecordItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.content:AddComponent(UINoticeRecordItem, objectName)
  end
  script:SetActive(true)
  script:SetData(packData, self.scroll_view, index - 1)
  if index == #self.showDataList then
    DataCenter.AllianceNoticeRecordManager:TryReqMoreRecordData(self.selectFilter)
  end
  return item
end

function UINoticeRecordView:ComponentDefine()
  self.curtain = self:AddComponent(UIButton, curtain_path)
  self.btn_close = self:AddComponent(UIButton, btn_close_path)
  self.curtain:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btn_close:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.type_select_bar = self:AddComponent(SelectBarContent, type_select_bar_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.scroll_view = self:AddComponent(UILoopListView2, scroll_view_path)
  self.scroll_view:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.empty_content = self:AddComponent(UIBaseContainer, empty_content_path)
  self.select_type_pos_set = self:AddComponent(UIBaseContainer, select_type_pos_set_path)
  self.select_menu = self:AddComponent(TypeMenuContent, select_menu_path)
  self.webViewContent = self:AddComponent(UIWebViewContent, "webViewContent")
  self.webViewContent:InitData(function()
  end, function()
  end, NewsCenterOpenType.NoticeRecord)
end

function UINoticeRecordView:ComponentDestroy()
  self:ClearContent()
  self.curtain = nil
  self.btn_close = nil
  self.type_select_bar = nil
  self.scroll_view = nil
  self.empty_content = nil
  self.select_type_pos_set = nil
  self.select_menu = nil
  self.content = nil
end

function UINoticeRecordView:ClearContent()
  self.content:RemoveComponents(UINoticeRecordItem)
  self.scroll_view:ClearAllItems()
end

function UINoticeRecordView:DataDefine()
  self.showDataList = {}
  self.selectFilter = nil
  self.itemIndex = 0
end

function UINoticeRecordView:DataDestroy()
  self.showDataList = {}
  self.selectFilter = nil
  self.itemIndex = nil
end

function UINoticeRecordView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AlNoticeRecordMsgGet, self.OnDataReceive)
  self:AddUIListener(EventId.CHAT_NEWSCENTER_NOTICE_RECORD_VIEW_OPENURL, self.OnOpenURL)
  self:AddUIListener(EventId.CHAT_NEWSCENTER_NOTICE_RECORD_OPENURL, self.OnOpenURL)
  self:AddUIListener(EventId.CHAT_NEWSCENTER_SHARE, self.OnCloseNewsCenterURL)
end

function UINoticeRecordView:OnRemoveListener()
  self:RemoveUIListener(EventId.AlNoticeRecordMsgGet, self.OnDataReceive)
  self:RemoveUIListener(EventId.CHAT_NEWSCENTER_NOTICE_RECORD_VIEW_OPENURL, self.OnOpenURL)
  self:RemoveUIListener(EventId.CHAT_NEWSCENTER_NOTICE_RECORD_OPENURL, self.OnOpenURL)
  self:RemoveUIListener(EventId.CHAT_NEWSCENTER_SHARE, self.OnCloseNewsCenterURL)
  base.OnRemoveListener(self)
end

function UINoticeRecordView:Init()
  DataCenter.AllianceNoticeRecordManager:ClearNextReqTime()
  self.selectFilter = AlNoticeRecordFilterType.All
  self:RefreshData()
  self:RefreshView(true)
end

function UINoticeRecordView:OnOpenURL(data)
  self.webViewContent:OnOpenURL(data)
end

function UINoticeRecordView:OnCloseNewsCenterURL()
  self.webViewContent:CloseWeb()
end

function UINoticeRecordView:BlackWebView()
  if self.webViewContent and self.webViewContent:GetActive() then
    self.webViewContent:OnClickBack()
  else
    self.ctrl:CloseSelf()
  end
end

function UINoticeRecordView:OnFilterChange(filterType)
  if filterType == self.selectFilter then
    return
  end
  self.selectFilter = filterType
  self:RefreshData()
  self:RefreshView(true)
end

function UINoticeRecordView:RefreshData()
  self.showDataList = {}
  DataCenter.AllianceNoticeRecordManager:TryReqStartRecordData(self.selectFilter)
  local curIDList = DataCenter.AllianceNoticeRecordManager:GetDataIdList(self.selectFilter)
  for i, id in ipairs(curIDList) do
    if self.showDataList[i] == nil then
      local data = {id = id, isDetail = false}
      self.showDataList[i] = data
    end
  end
end

function UINoticeRecordView:ChangeItemIsDetail(index, isDetail)
  if self.showDataList[index] == nil then
    return
  end
  self.showDataList[index].isDetail = isDetail
end

function UINoticeRecordView:RefreshView(isMoveTop)
  if isMoveTop then
    self.type_select_bar:SetData(self.selectFilter)
    self:OnMenuHideMsg()
  end
  if #self.showDataList == 0 then
    self.empty_content:SetActive(true)
    self.scroll_view:SetActive(false)
    self.scroll_view:SetListItemCount(#self.showDataList, false, false)
    self.content:SetAnchoredPositionXY(0, 0)
  else
    self.empty_content:SetActive(false)
    self.scroll_view:SetActive(true)
    self.scroll_view:SetListItemCount(#self.showDataList, false, false)
    if isMoveTop then
      self.scroll_view:MovePanelToItemIndex(0)
    end
    self.scroll_view:RefreshAllShownItem()
  end
end

function UINoticeRecordView:OnDataReceive(msg)
  self:RefreshData()
  self:RefreshView()
end

function UINoticeRecordView:OnMenuHideMsg()
  self.select_menu:SetActive(false)
  self.type_select_bar.menuShow = false
  self.type_select_bar:RefreshMenuShowBtn()
end

function UINoticeRecordView:OnSetMenuShow(targetContainer, dataList)
  local targetSizeDelta = targetContainer:GetSizeDelta()
  self.select_type_pos_set:SetSizeDeltaXY(targetSizeDelta.x, targetSizeDelta.y)
  self.select_type_pos_set:SetPosition(targetContainer:GetPosition())
  local posSetPos = self.select_type_pos_set:GetAnchoredPosition()
  self.select_menu:SetActive(true)
  self.select_menu:SetAnchoredPositionXY(posSetPos.x, posSetPos.y - targetSizeDelta.y / 2 + 5)
  self.select_menu:SetData(targetContainer, dataList, self.selectFilter)
end

return UINoticeRecordView
