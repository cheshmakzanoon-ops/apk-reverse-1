local TacticalLevelDisplaySkillItem = BaseClass("TacticalLevelDisplaySkillItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroSkillItem = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillItem")
local skill_item_path = "SkillItem"
local bg_path = "bg"

function TacticalLevelDisplaySkillItem:OnCreate()
  base.OnCreate(self)
  self.skillItem = self:AddComponent(UIHeroSkillItem, skill_item_path)
  self.bg = self:AddComponent(UIImage, bg_path)
end

function TacticalLevelDisplaySkillItem:OnDestroy()
  self.skillItem = nil
  base.OnDestroy(self)
end

function TacticalLevelDisplaySkillItem:OnEnable()
  base.OnEnable(self)
end

function TacticalLevelDisplaySkillItem:OnDisable()
  base.OnDisable(self)
end

function TacticalLevelDisplaySkillItem:SetData(skillId, isUnlock)
  self.skillId = skillId
  local skillInfo = SkillInfo.New()
  skillInfo:CreateFromTemplate(self.skillId, isUnlock)
  self.skillItem:SetActive(true)
  self.skillItem:SetTacticalWeaponSkillData(skillInfo, {
    showSkillName = false,
    showSkillLevel = false,
    showStar = true,
    showLock = not isUnlock
  }, function(skillData, skillItem)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTacticalWeaponSkillDetail, {anim = true}, skillData, skillItem)
  end)
  CS.UIGray.SetGray(self.bg.transform, not isUnlock, true)
end

return TacticalLevelDisplaySkillItem
