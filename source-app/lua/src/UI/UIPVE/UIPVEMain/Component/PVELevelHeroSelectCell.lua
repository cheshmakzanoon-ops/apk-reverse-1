local PVELevelHeroSelectCell = BaseClass("PVELevelHeroSelectCell", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCell = require("UI.UIHero2.Common.UIHeroCellSmall")
local hero_path = "UIHeroCellSmall"
local select_path = "selectObj"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.hero = self:AddComponent(UIHeroCell, hero_path)
  self.select_go = self:AddComponent(UIBaseContainer, select_path)
end

local function ComponentDestroy(self)
  self.hero = nil
  self.select_go = nil
end

local function DataDefine(self)
  self.onClick = nil
end

local function DataDestroy(self)
  self.onClick = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetData(self, data)
  self.data = data
  self.hero:SetData(data.uuid, function()
    self:OnClick()
  end)
end

local function SetOnClick(self, onClick)
  self.onClick = onClick
end

local function SetSelected(self, selected)
  self.select_go:SetActive(selected)
end

local function OnClick(self)
  if self.onClick then
    self.onClick()
  end
end

PVELevelHeroSelectCell.OnCreate = OnCreate
PVELevelHeroSelectCell.OnDestroy = OnDestroy
PVELevelHeroSelectCell.ComponentDefine = ComponentDefine
PVELevelHeroSelectCell.ComponentDestroy = ComponentDestroy
PVELevelHeroSelectCell.DataDefine = DataDefine
PVELevelHeroSelectCell.DataDestroy = DataDestroy
PVELevelHeroSelectCell.OnAddListener = OnAddListener
PVELevelHeroSelectCell.OnRemoveListener = OnRemoveListener
PVELevelHeroSelectCell.SetData = SetData
PVELevelHeroSelectCell.SetOnClick = SetOnClick
PVELevelHeroSelectCell.SetSelected = SetSelected
PVELevelHeroSelectCell.RefreshState = RefreshState
PVELevelHeroSelectCell.OnClick = OnClick
return PVELevelHeroSelectCell
