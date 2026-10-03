local RocketLandingScene = BaseClass("RocketLandingScene")
local rotation_go_path = "O_hjzl_sn_01_ui/A_hjzl_sn_camera01_ui (1)"
local RotateState = {
  None = 0,
  Left = 1,
  Right = 2
}
local RotationOffset = 20
local MaxRotate = 296
local MinRotate = 245
local DragMoveRotate = 0.05

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
  self.rotation_go = self.transform:Find(rotation_go_path).transform
end

local function ComponentDestroy(self)
  self.rotation_go = nil
end

local function DataDefine(self)
  self.rotateY = 0
  self.rotateState = 0
  self.lastDragPosX = 0
end

local function DataDestroy(self)
  self.rotateY = nil
  self.rotateState = nil
  self.lastDragPosX = nil
end

local function ReInit(self)
  self.rotateY = self.rotation_go.localRotation.eulerAngles.y
end

local function Rotate(self, offset)
  local y = self.rotateY + offset
  if y <= MaxRotate and y >= MinRotate then
    self.rotateY = y
    self.rotation_go.localRotation = Quaternion.Euler(0, y, 0)
  end
end

local function OnBeginDrag(self, eventData)
  self.lastDragPosX = eventData.position.x
end

local function OnDrag(self, eventData)
  local currentPosX = eventData.position.x
  local offset = (self.lastDragPosX - currentPosX) * DragMoveRotate
  self.lastDragPosX = currentPosX
  self:Rotate(offset)
end

local function StartRotateModel(self, isLeft)
  self.rotateState = isLeft and RotateState.Left or RotateState.Right
end

local function StopRotateModel(self)
  self.rotateState = RotateState.None
end

local function Update(self)
  if self.rotateState == RotateState.None then
    return
  end
  local offset = Time.deltaTime * (self.rotateState == RotateState.Right and RotationOffset or -RotationOffset)
  self:Rotate(offset)
end

RocketLandingScene.OnCreate = OnCreate
RocketLandingScene.OnDestroy = OnDestroy
RocketLandingScene.ComponentDefine = ComponentDefine
RocketLandingScene.ComponentDestroy = ComponentDestroy
RocketLandingScene.DataDefine = DataDefine
RocketLandingScene.DataDestroy = DataDestroy
RocketLandingScene.ReInit = ReInit
RocketLandingScene.Rotate = Rotate
RocketLandingScene.OnBeginDrag = OnBeginDrag
RocketLandingScene.OnDrag = OnDrag
RocketLandingScene.StartRotateModel = StartRotateModel
RocketLandingScene.StopRotateModel = StopRotateModel
RocketLandingScene.Update = Update
return RocketLandingScene
