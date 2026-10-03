local HeroHeadAreaComponent = BaseClass("HeroHeadAreaComponent", UIBaseContainer)
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local u_i_hero_cell_small_path = "UIHeroCellSmall"
local hero_name_text_path = "HeroNameText"

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
  self.headItem = self:AddComponent(UIHeroCellSmall, u_i_hero_cell_small_path)
  self.heroNameText = self:AddComponent(UIText, hero_name_text_path)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
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

function HeroHeadAreaComponent:SetData(fromHeroData, toHeroData)
  if not fromHeroData or not toHeroData then
    return
  end
  self.headItem:SetData(fromHeroData.uuid)
  self.headItem:SetRank(toHeroData:GetRank(), toHeroData.meta.maxRank)
  self.headItem:SetDisplayLevel(toHeroData.level)
  self.heroNameText:SetLocalText(fromHeroData.meta.name)
end

HeroHeadAreaComponent.OnCreate = OnCreate
HeroHeadAreaComponent.OnDestroy = OnDestroy
HeroHeadAreaComponent.OnEnable = OnEnable
HeroHeadAreaComponent.OnDisable = OnDisable
HeroHeadAreaComponent.ComponentDefine = ComponentDefine
HeroHeadAreaComponent.ComponentDestroy = ComponentDestroy
HeroHeadAreaComponent.DataDefine = DataDefine
HeroHeadAreaComponent.DataDestroy = DataDestroy
HeroHeadAreaComponent.OnAddListener = OnAddListener
HeroHeadAreaComponent.OnRemoveListener = OnRemoveListener
return HeroHeadAreaComponent
