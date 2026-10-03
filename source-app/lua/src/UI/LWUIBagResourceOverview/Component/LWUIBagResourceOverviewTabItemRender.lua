local base = UIBaseContainer
local LWUIBagResourceOverviewTabItemRender = BaseClass("LWUIBagResourceOverviewTabItemRender", base)
local Localization = CS.GameEntry.Localization
local tabBtn_path = ""
local tabText_path = "TabText"
local chooseTabText_path = "ChooseState/ChooseTabText"
local chooseState_path = "ChooseState"

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
  self.tabBtn = self:AddComponent(UIButton, tabBtn_path)
  self.tabText = self:AddComponent(UIText, tabText_path)
  self.chooseTabText = self:AddComponent(UIText, chooseTabText_path)
  self.chooseState = self:AddComponent(UIBaseContainer, chooseState_path)
  self.tabBtn:SetOnClick(function()
    self:TabBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.tabBtn = nil
  self.tabText = nil
  self.chooseTabText = nil
  self.chooseState = nil
end

local function DataDefine(self)
  self.itemIndex = 1
  self.tabData = nil
end

local function DataDestroy(self)
  self.itemIndex = nil
  self.tabData = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChangeBagResourceOverviewTab, self.SetSelectState)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.ChangeBagResourceOverviewTab, self.SetSelectState)
  base.OnRemoveListener(self)
end

local function InitData(self, index, tabData, curTabIndex)
  self.itemIndex = index
  self.tabData = tabData
  local tabName = self:GetTabName(self.tabData.tabType)
  self.tabText:SetText(tabName)
  self.chooseTabText:SetText(tabName)
  self:SetSelectState(curTabIndex)
end

local function SetSelectState(self, selectIndex)
  self.chooseState:SetActive(self.itemIndex == selectIndex)
end

local function TabBtnClick(self)
  self.view:OnTabItemClick(self.itemIndex)
  EventManager:GetInstance():Broadcast(EventId.ChangeBagResourceOverviewTab, self.itemIndex)
end

local function GetTabName(self, bagResourceOverviewTabType)
  if bagResourceOverviewTabType == BagResourceOverviewTabType.Resource then
    return Localization:GetString("resource_statistics_title")
  elseif bagResourceOverviewTabType == BagResourceOverviewTabType.SpeedUp then
    return Localization:GetString("speed_statistics_title")
  elseif bagResourceOverviewTabType == BagResourceOverviewTabType.Other then
    return Localization:GetString("other_statistics_title")
  end
  return ""
end

LWUIBagResourceOverviewTabItemRender.OnCreate = OnCreate
LWUIBagResourceOverviewTabItemRender.OnDestroy = OnDestroy
LWUIBagResourceOverviewTabItemRender.OnEnable = OnEnable
LWUIBagResourceOverviewTabItemRender.OnDisable = OnDisable
LWUIBagResourceOverviewTabItemRender.ComponentDefine = ComponentDefine
LWUIBagResourceOverviewTabItemRender.ComponentDestroy = ComponentDestroy
LWUIBagResourceOverviewTabItemRender.DataDefine = DataDefine
LWUIBagResourceOverviewTabItemRender.DataDestroy = DataDestroy
LWUIBagResourceOverviewTabItemRender.OnAddListener = OnAddListener
LWUIBagResourceOverviewTabItemRender.OnRemoveListener = OnRemoveListener
LWUIBagResourceOverviewTabItemRender.InitData = InitData
LWUIBagResourceOverviewTabItemRender.SetSelectState = SetSelectState
LWUIBagResourceOverviewTabItemRender.TabBtnClick = TabBtnClick
LWUIBagResourceOverviewTabItemRender.GetTabName = GetTabName
return LWUIBagResourceOverviewTabItemRender
