local HeroUniqueWeaponAreaComponent = BaseClass("HeroUniqueWeaponAreaComponent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local level_info_path = "LevelInfo"
local unique_weapon_lv_text_path = "LevelInfo/UniqueWeaponLvText"
local unique_weapon_lock_area_path = "UniqueWeaponLockArea"
local weapon_lock_tips_text_path = "UniqueWeaponLockArea/WeaponLockTipsText"
local not_exist_unique_weapon_area_path = "NotExistUniqueWeaponArea"

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
  self.levelInfoObj = self:AddComponent(UIBaseContainer, level_info_path)
  self.uniqueWeaponLvText = self:AddComponent(UIText, unique_weapon_lv_text_path)
  self.uniqueWeaponLockAreaObj = self:AddComponent(UIBaseContainer, unique_weapon_lock_area_path)
  self.uniqueWeaponLockTipText = self:AddComponent(UIText, weapon_lock_tips_text_path)
  self.uniqueWeaponNoExistObj = self:AddComponent(UIBaseContainer, not_exist_unique_weapon_area_path)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function HeroUniqueWeaponAreaComponent:SetData(fromHeroData, toHeroData)
  if not fromHeroData or not toHeroData then
    return
  end
  self.levelInfoObj:SetActive(false)
  self.uniqueWeaponLockAreaObj:SetActive(false)
  self.uniqueWeaponNoExistObj:SetActive(false)
  local isUnlockUniqueWeaponLv = fromHeroData:IsUniqueWeaponOpen() and fromHeroData:GetUniqueWeaponLv() > 0
  if not isUnlockUniqueWeaponLv and not fromHeroData:IsUniqueWeaponLockState() then
    self.uniqueWeaponNoExistObj:SetActive(true)
    return
  end
  local starAfterExchange = toHeroData.rank
  local showNeedRankId = LuaEntry.DataConfig:TryGetNum("hero_unique_weapon", "k3", 0)
  if starAfterExchange < showNeedRankId then
    self.uniqueWeaponLockAreaObj:SetActive(true)
    return
  end
  self.levelInfoObj:SetActive(true)
  local showWeaponLv = 0
  if fromHeroData:IsUniqueWeaponLockState() then
    showWeaponLv = fromHeroData:GetUniqueWeaponRealLv() or 0
  else
    showWeaponLv = fromHeroData:GetUniqueWeaponLv() or 0
  end
  self.uniqueWeaponLvText:SetText(showWeaponLv)
end

HeroUniqueWeaponAreaComponent.OnCreate = OnCreate
HeroUniqueWeaponAreaComponent.OnDestroy = OnDestroy
HeroUniqueWeaponAreaComponent.OnEnable = OnEnable
HeroUniqueWeaponAreaComponent.OnDisable = OnDisable
HeroUniqueWeaponAreaComponent.ComponentDefine = ComponentDefine
HeroUniqueWeaponAreaComponent.ComponentDestroy = ComponentDestroy
HeroUniqueWeaponAreaComponent.DataDefine = DataDefine
HeroUniqueWeaponAreaComponent.DataDestroy = DataDestroy
HeroUniqueWeaponAreaComponent.OnAddListener = OnAddListener
HeroUniqueWeaponAreaComponent.OnRemoveListener = OnRemoveListener
return HeroUniqueWeaponAreaComponent
