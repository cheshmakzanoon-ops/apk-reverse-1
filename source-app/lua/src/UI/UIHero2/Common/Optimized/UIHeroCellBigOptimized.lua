local UIHeroCellBigOptimized = BaseClass("UIHeroCellBigOptimized", UIBaseContainer)
local base = UIBaseContainer
local LWHeroRankStarOptimized = require("UI.UIHero2.Common.Optimized.LWHeroRankStarOptimized")
local UIGray = CS.UIGray
local GameObject = CS.UnityEngine.GameObject
local Type_CS_Image = typeof(CS.UnityEngine.UI.Image)
local Type_CS_RectTransform = typeof(CS.UnityEngine.RectTransform)
local UpLvIconPrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/Optimized/UpLevelIcon.prefab"
local RedPointPrefabPath = "Assets/Main/Prefabs/UI/ChatNew/RedPointNum.prefab"

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

function UIHeroCellBigOptimized:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.img_icon1 = self.viewSkin:AddComponent(self, UIImage, 1)
  self.mask = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  self.img_bg = self.viewSkin:AddComponent(self, UIImage, 3)
  self.level_bg = self.viewSkin:AddComponent(self, UIImage, 4)
  self.text_level = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.btn_go = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btn_go:SetOnClick(function()
    self:OnBtn_goClick()
  end)
  self.typeIcon = self.viewSkin:AddComponent(self, UIImage, 7)
  self.jobIcon = self.viewSkin:AddComponent(self, UIImage, 8)
  self.compHeroRankStar = self.viewSkin:AddComponent(self, LWHeroRankStarOptimized, 9)
  self.nodeNewTag = self:LazyAddComponent(UIBaseComponent, "root/ImgNew")
  self.nodeRedPoint = self:LazyAddComponent(UIBaseComponent, "root/NodeRedPoint")
  self.upLevel = self:LazyAddComponent(UIBaseContainer, "root/UpLevel")
  self.upLevelAniRoot = self:LazyAddComponent(UIBaseContainer, "root/UpLevel/Icon")
  self.fragCountText = self:LazyAddComponent(UIText, "root/LevelBg/fragCountText")
  self.blackMask = self:LazyAddComponent(UIImage, "root/BlackMask")
  self.imgBomb = self:LazyAddComponent(UIImage, "root/ImgBomb")
end

function UIHeroCellBigOptimized:ComponentDestroy()
  self.viewSkin = nil
  self.img_icon1 = nil
  self.mask = nil
  self.img_bg = nil
  self.level_bg = nil
  self.text_level = nil
  self.btn_go = nil
  self.typeIcon = nil
  self.jobIcon = nil
  self.compHeroRankStar = nil
  self.nodeNewTag = nil
  self.nodeRedPoint = nil
  self.upLevel = nil
  self.upLevelAniRoot = nil
  self.fragCountText = nil
  self.blackMask = nil
  self.imgBomb = nil
  self:TryDestroyDominatorComponent()
  if self.reqHeroAwakenEffect ~= nil then
    self.reqHeroAwakenEffect:Destroy()
    self.reqHeroAwakenEffect = nil
  end
end

local function DataDefine(self)
  self.param = nil
  self.callBack = nil
end

local function DataDestroy(self)
  self.param = nil
  self.callBack = nil
end

