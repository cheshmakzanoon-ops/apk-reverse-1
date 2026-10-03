local BuildConnectRoadEffect = BaseClass("BuildConnectRoadEffect")
local HeightPositionDelta = Vector3.New(0, 0.15, 0)
local NormalScale = Vector3.New(1, 1, 1)
local UnNormalScale = Vector3.New(-1, 1, 1)

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
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param)
  self.param = param
  self:ShowPanel()
end

local function ShowPanel(self)
  local t = SceneUtils.TileIndexToWorld(self.param.posIndex)
  t = t + HeightPositionDelta
  self.gameObject.transform:Set_position(t.x, t.y, t.z)
  if self.param.dir == ConnectDirection.TopToDown then
    self.gameObject.transform:Set_localEulerAngles(0, 180, 0)
  elseif self.param.dir == ConnectDirection.DownToTop then
    self.gameObject.transform:Set_localEulerAngles(0, 0, 0)
  elseif self.param.dir == ConnectDirection.RightToLeft then
    self.gameObject.transform:Set_localEulerAngles(0, -90, 0)
  elseif self.param.dir == ConnectDirection.LeftToRight then
    self.gameObject.transform:Set_localEulerAngles(0, 90, 0)
  elseif self.param.dir == ConnectDirection.TopToLeft then
    self.gameObject.transform:Set_localEulerAngles(0, -90, 0)
    self.gameObject.transform:Set_localScale(NormalScale.x, NormalScale.y, NormalScale.z)
  elseif self.param.dir == ConnectDirection.TopToRight then
    self.gameObject.transform:Set_localEulerAngles(0, 90, 0)
    self.gameObject.transform:Set_localScale(UnNormalScale.x, UnNormalScale.y, UnNormalScale.z)
  elseif self.param.dir == ConnectDirection.DownToLeft then
    self.gameObject.transform:Set_localEulerAngles(0, -90, 0)
    self.gameObject.transform:Set_localScale(UnNormalScale.x, UnNormalScale.y, UnNormalScale.z)
  elseif self.param.dir == ConnectDirection.DownToRight then
    self.gameObject.transform:Set_localEulerAngles(0, 90, 0)
    self.gameObject.transform:Set_localScale(NormalScale.x, NormalScale.y, NormalScale.z)
  elseif self.param.dir == ConnectDirection.RightToTop then
    self.gameObject.transform:Set_localEulerAngles(0, 0, 0)
    self.gameObject.transform:Set_localScale(NormalScale.x, NormalScale.y, NormalScale.z)
  elseif self.param.dir == ConnectDirection.RightToDown then
    self.gameObject.transform:Set_localEulerAngles(0, 180, 0)
    self.gameObject.transform:Set_localScale(UnNormalScale.x, UnNormalScale.y, UnNormalScale.z)
  elseif self.param.dir == ConnectDirection.LeftToTop then
    self.gameObject.transform:Set_localEulerAngles(0, 0, 0)
    self.gameObject.transform:Set_localScale(UnNormalScale.x, UnNormalScale.y, UnNormalScale.z)
  elseif self.param.dir == ConnectDirection.LeftToDown then
    self.gameObject.transform:Set_localEulerAngles(0, 180, 0)
    self.gameObject.transform:Set_localScale(NormalScale.x, NormalScale.y, NormalScale.z)
  elseif self.param.dir == ConnectDirection.Down then
    self.gameObject.transform:Set_localEulerAngles(0, 180, 0)
  elseif self.param.dir == ConnectDirection.Top then
    self.gameObject.transform:Set_localEulerAngles(0, 0, 0)
  elseif self.param.dir == ConnectDirection.Left then
    self.gameObject.transform:Set_localEulerAngles(0, -90, 0)
  elseif self.param.dir == ConnectDirection.Right then
    self.gameObject.transform:Set_localEulerAngles(0, 90, 0)
  end
end

BuildConnectRoadEffect.OnCreate = OnCreate
BuildConnectRoadEffect.OnDestroy = OnDestroy
BuildConnectRoadEffect.ComponentDefine = ComponentDefine
BuildConnectRoadEffect.ComponentDestroy = ComponentDestroy
BuildConnectRoadEffect.DataDefine = DataDefine
BuildConnectRoadEffect.DataDestroy = DataDestroy
BuildConnectRoadEffect.ReInit = ReInit
BuildConnectRoadEffect.ShowPanel = ShowPanel
return BuildConnectRoadEffect
