local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local UIHeroStars = require("UI.UIHero2.Common.UIHeroStars")
local MailPlayerHeroItem = BaseClass("MailPlayerHeroItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local btn_go_path = ""
local img_quality_path = "layout/imgQuality"
local img_camp_path = "layout/imgCamp"
local img_level_bg_path = "layout/LVBg"
local text_level_path = "layout/LVBg/textLevel"
local img_icon_path = "layout/imgIcon"
local img_rank_path = "layout/ImgRank"

function MailPlayerHeroItem:OnCreate()
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
  self.star = self:AddComponent(UIHeroStars, "layout/NodeArrow")
end

function MailPlayerHeroItem:SetData(herodata, parent, isSelf)
  if herodata == nil then
    return
  end
  self.parent = parent
  self.isSelf = isSelf
  local heroId = herodata.heroId
  self.heroId = heroId
  local heroLv = herodata.heroLevel
  self.heroLevel = heroLv
  local heroQuality = herodata.heroQuality or 0
  local skillInfos = herodata.skillInfos or {}
  local rankLv = herodata.rankLv or 0
  local stage = herodata.stage or 0
  local curMilitaryRankId = HeroUtils.GetRankIdByLvAndStage(heroId, rankLv, stage)
  local heroConfig = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), heroId)
  local camp = heroConfig.camp
  local rarity = heroConfig.rarity
  local isWakeUp = HeroUtils.GetIsWakeUp(rarity, skillInfos)
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
    self.imgArkGrade:LoadSprite(HeroUtils.GetMilitaryRankIcon(curMilitaryRankId))
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
end

function MailPlayerHeroItem:OnBtnClick()
  local showOther = false
  if self.parent ~= nil then
    showOther = self.parent:OnHeroDetailClick(self.isSelf)
  end
  if showOther == false and self.heroId ~= nil then
    local heroName = GetTableData(HeroUtils.GetHeroXmlName(), self.heroId, "name")
    if heroName ~= nil and heroName ~= "" then
      local rankName = ""
      if self.rankId == nil or self.rankId <= 1 then
        rankName = ""
      else
        rankName = Localization:GetString(HeroUtils.GetMilitaryRankName(self.rankId))
      end
      local scaleFactor = UIManager:GetInstance():GetScaleFactor()
      local position = self.btn.gameObject.transform.position + Vector3.New(33, -66, 0) * scaleFactor
      local param = UIHeroTipView.Param.New()
      param.content = Localization:GetString(heroName) .. "\n" .. "Lv." .. self.heroLevel .. "  " .. rankName
      param.dir = UIHeroTipView.Direction.BELOW
      param.defWidth = 160
      param.pivot = 0.5
      param.position = position
      param.deltaX = 0
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
    end
  end
end

function MailPlayerHeroItem:GetLvBgPath(rarity, isWaken)
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

return MailPlayerHeroItem
