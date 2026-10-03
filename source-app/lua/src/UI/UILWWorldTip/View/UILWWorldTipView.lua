local UILWWorldTipView = BaseClass("UILWWorldTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UILWWorldTipTab = require("UI.UILWWorldTip.Component.UILWWorldTipTab")
local UILWWorldTipPage = require("UI.UILWWorldTip.Component.UILWWorldTipPage")
local UILWWorldTipToggle = require("UI.UILWWorldTip.Component.UILWWorldTipToggle")
local compBook = {
  {
    path = "black",
    name = "bg",
    type = UIButton
  },
  {
    path = "bg/bg_top/txtTitle",
    name = "title",
    type = UITextMeshProUGUIEx
  },
  {
    path = "bg/bg_top/btnClose",
    name = "closeBtn",
    type = UIButton
  },
  {
    path = "bg/scrollTabs",
    name = "scrollTabs",
    type = UIBaseComponent
  },
  {
    path = "bg/scrollTabs/Viewport/Content",
    name = "tabContainer",
    type = UIBaseContainer
  },
  {
    path = "bg/bg_2/jumpTo",
    name = "jumpTo",
    type = UIBaseContainer
  },
  {
    path = "bg/bg_2/jumpTo/jumpToLabel",
    name = "jumpToDesc",
    type = UITextMeshProUGUIEx
  },
  {
    path = "bg/bg_2/jumpTo/jumpToBtn",
    name = "jumpToBtn",
    type = UIButton
  },
  {
    path = "bg/bg_2/jumpTo/jumpToBtn/jumpToBtnText",
    name = "jumpToBtnText",
    type = UITextMeshProUGUIEx
  },
  {
    path = "bg/bg_2/ScrollView/Viewport/ScrollContent",
    name = "scroll_content",
    type = UIBaseContainer
  },
  {
    path = "bg/bg_2/ScrollView",
    name = "scroll_view",
    type = UILoopListView2
  },
  {
    path = "bg/bg_2/SingleScrollView/Viewport/Content",
    name = "single_scroll_content",
    type = UILWWorldTipPage
  },
  {
    path = "bg/bg_2/SingleScrollView",
    name = "single_scroll_view",
    type = UIBaseComponent
  },
  {
    path = "bg/bg_2/toggleView/toggleContent",
    name = "toggle_content",
    type = UIBaseContainer
  },
  {
    path = "bg/bg_2/toggleView/toggleContent/toggleItem",
    name = "toggle_item",
    type = UIBaseComponent
  }
}

local function GetScrollItem(self, listview, index)
  index = index + 1
  if index < 1 or index > #self.seriesData then
    return nil
  end
  local item = listview:NewListViewItem("Page")
  local script = self.scroll_content:GetComponent(item.gameObject.name, UILWWorldTipPage)
  if script == nil then
    local objectName = tostring(NameCount)
    NameCount = NameCount + 1
    item.gameObject.name = objectName
    script = self.scroll_content:AddComponent(UILWWorldTipPage, objectName)
  end
  script:SetData(self.seriesData[index])
  return item
end

local function OnItemSnapFinish(self, listView, item)
  self.selectIndex = item.ItemIndex + 1
  self:RefreshToggles()
end

local function OnItemSnapNearestChanged(self, listView, item)
  self.selectIndex = item.ItemIndex + 1
  self:RefreshToggles()
end

function UILWWorldTipView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshTabs()
end

function UILWWorldTipView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UILWWorldTipView:OnAddListener()
  base.OnAddListener(self)
end

function UILWWorldTipView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWWorldTipView:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.bg:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.jumpToBtn:SetOnClick(function()
    self:OnJumpToBtnClick()
  end)
  self.scroll_view:InitListViewParam(0, function(listview, index)
    return GetScrollItem(self, listview, index)
  end)
  self.scroll_view:SetOnSnapItemFinished(function(listView, item)
    OnItemSnapFinish(self, listView, item)
  end)
  self.scroll_view:SetOnSnapNearestChanged(function(listView, item)
    OnItemSnapNearestChanged(self, listView, item)
  end)
  self.toggle_item:SetActive(false)
  self.toggle_item.gameObject:GameObjectCreatePool()
  self.selectIndex = 1
end

function UILWWorldTipView:DataDefine()
  local param = self:GetUserData()
  if type(param) == "number" then
    local datas = DataCenter.LWWorldTipManager:GetDataByGroup(param)
    self.datas = datas or {}
  elseif type(param) == "table" then
    self.datas = param
  end
end

function UILWWorldTipView:ComponentDestroy()
  self:ClearAllTabs()
  self:ClearAllPagesAndToggles()
  self:ClearCompsByBook(compBook)
end

function UILWWorldTipView:DataDestroy()
  self.datas = nil
  self.seriesData = nil
end

function UILWWorldTipView:RefreshTabs()
  self:ClearAllTabs()
  if table.count(self.datas) <= 0 then
    return
  end
  self.modelTabs = {}
  self.tabItems = {}
  for i, v in ipairs(self.datas) do
    self.modelTabs[i] = self:GameObjectInstantiateAsync(UIAssets.UILWWorldTipTabItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.tabContainer.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.name = "UILWWorldTipTabItem" .. (v.id or i)
      local item = self.tabContainer:AddComponent(UILWWorldTipTab, go.name)
      item:SetData(v, i)
      self.tabItems[i] = item
      if i == 1 then
        self:OnTabClick(1)
      end
    end)
  end
  local data = self.datas[1]
  if data ~= nil then
    self.title:SetLocalText(data.UI_title_key)
  end
  self.scrollTabs:SetActive(#self.datas > 1)
end

function UILWWorldTipView:ClearAllTabs()
  self.tabContainer:RemoveComponents(UILWWorldTipTab)
  if self.modelTabs ~= nil then
    for k, v in pairs(self.modelTabs) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

function UILWWorldTipView:OnTabClick(tabIndex)
  if self.curTab ~= nil and self.curTab == tabIndex then
    return
  end
  if self.curTab ~= nil then
    local item = self.tabItems[self.curTab]
    if item then
      item:SetUnSelected()
    end
  end
  self.curTab = tabIndex
  if self.curTab ~= nil then
    local item = self.tabItems[self.curTab]
    if item then
      item:SetSelected()
    end
  end
  self:RefreshSeries()
end

function UILWWorldTipView:RefreshSeries()
  if not self.curTab then
    return
  end
  local data = self.datas[self.curTab]
  if not data then
    return
  end
  local go = data.if_go
  if go then
    self.jumpTo:SetActive(true)
    local goKey = data.if_go_key
    if not string.IsNullOrEmpty(goKey) then
      self.jumpToDesc:SetText(Localization:GetString(goKey))
    else
      self.jumpToDesc:SetText(nil)
    end
  else
    self.jumpTo:SetActive(false)
  end
  self.seriesData = data.series
  self:ClearAllPagesAndToggles()
  self:InitPagesAndToggles()
  self:RefreshToggles()
end

function UILWWorldTipView:ClearAllPagesAndToggles()
  self.toggle_content:RemoveComponents(UILWWorldTipToggle)
  self.toggle_item.gameObject:GameObjectRecycleAll()
  self.toggle_item_list = {}
  self.scroll_content:RemoveComponents(UILWWorldTipPage)
  self.scroll_view:ClearAllItems()
end

function UILWWorldTipView:InitPagesAndToggles()
  if not self.seriesData or #self.seriesData == 0 then
    return
  end
  local showNum = #self.seriesData
  if 1 < showNum then
    self.single_scroll_view:SetActive(false)
    self.toggle_content:SetActive(true)
    self.scroll_view:SetActive(true)
    for i = 1, showNum do
      local item = self.toggle_item.gameObject:GameObjectSpawn(self.toggle_content.transform)
      item.name = i
      local obj = self.toggle_content:AddComponent(UILWWorldTipToggle, item.name)
      obj:SetActive(true)
      self.toggle_item_list[i] = obj
      obj:SetData(i, self.selectIndex, function(index)
        self:OnToggleBtnClick(index)
      end)
    end
    self.scroll_view:SetListItemCount(showNum, false, false)
    self.scroll_view:RefreshAllShownItem()
  elseif showNum == 1 then
    self.single_scroll_view:SetActive(true)
    self.toggle_content:SetActive(false)
    self.scroll_view:SetActive(false)
    self.single_scroll_content:SetData(self.seriesData[1])
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.single_scroll_content.transform)
  end
end

function UILWWorldTipView:RefreshToggles()
  for i = 1, #self.toggle_item_list do
    self.toggle_item_list[i]:SetBeSelectData(self.selectIndex)
  end
end

function UILWWorldTipView:OnToggleBtnClick(index)
  self.scroll_view:MovePanelToItemIndex(index - 1, 0)
end

function UILWWorldTipView:OnJumpToBtnClick()
end

return UILWWorldTipView
