local UITacticalChipStarDetailView = BaseClass("UITacticalChipStarDetailView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UICommonTab = require("UI.UICommonTab.UICommonTab")
local TacticalChipStarDetailStarPanel = require("UI.UILWTacticalWeaponChip.StarDetail.Component.TacticalChipStarDetailStarPanel")
local TacticalChipStarDetailSystemPanel = require("UI.UILWTacticalWeaponChip.StarDetail.Component.TacticalChipStarDetailSystemPanel")
UITacticalChipStarDetailView.TabType = {Star = 1, System = 2}
local TabType = UITacticalChipStarDetailView.TabType

local function OnCreate(self)
  base.OnCreate(self)
  self.chipId, self.chipStar, self.defaultTabTagId, self.customTierSystemLevel = self:GetUserData()
  self:ComponentDefine()
  self:DataDefine()
  self:InitTab()
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
  self.btnBg = self:AddComponent(UIButton, "bgBtn")
  self.btnBg:SetOnClick(function()
    self:OnBtnBgClick()
  end)
  self.textTitle = self:AddComponent(UIText, "Root/title")
  self.textTitle:SetLocalText("uav_chips_title10")
  self.compStarTab = self:AddComponent(UICommonTab, "Root/starTab")
  self.compSystemTab = self:AddComponent(UICommonTab, "Root/systemTab")
  self.btnClose = self:AddComponent(UIButton, "Root/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.compStarPanel = self:AddComponent(TacticalChipStarDetailStarPanel, "Root/starPanel")
  self.compSystemPanel = self:AddComponent(TacticalChipStarDetailSystemPanel, "Root/systemPanel")
end

local function ComponentDestroy(self)
  self.btnBg = nil
  self.textTitle = nil
  self.compStarTab = nil
  self.compSystemTab = nil
  self.btnClose = nil
  self.compStarPanel = nil
  self.compSystemPanel = nil
end

function UITacticalChipStarDetailView:InitTab()
  if self.defaultTabTagId == nil then
    self.defaultTabTagId = TabType.Star
  end
  local starTab = {}
  starTab.tabId = TabType.Star
  starTab.title = Localization:GetString("uav_chips_title12")
  starTab.clickHandler = self.OnTabClick
  starTab.containPanel = self.compStarPanel
  self.compStarTab:ReInit(starTab)
  self.compStarTab:SetSelect(false)
  local systemTab = {}
  systemTab.tabId = TabType.System
  systemTab.title = Localization:GetString("battlesystem_chip_preview_title1")
  systemTab.clickHandler = self.OnTabClick
  systemTab.containPanel = self.compSystemPanel
  self.compSystemTab:ReInit(systemTab)
  self.compSystemTab:SetSelect(false)
  self:OnTabClick(self.tabMap[self.defaultTabTagId])
end

function UITacticalChipStarDetailView:OnTabClick(tabItem)
  if self.curTab ~= nil then
    if self.curTab.tabId == tabItem.tabId then
      return
    else
      self.curTab:SetSelect(false)
    end
  end
  self.curTab = tabItem
  self.curTab:SetSelect(true)
  self.curTab.containPanel:ReInit(self.chipId, self.chipStar, self.customTierSystemLevel)
end

local function DataDefine(self)
  self.tabMap = {}
  self.tabMap[TabType.Star] = self.compStarTab
  self.tabMap[TabType.System] = self.compSystemTab
end

local function DataDestroy(self)
  self.curTab = nil
  self.tabMap = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnBtnBgClick(self)
  self.ctrl:CloseSelf()
end

local function OnBtnCloseClick(self)
  self.ctrl:CloseSelf()
end

UITacticalChipStarDetailView.OnCreate = OnCreate
UITacticalChipStarDetailView.OnDestroy = OnDestroy
UITacticalChipStarDetailView.OnEnable = OnEnable
UITacticalChipStarDetailView.OnDisable = OnDisable
UITacticalChipStarDetailView.ComponentDefine = ComponentDefine
UITacticalChipStarDetailView.ComponentDestroy = ComponentDestroy
UITacticalChipStarDetailView.DataDefine = DataDefine
UITacticalChipStarDetailView.DataDestroy = DataDestroy
UITacticalChipStarDetailView.OnAddListener = OnAddListener
UITacticalChipStarDetailView.OnRemoveListener = OnRemoveListener
UITacticalChipStarDetailView.OnBtnBgClick = OnBtnBgClick
UITacticalChipStarDetailView.OnBtnCloseClick = OnBtnCloseClick
return UITacticalChipStarDetailView
