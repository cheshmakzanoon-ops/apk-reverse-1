local base = UIBaseContainer
local T11UnlockProgressUpgradeItemComponent = BaseClass("T11UnlockProgressUpgradeItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local T11MiddlePreviewComponent = require("UI.T11MainView.Component.State.Component.T11MiddlePreviewComponent")
local T11UnlockProgressUpgradeAreaComponent = require("UI.T11MainView.Component.State.Component.T11UnlockProgressUpgradeAreaComponent")
local t11_middle_preview_path = "T11MiddlePreview"
local t11_unlock_progress_upgrade_area_path = "T11UnlockProgressUpgradeArea"

function T11UnlockProgressUpgradeItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function T11UnlockProgressUpgradeItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function T11UnlockProgressUpgradeItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compT11UnlockProgressUpgradeItem = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.preViewCpt = self:AddComponent(T11MiddlePreviewComponent, t11_middle_preview_path)
  self.t11UnlockProgressCpt = self:AddComponent(T11UnlockProgressUpgradeAreaComponent, t11_unlock_progress_upgrade_area_path)
end

function T11UnlockProgressUpgradeItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compT11UnlockProgressUpgradeItem = nil
end

function T11UnlockProgressUpgradeItemComponent:DataDefine()
end

function T11UnlockProgressUpgradeItemComponent:DataDestroy()
end

function T11UnlockProgressUpgradeItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function T11UnlockProgressUpgradeItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function T11UnlockProgressUpgradeItemComponent:RefreshView()
  self.preViewCpt:RefreshView()
  self.t11UnlockProgressCpt:RefreshView()
end

return T11UnlockProgressUpgradeItemComponent
