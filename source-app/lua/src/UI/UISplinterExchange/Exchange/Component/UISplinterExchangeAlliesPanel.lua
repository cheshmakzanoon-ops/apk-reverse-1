local base = UIBaseContainer
local UISplinterExchangeAlliesPanel = BaseClass("UISplinterExchangeAlliesPanel", base)
local UISplinterExchangeCell = require("UI.UISplinterExchange.Exchange.Component.UISplinterExchangeCell")
local ScrollView_path = "ScrollView"
local TxtEmpty_path = "TxtEmpty"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:DataDefine()
end

local function OnDisable(self)
  self:DataDestroy()
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.ScrollView = self:AddComponent(UIScrollView, ScrollView_path)
  self.TxtEmpty = self:AddComponent(UIBaseContainer, TxtEmpty_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.ScrollView:SetActive(false)
  self.TxtEmpty:SetActive(true)
end

local function ComponentDestroy(self)
  self.ScrollView = nil
  self.TxtEmpty = nil
end

local function DataDefine(self)
  self.showDatalist = nil
end

local function DataDestroy(self)
  self.showDatalist = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.SplinterRefreshAL, self.Refresh)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.SplinterRefreshAL, self.Refresh)
  base.OnAddListener(self)
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(UISplinterExchangeCell, itemObj)
  if self.showDatalist and self.showDatalist[index] then
    cellItem:SetData(self.showDatalist[index])
  end
end

local function OnItemMoveOut(self, itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, UISplinterExchangeCell)
end

local function Refresh(self, type)
  if type ~= self.view.type then
    return
  end
  self.showDatalist = self.view.ctrl:GetAlExchangeDataList(self.view.type)
  if #self.showDatalist > 0 then
    self.ScrollView:SetActive(true)
    self.ScrollView:SetTotalCount(#self.showDatalist)
    self.ScrollView:RefillCells()
    self.TxtEmpty:SetActive(false)
  else
    self.ScrollView:SetActive(false)
    self.TxtEmpty:SetActive(true)
  end
end

UISplinterExchangeAlliesPanel.OnCreate = OnCreate
UISplinterExchangeAlliesPanel.OnDestroy = OnDestroy
UISplinterExchangeAlliesPanel.OnEnable = OnEnable
UISplinterExchangeAlliesPanel.OnDisable = OnDisable
UISplinterExchangeAlliesPanel.ComponentDefine = ComponentDefine
UISplinterExchangeAlliesPanel.ComponentDestroy = ComponentDestroy
UISplinterExchangeAlliesPanel.DataDefine = DataDefine
UISplinterExchangeAlliesPanel.DataDestroy = DataDestroy
UISplinterExchangeAlliesPanel.OnItemMoveIn = OnItemMoveIn
UISplinterExchangeAlliesPanel.OnItemMoveOut = OnItemMoveOut
UISplinterExchangeAlliesPanel.Refresh = Refresh
UISplinterExchangeAlliesPanel.OnAddListener = OnAddListener
UISplinterExchangeAlliesPanel.OnRemoveListener = OnRemoveListener
return UISplinterExchangeAlliesPanel
