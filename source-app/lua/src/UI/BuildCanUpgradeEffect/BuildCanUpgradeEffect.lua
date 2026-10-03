local BuildCanUpgradeEffect = BaseClass("BuildCanUpgradeEffect")

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
  self.transform = nil
  self.gameObject = nil
end

local function DataDefine(self)
  self.param = nil
  self.index = nil
end

local function DataDestroy(self)
  self.param = nil
  self.index = nil
end

local function ReInit(self, param)
  self.param = param
  if self.param.posIndex ~= nil then
    self:UpdatePosition(self.param.posIndex)
  end
end

local function UpdatePosition(self, index)
  if self.index ~= index then
    self.index = index
    self.transform.position = BuildingUtils.GetBuildModelDownVec(index, 0, self.param.tileY)
  end
end

BuildCanUpgradeEffect.OnCreate = OnCreate
BuildCanUpgradeEffect.OnDestroy = OnDestroy
BuildCanUpgradeEffect.ComponentDefine = ComponentDefine
BuildCanUpgradeEffect.ComponentDestroy = ComponentDestroy
BuildCanUpgradeEffect.DataDefine = DataDefine
BuildCanUpgradeEffect.DataDestroy = DataDestroy
BuildCanUpgradeEffect.ReInit = ReInit
BuildCanUpgradeEffect.UpdatePosition = UpdatePosition
return BuildCanUpgradeEffect
