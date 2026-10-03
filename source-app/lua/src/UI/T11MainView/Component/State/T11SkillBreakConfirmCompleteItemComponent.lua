local base = UIBaseContainer
local T11SkillBreakConfirmCompleteItemComponent = BaseClass("T11SkillBreakConfirmCompleteItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local T11SkillChangeSoldierModelAreaComponent = require("UI.T11MainView.Component.State.Component.T11SkillChangeSoldierModelAreaComponent")
local T11SkillBottomBreakConfirmCompleteItemComponent = require("UI.T11MainView.Component.State.Component.T11SkillBottomBreakConfirmCompleteItemComponent")
local t11_skill_change_soldier_model_area_path = "T11SkillChangeSoldierModelArea"
local t11_skill_break_confirm_complete_item_path = "T11SkillBreakConfirmCompleteItem"

function T11SkillBreakConfirmCompleteItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function T11SkillBreakConfirmCompleteItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function T11SkillBreakConfirmCompleteItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compBG1 = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.changeSoldierCpt = self:AddComponent(T11SkillChangeSoldierModelAreaComponent, t11_skill_change_soldier_model_area_path)
  self.bottomBreakConfirmCompleteCpt = self:AddComponent(T11SkillBottomBreakConfirmCompleteItemComponent, t11_skill_break_confirm_complete_item_path)
end

function T11SkillBreakConfirmCompleteItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compBG1 = nil
end

function T11SkillBreakConfirmCompleteItemComponent:DataDefine()
end

function T11SkillBreakConfirmCompleteItemComponent:DataDestroy()
end

function T11SkillBreakConfirmCompleteItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function T11SkillBreakConfirmCompleteItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function T11SkillBreakConfirmCompleteItemComponent:RefreshView()
  self.changeSoldierCpt:RefreshView()
  self.bottomBreakConfirmCompleteCpt:RefreshView()
end

return T11SkillBreakConfirmCompleteItemComponent
