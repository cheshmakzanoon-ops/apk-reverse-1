local base = UIBaseView
local UILWMomentPushView = BaseClass("UILWMomentPushView", base)
local UILWMomentPushItem = require("UI.UILWMomentPush.Component.UILWMomentPushItem")
local UITabBtnItem = require("UI.UILWMomentPush.Component.TabBtnItem")
local scrollView_path = "Root/middle/pushItemList"
local closeBtn_path = "Root/BottomBar/BtnBack"
local scrollViewContent_path = "Root/middle/pushItemList/MainViewport/MainContent"

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

local tab_item_path = "Root/middle/tabLayout/tabItem"
local tabs_path = "Root/middle/tabLayout/Tabs"

local function ComponentDefine(self)
  self.scrollView = self:AddComponent(UILoopListView2, scrollView_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.scrollViewContent = self:AddComponent(UIBaseContainer, scrollViewContent_path)
  self.momentNotDefaultText = self:AddComponent(UIText, "Root/middle/momentNotDefaultText")
  self.closeBtn:SetOnClick(BindCallback(self.view.ctrl, self.view.ctrl.CloseSelf))
  
  function self.scrollView.unity_looplistview2.mOnBeginDragAction()
  end
  
  function self.scrollView.unity_looplistview2.mOnDragingAction()
  end
  
  function self.scrollView.unity_looplistview2.mOnEndDragAction()
    self:OnDragEndAction()
  end
  
  self.momentNotDefaultText:SetActive(false)
  self.tabLayout = self:AddComponent(UIBaseContainer, tabs_path)
  self.tabItem = self:AddComponent(UIBaseComponent, tab_item_path)
  self.itemObj = self.tabItem.gameObject
  self.itemObj:GameObjectCreatePool()
  self.scrollView:InitListViewParam2(0, function(listview, index)
    return self:OnGetItemByIndex(listview, index)
  end, nil, nil, function(loopListViewItem)
    self:OnRecycleItemFunc(loopListViewItem)
  end)
end

local function ComponentDestroy(self)
  self.tabLayout:RemoveComponents(UITabBtnItem)
  self.itemObj:GameObjectRecycleAll()
  self.scrollView.unity_looplistview2.mOnBeginDragAction = nil
  self.scrollView.unity_looplistview2.mOnDragingAction = nil
  self.scrollView.unity_looplistview2.mOnEndDragAction = nil
  self.scrollViewContent:RemoveComponents(UILWMomentPushItem)
  self.scrollView:RecycleAllItem()
  self.scrollView = nil
  self.tipBtn = nil
  self.closeBtn = nil
  self.scrollViewContent = nil
end

local function DataDefine(self)
  self._objList = {}
  self.list = {}
  self.tabItemDic = {}
  self.lastMessageTimestamp = nil
  self.loadingMessageTimestamp = nil
end

local function DataDestroy(self)
  self._objList = {}
  self.list = {}
  self.tabItemDic = {}
  self.lastMessageTimestamp = nil
  self.loadingMessageTimestamp = nil
end

function UILWMomentPushView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_MOMENT_TIPS_HISTORY, self.OnHistoryDataResp)
end

function UILWMomentPushView:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_MOMENT_TIPS_HISTORY, self.OnHistoryDataResp)
  base.OnRemoveListener(self)
end

function UILWMomentPushView:ReInit()
  self.tabConfig = self.ctrl:GetTabConfig()
  self.tabLayout:RemoveComponents(UITabBtnItem)
  self.itemObj:GameObjectRecycleAll()
  local goItem, theItem
  for i = 1, #self.tabConfig do
    goItem = self.itemObj:GameObjectSpawn(self.tabLayout.transform)
    goItem.name = string.format("tab_%d", i)
    theItem = self.tabLayout:AddComponent(UITabBtnItem, goItem.name)
    self.tabConfig[i].index = i
    theItem:ReInit(self.tabConfig[i], i, function(data)
      self:OnTabBtnClick(data)
    end)
    goItem:SetActive(true)
    self.tabItemDic[i] = theItem
  end
  self:OnTabBtnClick(self.tabConfig[1])
