local base = UIBaseContainer
local T11MaxStageItemComponent = BaseClass("T11MaxStageItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local T11SkillChangeSoldierModelAreaComponent = require("UI.T11MainView.Component.State.Component.T11SkillChangeSoldierModelAreaComponent")
local T11MaxStageAreaComponent = require("UI.T11MainView.Component.State.Component.T11MaxStageAreaComponent")
local t11_skill_change_soldier_model_area_path = "T11SkillChangeSoldierModelArea"
local t11_max_stage_area_path = "T11MaxStageArea"

function T11MaxStageItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function T11MaxStageItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function T11MaxStageItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compT11MaxStageItem = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.changeSoldierCpt = self:AddComponent(T11SkillChangeSoldierModelAreaComponent, t11_skill_change_soldier_model_area_path)
  self.maxStageAreaCpt = self:AddComponent(T11MaxStageAreaComponent, t11_max_stage_area_path)
end

function T11MaxStageItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compT11MaxStageItem = nil
end

function T11MaxStageItemComponent:DataDefine()
end

function T11MaxStageItemComponent:DataDestroy()
end

function T11MaxStageItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function T11MaxStageItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function T11MaxStageItemComponent:RefreshView()
  self.changeSoldierCpt:RefreshView()
  self.maxStageAreaCpt:RefreshView()
end

return T11MaxStageItemComponent
