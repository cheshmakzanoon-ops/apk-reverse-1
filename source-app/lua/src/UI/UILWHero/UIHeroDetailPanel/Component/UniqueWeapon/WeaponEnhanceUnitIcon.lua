local base = UIBaseContainer
local WeaponEnhanceUnitIcon = BaseClass("WeaponEnhanceUnitIcon", base)
local btn_path = ""
local bg_path = "bg"
local img_path = "icon"
local lv_txt_path = "lv_txt"
local red_point_path = "red"
local SELECTED_BG_PATH = "Assets/Main/Sprites/UI/UILWHeroDetail/FX_zhuanwu_btn_xuanzhong.png"
local UNSELECTED_BG_PATH = "Assets/Main/Sprites/UI/UILWHeroDetail/FX_zhuanwu_btn_weixuanzhong.png"
local UNSELECTED_ICON_PATHS = {
  [HeroUWEnhanceUnitType.Weapon] = "Assets/Main/Sprites/UI/UILWHeroDetail/FX_zhuanwu_btn_weixuanzhong_paotou.png",
  [HeroUWEnhanceUnitType.Energy] = "Assets/Main/Sprites/UI/UILWHeroDetail/FX_zhuanwu_btn_weixuanzhong_xuhang.png",
  [HeroUWEnhanceUnitType.Armor] = "Assets/Main/Sprites/UI/UILWHeroDetail/FX_zhuanwu_btn_weixuanzhong_hujia.png"
}
local SELECTED_ICON_PATHS = {
  [HeroUWEnhanceUnitType.Weapon] = "Assets/Main/Sprites/UI/UILWHeroDetail/FX_zhuanwu_btn_xuanzhong_paotou.png",
  [HeroUWEnhanceUnitType.Energy] = "Assets/Main/Sprites/UI/UILWHeroDetail/FX_zhuanwu_btn_xuanzhong_xuhang.png",
  [HeroUWEnhanceUnitType.Armor] = "Assets/Main/Sprites/UI/UILWHeroDetail/FX_zhuanwu_btn_xuanzhong_hujia.png"
}
local LOCK_ICON_PATH = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_tubiao_suo.png"
local UNLOCK_EFFECT_PATH = "Assets/_Art_LastWar/Effect/Prefab/UI/2025/Eff_UI_enhance/Eff_UI_enhance_Unlook_001.prefab"

local function OnCreate(self, unitType)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.unitType = unitType
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
  self.effect:Stop()
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.img = self:AddComponent(UIImage, img_path)
  self.lv_txt = self:AddComponent(UIText, lv_txt_path)
  self.red_point = self:AddComponent(UIBaseContainer, red_point_path)
  self.btn:SetOnClick(function()
    if self.clickCallback then
      self.clickCallback(self.unitType)
    end
  end)
  self.effectParam = {}
  self.effect = self:AddComponent(UIVfx, "", nil, self.effectParam)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.bg = nil
  self.img = nil
  self.lv_txt = nil
  self.red_point = nil
end

local function DataDefine(self)
  self.isSelected = false
  self.level = 0
end

local function DataDestroy(self)
end

local function SetSelected(self, selected)
  self.isSelected = selected
  self:RefreshIcon()
end

local function RefreshIcon(self)
  local selected = self.isSelected
  self.bg:LoadSprite(selected and SELECTED_BG_PATH or UNSELECTED_BG_PATH)
  self.bg:SetNativeSize()
  local heroData = self.heroData
  if not heroData then
    return
  end
  local curLv = heroData:GetUWUnitLv(self.unitType)
  self.cur_unit_lv = curLv
  if curLv == 0 then
    local canUpgrade, hasEnough = heroData:CanUpgradeForUWUnit(self.unitType)
    if not canUpgrade then
      self.img:LoadSprite(LOCK_ICON_PATH)
      self.img:SetSizeDeltaXY(37.2, 48)
      self.isLocked = true
      return
    end
  end
  if self.isLocked then
    self:PlayUnlockEffect()
    self.isLocked = false
  end
  self.img:LoadSprite(selected and SELECTED_ICON_PATHS[self.unitType] or UNSELECTED_ICON_PATHS[self.unitType])
  self.img:SetNativeSize()
end

