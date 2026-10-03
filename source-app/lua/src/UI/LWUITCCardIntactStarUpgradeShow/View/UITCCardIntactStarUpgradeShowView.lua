local UITCCardIntactStarUpgradeShowView = BaseClass("UITCCardIntactStarUpgradeShowView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

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
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "PopUpTitle/Eff_ui_common_star_upgrade_full/title")
  self.compStarBgRoot = self:AddComponent(UIBaseContainer, "PopUpTitle/Eff_ui_common_star_upgrade_full/starBgRoot")
  self.compStarShowRoot = self:AddComponent(UIBaseContainer, "PopUpTitle/Eff_ui_common_star_upgrade_full/starShowRoot")
  self.btnPanel = self:AddComponent(UIButton, "panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
end

local function ComponentDestroy(self)
  self.textTitle = nil
  self.compStarBgRoot = nil
  self.compStarShowRoot = nil
  self.btnPanel = nil
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

local function OnBtnPanelClick(self)
end

UITCCardIntactStarUpgradeShowView.OnCreate = OnCreate
UITCCardIntactStarUpgradeShowView.OnDestroy = OnDestroy
UITCCardIntactStarUpgradeShowView.OnEnable = OnEnable
UITCCardIntactStarUpgradeShowView.OnDisable = OnDisable
UITCCardIntactStarUpgradeShowView.ComponentDefine = ComponentDefine
UITCCardIntactStarUpgradeShowView.ComponentDestroy = ComponentDestroy
UITCCardIntactStarUpgradeShowView.DataDefine = DataDefine
UITCCardIntactStarUpgradeShowView.DataDestroy = DataDestroy
UITCCardIntactStarUpgradeShowView.OnAddListener = OnAddListener
UITCCardIntactStarUpgradeShowView.OnRemoveListener = OnRemoveListener
UITCCardIntactStarUpgradeShowView.OnBtnPanelClick = OnBtnPanelClick
return UITCCardIntactStarUpgradeShowView
