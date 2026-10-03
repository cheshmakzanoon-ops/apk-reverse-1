local base = UIBaseContainer
local T11SkillUnlockableItemComponent = BaseClass("T11SkillUnlockableItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local T11SkillChangeSoldierModelAreaComponent = require("UI.T11MainView.Component.State.Component.T11SkillChangeSoldierModelAreaComponent")
local T11SkillBottomUnlockableComponent = require("UI.T11MainView.Component.State.Component.T11SkillBottomUnlockableComponent")
local t11_skill_change_soldier_model_area_path = "T11SkillChangeSoldierModelArea"
local t11_skill_bottom_unlockable_path = "T11SkillBottomUnlockable"

function T11SkillUnlockableItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function T11SkillUnlockableItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function T11SkillUnlockableItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compBG1 = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.changeSoldierCpt = self:AddComponent(T11SkillChangeSoldierModelAreaComponent, t11_skill_change_soldier_model_area_path)
  self.bottomUnlockableCpt = self:AddComponent(T11SkillBottomUnlockableComponent, t11_skill_bottom_unlockable_path)
end

function T11SkillUnlockableItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compBG1 = nil
end

function T11SkillUnlockableItemComponent:DataDefine()
end

function T11SkillUnlockableItemComponent:DataDestroy()
end

function T11SkillUnlockableItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function T11SkillUnlockableItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function T11SkillUnlockableItemComponent:RefreshView()
  self.changeSoldierCpt:RefreshView()
  self.bottomUnlockableCpt:RefreshView()
end

return T11SkillUnlockableItemComponent
