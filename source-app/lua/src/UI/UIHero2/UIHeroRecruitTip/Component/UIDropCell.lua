local UIDropCell = BaseClass("UIDropCell", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCell = require("UI.UIHero2.Common.UIHeroCellSmall")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.heroCell = self:AddComponent(UIHeroCell, "UIHeroCellSmall")
end

local function ComponentDestroy(self)
  self.heroCell = nil
end

local function SetData(self, heroConfigId)
  self.heroCell:InitWithConfigId(heroConfigId)
end

UIDropCell.OnCreate = OnCreate
UIDropCell.OnDestroy = OnDestroy
UIDropCell.ComponentDefine = ComponentDefine
UIDropCell.ComponentDestroy = ComponentDestroy
UIDropCell.SetData = SetData
return UIDropCell
