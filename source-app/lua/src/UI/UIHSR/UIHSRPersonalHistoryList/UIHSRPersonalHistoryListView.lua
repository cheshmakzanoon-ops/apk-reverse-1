local UIHSRPersonalHistoryListView = BaseClass("UIHSRPersonalHistoryListView", UIBaseView)
local HistoryConsignComponent = require("UI.UIHSR.UIHSRPersonalHistoryList.HistoryConsignComponent")
local HistoryRobComponent = require("UI.UIHSR.UIHSRPersonalHistoryList.HistoryRobComponent")
local HistoryDumpComponent = require("UI.UIHSR.UIHSRPersonalHistoryList.HistoryDumpComponent")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local TabType = {Trade = 1, Rob = 2}
local REQ_COUNT_EVERY_TIME = 20
local types = {
  MailType.ZONE_TRAIN_BATTLE_RESULT
}

function UIHSRPersonalHistoryListView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UIHSRPersonalHistoryListView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIHSRPersonalHistoryListView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textUnselectText2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.compSelect2 = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.textSelectText1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textSelectText2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseComponent, 8)
  self.textUnselectText1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.compSelect1 = self.viewSkin:AddComponent(self, UIBaseComponent, 10)
  self.btnToggle1 = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnToggle1:SetOnClick(function()
    self:OnBtnToggleClick(1)
  end)
  self.btnToggle2 = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnToggle2:SetOnClick(function()
    self:OnBtnToggleClick(2)
  end)
  self.textTitle:SetLocalText("activity_1200044_tips36")
  self.textUnselectText1:SetLocalText("activity_1200044_tips15")
  self.textSelectText1:SetLocalText("activity_1200044_tips15")
  self.textUnselectText2:SetLocalText("activity_1200044_tips57")
  self.textSelectText2:SetLocalText("activity_1200044_tips57")
  self.emptyTip = self:AddComponent(UITextMeshProUGUIEx, "PopUpContent/root/Empty")
  self.emptyTip:SetLocalText("120178")
  self.scrollView = self:AddComponent(UILoopListView2, "PopUpContent/root/ScrollView")
  self.loopListView = self:AddComponent(UILoopListView2, "PopUpContent/root/LoopListView")
  self.content = self:AddComponent(UIBaseContainer, "PopUpContent/root/LoopListView/Viewport/Content")
  self.loopListView:InitListView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
  self.loopListView:SetOnDragingAction(function()
    self:OnDraggingAction()
  end)
  self.loopListView:SetOnEndDragAction(function(...)
    self:OnEndDragAction()
  end)
  self.items = {}
end

function UIHSRPersonalHistoryListView:ComponentDestroy()
  self:ClearAllTradeItems()
  self.items = {}
  self.content:RemoveComponents(HistoryRobComponent)
  self.loopListView:ClearAllItems()
  self.loopListView = nil
  self.viewSkin = nil
  self.btnPanel = nil
  self.btnClose = nil
  self.textTitle = nil
  self.textUnselectText2 = nil
  self.compSelect2 = nil
  self.textSelectText1 = nil
  self.textSelectText2 = nil
  self.compContent = nil
  self.textUnselectText1 = nil
  self.compSelect1 = nil
  self.btnToggle1 = nil
  self.btnToggle2 = nil
end

function UIHSRPersonalHistoryListView:DataDefine()
  self.tabType = self:GetUserData() or TabType.Trade
  DataCenter.HSRDataManager:FetchAllMyHistory()
  self.recordList = {}
  self.startIndex = 0
end

function UIHSRPersonalHistoryListView:DataDestroy()
  self.recordList = {}
  self.startIndex = 0
end

function UIHSRPersonalHistoryListView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.HSRPersonalHistoryListRefresh, self.OnHSRPersonalHistoryListRefresh)
end

function UIHSRPersonalHistoryListView:OnRemoveListener()
  self:RemoveUIListener(EventId.HSRPersonalHistoryListRefresh, self.OnHSRPersonalHistoryListRefresh)
  base.OnRemoveListener(self)
end

function UIHSRPersonalHistoryListView:OnHSRPersonalHistoryListRefresh()
  if self.tabType == TabType.Trade then
    self:RefreshTrade()
  end
end

function UIHSRPersonalHistoryListView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIHSRPersonalHistoryListView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIHSRPersonalHistoryListView:OnBtnToggleClick(tabType)
  self.tabType = tabType
  self:RefreshView()
