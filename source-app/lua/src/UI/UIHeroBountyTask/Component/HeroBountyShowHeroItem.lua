local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local UIHeroStars = require("UI.UIHero2.Common.UIHeroStars")
local HeroBountyShowHeroItem = BaseClass("HeroBountyShowHeroItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local btn_go_path = "hero"
local img_quality_path = "hero/layout/imgQuality"
local img_camp_path = "hero/layout/imgCamp"
local img_level_bg_path = "hero/layout/LVBg"
local text_level_path = "hero/layout/LVBg/textLevel"
local img_icon_path = "hero/layout/imgIcon"
local img_rank_path = "hero/layout/ImgRank"

function HeroBountyShowHeroItem:OnCreate()
  base.OnCreate(self)
  self.img_quality = self:AddComponent(UIImage, img_quality_path)
  self.img_icon = self:AddComponent(UIImage, img_icon_path)
  self.img_camp = self:AddComponent(UIImage, img_camp_path)
  self.level_bg = self:AddComponent(UIImage, img_level_bg_path)
  self.text_level = self:AddComponent(UIText, text_level_path)
  self.imgArkGrade = self:AddComponent(UIImage, img_rank_path)
  self.btn = self:AddComponent(UIButton, btn_go_path)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.star = self:AddComponent(UIHeroStars, "hero/layout/NodeArrow")
end

function HeroBountyShowHeroItem:SetData(heroUuid, index)
  if heroUuid == nil then
    return
  end
  local herodata = self.view.ctrl:GetHeroDataByUuid(heroUuid)
  local heroId = herodata.heroId
  self.heroId = heroId
  local heroLv = herodata.heroLevel
  self.heroLevel = heroLv
  local heroQuality = herodata.qualityIndex or 0
  local curMilitaryRankId = herodata.rankId
  local camp = herodata.camp
  local rarity = herodata.rarity
  local isWakeUp = herodata.isWaken
  self.img_icon:LoadSpriteAuto(HeroUtils.GetHeroIconPath(heroId))
  if camp ~= -1 then
    self.img_camp:SetActive(true)
    self.img_camp:LoadSpriteAuto(HeroUtils.GetCampIconPath(camp))
  else
    self.img_camp:SetActive(false)
  end
  self.level_bg:SetActive(heroLv ~= nil)
  self.text_level:SetText("Lv." .. tostring(heroLv))
  local show = false
  if curMilitaryRankId == nil or curMilitaryRankId <= 1 then
    show = false
  elseif 18 <= curMilitaryRankId then
    self.imgArkGrade:LoadSpriteAuto(HeroUtils.GetMilitaryRankIcon(curMilitaryRankId))
    show = true
  end
  self.rankId = curMilitaryRankId
  self.imgArkGrade:SetActive(show)
  local param = {}
  param.showStarNum = heroQuality
  param.maxStarNum = HeroUtils.GetMaxStarLevel(heroId)
  local icon = HeroUtils.GetRarityIconPath(rarity, false, isWakeUp)
  self.img_quality:LoadSpriteAuto(icon)
  self.level_bg:LoadSprite(self:GetLvBgPath(rarity, isWakeUp))
  local lvColor = HeroUtils.GetLvColor(rarity, isWakeUp)
  self.text_level:SetColor(lvColor)
  self.star:SetData(param)
  self.star:SetActive(true)
  self.heroData = herodata
end

function HeroBountyShowHeroItem:OnBtnClick()
  if self.heroData ~= nil then
    local index = self.heroData.index
    self.view.ctrl:OnDeleteHeroByIndex(index)
    self.view:OnSelectHeroFinish(index)
  end
end

function HeroBountyShowHeroItem:GetLvBgPath(rarity, isWaken)
  local path = LoadPath.HeroIconsSmallPath
  if isWaken then
    return path .. "ui_quality_lvbg_cai"
  end
  local bg = {
    "ui_quality_lvbg_orange",
    "ui_quality_lvbg_purple",
    "ui_quality_lvbg_blue",
    "ui_quality_lvbg_green"
  }
  local iconName = bg[rarity]
  return path .. iconName
end

return HeroBountyShowHeroItem
