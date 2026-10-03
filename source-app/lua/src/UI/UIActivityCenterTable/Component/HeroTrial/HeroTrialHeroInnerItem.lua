local HeroTrialHeroInnerItem = BaseClass("HeroTrialHeroInnerItem", UIBaseContainer)
local base = UIBaseContainer
local LWHeroRankStar = require("UI.UIHero2.Common.LWHeroRankStar")

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
  self.layerNormal = self:AddComponent(UIBaseContainer, "LayerNormal")
  self.img_bg = self:AddComponent(UIImage, "LayerNormal/ImgBg")
  self.img_icon1 = self:AddComponent(UIImage, "LayerNormal/ImgBg/Mask/ImgIcon1")
  self.level_bg = self:AddComponent(UIImage, "LevelBg")
  self.text_level = self:AddComponent(UIText, "LevelBg/TextLevel")
  self.btn_go = self:AddComponent(UIButton, "")
  self.btn_go:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
  if self.transform:Find("typeLayOut/TypeIcon") then
    self.typeIcon = self:AddComponent(UIImage, "typeLayOut/TypeIcon")
  elseif self.transform:Find("TypeIcon") then
    self.typeIcon = self:AddComponent(UIImage, "TypeIcon")
  end
  if self.transform:Find("typeLayOut/jobIcon") then
    self.jobIcon = self:AddComponent(UIImage, "typeLayOut/jobIcon")
  end
  self.heroRankStar = self:AddComponent(LWHeroRankStar, "HeroRankStar")
end

local function ComponentDestroy(self)
  self.layerNormal = nil
  self.img_bg = nil
  self.img_icon1 = nil
  self.level_bg = nil
  self.text_level = nil
  self.btn_go = nil
  self.typeIcon = nil
end

local function DataDefine(self)
  self.param = nil
  self.callBack = nil
end

local function DataDestroy(self)
  self.param = nil
  self.callBack = nil
end

local function SetHeroRank(self, rank)
  if rank == nil then
    self.heroRankStar:SetActive(false)
  else
    self.heroRankStar:SetActive(true)
    self.heroRankStar:ShowRank(rank, self.heroData.meta.maxRank)
  end
end

local function SetData(self, heroUuid, callBack)
  self.param = heroUuid
  self.itemId = nil
  self.callBack = callBack
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
  local quality = heroData.quality
  self.heroData = heroData
  self.quality = heroData.quality
  self.heroId = heroData.heroId
  self:SetQuality(quality, false)
  local iconPath = HeroUtils.GetHeroIconPath(heroData.modelId, HeroIconType.half_portrait)
  self.img_icon1:LoadSpriteAuto(iconPath)
  self.text_level:SetText("Lv." .. tostring(heroData.level))
  self:ToggleLevel(false)
  self:ToggleFragCount(false)
  self:ToggleBlackMask(false)
  SetHeroRank(self, heroData:GetRank())
  if self.typeIcon then
    self.typeIcon:LoadSprite(HeroUtils.GetHeroTypeIcon(heroData.heroType))
  end
  if self.jobIcon then
    self.jobIcon:LoadSprite(HeroUtils.GetHeroJobIcon(heroData.meta.job, 2))
    self.jobIcon:SetActive(true)
  end
end

local function InitWithHeroPieceItem(self, itemId, callBack)
  self.param = itemId
  self.callBack = callBack
  local item = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
  local heroConfig = DataCenter.HeroTemplateManager:GetTemplate(toInt(item.para2))
  if heroConfig == nil then
    return
  end
  local quality = heroConfig.quality
  self.heroId = heroConfig.id
  self:SetQuality(quality, true, false)
  local iconPath = HeroUtils.GetHeroIconPath(heroConfig.appearance, HeroIconType.half_portrait)
  self.img_icon1:LoadSpriteAuto(iconPath)
  self.typeIcon:LoadSpriteAuto(HeroUtils.GetHeroTypeIcon(heroConfig.type))
  self.heroRankStar:SetActive(true)
  self.heroRankStar:ShowRank(0, heroConfig.maxRank)
end

local function RefreshPieceItem(self)
  local itemCount = DataCenter.ItemData:GetItemCount(self.param)
  local itemNeed = HeroUtils.GetJigsawCost(self.param)
  self:ToggleBlackMask(itemCount < itemNeed)
end

local function InitWithConfigId(self, heroId, quality, level, rankId)
  self.param = heroId
  self.itemId = nil
  local heroConfig = DataCenter.HeroTemplateManager:GetTemplate(heroId)
  if heroConfig == nil then
    return
  end
  if quality == nil then
    quality = heroConfig.quality
  end
  self.heroId = heroConfig.id
  self:SetQuality(quality, level == nil, false)
  local iconPath = HeroUtils.GetHeroIconPath(heroConfig.appearance, HeroIconType.half_portrait)
  self.img_icon1:LoadSpriteAuto(iconPath)
  self.typeIcon:LoadSpriteAuto(HeroUtils.GetHeroTypeIcon(heroConfig.type))
  self.text_level:SetText(level ~= nil and "Lv." .. tostring(level) or "")
  SetHeroRank(self, rankId)
