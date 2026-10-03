local PirateAwayScene = BaseClass("PirateAwayScene")

local function OnCreate(self, go)
  if go ~= nil then
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
  self.transform.position = self.param.pos
end

PirateAwayScene.OnCreate = OnCreate
PirateAwayScene.OnDestroy = OnDestroy
PirateAwayScene.ComponentDefine = ComponentDefine
PirateAwayScene.ComponentDestroy = ComponentDestroy
PirateAwayScene.DataDefine = DataDefine
PirateAwayScene.DataDestroy = DataDestroy
PirateAwayScene.ReInit = ReInit
return PirateAwayScene
