local UITacticalWeaponSuperStageUpMaskView = BaseClass("UITacticalWeaponSuperStageUpMaskView", UIBaseView)
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
  self.btnBg = self:AddComponent(UIButton, "bgBtn")
  self.btnBg:SetOnClick(function()
    self:OnBtnBgClick()
  end)
end

local function ComponentDestroy(self)
  self.btnBg = nil
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

local function OnBtnBgClick(self)
end

UITacticalWeaponSuperStageUpMaskView.OnCreate = OnCreate
UITacticalWeaponSuperStageUpMaskView.OnDestroy = OnDestroy
UITacticalWeaponSuperStageUpMaskView.OnEnable = OnEnable
UITacticalWeaponSuperStageUpMaskView.OnDisable = OnDisable
UITacticalWeaponSuperStageUpMaskView.ComponentDefine = ComponentDefine
UITacticalWeaponSuperStageUpMaskView.ComponentDestroy = ComponentDestroy
UITacticalWeaponSuperStageUpMaskView.DataDefine = DataDefine
UITacticalWeaponSuperStageUpMaskView.DataDestroy = DataDestroy
UITacticalWeaponSuperStageUpMaskView.OnAddListener = OnAddListener
UITacticalWeaponSuperStageUpMaskView.OnRemoveListener = OnRemoveListener
UITacticalWeaponSuperStageUpMaskView.OnBtnBgClick = OnBtnBgClick
return UITacticalWeaponSuperStageUpMaskView
