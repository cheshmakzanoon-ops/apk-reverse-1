local UIHeroCellSmall = BaseClass("UIHeroCellSmall", UIBaseContainer)
local base = UIBaseContainer
local UIHeroStars = require("UI.UIHero2.Common.UIHeroStars")
local LWHeroRankStar = require("UI.UIHero2.Common.LWHeroRankStar")
local GameObject = CS.UnityEngine.GameObject
local Type_CS_Image = typeof(CS.UnityEngine.UI.Image)
local Type_CS_RectTransform = typeof(CS.UnityEngine.RectTransform)
local btn_go_path = ""
local img_quality_path = "imgQuality"
local img_camp_path = "imgCamp"
local img_level_bg_path = "LVBg"
local text_level_path = "textLevel"
local img_rank_path = "ImgRank"
local img_type_path = "ImgType"
local img_Job_path = "ImgJob"
local img_mask_path = "Mask"
local img_selected_path = "SelectedMark"
local text_name_path = "textName"
local BattleLevel = DataCenter.BattleLevel

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
  self.img_icon = self:AddComponent(UIImage, "imgIcon")
  self.level_bg = self:AddComponent(UIImage, img_level_bg_path)
  self.text_level = self:AddComponent(UIText, text_level_path)
  self.text_level.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
  self.img_rank = self:AddComponent(UIImage, img_rank_path)
  self.img_type = self:AddComponent(UIImage, img_type_path)
  self.img_job = self:AddComponent(UIImage, img_Job_path)
  self.mask = self:AddComponent(UIImage, img_mask_path)
  self.selected_mark = self:AddComponent(UIImage, img_selected_path)
  self.text_name = self:AddComponent(UIText, text_name_path)
  self.btn_go = self:AddComponent(UIButton, btn_go_path)
  self.btn_go:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
  self.heroRankStar = self:AddComponent(LWHeroRankStar, "HeroRankStar")
  self.empty = self:AddComponent(UIBaseComponent, "imgEmpty")
end

local function ComponentDestroy(self)
  self.img_icon = nil
  self.img_camp = nil
  self.level_bg = nil
  self.text_level = nil
  self.img_rank = nil
  self.img_type = nil
  self.img_job = nil
  self.mask = nil
  self.selected_mark = nil
  self.text_name = nil
  self.btn_go = nil
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
end

local function DataDefine(self)
  self.heroUuid = 0
  self.callBack = nil
end

local function DataDestroy(self)
  self.heroUuid = nil
  self.callBack = nil
end

local function GetSelected(self)
  if self.selected == nil then
    self.selected = false
  end
  return self.selected
end

local function SetMask(self, stat)
  self.mask:SetActive(stat)
end

local function SetSelected(self, state)
  local oldState = self.selected
  self.selected = state
  self.selected_mark:SetActive(state)
  if not oldState and state then
    SetMask(self, true)
  elseif oldState and not state then
    SetMask(self, false)
  end
end

local function Reinit(self, param)
  self:SetData(param.heroUuid)
end

local function SetData(self, heroUuid, callBack, showGrade, showZeroStar, iconType)
  if heroUuid == nil then
    self.empty:SetActive(true)
    return
  else
    self.empty:SetActive(false)
  end
  self.heroUuid = heroUuid
  self.callBack = callBack
  self.showZeroStar = showZeroStar
  local heroData = BattleLevel:GetPveHeroData(heroUuid)
  assert(heroData ~= nil, "heroData is nil! heroUuid:" .. tostring(heroUuid))
  self:SetHeroData(heroData)
  if self.img_dominatorRank then
    self.img_dominatorRank:SetEnable(false)
  end
end

local function SetHeroData(self, heroData, iconType)
  local quality = heroData.quality
  self.quality = quality
  self.heroId = heroData.heroId
  self.isWaken = heroData.IsWakeUp ~= nil and heroData:IsWakeUp() or false
  local iconPath = HeroUtils.GetHeroIconPath(heroData.modelId, iconType, heroData:GetSkinId())
  self.img_icon:LoadSpriteAuto(iconPath)
  self.img_type:SetEnable(true)
  self.img_job:SetEnable(true)
  self.img_type:LoadSpriteAuto(HeroUtils.GetHeroTypeIcon(heroData.heroType, heroData:IsUniqueWeaponOpen() and heroData:HasUniqueWeapon(), heroData:IsHeroAwakened()))
  self.img_job:LoadSpriteAuto(HeroUtils.GetHeroJobIcon(heroData.meta.job, 2))
  self.text_name:SetText(heroData:GetName())
  self.text_level:SetText("Lv." .. tostring(heroData.level))
  self:SetQuality(quality, false)
  self:SetRank(heroData:GetRank(), heroData.meta.maxRank, heroData:GetHeroAwakenRankLevel())
  SetSelected(self, false)
  SetMask(self, false)
  if self.img_dominatorRank then
    self.img_dominatorRank:SetEnable(false)
  end
end

