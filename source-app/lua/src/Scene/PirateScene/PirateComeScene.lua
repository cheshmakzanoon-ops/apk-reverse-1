local PirateComeScene = BaseClass("PirateComeScene")

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

PirateComeScene.OnCreate = OnCreate
PirateComeScene.OnDestroy = OnDestroy
PirateComeScene.ComponentDefine = ComponentDefine
PirateComeScene.ComponentDestroy = ComponentDestroy
PirateComeScene.DataDefine = DataDefine
PirateComeScene.DataDestroy = DataDestroy
PirateComeScene.ReInit = ReInit
return PirateComeScene
