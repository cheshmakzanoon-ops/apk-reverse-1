local base = UIBaseView
local UISplinterExchangeView = BaseClass("UISplinterExchangeView", base)
local UISplinterExchangeAlliesPanel = require("UI.UISplinterExchange.Exchange.Component.UISplinterExchangeAlliesPanel")
local UISplinterExchangeSelfPanel = require("UI.UISplinterExchange.Exchange.Component.UISplinterExchangeSelfPanel")
local UISplinterExchangeToggle = require("UI.UISplinterExchange.Exchange.Component.UISplinterExchangeToggle")
local TtileTxt_path = "Root/Content/UICommonPopBg/bg_3/TitleTxt"
local CloseBtn_path = "Root/Content/UICommonPopBg/bg_3/CloseBtn"
local AlliesPanel_path = "Root/Content/ContentHolder/AlliesPanel"
local SelfPanel_path = "Root/Content/ContentHolder/SelfPanel"
local Toggle1_path = "Root/Content/ContentHolder/TabGroup/Toggle1"
local Toggle2_path = "Root/Content/ContentHolder/TabGroup/Toggle2"

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
  self:SelectTab(self.selectTab)
  if self.selectTab == 1 then
    self.SelfPanel:SetOpenFragId(self.selectFragId)
  end
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.TtileTxt = self:AddComponent(UIText, TtileTxt_path)
  self.CloseBtn = self:AddComponent(UIButton, CloseBtn_path)
  self.AlliesPanel = self:AddComponent(UISplinterExchangeAlliesPanel, AlliesPanel_path)
  self.SelfPanel = self:AddComponent(UISplinterExchangeSelfPanel, SelfPanel_path)
  self.Toggle1 = self:AddComponent(UISplinterExchangeToggle, Toggle1_path)
  self.Toggle2 = self:AddComponent(UISplinterExchangeToggle, Toggle2_path)
  self.CloseBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.ClosePanel = self:AddComponent(UIButton, "Panel")
  self.ClosePanel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.Toggle1:SetOnValueChanged(function(tf)
    if tf then
      self:SelectTab(1)
    end
  end)
  self.Toggle2:SetOnValueChanged(function(tf)
    if tf then
      self:SelectTab(2)
    end
  end)
end

local function ComponentDestroy(self)
  self.TtileTxt = nil
  self.CloseBtn = nil
  self.AlliesPanel = nil
  self.SelfPanel = nil
  self.Toggle1 = nil
  self.Toggle2 = nil
end

local function DataDefine(self)
  self.type, self.selectTab, self.selectFragId = self:GetUserData()
  if self.type == nil then
    self.type = SplinterExchangeType.DispatchTreasure.Id
  end
  if self.selectTab == nil then
    self.selectTab = 1
  end
end

local function DataDestroy(self)
  self.type = nil
  self.selectTab = nil
  self.selectFragId = nil
end

local function SelectTab(self, index)
  self.selectTab = index
  if index == 1 then
    local param = {}
    param.type = self.type
    self.Toggle1:SetSelect()
    self.Toggle2:SetUnSelect()
    self.ctrl:SendGetSelfExchangeDataMsg(param)
    self.SelfPanel:SetActive(true)
    self.AlliesPanel:SetActive(false)
  elseif index == 2 then
    local param = {}
    param.type = self.type
    self.Toggle1:SetUnSelect()
    self.Toggle2:SetSelect()
    self.ctrl:SendGetAlExchangeDataListMsg(param)
    self.SelfPanel:SetActive(false)
    self.AlliesPanel:SetActive(true)
  end
end

UISplinterExchangeView.OnCreate = OnCreate
UISplinterExchangeView.OnDestroy = OnDestroy
UISplinterExchangeView.OnEnable = OnEnable
UISplinterExchangeView.OnDisable = OnDisable
UISplinterExchangeView.ComponentDefine = ComponentDefine
UISplinterExchangeView.ComponentDestroy = ComponentDestroy
UISplinterExchangeView.DataDefine = DataDefine
UISplinterExchangeView.DataDestroy = DataDestroy
UISplinterExchangeView.SelectTab = SelectTab
return UISplinterExchangeView
