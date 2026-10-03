local BuildConnectEffect = BaseClass("BuildConnectEffect")
local HeightPositionDelta = Vector3.New(0, 1, 0)

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
  self.curPosition = nil
end

local function DataDestroy(self)
  self.param = nil
  self.curPosition = nil
end

local function ReInit(self, param)
  self.param = param
  self:ShowPanel()
end

local function ShowPanel(self)
  self.gameObject.transform.position = BuildingUtils.GetBuildModelCenterVec(self.param.posIndex, self.param.tileX, self.param.tileY) + HeightPositionDelta + Vector3.New(0, self.param.modelHeight, 0)
end

BuildConnectEffect.OnCreate = OnCreate
BuildConnectEffect.OnDestroy = OnDestroy
BuildConnectEffect.ComponentDefine = ComponentDefine
BuildConnectEffect.ComponentDestroy = ComponentDestroy
BuildConnectEffect.DataDefine = DataDefine
BuildConnectEffect.DataDestroy = DataDestroy
BuildConnectEffect.ReInit = ReInit
BuildConnectEffect.ShowPanel = ShowPanel
return BuildConnectEffect
