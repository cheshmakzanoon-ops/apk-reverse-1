local FormationHeroItem = BaseClass("FormationHeroItem", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCell = require("UI.UIHero2.Common.UIHeroCellSmall")
local hero_path = "UIHeroCellSmall"
local empty_path = "Empty"
local empty_style2_path = "EmptyStyle2"

local function OnCreate(self)
  base.OnCreate(self)
  self.heroBase = self:AddComponent(UIHeroCell, hero_path)
  self.empty = self:TryAddComponent(UIImage, empty_path)
  if self.empty then
    self.empty:SetActive(true)
  end
  self.empty_style2 = self:TryAddComponent(UIImage, empty_style2_path)
  if self.empty_style2 then
    self.empty_style2:SetActive(false)
  end
end

local function OnDestroy(self)
  self.empty = nil
  self.empty_style2 = nil
  base.OnDestroy(self)
end

local function InitData(self, data)
  self.uuid = data
  if data then
    self.heroBase:SetActive(true)
    self.heroBase:SetData(self.uuid)
  else
    self.heroBase:SetActive(false)
  end
end

local function InitWithConfigId(self, heroConfigId, quality, level, rankId, weaponLevel, awakenLv, skinId)
  if heroConfigId then
    self.heroBase:SetActive(true)
    self.heroBase:InitWithConfigId(heroConfigId, quality, level, rankId, weaponLevel, awakenLv, skinId)
  else
    self.heroBase:SetActive(false)
  end
end

local function SetHeroEmptyState(self, useStyle2)
  if self.empty then
    self.empty:SetActive(not useStyle2)
  end
  if self.empty_style2 then
    self.empty_style2:SetActive(useStyle2)
  end
end

FormationHeroItem.OnCreate = OnCreate
FormationHeroItem.OnDestroy = OnDestroy
FormationHeroItem.InitData = InitData
FormationHeroItem.InitWithConfigId = InitWithConfigId
FormationHeroItem.SetHeroEmptyState = SetHeroEmptyState
return FormationHeroItem
