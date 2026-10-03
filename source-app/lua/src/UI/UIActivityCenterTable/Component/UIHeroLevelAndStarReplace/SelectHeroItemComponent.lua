local SelectHeroItemComponent = BaseClass("SelectHeroItemComponent", UIBaseContainer)
local LWHeroRankStar = require("UI.UIHero2.Common.LWHeroRankStar")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local un_select_content_path = "UnSelectContent"
local select_content_path = "SelectContent"
local hero_name_text_path = "SelectContent/HeroNameText"
local select_avatar_content_path = "SelectContent/Mask/SelectAvatarContent"
local cancel_btn_path = "SelectContent/CancelBtn"
local unique_weapon_lock_tip_area_path = "SelectContent/UniqueWeaponLockTipArea"
local select_hero_btn1_path = "UnSelectContent/SelectHeroBtn1"
local select_hero_btn2_path = "SelectContent/SelectHeroBtn2"
local hero_rank_star_path = "SelectContent/StarInfo/HeroRankStar"
local type_icon_path = "SelectContent/LvInfo/TypeIcon"
local lv_text_path = "SelectContent/LvInfo/LvText"
local select_eff_point_path = "SelectContent/SelectEffPoint"
local exchange_success_eff_point_path = "SelectContent/ExchangeSuccessEffPoint"
local b_g_path = "BG"
local selectEffPrefabPath = "Assets/_Art_LastWar/Effect/Prefab/UI/2025/Eff_UI_ActHeroLevelAndStarReplace/Eff_UIActHeroLevelAndStarReplace_Get_slot.prefab"
local changeSuccessEffPrefabPath = "Assets/_Art_LastWar/Effect/Prefab/UI/2025/Eff_UI_ActHeroLevelAndStarReplace/Eff_UIActHeroLevelAndStarReplace_Change_Slot.prefab"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.unSelectHeroContentObj = self:AddComponent(UIBaseContainer, un_select_content_path)
  self.selectedHeroContentObj = self:AddComponent(UIBaseContainer, select_content_path)
  self.heroNameText = self:AddComponent(UIText, hero_name_text_path)
  self.avatarPointObj = self:AddComponent(UIBaseContainer, select_avatar_content_path)
  self.removeHeroBtn = self:AddComponent(UIButton, cancel_btn_path)
  self.removeHeroBtn:SetOnClick(function()
    self:CancelSelectHero()
  end)
  self.uniqueWeaponLockaTipObj = self:AddComponent(UIBaseContainer, unique_weapon_lock_tip_area_path)
  self.openSelectHeroPanelBtn1 = self:AddComponent(UIButton, select_hero_btn1_path)
  self.openSelectHeroPanelBtn1:SetOnClick(function()
    self:OpenSelectHeroPanel()
  end)
  self.openSelectHeroPanelBtn2 = self:AddComponent(UIButton, select_hero_btn2_path)
  self.openSelectHeroPanelBtn2:SetOnClick(function()
    self:OpenSelectHeroPanel()
  end)
  self.hero_rank_star = self:AddComponent(LWHeroRankStar, hero_rank_star_path)
  self.typeIcon = self:AddComponent(UIImage, type_icon_path)
  self.lvText = self:AddComponent(UIText, lv_text_path)
  self.selectEff = self:AddComponent(UIVfx, select_eff_point_path, selectEffPrefabPath, {
    lifeType = UIVfxLifeType.HideAfterOnce
  })
  self.exchangeSuccessEff = self:AddComponent(UIVfx, exchange_success_eff_point_path, changeSuccessEffPrefabPath, {
    lifeType = UIVfxLifeType.HideAfterOnce
  })
  self.bgObj = self:AddComponent(UIBaseContainer, b_g_path)
end

local function ComponentDestroy(self)
  if self.spineLoader ~= nil then
    self.spineLoader:Destroy()
    self.spineLoader = nil
  end
  if self.showSelectEffTimer then
    self.showSelectEffTimer:Stop()
    self.showSelectEffTimer = nil
  end
end

local function DataDefine(self)
  self.side = nil
  self.prevLv = nil
  self.prevRank = nil
end

local function DataDestroy(self)
  self.side = nil
  self.prevLv = nil
  self.prevRank = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function SelectHeroItemComponent:Init(side)
  self.side = side
  if side == HeroReplaceSlotSide.Left then
    self.bgObj.rectTransform:Set_localPosition(-7, -7, 0)
  else
    self.bgObj.rectTransform:Set_localPosition(7, -7, 0)
  end
end

function SelectHeroItemComponent:ShowHeroData(heroUuid)
  self.heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
  if not self.heroData then
    return
  end
  self:ShowHeroInfo()
  self:ShowHeroDisplayEff()
end