local function SetHeroStationSkill(self, skillId)
end

local function CheckInStation(self, stationId)
end

local function InitWithConfigId(self, heroConfigId, quality, level, rankId, weaponLv, awakenLv, skinId)
  if heroConfigId == nil then
    self.empty:SetActive(true)
    return
  else
    self.empty:SetActive(false)
  end
  local heroConfig = DataCenter.HeroTemplateManager:GetTemplate(heroConfigId)
  if heroConfig == nil then
    return
  end
  if heroConfig.heroData_type == HeroTemplateType.Dominator then
    self:SetDominatorConfig(heroConfigId, rankId)
    return
  end
  if quality == nil then
    quality = heroConfig.quality
  end
  local modelId = heroConfig.appearance
  local _weaponLevel = weaponLv or 0
  if _weaponLevel ~= nil and 0 < _weaponLevel then
    local weaponInfo = DataCenter.HeroUniqueWeaponTemplateManager:GetTemplateByHeroId(heroConfigId, _weaponLevel)
    if weaponInfo ~= nil then
      modelId = weaponInfo.modelId
    end
  end
  local iconPath = HeroUtils.GetHeroIconPath(modelId, nil, skinId)
  self.img_icon:LoadSpriteAuto(iconPath)
  self.text_name:SetLocalText(heroConfig.name)
  self.quality = heroConfig.rarity
  self.heroId = heroConfig.id
  self:SetQuality(quality, false)
  self.level_bg:LoadSpriteAsync(HeroUtils.GetLevelBg(quality))
  self.text_level:SetText(level ~= nil and "Lv." .. tostring(level) or "")
  self.img_type:SetEnable(true)
  self.img_job:SetEnable(true)
  self.img_job:LoadSpriteAsync(HeroUtils.GetHeroJobIcon(heroConfig.job, 2))
  local isShowUniqueWeapon = heroConfig:IsUnqueWeaponShow()
  local hasWeapon = _weaponLevel ~= nil and 0 < _weaponLevel
  local isAwakened = awakenLv ~= nil and 0 < awakenLv
  self.img_type:LoadSpriteAsync(HeroUtils.GetHeroTypeIcon(heroConfig.type, isShowUniqueWeapon and hasWeapon, isAwakened))
  self:SetRank(rankId, heroConfig.maxRank, awakenLv)
  SetSelected(self, false)
  SetMask(self, false)
  if self.img_dominatorRank then
    self.img_dominatorRank:SetEnable(false)
  end
end

local function SetQuality(self, quality, isPoster, isWaken)
  self.img_quality:SetActive(not isPoster)
  self.img_icon:SetActive(not isPoster)
  self.level_bg:SetActive(not isPoster)
  self:ToggleLevel(not isPoster)
  if isPoster then
    self:ToggleLevel(false)
  else
    local icon = HeroUtils.GetQualityIconPath(quality, false)
    self.img_quality:LoadSpriteAsync(icon)
    self.level_bg:LoadSpriteAsync(HeroUtils.GetLevelBg(quality))
  end
end

local function InitWithConfigIdByPoster(self, heroConfigId, quality, level)
  if heroConfigId == nil then
    self.empty:SetActive(true)
    return
  else
    self.empty:SetActive(false)
  end
  local heroConfig = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), heroConfigId)
  if quality == nil then
    quality = heroConfig.init_quality_level
  end
  self.text_name:SetLocalText(heroConfig.name)
  self.rarity = heroConfig.rarity
  self.heroId = heroConfig.id
  self:SetQuality(quality, true)
  self.level_bg:SetActive(level ~= nil)
  SetSelected(self, false)
  SetMask(self, false)
  if self.img_dominatorRank then
    self.img_dominatorRank:SetEnable(false)
  end
end

local function SetRank(self, rank, maxRank, heroAwakenRank)
  if rank == nil or rank == 0 then
    self.heroRankStar:SetActive(false)
    return
  end
  self.heroRankStar:SetActive(true)
  self.heroRankStar:ShowRank(rank, maxRank, heroAwakenRank)
end

local function SetDisplayLevel(self, level)
  self.text_level:SetText("Lv." .. level)
end

local function OnBtnClick(self)
  if self.callBack ~= nil then
    self.callBack(self.transform, self.heroUuid)
  end
end

local function SetLvTextBiggest(self)
  self.text_level.transform:Set_localScale(1.3, 1.3, 1.3)
end

local function ToggleRayCast(self, t)
  local empty4Raycast = self.btn_go.transform:GetComponent(typeof(CS.UnityEngine.UI.Empty4Raycast))
  if empty4Raycast ~= nil then
    empty4Raycast.raycastTarget = t
  end
end

local function ToggleRank(self, t)
  self.img_rank:SetActive(t)
end

local function ToggleLevel(self, t)
  self.level_bg:SetActive(t)
  self.text_level:SetActive(t)
end

function UIHeroCellSmall:ToggleJob(t)
  self.img_job:SetEnable(t)
