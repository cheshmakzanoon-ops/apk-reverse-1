local UIHeroDetailPageToggle = BaseClass("UIHeroDetailPageToggle", UIBaseContainer)
local base = UIBaseContainer
local selectedBg_path = "selectedBg"
local txt_path = "txt"
local redPoint_path = "redPoint"
local up_level_path = "UpLevel"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function DataDefine(self)
  self.type = nil
  self.activeState = false
end

local function DataDestroy(self)
  self.type = nil
  self.activeState = false
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function OnClick(self)
  if self.view then
    self.view:GoToPage(self.type)
  end
end

local function ComponentDefine(self)
  self.selectedBg = self:AddComponent(UIImage, selectedBg_path)
  self.txt = self:AddComponent(UIText, txt_path)
  self.redPoint = self:AddComponent(UIImage, redPoint_path)
  self.toggle = self:AddComponent(UIButton, "")
  self.toggle:SetOnClick(BindCallback(self, OnClick))
  if self.up_level ~= nil then
    self.redPoint:SetActive(false)
  end
end

local function ComponentDestroy(self)
  self.btn = nil
  self.up_level = nil
end

local function OnGoodsUpdate(self)
  if not self:GetActive() then
    return
  end
  if self.type == HeroDetailPageType.HeroRank or self.type == HeroDetailPageType.HeroUniqueWeapon then
    self:RefershRedPoint()
  end
end

local function ResourceItemUpdate(self)
  if not self:GetActive() then
    return
  end
  if self.type == HeroDetailPageType.HeroGrowth then
    self:RefershRedPoint()
  end
end

local function OnHeroRankUpdate(self)
  if not self:GetActive() then
    return
  end
  if self.type == HeroDetailPageType.HeroRank or self.type == HeroDetailPageType.HeroUniqueWeapon then
    self:RefershRedPoint()
  end
end

local function OnHeroUgprade(self)
  if not self:GetActive() then
    return
  end
  if self.type == HeroDetailPageType.HeroGrowth then
    self:RefershRedPoint()
  end
end

local function OnHeroUniqueWeaponUpgrade(self)
  if not self:GetActive() then
    return
  end
  if self.type == HeroDetailPageType.HeroUniqueWeapon then
    self:RefershRedPoint()
  end
end

local function OnHeroAwakenUpgrade(self)
  if not self:GetActive() then
    return
  end
  if self.type == HeroDetailPageType.HeroAwaken then
    self:RefershRedPoint()
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, OnGoodsUpdate)
  self:AddUIListener(EventId.HeroUpgradeRank, OnHeroRankUpdate)
  self:AddUIListener(EventId.RefreshResourceItem, ResourceItemUpdate)
  self:AddUIListener(EventId.HeroLvUpSuccess, OnHeroUgprade)
  self:AddUIListener(EventId.HeroBeyondSuccess, OnHeroUgprade)
  self:AddUIListener(EventId.HeroUniqueWeaponUpgrade, OnHeroUniqueWeaponUpgrade)
  self:AddUIListener(EventId.OpenHeroUniqueWeapon, OnHeroUniqueWeaponUpgrade)
  self:AddUIListener(EventId.HeroUWEnhanceUnitUpgrade, OnHeroUniqueWeaponUpgrade)
  self:AddUIListener(EventId.HeroUWEnhanceUnlocked, OnHeroUniqueWeaponUpgrade)
  self:AddUIListener(EventId.OpenHeroAwakenPage, OnHeroAwakenUpgrade)
  self:AddUIListener(EventId.HeroAwakenUpgradeSuccess, OnHeroAwakenUpgrade)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshItems, OnGoodsUpdate)
  self:RemoveUIListener(EventId.HeroUpgradeRank, OnHeroRankUpdate)
  self:RemoveUIListener(EventId.RefreshResourceItem, ResourceItemUpdate)
  self:RemoveUIListener(EventId.HeroLvUpSuccess, OnHeroUgprade)
  self:RemoveUIListener(EventId.HeroBeyondSuccess, OnHeroUgprade)
  self:RemoveUIListener(EventId.HeroUniqueWeaponUpgrade, OnHeroUniqueWeaponUpgrade)
  self:RemoveUIListener(EventId.OpenHeroUniqueWeapon, OnHeroUniqueWeaponUpgrade)
  self:RemoveUIListener(EventId.HeroUWEnhanceUnitUpgrade, OnHeroUniqueWeaponUpgrade)
  self:RemoveUIListener(EventId.HeroUWEnhanceUnlocked, OnHeroUniqueWeaponUpgrade)
  self:RemoveUIListener(EventId.OpenHeroAwakenPage, OnHeroAwakenUpgrade)
  self:RemoveUIListener(EventId.HeroAwakenUpgradeSuccess, OnHeroAwakenUpgrade)
