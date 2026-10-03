local ConnectElectricityScene = BaseClass("ConnectElectricityScene")
local CloseTime = 4.3

function ConnectElectricityScene:OnCreate(go)
  if go ~= nil then
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

function ConnectElectricityScene:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
end

function ConnectElectricityScene:ComponentDefine()
end

function ConnectElectricityScene:ComponentDestroy()
  self.gameObject = nil
  self.transform = nil
end

function ConnectElectricityScene:DataDefine()
  self.param = nil
  self.timer = nil
  
  function self.timer_action(temp)
    self:TimeCallBack()
  end
end

function ConnectElectricityScene:DataDestroy()
  self.param = nil
  self:DeleteTimer()
end

function ConnectElectricityScene:ReInit(param)
  self.param = param
  self.transform.position = SceneUtils.TileToWorld(DataCenter.BuildManager.main_city_pos)
end

function ConnectElectricityScene:ChangeParam(param)
  self:ReInit(param)
end

function ConnectElectricityScene:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function ConnectElectricityScene:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(CloseTime, self.timer_action, self, true, false, false)
  end
  self.timer:Start()
end

function ConnectElectricityScene:TimeCallBack()
  self:DeleteTimer()
  EventManager:GetInstance():Broadcast(EventId.GuideTimelineMarker, GuideTimeLineShowMarkerType.End)
end

return ConnectElectricityScene
