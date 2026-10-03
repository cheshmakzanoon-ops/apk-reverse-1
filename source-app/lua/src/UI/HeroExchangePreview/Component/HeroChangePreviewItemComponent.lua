local HeroChangePreviewItemComponent = BaseClass("HeroChangePreviewItemComponent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local hero_head_area_path = "HeroHeadArea"
local hero_unique_weapon_area_path = "HeroUniqueWeaponArea"
local hero_skill_area_path = "HeroSkillArea"
local hero_honor_wall_area_path = "HeroHonorWallArea"
local HeroHeadInfo = require("UI.HeroExchangePreview.Component.HeroHeadAreaComponent")
local UniqueWeapon = require("UI.HeroExchangePreview.Component.HeroUniqueWeaponAreaComponent")
local HeroSkill = require("UI.HeroExchangePreview.Component.HeroSkillAreaComponent")
local HonorWall = require("UI.HeroExchangePreview.Component.HeroHonorWallAreaComponent")

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
  self.heroBaseInfo = self:AddComponent(HeroHeadInfo, hero_head_area_path)
  self.uniqueWeaponInfo = self:AddComponent(UniqueWeapon, hero_unique_weapon_area_path)
  self.skillInfo = self:AddComponent(HeroSkill, hero_skill_area_path)
  self.HonorWall = self:AddComponent(HonorWall, hero_honor_wall_area_path)
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

function HeroChangePreviewItemComponent:SetData(fromHeroData, toHeroData)
  self.fromHeroData = fromHeroData
  self.toHeroData = toHeroData
  self.heroBaseInfo:SetData(fromHeroData, toHeroData)
  self.uniqueWeaponInfo:SetData(fromHeroData, toHeroData)
  self.skillInfo:SetData(fromHeroData, toHeroData)
  self.HonorWall:SetData(fromHeroData, toHeroData)
end

HeroChangePreviewItemComponent.OnCreate = OnCreate
HeroChangePreviewItemComponent.OnDestroy = OnDestroy
HeroChangePreviewItemComponent.OnEnable = OnEnable
HeroChangePreviewItemComponent.OnDisable = OnDisable
HeroChangePreviewItemComponent.ComponentDefine = ComponentDefine
HeroChangePreviewItemComponent.ComponentDestroy = ComponentDestroy
HeroChangePreviewItemComponent.DataDefine = DataDefine
HeroChangePreviewItemComponent.DataDestroy = DataDestroy
HeroChangePreviewItemComponent.OnAddListener = OnAddListener
HeroChangePreviewItemComponent.OnRemoveListener = OnRemoveListener
return HeroChangePreviewItemComponent