end

local function SetType(self, type)
  self.type = type
end

local function GetType(self)
  return self.type or 0
end

local function SetData(self, heroData)
  self.heroData = heroData
  self:RefershRedPoint()
end

local function SetSelected(self, activeState)
  self.selectedBg:SetActive(activeState)
end

local function SetShowRedPoint(self, state)
  if not self.heroData then
    self:RedPointVisibleImp(false)
    return
  end
  self:RedPointVisibleImp(state)
end

local function RefershRedPoint(self)
  if not self.type then
    self:RedPointVisibleImp(false)
  end
  local showRedPoint = false
  if not self.heroData then
    self:RedPointVisibleImp(false)
    return
  end
  if self.type == HeroDetailPageType.HeroGrowth then
    showRedPoint = HeroRedPointManager:GetInstance():CheckCanShowRedPoint(HeroRedPointType.HeroDetail_PropertyPage, self.heroData.uuid)
  elseif self.type == HeroDetailPageType.HeroSkill then
    showRedPoint = HeroRedPointManager:GetInstance():CheckCanShowRedPoint(HeroRedPointType.HeroDetail_SkillPage, self.heroData.uuid)
  elseif self.type == HeroDetailPageType.HeroRank then
    showRedPoint = self.heroData:CanUpMilitaryRank()
  elseif self.type == HeroDetailPageType.HeroUniqueWeapon then
    showRedPoint = HeroRedPointManager:GetInstance():CheckCanShowRedPoint(HeroRedPointType.HeroDetial_UniqueWeapon, self.heroData.uuid)
  elseif self.type == HeroDetailPageType.HeroAwaken then
    showRedPoint = HeroRedPointManager:GetInstance():CheckCanShowRedPoint(HeroRedPointType.HeroDetial_HeroAwaken, self.heroData.uuid)
  end
  self:RedPointVisibleImp(showRedPoint)
end

function UIHeroDetailPageToggle:RedPointVisibleImp(visible)
  if self.up_level ~= nil then
    self.up_level:SetActive(visible)
    return
  end
  self.redPoint:SetActive(visible)
end

UIHeroDetailPageToggle.OnCreate = OnCreate
UIHeroDetailPageToggle.OnDestroy = OnDestroy
UIHeroDetailPageToggle.OnEnable = OnEnable
UIHeroDetailPageToggle.OnDisable = OnDisable
UIHeroDetailPageToggle.DataDefine = DataDefine
UIHeroDetailPageToggle.DataDestroy = DataDestroy
UIHeroDetailPageToggle.ComponentDefine = ComponentDefine
UIHeroDetailPageToggle.ComponentDestroy = ComponentDestroy
UIHeroDetailPageToggle.SetSelected = SetSelected
UIHeroDetailPageToggle.OnAddListener = OnAddListener
UIHeroDetailPageToggle.OnRemoveListener = OnRemoveListener
UIHeroDetailPageToggle.SetType = SetType
UIHeroDetailPageToggle.GetType = GetType
UIHeroDetailPageToggle.SetData = SetData
UIHeroDetailPageToggle.RefershRedPoint = RefershRedPoint
UIHeroDetailPageToggle.SetShowRedPoint = SetShowRedPoint
return UIHeroDetailPageToggle
