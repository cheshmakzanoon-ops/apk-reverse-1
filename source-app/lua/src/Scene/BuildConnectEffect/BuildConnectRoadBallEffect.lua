local BuildConnectRoadBallEffect = BaseClass("BuildConnectRoadBallEffect")

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
  self.AutoBuildConnectEffectBallMove = self.gameObject:GetComponent(typeof(CS.AutoBuildConnectEffectBallMove))
end

local function ComponentDestroy(self)
  self.AutoBuildConnectEffectBallMove = nil
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
  self.AutoBuildConnectEffectBallMove:Init(self.param.path, self.param.perMoveTime, self.param.startIndex)
end

BuildConnectRoadBallEffect.OnCreate = OnCreate
BuildConnectRoadBallEffect.OnDestroy = OnDestroy
BuildConnectRoadBallEffect.ComponentDefine = ComponentDefine
BuildConnectRoadBallEffect.ComponentDestroy = ComponentDestroy
BuildConnectRoadBallEffect.DataDefine = DataDefine
BuildConnectRoadBallEffect.DataDestroy = DataDestroy
BuildConnectRoadBallEffect.ReInit = ReInit
BuildConnectRoadBallEffect.ShowPanel = ShowPanel
return BuildConnectRoadBallEffect