local function SetHeroRank(self, rank, heroAwakenRank)
  if rank == nil then
    self.compHeroRankStar:SetActive(false)
  else
    self.compHeroRankStar:SetActive(true)
    if self.heroData and self.heroData.meta then
      self.compHeroRankStar:ShowRank(rank, self.heroData.meta.maxRank, heroAwakenRank)
    elseif self.heroId then
      local heroConfig = DataCenter.HeroTemplateManager:GetTemplate(self.heroId)
      self.compHeroRankStar:ShowRank(rank, heroConfig.maxRank, heroAwakenRank)
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
  local iconPath = HeroUtils.GetHeroIconPath(heroData.modelId, HeroIconType.half_portrait, heroData:GetSkinId())
  self.img_icon1:SetActive(true)
  self.img_icon1:LoadSpriteAuto(iconPath)
  self.text_level:SetText("Lv." .. tostring(heroData.level))
  local isNew = DataCenter.HeroDataManager:IsNewHero(heroUuid)
  self.nodeNewTag:SetActive(isNew)
  self:ToggleLevel(true)
  self:ToggleFragCount(false)
  self:ToggleBlackMask(false)
  local upLvShow = false
  if self.enableRedPoint then
    if heroData and heroData:CanUpMilitaryRank() then
      upLvShow = true
    end
    self:UpdateRedPoint()
  end
  self:SetUpLvIcon(upLvShow)
  SetHeroRank(self, heroData:GetRank(), heroData:GetHeroAwakenRankLevel())
  if self.typeIcon then
    self.typeIcon:SetActive(true)
    self.typeIcon:LoadSpriteAsync(HeroUtils.GetHeroTypeIcon(heroData.heroType, heroData:IsUniqueWeaponOpen() and heroData:HasUniqueWeapon(), heroData:IsHeroAwakened()))
  end
  if self.jobIcon then
    self.jobIcon:LoadSpriteAsync(HeroUtils.GetHeroJobIcon(heroData.meta.job, 2))
    self.jobIcon:SetActive(true)
  end
  self.imgBomb:SetActive(false)
  self:DisableDominatorComponent()
  local isAwakenMax = self.heroData:IsHeroAwakenReachMaxLevel()
  self:SetHeroAwakenEffect(isAwakenMax)
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
  self:SetUpLvIcon(false)
  local iconPath = HeroUtils.GetHeroIconPath(heroConfig.appearance, HeroIconType.half_portrait, nil)
  self.img_icon1:SetActive(true)
  self.img_icon1:LoadSpriteAuto(iconPath)
  self.typeIcon:SetActive(true)
  self.typeIcon:LoadSpriteAsync(HeroUtils.GetHeroTypeIcon(heroConfig.type))
  self:ToggleLevel(false)
  self:ToggleFragCount(true)
  self.nodeNewTag:SetActive(false)
  self.nodeRedPoint:SetActive(false)
  self:RefreshPieceItem()
  if self.jobIcon then
    self.jobIcon:LoadSpriteAsync(HeroUtils.GetHeroJobIcon(heroConfig.job, 2))
    self.jobIcon:SetActive(true)
  end
  SetHeroRank(self, nil, nil)
  local bomb = DataCenter.LWSaveGirlManager:IsSavingHero(self.heroId)
  self.imgBomb:SetActive(bomb)
  self:DisableDominatorComponent()
  self:SetHeroAwakenEffect(false)
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
  if heroConfig.heroData_type == HeroTemplateType.Dominator then
    self:SetDominatorConfig(heroId, rankId)
    return
  end
  if quality == nil then
    quality = heroConfig.quality
  end
  self:SetUpLvIcon(false)
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
  local iconPath = HeroUtils.GetHeroIconPath(modelId, HeroIconType.half_portrait, nil)
  self.img_icon1:SetActive(true)
  self.img_icon1:LoadSpriteAuto(iconPath)
  self.typeIcon:SetActive(true)
  self.typeIcon:LoadSpriteAuto(HeroUtils.GetHeroTypeIcon(heroConfig.type, 0 < _weaponLv))
  if self.jobIcon then
    self.jobIcon:LoadSpriteAuto(HeroUtils.GetHeroJobIcon(heroConfig.job, 2))
    self.jobIcon:SetActive(true)
  end
  self.text_level:SetText(level ~= nil and "Lv." .. tostring(level) or "")
  self.nodeNewTag:SetActive(false)
  self.nodeRedPoint:SetActive(false)
  SetHeroRank(self, rankId, nil)
  self:DisableDominatorComponent()
  self:SetHeroAwakenEffect(false)
