local UILW3V3BattleResultTeamItem = BaseClass("UILW3V3BattleResultTeamItem", UIBaseContainer)
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
  end
  self.loseMask = self:AddComponent(UIBaseContainer, "loseMask")
  self.root = self:AddComponent(UIBaseContainer, "")
end

local function ComponentDestroy(self)
  self.heroItems = nil
  self.loseMask = nil
  self.root = nil
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

local function SetData(self, data)
  self.data = data
  local heroes = self.data.heroData
  for i = 1, 5 do
    if heroes and heroes[i] then
      local isSelfHero = DataCenter.HeroDataManager:GetHeroByUuid(heroes[i].heroUuid) ~= nil
      if isSelfHero then
        self.heroItems[i]:SetData(heroes[i].heroUuid)
      else
        self.heroItems[i]:InitWithConfigId(heroes[i].heroId, nil, heroes[i].heroLevel, heroes[i].rankLv, heroes[i].weaponLevel, heroes[i].awakenLv, heroes[i].heroSkinId)
      end
      self.heroItems[i]:SetActive(true)
    else
      self.heroItems[i]:SetActive(false)
    end
  end
  if self.data.dominatorData then
    self.heroItems[6]:SetActive(true)
    self.heroItems[6]:InitWithConfigId(self.data.dominatorData.heroId, nil, nil, self.data.dominatorData.rankLv)
  else
    self.heroItems[6]:SetActive(false)
  end
  self.loseMask:SetActive(not self.data.isWin)
  CS.UIGray.SetGray(self.root.transform, not self.data.isWin)
end

UILW3V3BattleResultTeamItem.OnCreate = OnCreate
UILW3V3BattleResultTeamItem.OnDestroy = OnDestroy
UILW3V3BattleResultTeamItem.ComponentDefine = ComponentDefine
UILW3V3BattleResultTeamItem.ComponentDestroy = ComponentDestroy
UILW3V3BattleResultTeamItem.DataDefine = DataDefine
UILW3V3BattleResultTeamItem.DataDestroy = DataDestroy
UILW3V3BattleResultTeamItem.OnEnable = OnEnable
UILW3V3BattleResultTeamItem.OnDisable = OnDisable
UILW3V3BattleResultTeamItem.SetData = SetData
return UILW3V3BattleResultTeamItem
