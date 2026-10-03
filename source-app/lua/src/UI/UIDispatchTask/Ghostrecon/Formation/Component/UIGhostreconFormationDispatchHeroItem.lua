local base = UIBaseContainer
local UIGhostreconFormationDispatchHeroItem = BaseClass("UIGhostreconFormationDispatchHeroItem", base)
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local joinIcon_path = "JoinIcon"
local heroCell_path = "HeroCell"

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
  self.joinIcon = self:AddComponent(UIBaseContainer, joinIcon_path)
  self.heroCell = self:AddComponent(UIHeroCellSmall, heroCell_path)
end

local function ComponentDestroy(self)
  self.joinIcon = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetEmpty(self)
  self.heroCell:SetActive(false)
end

local function SetData(self, heroId, clickFunc)
  if heroId then
    self.heroCell:SetData(heroId, clickFunc)
    self.heroCell:SetActive(true)
  else
    self.heroCell:SetActive(false)
  end
end

UIGhostreconFormationDispatchHeroItem.OnCreate = OnCreate
UIGhostreconFormationDispatchHeroItem.OnDestroy = OnDestroy
UIGhostreconFormationDispatchHeroItem.OnEnable = OnEnable
UIGhostreconFormationDispatchHeroItem.OnDisable = OnDisable
UIGhostreconFormationDispatchHeroItem.ComponentDefine = ComponentDefine
UIGhostreconFormationDispatchHeroItem.ComponentDestroy = ComponentDestroy
UIGhostreconFormationDispatchHeroItem.DataDefine = DataDefine
UIGhostreconFormationDispatchHeroItem.DataDestroy = DataDestroy
UIGhostreconFormationDispatchHeroItem.SetEmpty = SetEmpty
UIGhostreconFormationDispatchHeroItem.SetData = SetData
return UIGhostreconFormationDispatchHeroItem
