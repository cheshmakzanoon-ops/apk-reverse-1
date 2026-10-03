local UILWKOFDefenseTeamOrderItem = BaseClass("UILWKOFDefenseTeamOrderItem", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCellBig = require("UI.UIHero2.Common.UIHeroCellBig")
local UIGray = CS.UIGray
local hero_path = "HeroRoot/Hero%d"

function UILWKOFDefenseTeamOrderItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWKOFDefenseTeamOrderItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWKOFDefenseTeamOrderItem:ComponentDefine()
  self.heroItems = {}
  self.herosCanvas = {}
  for i = 1, 5 do
    local item = self:AddComponent(UIHeroCellBig, string.format(hero_path, i))
    item:DisableRedPoint()
    table.insert(self.heroItems, item)
    local canvas = self:AddComponent(UICanvasGroup, string.format(hero_path, i))
    table.insert(self.herosCanvas, canvas)
  end
  self.power = self:AddComponent(UIBaseContainer, "Power")
  self.powerText = self:AddComponent(UIText, "Power/PowerText")
end

function UILWKOFDefenseTeamOrderItem:ComponentDestroy()
  self.heroItems = nil
end

function UILWKOFDefenseTeamOrderItem:ResetShowState()
  UIGray.SetGray(self.transform, false, false)
end

function UILWKOFDefenseTeamOrderItem:SetGray(gray)
  UIGray.SetGray(self.transform, gray, false)
end

function UILWKOFDefenseTeamOrderItem:SetData(heroes, powerStr)
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
  self.heroes = heroes
  self:ResetShowState(self)
  if not string.IsNullOrEmpty(powerStr) then
    self.power:SetActive(true)
    self.powerText:SetText(powerStr)
  else
    self.power:SetActive(false)
  end
end

return UILWKOFDefenseTeamOrderItem
