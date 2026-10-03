local base = UIBaseContainer
local T11SkillProgressUpgradeItemComponent = BaseClass("T11SkillProgressUpgradeItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local T11SkillChangeSoldierModelAreaComponent = require("UI.T11MainView.Component.State.Component.T11SkillChangeSoldierModelAreaComponent")
local T11SkillProgressUpgradeAreaComponent = require("UI.T11MainView.Component.State.Component.T11SkillProgressUpgradeAreaComponent")
local t11_skill_change_soldier_model_area_path = "T11SkillChangeSoldierModelArea"
local t11_skill_progress_upgrade_area_path = "T11SkillProgressUpgradeArea"

function T11SkillProgressUpgradeItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function T11SkillProgressUpgradeItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function T11SkillProgressUpgradeItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compT11SkillProgressUpgradeItem = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.changeSoldierModelCpt = self:AddComponent(T11SkillChangeSoldierModelAreaComponent, t11_skill_change_soldier_model_area_path)
  self.skillUpgradeCpt = self:AddComponent(T11SkillProgressUpgradeAreaComponent, t11_skill_progress_upgrade_area_path)
end

function T11SkillProgressUpgradeItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compT11SkillProgressUpgradeItem = nil
end

function T11SkillProgressUpgradeItemComponent:DataDefine()
end

function T11SkillProgressUpgradeItemComponent:DataDestroy()
end

function T11SkillProgressUpgradeItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function T11SkillProgressUpgradeItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function T11SkillProgressUpgradeItemComponent:RefreshView()
  self.changeSoldierModelCpt:RefreshView()
  self.skillUpgradeCpt:RefreshView()
end

return T11SkillProgressUpgradeItemComponent