function SelectHeroItemComponent:ShowHeroAfterChange()
  if self.heroData and self.prevLv and self.prevRank then
    local curLv = self.heroData.level
    local curRank = self.heroData:GetRank()
    if (curLv > self.prevLv or curRank > self.prevRank) and self.exchangeSuccessEff then
      self.exchangeSuccessEff:Replay()
    end
  end
  self:RefreshHeroLvAndRankInfo()
end

function SelectHeroItemComponent:ShowHeroInfo()
  if not self.heroData then
    self:SetEmptyState()
    return
  end
  self.removeHeroBtn:SetActive(true)
  self.heroNameText:SetLocalText(self.heroData.meta.name)
  self.typeIcon:LoadSpriteAuto(HeroUtils.GetHeroTypeIcon(self.heroData.heroType, self.heroData:IsUniqueWeaponOpen() and self.heroData:HasUniqueWeapon()))
  self:SetShowHeroInfoState()
  self:RefreshHeroLvAndRankInfo()
  self:LoadHeroSpine()
end

function SelectHeroItemComponent:RefreshHeroLvAndRankInfo()
  self.lvText:SetText("Lv." .. self.heroData.level)
  self:ShowHeroRank()
  self.prevLv = self.heroData.level
  self.prevRank = self.heroData:GetRank()
end

function SelectHeroItemComponent:ShowHeroDisplayEff()
  if self.showSelectEffTimer then
    self.showSelectEffTimer:Stop()
    self.showSelectEffTimer = nil
  end
  self.showSelectEffTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.selectEff then
      self.selectEff:Replay()
    end
  end, 0.2)
end

function SelectHeroItemComponent:LoadHeroSpine()
  if not self.heroData then
    return
  end
  local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(self.heroData.modelId)
  local spinePath = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_path")
  if self.spineLoader ~= nil then
    self.spineLoader:Destroy()
    self.spineLoader = nil
  end
  local request = ResourceManager:InstantiateAsync(spinePath)
  self.spineLoader = request
  request:completed("+", function()
    if request.isError or request.gameObject == nil then
      self.heroSpineLoadRequest[self.heroData.uuid] = nil
      return
    end
    self:ResetSpineTransform(request.gameObject, self.heroData.modelId)
  end)
end

function SelectHeroItemComponent:ResetSpineTransform(obj, modelId)
  if not obj then
    return
  end
  if not self.avatarPointObj then
    return
  end
  obj:SetActive(true)
  local rectTransform = obj:GetComponent(typeof(CS.UnityEngine.RectTransform))
  if rectTransform ~= nil then
    local spineScale = Vector3.one
    local spinePos = Vector3.zero
    local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(modelId)
    spineScale = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_skill_scale")
    spinePos = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_skill_pos")
    rectTransform:SetParent(self.avatarPointObj.transform)
    rectTransform:Set_localScale(spineScale, spineScale, 1)
    rectTransform:Set_anchoredPosition(spinePos[1], spinePos[2], 0)
  end
end

function SelectHeroItemComponent:SetShowHeroInfoState()
  self.unSelectHeroContentObj:SetActive(false)
  self.selectedHeroContentObj:SetActive(true)
end

function SelectHeroItemComponent:SetEmptyState()
  self.unSelectHeroContentObj:SetActive(true)
  self.selectedHeroContentObj:SetActive(false)
end

function SelectHeroItemComponent:CancelSelectHero()
  if not self.holder then
    return
  end
  self.holder:CancelSelectHero(self.side)
end

function SelectHeroItemComponent:OpenSelectHeroPanel()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonHeroList, 2, self.side, self.holder:GetAllNeedExcludeHero(), HeroListCardType.ShowHeroRank)
end

function SelectHeroItemComponent:ShowHeroRank()
  if not self.heroData then
    self.hero_rank_star:SetActive(false)
    return
  end
  if self.heroData:GetRank() == nil then
    self.hero_rank_star:SetActive(false)
  else
    self.hero_rank_star:SetActive(true)
    if self.heroData and self.heroData.meta then
      self.hero_rank_star:ShowRank(self.heroData:GetRank(), self.heroData.meta.maxRank)
    end
  end
end

function SelectHeroItemComponent:OnStartExchange()
  self.removeHeroBtn:SetActive(false)
end

SelectHeroItemComponent.OnCreate = OnCreate
SelectHeroItemComponent.OnDestroy = OnDestroy
SelectHeroItemComponent.OnEnable = OnEnable
SelectHeroItemComponent.OnDisable = OnDisable
SelectHeroItemComponent.ComponentDefine = ComponentDefine
SelectHeroItemComponent.ComponentDestroy = ComponentDestroy
SelectHeroItemComponent.DataDefine = DataDefine
SelectHeroItemComponent.DataDestroy = DataDestroy
SelectHeroItemComponent.OnAddListener = OnAddListener
SelectHeroItemComponent.OnRemoveListener = OnRemoveListener
return SelectHeroItemComponent