end

local function SetQuality(self, quality, hideLv, isPoster, isWaken, isItem)
  self.img_bg:LoadSpriteAsync(HeroUtils.GetQualityIconPath(quality, true, false))
  self.level_bg:SetActive(true)
  self.level_bg:LoadSpriteAsync(HeroUtils.GetLevelBg(quality))
end

local function OnBtn_goClick(self)
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

function UIHeroCellBigOptimized:SetDominatorConfig(id, rank, showRank)
  self.img_bg:LoadSpriteAsync(LoadPath.DominatorIconBgBig)
  self.level_bg:SetActive(false)
  if self.typeIcon then
    self.typeIcon:SetActive(false)
  end
  if self.jobIcon then
    self.jobIcon:SetActive(false)
  end
  self.img_icon1:SetActive(false)
  self:SetUpLvIcon(false)
  SetHeroRank(self, nil, nil)
  local appearanceId = DataCenter.DominatorTemplateManager:GetAppearanceId(id, rank)
  local iconPath = HeroUtils.GetHeroIconPath(appearanceId, HeroIconType.small_icon, nil)
  if self.img_dominatorIcon == nil then
    local go = GameObject("img_dominatorIcon")
    go:AddComponent(Type_CS_Image)
    local rectTransform = go:GetComponent(Type_CS_RectTransform)
    rectTransform:SetParent(self.mask.transform)
    rectTransform:SetAsLastSibling()
    self.img_dominatorIcon = self:AddComponent(UIImage, "LayerNormal/ImgBg/Mask/img_dominatorIcon")
    self.img_dominatorIcon:SetLocalScaleXYZ(1, 1, 1)
    self.img_dominatorIcon:SetPivotXY(0.5, 1)
    self.img_dominatorIcon:SetAnchorMinXY(0.5, 1)
    self.img_dominatorIcon:SetAnchorMaxXY(0.5, 1)
    self.img_dominatorIcon:SetAnchoredPositionXY(0, 0)
    self.img_dominatorIcon:SetSizeDeltaXY(148, 148)
  end
  self.img_dominatorIcon:SetEnable(true)
  self.img_dominatorIcon:LoadSpriteAuto(iconPath)
  if showRank == nil then
    showRank = true
  end
  rank = rank or 0
  if rank < 0 then
    showRank = false
  end
  if not showRank then
    if self.img_dominatorRank then
      self.img_dominatorRank:SetEnable(false)
    end
  else
    if self.img_dominatorRank == nil then
      local go = GameObject("img_dominatorRank")
      go:AddComponent(Type_CS_Image)
      local rectTransform = go:GetComponent(Type_CS_RectTransform)
      rectTransform:SetParent(self.transform)
      rectTransform:SetAsLastSibling()
      self.img_dominatorRank = self:AddComponent(UIImage, "img_dominatorRank")
      self.img_dominatorRank:SetLocalScaleXYZ(1, 1, 1)
      self.img_dominatorRank:SetPivotXY(0.5, 1)
      self.img_dominatorRank:SetAnchoredPositionXY(0, -29.5)
      self.img_dominatorRank:SetSizeDeltaXY(80, 80)
    end
    local rankShowTemplate = DataCenter.DominatorTemplateManager:GetRankShowTemplateByIdAndRank(id, rank)
    if rankShowTemplate == nil then
      self.img_dominatorRank:SetEnable(false)
    else
      self.img_dominatorRank:SetEnable(true)
      self.img_dominatorRank:LoadSpriteAsync(rankShowTemplate:GetRankIconPathSmall())
    end
  end
  self:SetHeroAwakenEffect(false)
end

function UIHeroCellBigOptimized:DisableDominatorComponent()
  if self.img_dominatorRank then
    self.img_dominatorRank:SetEnable(false)
  end
  if self.img_dominatorIcon then
    self.img_dominatorIcon:SetEnable(false)
  end