end

local function SetQuality(self, quality, hideLv, isPoster, isWaken, isItem)
  self.img_bg:LoadSpriteAuto(HeroUtils.GetQualityIconPath(quality, true, false))
  self.level_bg:LoadSpriteAuto(HeroUtils.GetLevelBg(quality))
end

local function OnBtnClick(self)
  local openHeroExhibit = CommonUtil.PlayerPrefsGetBool("OPEN_HERO_EXHIBIT_IN_HERO_VIEW", false)
  if not openHeroExhibit then
    self:UpdateRedPoint()
    if self.callBack ~= nil then
      self.callBack(self.transform, self.param)
    end
  else
    local heroUuid = self.param
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
    if heroUuid ~= nil and heroData ~= nil and DataCenter.HeroDataManager:NeedShowNewHeroWindow(heroUuid) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroExhibitPanel, {anim = false}, heroUuid, {heroUuid}, nil, true)
    end
  end
end

local function UpdateRedPoint(self)
end

local function EnableRedPoint(self)
  self.enableRedPoint = true
  self:UpdateRedPoint()
end

local function DisableRedPoint(self)
  self.enableRedPoint = false
end

local function GetRarityMaskPath(rarity, isWaken)
  if isWaken then
    return string.format(LoadPath.HeroListPath, "ui_quality_mask_cai_big")
  end
  local mask = {
    "ui_quality_mask_orange_big",
    "ui_quality_mask_purple_big",
    "ui_quality_mask_blue_big",
    "ui_quality_mask_green_big"
  }
  local iconName = mask[rarity]
  return string.format(LoadPath.HeroListPath, iconName)
end

local function GetRarityLvBgPath(rarity, isWaken)
  local path = LoadPath.HeroListPath
  if isWaken then
    return string.format(path, "ui_herolist_lv_cai_bg")
  end
  local bg = {
    "ui_herolist_lv_orange_bg",
    "ui_herolist_lv_purple_bg",
    "ui_herolist_lv_blue_bg",
    "ui_herolist_lv_green_bg"
  }
  local iconName = bg[rarity]
  return string.format(path, iconName)
end

local function GetCellPos(self)
  return self.layerNormal.transform.position
end

local function GetCellSizeDelta(self)
  return self.layerNormal:GetSizeDelta()
end

local function ToggleLevel(self, t)
  self.text_level:SetActive(t)
end

local function GetGuideClickBtn(self)
  return self.btn_go
end

local function HideStar(self)
end

local function ToggleFragCount(self, t)
end

local function ToggleBlackMask(self, t)
end

HeroTrialHeroInnerItem.OnCreate = OnCreate
HeroTrialHeroInnerItem.OnDestroy = OnDestroy
HeroTrialHeroInnerItem.OnEnable = OnEnable
HeroTrialHeroInnerItem.OnDisable = OnDisable
HeroTrialHeroInnerItem.ComponentDefine = ComponentDefine
HeroTrialHeroInnerItem.ComponentDestroy = ComponentDestroy
HeroTrialHeroInnerItem.DataDefine = DataDefine
HeroTrialHeroInnerItem.DataDestroy = DataDestroy
HeroTrialHeroInnerItem.SetData = SetData
HeroTrialHeroInnerItem.InitWithConfigId = InitWithConfigId
HeroTrialHeroInnerItem.SetQuality = SetQuality
HeroTrialHeroInnerItem.OnBtnClick = OnBtnClick
HeroTrialHeroInnerItem.HideStar = HideStar
HeroTrialHeroInnerItem.EnableRedPoint = EnableRedPoint
HeroTrialHeroInnerItem.DisableRedPoint = DisableRedPoint
HeroTrialHeroInnerItem.UpdateRedPoint = UpdateRedPoint
HeroTrialHeroInnerItem.GetRarityMaskPath = GetRarityMaskPath
HeroTrialHeroInnerItem.GetRarityLvBgPath = GetRarityLvBgPath
HeroTrialHeroInnerItem.GetCellPos = GetCellPos
HeroTrialHeroInnerItem.GetCellSizeDelta = GetCellSizeDelta
HeroTrialHeroInnerItem.ToggleLevel = ToggleLevel
HeroTrialHeroInnerItem.GetGuideClickBtn = GetGuideClickBtn
HeroTrialHeroInnerItem.InitWithHeroPieceItem = InitWithHeroPieceItem
HeroTrialHeroInnerItem.RefreshPieceItem = RefreshPieceItem
HeroTrialHeroInnerItem.ToggleFragCount = ToggleFragCount
HeroTrialHeroInnerItem.ToggleBlackMask = ToggleBlackMask
return HeroTrialHeroInnerItem
