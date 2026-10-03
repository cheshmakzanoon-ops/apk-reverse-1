local base = UIBaseContainer
local T11SkillUnlockingItemComponent = BaseClass("T11SkillUnlockingItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local T11SkillChangeSoldierModelAreaComponent = require("UI.T11MainView.Component.State.Component.T11SkillChangeSoldierModelAreaComponent")
local T11SkillBottomUnlockingComponent = require("UI.T11MainView.Component.State.Component.T11SkillBottomUnlockingComponent")
local t11_skill_change_soldier_model_area_path = "T11SkillChangeSoldierModelArea"
local t11_skill_bottom_unlocking_path = "T11SkillBottomUnlocking"

function T11SkillUnlockingItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function T11SkillUnlockingItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function T11SkillUnlockingItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compBG1 = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.changeSoldierCpt = self:AddComponent(T11SkillChangeSoldierModelAreaComponent, t11_skill_change_soldier_model_area_path)
  self.bottomUnlockingCpt = self:AddComponent(T11SkillBottomUnlockingComponent, t11_skill_bottom_unlocking_path)
end

function T11SkillUnlockingItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compBG1 = nil
end

function T11SkillUnlockingItemComponent:DataDefine()
end

function T11SkillUnlockingItemComponent:DataDestroy()
end

function T11SkillUnlockingItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function T11SkillUnlockingItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function T11SkillUnlockingItemComponent:RefreshView()
  self.changeSoldierCpt:RefreshView()
  self.bottomUnlockingCpt:RefreshView()
end

return T11SkillUnlockingItemComponent
