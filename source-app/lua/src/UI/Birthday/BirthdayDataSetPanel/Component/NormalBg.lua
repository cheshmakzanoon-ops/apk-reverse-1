local NormalBg = BaseClass("NormalBg", UIBaseContainer)
local base = UIBaseContainer

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

local function ComponentDefine(self)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetData(self, month, day, sznType)
end

local function SetIdelAni(self)
end

local function SetChangeAni(self)
end

NormalBg.OnCreate = OnCreate
NormalBg.OnDestroy = OnDestroy
NormalBg.ComponentDefine = ComponentDefine
NormalBg.ComponentDestroy = ComponentDestroy
NormalBg.DataDefine = DataDefine
NormalBg.DataDestroy = DataDestroy
NormalBg.SetData = SetData
NormalBg.SetIdelAni = SetIdelAni
NormalBg.SetChangeAni = SetChangeAni
return NormalBg
