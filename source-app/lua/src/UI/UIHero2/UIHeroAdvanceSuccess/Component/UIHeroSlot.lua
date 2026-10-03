local UIHeroSlot = BaseClass("UIHeroSlot", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCell = require("UI.UIHero2.Common.UIHeroCellSmall")
local Localization = CS.GameEntry.Localization
local UIHeroStars = require("UI.UIHero2.Common.UIHeroStars")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self.parent = nil
  self.heroUuid = nil
  self.heroData = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.heroCell = self:AddComponent(UIHeroCell, "UIHeroCellSmall")
  self.heroCell:ToggleRayCast(false)
  self.btn = self:AddComponent(UIButton, "Close")
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.heroCell = nil
end

local function SetData(self, heroUuid, requireType, requireQuality)
  self.heroUuid = heroUuid
  self.requireType = requireType
  self.requireQuality = requireQuality
  self.heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
  self.heroCell:SetData(heroUuid)
  self.heroCell:SetCampActive(false)
end

local function SetParent(self, parent)
  self.parent = parent
end

local function OnBtnClick(self)
  if self.heroUuid ~= nil then
    self.parent:OnToggleDogFood(self.heroUuid)
    self.heroUuid = nil
  end
end

UIHeroSlot.OnCreate = OnCreate
UIHeroSlot.OnDestroy = OnDestroy
UIHeroSlot.OnEnable = OnEnable
UIHeroSlot.OnDisable = OnDisable
UIHeroSlot.ComponentDefine = ComponentDefine
UIHeroSlot.ComponentDestroy = ComponentDestroy
UIHeroSlot.SetData = SetData
UIHeroSlot.SetParent = SetParent
UIHeroSlot.OnBtnClick = OnBtnClick
return UIHeroSlot
