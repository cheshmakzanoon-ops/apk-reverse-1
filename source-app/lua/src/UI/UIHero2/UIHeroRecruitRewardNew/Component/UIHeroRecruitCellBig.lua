local UIHeroCellBig = BaseClass("UIHeroCellBig", UIBaseContainer)
local base = UIBaseContainer
local UIHeroStars = require("UI.UIHero2.Common.UIHeroStars")
local UIHeroCellBigPiece = require("UI.UIHero2.Common.UIHeroCellBigPiece")
local LWHeroRankStar = require("UI.UIHero2.Common.LWHeroRankStar")
local UIGray = CS.UIGray

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
    self:OnBtnClick()
  end)
  self.nodeNewTag = self:AddComponent(UIBaseContainer, "ImgNew")
  self.nodeRedPoint = self:AddComponent(UIBaseContainer, "NodeRedPoint")
  if self.transform:Find("UpLevel") then
    self.upLevel = self:AddComponent(UIImage, "UpLevel")
  end
  if self.transform:Find("typeLayOut/TypeIcon") then
    self.typeIcon = self:AddComponent(UIImage, "typeLayOut/TypeIcon")
  elseif self.transform:Find("TypeIcon") then
    self.typeIcon = self:AddComponent(UIImage, "TypeIcon")
  end
  if self.transform:Find("typeLayOut/jobIcon") then
    self.jobIcon = self:AddComponent(UIImage, "typeLayOut/jobIcon")
  end
  self.fragCountText = self:AddComponent(UIText, "LevelBg/fragCountText")
  self.blackMask = self:AddComponent(UIImage, "BlackMask")
  self.heroRankStar = self:AddComponent(LWHeroRankStar, "HeroRankStar")
  self.imgBomb = self:AddComponent(UIImage, "ImgBomb")
end

local function ComponentDestroy(self)
  self.layerNormal = nil
  self.img_bg = nil
  self.img_icon1 = nil
  self.level_bg = nil
  self.text_level = nil
  self.btn_go = nil
  self.nodeNewTag = nil
  self.nodeRedPoint = nil
  self.typeIcon = nil
  self.fragCountText = nil
  self.blackMask = nil
end

local function DataDefine(self)
  self.param = nil
  self.callBack = nil
end

local function DataDestroy(self)
  self.param = nil
  self.callBack = nil
end

local function SetHeroRank(self, rank, heroAwakenRankLv)
  if rank == nil then
    self.heroRankStar:SetActive(false)
  else
    self.heroRankStar:SetActive(true)
    if self.heroData and self.heroData.meta then
      self.heroRankStar:ShowRank(rank, self.heroData.meta.maxRank, heroAwakenRankLv)
    elseif self.heroId then
      local heroConfig = DataCenter.HeroTemplateManager:GetTemplate(self.heroId)
      self.heroRankStar:ShowRank(rank, heroConfig.maxRank, heroAwakenRankLv)
    end
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
  local isNew = DataCenter.HeroDataManager:IsNewHero(heroUuid)
  self.nodeNewTag:SetActive(isNew)
  self:ToggleLevel(true)
  self:ToggleFragCount(false)
  self:ToggleBlackMask(false)
  if self.upLevel then
    self.upLevel:SetActive(false)
    if self.enableRedPoint and heroData and heroData:CanUpMilitaryRank() then
      self.upLevel:SetActive(true)
    end
  end
  SetHeroRank(self, heroData:GetRank(), heroData:GetHeroAwakenRankLevel())
  if self.typeIcon then
    self.typeIcon:LoadSpriteAuto(HeroUtils.GetHeroTypeIcon(heroData.heroType, heroData:IsUniqueWeaponOpen() and heroData:HasUniqueWeapon(), heroData:IsHeroAwakened()))
  end
  if self.jobIcon then
    self.jobIcon:LoadSprite(HeroUtils.GetHeroJobIcon(heroData.meta.job, 2))
    self.jobIcon:SetActive(true)
  end
  self.imgBomb:SetActive(false)
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
  self.upLevel:SetActive(false)
  local iconPath = HeroUtils.GetHeroIconPath(heroConfig.appearance, HeroIconType.half_portrait)
  self.img_icon1:LoadSpriteAuto(iconPath)
  self.typeIcon:LoadSpriteAuto(HeroUtils.GetHeroTypeIcon(heroConfig.type))
  self:ToggleLevel(false)
  self:ToggleFragCount(true)
  self.nodeNewTag:SetActive(false)
  self.nodeRedPoint:SetActive(false)
  self:RefreshPieceItem()
  if self.jobIcon then
    self.jobIcon:LoadSpriteAuto(HeroUtils.GetHeroJobIcon(heroConfig.job, 2))
    self.jobIcon:SetActive(true)
  end
  SetHeroRank(self, nil, nil)
  local bomb = DataCenter.LWSaveGirlManager:IsSavingHero(self.heroId)
  self.imgBomb:SetActive(bomb)
end

