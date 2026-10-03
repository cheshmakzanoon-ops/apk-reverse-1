local GatherEffect = BaseClass("GatherEffect")

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
  if self.deleteTimer ~= nil then
    self.deleteTimer:Stop()
    self.deleteTimer = nil
  end
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function ReInit(self, index)
  if self.deleteTimer ~= nil then
    self.deleteTimer:Stop()
    self.deleteTimer = nil
  end
  self.index = index
  self.deleteTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.deleteTimer ~= nil then
      self.deleteTimer:Stop()
      self.deleteTimer = nil
    end
    EventManager:GetInstance():Broadcast(EventId.GatherEffectEnd, self.index)
  end, 3)
  self:UpdatePosition(index)
end

local function UpdatePosition(self, index)
  local worldPos = SceneUtils.TileIndexToWorld(index)
  self.transform.position = worldPos
  self.index = index
end

GatherEffect.OnCreate = OnCreate
GatherEffect.OnDestroy = OnDestroy
GatherEffect.ComponentDefine = ComponentDefine
GatherEffect.ComponentDestroy = ComponentDestroy
GatherEffect.DataDefine = DataDefine
GatherEffect.DataDestroy = DataDestroy
GatherEffect.ReInit = ReInit
GatherEffect.UpdatePosition = UpdatePosition
return GatherEffect
