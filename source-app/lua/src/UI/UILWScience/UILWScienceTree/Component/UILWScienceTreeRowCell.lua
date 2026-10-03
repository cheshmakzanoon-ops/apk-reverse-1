local UILWRowCell = BaseClass("UILWRowCell", UIBaseContainer)
local base = UIBaseContainer
local Param = DataClass("Param", ParamData)
local ParamData = {
  index
}

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
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
  self.param = {}
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param)
  self.param = param
end

UILWRowCell.OnCreate = OnCreate
UILWRowCell.OnDestroy = OnDestroy
UILWRowCell.Param = Param
UILWRowCell.OnEnable = OnEnable
UILWRowCell.OnDisable = OnDisable
UILWRowCell.ComponentDefine = ComponentDefine
UILWRowCell.ComponentDestroy = ComponentDestroy
UILWRowCell.DataDefine = DataDefine
UILWRowCell.DataDestroy = DataDestroy
UILWRowCell.ReInit = ReInit
return UILWRowCell
