local UIHeroCell = require("UI.UIHero2.Common.UIHeroCellSmall")
local ChatHeroItem = BaseClass("ChatHeroItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local hero_path = "UIHeroCellSmall"
local empty_path = "Image"

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
  self.heroBase = self:AddComponent(UIHeroCell, hero_path)
  self.empty_obj = self:AddComponent(UIBaseContainer, empty_path)
end

local function ComponentDestroy(self)
  self.heroBase = nil
  self.empty_obj = nil
end

local function DataDefine(self)
  self.param = {}
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, heroData)
  self.heroData = heroData
  if heroData ~= nil then
    self.heroBase:SetActive(true)
    local rarity = GetTableData(HeroUtils.GetHeroXmlName(), self.heroData.heroId, "rarity")
    local isWakeUp = HeroUtils.GetIsWakeUp(rarity, self.heroData.skillList)
    self.heroBase:InitWithConfigId(self.heroData.heroId, self.heroData.quality, self.heroData.heroLv, nil, nil, self.heroData.rankId, isWakeUp)
  else
    self.heroBase:SetActive(false)
  end
end

ChatHeroItem.OnCreate = OnCreate
ChatHeroItem.OnDestroy = OnDestroy
ChatHeroItem.OnEnable = OnEnable
ChatHeroItem.OnDisable = OnDisable
ChatHeroItem.ComponentDefine = ComponentDefine
ChatHeroItem.ComponentDestroy = ComponentDestroy
ChatHeroItem.DataDefine = DataDefine
ChatHeroItem.DataDestroy = DataDestroy
ChatHeroItem.ReInit = ReInit
return ChatHeroItem
