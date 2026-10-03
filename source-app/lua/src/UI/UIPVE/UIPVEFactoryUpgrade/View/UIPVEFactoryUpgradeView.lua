local UIPVEFactoryUpgradeView = BaseClass("UIPVEFactoryUpgradeView", UIBaseView)
local base = UIBaseView
local UIPVEFactoryUpgradeCell = require("UI.UIPVE.UIPVEFactoryUpgrade.Component.UIPVEFactoryUpgradeCell")
local close_btn_path = "CloseBtn"
local panel_path = "panel"
local trigger_name_path = "Left/NameText"
local trigger_icon_path = "Left/TriggerIcon"
local trigger_desc_path = "Left/DescText"
local cost_btn_path = "Left/CostBtn"
local cost_btn_text_path = "Left/CostBtn/btnTxt2"
local scroll_path = "ScrollView"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn = self:AddComponent(UIButton, panel_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.ScrollView = self:AddComponent(UIScrollView, scroll_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.trigger_name = self:AddComponent(UIText, trigger_name_path)
  self.trigger_icon = self:AddComponent(UIImage, trigger_icon_path)
  self.trigger_desc = self:AddComponent(UIText, trigger_desc_path)
  self.cost_btn = self:AddComponent(UIButton, cost_btn_path)
  self.cost_btn_text = self:AddComponent(UIText, cost_btn_text_path)
  self.cost_btn:SetOnClick(function()
    self:OnCostClick()
  end)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
  self.data = self:GetUserData()
  self.hasListener = false
end

local function DataDestroy(self)
  self.hasListener = false
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self.hasListener = true
  self:AddUIListener(EventId.RefreshResourceItem, self.OnResOrItemUpdate)
  self:AddUIListener(EventId.RefreshItems, self.OnResOrItemUpdate)
  self:AddUIListener(EventId.PVEBuildingUpgradeBack, self.OnResOrItemUpdate)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  if self.hasListener == true then
    self:RemoveUIListener(EventId.RefreshResourceItem, self.OnResOrItemUpdate)
    self:RemoveUIListener(EventId.RefreshItems, self.OnResOrItemUpdate)
    self:RemoveUIListener(EventId.PVEBuildingUpgradeBack, self.OnResOrItemUpdate)
  end
end

local function ReInit(self)
  self:Refresh()
end

local function OnResOrItemUpdate(self)
  self:Refresh()
end

local function OnCostClick(self)
end

local function Refresh(self)
  self:ClearScroll()
  self.panelData = self.ctrl:GetPanelData(self.data)
  self.showDatalist = self.panelData.list
  if self.panelData.isAllDone then
    self.ctrl:CloseSelf()
    return
  end
  self:RefreshTriggerInfo()
  self.ScrollView:SetTotalCount(#self.showDatalist)
  self.ScrollView:RefillCells()
end

local function RefreshTriggerInfo(self)
  self.trigger_name:SetLocalText(self.panelData.name)
  self.trigger_desc:SetLocalText(self.panelData.desc)
  if self.panelData.icon ~= nil then
    self.trigger_icon:LoadSprite(self.panelData.icon)
    self.trigger_icon:SetActive(true)
  else
    self.trigger_icon:SetActive(false)
  end
  self.cost_btn:SetActive(false)
end

local function ClearScroll(self)
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(UIPVEFactoryUpgradeCell)
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(UIPVEFactoryUpgradeCell, itemObj)
  cellItem:ReInit(self.showDatalist[index])
end

local function OnItemMoveOut(self, itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, UIPVEFactoryUpgradeCell)
end

UIPVEFactoryUpgradeView.OnCreate = OnCreate
UIPVEFactoryUpgradeView.OnDestroy = OnDestroy
UIPVEFactoryUpgradeView.ComponentDefine = ComponentDefine
UIPVEFactoryUpgradeView.ComponentDestroy = ComponentDestroy
UIPVEFactoryUpgradeView.DataDefine = DataDefine
UIPVEFactoryUpgradeView.DataDestroy = DataDestroy
UIPVEFactoryUpgradeView.OnEnable = OnEnable
UIPVEFactoryUpgradeView.OnDisable = OnDisable
UIPVEFactoryUpgradeView.OnAddListener = OnAddListener
UIPVEFactoryUpgradeView.OnRemoveListener = OnRemoveListener
UIPVEFactoryUpgradeView.ReInit = ReInit
UIPVEFactoryUpgradeView.OnResOrItemUpdate = OnResOrItemUpdate
UIPVEFactoryUpgradeView.Refresh = Refresh
UIPVEFactoryUpgradeView.ClearScroll = ClearScroll
UIPVEFactoryUpgradeView.OnItemMoveIn = OnItemMoveIn
UIPVEFactoryUpgradeView.OnItemMoveOut = OnItemMoveOut
UIPVEFactoryUpgradeView.OnCostClick = OnCostClick
UIPVEFactoryUpgradeView.RefreshTriggerInfo = RefreshTriggerInfo
return UIPVEFactoryUpgradeView
