local base = UIBaseContainer
local UIActHeroLevelAddHeroItem = BaseClass("UIActHeroLevelAddHeroItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local empty_path = "empty"
local LWHeroRankStar = require("UI.UIHero2.Common.LWHeroRankStar")
local hero_path = "hero"
local add_btn_path = "AddBtn"
local name_path = "hero/name"
local lv_path = "hero/lv"

function UIActHeroLevelAddHeroItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIActHeroLevelAddHeroItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActHeroLevelAddHeroItem:OnEnable()
  base.OnEnable(self)
end

function UIActHeroLevelAddHeroItem:OnDisable()
  base.OnDisable(self)
end

function UIActHeroLevelAddHeroItem:ComponentDefine()
  self.empty = self:AddComponent(UIBaseContainer, empty_path)
  self.add_btn = self:AddComponent(UIButton, add_btn_path)
  self.name = self:AddComponent(UIText, name_path)
  self.lv = self:AddComponent(UIText, lv_path)
  self.add_btn:SetOnClick(function()
    self:ClickEmpty()
  end)
  self.hero = self:AddComponent(UIBaseContainer, hero_path)
  self.heroRankStar = self:AddComponent(LWHeroRankStar, "hero/UIHeroCellBig/HeroRankStar")
  self.img_icon1 = self:AddComponent(UIImage, "hero/UIHeroCellBig/LayerNormal/ImgBg/Mask/ImgIcon1")
  self.img_bg = self:AddComponent(UIImage, "hero/UIHeroCellBig/LayerNormal/ImgBg")
  self.level_bg = self:AddComponent(UIImage, "hero/UIHeroCellBig/LevelBg")
end

function UIActHeroLevelAddHeroItem:ComponentDestroy()
  self.empty = nil
  self.add_btn = nil
  self.name = nil
  self.lv = nil
  self.heroRankStar = nil
  self.hero = nil
  self.img_icon1 = nil
  self.img_bg = nil
  self.level_bg = nil
end

function UIActHeroLevelAddHeroItem:ClickEmpty()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonHeroList, 2, self.index, self.parentView:GetSelectHero())
end

function UIActHeroLevelAddHeroItem:HeroLevelEmptyItemSetData(heroUuid, index, view)
  self.index = index
  self.heroUuid = heroUuid
  self.parentView = view
  self.empty:SetActive(heroUuid == nil)
  if heroUuid then
    self.hero:SetActive(true)
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
    local iconPath = HeroUtils.GetHeroIconPath(heroData.modelId, HeroIconType.half_portrait)
    self.img_icon1:LoadSpriteAuto(iconPath)
    self:SetQuality(heroData.quality, false)
    self:SetHeroRank(heroData)
    self.name:SetLocalText(heroData.firstName)
    self.lv:SetText("Lv." .. tostring(heroData.level))
  else
    self.hero:SetActive(false)
  end
end

function UIActHeroLevelAddHeroItem:SetQuality(quality)
  self.img_bg:LoadSpriteAuto(HeroUtils.GetQualityIconPath(quality, true, false))
  self.level_bg:LoadSpriteAuto(HeroUtils.GetLevelBg(quality))
end

function UIActHeroLevelAddHeroItem:SetHeroRank(heroData)
  if heroData:GetRank() == nil then
    self.heroRankStar:SetActive(false)
  else
    self.heroRankStar:SetActive(true)
    if heroData and heroData.meta then
      self.heroRankStar:ShowRank(heroData:GetRank(), heroData.meta.maxRank)
    end
  end
end

return UIActHeroLevelAddHeroItem
