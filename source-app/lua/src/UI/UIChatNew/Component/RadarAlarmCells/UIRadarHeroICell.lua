local UIRadarHeroICell = BaseClass("UIRadarHeroICell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroStars = require("UI.UIHero2.Common.UIHeroStars")
local btn_go_path = "UIHeroCellSmall"
local img_quality_path = "UIHeroCellSmall/imgQuality"
local img_icon_path = "UIHeroCellSmall/imgIcon"
local img_camp_path = "UIHeroCellSmall/imgCamp"
local img_level_bg_path = "UIHeroCellSmall/LVBg"
local text_level_path = "UIHeroCellSmall/LVBg/textLevel"
local text_name_path = "UIHeroCellSmall/textName"
local img_ark_path = "UIHeroCellSmall/ImgRank"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.img_quality = self:AddComponent(UIImage, img_quality_path)
  self.img_icon = self:AddComponent(UIImage, img_icon_path)
  self.img_camp = self:AddComponent(UIImage, img_camp_path)
  self.level_bg = self:AddComponent(UIImage, img_level_bg_path)
  self.text_level = self:AddComponent(UIText, text_level_path)
  self.text_name = self:AddComponent(UIText, text_name_path)
  self.btn_go = self:AddComponent(UIButton, btn_go_path)
  self.btn_go:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.star = self:AddComponent(UIHeroStars, "UIHeroCellSmall/NodeArrow")
  self.imgArkGrade = self:AddComponent(UIImage, img_ark_path)
end

local function ComponentDestroy(self)
  self.img_quality = nil
  self.img_icon = nil
  self.img_camp = nil
  self.level_bg = nil
  self.text_level = nil
  self.text_name = nil
  self.btn_go = nil
  self.imgArkGrade = nil
end

local function DataDefine(self)
  self.heroUuid = 0
  self.callBack = nil
end

local function DataDestroy(self)
  self.heroUuid = nil
  self.callBack = nil
end

local function SetData(self, heroUuid, callBack, showGrade)
  self.heroUuid = heroUuid
  self.callBack = callBack
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
  assert(heroData ~= nil, "heroData is nil! heroUuid:" .. tostring(heroUuid))
  local heroConfig = heroData:GetConfig()
  local quality = heroData.quality
  local camp = heroConfig.camp
  local rarity = heroData.rarity
  local isMaster = heroData.isMaster
  self.rarity = heroConfig.rarity
  local isWaken = heroData:IsWakeUp()
  local iconPath = HeroUtils.GetHeroIconPath(heroData.heroId)
  self.img_icon:LoadSpriteAuto(iconPath)
  if camp ~= -1 then
    self.img_camp:SetActive(true)
    self.img_camp:LoadSpriteAuto(HeroUtils.GetCampIconPath(camp))
  else
    self.img_camp:SetActive(false)
  end
  self.text_name:SetLocalText(heroConfig.name)
  self.text_level:SetText("Lv." .. tostring(heroData.level))
  self.heroId = heroConfig.id
  self:SetQuality(quality, not isMaster, isWaken)
  local rankId = heroData:GetRank()
  self.imgArkGrade:SetActive(isMaster and 18 <= rankId and (showGrade == nil or showGrade == true))
  self.imgArkGrade:LoadSprite(HeroUtils.GetMilitaryRankIcon(rankId))
end

local function InitWithConfigId(self, heroConfigId, quality, level, ranId, isWakeUp)
  local heroConfig = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), heroConfigId)
  local camp = heroConfig.camp
  if quality == nil then
    quality = heroConfig.init_quality_level
  end
  self.img_icon:LoadSpriteAuto(HeroUtils.GetHeroIconPath(heroConfigId))
  if camp ~= -1 then
    self.img_camp:SetActive(true)
    self.img_camp:LoadSpriteAuto(HeroUtils.GetCampIconPath(camp))
  else
    self.img_camp:SetActive(false)
  end
  self.text_name:SetLocalText(heroConfig.name)
  self.rarity = heroConfig.rarity
  self.level_bg:SetActive(level ~= nil)
  self.text_level:SetText("Lv." .. tostring(level))
  self.heroId = heroConfig.id
  self:SetQuality(quality, false, isWakeUp)
  if ranId and 18 <= ranId then
    self.imgArkGrade:SetActive(true)
    self.imgArkGrade:LoadSpriteAuto(HeroUtils.GetMilitaryRankIcon(ranId))
  else
    self.imgArkGrade:SetActive(false)
  end
end

local function SetQuality(self, quality, isPoster, isWaken)
  local param = {}
  param.showStarNum = quality
  param.maxStarNum = HeroUtils.GetMaxStarLevel(self.heroId)
  local icon = HeroUtils.GetRarityIconPath(self.rarity, false, isWaken)
  self.img_quality:LoadSpriteAuto(icon)
  self.level_bg:LoadSpriteAuto(self.GetLvBgPath(self.rarity, isWaken))
  local lvColor = HeroUtils.GetLvColor(self.rarity, isWaken)
  self.text_level:SetColor(lvColor)
  self.star:SetData(param)
  self.star:SetActive(true)
end

local function SetDisplayLevel(self, level)
  local lvStr = Localization:GetString("300665", level or "")
end

local function OnBtnClick(self)
  if self.callBack ~= nil then
    self.callBack(self.transform, self.heroUuid)
  end
end

local function GetLvBgPath(rarity, isWaken)
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

UIRadarHeroICell.OnCreate = OnCreate
UIRadarHeroICell.OnDestroy = OnDestroy
UIRadarHeroICell.OnEnable = OnEnable
UIRadarHeroICell.OnDisable = OnDisable
UIRadarHeroICell.ComponentDefine = ComponentDefine
UIRadarHeroICell.ComponentDestroy = ComponentDestroy
UIRadarHeroICell.DataDefine = DataDefine
UIRadarHeroICell.DataDestroy = DataDestroy
UIRadarHeroICell.SetData = SetData
UIRadarHeroICell.InitWithConfigId = InitWithConfigId
UIRadarHeroICell.SetQuality = SetQuality
UIRadarHeroICell.SetDisplayLevel = SetDisplayLevel
UIRadarHeroICell.OnBtnClick = OnBtnClick
UIRadarHeroICell.GetLvBgPath = GetLvBgPath
return UIRadarHeroICell
