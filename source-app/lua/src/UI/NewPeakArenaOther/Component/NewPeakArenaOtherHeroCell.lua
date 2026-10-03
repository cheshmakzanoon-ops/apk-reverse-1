local NewPeakArenaOtherHeroCell = BaseClass("NewPeakArenaOtherHeroCell", UIBaseContainer)
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
  for i = 1, ArmyFormationSlot.Dominator do
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

local function SetData(self, heroes, powerStr)
  for i = 1, ArmyFormationSlot.Dominator do
    if heroes and heroes[i] then
      local isSelfHero = DataCenter.HeroDataManager:GetHeroByUuid(heroes[i].heroUuid) ~= nil
      if isSelfHero then
        self.heroItems[i]:SetData(heroes[i].heroUuid)
      else
        local dominatorInfo = DataCenter.DominatorManager:GetInfoByUuid(heroes[i].heroUuid)
        local isSelfDominator = dominatorInfo ~= nil
        if isSelfDominator then
          self.heroItems[i]:InitWithConfigId(dominatorInfo.dominatorId, nil, nil, dominatorInfo:GetCurRankLv())
        else
          self.heroItems[i]:InitWithConfigId(heroes[i].heroId, nil, heroes[i].heroLevel, heroes[i].rankLv, heroes[i].weaponLevel, heroes[i].awakenLv, heroes[i].heroSkinId)
        end
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
end

NewPeakArenaOtherHeroCell.OnCreate = OnCreate
NewPeakArenaOtherHeroCell.OnDestroy = OnDestroy
NewPeakArenaOtherHeroCell.ComponentDefine = ComponentDefine
NewPeakArenaOtherHeroCell.ComponentDestroy = ComponentDestroy
NewPeakArenaOtherHeroCell.DataDefine = DataDefine
NewPeakArenaOtherHeroCell.DataDestroy = DataDestroy
NewPeakArenaOtherHeroCell.OnEnable = OnEnable
NewPeakArenaOtherHeroCell.OnDisable = OnDisable
NewPeakArenaOtherHeroCell.SetData = SetData
NewPeakArenaOtherHeroCell.ResetShowState = ResetShowState
NewPeakArenaOtherHeroCell.SetGray = SetGray
return NewPeakArenaOtherHeroCell
