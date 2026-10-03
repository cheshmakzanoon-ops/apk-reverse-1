local WorldDesertCityEffectScene = BaseClass("WorldDesertCityEffectScene")

function WorldDesertCityEffectScene:OnCreate(go)
  if go ~= nil then
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

function WorldDesertCityEffectScene:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
end

function WorldDesertCityEffectScene:ComponentDefine()
end

function WorldDesertCityEffectScene:ComponentDestroy()
  self.gameObject = nil
  self.transform = nil
end

function WorldDesertCityEffectScene:DataDefine()
  self.param = nil
  self.timer = nil
  
  function self.timer_action(temp)
    self:TimeCallBack()
  end
end

function WorldDesertCityEffectScene:DataDestroy()
  self.param = nil
  self:DeleteTimer()
end

function WorldDesertCityEffectScene:ReInit(param)
  self.param = param
  self.transform.position = self.param.pos
  self:AddTimer(self.param.time)
end

function WorldDesertCityEffectScene:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function WorldDesertCityEffectScene:AddTimer(time)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(time, self.timer_action, self, true, false, false)
  end
  self.timer:Start()
end

function WorldDesertCityEffectScene:TimeCallBack()
  self:DeleteTimer()
  EventManager:GetInstance():Broadcast(EventId.GuideTimelineMarker, GuideTimeLineShowMarkerType.End)
end

return WorldDesertCityEffectScene
