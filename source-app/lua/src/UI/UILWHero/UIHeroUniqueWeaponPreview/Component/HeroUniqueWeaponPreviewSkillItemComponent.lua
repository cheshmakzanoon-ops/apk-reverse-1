local base = UIBaseContainer
local HeroUniqueWeaponPreviewSkillItemComponent = BaseClass("HeroUniqueWeaponPreviewSkillItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIHeroEffectItem = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroEffectItem")

function HeroUniqueWeaponPreviewSkillItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function HeroUniqueWeaponPreviewSkillItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function HeroUniqueWeaponPreviewSkillItemComponent:SetData(index, icon, locked, callback)
  self.index = index
  self.compUIHeroEffectItem:SetData(index, icon, locked, callback)
end

function HeroUniqueWeaponPreviewSkillItemComponent:GetIndex()
  return self.index
end

function HeroUniqueWeaponPreviewSkillItemComponent:SetSelect(value)
  self.compSelectFrame:SetActive(value)
end

function HeroUniqueWeaponPreviewSkillItemComponent:ComponentDefine()
  self.compUIHeroEffectItem = self:AddComponent(UIHeroEffectItem, "UIHeroEffectItem")
  self.compSelectFrame = self:AddComponent(UIBaseContainer, "SelectFrame")
end

function HeroUniqueWeaponPreviewSkillItemComponent:ComponentDestroy()
  self.compUIHeroEffectItem = nil
  self.compSelectFrame = nil
end

function HeroUniqueWeaponPreviewSkillItemComponent:DataDefine()
end

function HeroUniqueWeaponPreviewSkillItemComponent:DataDestroy()
end

function HeroUniqueWeaponPreviewSkillItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function HeroUniqueWeaponPreviewSkillItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

return HeroUniqueWeaponPreviewSkillItemComponent
