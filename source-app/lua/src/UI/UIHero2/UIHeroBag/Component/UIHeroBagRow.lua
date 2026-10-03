local UIHeroBagRow = BaseClass("UIHeroBagRow", UIBaseContainer)
local base = UIBaseContainer
local UIHeroBagCell = require("UI.UIHero2.UIHeroBag.Component.UIHeroBagCell")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.cellObjList = {}
  for k = 1, HeroBagCellNumPerLine do
    local cell = self:AddComponent(UIHeroBagCell, "Cell" .. k)
    table.insert(self.cellObjList, cell)
  end
end

local function ComponentDestroy(self)
  self.cellObjList = nil
end

local function SetData(self, lineData, index, clickFunc)
  self.index = index
  for k, cell in ipairs(self.cellObjList) do
    local cellData = lineData[k]
    cell:SetActive(cellData ~= nil)
    if cellData ~= nil then
      cell:SetData(cellData, clickFunc)
    end
  end
end

UIHeroBagRow.OnCreate = OnCreate
UIHeroBagRow.OnDestroy = OnDestroy
UIHeroBagRow.ComponentDefine = ComponentDefine
UIHeroBagRow.ComponentDestroy = ComponentDestroy
UIHeroBagRow.SetData = SetData
return UIHeroBagRow
