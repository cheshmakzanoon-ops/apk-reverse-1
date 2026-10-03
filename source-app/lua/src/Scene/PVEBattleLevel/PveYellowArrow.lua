local PveYellowArrow = BaseClass("PveYellowArrow")

local function OnCreate(self, go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
end

local function ComponentDefine(self)
end

local function ComponentDestroy(self)
  self.gameObject = nil
  self.transform = nil
end

local function DataDefine(self)
  self.param = nil
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param)
  self.param = param
  self.transform.position = self.param.position
end

local function SetVisible(self, visible)
  self.gameObject:SetActive(visible)
end

PveYellowArrow.OnCreate = OnCreate
PveYellowArrow.OnDestroy = OnDestroy
PveYellowArrow.ComponentDefine = ComponentDefine
PveYellowArrow.ComponentDestroy = ComponentDestroy
PveYellowArrow.DataDefine = DataDefine
PveYellowArrow.DataDestroy = DataDestroy
PveYellowArrow.ReInit = ReInit
PveYellowArrow.SetVisible = SetVisible
return PveYellowArrow
