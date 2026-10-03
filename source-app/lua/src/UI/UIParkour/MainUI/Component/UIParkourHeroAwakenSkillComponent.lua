local base = UIBaseContainer
local UIParkourHeroAwakenSkillComponent = BaseClass("UIParkourHeroAwakenSkillComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local UIHeroSkillItem = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillItem")

function UIParkourHeroAwakenSkillComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:SetActive(false)
end

function UIParkourHeroAwakenSkillComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIParkourHeroAwakenSkillComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compUIHeroCellSmall = self.viewSkin:AddComponent(self, UIHeroCellSmall, 1)
  self.compUIHeroSkillItem = self.viewSkin:AddComponent(self, UIHeroSkillItem, 2)
end

function UIParkourHeroAwakenSkillComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compUIHeroCellSmall = nil
  self.compUIHeroSkillItem = nil
end

function UIParkourHeroAwakenSkillComponent:DataDefine()
end

function UIParkourHeroAwakenSkillComponent:DataDestroy()
end

function UIParkourHeroAwakenSkillComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIParkourHeroAwakenSkillComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIParkourHeroAwakenSkillComponent:ReInit(skill, hero)
  if skill then
    self.compUIHeroSkillItem:SetData(skill, {
      showSkillName = false,
      showSkillLevel = false,
      showLock = false,
      showRedPoint = false,
      showStar = false
    }, nil)
  end
  if hero then
    self.compUIHeroCellSmall:InitWithConfigId(hero.heroId, hero.quality, hero.level, hero.rank, hero:GetUniqueWeaponLv(), hero:GetHeroAwakenRankLevel(), hero:GetSkinId())
  end
  self:SetActive(false)
  self:SetActive(true)
end

return UIParkourHeroAwakenSkillComponent