end

function UILWMomentPushView:OnTabBtnClick(data)
  if self.selectData == data then
    return
  end
  if self.selectData then
    self.tabItemDic[self.selectData.index]:SetIsOn(false)
  end
  self.tabItemDic[data.index]:SetIsOn(true)
  self.selectData = data
  self.list = {}
  self.lastMessageTimestamp = nil
  self.loadingMessageTimestamp = nil
  ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.MomentTipsHistory, self.lastMessageTimestamp, self.selectData.type)
  self:RefreshView()
  self.tabItemDic[data.index]:SetRedNumber(0)
end

function UILWMomentPushView:RefreshView()
  self.scrollView:SetListItemCount(table.length(self.list), false, false)
  self.scrollView:RefreshAllShownItem()
  self.momentNotDefaultText:SetActive(#self.list == 0)
  ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.MomentNoticeRed, self.selectData.type)
  ChatInterface.getMoment():SetMomentMsgRedDot(self.selectData.type, 0)
end

function UILWMomentPushView:OnGetItemByIndex(listView, index)
  self.prefabIndex = self.prefabIndex or 0
  local prefabName = self:GetItemPrefabName(index)
  local item = listView:NewListViewItem(prefabName)
  if item == nil then
    return nil
  end
  if self._objList[item] ~= nil then
    self._objList[item]:SetActive(true)
    self._objList[item]:UpdateItem(self.list[index + 1], index)
  else
    local script = self:GetItemScript(index)
    if script == nil then
      return
    end
    local objectName = prefabName .. "_" .. tostring(self.prefabIndex) .. "_" .. tostring(index)
    item.gameObject.name = tostring(objectName)
    self.prefabIndex = self.prefabIndex + 1
    local temp = self.scrollViewContent:AddComponent(script, item.gameObject)
    temp:SetActive(true)
    temp:UpdateItem(self.list[index + 1], index)
    self._objList[item] = temp
  end
  return item
end

function UILWMomentPushView:OnRecycleItemFunc(loopListViewItem)
  if loopListViewItem == nil then
    return
  end
  local script = self._objList[loopListViewItem]
  if script ~= nil and script.OnRecycleItem then
    script:OnRecycleItem()
    script:SetActive(false)
  end
end

function UILWMomentPushView:GetItemPrefabName(index)
  return "UILWMomentPushItem"
end

function UILWMomentPushView:GetItemScript(index)
  return UILWMomentPushItem
end

function UILWMomentPushView:OnDragEndAction()
  local containerTrans = self.scrollView.unity_looplistview2.ContainerTrans
  if containerTrans.localPosition.y > containerTrans.rect.size.y - self.scrollView.rectTransform.rect.size.y then
    self:PullToLoadHistory()
  end
end

function UILWMomentPushView:PullToLoadHistory()
  ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.MomentTipsHistory, self.lastMessageTimestamp, self.selectData.type)
  self.loadingMessageTimestamp = self.lastMessageTimestamp
end

function UILWMomentPushView:OnHistoryDataResp(t)
  if not (t and t.result) or not t.result.tipsList then
    return
  end
  local list = t.result.tipsList
  if not next(list) then
    return
  end
  table.sort(list, function(a, b)
    return a.timestamp > b.timestamp
  end)
  local message = list[#list]
  self.lastMessageTimestamp = message.timestamp
  if self.loadingMessageTimestamp == self.lastMessageTimestamp then
    return
  end
  local index = #self.list
  for _, v in ipairs(list) do
    table.insert(self.list, v)
  end
  self:RefreshView()
  self.scrollView:MovePanelToItemIndex(index, 0, true)
end

UILWMomentPushView.OnCreate = OnCreate
UILWMomentPushView.OnDestroy = OnDestroy
UILWMomentPushView.OnEnable = OnEnable
UILWMomentPushView.OnDisable = OnDisable
UILWMomentPushView.ComponentDefine = ComponentDefine
UILWMomentPushView.ComponentDestroy = ComponentDestroy
UILWMomentPushView.DataDefine = DataDefine
UILWMomentPushView.DataDestroy = DataDestroy
return UILWMomentPushView
