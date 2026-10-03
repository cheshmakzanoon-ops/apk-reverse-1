local ShowAirDropScene = BaseClass("ShowAirDropScene")

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
end

local function DataDestroy(self)
end

local function ReInit(self, param)
end

ShowAirDropScene.OnCreate = OnCreate
ShowAirDropScene.OnDestroy = OnDestroy
ShowAirDropScene.ComponentDefine = ComponentDefine
ShowAirDropScene.ComponentDestroy = ComponentDestroy
ShowAirDropScene.DataDefine = DataDefine
ShowAirDropScene.DataDestroy = DataDestroy
ShowAirDropScene.ReInit = ReInit
return ShowAirDropScene
