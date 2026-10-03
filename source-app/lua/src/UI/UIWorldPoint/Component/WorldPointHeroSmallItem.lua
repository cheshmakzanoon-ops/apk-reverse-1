local WorldPointHeroSmallItem = BaseClass("WorldPointHeroSmallItem", UIBaseContainer)
local base = UIBaseContainer
local LWHeroRankStar = require("UI.UIHero2.Common.LWHeroRankStar")
local btn_go_path = ""
local img_quality_path = "imgQuality"
local img_type_path = "ImgType"
local img_Job_path = "ImgJob"
local text_level_path = "textLevel"
local img_level_bg_path = "LVBg"

local function OnCreate(self)
  base.OnCreate(self)
  self.img_quality = self:AddComponent(UIImage, img_quality_path)
  self.img_icon = self:AddComponent(UIImage, "imgIcon")
  self.img_type = self:AddComponent(UIImage, img_type_path)
  self.img_job = self:AddComponent(UIImage, img_Job_path)
  self.text_level = self:AddComponent(UIText, text_level_path)
  self.level_bg = self:AddComponent(UIImage, img_level_bg_path)
  self.heroRankStar = self:AddComponent(LWHeroRankStar, "HeroRankStar")
end

local function OnDestroy(self)
  self.img_quality = nil
  self.img_icon = nil
  self.img_type = nil
  self.img_job = nil
  self.text_level = nil
  self.level_bg = nil
  self.heroRankStar = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function RefreshData(self, data)
  self.param = data
  local metaId = self.param.metaId
  local meta = DataCenter.HeroTemplateManager:GetTemplate(metaId)
  if meta ~= nil then
    local icon = HeroUtils.GetQualityIconPath(meta.quality, false)
    self.img_quality:LoadSpriteAuto(icon)
    local iconPath = HeroUtils.GetHeroIconPath(meta.appearance, HeroIconType.small_icon)
    self.img_icon:LoadSpriteAuto(iconPath)
    self.img_type:LoadSpriteAuto(HeroUtils.GetHeroTypeIcon(meta.type))
    self.img_job:LoadSpriteAuto(HeroUtils.GetHeroJobIcon(meta.job))
    self.text_level:SetText("Lv." .. tostring(self.param.level))
    self.level_bg:SetActive(false)
    self.level_bg:LoadSpriteAuto(HeroUtils.GetLevelBg(meta.quality))
    self.heroRankStar:SetActive(false)
  end
end

local function OnBtnClick(self)
end

local function SetGray(self, gray)
end

WorldPointHeroSmallItem.OnCreate = OnCreate
WorldPointHeroSmallItem.OnDestroy = OnDestroy
WorldPointHeroSmallItem.OnBtnClick = OnBtnClick
WorldPointHeroSmallItem.OnEnable = OnEnable
WorldPointHeroSmallItem.OnDisable = OnDisable
WorldPointHeroSmallItem.RefreshData = RefreshData
WorldPointHeroSmallItem.SetGray = SetGray
return WorldPointHeroSmallItem
