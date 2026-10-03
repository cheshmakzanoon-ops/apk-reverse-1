local BuildZoneSubEffect = BaseClass("BuildZoneSubEffect")

local function OnCreate(self, go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
end

local function ComponentDefine(self)
end

local function ComponentDestroy(self)
end

local function ReInit(self, param)
  self.param = param
end

BuildZoneSubEffect.OnCreate = OnCreate
BuildZoneSubEffect.OnDestroy = OnDestroy
BuildZoneSubEffect.ComponentDefine = ComponentDefine
BuildZoneSubEffect.ComponentDestroy = ComponentDestroy
BuildZoneSubEffect.ReInit = ReInit
return BuildZoneSubEffect
