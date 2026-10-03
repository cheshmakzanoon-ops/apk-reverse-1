local BuildCancelEffect = BaseClass("BuildCancelEffect")
local PositionDelta = Vector3.New(0, 0, 0)

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
  self:ShowPanel()
end

local function ShowPanel(self)
  self.transform.position = SceneUtils.TileIndexToWorld(self.param.posIndex) + PositionDelta
end

BuildCancelEffect.OnCreate = OnCreate
BuildCancelEffect.OnDestroy = OnDestroy
BuildCancelEffect.ComponentDefine = ComponentDefine
BuildCancelEffect.ComponentDestroy = ComponentDestroy
BuildCancelEffect.DataDefine = DataDefine
BuildCancelEffect.DataDestroy = DataDestroy
BuildCancelEffect.ReInit = ReInit
BuildCancelEffect.ShowPanel = ShowPanel
return BuildCancelEffect