end

function UIHeroCellBigOptimized:TryDestroyDominatorComponent()
  if self.img_dominatorRank then
    local go = self.img_dominatorRank.gameObject
    if not IsNull(go) then
      go.name = "Deleted"
      self:RemoveComponent(self.img_dominatorRank:GetName(), UIImage)
      CS.UnityEngine.GameObject.Destroy(go)
    else
      Logger.LogError("img_dominatorRank gameObject is null")
    end
    self.img_dominatorRank = nil
  end
  if self.img_dominatorIcon then
    local go = self.img_dominatorIcon.gameObject
    if not IsNull(go) then
      go.name = "Deleted"
      self:RemoveComponent(self.img_dominatorIcon:GetName(), UIImage)
      CS.UnityEngine.GameObject.Destroy(go)
    else
      Logger.LogError("img_dominatorIcon gameObject is null")
    end
    self.img_dominatorIcon = nil
  end
end

function UIHeroCellBigOptimized:SetUpLvIcon(show)
  self.upLvShow = show
  self.upLevel:SetActive(true)
  if not show and not self.upLvIcon then
    return
  end
  if self.upLvIcon then
    self.upLvIcon:SetActive(show)
  end
  if not self.upLvReq then
    self.upLvReq = self:GameObjectInstantiateAsync(UpLvIconPrefabPath, function(req)
      if IsNull(req.gameObject) then
        return
      end
      local go = req.gameObject
      local trans = go.transform
      go.name = "UpLvIcon"
      trans:SetParent(self.upLevelAniRoot.transform)
      trans:Set_localScale(1, 1, 1)
      trans:Set_localPosition(0, 0, 0)
      self.upLvIcon = self.upLevelAniRoot:AddComponent(UIBaseContainer, "UpLvIcon")
      self.upLvIcon:SetActive(self.upLvShow)
      self.upLvIcon:SetAnchoredPositionXY(0, 0)
    end)
  end
end

function UIHeroCellBigOptimized:SetHeroAwakenEffect(isShowEffect)
end

UIHeroCellBigOptimized.OnCreate = OnCreate
UIHeroCellBigOptimized.OnDestroy = OnDestroy
UIHeroCellBigOptimized.OnEnable = OnEnable
UIHeroCellBigOptimized.OnDisable = OnDisable
UIHeroCellBigOptimized.DataDefine = DataDefine
UIHeroCellBigOptimized.DataDestroy = DataDestroy
UIHeroCellBigOptimized.SetData = SetData
UIHeroCellBigOptimized.InitWithConfigId = InitWithConfigId
UIHeroCellBigOptimized.SetQuality = SetQuality
UIHeroCellBigOptimized.OnBtn_goClick = OnBtn_goClick
UIHeroCellBigOptimized.HideStar = HideStar
UIHeroCellBigOptimized.EnableRedPoint = EnableRedPoint
UIHeroCellBigOptimized.DisableRedPoint = DisableRedPoint
UIHeroCellBigOptimized.UpdateRedPoint = UpdateRedPoint
UIHeroCellBigOptimized.GetRarityMaskPath = GetRarityMaskPath
UIHeroCellBigOptimized.GetRarityLvBgPath = GetRarityLvBgPath
UIHeroCellBigOptimized.ToggleLevel = ToggleLevel
UIHeroCellBigOptimized.GetGuideClickBtn = GetGuideClickBtn
UIHeroCellBigOptimized.InitWithHeroPieceItem = InitWithHeroPieceItem
UIHeroCellBigOptimized.RefreshPieceItem = RefreshPieceItem
UIHeroCellBigOptimized.ToggleFragCount = ToggleFragCount
UIHeroCellBigOptimized.ToggleBlackMask = ToggleBlackMask
return UIHeroCellBigOptimized
