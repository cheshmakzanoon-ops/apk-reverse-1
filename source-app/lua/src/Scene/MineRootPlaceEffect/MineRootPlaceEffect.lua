local MineRootPlaceEffect = BaseClass("MineRootPlaceEffect")

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
  self.pointIndex = nil
end

local function DataDestroy(self)
  self.pointIndex = nil
end

local function ReInit(self, pointIndex)
  self.pointIndex = pointIndex
  self:UpdatePosition(self.pointIndex)
end

local function UpdatePosition(self, index)
  local pos = SceneUtils.TileIndexToWorld(index)
  pos.y = self.transform.position.y
  self.transform.position = pos
end

MineRootPlaceEffect.OnCreate = OnCreate
MineRootPlaceEffect.OnDestroy = OnDestroy
MineRootPlaceEffect.ComponentDefine = ComponentDefine
MineRootPlaceEffect.ComponentDestroy = ComponentDestroy
MineRootPlaceEffect.DataDefine = DataDefine
MineRootPlaceEffect.DataDestroy = DataDestroy
MineRootPlaceEffect.ReInit = ReInit
MineRootPlaceEffect.UpdatePosition = UpdatePosition
return MineRootPlaceEffect
