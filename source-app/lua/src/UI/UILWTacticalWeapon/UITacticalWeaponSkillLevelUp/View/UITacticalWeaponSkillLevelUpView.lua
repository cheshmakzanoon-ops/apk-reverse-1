local UITacticalWeaponSkillLevelUpView = BaseClass("UITacticalWeaponSkillLevelUpView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIHeroSkillItem = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillItem")
local skill_item_path = "UIGarageRefitUpgrade/UICommonRewardPopUp/skillItemRoot/SkillItem"
local panel_path = "UIGarageRefitUpgrade/UICommonRewardPopUp/Panel"

function UITacticalWeaponSkillLevelUpView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnReInit()
end

function UITacticalWeaponSkillLevelUpView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UITacticalWeaponSkillLevelUpView:ComponentDefine()
  self.skill_item = self:AddComponent(UIHeroSkillItem, skill_item_path)
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

function UITacticalWeaponSkillLevelUpView:ComponentDestroy()
  self.skill_item = nil
  self.panel = nil
end

function UITacticalWeaponSkillLevelUpView:DataDefine()
end

function UITacticalWeaponSkillLevelUpView:DataDestroy()
end

function UITacticalWeaponSkillLevelUpView:OnAddListener()
  base.OnAddListener(self)
end

function UITacticalWeaponSkillLevelUpView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UITacticalWeaponSkillLevelUpView:OnReInit()
  local skillInfo = self:GetUserData()
  self.skill_item:SetActive(true)
  self.skill_item:SetData(skillInfo, {
    showSkillName = false,
    showSkillLevel = false,
    showStar = true
  })
  DataCenter.LWSoundManager:PlaySound(62308, false)
end

return UITacticalWeaponSkillLevelUpView
