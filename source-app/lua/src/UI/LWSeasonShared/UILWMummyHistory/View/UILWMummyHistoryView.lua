local UILWMummyHistoryView = BaseClass("UILWMummyHistoryView", UIBaseView)
local base = UIBaseView
local lastActiveTab = 1
local UILWMummyHistoryItem = require("UI.LWSeasonShared.UILWMummyHistory.Component.UILWMummyHistoryItem")
local UILWMummyHistoryConvert = require("UI.LWSeasonShared.UILWMummyHistory.Component.UILWMummyHistoryConvert")
local panel_path = "panel"
local close_btn_path = "PopUpTitle/CloseBtn"
local tab1_path = "PopUpTitle/Root/TabLayout/Tab1"
local tab2_path = "PopUpTitle/Root/TabLayout/Tab2"
local scroll_view_path = "PopUpTitle/Root/Content/ScrollView"
local content_path = "PopUpTitle/Root/Content/ScrollView/Viewport/Content"
local empty_path = "PopUpTitle/Root/Content/Empty"
local loading_path = "PopUpTitle/Root/Content/loading"

function UILWMummyHistoryView:OnCreate()
  base.OnCreate(self)
  self.DeathList = nil
  self.ConvertList = nil
  self.items = {}
  self:ComponentDefine()
  self.scroll_view:InitListView(0, function(listview, index)
    return self:TryGetScrollItem(listview, index)
  end)
  local seasonType = SeasonUtil.GetSeasonType()
  if seasonType == SeasonMapType.Mummy then
    self.tab_item1:SetOnValueChanged(function(tf)
      if tf then
        self:OnTabChanged(1)
      end
    end)
    self.tab_item2:SetOnValueChanged(function(tf)
      if tf then
        self:OnTabChanged(2)
      end
    end)
    if lastActiveTab == 1 then
      self.tab_item1:SetIsOn(true)
    elseif lastActiveTab == 2 then
      self.tab_item2:SetIsOn(true)
    end
    if self.activeTab == nil then
      self:OnTabChanged(lastActiveTab)
    end
  elseif seasonType == SeasonMapType.Darkness or seasonType == SeasonMapType.NineNation then
    self.tab_item1:SetIsOn(true)
    self.tab_item2:SetActive(false)
    self:OnTabChanged(2)
  end
end

function UILWMummyHistoryView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMummyHistoryView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshSeasonMummyDeathHistory, self.UpdateDeathHistory)
  self:AddUIListener(EventId.RefreshSeasonMummyConvertHistory, self.UpdateConvertHistory)
end

function UILWMummyHistoryView:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshSeasonMummyDeathHistory, self.UpdateDeathHistory)
  self:RemoveUIListener(EventId.RefreshSeasonMummyConvertHistory, self.UpdateConvertHistory)
  base.OnRemoveListener(self)
end

function UILWMummyHistoryView:ComponentDefine()
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.tab_item1 = self:AddComponent(UIToggle, tab1_path)
  self.tab_item2 = self:AddComponent(UIToggle, tab2_path)
  self.scroll_view = self:AddComponent(UILoopListView2, scroll_view_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.emptyTips = self:AddComponent(UITextMeshProUGUIEx, empty_path)
  self.loading = self:AddComponent(UIImage, loading_path)
end

function UILWMummyHistoryView:ComponentDestroy()
  self.items = {}
  self.content:RemoveComponents(UILWMummyHistoryItem)
  self.content:RemoveComponents(UILWMummyHistoryConvert)
  self.scroll_view:ClearAllItems()
  self.btn_back = nil
  self.tab_item1 = nil
  self.tab_item2 = nil
  self.scroll_view = nil
  self.content = nil
  self.emptyTips = nil
  self.loading = nil
end

function UILWMummyHistoryView:OnTabChanged(tabIndex)
  local dataCount = 0
  lastActiveTab = tabIndex
  self.activeTab = tabIndex
  if tabIndex == 1 then
    self.dataList = self.DeathList
  else
    self.dataList = self.ConvertList
  end
  if self.dataList == nil then
    if tabIndex == 1 then
      SFSNetwork.SendMessage(MsgDefines.FetchSeasonMummyDeathHistory)
    else
      SFSNetwork.SendMessage(MsgDefines.FetchSeasonMummyConvertHistory)
    end
    self.scroll_view:SetActive(false)
    self.emptyTips:SetActive(false)
  else
    dataCount = #self.dataList
    self.scroll_view:SetActive(0 < dataCount)
    self.emptyTips:SetActive(dataCount == 0)
    if 0 < dataCount then
      self.scroll_view:SetListItemCount(dataCount, true, false)
      self.scroll_view:RefreshAllShownItem()
    end
  end
  self.loading:SetActive(self.dataList == nil)
end

function UILWMummyHistoryView:UpdateDeathHistory(dataList)
  if dataList then
    self.DeathList = dataList
    if self.activeTab == 1 then
      local dataCount = #dataList
      self.dataList = dataList
      self.loading:SetActive(false)
      self.scroll_view:SetActive(0 < dataCount)
      self.emptyTips:SetActive(dataCount == 0)
      if 0 < dataCount then
        self.scroll_view:SetListItemCount(dataCount, true, false)
        self.scroll_view:RefreshAllShownItem()
      end
    end
  end
end

function UILWMummyHistoryView:UpdateConvertHistory(dataList)
  if dataList then
    self.ConvertList = dataList
    if self.activeTab == 2 then
      local dataCount = #dataList
      self.dataList = dataList
      self.loading:SetActive(false)
      self.scroll_view:SetActive(0 < dataCount)
      self.emptyTips:SetActive(dataCount == 0)
      if 0 < dataCount then
        self.scroll_view:SetListItemCount(dataCount, true, false)
        self.scroll_view:RefreshAllShownItem()
      end
    end
  end
end

function UILWMummyHistoryView:TryGetScrollItem(listview, index)
  local dataList = self.dataList
  if dataList == nil or #dataList <= 0 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #dataList then
    return nil
  end
  local csItem
  local data = dataList[index]
  local theScript
  if self.activeTab == 1 then
    csItem = listview:NewListViewItem("HistoryItem")
    theScript = UILWMummyHistoryItem
  elseif self.activeTab == 2 then
    csItem = listview:NewListViewItem("ConvertItem")
    theScript = UILWMummyHistoryConvert
  end
  if csItem then
    if self.items[csItem] == nil then
      local nameStr = "Item" .. UIUtil.GetLoopListItemIndex()
      csItem.gameObject.name = nameStr
      self.items[csItem] = self.content:AddComponent(theScript, nameStr)
    end
    if self.items[csItem] ~= nil then
      self.items[csItem]:ReInit(index, data)
    end
    csItem.gameObject:SetActive(true)
  end
  return csItem
end

return UILWMummyHistoryView