end

function UIHSRPersonalHistoryListView:RefreshView()
  self:RefreshToggle()
  if self.tabType == TabType.Trade then
    self:RefreshTrade()
  elseif self.tabType == TabType.Rob then
    self:RefreshRob()
  end
end

function UIHSRPersonalHistoryListView:RefreshToggle()
  self.compSelect1:SetActive(self.tabType == TabType.Trade)
  self.compSelect2:SetActive(self.tabType == TabType.Rob)
end

function UIHSRPersonalHistoryListView:RefreshTrade()
  self.scrollView:SetActive(true)
  self.loopListView:SetActive(false)
  self:ClearAllTradeItems()
  local dataList = DataCenter.HSRDataManager:GetAllMyHistory()
  self.emptyTip:SetActive(table.IsNullOrEmpty(dataList))
  for _, v in ipairs(dataList) do
    local item
    if v.sellType == HSRSellType.Consign then
      item = self.compContent:LoadComponentAsync(HistoryConsignComponent, "Assets/Main/SeasonRes/S5/Prefabs/UI/HSR/HistoryConsign.prefab")
    elseif v.sellType == HSRSellType.Dump then
      item = self.compContent:LoadComponentAsync(HistoryDumpComponent, "Assets/Main/SeasonRes/S5/Prefabs/UI/HSR/HistoryDump.prefab")
    end
    item:SetData(v)
    table.insert(self.tradeItems, item)
  end
end

function UIHSRPersonalHistoryListView:ClearAllTradeItems()
  if self.tradeItems then
    for _, v in pairs(self.tradeItems) do
      self.compContent:RemoveAsyncComponent(v)
    end
  end
  self.tradeItems = {}
end

function UIHSRPersonalHistoryListView:RefreshRob()
  self.scrollView:SetActive(false)
  self.loopListView:SetActive(true)
  self:GetListData()
end

local NameCount = 0

function UIHSRPersonalHistoryListView:GetScrollItem(listview, index)
  local dataList = self.recordList
  if dataList == nil or #dataList <= 0 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #dataList then
    return nil
  end
  local csItem = listview:NewListViewItem("HistoryRob")
  if self.items[csItem] == nil then
    NameCount = NameCount + 1
    local nameStr = "HistoryRob" .. NameCount
    csItem.gameObject.name = nameStr
    local mailItem = self.content:AddComponent(HistoryRobComponent, nameStr)
    self.items[csItem] = mailItem
  end
  self.items[csItem]:SetData(dataList[index])
  return csItem
end

function UIHSRPersonalHistoryListView:OnDraggingAction()
  local _totalCnt = #self.recordList
  if self._loadingMail == true then
    return
  end
  local _lastItem = self.loopListView:GetShownItemByItemIndex(_totalCnt - 1)
  if _lastItem == nil then
    return
  end
  local _lastItemY = self.loopListView:GetItemCornerPosInViewPort(_lastItem).y
  local _viewPortSize = self.loopListView.unity_looplistview2.ViewPortSize
  if 50 <= _lastItemY + _viewPortSize then
    self._toLoadMore = true
  end
end

function UIHSRPersonalHistoryListView:OnEndDragAction()
  if self._toLoadMore == true then
    self._loadingMail = false
    self._toLoadMore = false
    if #self.recordList >= self.startIndex + REQ_COUNT_EVERY_TIME then
      self:GetMoreRecord()
    end
  end
end

function UIHSRPersonalHistoryListView:GetMoreRecord()
  self.startIndex = self.startIndex + REQ_COUNT_EVERY_TIME
  self:GetListData()
end

function UIHSRPersonalHistoryListView:GetListData()
  DataCenter.MailDataManager:ReqMailByTypes(types, self.startIndex, REQ_COUNT_EVERY_TIME, function(mailDatas)
    if self.startIndex then
      local uids = {}
      for k, v in ipairs(mailDatas) do
        self.recordList[self.startIndex + k] = v
        table.insert(uids, v.uid)
      end
      Logger.LogInfo("RobRecord ReqMailByTypes " .. #uids .. " " .. table.concat(uids, ","))
      self.emptyTip:SetActive(table.IsNullOrEmpty(self.recordList))
      self.loopListView:SetListItemCount(#self.recordList, false, false)
      self.loopListView:RefreshAllShownItem()
    end
  end)
end

return UIHSRPersonalHistoryListView