local function RefreshPieceItem(self)
  local itemCount = DataCenter.ItemData:GetItemCount(self.param)
  local itemNeed = HeroUtils.GetJigsawCost(self.param)
  self.nodeRedPoint:SetActive(itemCount >= itemNeed)
  self.fragCountText:SetText(itemCount .. "/" .. itemNeed)
  self:ToggleBlackMask(itemCount < itemNeed)
end

local function InitWithConfigId(self, heroId, quality, level, rankId, weaponLv)
  self.param = heroId
  self.itemId = nil
  local heroConfig = DataCenter.HeroTemplateManager:GetTemplate(heroId)
  if heroConfig == nil then
    return
  end
  if quality == nil then
    quality = heroConfig.quality
  end
  self.upLevel:SetActive(false)
  self.heroId = heroConfig.id
  self:SetQuality(quality, level == nil, false)
  self:ToggleFragCount(false)
  local modelId = heroConfig.appearance
  local _weaponLv = weaponLv or 0
  if _weaponLv ~= nil and 0 < _weaponLv then
    local weaponInfo = DataCenter.HeroUniqueWeaponTemplateManager:GetTemplateByHeroId(heroId, _weaponLv)
    if weaponInfo ~= nil then
      modelId = weaponInfo.modelId
    end
  end
  local iconPath = HeroUtils.GetHeroIconPath(modelId, HeroIconType.half_portrait)
  self.img_icon1:LoadSpriteAuto(iconPath)
  self.typeIcon:LoadSpriteAuto(HeroUtils.GetHeroTypeIcon(heroConfig.type, 0 < _weaponLv))
  if self.jobIcon then
    self.jobIcon:LoadSpriteAuto(HeroUtils.GetHeroJobIcon(heroConfig.job, 2))
    self.jobIcon:SetActive(true)
  end
  self.text_level:SetText(level ~= nil and "Lv." .. tostring(level) or "")
  self.nodeNewTag:SetActive(false)
  self.nodeRedPoint:SetActive(false)
  SetHeroRank(self, rankId, nil)
end

local function SetQuality(self, quality, hideLv, isPoster, isWaken, isItem)
  self.img_bg:LoadSpriteAuto(HeroUtils.GetQualityIconPath(quality, true, false))
  self.level_bg:LoadSpriteAuto(HeroUtils.GetLevelBg(quality))
end

local function OnBtnClick(self)
  local openHeroExhibit = CommonUtil.PlayerPrefsGetBool("OPEN_HERO_EXHIBIT_IN_HERO_VIEW", false)
  if not openHeroExhibit then
    self.nodeNewTag:SetActive(false)
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
  local heroUuid = self.param
  if not self.enableRedPoint then
    self.nodeRedPoint:SetActive(false)
    return
  end
  if heroUuid ~= nil and self.heroUuid ~= "" then
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
    if heroData ~= nil then
      local needShowRed = HeroRedPointManager:GetInstance():CheckCanShowRedPoint(HeroRedPointType.HeroListCard, heroUuid)
      self.nodeRedPoint:SetActive(needShowRed)
    end
  end
end

local function EnableRedPoint(self)
  self.enableRedPoint = true
  self:UpdateRedPoint()
end

local function DisableRedPoint(self)
  self.enableRedPoint = false
  self.nodeRedPoint:SetActive(false)
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
  self.fragCountText:SetActive(t)
end

local function ToggleBlackMask(self, t)
  self.blackMask:SetActive(t)
end

UIHeroCellBig.OnCreate = OnCreate
UIHeroCellBig.OnDestroy = OnDestroy
UIHeroCellBig.OnEnable = OnEnable
UIHeroCellBig.OnDisable = OnDisable
UIHeroCellBig.ComponentDefine = ComponentDefine
UIHeroCellBig.ComponentDestroy = ComponentDestroy
UIHeroCellBig.DataDefine = DataDefine
UIHeroCellBig.DataDestroy = DataDestroy
UIHeroCellBig.SetData = SetData
UIHeroCellBig.InitWithConfigId = InitWithConfigId
UIHeroCellBig.SetQuality = SetQuality
UIHeroCellBig.OnBtnClick = OnBtnClick
UIHeroCellBig.HideStar = HideStar
UIHeroCellBig.EnableRedPoint = EnableRedPoint
UIHeroCellBig.DisableRedPoint = DisableRedPoint
UIHeroCellBig.UpdateRedPoint = UpdateRedPoint
UIHeroCellBig.GetRarityMaskPath = GetRarityMaskPath
UIHeroCellBig.GetRarityLvBgPath = GetRarityLvBgPath
UIHeroCellBig.GetCellPos = GetCellPos
UIHeroCellBig.GetCellSizeDelta = GetCellSizeDelta
UIHeroCellBig.ToggleLevel = ToggleLevel
UIHeroCellBig.GetGuideClickBtn = GetGuideClickBtn
UIHeroCellBig.InitWithHeroPieceItem = InitWithHeroPieceItem
UIHeroCellBig.RefreshPieceItem = RefreshPieceItem
UIHeroCellBig.ToggleFragCount = ToggleFragCount
UIHeroCellBig.ToggleBlackMask = ToggleBlackMask
return UIHeroCellBig