end

local function SetStarActive(self, active)
end

local function SetCampActive(self, active)
  if self.img_camp ~= nil then
    self.img_camp:SetActive(active)
  end
end

local function GetLastStarPos(self)
  return Vector3.New(0, 0, 0)
end

local function ShowUpgradeStarEffect(self)
end

local function ShowStarProgress(self)
end

local function SetAllImageGrey(self, showGrey, click)
  CS.UIGray.SetGray(self.transform, showGrey, click)
end

function UIHeroCellSmall:SetDominatorConfig(id, rank, showRank)
  local appearanceId = DataCenter.DominatorTemplateManager:GetAppearanceId(id, rank)
  local iconPath = HeroUtils.GetHeroIconPath(appearanceId, HeroIconType.small_icon, nil)
  self.img_icon:LoadSpriteAuto(iconPath)
  self.img_quality:LoadSpriteAsync(LoadPath.DominatorIconBg)
  self:ToggleLevel(false)
  self:ToggleRank(false)
  self.img_type:SetEnable(false)
  self.img_job:SetEnable(false)
  self:SetRank(0)
  if showRank == nil then
    showRank = true
  end
  local rank = rank or 0
  if rank < 0 or not showRank then
    if self.img_dominatorRank then
      self.img_dominatorRank:SetEnable(false)
    end
    return
  end
  if self.img_dominatorRank == nil then
    local go = GameObject("img_dominatorRank")
    go:AddComponent(Type_CS_Image)
    local rectTransform = go:GetComponent(Type_CS_RectTransform)
    rectTransform:SetParent(self.img_icon.transform)
    rectTransform:SetAsLastSibling()
    self.img_dominatorRank = self:AddComponent(UIImage, "imgIcon/img_dominatorRank")
    self.img_dominatorRank:SetLocalScaleXYZ(1, 1, 1)
    self.img_dominatorRank:SetPivotXY(0, 1)
    self.img_dominatorRank:SetAnchorMinXY(0, 1)
    self.img_dominatorRank:SetAnchorMaxXY(0, 1)
    self.img_dominatorRank:SetAnchoredPositionXY(-13.2, 11.5)
    self.img_dominatorRank:SetSizeDeltaXY(60, 60)
  end
  local rankShowTemplate = DataCenter.DominatorTemplateManager:GetRankShowTemplateByIdAndRank(id, rank)
  if rankShowTemplate == nil then
    self.img_dominatorRank:SetEnable(false)
    return
  end
  self.img_dominatorRank:SetEnable(true)
  self.img_dominatorRank:LoadSpriteAsync(rankShowTemplate:GetRankIconPathSmall())
end

function UIHeroCellSmall:SetImgIcon(imgPath)
  if self.img_icon then
    self.img_icon:LoadSpriteAuto(imgPath)
  end
end

UIHeroCellSmall.OnCreate = OnCreate
UIHeroCellSmall.OnDestroy = OnDestroy
UIHeroCellSmall.OnEnable = OnEnable
UIHeroCellSmall.OnDisable = OnDisable
UIHeroCellSmall.ComponentDefine = ComponentDefine
UIHeroCellSmall.ComponentDestroy = ComponentDestroy
UIHeroCellSmall.DataDefine = DataDefine
UIHeroCellSmall.DataDestroy = DataDestroy
UIHeroCellSmall.GetLastStarPos = GetLastStarPos
UIHeroCellSmall.ShowUpgradeStarEffect = ShowUpgradeStarEffect
UIHeroCellSmall.Reinit = Reinit
UIHeroCellSmall.SetData = SetData
UIHeroCellSmall.SetHeroData = SetHeroData
UIHeroCellSmall.ToggleRayCast = ToggleRayCast
UIHeroCellSmall.SetHeroStationSkill = SetHeroStationSkill
UIHeroCellSmall.CheckInStation = CheckInStation
UIHeroCellSmall.InitWithConfigId = InitWithConfigId
UIHeroCellSmall.InitWithConfigIdByPoster = InitWithConfigIdByPoster
UIHeroCellSmall.SetQuality = SetQuality
UIHeroCellSmall.SetRank = SetRank
UIHeroCellSmall.SetDisplayLevel = SetDisplayLevel
UIHeroCellSmall.OnBtnClick = OnBtnClick
UIHeroCellSmall.SetLvTextBiggest = SetLvTextBiggest
UIHeroCellSmall.ToggleLevel = ToggleLevel
UIHeroCellSmall.ToggleRank = ToggleRank
UIHeroCellSmall.SetStarActive = SetStarActive
UIHeroCellSmall.SetCampActive = SetCampActive
UIHeroCellSmall.ShowStarProgress = ShowStarProgress
UIHeroCellSmall.SetMask = SetMask
UIHeroCellSmall.SetSelected = SetSelected
UIHeroCellSmall.GetSelected = GetSelected
UIHeroCellSmall.SetAllImageGrey = SetAllImageGrey
return UIHeroCellSmall
