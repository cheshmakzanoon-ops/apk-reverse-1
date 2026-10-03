local base = UIBaseView
local UISplinterExchangeLogView = BaseClass("UISplinterExchangeLogView", base)
local UISplinterExchangeLogCell = require("UI.UISplinterExchange.Log.Component.UISplinterExchangeLogCell")
local TitleTxt_path = "Root/Content/UICommonPopBg/bg_3/TitleTxt"
local ScrollView_path = "Root/Content/ContentHolder/ScrollView"
local CloseBtn_path = "Root/Content/UICommonPopBg/bg_3/CloseBtn"
local TxtEmpty_path = "Root/Content/ContentHolder/TxtEmpty"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.TitleTxt = self:AddComponent(UIText, TitleTxt_path)
  self.ScrollView = self:AddComponent(UIScrollView, ScrollView_path)
  self.CloseBtn = self:AddComponent(UIButton, CloseBtn_path)
  self.TxtEmpty = self:AddComponent(UIBaseContainer, TxtEmpty_path)
  self.CloseBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.ClosePanel = self:AddComponent(UIButton, "Panel")
  self.ClosePanel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.TitleTxt:SetLocalText("Treasure_map_22")
end

local function ComponentDestroy(self)
  self.TitleTxt = nil
  self.ScrollView = nil
  self.CloseBtn = nil
  self.TxtEmpty = nil
end

local function DataDefine(self)
  self.type = self:GetUserData()
  self:Refresh(self.type)
end

local function DataDestroy(self)
  self.type = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.SplinterRefreshLog, self.Refresh)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.SplinterRefreshLog, self.Refresh)
  base.OnAddListener(self)
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(UISplinterExchangeLogCell, itemObj)
  cellItem:SetData(self.type, self.showDatalist[index])
end

local function OnItemMoveOut(self, itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, UISplinterExchangeLogCell)
end

local function Refresh(self, type)
  if self.type ~= type then
    return
  end
  self.showDatalist = self.ctrl:GetRecordDataList(self.type)
  if #self.showDatalist > 0 then
    self.ScrollView:SetActive(true)
    self.ScrollView:SetTotalCount(#self.showDatalist)
    self.ScrollView:RefillCells()
    self.TxtEmpty:SetActive(false)
  else
    self.ScrollView:SetActive(false)
    self.TxtEmpty:SetActive(true)
  end
  local redPointStr = DataCenter.SplinterExchangeManager:GetLogRedPointStrByType(self.type)
  if not string.IsNullOrEmpty(redPointStr) then
    DataCenter.SplinterExchangeManager:SetShowExchangeRedPoint({
      [redPointStr] = 0
    })
  end
end

UISplinterExchangeLogView.OnCreate = OnCreate
UISplinterExchangeLogView.OnDestroy = OnDestroy
UISplinterExchangeLogView.OnEnable = OnEnable
UISplinterExchangeLogView.OnDisable = OnDisable
UISplinterExchangeLogView.ComponentDefine = ComponentDefine
UISplinterExchangeLogView.ComponentDestroy = ComponentDestroy
UISplinterExchangeLogView.DataDefine = DataDefine
UISplinterExchangeLogView.DataDestroy = DataDestroy
UISplinterExchangeLogView.OnItemMoveIn = OnItemMoveIn
UISplinterExchangeLogView.OnItemMoveOut = OnItemMoveOut
UISplinterExchangeLogView.Refresh = Refresh
UISplinterExchangeLogView.OnAddListener = OnAddListener
UISplinterExchangeLogView.OnRemoveListener = OnRemoveListener
return UISplinterExchangeLogView
