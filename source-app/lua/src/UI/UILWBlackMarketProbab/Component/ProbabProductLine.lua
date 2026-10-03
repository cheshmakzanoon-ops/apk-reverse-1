local base = UIBaseContainer
local ProbabProductLine = BaseClass("ProbabProductLine", base)
local ProbabProductItem = require("UI.UILWBlackMarketProbab.Component.ProbabProductItem")
local leftProduct_path = "leftProduct"
local rightProduct_path = "rightProduct"

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
  self.leftProduct = self:AddComponent(ProbabProductItem, leftProduct_path)
  self.rightProduct = self:AddComponent(ProbabProductItem, rightProduct_path)
end

local function ComponentDestroy(self)
  self.leftProduct = nil
  self.rightProduct = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetData(self, leftData, rightData)
  if not leftData then
    self.leftProduct:SetActive(false)
  else
    self.leftProduct:SetActive(true)
    self.leftProduct:SetData(leftData)
  end
  if not rightData then
    self.rightProduct:SetActive(false)
  else
    self.rightProduct:SetActive(true)
    self.rightProduct:SetData(rightData)
  end
end

ProbabProductLine.OnCreate = OnCreate
ProbabProductLine.OnDestroy = OnDestroy
ProbabProductLine.OnEnable = OnEnable
ProbabProductLine.OnDisable = OnDisable
ProbabProductLine.ComponentDefine = ComponentDefine
ProbabProductLine.ComponentDestroy = ComponentDestroy
ProbabProductLine.DataDefine = DataDefine
ProbabProductLine.DataDestroy = DataDestroy
ProbabProductLine.SetData = SetData
return ProbabProductLine
