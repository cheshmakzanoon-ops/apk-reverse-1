local base = require("UI.UILWHero.UIHeroSimpleTip.View.UIArrowTipBase")
local UIHeroPropertyDetailTipView = BaseClass("UIHeroPropertyDetailTipView", base)
local Localization = CS.GameEntry.Localization
local UIHeroPropertyCell = require("UI.UILWHero.UIHeroPropertyDetailTip.Component.UIHeroPropertyCell_hero")
local Screen = CS.UnityEngine.Screen
local cell_path = "PropertyItem"
local cell_content_path = "Root/ImgBg/Content/cells_content"
local main_prop_name_path = "Root/ImgBg/Content/PropertyMain/Name"
local main_prop_value_path = "Root/ImgBg/Content/PropertyMain/Value"

local function ComponentDefine(self)
  base.ComponentDefine(self)
  self.cells = {}
  self.cellPrefab = self.transform:Find(cell_path).gameObject
  self.cellPrefab:GameObjectCreatePool()
  self.cellContent = self:AddComponent(UIBaseContainer, cell_content_path)
  self.mainPropName = self:AddComponent(UIText, main_prop_name_path)
  self.mainPropValue = self:AddComponent(UIText, main_prop_value_path)
end

local function ComponentDestroy(self)
  self.descText = nil
  self.titleText = nil
  if self.cells ~= nil then
    self:ClearCell()
    self.cells = nil
  end
  self.imgArrow = nil
  self.root = nil
  self.cellPrefab = nil
  base.ComponentDestroy(self)
end

function UIHeroPropertyDetailTipView:RefreshShow()
  base.RefreshShow(self)
  self.mainPropName:SetText(self.param.mainPropName)
  self.mainPropValue:SetText(string.GetFormattedSeparatorNum(self.param.mainPropValue))
  self:ClearCell()
  if self.param.splitProp then
    local index = 0
    for k, v in pairs(self.param.splitProp) do
      local c = self.cellPrefab:GameObjectSpawn(self.cellContent.transform)
      table.insert(self.cells, c)
      NameCount = NameCount + 1
      c.name = tostring(NameCount)
      c.gameObject:SetActive(true)
      local cell = self.cellContent:AddComponent(UIHeroPropertyCell, c.name)
      cell:Refresh(v, index % 2 == 0)
      index = index + 1
    end
  end
end

local function ClearCell(self)
  if self.cells ~= nil then
    self.cellContent:RemoveComponents(UIHeroPropertyCell)
    self.cellPrefab:GameObjectRecycleAll()
    self.cells = {}
  end
end

UIHeroPropertyDetailTipView.ComponentDefine = ComponentDefine
UIHeroPropertyDetailTipView.ComponentDestroy = ComponentDestroy
UIHeroPropertyDetailTipView.ClearCell = ClearCell
return UIHeroPropertyDetailTipView
