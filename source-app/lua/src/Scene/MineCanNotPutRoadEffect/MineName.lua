local MineName = BaseClass("MineName")

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
  self.name_text = self.transform:Find("NameText"):GetComponent(typeof(CS.SuperTextMesh))
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

local function ReInit(self, pointIndex, nameStr)
  self.pointIndex = pointIndex
  self.name_text.text = nameStr
  self:UpdatePosition(self.pointIndex)
end

local function UpdatePosition(self, index)
  local pos = SceneUtils.TileIndexToWorld(index)
  pos.y = self.transform.position.y
  self.transform.position = pos
end

MineName.OnCreate = OnCreate
MineName.OnDestroy = OnDestroy
MineName.ComponentDefine = ComponentDefine
MineName.ComponentDestroy = ComponentDestroy
MineName.DataDefine = DataDefine
MineName.DataDestroy = DataDestroy
MineName.ReInit = ReInit
MineName.UpdatePosition = UpdatePosition
return MineName
