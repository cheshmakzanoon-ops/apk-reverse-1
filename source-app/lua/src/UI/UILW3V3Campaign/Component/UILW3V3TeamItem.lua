local UILW3V3TeamItem = BaseClass("UILW3V3TeamItem", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCellBig = require("UI.UIHero2.Common.UIHeroCellBig")
local UIGray = CS.UIGray
local hero_path345 = "Hero%d"
local hero_path126 = "HeroLayout/Hero%d"

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

local function ComponentDefine(self)
  self.heroItems = {}
  self.herosCanvas = {}
  self.heroHps = {}
  for i = 1, 6 do
    local itemPath = hero_path345
    if i <= 2 or i == 6 then
      itemPath = hero_path126
    end
    local item = self:AddComponent(UIHeroCellBig, string.format(itemPath, i))
    item:DisableRedPoint()
    table.insert(self.heroItems, item)
    local canvas = self:AddComponent(UICanvasGroup, string.format(itemPath, i))
    table.insert(self.herosCanvas, canvas)
    local hp = self:TryAddComponent(UISlider, string.format(itemPath, i) .. "/Hp" .. i)
    table.insert(self.heroHps, hp)
  end
  self.power = self:AddComponent(UIBaseContainer, "Power")
  self.powerText = self:AddComponent(UIText, "Power/PowerText")
end

local function ComponentDestroy(self)
  self.heroItems = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ResetShowState(self)
  UIGray.SetGray(self.transform, false, false)
end

local function SetGray(self, gray)
  UIGray.SetGray(self.transform, gray, false)
end

local function SetData(self, heroes, powerStr, dominatorData)
  for i = 1, 5 do
    if heroes and heroes[i] then
      local heroUuid = heroes[i].heroUuid
      local isSelfHero = heroUuid and DataCenter.HeroDataManager:GetHeroByUuid(heroUuid) ~= nil
      if isSelfHero then
        self.heroItems[i]:SetData(heroUuid)
      else
        self.heroItems[i]:InitWithConfigId(heroes[i].heroId, nil, heroes[i].heroLevel, heroes[i].rankLv, heroes[i].weaponLevel, heroes[i].awakenLv, heroes[i].heroSkinId)
      end
      self.heroItems[i]:SetActive(true)
    else
      self.heroItems[i]:SetActive(false)
    end
  end
  self.heroes = heroes
  ResetShowState(self)
  if not string.IsNullOrEmpty(powerStr) then
    self.power:SetActive(true)
    self.powerText:SetText(powerStr)
  else
    self.power:SetActive(false)
  end
  if self.heroItems[6] then
    local hasDominator = dominatorData ~= nil and dominatorData.heroId ~= nil and dominatorData.rankLv ~= nil
    self.heroItems[6]:SetActive(hasDominator)
    if hasDominator then
      self.heroItems[6]:InitWithConfigId(dominatorData.heroId, nil, nil, dominatorData.rankLv)
    end
  end
  if #self.heroHps > 0 then
    for i = 1, 6 do
      if heroes and heroes[i] and heroes[i].hp and type(heroes[i].hp) == "number" then
        self.heroHps[i]:SetValue(heroes[i].hp)
      end
    end
  end
end

UILW3V3TeamItem.OnCreate = OnCreate
UILW3V3TeamItem.OnDestroy = OnDestroy
UILW3V3TeamItem.ComponentDefine = ComponentDefine
UILW3V3TeamItem.ComponentDestroy = ComponentDestroy
UILW3V3TeamItem.DataDefine = DataDefine
UILW3V3TeamItem.DataDestroy = DataDestroy
UILW3V3TeamItem.OnEnable = OnEnable
UILW3V3TeamItem.OnDisable = OnDisable
UILW3V3TeamItem.SetData = SetData
UILW3V3TeamItem.ResetShowState = ResetShowState
UILW3V3TeamItem.SetGray = SetGray
return UILW3V3TeamItem