local function GetAttributes(self)
  local heroData = self.heroData
  if not heroData then
    return nil
  end
  local curLv = heroData:GetUWUnitLv(self.unitType)
  local isMaxLv = heroData:IsUWUnitMaxLv(self.unitType)
  local allAttr, allValue, selfAttr, selfValue = heroData:GetUniqueWeaponEnhanceAttr(self.unitType, curLv)
  local attrInfo = {
    allAttr = allAttr,
    allValue = allValue,
    selfAttr = selfAttr,
    selfValue = selfValue
  }
  if not isMaxLv then
    local nextLv = curLv + 1
    local nextAllAttr, nextAllValue, nextSelfAttr, nextSelfValue = heroData:GetUniqueWeaponEnhanceAttr(self.unitType, nextLv)
    attrInfo.nextAllValue = nextAllValue - allValue
    attrInfo.nextSelfValue = nextSelfValue - selfValue
    local nextUnlockLv, nextUnlockValue = heroData:GetNextUnlockSelfAttr(self.unitType, curLv)
    if 0 < nextUnlockLv then
      attrInfo.nextUnlockLv = nextUnlockLv
      attrInfo.nextUnlockValue = nextUnlockValue
    end
  end
  return attrInfo
end

function WeaponEnhanceUnitIcon:GetUpgradeInfo()
  local heroData = self.heroData
  if not heroData then
    return nil
  end
  return heroData:GetUnitUpgradeInfo(self.unitType)
end

function WeaponEnhanceUnitIcon:GetUpgradeCost()
  local heroData = self.heroData
  if not heroData then
    return nil
  end
  return heroData:GetUnitUpgradeCost(self.unitType)
end

function WeaponEnhanceUnitIcon:GetUpgradeCondition()
  local heroData = self.heroData
  if not heroData then
    return nil
  end
  local upgradeInfo = heroData:GetUnitUpgradeInfo(self.unitType)
  if not upgradeInfo then
    return nil
  end
  return upgradeInfo.unitCondition
end

function WeaponEnhanceUnitIcon:SetHeroData(heroData)
  self.heroData = heroData
  self:RefreshIcon()
  self:RefreshLv()
  self:RefreshRedPoint()
end

function WeaponEnhanceUnitIcon:SetUnitType(unitType)
  self.unitType = unitType
end

function WeaponEnhanceUnitIcon:GetUnitType()
  return self.unitType
end

function WeaponEnhanceUnitIcon:SetClickCallback(callback)
  self.clickCallback = callback
end

function WeaponEnhanceUnitIcon:RefreshLv()
  self.lv_txt:SetText(string.format("Lv.%d", self.heroData:GetUWUnitLv(self.unitType)))
end

function WeaponEnhanceUnitIcon:OnHeroUWUnitUpdate(data)
  local uuid = self.heroData.uuid
  if uuid ~= data.uuid then
    return
  end
  self:RefreshLv()
  self:RefreshIcon()
  self:RefreshRedPoint()
end

function WeaponEnhanceUnitIcon:RefreshRedPoint()
  self.red_point:SetActive(self.heroData:CanShowUWEnhanceRedPointForUnit(self.unitType))
end

function WeaponEnhanceUnitIcon:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.RefreshRedPoint)
  self:AddUIListener(EventId.HeroUWEnhanceUnitUpgrade, self.OnHeroUWUnitUpdate)
end

function WeaponEnhanceUnitIcon:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshRedPoint)
  self:RemoveUIListener(EventId.HeroUWEnhanceUnitUpgrade, self.OnHeroUWUnitUpdate)
end

function WeaponEnhanceUnitIcon:PlayUnlockEffect()
  self.effect:Stop()
  self.effectParam.duration = 1
  self.effectParam.onRemove = nil
  self.effect:Play(UNLOCK_EFFECT_PATH, self.effectParam)
end

WeaponEnhanceUnitIcon.OnCreate = OnCreate
WeaponEnhanceUnitIcon.OnDestroy = OnDestroy
WeaponEnhanceUnitIcon.OnEnable = OnEnable
WeaponEnhanceUnitIcon.OnDisable = OnDisable
WeaponEnhanceUnitIcon.ComponentDefine = ComponentDefine
WeaponEnhanceUnitIcon.ComponentDestroy = ComponentDestroy
WeaponEnhanceUnitIcon.DataDefine = DataDefine
WeaponEnhanceUnitIcon.DataDestroy = DataDestroy
WeaponEnhanceUnitIcon.SetSelected = SetSelected
WeaponEnhanceUnitIcon.GetAttributes = GetAttributes
WeaponEnhanceUnitIcon.RefreshIcon = RefreshIcon
return WeaponEnhanceUnitIcon
