local UIActEasterEggRulesView = BaseClass("UIActEasterEggRulesView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UICommonTab = require("UI.UICommonTab.UICommonTab")
local UIActEasterEggPercentDisplayItem = require("UI.LWUIActEasterEgg.Rules.Component.UIActEasterEggPercentDisplayItem")

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

local function ComponentDefine(self)
  self.btnPanel = self:AddComponent(UIButton, "panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.compDetailPanel = self:AddComponent(UIBaseContainer, "PopUpTitle/detailPanel")
  self.txtDetail = self:AddComponent(UIText, "PopUpTitle/detailPanel/Viewport/detailContent1")
  self.compPercentPanel = self:AddComponent(UIBaseContainer, "PopUpTitle/percentPanel")
  self.btnClose = self:AddComponent(UIButton, "PopUpTitle/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnView = self:AddComponent(UIButton, "PopUpTitle/viewBtn")
  self.btnView:SetOnClick(function()
    self:OnBtnViewClick()
  end)
  self.compContent = self:AddComponent(UIBaseContainer, "PopUpTitle/percentPanel/itemList/Viewport/Content")
  self.loopListView2ItemList = self:AddComponent(UILoopListView2, "PopUpTitle/percentPanel/itemList")
  self.compDetailTab = self:AddComponent(UICommonTab, "PopUpTitle/detailTab")
  self.compPercentTab = self:AddComponent(UICommonTab, "PopUpTitle/percentTab")
  self.loopListView2ItemList:InitListView(0, function(loopScroll, index, item)
    return self:OnGetItemByIndex(loopScroll, index)
  end)
  self.itemIndex = 0
end

local function ComponentDestroy(self)
  self.rewardList = nil
  self.compContent:RemoveComponents(UIActEasterEggPercentDisplayItem)
  self.loopListView2ItemList:ClearAllItems()
  self.itemIndex = nil
  self.txtDetail = nil
  self.btnPanel = nil
  self.compDetailTab = nil
  self.compPercentTab = nil
  self.compDetailPanel = nil
  self.compPercentPanel = nil
  self.btnClose = nil
  self.btnView = nil
  self.compContent = nil
  self.loopListView2ItemList = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function UIActEasterEggRulesView:ReInit()
  self.defaultTabTagId = self:GetUserData()
  self:InitTab()
  self:Refresh()
end

function UIActEasterEggRulesView:InitTab()
  local detailTab = {}
  detailTab.tabId = 1
  detailTab.title = Localization:GetString("activity_99144_ui_2a")
  detailTab.clickHandler = self.OnTabClick
  detailTab.containPanel = self.compDetailPanel
  local activityData = DataCenter.ActEasterEggManager:GetActivityData()
  if activityData then
    local configData = DataCenter.ActEasterEggManager:GetEggConfigData()
    local todayPickUp = configData and configData.pickingUpTimes or 0
    local pickUpLimit = activityData.pickUpNumLimit
    local pickUpNum = activityData.pickUpNum
    local detail = Localization:GetString("activity_desc_99144", todayPickUp, pickUpNum, pickUpLimit)
    self.txtDetail:SetText(detail)
  end
  self.compDetailTab:ReInit(detailTab)
  self.compDetailTab:SetSelect(false)
  local percentTab = {}
  percentTab.tabId = 2
  percentTab.title = Localization:GetString("activity_99144_ui_2b")
  percentTab.clickHandler = self.OnTabClick
  percentTab.containPanel = self.compPercentPanel
  self.compPercentTab:ReInit(percentTab)
  self.compPercentTab:SetSelect(false)
  if self.defaultTabTagId == nil then
    self.defaultTabTagId = 1
  end
  self.tabMap = {}
  self.tabMap[1] = self.compDetailTab
  self.tabMap[2] = self.compPercentTab
  self:OnTabClick(self.tabMap[self.defaultTabTagId])
end

function UIActEasterEggRulesView:Refresh()
  self.rewardList = DataCenter.ActEasterEggManager.eggConfig.eggDropDisplay
  self.loopListView2ItemList:SetListItemCount(#self.rewardList, false, false)
  self.loopListView2ItemList:RefreshAllShownItem()
end

function UIActEasterEggRulesView:OnGetItemByIndex(loopScroll, index)
  if self.rewardList ~= nil then
    local count = #self.rewardList
    index = index + 1
    if index < 1 or count < index then
      return nil
    end
    local item = loopScroll:NewListViewItem("UIActEasterEggPercentDisplayItem")
    local script = self.compContent:GetComponent(item.gameObject.name, UIActEasterEggPercentDisplayItem)
    if script == nil then
      self.itemIndex = self.itemIndex + 1
      local name = "item_" .. self.itemIndex
      item.gameObject.name = name
      script = self.compContent:AddComponent(UIActEasterEggPercentDisplayItem, name)
    end
    local data = self.rewardList[index]
    script:ReInit(data)
    return item
  end
end

function UIActEasterEggRulesView:OnTabClick(tabItem)
  if self.curTab ~= nil then
    if self.curTab.tabId == tabItem.tabId then
      return
    else
      self.curTab:SetSelect(false)
    end
  end
  self.curTab = tabItem
  self.curTab:SetSelect(true)
end

local function OnBtnPanelClick(self)
  self.ctrl:CloseSelf()
end

local function OnBtnCloseClick(self)
  self.ctrl:CloseSelf()
end

local function OnBtnViewClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActEasterEggRulesGamePlay, {anim = true})
end

UIActEasterEggRulesView.OnCreate = OnCreate
UIActEasterEggRulesView.OnDestroy = OnDestroy
UIActEasterEggRulesView.OnEnable = OnEnable
UIActEasterEggRulesView.OnDisable = OnDisable
UIActEasterEggRulesView.ComponentDefine = ComponentDefine
UIActEasterEggRulesView.ComponentDestroy = ComponentDestroy
UIActEasterEggRulesView.DataDefine = DataDefine
UIActEasterEggRulesView.DataDestroy = DataDestroy
UIActEasterEggRulesView.OnAddListener = OnAddListener
UIActEasterEggRulesView.OnRemoveListener = OnRemoveListener
UIActEasterEggRulesView.OnBtnPanelClick = OnBtnPanelClick
UIActEasterEggRulesView.OnBtnCloseClick = OnBtnCloseClick
UIActEasterEggRulesView.OnBtnViewClick = OnBtnViewClick
return UIActEasterEggRulesView
