local MineCanNotPutRoadEffect = BaseClass("MineCanNotPutRoadEffect")

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

MineCanNotPutRoadEffect.OnCreate = OnCreate
MineCanNotPutRoadEffect.OnDestroy = OnDestroy
MineCanNotPutRoadEffect.ComponentDefine = ComponentDefine
MineCanNotPutRoadEffect.ComponentDestroy = ComponentDestroy
MineCanNotPutRoadEffect.DataDefine = DataDefine
MineCanNotPutRoadEffect.DataDestroy = DataDestroy
MineCanNotPutRoadEffect.ReInit = ReInit
MineCanNotPutRoadEffect.UpdatePosition = UpdatePosition
return MineCanNotPutRoadEffect
